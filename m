From: akpm@linux-foundation.org
Subject: + drivers-hid-eliminate-a-double-lock.patch added to -mm tree
Date: Mon, 21 Jun 2010 15:34:23 -0700
Message-ID: <201006212234.o5LMYN7B009070@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56547 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752010Ab0FUWeb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 Jun 2010 18:34:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, jkosina@suse.cz


The patch titled
     drivers/hid: eliminate a double lock
has been added to the -mm tree.  Its filename is
     drivers-hid-eliminate-a-double-lock.patch

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
Subject: drivers/hid: eliminate a double lock
From: Julia Lawall <julia@diku.dk>

The path around the loop ends with the lock held, so the call to mutex_lock
is moved before the beginning of the loop.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@locked@
expression E1;
position p;
@@

read_lock(E1@p,...);

@r exists@
expression x <= locked.E1;
expression locked.E1;
expression E2;
identifier lock;
position locked.p,p1,p2;
@@

*lock@p1 (E1@p,...);
... when != E1
    when != \(x = E2\|&x\)
*lock@p2 (E1,...);
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hid/hid-debug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/hid/hid-debug.c~drivers-hid-eliminate-a-double-lock drivers/hid/hid-debug.c
--- a/drivers/hid/hid-debug.c~drivers-hid-eliminate-a-double-lock
+++ a/drivers/hid/hid-debug.c
@@ -949,8 +949,8 @@ static ssize_t hid_debug_events_read(str
 	int ret = 0, len;
 	DECLARE_WAITQUEUE(wait, current);
 
+	mutex_lock(&list->read_mutex);
 	while (ret == 0) {
-		mutex_lock(&list->read_mutex);
 		if (list->head == list->tail) {
 			add_wait_queue(&list->hdev->debug_wait, &wait);
 			set_current_state(TASK_INTERRUPTIBLE);
_

Patches currently in -mm which might be from julia@diku.dk are

linux-next.patch
drivers-hid-eliminate-a-double-lock.patch
fs-btrfs-use-memdup_user.patch
fs-btrfs-use-err_cast.patch
drivers-dma-eliminate-a-null-pointer-dereference.patch
drivers-media-use-memdup_user.patch
drivers-media-video-pvrusb2-add-missing-mutex_unlock.patch
drivers-video-omap2-displays-add-missing-mutex_unlock.patch
drivers-s390-net-use-memdup_user.patch
drivers-scsi-libsas-use-sam_good.patch
drivers-scsi-remove-unnecessary-null-test.patch
drivers-message-move-dereference-after-null-test.patch
drivers-scsi-correct-the-size-argument-to-kmalloc.patch
drivers-scsi-use-memdup_user.patch
drivers-block-use-memdup_user.patch
arch-sparc-kernel-eliminate-what-looks-like-a-null-pointer-dereference.patch
mm-use-memdup_user.patch
mm-use-err_cast.patch
drivers-message-i2o-exec-osmc-add-missing-mutex_unlock.patch
drivers-char-n_gsmc-add-missing-spin_unlock_irqrestore.patch

