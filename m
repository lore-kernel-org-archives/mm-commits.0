From: akpm@linux-foundation.org
Subject: + mm-mmapc-add-mlock_future_check-helper.patch added to -mm tree
Date: Tue, 03 Dec 2013 14:57:59 -0800
Message-ID: <529e61f7.gOITz+qo6VfGSNl+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54937 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755151Ab3LCW6A (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Dec 2013 17:58:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, walken@google.com, vbabka@suse.cz, riel@redhat.com, davidlohr@hp.com

Subject: + mm-mmapc-add-mlock_future_check-helper.patch added to -mm tree
To: davidlohr@hp.com,riel@redhat.com,vbabka@suse.cz,walken@google.com
From: akpm@linux-foundation.org
Date: Tue, 03 Dec 2013 14:57:59 -0800


The patch titled
     Subject: mm/mmap.c: add mlock_future_check() helper
has been added to the -mm tree.  Its filename is
     mm-mmapc-add-mlock_future_check-helper.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mmapc-add-mlock_future_check-helper.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mmapc-add-mlock_future_check-helper.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Davidlohr Bueso <davidlohr@hp.com>
Subject: mm/mmap.c: add mlock_future_check() helper

Both do_brk and do_mmap_pgoff verify that we are actually capable of
locking future pages if the corresponding VM_LOCKED flags are used. 
Encapsulate this logic into a single mlock_future_check() helper function.

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
Cc: Rik van Riel <riel@redhat.com>
Reviewed-by: Michel Lespinasse <walken@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   45 +++++++++++++++++++++++----------------------
 1 file changed, 23 insertions(+), 22 deletions(-)

diff -puN mm/mmap.c~mm-mmapc-add-mlock_future_check-helper mm/mmap.c
--- a/mm/mmap.c~mm-mmapc-add-mlock_future_check-helper
+++ a/mm/mmap.c
@@ -1215,6 +1215,24 @@ static inline unsigned long round_hint_t
 	return hint;
 }
 
+static inline int mlock_future_check(struct mm_struct *mm,
+				     unsigned long flags,
+				     unsigned long len)
+{
+	unsigned long locked, lock_limit;
+
+	/*  mlock MCL_FUTURE? */
+	if (flags & VM_LOCKED) {
+		locked = len >> PAGE_SHIFT;
+		locked += mm->locked_vm;
+		lock_limit = rlimit(RLIMIT_MEMLOCK);
+		lock_limit >>= PAGE_SHIFT;
+		if (locked > lock_limit && !capable(CAP_IPC_LOCK))
+			return -EAGAIN;
+	}
+	return 0;
+}
+
 /*
  * The caller must hold down_write(&current->mm->mmap_sem).
  */
@@ -1276,16 +1294,8 @@ unsigned long do_mmap_pgoff(struct file
 		if (!can_do_mlock())
 			return -EPERM;
 
-	/* mlock MCL_FUTURE? */
-	if (vm_flags & VM_LOCKED) {
-		unsigned long locked, lock_limit;
-		locked = len >> PAGE_SHIFT;
-		locked += mm->locked_vm;
-		lock_limit = rlimit(RLIMIT_MEMLOCK);
-		lock_limit >>= PAGE_SHIFT;
-		if (locked > lock_limit && !capable(CAP_IPC_LOCK))
-			return -EAGAIN;
-	}
+	if (mlock_future_check(mm, vm_flags, len))
+		return -EAGAIN;
 
 	if (file) {
 		struct inode *inode = file_inode(file);
@@ -2616,18 +2626,9 @@ static unsigned long do_brk(unsigned lon
 	if (error & ~PAGE_MASK)
 		return error;
 
-	/*
-	 * mlock MCL_FUTURE?
-	 */
-	if (mm->def_flags & VM_LOCKED) {
-		unsigned long locked, lock_limit;
-		locked = len >> PAGE_SHIFT;
-		locked += mm->locked_vm;
-		lock_limit = rlimit(RLIMIT_MEMLOCK);
-		lock_limit >>= PAGE_SHIFT;
-		if (locked > lock_limit && !capable(CAP_IPC_LOCK))
-			return -EAGAIN;
-	}
+	error = mlock_future_check(mm, mm->def_flags, len);
+	if (error)
+		return error;
 
 	/*
 	 * mm->mmap_sem is required to protect against another thread
_

Patches currently in -mm which might be from davidlohr@hp.com are

mm-mmapc-add-mlock_future_check-helper.patch
mm-mlock-prepare-params-outside-critical-region.patch
ipc-semc-avoid-overflow-of-semop-undo-semadj-value.patch
ipc-semc-avoid-overflow-of-semop-undo-semadj-value-fix.patch

