From: akpm@linux-foundation.org
Subject: + maps4-add-proc-pid-pagemap-interface.patch added to -mm tree
Date: Mon, 29 Oct 2007 14:57:41 -0700
Message-ID: <200710292157.l9TLvfXH025366@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47569 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752535AbXJ2V6q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Oct 2007 17:58:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mpm@selenic.com, haveblue@us.ibm.com


The patch titled
     maps4: add /proc/pid/pagemap interface
has been added to the -mm tree.  Its filename is
     maps4-add-proc-pid-pagemap-interface.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: maps4: add /proc/pid/pagemap interface
From: Matt Mackall <mpm@selenic.com>

This interface provides a mapping for each page in an address space to its
physical page frame number, allowing precise determination of what pages are
mapped and what pages are shared between processes.

New in this version:

- headers gone again (as recommended by Dave Hansen and Alan Cox)
- 64-bit entries (as per discussion with Andi Kleen)
- swap pte information exported (from Dave Hansen)
- page walker callback for holes (from Dave Hansen)
- direct put_user I/O (as suggested by Rusty Russell)

This patch folds in cleanups and swap PTE support from Dave Hansen
<haveblue@us.ibm.com>.

Signed-off-by: Matt Mackall <mpm@selenic.com>
Cc: Dave Hansen <haveblue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c     |    4 
 fs/proc/internal.h |    2 
 fs/proc/task_mmu.c |  199 ++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 203 insertions(+), 2 deletions(-)

diff -puN fs/proc/base.c~maps4-add-proc-pid-pagemap-interface fs/proc/base.c
--- a/fs/proc/base.c~maps4-add-proc-pid-pagemap-interface
+++ a/fs/proc/base.c
@@ -692,7 +692,7 @@ out_no_task:
 }
 #endif
 
-static loff_t mem_lseek(struct file * file, loff_t offset, int orig)
+loff_t mem_lseek(struct file *file, loff_t offset, int orig)
 {
 	switch (orig) {
 	case 0:
@@ -2160,6 +2160,7 @@ static const struct pid_entry tgid_base_
 #ifdef CONFIG_MMU
 	REG("clear_refs", S_IWUSR, clear_refs),
 	REG("smaps",      S_IRUGO, smaps),
+	REG("pagemap",    S_IRUSR, pagemap),
 #endif
 #ifdef CONFIG_SECURITY
 	DIR("attr",       S_IRUGO|S_IXUGO, attr_dir),
@@ -2483,6 +2484,7 @@ static const struct pid_entry tid_base_s
 #ifdef CONFIG_MMU
 	REG("clear_refs", S_IWUSR, clear_refs),
 	REG("smaps",     S_IRUGO, smaps),
+	REG("pagemap",    S_IRUSR, pagemap),
 #endif
 #ifdef CONFIG_SECURITY
 	DIR("attr",      S_IRUGO|S_IXUGO, attr_dir),
diff -puN fs/proc/internal.h~maps4-add-proc-pid-pagemap-interface fs/proc/internal.h
--- a/fs/proc/internal.h~maps4-add-proc-pid-pagemap-interface
+++ a/fs/proc/internal.h
@@ -50,11 +50,13 @@ extern int proc_tid_stat(struct task_str
 extern int proc_tgid_stat(struct task_struct *, char *);
 extern int proc_pid_status(struct task_struct *, char *);
 extern int proc_pid_statm(struct task_struct *, char *);
+extern loff_t mem_lseek(struct file *file, loff_t offset, int orig);
 
 extern const struct file_operations proc_maps_operations;
 extern const struct file_operations proc_numa_maps_operations;
 extern const struct file_operations proc_smaps_operations;
 extern const struct file_operations proc_clear_refs_operations;
+extern const struct file_operations proc_pagemap_operations;
 
 void free_proc_entry(struct proc_dir_entry *de);
 
diff -puN fs/proc/task_mmu.c~maps4-add-proc-pid-pagemap-interface fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~maps4-add-proc-pid-pagemap-interface
+++ a/fs/proc/task_mmu.c
@@ -5,7 +5,10 @@
 #include <linux/highmem.h>
 #include <linux/ptrace.h>
 #include <linux/pagemap.h>
+#include <linux/ptrace.h>
 #include <linux/mempolicy.h>
+#include <linux/swap.h>
+#include <linux/swapops.h>
 
 #include <asm/elf.h>
 #include <asm/uaccess.h>
@@ -520,6 +523,201 @@ const struct file_operations proc_clear_
 	.write		= clear_refs_write,
 };
 
+struct pagemapread {
+	char __user *out, *end;
+};
+
+#define PM_ENTRY_BYTES sizeof(u64)
+#define PM_RESERVED_BITS    3
+#define PM_RESERVED_OFFSET  (64 - PM_RESERVED_BITS)
+#define PM_RESERVED_MASK    (((1LL<<PM_RESERVED_BITS)-1) << PM_RESERVED_OFFSET)
+#define PM_SPECIAL(nr)      (((nr) << PM_RESERVED_OFFSET) | PM_RESERVED_MASK)
+#define PM_NOT_PRESENT      PM_SPECIAL(1LL)
+#define PM_SWAP             PM_SPECIAL(2LL)
+#define PM_END_OF_BUFFER    1
+
+static int add_to_pagemap(unsigned long addr, u64 pfn,
+			  struct pagemapread *pm)
+{
+	/*
+	 * Make sure there's room in the buffer for an
+	 * entire entry.  Otherwise, only copy part of
+	 * the pfn.
+	 */
+	if (pm->out + PM_ENTRY_BYTES >= pm->end) {
+		if (copy_to_user(pm->out, &pfn, pm->end - pm->out))
+			return -EFAULT;
+		pm->out = pm->end;
+		return PM_END_OF_BUFFER;
+	}
+
+	if (put_user(pfn, pm->out))
+		return -EFAULT;
+	pm->out += PM_ENTRY_BYTES;
+	return 0;
+}
+
+static int pagemap_pte_hole(unsigned long start, unsigned long end,
+				void *private)
+{
+	struct pagemapread *pm = private;
+	unsigned long addr;
+	int err = 0;
+	for (addr = start; addr < end; addr += PAGE_SIZE) {
+		err = add_to_pagemap(addr, PM_NOT_PRESENT, pm);
+		if (err)
+			break;
+	}
+	return err;
+}
+
+u64 swap_pte_to_pagemap_entry(pte_t pte)
+{
+	swp_entry_t e = pte_to_swp_entry(pte);
+	return PM_SWAP | swp_type(e) | (swp_offset(e) << MAX_SWAPFILES_SHIFT);
+}
+
+static int pagemap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
+			     void *private)
+{
+	struct pagemapread *pm = private;
+	pte_t *pte;
+	int err = 0;
+
+	pte = pte_offset_map(pmd, addr);
+	for (; addr != end; pte++, addr += PAGE_SIZE) {
+		u64 pfn = PM_NOT_PRESENT;
+		if (is_swap_pte(*pte))
+			pfn = swap_pte_to_pagemap_entry(*pte);
+		else if (pte_present(*pte))
+			pfn = pte_pfn(*pte);
+		err = add_to_pagemap(addr, pfn, pm);
+		if (err)
+			return err;
+	}
+	pte_unmap(pte - 1);
+
+	cond_resched();
+
+	return err;
+}
+
+static struct mm_walk pagemap_walk = {
+	.pmd_entry = pagemap_pte_range,
+	.pte_hole = pagemap_pte_hole
+};
+
+/*
+ * /proc/pid/pagemap - an array mapping virtual pages to pfns
+ *
+ * For each page in the address space, this file contains one 64-bit
+ * entry representing the corresponding physical page frame number
+ * (PFN) if the page is present. If there is a swap entry for the
+ * physical page, then an encoding of the swap file number and the
+ * page's offset into the swap file are returned. If no page is
+ * present at all, PM_NOT_PRESENT is returned. This allows determining
+ * precisely which pages are mapped (or in swap) and comparing mapped
+ * pages between processes.
+ *
+ * Efficient users of this interface will use /proc/pid/maps to
+ * determine which areas of memory are actually mapped and llseek to
+ * skip over unmapped regions.
+ */
+static ssize_t pagemap_read(struct file *file, char __user *buf,
+			    size_t count, loff_t *ppos)
+{
+	struct task_struct *task = get_proc_task(file->f_path.dentry->d_inode);
+	struct page **pages, *page;
+	unsigned long uaddr, uend;
+	struct mm_struct *mm;
+	struct pagemapread pm;
+	int pagecount;
+	int ret = -ESRCH;
+
+	if (!task)
+		goto out;
+
+	ret = -EACCES;
+	if (!ptrace_may_attach(task))
+		goto out;
+
+	ret = -EINVAL;
+	/* file position must be aligned */
+	if (*ppos % PM_ENTRY_BYTES)
+		goto out;
+
+	ret = 0;
+	mm = get_task_mm(task);
+	if (!mm)
+		goto out;
+
+	ret = -ENOMEM;
+	uaddr = (unsigned long)buf & PAGE_MASK;
+	uend = (unsigned long)(buf + count);
+	pagecount = (PAGE_ALIGN(uend) - uaddr) / PAGE_SIZE;
+	pages = kmalloc(pagecount * sizeof(struct page *), GFP_KERNEL);
+	if (!pages)
+		goto out_task;
+
+	down_read(&current->mm->mmap_sem);
+	ret = get_user_pages(current, current->mm, uaddr, pagecount,
+			     1, 0, pages, NULL);
+	up_read(&current->mm->mmap_sem);
+
+	if (ret < 0)
+		goto out_free;
+
+	pm.out = buf;
+	pm.end = buf + count;
+
+	if (!ptrace_may_attach(task)) {
+		ret = -EIO;
+	} else {
+		unsigned long src = *ppos;
+		unsigned long svpfn = src / PM_ENTRY_BYTES;
+		unsigned long start_vaddr = svpfn << PAGE_SHIFT;
+		unsigned long end_vaddr = TASK_SIZE_OF(task);
+
+		/* watch out for wraparound */
+		if (svpfn > TASK_SIZE_OF(task) >> PAGE_SHIFT)
+			start_vaddr = end_vaddr;
+
+		/*
+		 * The odds are that this will stop walking way
+		 * before end_vaddr, because the length of the
+		 * user buffer is tracked in "pm", and the walk
+		 * will stop when we hit the end of the buffer.
+		 */
+		ret = walk_page_range(mm, start_vaddr, end_vaddr,
+					&pagemap_walk, &pm);
+		if (ret == PM_END_OF_BUFFER)
+			ret = 0;
+		/* don't need mmap_sem for these, but this looks cleaner */
+		*ppos += pm.out - buf;
+		if (!ret)
+			ret = pm.out - buf;
+	}
+
+	for (; pagecount; pagecount--) {
+		page = pages[pagecount-1];
+		if (!PageReserved(page))
+			SetPageDirty(page);
+		page_cache_release(page);
+	}
+	mmput(mm);
+out_free:
+	kfree(pages);
+out_task:
+	put_task_struct(task);
+out:
+	return ret;
+}
+
+const struct file_operations proc_pagemap_operations = {
+	.llseek		= mem_lseek, /* borrow this */
+	.read		= pagemap_read,
+};
+
 #ifdef CONFIG_NUMA
 extern int show_numa_map(struct seq_file *m, void *v);
 
@@ -553,4 +751,3 @@ const struct file_operations proc_numa_m
 	.release	= seq_release_private,
 };
 #endif
-
_

Patches currently in -mm which might be from mpm@selenic.com are

maps4-add-proportional-set-size-accounting-in-smaps.patch
maps4-from-dave-hansen-haveblue-usibmcom.patch
maps4-move-is_swap_pte.patch
maps4-introduce-a-generic-page-walker.patch
maps4-use-pagewalker-in-clear_refs-and-smaps.patch
maps4-simplify-interdependence-of-maps-and-smaps.patch
maps4-move-clear_refs-code-to-task_mmuc.patch
maps4-regroup-task_mmu-by-interface.patch
maps4-add-proc-pid-pagemap-interface.patch
maps4-add-proc-kpagecount-interface.patch
maps4-add-proc-kpageflags-interface.patch
maps4-make-page-monitoring-proc-file-optional.patch
