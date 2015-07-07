From: akpm@linux-foundation.org
Subject: + mm-mlock-refactor-mlock-munlock-and-munlockall-code.patch added to -mm tree
Date: Tue, 07 Jul 2015 14:16:34 -0700
Message-ID: <559c41b2.Pr3RQEEZPCDa1+Zg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58374 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933482AbbGGVQf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Jul 2015 17:16:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: emunson@akamai.com, mhocko@suse.cz, mtk.manpages@gmail.com, shuahkh@osg.samsung.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: mlock: refactor mlock, munlock, and munlockall code
has been added to the -mm tree.  Its filename is
     mm-mlock-refactor-mlock-munlock-and-munlockall-code.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mlock-refactor-mlock-munlock-and-munlockall-code.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mlock-refactor-mlock-munlock-and-munlockall-code.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Eric B Munson <emunson@akamai.com>
Subject: mm: mlock: refactor mlock, munlock, and munlockall code

mlock() allows a user to control page out of program memory, but this
comes at the cost of faulting in the entire mapping when it is allocated. 
For large mappings where the entire area is not necessary this is not
ideal.  Instead of forcing all locked pages to be present when they are
allocated, this set creates a middle ground.  Pages are marked to be
placed on the unevictable LRU (locked) when they are first used, but they
are not faulted in by the mlock call.

This series introduces a new mlock() system call that takes a flags
argument along with the start address and size.  This flags argument gives
the caller the ability to request memory be locked in the traditional way,
or to be locked after the page is faulted in.  New calls are added for
munlock() and munlockall() which give the called a way to specify which
flags are supposed to be cleared.  A new MCL flag is added to mirror the
lock on fault behavior from mlock() in mlockall().  Finally, a flag for
mmap() is added that allows a user to specify that the covered are should
not be paged out, but only after the memory has been used the first time.

There are two main use cases that this set covers.  The first is the
security focussed mlock case.  A buffer is needed that cannot be written
to swap.  The maximum size is known, but on average the memory used is
significantly less than this maximum.  With lock on fault, the buffer is
guaranteed to never be paged out without consuming the maximum size every
time such a buffer is created.

The second use case is focussed on performance.  Portions of a large file
are needed and we want to keep the used portions in memory once accessed. 
This is the case for large graphical models where the path through the
graph is not known until run time.  The entire graph is unlikely to be
used in a given invocation, but once a node has been used it needs to stay
resident for further processing.  Given these constraints we have a number
of options.  We can potentially waste a large amount of memory by mlocking
the entire region (this can also cause a significant stall at startup as
the entire file is read in).  We can mlock every page as we access them
without tracking if the page is already resident but this introduces large
overhead for each access.  The third option is mapping the entire region
with PROT_NONE and using a signal handler for SIGSEGV to
mprotect(PROT_READ) and mlock() the needed page.  Doing this page at a
time adds a significant performance penalty.  Batching can be used to
mitigate this overhead, but in order to safely avoid trying to mprotect
pages outside of the mapping, the boundaries of each mapping to be used in
this way must be tracked and available to the signal handler.  This is
precisely what the mm system in the kernel should already be doing.

For mlock(MLOCK_ONFAULT) and mmap(MAP_LOCKONFAULT) the user is charged
against RLIMIT_MEMLOCK as if mlock(MLOCK_LOCKED) or mmap(MAP_LOCKED) was
used, so when the VMA is created not when the pages are faulted in.  For
mlockall(MCL_ONFAULT) the user is charged as if MCL_FUTURE was used.  This
decision was made to keep the accounting checks out of the page fault
path.

To illustrate the benefit of this set I wrote a test program that mmaps a
5 GB file filled with random data and then makes 15,000,000 accesses to
random addresses in that mapping.  The test program was run 20 times for
each setup.  Results are reported for two program portions, setup and
execution.  The setup phase is calling mmap and optionally mlock on the
entire region.  For most experiments this is trivial, but it highlights
the cost of faulting in the entire region.  Results are averages across
the 20 runs in milliseconds.

mmap with mlock(MLOCK_LOCKED) on entire range:
Setup avg:      8228.666
Processing avg: 8274.257

mmap with mlock(MLOCK_LOCKED) before each access:
Setup avg:      0.113
Processing avg: 90993.552

mmap with PROT_NONE and signal handler and batch size of 1 page: With the
default value in max_map_count, this gets ENOMEM as I attempt to change
the permissions, after upping the sysctl significantly I get: Setup avg:
0.058 Processing avg: 69488.073

mmap with PROT_NONE and signal handler and batch size of 8 pages:
Setup avg:      0.068
Processing avg: 38204.116

mmap with PROT_NONE and signal handler and batch size of 16 pages:
Setup avg:      0.044
Processing avg: 29671.180

mmap with mlock(MLOCK_ONFAULT) on entire range:
Setup avg:      0.189
Processing avg: 17904.899

The signal handler in the batch cases faulted in memory in two steps to
avoid having to know the start and end of the faulting mapping.  The first
step covers the page that caused the fault as we know that it will be
possible to lock.  The second step speculatively tries to mlock and
mprotect the batch size - 1 pages that follow.  There may be a clever way
to avoid this without having the program track each mapping to be covered
by this handeler in a globally accessible structure, but I could not find
it.  It should be noted that with a large enough batch size this two step
fault handler can still cause the program to crash if it reaches far
beyond the end of the mapping.

These results show that if the developer knows that a majority of the
mapping will be used, it is better to try and fault it in at once,
otherwise MAP_LOCKONFAULT is significantly faster.

The performance cost of these patches are minimal on the two benchmarks I
have tested (stream and kernbench).  The following are the average values
across 20 runs of stream and 10 runs of kernbench after a warmup run whose
results were discarded.

Avg throughput in MB/s from stream using 1000000 element arrays
Test     4.2-rc1      4.2-rc1+lock-on-fault
Copy:    10,566.5     10,421
Scale:   10,685       10,503.5
Add:     12,044.1     11,814.2
Triad:   12,064.8     11,846.3

Kernbench optimal load
                 4.2-rc1  4.2-rc1+lock-on-fault
Elapsed Time     78.453   78.991
User Time        64.2395  65.2355
System Time      9.7335   9.7085
Context Switches 22211.5  22412.1
Sleeps           14965.3  14956.1


This patch (of 5):

With the exception of mlockall() none of the mlock family of system calls
take a flags argument so they are not extensible.  A later patch in this
set will extend the mlock family to support a middle ground between pages
that are locked and faulted in immediately and unlocked pages.  To pave
the way for the new system calls, the code needs some reorganization so
that all the actual entry points handle is checking input and translating
to VMA flags.

This patch mostly moves code around with the exception of do_munlockall().
All three functions are changed to support a follow on patch which
introduces new system calls that allow the user to specify flags for these
calls.

Signed-off-by: Eric B Munson <emunson@akamai.com>
Cc: Shuah Khan <shuahkh@osg.samsung.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mlock.c |   57 +++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 46 insertions(+), 11 deletions(-)

diff -puN mm/mlock.c~mm-mlock-refactor-mlock-munlock-and-munlockall-code mm/mlock.c
--- a/mm/mlock.c~mm-mlock-refactor-mlock-munlock-and-munlockall-code
+++ a/mm/mlock.c
@@ -553,7 +553,8 @@ out:
 	return ret;
 }
 
-static int do_mlock(unsigned long start, size_t len, int on)
+static int apply_vma_flags(unsigned long start, size_t len,
+			   vm_flags_t flags, bool add_flags)
 {
 	unsigned long nstart, end, tmp;
 	struct vm_area_struct * vma, * prev;
@@ -579,9 +580,11 @@ static int do_mlock(unsigned long start,
 
 		/* Here we know that  vma->vm_start <= nstart < vma->vm_end. */
 
-		newflags = vma->vm_flags & ~VM_LOCKED;
-		if (on)
-			newflags |= VM_LOCKED;
+		newflags = vma->vm_flags;
+		if (add_flags)
+			newflags |= flags;
+		else
+			newflags &= ~flags;
 
 		tmp = vma->vm_end;
 		if (tmp > end)
@@ -604,7 +607,7 @@ static int do_mlock(unsigned long start,
 	return error;
 }
 
-SYSCALL_DEFINE2(mlock, unsigned long, start, size_t, len)
+static int do_mlock(unsigned long start, size_t len, vm_flags_t flags)
 {
 	unsigned long locked;
 	unsigned long lock_limit;
@@ -628,7 +631,7 @@ SYSCALL_DEFINE2(mlock, unsigned long, st
 
 	/* check against resource limits */
 	if ((locked <= lock_limit) || capable(CAP_IPC_LOCK))
-		error = do_mlock(start, len, 1);
+		error = apply_vma_flags(start, len, flags, true);
 
 	up_write(&current->mm->mmap_sem);
 	if (error)
@@ -640,7 +643,12 @@ SYSCALL_DEFINE2(mlock, unsigned long, st
 	return 0;
 }
 
-SYSCALL_DEFINE2(munlock, unsigned long, start, size_t, len)
+SYSCALL_DEFINE2(mlock, unsigned long, start, size_t, len)
+{
+	return do_mlock(start, len, VM_LOCKED);
+}
+
+static int do_munlock(unsigned long start, size_t len, vm_flags_t flags)
 {
 	int ret;
 
@@ -648,20 +656,23 @@ SYSCALL_DEFINE2(munlock, unsigned long,
 	start &= PAGE_MASK;
 
 	down_write(&current->mm->mmap_sem);
-	ret = do_mlock(start, len, 0);
+	ret = apply_vma_flags(start, len, flags, false);
 	up_write(&current->mm->mmap_sem);
 
 	return ret;
 }
 
+SYSCALL_DEFINE2(munlock, unsigned long, start, size_t, len)
+{
+	return do_munlock(start, len, VM_LOCKED);
+}
+
 static int do_mlockall(int flags)
 {
 	struct vm_area_struct * vma, * prev = NULL;
 
 	if (flags & MCL_FUTURE)
 		current->mm->def_flags |= VM_LOCKED;
-	else
-		current->mm->def_flags &= ~VM_LOCKED;
 	if (flags == MCL_FUTURE)
 		goto out;
 
@@ -711,12 +722,36 @@ out:
 	return ret;
 }
 
+static int do_munlockall(int flags)
+{
+	struct vm_area_struct * vma, * prev = NULL;
+
+	if (flags & MCL_FUTURE)
+		current->mm->def_flags &= ~VM_LOCKED;
+	if (flags == MCL_FUTURE)
+		goto out;
+
+	for (vma = current->mm->mmap; vma ; vma = prev->vm_next) {
+		vm_flags_t newflags;
+
+		newflags = vma->vm_flags;
+		if (flags & MCL_CURRENT)
+			newflags &= ~VM_LOCKED;
+
+		/* Ignore errors */
+		mlock_fixup(vma, &prev, vma->vm_start, vma->vm_end, newflags);
+		cond_resched_rcu_qs();
+	}
+out:
+	return 0;
+}
+
 SYSCALL_DEFINE0(munlockall)
 {
 	int ret;
 
 	down_write(&current->mm->mmap_sem);
-	ret = do_mlockall(0);
+	ret = do_munlockall(MCL_CURRENT | MCL_FUTURE);
 	up_write(&current->mm->mmap_sem);
 	return ret;
 }
_

Patches currently in -mm which might be from emunson@akamai.com are

mm-mlock-refactor-mlock-munlock-and-munlockall-code.patch
mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls.patch
mm-mlock-introduce-vm_lockonfault-and-add-mlock-flags-to-enable-it.patch
mm-mmap-add-mmap-flag-to-request-vm_lockonfault.patch
selftests-vm-add-tests-for-lock-on-fault.patch

