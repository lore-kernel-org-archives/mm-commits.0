From: akpm@linux-foundation.org
Subject: + smaps-add-clear_refs-file-to-clear-reference.patch added to -mm tree
Date: Fri, 09 Feb 2007 15:39:49 -0800
Message-ID: <200702092339.l19NdohM029897@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:54712 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752560AbXBIXkD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 9 Feb 2007 18:40:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, clameter@sgi.com, hugh@veritas.com, lethal@linux-sh.org


The patch titled
     smaps: add clear_refs file to clear reference
has been added to the -mm tree.  Its filename is
     smaps-add-clear_refs-file-to-clear-reference.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: smaps: add clear_refs file to clear reference
From: David Rientjes <rientjes@google.com>

Adds /proc/pid/clear_refs.  When any non-zero number is written to this file,
pte_mkold() and ClearPageReferenced() is called for each pte and its
corresponding page, respectively, in that task's VMAs.  This file is only
writable by the user who owns the task.

It is now possible to measure _approximately_ how much memory a task is using
by clearing the reference bits with

	echo 1 > /proc/pid/clear_refs

and checking the reference count for each VMA from the /proc/pid/smaps output
at a measured time interval.  For example, to observe the approximate change
in memory footprint for a task, write a script that clears the references
(echo 1 > /proc/pid/clear_refs), sleeps, and then greps for Pgs_Referenced and
extracts the size in kB.  Add the sizes for each VMA together for the total
referenced footprint.  Moments later, repeat the process and observe the
difference.

For example, using an efficient Mozilla:

	accumulated time		referenced memory
	----------------		-----------------
		 0 s				 408 kB
		 1 s				 408 kB
		 2 s				 556 kB
		 3 s				1028 kB
		 4 s				 872 kB
		 5 s				1956 kB
		 6 s				 416 kB
		 7 s				1560 kB
		 8 s				2336 kB
		 9 s				1044 kB
		10 s				 416 kB

This is a valuable tool to get an approximate measurement of the memory
footprint for a task.

Cc: Hugh Dickins <hugh@veritas.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Christoph Lameter <clameter@sgi.com>
Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c          |   31 +++++++++++++++++++++++++++++++
 fs/proc/task_mmu.c      |   37 +++++++++++++++++++++++++++++++++++++
 include/linux/proc_fs.h |    1 +
 3 files changed, 69 insertions(+)

diff -puN fs/proc/base.c~smaps-add-clear_refs-file-to-clear-reference fs/proc/base.c
--- a/fs/proc/base.c~smaps-add-clear_refs-file-to-clear-reference
+++ a/fs/proc/base.c
@@ -715,6 +715,35 @@ static struct file_operations proc_oom_a
 	.write		= oom_adjust_write,
 };
 
+static ssize_t clear_refs_write(struct file *file, const char __user *buf,
+				size_t count, loff_t *ppos)
+{
+	struct task_struct *task;
+	char buffer[PROC_NUMBUF], *end;
+
+	memset(buffer, 0, sizeof(buffer));
+	if (count > sizeof(buffer) - 1)
+		count = sizeof(buffer) - 1;
+	if (copy_from_user(buffer, buf, count))
+		return -EFAULT;
+	if (!simple_strtol(buffer, &end, 0))
+		return -EINVAL;
+	if (*end == '\n')
+		end++;
+	task = get_proc_task(file->f_path.dentry->d_inode);
+	if (!task)
+		return -ESRCH;
+	clear_refs_smap(task->mm->mmap);
+	put_task_struct(task);
+	if (end - buffer == 0)
+		return -EIO;
+	return end - buffer;
+}
+
+static struct file_operations proc_clear_refs_operations = {
+	.write		= clear_refs_write,
+};
+
 #ifdef CONFIG_AUDITSYSCALL
 #define TMPBUFLEN 21
 static ssize_t proc_loginuid_read(struct file * file, char __user * buf,
@@ -1856,6 +1885,7 @@ static struct pid_entry tgid_base_stuff[
 	REG("mounts",     S_IRUGO, mounts),
 	REG("mountstats", S_IRUSR, mountstats),
 #ifdef CONFIG_MMU
+	REG("clear_refs", S_IWUSR, clear_refs),
 	REG("smaps",      S_IRUGO, smaps),
 #endif
 #ifdef CONFIG_SECURITY
@@ -2137,6 +2167,7 @@ static struct pid_entry tid_base_stuff[]
 	LNK("exe",       exe),
 	REG("mounts",    S_IRUGO, mounts),
 #ifdef CONFIG_MMU
+	REG("clear_refs", S_IWUSR, clear_refs),
 	REG("smaps",     S_IRUGO, smaps),
 #endif
 #ifdef CONFIG_SECURITY
diff -puN fs/proc/task_mmu.c~smaps-add-clear_refs-file-to-clear-reference fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~smaps-add-clear_refs-file-to-clear-reference
+++ a/fs/proc/task_mmu.c
@@ -254,6 +254,36 @@ static void smaps_one_pmd(struct vm_area
 	cond_resched();
 }
 
+static void clear_refs_one_pmd(struct vm_area_struct *vma, pmd_t *pmd,
+			       unsigned long addr, unsigned long end,
+			       void *private)
+{
+	pte_t *pte, ptent;
+	spinlock_t *ptl;
+	struct page *page;
+
+	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
+	for (; addr != end; pte++, addr += PAGE_SIZE) {
+		ptent = *pte;
+		if (!pte_present(ptent))
+			continue;
+
+		page = vm_normal_page(vma, addr, ptent);
+		if (!page)
+			continue;
+
+		/* Clear accessed and referenced bits. */
+		if (pte_young(ptent)) {
+			ptent = pte_mkold(ptent);
+			set_pte_at(vma->vm_mm, addr, pte, ptent);
+			flush_tlb_page(vma, addr);
+		}
+		ClearPageReferenced(page);
+	}
+	pte_unmap_unlock(pte - 1, ptl);
+	cond_resched();
+}
+
 static inline void for_each_pmd_in_pud(struct pmd_walker *walker, pud_t *pud,
 				       unsigned long addr, unsigned long end)
 {
@@ -320,6 +350,13 @@ static int show_smap(struct seq_file *m,
 	return show_map_internal(m, v, &mss);
 }
 
+void clear_refs_smap(struct vm_area_struct *vma)
+{
+	for (; vma; vma = vma->vm_next)
+		if (vma->vm_mm && !is_vm_hugetlb_page(vma))
+			for_each_pmd(vma, clear_refs_one_pmd, NULL);
+}
+
 static void *m_start(struct seq_file *m, loff_t *pos)
 {
 	struct proc_maps_private *priv = m->private;
diff -puN include/linux/proc_fs.h~smaps-add-clear_refs-file-to-clear-reference include/linux/proc_fs.h
--- a/include/linux/proc_fs.h~smaps-add-clear_refs-file-to-clear-reference
+++ a/include/linux/proc_fs.h
@@ -104,6 +104,7 @@ int proc_pid_readdir(struct file * filp,
 unsigned long task_vsize(struct mm_struct *);
 int task_statm(struct mm_struct *, int *, int *, int *, int *);
 char *task_mem(struct mm_struct *, char *);
+void clear_refs_smap(struct vm_area_struct *);
 
 extern struct proc_dir_entry *create_proc_entry(const char *name, mode_t mode,
 						struct proc_dir_entry *parent);
_

Patches currently in -mm which might be from rientjes@google.com are

smaps-extract-pmd-walker-from-smaps-code.patch
smaps-add-pages-referenced-count-to-smaps.patch
smaps-add-clear_refs-file-to-clear-reference.patch
