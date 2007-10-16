From: akpm@linux-foundation.org
Subject: - maps2-add-proc-pid-pagemap-interface.patch removed from -mm tree
Date: Tue, 16 Oct 2007 14:36:34 -0700
Message-ID: <200710162136.l9GLaYs6018600@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37679 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934310AbXJPVhY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:37:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mpm@selenic.com, jeremy@goop.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     maps: add /proc/pid/pagemap interface
has been removed from the -mm tree.  Its filename was
     maps2-add-proc-pid-pagemap-interface.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: maps: add /proc/pid/pagemap interface
From: Matt Mackall <mpm@selenic.com>

This interface provides a mapping for each page in an address space to its
physical page frame number, allowing precise determination of what pages are
mapped and what pages are shared between processes.

[akpm@linux-foundation.org: warning fix]
Signed-off-by: Matt Mackall <mpm@selenic.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c     |    8 +
 fs/proc/internal.h |    2 
 fs/proc/task_mmu.c |  209 +++++++++++++++++++++++++++++++++++++++++++
 init/Kconfig       |   10 ++
 4 files changed, 228 insertions(+), 1 deletion(-)

diff -puN fs/proc/base.c~maps2-add-proc-pid-pagemap-interface fs/proc/base.c
--- a/fs/proc/base.c~maps2-add-proc-pid-pagemap-interface
+++ a/fs/proc/base.c
@@ -635,7 +635,7 @@ out_no_task:
 }
 #endif
 
-static loff_t mem_lseek(struct file * file, loff_t offset, int orig)
+loff_t mem_lseek(struct file * file, loff_t offset, int orig)
 {
 	switch (orig) {
 	case 0:
@@ -2039,6 +2039,9 @@ static const struct pid_entry tgid_base_
 #ifdef CONFIG_PROC_SMAPS
 	REG("smaps",      S_IRUGO, smaps),
 #endif
+#ifdef CONFIG_PROC_PAGEMAP
+	REG("pagemap",    S_IRUSR, pagemap),
+#endif
 #endif
 #ifdef CONFIG_SECURITY
 	DIR("attr",       S_IRUGO|S_IXUGO, attr_dir),
@@ -2329,6 +2332,9 @@ static const struct pid_entry tid_base_s
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
@@ -50,11 +50,13 @@ extern int proc_tid_stat(struct task_str
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
@@ -5,6 +5,7 @@
 #include <linux/highmem.h>
 #include <linux/ptrace.h>
 #include <linux/pagemap.h>
+#include <linux/ptrace.h>
 #include <linux/mempolicy.h>
 
 #include <asm/elf.h>
@@ -530,3 +531,211 @@ const struct file_operations proc_numa_m
 };
 #endif
 
+#ifdef CONFIG_PROC_PAGEMAP
+struct pagemapread {
+	struct mm_struct *mm;
+	unsigned long next;
+	unsigned long *buf;
+	pte_t *ptebuf;
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
+
+#ifdef CONFIG_HIGHPTE
+	/* copy PTE directory to temporary buffer and unmap it */
+	memcpy(pm->ptebuf, pte, PAGE_ALIGN((unsigned long)pte) - (unsigned long)pte);
+	pte_unmap(pte);
+	pte = pm->ptebuf;
+#endif
+
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
+
+#ifndef CONFIG_HIGHPTE
+	pte_unmap(pte - 1);
+#endif
+
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
+#ifdef CONFIG_HIGHPTE
+	pm.ptebuf = kzalloc(PAGE_SIZE, GFP_USER);
+	if (!pm.ptebuf)
+		goto out_free;
+#endif
+
+	ret = 0;
+	mm = get_task_mm(task);
+	if (!mm)
+		goto out_freepte;
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
+			goto out_mm;
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
+out_mm:
+	mmput(mm);
+out_freepte:
+#ifdef CONFIG_HIGHPTE
+	kfree(pm.ptebuf);
+out_free:
+#endif
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
@@ -613,6 +613,16 @@ config PROC_CLEAR_REFS
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

origin.patch
maps2-add-proc-pid-pagemap-interface.patch
maps2-add-proc-pid-pagemap-interface-fix-proc-pid-pagemap-return-length-calculation.patch
maps2-add-proc-pid-pagemap-interface-fix-proc-pid-pagemap-end-address-calculation.patch
maps2-add-proc-pid-pagemap-interface-fix-proc-pid-pagemap-header-copy-to-userspace.patch
maps2-add-proc-kpagemap-interface.patch
mmaps2-vma-out-of-mem_size_stats.patch
maps2-make-proc-pid-smaps-optional-under-config_embeddedpatch.patch
maps2-make-proc-pid-smaps-optional-under-config_embeddedpatch-fix.patch
maps-pssproportional-set-size-accounting-in-smaps.patch
lib-sortc-optimization.patch
sparse-pointer-use-of-zero-as-null.patch
sparse-pointer-use-of-zero-as-null-checkpatch-fixes.patch
