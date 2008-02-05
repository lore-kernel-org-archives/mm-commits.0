From: akpm@linux-foundation.org
Subject: - maps4-add-proc-pid-pagemap-interface.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:31:16 -0800
Message-ID: <200802052230.m15MUvof012119@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56331 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762600AbYBEWmR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:42:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mpm@selenic.com, haveblue@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     maps4: add /proc/pid/pagemap interface
has been removed from the -mm tree.  Its filename was
     maps4-add-proc-pid-pagemap-interface.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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
 fs/proc/task_mmu.c |  200 ++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 204 insertions(+), 2 deletions(-)

diff -puN fs/proc/base.c~maps4-add-proc-pid-pagemap-interface fs/proc/base.c
--- a/fs/proc/base.c~maps4-add-proc-pid-pagemap-interface
+++ a/fs/proc/base.c
@@ -783,7 +783,7 @@ out_no_task:
 }
 #endif
 
-static loff_t mem_lseek(struct file * file, loff_t offset, int orig)
+loff_t mem_lseek(struct file *file, loff_t offset, int orig)
 {
 	switch (orig) {
 	case 0:
@@ -2252,6 +2252,7 @@ static const struct pid_entry tgid_base_
 #ifdef CONFIG_MMU
 	REG("clear_refs", S_IWUSR, clear_refs),
 	REG("smaps",      S_IRUGO, smaps),
+	REG("pagemap",    S_IRUSR, pagemap),
 #endif
 #ifdef CONFIG_SECURITY
 	DIR("attr",       S_IRUGO|S_IXUGO, attr_dir),
@@ -2580,6 +2581,7 @@ static const struct pid_entry tid_base_s
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
@@ -52,11 +52,13 @@ extern int proc_tid_stat(struct task_str
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
@@ -519,6 +522,202 @@ const struct file_operations proc_clear_
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
+	for (; addr != end; addr += PAGE_SIZE) {
+		u64 pfn = PM_NOT_PRESENT;
+		pte = pte_offset_map(pmd, addr);
+		if (is_swap_pte(*pte))
+			pfn = swap_pte_to_pagemap_entry(*pte);
+		else if (pte_present(*pte))
+			pfn = pte_pfn(*pte);
+		/* unmap so we're not in atomic when we copy to userspace */
+		pte_unmap(pte);
+		err = add_to_pagemap(addr, pfn, pm);
+		if (err)
+			return err;
+	}
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
 
@@ -552,4 +751,3 @@ const struct file_operations proc_numa_m
 	.release	= seq_release_private,
 };
 #endif
-
_

Patches currently in -mm which might be from mpm@selenic.com are

origin.patch
drivers-char-randomcwrite_pool-cond_resched-needed.patch
random-clean-up-checkpatch-complaints.patch
random-clean-up-checkpatch-complaints-fix.patch
random-consolidate-wakeup-logic.patch
random-use-unlocked_ioctl.patch
random-reuse-rand_initialize.patch
random-improve-variable-naming-clear-extract-buffer.patch
random-make-backtracking-attacks-harder.patch
random-remove-cacheline-alignment-for-locks.patch
random-eliminate-redundant-new_rotate-variable.patch
random-remove-some-prefetch-logic.patch
random-simplify-add_ptr-logic.patch
random-make-mixing-interface-byte-oriented.patch
random-simplify-and-rename-credit_entropy_store.patch
random-add-async-notification-support-to-dev-random.patch
