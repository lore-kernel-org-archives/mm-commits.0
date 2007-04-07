From: akpm@linux-foundation.org
Subject: + maps2-add-proc-pid-pagemap-interface.patch added to -mm tree
Date: Fri, 06 Apr 2007 23:55:55 -0700
Message-ID: <200704070655.l376ttTA029497@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46473 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965458AbXDGG4K (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 7 Apr 2007 02:56:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mpm@selenic.com, jeremy@goop.org, rientjes@google.com


The patch titled
     maps: add /proc/pid/pagemap interface
has been added to the -mm tree.  Its filename is
     maps2-add-proc-pid-pagemap-interface.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: maps: add /proc/pid/pagemap interface
From: Matt Mackall <mpm@selenic.com>

This interface provides a mapping for each page in an address space to its
physical page frame number, allowing precise determination of what pages are
mapped and what pages are shared between processes.

Signed-off-by: Matt Mackall <mpm@selenic.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c     |    8 +
 fs/proc/internal.h |    2 
 fs/proc/task_mmu.c |  184 +++++++++++++++++++++++++++++++++++++++++++
 init/Kconfig       |   10 ++
 4 files changed, 203 insertions(+), 1 deletion(-)

diff -puN fs/proc/base.c~maps2-add-proc-pid-pagemap-interface fs/proc/base.c
--- a/fs/proc/base.c~maps2-add-proc-pid-pagemap-interface
+++ a/fs/proc/base.c
@@ -630,7 +630,7 @@ out_no_task:
 }
 #endif
 
-static loff_t mem_lseek(struct file * file, loff_t offset, int orig)
+loff_t mem_lseek(struct file * file, loff_t offset, int orig)
 {
 	switch (orig) {
 	case 0:
@@ -1858,6 +1858,9 @@ static struct pid_entry tgid_base_stuff[
 #ifdef CONFIG_PROC_SMAPS
 	REG("smaps",      S_IRUGO, smaps),
 #endif
+#ifdef CONFIG_PROC_PAGEMAP
+	REG("pagemap",    S_IRUSR, pagemap),
+#endif
 #endif
 #ifdef CONFIG_SECURITY
 	DIR("attr",       S_IRUGO|S_IXUGO, attr_dir),
@@ -2144,6 +2147,9 @@ static struct pid_entry tid_base_stuff[]
 #ifdef CONFIG_PROC_SMAPS
 	REG("smaps",     S_IRUGO, smaps),
 #endif
+#ifdef CONFIG_PROC_PAGEMAP
+	REG("pagemap",    S_IRUSR, pagemap),
+#endif
 #endif
 #ifdef CONFIG_SECURITY
 	DIR("attr",      S_IRUGO|S_IXUGO, attr_dir),
diff -puN fs/proc/internal.h~maps2-add-proc-pid-pagemap-interface fs/proc/internal.h
--- a/fs/proc/internal.h~maps2-add-proc-pid-pagemap-interface
+++ a/fs/proc/internal.h
@@ -43,11 +43,13 @@ extern int proc_tid_stat(struct task_str
 extern int proc_tgid_stat(struct task_struct *, char *);
 extern int proc_pid_status(struct task_struct *, char *);
 extern int proc_pid_statm(struct task_struct *, char *);
+extern loff_t mem_lseek(struct file * file, loff_t offset, int orig);
 
 extern const struct file_operations proc_maps_operations;
 extern const struct file_operations proc_numa_maps_operations;
 extern const struct file_operations proc_smaps_operations;
 extern const struct file_operations proc_clear_refs_operations;
+extern const struct file_operations proc_pagemap_operations;
 
 void free_proc_entry(struct proc_dir_entry *de);
 
diff -puN fs/proc/task_mmu.c~maps2-add-proc-pid-pagemap-interface fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~maps2-add-proc-pid-pagemap-interface
+++ a/fs/proc/task_mmu.c
@@ -515,3 +515,187 @@ const struct file_operations proc_numa_m
 };
 #endif
 
+#ifdef CONFIG_PROC_PAGEMAP
+struct pagemapread {
+	struct mm_struct *mm;
+	unsigned long next;
+	unsigned long *buf;
+	unsigned long pos;
+	size_t count;
+	int index;
+	char __user *out;
+};
+
+static int flush_pagemap(struct pagemapread *pm)
+{
+	int n = min(pm->count, pm->index * sizeof(unsigned long));
+	if (copy_to_user(pm->out, pm->buf, n))
+		return -EFAULT;
+	pm->out += n;
+	pm->pos += n;
+	pm->count -= n;
+	pm->index = 0;
+	cond_resched();
+	return 0;
+}
+
+static int add_to_pagemap(unsigned long addr, unsigned long pfn,
+			  struct pagemapread *pm)
+{
+	pm->buf[pm->index++] = pfn;
+	pm->next = addr + PAGE_SIZE;
+	if (pm->index * sizeof(unsigned long) >= PAGE_SIZE ||
+	    pm->index * sizeof(unsigned long) >= pm->count)
+		return flush_pagemap(pm);
+	return 0;
+}
+
+static int pagemap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
+			     void *private)
+{
+	struct pagemapread *pm = private;
+	pte_t *pte;
+	int err;
+
+	pte = pte_offset_map(pmd, addr);
+	for (; addr != end; pte++, addr += PAGE_SIZE) {
+		if (addr < pm->next)
+			continue;
+		if (!pte_present(*pte))
+			err = add_to_pagemap(addr, -1, pm);
+		else
+			err = add_to_pagemap(addr, pte_pfn(*pte), pm);
+		if (err)
+			return err;
+	}
+	pte_unmap(pte - 1);
+	return 0;
+}
+
+static int pagemap_fill(struct pagemapread *pm, unsigned long end)
+{
+	int ret;
+
+	while (pm->next != end) {
+		ret = add_to_pagemap(pm->next, -1UL, pm);
+		if (ret)
+			return ret;
+	}
+	return 0;
+}
+
+static struct mm_walk pagemap_walk = { .pmd_entry = pagemap_pte_range };
+
+/*
+ * /proc/pid/pagemap - an array mapping virtual pages to pfns
+ *
+ * For each page in the address space, this file contains one long
+ * representing the corresponding physical page frame number (PFN) or
+ * -1 if the page isn't present. This allows determining precisely
+ * which pages are mapped and comparing mapped pages between
+ * processes.
+ *
+ * Efficient users of this interface will use /proc/pid/maps to
+ * determine which areas of memory are actually mapped and llseek to
+ * skip over unmapped regions.
+ *
+ * The first 4 bytes of this file form a simple header:
+ *
+ * first byte:   0 for big endian, 1 for little
+ * second byte:  page shift (eg 12 for 4096 byte pages)
+ * third byte:   entry size in bytes (currently either 4 or 8)
+ * fourth byte:  header size
+ */
+static ssize_t pagemap_read(struct file *file, char __user *buf,
+			    size_t count, loff_t *ppos)
+{
+	struct task_struct *task = get_proc_task(file->f_path.dentry->d_inode);
+	unsigned long src = *ppos;
+	unsigned long *page;
+	unsigned long addr, end, vend, svpfn, evpfn;
+	struct mm_struct *mm;
+	struct vm_area_struct *vma;
+	struct pagemapread pm;
+	int ret = -ESRCH;
+
+	if (!task)
+		goto out_no_task;
+
+	ret = -EACCES;
+	if (!ptrace_may_attach(task))
+		goto out;
+
+	ret = -EIO;
+	svpfn = src / sizeof(unsigned long) - 1;
+	addr = PAGE_SIZE * svpfn;
+	if ((svpfn + 1) * sizeof(unsigned long) != src)
+		goto out;
+	evpfn = min((src + count) / sizeof(unsigned long),
+		    ((~0UL) >> PAGE_SHIFT) + 1);
+	count = (evpfn - svpfn) * sizeof(unsigned long);
+	end = PAGE_SIZE * evpfn;
+
+	ret = -ENOMEM;
+	page = kzalloc(PAGE_SIZE, GFP_USER);
+	if (!page)
+		goto out;
+
+	ret = 0;
+	mm = get_task_mm(task);
+	if (!mm)
+		goto out_free;
+
+	pm.mm = mm;
+	pm.next = addr;
+	pm.buf = page;
+	pm.pos = src;
+	pm.count = count;
+	pm.index = 0;
+	pm.out = buf;
+
+	if (svpfn == -1) {
+		add_to_pagemap(pm.next, 0, &pm);
+		((char *)page)[0] = (ntohl(1) != 1);
+		((char *)page)[1] = PAGE_SHIFT;
+		((char *)page)[2] = sizeof(unsigned long);
+		((char *)page)[3] = sizeof(unsigned long);
+	}
+
+	down_read(&mm->mmap_sem);
+	vma = find_vma(mm, pm.next);
+	while (pm.count > 0 && vma) {
+		if (!ptrace_may_attach(task)) {
+			ret = -EIO;
+			goto out;
+		}
+		vend = min(vma->vm_start - 1, end - 1) + 1;
+		ret = pagemap_fill(&pm, vend);
+		if (ret || !pm.count)
+			break;
+		vend = min(vma->vm_end - 1, end - 1) + 1;
+		ret = walk_page_range(mm, vma->vm_start, vend,
+				      &pagemap_walk, &pm);
+		vma = vma->vm_next;
+	}
+	up_read(&mm->mmap_sem);
+
+	ret = pagemap_fill(&pm, end);
+
+	*ppos = pm.pos;
+	if (!ret)
+		ret = pm.pos - src;
+
+	mmput(mm);
+out_free:
+	kfree(page);
+out:
+	put_task_struct(task);
+out_no_task:
+	return ret;
+}
+
+const struct file_operations proc_pagemap_operations = {
+	.llseek		= mem_lseek, /* borrow this */
+	.read		= pagemap_read,
+};
+#endif
diff -puN init/Kconfig~maps2-add-proc-pid-pagemap-interface init/Kconfig
--- a/init/Kconfig~maps2-add-proc-pid-pagemap-interface
+++ a/init/Kconfig
@@ -509,6 +509,16 @@ config PROC_CLEAR_REFS
           working set size. Disabling this interface will reduce
           the size of the kernel for small machines.
 
+config PROC_PAGEMAP
+	default y
+	bool "Enable /proc/pid/pagemap support" if EMBEDDED && PROC_FS && MMU
+	help
+	  The /proc/pid/pagemap interface allows reading the
+          kernel's virtual memory to page frame mapping to determine which
+          individual pages a process has mapped and which pages it shares
+          with other processes. Disabling this interface will reduce the
+          size of the kernel for small machines.
+
 endmenu		# General setup
 
 config RT_MUTEXES
_

Patches currently in -mm which might be from mpm@selenic.com are

slab-introduce-krealloc.patch
slab-introduce-krealloc-fix.patch
smaps-add-clear_refs-file-to-clear-reference-cleanup.patch
maps2-uninline-some-functions-in-the-page-walker.patch
maps2-eliminate-the-pmd_walker-struct-in-the-page-walker.patch
maps2-remove-vma-from-args-in-the-page-walker.patch
maps2-propagate-errors-from-callback-in-page-walker.patch
maps2-add-callbacks-for-each-level-to-page-walker.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-simplify-interdependence-of-proc-pid-maps-and-smaps.patch
maps2-move-clear_refs-code-to-task_mmuc.patch
maps2-regroup-task_mmu-by-interface.patch
maps2-make-proc-pid-smaps-optional-under-config_embedded.patch
maps2-make-proc-pid-clear_refs-option-under-config_embedded.patch
maps2-add-proc-pid-pagemap-interface.patch
maps2-add-proc-kpagemap-interface.patch
