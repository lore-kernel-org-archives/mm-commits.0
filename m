From: akpm@linux-foundation.org
Subject: +
 mm-fix-overly-aggressive-shmdt-when-calls-span-multiple-segments.patch
 added to -mm tree
Date: Tue, 04 Nov 2014 14:20:32 -0800
Message-ID: <54595130.7RDLMxNLPkNtf7bL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48372 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753270AbaKDWUb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Nov 2014 17:20:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave.hansen@linux.intel.com, davidlohr@hp.com, manfred@colorfullife.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc/shm.c: fix overly aggressive shmdt() when calls span multiple segments
has been added to the -mm tree.  Its filename is
     mm-fix-overly-aggressive-shmdt-when-calls-span-multiple-segments.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fix-overly-aggressive-shmdt-when-calls-span-multiple-segments.patch
		echo and later at
		echo  http://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-overly-aggressive-shmdt-when-calls-span-multiple-segments.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dave Hansen <dave.hansen@linux.intel.com>
Subject: ipc/shm.c: fix overly aggressive shmdt() when calls span multiple segments

This is a highly-contrived scenario.  But, a single shmdt() call can be
induced in to unmapping memory from mulitple shm segments.  Example code
is here:

	http://www.sr71.net/~dave/intel/shmfun.c

The fix is pretty simple: Record the 'struct file' for the first VMA we
encounter and then stick to it.  Decline to unmap anything not from the
same file and thus the same segment.

I found this by inspection and the odds of anyone hitting this in practice
are pretty darn small.

Lightly tested, but it's a pretty small patch.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: Davidlohr Bueso <davidlohr@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/shm.c |   18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff -puN ipc/shm.c~mm-fix-overly-aggressive-shmdt-when-calls-span-multiple-segments ipc/shm.c
--- a/ipc/shm.c~mm-fix-overly-aggressive-shmdt-when-calls-span-multiple-segments
+++ a/ipc/shm.c
@@ -1229,6 +1229,7 @@ SYSCALL_DEFINE1(shmdt, char __user *, sh
 	int retval = -EINVAL;
 #ifdef CONFIG_MMU
 	loff_t size = 0;
+	struct file *file;
 	struct vm_area_struct *next;
 #endif
 
@@ -1245,7 +1246,8 @@ SYSCALL_DEFINE1(shmdt, char __user *, sh
 	 *   started at address shmaddr. It records it's size and then unmaps
 	 *   it.
 	 * - Then it unmaps all shm vmas that started at shmaddr and that
-	 *   are within the initially determined size.
+	 *   are within the initially determined size and that are from the
+	 *   same shm segment from which we determined the size.
 	 * Errors from do_munmap are ignored: the function only fails if
 	 * it's called with invalid parameters or if it's called to unmap
 	 * a part of a vma. Both calls in this function are for full vmas,
@@ -1271,8 +1273,14 @@ SYSCALL_DEFINE1(shmdt, char __user *, sh
 		if ((vma->vm_ops == &shm_vm_ops) &&
 			(vma->vm_start - addr)/PAGE_SIZE == vma->vm_pgoff) {
 
-
-			size = file_inode(vma->vm_file)->i_size;
+			/*
+			 * Record the file of the shm segment being
+			 * unmapped.  With mremap(), someone could place
+			 * page from another segment but with equal offsets
+			 * in the range we are unmapping.
+			 */
+			file = vma->vm_file;
+			size = file_inode(file)->i_size;
 			do_munmap(mm, vma->vm_start, vma->vm_end - vma->vm_start);
 			/*
 			 * We discovered the size of the shm segment, so
@@ -1298,8 +1306,8 @@ SYSCALL_DEFINE1(shmdt, char __user *, sh
 
 		/* finding a matching vma now does not alter retval */
 		if ((vma->vm_ops == &shm_vm_ops) &&
-			(vma->vm_start - addr)/PAGE_SIZE == vma->vm_pgoff)
