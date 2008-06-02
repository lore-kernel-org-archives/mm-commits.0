From: akpm@linux-foundation.org
Subject: + splice-use-get_user_pages_fast.patch added to -mm tree
Date: Mon, 02 Jun 2008 16:57:48 -0700
Message-ID: <200806022357.m52NvmMm006443@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38694 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754561AbYFBX7M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Jun 2008 19:59:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de, andi@firstfloor.org, apw@shadowen.org, jens.axboe@oracle.com, mingo@elte.hu, pbadari@us.ibm.com, shaggy@austin.ibm.com, tglx@linutronix.de, zach.brown@oracle.com


The patch titled
     splice: use get_user_pages_fast
has been added to the -mm tree.  Its filename is
     splice-use-get_user_pages_fast.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: splice: use get_user_pages_fast
From: Nick Piggin <npiggin@suse.de>

Use get_user_pages_fast in splice.  This reverts some mmap_sem batching
there, however the biggest problem with mmap_sem tends to be hold times
blocking out other threads rather than cacheline bouncing.  Further: on
architectures that implement get_user_pages_fast without locks, mmap_sem
can be avoided completely anyway.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: Dave Kleikamp <shaggy@austin.ibm.com>
Cc: Andy Whitcroft <apw@shadowen.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Dave Kleikamp <shaggy@austin.ibm.com>
Cc: Badari Pulavarty <pbadari@us.ibm.com>
Cc: Zach Brown <zach.brown@oracle.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/splice.c |   41 +++--------------------------------------
 1 file changed, 3 insertions(+), 38 deletions(-)

diff -puN fs/splice.c~splice-use-get_user_pages_fast fs/splice.c
--- a/fs/splice.c~splice-use-get_user_pages_fast
+++ a/fs/splice.c
@@ -1154,36 +1154,6 @@ static long do_splice(struct file *in, l
 }
 
 /*
- * Do a copy-from-user while holding the mmap_semaphore for reading, in a
- * manner safe from deadlocking with simultaneous mmap() (grabbing mmap_sem
- * for writing) and page faulting on the user memory pointed to by src.
- * This assumes that we will very rarely hit the partial != 0 path, or this
- * will not be a win.
- */
-static int copy_from_user_mmap_sem(void *dst, const void __user *src, size_t n)
-{
-	int partial;
-
-	if (!access_ok(VERIFY_READ, src, n))
-		return -EFAULT;
-
-	pagefault_disable();
-	partial = __copy_from_user_inatomic(dst, src, n);
-	pagefault_enable();
-
-	/*
-	 * Didn't copy everything, drop the mmap_sem and do a faulting copy
-	 */
-	if (unlikely(partial)) {
-		up_read(&current->mm->mmap_sem);
-		partial = copy_from_user(dst, src, n);
-		down_read(&current->mm->mmap_sem);
-	}
-
-	return partial;
-}
-
-/*
  * Map an iov into an array of pages and offset/length tupples. With the
  * partial_page structure, we can map several non-contiguous ranges into
  * our ones pages[] map instead of splitting that operation into pieces.
@@ -1196,8 +1166,6 @@ static int get_iovec_page_array(const st
 {
 	int buffers = 0, error = 0;
 
-	down_read(&current->mm->mmap_sem);
-
 	while (nr_vecs) {
 		unsigned long off, npages;
 		struct iovec entry;
@@ -1206,7 +1174,7 @@ static int get_iovec_page_array(const st
 		int i;
 
 		error = -EFAULT;
-		if (copy_from_user_mmap_sem(&entry, iov, sizeof(entry)))
+		if (copy_from_user(&entry, iov, sizeof(entry)))
 			break;
 
 		base = entry.iov_base;
@@ -1240,9 +1208,8 @@ static int get_iovec_page_array(const st
 		if (npages > PIPE_BUFFERS - buffers)
 			npages = PIPE_BUFFERS - buffers;
 
-		error = get_user_pages(current, current->mm,
-				       (unsigned long) base, npages, 0, 0,
-				       &pages[buffers], NULL);
+		error = get_user_pages_fast((unsigned long)base, npages,
+					0, &pages[buffers]);
 
 		if (unlikely(error <= 0))
 			break;
@@ -1281,8 +1248,6 @@ static int get_iovec_page_array(const st
 		iov++;
 	}
 
-	up_read(&current->mm->mmap_sem);
-
 	if (buffers)
 		return buffers;
 
_

Patches currently in -mm which might be from npiggin@suse.de are

hugetlb-fix-lockdep-error.patch
linux-next.patch
spufs-convert-nopfn-to-fault.patch
vt-fix-vc_resize-locking.patch
mspec-convert-nopfn-to-fault.patch
mspec-convert-nopfn-to-fault-fix.patch
mm-remove-nopfn.patch
mm-remove-double-indirection-on-tlb-parameter-to-free_pgd_range-co.patch
x86-implement-pte_special.patch
mm-introduce-get_user_pages_fast.patch
mm-introduce-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast.patch
x86-lockless-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast-fix.patch
x86-lockless-get_user_pages_fast-fix-warning.patch
dio-use-get_user_pages_fast.patch
splice-use-get_user_pages_fast.patch
reiser4.patch
likeliness-accounting-change-and-cleanup.patch

