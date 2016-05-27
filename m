From: akpm@linux-foundation.org
Subject: [merged]
 mm-make-mmap_sem-for-write-waits-killable-for-mm-syscalls.patch removed
 from -mm tree
Date: Fri, 27 May 2016 11:44:32 -0700
Message-ID: <57489590.CB/6mzHC7xsYXrlj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42603 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754154AbcE0Sod (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 May 2016 14:44:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, aarcange@redhat.com, dave.hansen@linux.intel.com, hannes@cmpxchg.org, hughd@google.com, kirill.shutemov@linux.intel.com, koct9i@gmail.com, mgorman@suse.de, rientjes@google.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: make mmap_sem for write waits killable for mm syscalls
has been removed from the -mm tree.  Its filename was
     mm-make-mmap_sem-for-write-waits-killable-for-mm-syscalls.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm: make mmap_sem for write waits killable for mm syscalls

This is a follow up work for oom_reaper [1].  As the async OOM killing
depends on oom_sem for read we would really appreciate if a holder for
write didn't stood in the way.  This patchset is changing many of
down_write calls to be killable to help those cases when the writer is
blocked and waiting for readers to release the lock and so help
__oom_reap_task to process the oom victim.

Most of the patches are really trivial because the lock is help from a
shallow syscall paths where we can return EINTR trivially and allow the
current task to die (note that EINTR will never get to the userspace as
the task has fatal signal pending).  Others seem to be easy as well as the
callers are already handling fatal errors and bail and return to userspace
which should be sufficient to handle the failure gracefully.  I am not
familiar with all those code paths so a deeper review is really
appreciated.

As this work is touching more areas which are not directly connected I
have tried to keep the CC list as small as possible and people who I
believed would be familiar are CCed only to the specific patches (all
should have received the cover though).

This patchset is based on linux-next and it depends on down_write_killable
for rw_semaphores which got merged into tip locking/rwsem branch and it is
merged into this next tree.  I guess it would be easiest to route these
patches via mmotm because of the dependency on the tip tree but if
respective maintainers prefer other way I have no objections.

I haven't covered all the mmap_write(mm->mmap_sem) instances here

$ git grep "down_write(.*\<mmap_sem\>)" next/master | wc -l
98
$ git grep "down_write(.*\<mmap_sem\>)" | wc -l
62

I have tried to cover those which should be relatively easy to review in
this series because this alone should be a nice improvement. Other places
can be changed on top.

[0] http://lkml.kernel.org/r/1456752417-9626-1-git-send-email-mhocko@kernel.org
[1] http://lkml.kernel.org/r/1452094975-551-1-git-send-email-mhocko@kernel.org
[2] http://lkml.kernel.org/r/1456750705-7141-1-git-send-email-mhocko@kernel.org


This patch (of 18):

This is the first step in making mmap_sem write waiters killable. It
focuses on the trivial ones which are taking the lock early after
entering the syscall and they are not changing state before.

Therefore it is very easy to change them to use down_write_killable
and immediately return with -EINTR. This will allow the waiter to
pass away without blocking the mmap_sem which might be required to
make a forward progress. E.g. the oom reaper will need the lock for
reading to dismantle the OOM victim address space.

The only tricky function in this patch is vm_mmap_pgoff which has many
call sites via vm_mmap. To reduce the risk keep vm_mmap with the
original non-killable semantic for now.

vm_munmap callers do not bother checking the return value so open code
it into the munmap syscall path for now for simplicity.

Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@suse.de>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    5 +++--
 mm/madvise.c  |    8 +++++---
 mm/mlock.c    |   16 ++++++++++------
 mm/mmap.c     |   27 +++++++++++++++++++++++----
 mm/mprotect.c |    3 ++-
 mm/mremap.c   |    3 ++-
 mm/nommu.c    |    2 +-
 mm/util.c     |   12 +++++++++---
 8 files changed, 55 insertions(+), 21 deletions(-)

diff -puN mm/internal.h~mm-make-mmap_sem-for-write-waits-killable-for-mm-syscalls mm/internal.h
--- a/mm/internal.h~mm-make-mmap_sem-for-write-waits-killable-for-mm-syscalls
+++ a/mm/internal.h
@@ -442,9 +442,10 @@ extern u64 hwpoison_filter_flags_value;
 extern u64 hwpoison_filter_memcg;
 extern u32 hwpoison_filter_enable;
 
-extern unsigned long vm_mmap_pgoff(struct file *, unsigned long,
+extern unsigned long  __must_check vm_mmap_pgoff(struct file *, unsigned long,
         unsigned long, unsigned long,
-        unsigned long, unsigned long);
+        unsigned long, unsigned long,
+        bool);
 
 extern void set_pageblock_order(void);
 unsigned long reclaim_clean_pages_from_list(struct zone *zone,
diff -puN mm/madvise.c~mm-make-mmap_sem-for-write-waits-killable-for-mm-syscalls mm/madvise.c
--- a/mm/madvise.c~mm-make-mmap_sem-for-write-waits-killable-for-mm-syscalls
+++ a/mm/madvise.c
@@ -707,10 +707,12 @@ SYSCALL_DEFINE3(madvise, unsigned long,
 		return error;
 
 	write = madvise_need_mmap_write(behavior);
-	if (write)
-		down_write(&current->mm->mmap_sem);
-	else
+	if (write) {
+		if (down_write_killable(&current->mm->mmap_sem))
+			return -EINTR;
+	} else {
 		down_read(&current->mm->mmap_sem);
+	}
 
 	/*
 	 * If the interval [start,end) covers some unmapped address
diff -puN mm/mlock.c~mm-make-mmap_sem-for-write-waits-killable-for-mm-syscalls mm/mlock.c
--- a/mm/mlock.c~mm-make-mmap_sem-for-write-waits-killable-for-mm-syscalls
+++ a/mm/mlock.c
@@ -617,7 +617,7 @@ static int apply_vma_lock_flags(unsigned
 	return error;
 }
 
-static int do_mlock(unsigned long start, size_t len, vm_flags_t flags)
+static __must_check int do_mlock(unsigned long start, size_t len, vm_flags_t flags)
 {
 	unsigned long locked;
 	unsigned long lock_limit;
@@ -635,7 +635,8 @@ static int do_mlock(unsigned long start,
 	lock_limit >>= PAGE_SHIFT;
 	locked = len >> PAGE_SHIFT;
 
-	down_write(&current->mm->mmap_sem);
+	if (down_write_killable(&current->mm->mmap_sem))
+		return -EINTR;
 
 	locked += current->mm->locked_vm;
 
@@ -678,7 +679,8 @@ SYSCALL_DEFINE2(munlock, unsigned long,
 	len = PAGE_ALIGN(len + (offset_in_page(start)));
 	start &= PAGE_MASK;
 
-	down_write(&current->mm->mmap_sem);
+	if (down_write_killable(&current->mm->mmap_sem))
+		return -EINTR;
 	ret = apply_vma_lock_flags(start, len, 0);
 	up_write(&current->mm->mmap_sem);
 
@@ -748,9 +750,10 @@ SYSCALL_DEFINE1(mlockall, int, flags)
 	lock_limit = rlimit(RLIMIT_MEMLOCK);
 	lock_limit >>= PAGE_SHIFT;
 
-	ret = -ENOMEM;
-	down_write(&current->mm->mmap_sem);
+	if (down_write_killable(&current->mm->mmap_sem))
+		return -EINTR;
 
+	ret = -ENOMEM;
 	if (!(flags & MCL_CURRENT) || (current->mm->total_vm <= lock_limit) ||
 	    capable(CAP_IPC_LOCK))
 		ret = apply_mlockall_flags(flags);
@@ -765,7 +768,8 @@ SYSCALL_DEFINE0(munlockall)
 {
 	int ret;
 
-	down_write(&current->mm->mmap_sem);
+	if (down_write_killable(&current->mm->mmap_sem))
+		return -EINTR;
 	ret = apply_mlockall_flags(0);
 	up_write(&current->mm->mmap_sem);
 	return ret;
diff -puN mm/mmap.c~mm-make-mmap_sem-for-write-waits-killable-for-mm-syscalls mm/mmap.c
--- a/mm/mmap.c~mm-make-mmap_sem-for-write-waits-killable-for-mm-syscalls
+++ a/mm/mmap.c
@@ -178,7 +178,8 @@ SYSCALL_DEFINE1(brk, unsigned long, brk)
 	unsigned long min_brk;
 	bool populate;
 
-	down_write(&mm->mmap_sem);
+	if (down_write_killable(&mm->mmap_sem))
+		return -EINTR;
 
 #ifdef CONFIG_COMPAT_BRK
 	/*
@@ -1332,7 +1333,7 @@ SYSCALL_DEFINE6(mmap_pgoff, unsigned lon
 
 	flags &= ~(MAP_EXECUTABLE | MAP_DENYWRITE);
 
-	retval = vm_mmap_pgoff(file, addr, len, prot, flags, pgoff);
+	retval = vm_mmap_pgoff(file, addr, len, prot, flags, pgoff, true);
 out_fput:
 	if (file)
 		fput(file);
@@ -2493,6 +2494,10 @@ int vm_munmap(unsigned long start, size_
 	int ret;
 	struct mm_struct *mm = current->mm;
 
+	/*
+	 * XXX convert to down_write_killable as soon as all users are able
+	 * to handle the error.
+	 */
 	down_write(&mm->mmap_sem);
 	ret = do_munmap(mm, start, len);
 	up_write(&mm->mmap_sem);
@@ -2502,8 +2507,15 @@ EXPORT_SYMBOL(vm_munmap);
 
 SYSCALL_DEFINE2(munmap, unsigned long, addr, size_t, len)
 {
+	int ret;
+	struct mm_struct *mm = current->mm;
+
 	profile_munmap(addr);
-	return vm_munmap(addr, len);
+	if (down_write_killable(&mm->mmap_sem))
+		return -EINTR;
+	ret = do_munmap(mm, addr, len);
+	up_write(&mm->mmap_sem);
+	return ret;
 }
 
 
@@ -2535,7 +2547,9 @@ SYSCALL_DEFINE5(remap_file_pages, unsign
 	if (pgoff + (size >> PAGE_SHIFT) < pgoff)
 		return ret;
 
-	down_write(&mm->mmap_sem);
+	if (down_write_killable(&mm->mmap_sem))
+		return -EINTR;
+
 	vma = find_vma(mm, start);
 
 	if (!vma || !(vma->vm_flags & VM_SHARED))
@@ -2700,6 +2714,11 @@ unsigned long vm_brk(unsigned long addr,
 	unsigned long ret;
 	bool populate;
 
+	/*
+	 * XXX not all users are chcecking the return value, convert
+	 * to down_write_killable after they are able to cope with
+	 * error
+	 */
 	down_write(&mm->mmap_sem);
 	ret = do_brk(addr, len);
 	populate = ((mm->def_flags & VM_LOCKED) != 0);
diff -puN mm/mprotect.c~mm-make-mmap_sem-for-write-waits-killable-for-mm-syscalls mm/mprotect.c
--- a/mm/mprotect.c~mm-make-mmap_sem-for-write-waits-killable-for-mm-syscalls
+++ a/mm/mprotect.c
@@ -379,7 +379,8 @@ SYSCALL_DEFINE3(mprotect, unsigned long,
 
 	reqprot = prot;
 
-	down_write(&current->mm->mmap_sem);
+	if (down_write_killable(&current->mm->mmap_sem))
+		return -EINTR;
 
 	vma = find_vma(current->mm, start);
 	error = -ENOMEM;
diff -puN mm/mremap.c~mm-make-mmap_sem-for-write-waits-killable-for-mm-syscalls mm/mremap.c
--- a/mm/mremap.c~mm-make-mmap_sem-for-write-waits-killable-for-mm-syscalls
+++ a/mm/mremap.c
@@ -503,7 +503,8 @@ SYSCALL_DEFINE5(mremap, unsigned long, a
 	if (!new_len)
 		return ret;
 
-	down_write(&current->mm->mmap_sem);
+	if (down_write_killable(&current->mm->mmap_sem))
+		return -EINTR;
 
 	if (flags & MREMAP_FIXED) {
 		ret = mremap_to(addr, old_len, new_addr, new_len,
diff -puN mm/nommu.c~mm-make-mmap_sem-for-write-waits-killable-for-mm-syscalls mm/nommu.c
--- a/mm/nommu.c~mm-make-mmap_sem-for-write-waits-killable-for-mm-syscalls
+++ a/mm/nommu.c
@@ -1446,7 +1446,7 @@ SYSCALL_DEFINE6(mmap_pgoff, unsigned lon
 
 	flags &= ~(MAP_EXECUTABLE | MAP_DENYWRITE);
 
-	retval = vm_mmap_pgoff(file, addr, len, prot, flags, pgoff);
+	retval = vm_mmap_pgoff(file, addr, len, prot, flags, pgoff, true);
 
 	if (file)
 		fput(file);
diff -puN mm/util.c~mm-make-mmap_sem-for-write-waits-killable-for-mm-syscalls mm/util.c
--- a/mm/util.c~mm-make-mmap_sem-for-write-waits-killable-for-mm-syscalls
+++ a/mm/util.c
@@ -289,7 +289,7 @@ EXPORT_SYMBOL_GPL(get_user_pages_fast);
 
 unsigned long vm_mmap_pgoff(struct file *file, unsigned long addr,
 	unsigned long len, unsigned long prot,
-	unsigned long flag, unsigned long pgoff)
+	unsigned long flag, unsigned long pgoff, bool killable)
 {
 	unsigned long ret;
 	struct mm_struct *mm = current->mm;
@@ -297,7 +297,12 @@ unsigned long vm_mmap_pgoff(struct file
 
 	ret = security_mmap_file(file, prot, flag);
 	if (!ret) {
-		down_write(&mm->mmap_sem);
+		if (killable) {
+			if (down_write_killable(&mm->mmap_sem))
+				return -EINTR;
+		} else {
+			down_write(&mm->mmap_sem);
+		}
 		ret = do_mmap_pgoff(file, addr, len, prot, flag, pgoff,
 				    &populate);
 		up_write(&mm->mmap_sem);
@@ -307,6 +312,7 @@ unsigned long vm_mmap_pgoff(struct file
 	return ret;
 }
 
+/* XXX are all callers checking an error */
 unsigned long vm_mmap(struct file *file, unsigned long addr,
 	unsigned long len, unsigned long prot,
 	unsigned long flag, unsigned long offset)
@@ -316,7 +322,7 @@ unsigned long vm_mmap(struct file *file,
 	if (unlikely(offset_in_page(offset)))
 		return -EINVAL;
 
-	return vm_mmap_pgoff(file, addr, len, prot, flag, offset >> PAGE_SHIFT);
+	return vm_mmap_pgoff(file, addr, len, prot, flag, offset >> PAGE_SHIFT, false);
 }
 EXPORT_SYMBOL(vm_mmap);
 
_

Patches currently in -mm which might be from mhocko@suse.com are

oom_reaper-close-race-with-exiting-task.patch

