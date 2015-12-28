From: akpm@linux-foundation.org
Subject: + mm-rework-virtual-memory-accounting.patch added to -mm tree
Date: Mon, 28 Dec 2015 15:10:42 -0800
Message-ID: <5681c172.1vuwCcmKcUgIM/s/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44577 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752566AbbL1XKn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 28 Dec 2015 18:10:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: koct9i@gmail.com, a.p.zijlstra@chello.nl, gorcunov@openvz.org, keescook@google.com, luto@amacapital.net, quentin.casasnovas@oracle.com, torvalds@linux-foundation.org, vdavydov@virtuozzo.com, vegard.nossum@oracle.com, w@1wt.eu, xemul@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: rework virtual memory accounting
has been added to the -mm tree.  Its filename is
     mm-rework-virtual-memory-accounting.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-rework-virtual-memory-accounting.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-rework-virtual-memory-accounting.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Konstantin Khlebnikov <koct9i@gmail.com>
Subject: mm: rework virtual memory accounting

When inspecting a vague code inside prctl(PR_SET_MM_MEM) call (which
testing the RLIMIT_DATA value to figure out if we're allowed to assign new
@start_brk, @brk, @start_data, @end_data from mm_struct) it's been
commited that RLIMIT_DATA in a form it's implemented now doesn't do
anything useful because most of user-space libraries use mmap() syscall
for dynamic memory allocations.

Linus suggested to convert RLIMIT_DATA rlimit into something suitable for
anonymous memory accounting.  But in this patch we go further, and the
changes are bundled together as:

 * keep vma counting if CONFIG_PROC_FS=n, will be used for limits
 * replace mm->shared_vm with better defined mm->data_vm
 * account anonymous executable areas as executable
 * account file-backed growsdown/up areas as stack
 * drop struct file* argument from vm_stat_account
 * enforce RLIMIT_DATA for size of data areas

This way code looks cleaner: now code/stack/data classification depends
only on vm_flags state:

 VM_EXEC & ~VM_WRITE            -> code  (VmExe + VmLib in proc)
 VM_GROWSUP | VM_GROWSDOWN      -> stack (VmStk)
 VM_WRITE & ~VM_SHARED & !stack -> data  (VmData)

The rest (VmSize - VmData - VmStk - VmExe - VmLib) could be called
"shared", but that might be strange beast like readonly-private or VM_IO
area.

 - RLIMIT_AS            limits whole address space "VmSize"
 - RLIMIT_STACK         limits stack "VmStk" (but each vma individually)
 - RLIMIT_DATA          now limits "VmData"

Signed-off-by: Konstantin Khlebnikov <koct9i@gmail.com>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Quentin Casasnovas <quentin.casasnovas@oracle.com>
Cc: Vegard Nossum <vegard.nossum@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Willy Tarreau <w@1wt.eu>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Kees Cook <keescook@google.com>
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>
Cc: Pavel Emelyanov <xemul@virtuozzo.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/perfmon.c |    3 -
 fs/proc/task_mmu.c         |    7 +--
 include/linux/mm.h         |   13 +------
 include/linux/mm_types.h   |    2 -
 kernel/fork.c              |    5 +-
 mm/debug.c                 |    4 +-
 mm/mmap.c                  |   63 +++++++++++++++++------------------
 mm/mprotect.c              |    8 +++-
 mm/mremap.c                |    7 ++-
 9 files changed, 54 insertions(+), 58 deletions(-)

diff -puN arch/ia64/kernel/perfmon.c~mm-rework-virtual-memory-accounting arch/ia64/kernel/perfmon.c
--- a/arch/ia64/kernel/perfmon.c~mm-rework-virtual-memory-accounting
+++ a/arch/ia64/kernel/perfmon.c
@@ -2332,8 +2332,7 @@ pfm_smpl_buffer_alloc(struct task_struct
 	 */
 	insert_vm_struct(mm, vma);
 
-	vm_stat_account(vma->vm_mm, vma->vm_flags, vma->vm_file,
-							vma_pages(vma));
+	vm_stat_account(vma->vm_mm, vma->vm_flags, vma_pages(vma));
 	up_write(&task->mm->mmap_sem);
 
 	/*
diff -puN fs/proc/task_mmu.c~mm-rework-virtual-memory-accounting fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~mm-rework-virtual-memory-accounting
+++ a/fs/proc/task_mmu.c
@@ -23,7 +23,7 @@
 
 void task_mem(struct seq_file *m, struct mm_struct *mm)
 {
-	unsigned long data, text, lib, swap, ptes, pmds, anon, file, shmem;
+	unsigned long text, lib, swap, ptes, pmds, anon, file, shmem;
 	unsigned long hiwater_vm, total_vm, hiwater_rss, total_rss;
 
 	anon = get_mm_counter(mm, MM_ANONPAGES);
@@ -44,7 +44,6 @@ void task_mem(struct seq_file *m, struct
 	if (hiwater_rss < mm->hiwater_rss)
 		hiwater_rss = mm->hiwater_rss;
 
-	data = mm->total_vm - mm->shared_vm - mm->stack_vm;
 	text = (PAGE_ALIGN(mm->end_code) - (mm->start_code & PAGE_MASK)) >> 10;
 	lib = (mm->exec_vm << (PAGE_SHIFT-10)) - text;
 	swap = get_mm_counter(mm, MM_SWAPENTS);
@@ -76,7 +75,7 @@ void task_mem(struct seq_file *m, struct
 		anon << (PAGE_SHIFT-10),
 		file << (PAGE_SHIFT-10),
 		shmem << (PAGE_SHIFT-10),
-		data << (PAGE_SHIFT-10),
+		mm->data_vm << (PAGE_SHIFT-10),
 		mm->stack_vm << (PAGE_SHIFT-10), text, lib,
 		ptes >> 10,
 		pmds >> 10,
@@ -97,7 +96,7 @@ unsigned long task_statm(struct mm_struc
 			get_mm_counter(mm, MM_SHMEMPAGES);
 	*text = (PAGE_ALIGN(mm->end_code) - (mm->start_code & PAGE_MASK))
 								>> PAGE_SHIFT;
-	*data = mm->total_vm - mm->shared_vm;
+	*data = mm->data_vm + mm->stack_vm;
 	*resident = *shared + get_mm_counter(mm, MM_ANONPAGES);
 	return mm->total_vm;
 }
diff -puN include/linux/mm.h~mm-rework-virtual-memory-accounting include/linux/mm.h
--- a/include/linux/mm.h~mm-rework-virtual-memory-accounting
+++ a/include/linux/mm.h
@@ -1929,7 +1929,9 @@ extern void mm_drop_all_locks(struct mm_
 extern void set_mm_exe_file(struct mm_struct *mm, struct file *new_exe_file);
 extern struct file *get_mm_exe_file(struct mm_struct *mm);
 
-extern int may_expand_vm(struct mm_struct *mm, unsigned long npages);
+extern bool may_expand_vm(struct mm_struct *, vm_flags_t, unsigned long npages);
+extern void vm_stat_account(struct mm_struct *, vm_flags_t, long npages);
+
 extern struct vm_area_struct *_install_special_mapping(struct mm_struct *mm,
 				   unsigned long addr, unsigned long len,
 				   unsigned long flags,
@@ -2147,15 +2149,6 @@ typedef int (*pte_fn_t)(pte_t *pte, pgta
 extern int apply_to_page_range(struct mm_struct *mm, unsigned long address,
 			       unsigned long size, pte_fn_t fn, void *data);
 
-#ifdef CONFIG_PROC_FS
-void vm_stat_account(struct mm_struct *, unsigned long, struct file *, long);
-#else
-static inline void vm_stat_account(struct mm_struct *mm,
-			unsigned long flags, struct file *file, long pages)
-{
-	mm->total_vm += pages;
-}
-#endif /* CONFIG_PROC_FS */
 
 #ifdef CONFIG_DEBUG_PAGEALLOC
 extern bool _debug_pagealloc_enabled;
diff -puN include/linux/mm_types.h~mm-rework-virtual-memory-accounting include/linux/mm_types.h
--- a/include/linux/mm_types.h~mm-rework-virtual-memory-accounting
+++ a/include/linux/mm_types.h
@@ -427,7 +427,7 @@ struct mm_struct {
 	unsigned long total_vm;		/* Total pages mapped */
 	unsigned long locked_vm;	/* Pages that have PG_mlocked set */
 	unsigned long pinned_vm;	/* Refcount permanently increased */
-	unsigned long shared_vm;	/* Shared pages (files) */
+	unsigned long data_vm;		/* VM_WRITE & ~VM_SHARED/GROWSDOWN */
 	unsigned long exec_vm;		/* VM_EXEC & ~VM_WRITE */
 	unsigned long stack_vm;		/* VM_GROWSUP/DOWN */
 	unsigned long def_flags;
diff -puN kernel/fork.c~mm-rework-virtual-memory-accounting kernel/fork.c
--- a/kernel/fork.c~mm-rework-virtual-memory-accounting
+++ a/kernel/fork.c
@@ -413,7 +413,7 @@ static int dup_mmap(struct mm_struct *mm
 	RCU_INIT_POINTER(mm->exe_file, get_mm_exe_file(oldmm));
 
 	mm->total_vm = oldmm->total_vm;
-	mm->shared_vm = oldmm->shared_vm;
+	mm->data_vm = oldmm->data_vm;
 	mm->exec_vm = oldmm->exec_vm;
 	mm->stack_vm = oldmm->stack_vm;
 
@@ -432,8 +432,7 @@ static int dup_mmap(struct mm_struct *mm
 		struct file *file;
 
 		if (mpnt->vm_flags & VM_DONTCOPY) {
-			vm_stat_account(mm, mpnt->vm_flags, mpnt->vm_file,
-							-vma_pages(mpnt));
+			vm_stat_account(mm, mpnt->vm_flags, -vma_pages(mpnt));
 			continue;
 		}
 		charge = 0;
diff -puN mm/debug.c~mm-rework-virtual-memory-accounting mm/debug.c
--- a/mm/debug.c~mm-rework-virtual-memory-accounting
+++ a/mm/debug.c
@@ -175,7 +175,7 @@ void dump_mm(const struct mm_struct *mm)
 		"mmap_base %lu mmap_legacy_base %lu highest_vm_end %lu\n"
 		"pgd %p mm_users %d mm_count %d nr_ptes %lu nr_pmds %lu map_count %d\n"
 		"hiwater_rss %lx hiwater_vm %lx total_vm %lx locked_vm %lx\n"
-		"pinned_vm %lx shared_vm %lx exec_vm %lx stack_vm %lx\n"
+		"pinned_vm %lx data_vm %lx exec_vm %lx stack_vm %lx\n"
 		"start_code %lx end_code %lx start_data %lx end_data %lx\n"
 		"start_brk %lx brk %lx start_stack %lx\n"
 		"arg_start %lx arg_end %lx env_start %lx env_end %lx\n"
@@ -209,7 +209,7 @@ void dump_mm(const struct mm_struct *mm)
 		mm_nr_pmds((struct mm_struct *)mm),
 		mm->map_count,
 		mm->hiwater_rss, mm->hiwater_vm, mm->total_vm, mm->locked_vm,
-		mm->pinned_vm, mm->shared_vm, mm->exec_vm, mm->stack_vm,
+		mm->pinned_vm, mm->data_vm, mm->exec_vm, mm->stack_vm,
 		mm->start_code, mm->end_code, mm->start_data, mm->end_data,
 		mm->start_brk, mm->brk, mm->start_stack,
 		mm->arg_start, mm->arg_end, mm->env_start, mm->env_end,
diff -puN mm/mmap.c~mm-rework-virtual-memory-accounting mm/mmap.c
--- a/mm/mmap.c~mm-rework-virtual-memory-accounting
+++ a/mm/mmap.c
@@ -1220,24 +1220,6 @@ none:
 	return NULL;
 }
 
-#ifdef CONFIG_PROC_FS
-void vm_stat_account(struct mm_struct *mm, unsigned long flags,
-						struct file *file, long pages)
-{
-	const unsigned long stack_flags
-		= VM_STACK_FLAGS & (VM_GROWSUP|VM_GROWSDOWN);
-
-	mm->total_vm += pages;
-
-	if (file) {
-		mm->shared_vm += pages;
-		if ((flags & (VM_EXEC|VM_WRITE)) == VM_EXEC)
-			mm->exec_vm += pages;
-	} else if (flags & stack_flags)
-		mm->stack_vm += pages;
-}
-#endif /* CONFIG_PROC_FS */
-
 /*
  * If a hint addr is less than mmap_min_addr change hint to be as
  * low as possible but still greater than mmap_min_addr
@@ -1556,7 +1538,7 @@ unsigned long mmap_region(struct file *f
 	unsigned long charged = 0;
 
 	/* Check against address space limit. */
-	if (!may_expand_vm(mm, len >> PAGE_SHIFT)) {
+	if (!may_expand_vm(mm, vm_flags, len >> PAGE_SHIFT)) {
 		unsigned long nr_pages;
 
 		/*
@@ -1565,7 +1547,8 @@ unsigned long mmap_region(struct file *f
 		 */
 		nr_pages = count_vma_pages_range(mm, addr, addr + len);
 
-		if (!may_expand_vm(mm, (len >> PAGE_SHIFT) - nr_pages))
+		if (!may_expand_vm(mm, vm_flags,
+					(len >> PAGE_SHIFT) - nr_pages))
 			return -ENOMEM;
 	}
 
@@ -1664,7 +1647,7 @@ unsigned long mmap_region(struct file *f
 out:
 	perf_event_mmap(vma);
 
-	vm_stat_account(mm, vm_flags, file, len >> PAGE_SHIFT);
+	vm_stat_account(mm, vm_flags, len >> PAGE_SHIFT);
 	if (vm_flags & VM_LOCKED) {
 		if (!((vm_flags & VM_SPECIAL) || is_vm_hugetlb_page(vma) ||
 					vma == get_gate_vma(current->mm)))
@@ -2111,7 +2094,7 @@ static int acct_stack_growth(struct vm_a
 	unsigned long new_start, actual_size;
 
 	/* address space limit tests */
-	if (!may_expand_vm(mm, grow))
+	if (!may_expand_vm(mm, vma->vm_flags, grow))
 		return -ENOMEM;
 
 	/* Stack limit test */
@@ -2208,8 +2191,7 @@ int expand_upwards(struct vm_area_struct
 				spin_lock(&mm->page_table_lock);
 				if (vma->vm_flags & VM_LOCKED)
 					mm->locked_vm += grow;
-				vm_stat_account(mm, vma->vm_flags,
-						vma->vm_file, grow);
+				vm_stat_account(mm, vma->vm_flags, grow);
 				anon_vma_interval_tree_pre_update_vma(vma);
 				vma->vm_end = address;
 				anon_vma_interval_tree_post_update_vma(vma);
@@ -2284,8 +2266,7 @@ int expand_downwards(struct vm_area_stru
 				spin_lock(&mm->page_table_lock);
 				if (vma->vm_flags & VM_LOCKED)
 					mm->locked_vm += grow;
-				vm_stat_account(mm, vma->vm_flags,
-						vma->vm_file, grow);
+				vm_stat_account(mm, vma->vm_flags, grow);
 				anon_vma_interval_tree_pre_update_vma(vma);
 				vma->vm_start = address;
 				vma->vm_pgoff -= grow;
@@ -2399,7 +2380,7 @@ static void remove_vma_list(struct mm_st
 
 		if (vma->vm_flags & VM_ACCOUNT)
 			nr_accounted += nrpages;
-		vm_stat_account(mm, vma->vm_flags, vma->vm_file, -nrpages);
+		vm_stat_account(mm, vma->vm_flags, -nrpages);
 		vma = remove_vma(vma);
 	} while (vma);
 	vm_unacct_memory(nr_accounted);
@@ -2769,7 +2750,7 @@ static unsigned long do_brk(unsigned lon
 	}
 
 	/* Check against address space limits *after* clearing old maps... */
-	if (!may_expand_vm(mm, len >> PAGE_SHIFT))
+	if (!may_expand_vm(mm, flags, len >> PAGE_SHIFT))
 		return -ENOMEM;
 
 	if (mm->map_count > sysctl_max_map_count)
@@ -2804,6 +2785,7 @@ static unsigned long do_brk(unsigned lon
 out:
 	perf_event_mmap(vma);
 	mm->total_vm += len >> PAGE_SHIFT;
+	mm->data_vm += len >> PAGE_SHIFT;
 	if (flags & VM_LOCKED)
 		mm->locked_vm += (len >> PAGE_SHIFT);
 	vma->vm_flags |= VM_SOFTDIRTY;
@@ -2995,9 +2977,28 @@ out:
  * Return true if the calling process may expand its vm space by the passed
  * number of pages
  */
-int may_expand_vm(struct mm_struct *mm, unsigned long npages)
+bool may_expand_vm(struct mm_struct *mm, vm_flags_t flags, unsigned long npages)
 {
-	return mm->total_vm + npages <= rlimit(RLIMIT_AS) >> PAGE_SHIFT;
+	if (mm->total_vm + npages > rlimit(RLIMIT_AS) >> PAGE_SHIFT)
+		return false;
+
+	if ((flags & (VM_WRITE | VM_SHARED | (VM_STACK_FLAGS &
+				(VM_GROWSUP | VM_GROWSDOWN)))) == VM_WRITE)
+		return mm->data_vm + npages <= rlimit(RLIMIT_DATA);
+
+	return true;
+}
+
+void vm_stat_account(struct mm_struct *mm, vm_flags_t flags, long npages)
+{
+	mm->total_vm += npages;
+
+	if ((flags & (VM_EXEC | VM_WRITE)) == VM_EXEC)
+		mm->exec_vm += npages;
+	else if (flags & (VM_STACK_FLAGS & (VM_GROWSUP | VM_GROWSDOWN)))
+		mm->stack_vm += npages;
+	else if ((flags & (VM_WRITE | VM_SHARED)) == VM_WRITE)
+		mm->data_vm += npages;
 }
 
 static int special_mapping_fault(struct vm_area_struct *vma,
@@ -3079,7 +3080,7 @@ static struct vm_area_struct *__install_
 	if (ret)
 		goto out;
 
-	mm->total_vm += len >> PAGE_SHIFT;
+	vm_stat_account(mm, vma->vm_flags, len >> PAGE_SHIFT);
 
 	perf_event_mmap(vma);
 
diff -puN mm/mprotect.c~mm-rework-virtual-memory-accounting mm/mprotect.c
--- a/mm/mprotect.c~mm-rework-virtual-memory-accounting
+++ a/mm/mprotect.c
@@ -278,6 +278,10 @@ mprotect_fixup(struct vm_area_struct *vm
 	 * even if read-only so there is no need to account for them here
 	 */
 	if (newflags & VM_WRITE) {
+		/* Check space limits when area turns into data. */
+		if (!may_expand_vm(mm, newflags, nrpages) &&
+				may_expand_vm(mm, oldflags, nrpages))
+			return -ENOMEM;
 		if (!(oldflags & (VM_ACCOUNT|VM_WRITE|VM_HUGETLB|
 						VM_SHARED|VM_NORESERVE))) {
 			charged = nrpages;
@@ -334,8 +338,8 @@ success:
 		populate_vma_page_range(vma, start, end, NULL);
 	}
 
-	vm_stat_account(mm, oldflags, vma->vm_file, -nrpages);
-	vm_stat_account(mm, newflags, vma->vm_file, nrpages);
+	vm_stat_account(mm, oldflags, -nrpages);
+	vm_stat_account(mm, newflags, nrpages);
 	perf_event_mmap(vma);
 	return 0;
 
diff -puN mm/mremap.c~mm-rework-virtual-memory-accounting mm/mremap.c
--- a/mm/mremap.c~mm-rework-virtual-memory-accounting
+++ a/mm/mremap.c
@@ -317,7 +317,7 @@ static unsigned long move_vma(struct vm_
 	 * If this were a serious issue, we'd add a flag to do_munmap().
 	 */
 	hiwater_vm = mm->hiwater_vm;
-	vm_stat_account(mm, vma->vm_flags, vma->vm_file, new_len>>PAGE_SHIFT);
+	vm_stat_account(mm, vma->vm_flags, new_len >> PAGE_SHIFT);
 
 	if (do_munmap(mm, old_addr, old_len) < 0) {
 		/* OOM: unable to split vma, just get accounts right */
@@ -379,7 +379,8 @@ static struct vm_area_struct *vma_to_res
 			return ERR_PTR(-EAGAIN);
 	}
 
-	if (!may_expand_vm(mm, (new_len - old_len) >> PAGE_SHIFT))
+	if (!may_expand_vm(mm, vma->vm_flags,
+				(new_len - old_len) >> PAGE_SHIFT))
 		return ERR_PTR(-ENOMEM);
 
 	if (vma->vm_flags & VM_ACCOUNT) {
@@ -541,7 +542,7 @@ SYSCALL_DEFINE5(mremap, unsigned long, a
 				goto out;
 			}
 
-			vm_stat_account(mm, vma->vm_flags, vma->vm_file, pages);
+			vm_stat_account(mm, vma->vm_flags, pages);
 			if (vma->vm_flags & VM_LOCKED) {
 				mm->locked_vm += pages;
 				locked = true;
_

Patches currently in -mm which might be from koct9i@gmail.com are

mm-rework-virtual-memory-accounting.patch

