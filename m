From: akpm@linux-foundation.org
Subject: - smaps-add-clear_refs-file-to-clear-reference.patch removed from -mm tree
Date: Mon, 07 May 2007 17:02:29 -0700
Message-ID: <200705080002.l4802Tad008847@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:51673 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967485AbXEHAMI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:12:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, clameter@sgi.com, hugh@veritas.com, lethal@linux-sh.org, mm-commits@vger.kernel.org


The patch titled
     smaps: add clear_refs file to clear reference
has been removed from the -mm tree.  Its filename was
     smaps-add-clear_refs-file-to-clear-reference.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
[akpm@linux-foundation.org: build fixes]
[mpm@selenic.com: rename for_each_pmd]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt |   31 +++++-----
 fs/proc/base.c                     |   36 ++++++++++++
 fs/proc/task_mmu.c                 |   79 +++++++++++++++++++++------
 include/linux/proc_fs.h            |    1 
 4 files changed, 116 insertions(+), 31 deletions(-)

diff -puN Documentation/filesystems/proc.txt~smaps-add-clear_refs-file-to-clear-reference Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~smaps-add-clear_refs-file-to-clear-reference
+++ a/Documentation/filesystems/proc.txt
@@ -122,21 +122,22 @@ subdirectory has the entries listed in T
 
 Table 1-1: Process specific entries in /proc 
 ..............................................................................
- File    Content                                        
- cmdline Command line arguments                         
- cpu	 Current and last cpu in which it was executed		(2.4)(smp)
- cwd	 Link to the current working directory
- environ Values of environment variables      
- exe	 Link to the executable of this process
- fd      Directory, which contains all file descriptors 
- maps	 Memory maps to executables and library files		(2.4)
- mem     Memory held by this process                    
- root	 Link to the root directory of this process
- stat    Process status                                 
- statm   Process memory status information              
- status  Process status in human readable form          
- wchan   If CONFIG_KALLSYMS is set, a pre-decoded wchan
- smaps	 Extension based on maps, presenting the rss size for each mapped file
+ File		Content
+ clear_refs	Clears page referenced bits shown in smaps output
+ cmdline	Command line arguments
+ cpu		Current and last cpu in which it was executed	(2.4)(smp)
+ cwd		Link to the current working directory
+ environ	Values of environment variables
+ exe		Link to the executable of this process
+ fd		Directory, which contains all file descriptors
+ maps		Memory maps to executables and library files	(2.4)
+ mem		Memory held by this process
+ root		Link to the root directory of this process
+ stat		Process status
+ statm		Process memory status information
+ status		Process status in human readable form
+ wchan		If CONFIG_KALLSYMS is set, a pre-decoded wchan
+ smaps		Extension based on maps, the rss size for each mapped file
 ..............................................................................
 
 For example, to get the status information of a process, all you have to do is
diff -puN fs/proc/base.c~smaps-add-clear_refs-file-to-clear-reference fs/proc/base.c
--- a/fs/proc/base.c~smaps-add-clear_refs-file-to-clear-reference
+++ a/fs/proc/base.c
@@ -715,6 +715,40 @@ static const struct file_operations proc
 	.write		= oom_adjust_write,
 };
 
+static ssize_t clear_refs_write(struct file *file, const char __user *buf,
+				size_t count, loff_t *ppos)
+{
+	struct task_struct *task;
+	char buffer[PROC_NUMBUF], *end;
+	struct mm_struct *mm;
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
+	mm = get_task_mm(task);
+	if (mm) {
+		clear_refs_smap(mm);
+		mmput(mm);
+	}
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
@@ -1851,6 +1885,7 @@ static struct pid_entry tgid_base_stuff[
 	REG("mounts",     S_IRUGO, mounts),
 	REG("mountstats", S_IRUSR, mountstats),
 #ifdef CONFIG_MMU
+	REG("clear_refs", S_IWUSR, clear_refs),
 	REG("smaps",      S_IRUGO, smaps),
 #endif
 #ifdef CONFIG_SECURITY
@@ -2132,6 +2167,7 @@ static struct pid_entry tid_base_stuff[]
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
@@ -195,7 +195,7 @@ static int show_map_internal(struct seq_
 			   "Shared_Dirty:   %8lu kB\n"
 			   "Private_Clean:  %8lu kB\n"
 			   "Private_Dirty:  %8lu kB\n"
-			   "Pgs_Referenced: %8lu kB\n",
+			   "Referenced:     %8lu kB\n",
 			   (vma->vm_end - vma->vm_start) >> 10,
 			   mss->resident >> 10,
 			   mss->shared_clean  >> 10,
@@ -214,9 +214,9 @@ static int show_map(struct seq_file *m, 
 	return show_map_internal(m, v, NULL);
 }
 
-static void smaps_one_pmd(struct vm_area_struct *vma, pmd_t *pmd,
-			  unsigned long addr, unsigned long end,
-			  void *private)
+static void smaps_pte_range(struct vm_area_struct *vma, pmd_t *pmd,
+			    unsigned long addr, unsigned long end,
+			    void *private)
 {
 	struct mem_size_stats *mss = private;
 	pte_t *pte, ptent;
@@ -254,8 +254,34 @@ static void smaps_one_pmd(struct vm_area
 	cond_resched();
 }
 
-static inline void for_each_pmd_in_pud(struct pmd_walker *walker, pud_t *pud,
-				       unsigned long addr, unsigned long end)
+static void clear_refs_pte_range(struct vm_area_struct *vma, pmd_t *pmd,
+				 unsigned long addr, unsigned long end,
+				 void *private)
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
+		ptep_test_and_clear_young(vma, addr, pte);
+		ClearPageReferenced(page);
+	}
+	pte_unmap_unlock(pte - 1, ptl);
+	cond_resched();
+}
+
+static inline void walk_pmd_range(struct pmd_walker *walker, pud_t *pud,
+				  unsigned long addr, unsigned long end)
 {
 	pmd_t *pmd;
 	unsigned long next;
@@ -269,8 +295,8 @@ static inline void for_each_pmd_in_pud(s
 	}
 }
 
-static inline void for_each_pud_in_pgd(struct pmd_walker *walker, pgd_t *pgd,
-				       unsigned long addr, unsigned long end)
+static inline void walk_pud_range(struct pmd_walker *walker, pgd_t *pgd,
+				  unsigned long addr, unsigned long end)
 {
 	pud_t *pud;
 	unsigned long next;
@@ -280,15 +306,24 @@ static inline void for_each_pud_in_pgd(s
 		next = pud_addr_end(addr, end);
 		if (pud_none_or_clear_bad(pud))
 			continue;
-		for_each_pmd_in_pud(walker, pud, addr, next);
+		walk_pmd_range(walker, pud, addr, next);
 	}
 }
 
-static inline void for_each_pmd(struct vm_area_struct *vma,
-				void (*action)(struct vm_area_struct *, pmd_t *,
-					       unsigned long, unsigned long,
-					       void *),
-				void *private)
+/*
+ * walk_page_range - walk the page tables of a VMA with a callback
+ * @vma - VMA to walk
+ * @action - callback invoked for every bottom-level (PTE) page table
+ * @private - private data passed to the callback function
+ *
+ * Recursively walk the page table for the memory area in a VMA, calling
+ * a callback for every bottom-level (PTE) page table.
+ */
+static inline void walk_page_range(struct vm_area_struct *vma,
+				   void (*action)(struct vm_area_struct *,
+						  pmd_t *, unsigned long,
+						  unsigned long, void *),
+				   void *private)
 {
 	unsigned long addr = vma->vm_start;
 	unsigned long end = vma->vm_end;
@@ -305,7 +340,7 @@ static inline void for_each_pmd(struct v
 		next = pgd_addr_end(addr, end);
 		if (pgd_none_or_clear_bad(pgd))
 			continue;
-		for_each_pud_in_pgd(&walker, pgd, addr, next);
+		walk_pud_range(&walker, pgd, addr, next);
 	}
 }
 
@@ -316,10 +351,22 @@ static int show_smap(struct seq_file *m,
 
 	memset(&mss, 0, sizeof mss);
 	if (vma->vm_mm && !is_vm_hugetlb_page(vma))
-		for_each_pmd(vma, smaps_one_pmd, &mss);
+		walk_page_range(vma, smaps_pte_range, &mss);
 	return show_map_internal(m, v, &mss);
 }
 
+void clear_refs_smap(struct mm_struct *mm)
+{
+	struct vm_area_struct *vma;
+
+	down_read(&mm->mmap_sem);
+	for (vma = mm->mmap; vma; vma = vma->vm_next)
+		if (vma->vm_mm && !is_vm_hugetlb_page(vma))
+			walk_page_range(vma, clear_refs_pte_range, NULL);
+	flush_tlb_mm(mm);
+	up_read(&mm->mmap_sem);
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
+void clear_refs_smap(struct mm_struct *mm);
 
 extern struct proc_dir_entry *create_proc_entry(const char *name, mode_t mode,
 						struct proc_dir_entry *parent);
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
git-alsa.patch
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
cpusets-allow-empty-cpusmems_allowed-to-be-set-for.patch
cpusets-allow-empty-cpusmems_allowed-to-be-set-for-fix.patch
compiler-introduce-__used-and-__maybe_unused.patch
i386-pci-type-may-be-unused.patch
sh-dma-use-__maybe_unused.patch
scsi-fix-ambiguous-gdthtable-definition.patch
frv-gdb-use-__maybe_unused.patch
i386-voyager-use-__maybe_unused.patch
mips-excite-use-__maybe_unused.patch
mips-tlbex-use-__maybe_unused.patch
powerpc-ps3-use-__maybe_unused.patch
i386-mmzone-use-__maybe_unused.patch
