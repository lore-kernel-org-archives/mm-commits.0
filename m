From: akpm@linux-foundation.org
Subject: + idr-fix-idr_pre_get-locking-description.patch added to -mm tree
Date: Tue, 21 Sep 2010 15:52:36 -0700
Message-ID: <201009212252.o8LMqa0a007499@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44566 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752371Ab0IUWxL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Sep 2010 18:53:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: naota@elisp.net


The patch titled
     idr: fix idr_pre_get() locking description
has been added to the -mm tree.  Its filename is
     idr-fix-idr_pre_get-locking-description.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: idr: fix idr_pre_get() locking description
From: Naohiro Aota <naota@elisp.net>

Despite the idr_pre_get() kernel-doc, there are some cases where you can
call idr_pre_get() from within locked regions.  Add a description for such
cases.

See also: http://lkml.org/lkml/2010/9/16/462

Signed-off-by: Naohiro Aota <naota@elisp.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/idr.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff -puN lib/idr.c~idr-fix-idr_pre_get-locking-description lib/idr.c
--- a/lib/idr.c~idr-fix-idr_pre_get-locking-description
+++ a/lib/idr.c
@@ -110,9 +110,10 @@ static void idr_mark_full(struct idr_lay
  * @idp:	idr handle
  * @gfp_mask:	memory allocation flags
  *
- * This function should be called prior to locking and calling the
- * idr_get_new* functions. It preallocates enough memory to satisfy
- * the worst possible allocation.
+ * This function should be called prior to calling the idr_get_new*
+ * functions. It preallocates enough memory to satisfy the worst
+ * possible allocation. You can sleep in this function iff without
+ * holding spinlock.
  *
  * If the system is REALLY out of memory this function returns 0,
  * otherwise 1.
@@ -290,9 +291,8 @@ static int idr_get_new_above_int(struct 
  * This is the allocate id function.  It should be called with any
  * required locks.
  *
- * If memory is required, it will return -EAGAIN, you should unlock
- * and go back to the idr_pre_get() call.  If the idr is full, it will
- * return -ENOSPC.
+ * If memory is required, it will return -EAGAIN, you should go back to
+ * the idr_pre_get() call. If the idr is full, it will return -ENOSPC.
  *
  * @id returns a value in the range @starting_id ... 0x7fffffff
  */
@@ -321,9 +321,8 @@ EXPORT_SYMBOL(idr_get_new_above);
  * This is the allocate id function.  It should be called with any
  * required locks.
  *
- * If memory is required, it will return -EAGAIN, you should unlock
- * and go back to the idr_pre_get() call.  If the idr is full, it will
- * return -ENOSPC.
+ * If memory is required, it will return -EAGAIN, you should go back to
+ * the idr_pre_get() call. If the idr is full, it will return -ENOSPC.
  *
  * @id returns a value in the range 0 ... 0x7fffffff
  */
_

Patches currently in -mm which might be from naota@elisp.net are

linux-next.patch
idr-fix-idr_pre_get-locking-description.patch
idr-fix-idr_pre_get-locking-description-fix.patch

