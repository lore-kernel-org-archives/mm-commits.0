From: akpm@linux-foundation.org
Subject: + drivers-video-omap2-displays-add-missing-mutex_unlock.patch added to -mm tree
Date: Tue, 01 Jun 2010 14:19:01 -0700
Message-ID: <201006012119.o51LJ1x4019287@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57311 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757454Ab0FAVTr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Jun 2010 17:19:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, isely@pobox.com, mchehab@infradead.org


The patch titled
     drivers/video/omap2/displays: add missing mutex_unlock
has been added to the -mm tree.  Its filename is
     drivers-video-omap2-displays-add-missing-mutex_unlock.patch

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
Subject: drivers/video/omap2/displays: add missing mutex_unlock
From: Julia Lawall <julia@diku.dk>

Add a mutex_unlock missing on the error paths.  The use of the mutex is
balanced elsewhere in the file.

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
Acked-By: Mike Isely <isely@pobox.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/omap2/displays/panel-acx565akm.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/video/omap2/displays/panel-acx565akm.c~drivers-video-omap2-displays-add-missing-mutex_unlock drivers/video/omap2/displays/panel-acx565akm.c
--- a/drivers/video/omap2/displays/panel-acx565akm.c~drivers-video-omap2-displays-add-missing-mutex_unlock
+++ a/drivers/video/omap2/displays/panel-acx565akm.c
@@ -592,7 +592,7 @@ static int acx_panel_power_on(struct oma
 	r = omapdss_sdi_display_enable(dssdev);
 	if (r) {
 		pr_err("%s sdi enable failed\n", __func__);
-		return r;
+		goto fail_unlock;
 	}
 
 	/*FIXME tweak me */
@@ -633,6 +633,8 @@ static int acx_panel_power_on(struct oma
 	return acx565akm_bl_update_status(md->bl_dev);
 fail:
 	omapdss_sdi_display_disable(dssdev);
+fail_unlock:
+	mutex_unlock(&md->mutex);
 	return r;
 }
 
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

