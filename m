From: akpm@linux-foundation.org
Subject: [merged] mm-kill-vma-flag-vm_executable-and-mm-num_exe_file_vmas.patch removed from -mm tree
Date: Tue, 09 Oct 2012 11:06:11 -0700
Message-ID: <20121009180612.3E0A91E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:62892 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730Ab2JISGO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Oct 2012 14:06:14 -0400
Received: by mail-gg0-f202.google.com with SMTP id i4so660175ggm.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Oct 2012 11:06:13 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khlebnikov@openvz.org, a.p.zijlstra@chello.nl, cmetcalf@tilera.com, cotte@de.ibm.com, eparis@redhat.com, gorcunov@openvz.org, hpa@zytor.com, hughd@google.com, james.l.morris@oracle.com, jbaron@redhat.com, matthltc@us.ibm.com, mingo@redhat.com, npiggin@kernel.dk, oleg@redhat.com, penguin-kernel@I-love.SAKURA.ne.jp, robert.richter@amd.com, suresh.b.siddha@intel.com, takedakn@nttdata.co.jp, torvalds@linux-foundation.org, venki@google.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: kill vma flag VM_EXECUTABLE and mm->num_exe_file_vmas
has been removed from the -mm tree.  Its filename was
     mm-kill-vma-flag-vm_executable-and-mm-num_exe_file_vmas.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: mm: kill vma flag VM_EXECUTABLE and mm->num_exe_file_vmas

Currently the kernel sets mm->exe_file during sys_execve() and then tracks
number of vmas with VM_EXECUTABLE flag in mm->num_exe_file_vmas, as soon
as this counter drops to zero kernel resets mm->exe_file to NULL.  Plus it
resets mm->exe_file at last mmput() when mm->mm_users drops to zero.

VMA with VM_EXECUTABLE flag appears after mapping file with flag
MAP_EXECUTABLE, such vmas can appears only at sys_execve() or after vma
splitting, because sys_mmap ignores this flag.  Usually binfmt module sets
mm->exe_file and mmaps executable vmas with this file, they hold
mm->exe_file while task is running.

comment from v2.6.25-6245-g925d1c4 ("procfs task exe symlink"),
where all this stuff was introduced:

> The kernel implements readlink of /proc/pid/exe by getting the file from
> the first executable VMA.  Then the path to the file is reconstructed and
> reported as the result.
>
> Because of the VMA walk the code is slightly different on nommu systems.
> This patch avoids separate /proc/pid/exe code on nommu systems.  Instead of
> walking the VMAs to find the first executable file-backed VMA we store a
> reference to the exec'd file in the mm_struct.
>
> That reference would prevent the filesystem holding the executable file
> from being unmounted even after unmapping the VMAs.  So we track the number
> of VM_EXECUTABLE VMAs and drop the new reference when the last one is
> unmapped.  This avoids pinning the mounted filesystem.

exe_file's vma accounting is hooked into every file mmap/unmmap and vma
split/merge just to fix some hypothetical pinning fs from umounting by mm,
which already unmapped all its executable files, but still alive.

Seems like currently nobody depends on this behaviour.  We can try to
remove this logic and keep mm->exe_file until final mmput().

mm->exe_file is still protected with mm->mmap_sem, because we want to
change it via new sys_prctl(PR_SET_MM_EXE_FILE).  Also via this syscall
task can change its mm->exe_file and unpin mountpoint explicitly.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Carsten Otte <cotte@de.ibm.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Eric Paris <eparis@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Morris <james.l.morris@oracle.com>
Cc: Jason Baron <jbaron@redhat.com>
Cc: Kentaro Takeda <takedakn@nttdata.co.jp>
Cc: Matt Helsley <matthltc@us.ibm.com>
Cc: Nick Piggin <npiggin@kernel.dk>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Robert Richter <robert.richter@amd.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Venkatesh Pallipadi <venki@google.com>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h       |    4 ----
 include/linux/mm_types.h |    1 -
 include/linux/mman.h     |    1 -
 kernel/fork.c            |   21 ---------------------
 mm/mmap.c                |   25 ++++---------------------
 mm/nommu.c               |   11 +----------
 6 files changed, 5 insertions(+), 58 deletions(-)

diff -puN include/linux/mm.h~mm-kill-vma-flag-vm_executable-and-mm-num_exe_file_vmas include/linux/mm.h
--- a/include/linux/mm.h~mm-kill-vma-flag-vm_executable-and-mm-num_exe_file_vmas
+++ a/include/linux/mm.h
@@ -87,7 +87,6 @@ extern unsigned int kobjsize(const void 
 #define VM_PFNMAP	0x00000400	/* Page-ranges managed without "struct page", just pure PFN */
 #define VM_DENYWRITE	0x00000800	/* ETXTBSY on write attempts.. */
 
-#define VM_EXECUTABLE	0x00001000
 #define VM_LOCKED	0x00002000
 #define VM_IO           0x00004000	/* Memory mapped I/O or similar */
 
@@ -1396,9 +1395,6 @@ extern void exit_mmap(struct mm_struct *
 extern int mm_take_all_locks(struct mm_struct *mm);
 extern void mm_drop_all_locks(struct mm_struct *mm);
 
-/* From fs/proc/base.c. callers must _not_ hold the mm's exe_file_lock */
-extern void added_exe_file_vma(struct mm_struct *mm);
-extern void removed_exe_file_vma(struct mm_struct *mm);
 extern void set_mm_exe_file(struct mm_struct *mm, struct file *new_exe_file);
 extern struct file *get_mm_exe_file(struct mm_struct *mm);
 
diff -puN include/linux/mm_types.h~mm-kill-vma-flag-vm_executable-and-mm-num_exe_file_vmas include/linux/mm_types.h
--- a/include/linux/mm_types.h~mm-kill-vma-flag-vm_executable-and-mm-num_exe_file_vmas
+++ a/include/linux/mm_types.h
@@ -394,7 +394,6 @@ struct mm_struct {
 
 	/* store ref to file /proc/<pid>/exe symlink points to */
 	struct file *exe_file;
-	unsigned long num_exe_file_vmas;
 #ifdef CONFIG_MMU_NOTIFIER
 	struct mmu_notifier_mm *mmu_notifier_mm;
 #endif
diff -puN include/linux/mman.h~mm-kill-vma-flag-vm_executable-and-mm-num_exe_file_vmas include/linux/mman.h
--- a/include/linux/mman.h~mm-kill-vma-flag-vm_executable-and-mm-num_exe_file_vmas
+++ a/include/linux/mman.h
@@ -86,7 +86,6 @@ calc_vm_flag_bits(unsigned long flags)
 {
 	return _calc_vm_trans(flags, MAP_GROWSDOWN,  VM_GROWSDOWN ) |
 	       _calc_vm_trans(flags, MAP_DENYWRITE,  VM_DENYWRITE ) |
-	       _calc_vm_trans(flags, MAP_EXECUTABLE, VM_EXECUTABLE) |
 	       _calc_vm_trans(flags, MAP_LOCKED,     VM_LOCKED    );
 }
 #endif /* __KERNEL__ */
diff -puN kernel/fork.c~mm-kill-vma-flag-vm_executable-and-mm-num_exe_file_vmas kernel/fork.c
--- a/kernel/fork.c~mm-kill-vma-flag-vm_executable-and-mm-num_exe_file_vmas
+++ a/kernel/fork.c
@@ -622,26 +622,6 @@ void mmput(struct mm_struct *mm)
 }
 EXPORT_SYMBOL_GPL(mmput);
 
-/*
- * We added or removed a vma mapping the executable. The vmas are only mapped
- * during exec and are not mapped with the mmap system call.
- * Callers must hold down_write() on the mm's mmap_sem for these
- */
-void added_exe_file_vma(struct mm_struct *mm)
-{
-	mm->num_exe_file_vmas++;
-}
-
-void removed_exe_file_vma(struct mm_struct *mm)
-{
-	mm->num_exe_file_vmas--;
-	if ((mm->num_exe_file_vmas == 0) && mm->exe_file) {
-		fput(mm->exe_file);
-		mm->exe_file = NULL;
-	}
-
-}
-
 void set_mm_exe_file(struct mm_struct *mm, struct file *new_exe_file)
 {
 	if (new_exe_file)
@@ -649,7 +629,6 @@ void set_mm_exe_file(struct mm_struct *m
 	if (mm->exe_file)
 		fput(mm->exe_file);
 	mm->exe_file = new_exe_file;
-	mm->num_exe_file_vmas = 0;
 }
 
 struct file *get_mm_exe_file(struct mm_struct *mm)
diff -puN mm/mmap.c~mm-kill-vma-flag-vm_executable-and-mm-num_exe_file_vmas mm/mmap.c
--- a/mm/mmap.c~mm-kill-vma-flag-vm_executable-and-mm-num_exe_file_vmas
+++ a/mm/mmap.c
@@ -231,11 +231,8 @@ static struct vm_area_struct *remove_vma
 	might_sleep();
 	if (vma->vm_ops && vma->vm_ops->close)
 		vma->vm_ops->close(vma);
-	if (vma->vm_file) {
+	if (vma->vm_file)
 		fput(vma->vm_file);
-		if (vma->vm_flags & VM_EXECUTABLE)
-			removed_exe_file_vma(vma->vm_mm);
-	}
 	mpol_put(vma_policy(vma));
 	kmem_cache_free(vm_area_cachep, vma);
 	return next;
@@ -636,8 +633,6 @@ again:			remove_next = 1 + (end > next->
 		if (file) {
 			uprobe_munmap(next, next->vm_start, next->vm_end);
 			fput(file);
-			if (next->vm_flags & VM_EXECUTABLE)
-				removed_exe_file_vma(mm);
 		}
 		if (next->anon_vma)
 			anon_vma_merge(vma, next);
@@ -1304,8 +1299,6 @@ munmap_back:
 		error = file->f_op->mmap(file, vma);
 		if (error)
 			goto unmap_and_free_vma;
-		if (vm_flags & VM_EXECUTABLE)
-			added_exe_file_vma(mm);
 
 		/* Can addr have changed??
 		 *
@@ -1987,11 +1980,8 @@ static int __split_vma(struct mm_struct 
 	if (anon_vma_clone(new, vma))
 		goto out_free_mpol;
 
-	if (new->vm_file) {
+	if (new->vm_file)
 		get_file(new->vm_file);
-		if (vma->vm_flags & VM_EXECUTABLE)
-			added_exe_file_vma(mm);
-	}
 
 	if (new->vm_ops && new->vm_ops->open)
 		new->vm_ops->open(new);
@@ -2009,11 +1999,8 @@ static int __split_vma(struct mm_struct 
 	/* Clean everything up if vma_adjust failed. */
 	if (new->vm_ops && new->vm_ops->close)
 		new->vm_ops->close(new);
-	if (new->vm_file) {
-		if (vma->vm_flags & VM_EXECUTABLE)
-			removed_exe_file_vma(mm);
+	if (new->vm_file)
 		fput(new->vm_file);
-	}
 	unlink_anon_vmas(new);
  out_free_mpol:
 	mpol_put(pol);
@@ -2408,12 +2395,8 @@ struct vm_area_struct *copy_vma(struct v
 			new_vma->vm_start = addr;
 			new_vma->vm_end = addr + len;
 			new_vma->vm_pgoff = pgoff;
-			if (new_vma->vm_file) {
+			if (new_vma->vm_file)
 				get_file(new_vma->vm_file);
-
-				if (vma->vm_flags & VM_EXECUTABLE)
-					added_exe_file_vma(mm);
-			}
 			if (new_vma->vm_ops && new_vma->vm_ops->open)
 				new_vma->vm_ops->open(new_vma);
 			vma_link(mm, new_vma, prev, rb_link, rb_parent);
diff -puN mm/nommu.c~mm-kill-vma-flag-vm_executable-and-mm-num_exe_file_vmas mm/nommu.c
--- a/mm/nommu.c~mm-kill-vma-flag-vm_executable-and-mm-num_exe_file_vmas
+++ a/mm/nommu.c
@@ -789,11 +789,8 @@ static void delete_vma(struct mm_struct 
 	kenter("%p", vma);
 	if (vma->vm_ops && vma->vm_ops->close)
 		vma->vm_ops->close(vma);
-	if (vma->vm_file) {
+	if (vma->vm_file)
 		fput(vma->vm_file);
-		if (vma->vm_flags & VM_EXECUTABLE)
-			removed_exe_file_vma(mm);
-	}
 	put_nommu_region(vma->vm_region);
 	kmem_cache_free(vm_area_cachep, vma);
 }
@@ -1284,10 +1281,6 @@ unsigned long do_mmap_pgoff(struct file 
 	if (file) {
 		region->vm_file = get_file(file);
 		vma->vm_file = get_file(file);
-		if (vm_flags & VM_EXECUTABLE) {
-			added_exe_file_vma(current->mm);
-			vma->vm_mm = current->mm;
-		}
 	}
 
 	down_write(&nommu_region_sem);
@@ -1440,8 +1433,6 @@ error:
 	kmem_cache_free(vm_region_jar, region);
 	if (vma->vm_file)
 		fput(vma->vm_file);
-	if (vma->vm_flags & VM_EXECUTABLE)
-		removed_exe_file_vma(vma->vm_mm);
 	kmem_cache_free(vm_area_cachep, vma);
 	kleave(" = %d", ret);
 	return ret;
_

Patches currently in -mm which might be from khlebnikov@openvz.org are

origin.patch
linux-next.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch

