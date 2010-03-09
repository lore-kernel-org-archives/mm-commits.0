From: akpm@linux-foundation.org
Subject: [merged] mm-use-rlimit-helpers.patch removed from -mm tree
Date: Tue, 09 Mar 2010 11:03:17 -0800
Message-ID: <201003091903.o29J3HVP030957@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50411 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755639Ab0CITDW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:03:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jslaby@suse.cz, mm-commits@vger.kernel.org


The patch titled
     mm: use rlimit helpers
has been removed from the -mm tree.  Its filename was
     mm-use-rlimit-helpers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: use rlimit helpers
From: Jiri Slaby <jslaby@suse.cz>

Make sure compiler won't do weird things with limits.  E.g.  fetching them
twice may return 2 different values after writable limits are implemented.

I.e.  either use rlimit helpers added in
3e10e716abf3c71bdb5d86b8f507f9e72236c9cd ("resource: add helpers for
fetching rlimits") or ACCESS_ONCE if not applicable.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    2 +-
 mm/mlock.c   |   12 ++++++------
 mm/mmap.c    |   13 +++++++------
 mm/mremap.c  |    2 +-
 4 files changed, 15 insertions(+), 14 deletions(-)

diff -puN mm/filemap.c~mm-use-rlimit-helpers mm/filemap.c
--- a/mm/filemap.c~mm-use-rlimit-helpers
+++ a/mm/filemap.c
@@ -1986,7 +1986,7 @@ EXPORT_SYMBOL(iov_iter_single_seg_count)
 inline int generic_write_checks(struct file *file, loff_t *pos, size_t *count, int isblk)
 {
 	struct inode *inode = file->f_mapping->host;
-	unsigned long limit = current->signal->rlim[RLIMIT_FSIZE].rlim_cur;
+	unsigned long limit = rlimit(RLIMIT_FSIZE);
 
         if (unlikely(*pos < 0))
                 return -EINVAL;
diff -puN mm/mlock.c~mm-use-rlimit-helpers mm/mlock.c
--- a/mm/mlock.c~mm-use-rlimit-helpers
+++ a/mm/mlock.c
@@ -25,7 +25,7 @@ int can_do_mlock(void)
 {
 	if (capable(CAP_IPC_LOCK))
 		return 1;
-	if (current->signal->rlim[RLIMIT_MEMLOCK].rlim_cur != 0)
+	if (rlimit(RLIMIT_MEMLOCK) != 0)
 		return 1;
 	return 0;
 }
@@ -487,7 +487,7 @@ SYSCALL_DEFINE2(mlock, unsigned long, st
 	locked = len >> PAGE_SHIFT;
 	locked += current->mm->locked_vm;
 
-	lock_limit = current->signal->rlim[RLIMIT_MEMLOCK].rlim_cur;
+	lock_limit = rlimit(RLIMIT_MEMLOCK);
 	lock_limit >>= PAGE_SHIFT;
 
 	/* check against resource limits */
@@ -550,7 +550,7 @@ SYSCALL_DEFINE1(mlockall, int, flags)
 
 	down_write(&current->mm->mmap_sem);
 
-	lock_limit = current->signal->rlim[RLIMIT_MEMLOCK].rlim_cur;
+	lock_limit = rlimit(RLIMIT_MEMLOCK);
 	lock_limit >>= PAGE_SHIFT;
 
 	ret = -ENOMEM;
@@ -584,7 +584,7 @@ int user_shm_lock(size_t size, struct us
 	int allowed = 0;
 
 	locked = (size + PAGE_SIZE - 1) >> PAGE_SHIFT;
-	lock_limit = current->signal->rlim[RLIMIT_MEMLOCK].rlim_cur;
+	lock_limit = rlimit(RLIMIT_MEMLOCK);
 	if (lock_limit == RLIM_INFINITY)
 		allowed = 1;
 	lock_limit >>= PAGE_SHIFT;
@@ -618,12 +618,12 @@ int account_locked_memory(struct mm_stru
 
 	down_write(&mm->mmap_sem);
 
-	lim = rlim[RLIMIT_AS].rlim_cur >> PAGE_SHIFT;
+	lim = ACCESS_ONCE(rlim[RLIMIT_AS].rlim_cur) >> PAGE_SHIFT;
 	vm   = mm->total_vm + pgsz;
 	if (lim < vm)
 		goto out;
 
-	lim = rlim[RLIMIT_MEMLOCK].rlim_cur >> PAGE_SHIFT;
+	lim = ACCESS_ONCE(rlim[RLIMIT_MEMLOCK].rlim_cur) >> PAGE_SHIFT;
 	vm   = mm->locked_vm + pgsz;
 	if (lim < vm)
 		goto out;
diff -puN mm/mmap.c~mm-use-rlimit-helpers mm/mmap.c
--- a/mm/mmap.c~mm-use-rlimit-helpers
+++ a/mm/mmap.c
@@ -265,7 +265,7 @@ SYSCALL_DEFINE1(brk, unsigned long, brk)
 	 * segment grow beyond its set limit the in case where the limit is
 	 * not page aligned -Ram Gupta
 	 */
-	rlim = current->signal->rlim[RLIMIT_DATA].rlim_cur;
+	rlim = rlimit(RLIMIT_DATA);
 	if (rlim < RLIM_INFINITY && (brk - mm->start_brk) +
 			(mm->end_data - mm->start_data) > rlim)
 		goto out;
@@ -967,7 +967,7 @@ unsigned long do_mmap_pgoff(struct file 
 		unsigned long locked, lock_limit;
 		locked = len >> PAGE_SHIFT;
 		locked += mm->locked_vm;
-		lock_limit = current->signal->rlim[RLIMIT_MEMLOCK].rlim_cur;
+		lock_limit = rlimit(RLIMIT_MEMLOCK);
 		lock_limit >>= PAGE_SHIFT;
 		if (locked > lock_limit && !capable(CAP_IPC_LOCK))
 			return -EAGAIN;
@@ -1594,7 +1594,7 @@ static int acct_stack_growth(struct vm_a
 		return -ENOMEM;
 
 	/* Stack limit test */
-	if (size > rlim[RLIMIT_STACK].rlim_cur)
+	if (size > ACCESS_ONCE(rlim[RLIMIT_STACK].rlim_cur))
 		return -ENOMEM;
 
 	/* mlock limit tests */
@@ -1602,7 +1602,8 @@ static int acct_stack_growth(struct vm_a
 		unsigned long locked;
 		unsigned long limit;
 		locked = mm->locked_vm + grow;
-		limit = rlim[RLIMIT_MEMLOCK].rlim_cur >> PAGE_SHIFT;
+		limit = ACCESS_ONCE(rlim[RLIMIT_MEMLOCK].rlim_cur);
+		limit >>= PAGE_SHIFT;
 		if (locked > limit && !capable(CAP_IPC_LOCK))
 			return -ENOMEM;
 	}
@@ -2067,7 +2068,7 @@ unsigned long do_brk(unsigned long addr,
 		unsigned long locked, lock_limit;
 		locked = len >> PAGE_SHIFT;
 		locked += mm->locked_vm;
-		lock_limit = current->signal->rlim[RLIMIT_MEMLOCK].rlim_cur;
+		lock_limit = rlimit(RLIMIT_MEMLOCK);
 		lock_limit >>= PAGE_SHIFT;
 		if (locked > lock_limit && !capable(CAP_IPC_LOCK))
 			return -EAGAIN;
@@ -2281,7 +2282,7 @@ int may_expand_vm(struct mm_struct *mm, 
 	unsigned long cur = mm->total_vm;	/* pages */
 	unsigned long lim;
 
-	lim = current->signal->rlim[RLIMIT_AS].rlim_cur >> PAGE_SHIFT;
+	lim = rlimit(RLIMIT_AS) >> PAGE_SHIFT;
 
 	if (cur + npages > lim)
 		return 0;
diff -puN mm/mremap.c~mm-use-rlimit-helpers mm/mremap.c
--- a/mm/mremap.c~mm-use-rlimit-helpers
+++ a/mm/mremap.c
@@ -285,7 +285,7 @@ static struct vm_area_struct *vma_to_res
 	if (vma->vm_flags & VM_LOCKED) {
 		unsigned long locked, lock_limit;
 		locked = mm->locked_vm << PAGE_SHIFT;
-		lock_limit = current->signal->rlim[RLIMIT_MEMLOCK].rlim_cur;
+		lock_limit = rlimit(RLIMIT_MEMLOCK);
 		locked += new_len - old_len;
 		if (locked > lock_limit && !capable(CAP_IPC_LOCK))
 			goto Eagain;
_

Patches currently in -mm which might be from jslaby@suse.cz are

linux-next.patch
bootmem-avoid-dma32-zone-by-default.patch
ipc-use-rlimit-helpers.patch
edac-add-__init-to-i7core_xeon_pci_fixup.patch

