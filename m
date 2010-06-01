From: akpm@linux-foundation.org
Subject: + drivers-media-video-pvrusb2-add-missing-mutex_unlock.patch added to -mm tree
Date: Tue, 01 Jun 2010 14:18:56 -0700
Message-ID: <201006012118.o51LIuWG019281@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39150 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756682Ab0FAVTf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Jun 2010 17:19:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, hverkuil@xs4all.nl, isely@pobox.com, mchehab@infradead.org


The patch titled
     drivers/media/video/pvrusb2: add missing mutex_unlock
has been added to the -mm tree.  Its filename is
     drivers-media-video-pvrusb2-add-missing-mutex_unlock.patch

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
Subject: drivers/media/video/pvrusb2: add missing mutex_unlock
From: Julia Lawall <julia@diku.dk>

Add a mutex_unlock missing on the error path.  In the other functions in
the same file the locks and unlocks of this mutex appear to be balanced,
so it would seem that the same should hold in this case.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression E1;
@@

* mutex_lock(E1,...);
  <+... when != E1
  if (...) {
    ... when != E1
*   return ...;
  }
  ...+>
* mutex_unlock(E1,...);
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: Mike Isely <isely@pobox.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/pvrusb2/pvrusb2-ioread.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN drivers/media/video/pvrusb2/pvrusb2-ioread.c~drivers-media-video-pvrusb2-add-missing-mutex_unlock drivers/media/video/pvrusb2/pvrusb2-ioread.c
--- a/drivers/media/video/pvrusb2/pvrusb2-ioread.c~drivers-media-video-pvrusb2-add-missing-mutex_unlock
+++ a/drivers/media/video/pvrusb2/pvrusb2-ioread.c
@@ -223,7 +223,10 @@ int pvr2_ioread_setup(struct pvr2_ioread
 				   " pvr2_ioread_setup (setup) id=%p",cp);
 			pvr2_stream_kill(sp);
 			ret = pvr2_stream_set_buffer_count(sp,BUFFER_COUNT);
-			if (ret < 0) return ret;
+			if (ret < 0) {
+				mutex_unlock(&cp->mutex);
+				return ret;
+			}
 			for (idx = 0; idx < BUFFER_COUNT; idx++) {
 				bp = pvr2_stream_get_buffer(sp,idx);
 				pvr2_buffer_set_buffer(bp,
_

Patches currently in -mm which might be from julia@diku.dk are

origin.patch
linux-next.patch
fs-btrfs-use-memdup_user.patch
fs-btrfs-use-err_cast.patch
drivers-media-use-memdup_user.patch
drivers-i2c-use-memdup_user.patch
drivers-ide-use-memdup_user.patch
fs-ubifs-use-err_cast.patch
drivers-net-wireless-prism54-use-memdup_user.patch
drivers-s390-net-use-memdup_user.patch
drivers-scsi-libsas-use-sam_good.patch
drivers-scsi-remove-unnecessary-null-test.patch
drivers-message-move-dereference-after-null-test.patch
drivers-scsi-correct-the-size-argument-to-kmalloc.patch
drivers-scsi-use-memdup_user.patch
drivers-block-use-memdup_user.patch
drivers-staging-dream-camera-use-memdup_user.patch
drivers-usb-gadget-use-memdup_user.patch
mm-use-memdup_user.patch
mm-use-err_cast.patch
drivers-media-video-pvrusb2-add-missing-mutex_unlock.patch
arch-x86-kernel-add-missing-spin_unlock.patch
arch-ia64-kvm-add-missing-spin_unlock.patch
drivers-video-omap2-displays-add-missing-mutex_unlock.patch
drivers-message-i2o-exec-osmc-add-missing-mutex_unlock.patch
drivers-char-n_gsmc-add-missing-spin_unlock_irqrestore.patch
fs-ocfs2-dlm-add-missing-spin_unlock.patch
drivers-staging-vme-bridges-add-missing-unlocks.patch

