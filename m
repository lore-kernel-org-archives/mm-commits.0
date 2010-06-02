From: akpm@linux-foundation.org
Subject: + drivers-media-eliminate-a-null-pointer-dereference.patch added to -mm tree
Date: Tue, 01 Jun 2010 22:57:47 -0700
Message-ID: <201006020557.o525vipZ007936@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36432 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752818Ab0FBF5v (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Jun 2010 01:57:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, mchehab@infradead.org


The patch titled
     drivers/media: eliminate a NULL pointer dereference
has been added to the -mm tree.  Its filename is
     drivers-media-eliminate-a-null-pointer-dereference.patch

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
Subject: drivers/media: eliminate a NULL pointer dereference
From: Julia Lawall <julia@diku.dk>

In each case, the print involves dereferencing a value that is NULL or is
near NULL.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@r exists@
expression E,E1;
identifier f;
statement S1,S2,S3;
@@

if ((E == NULL && ...) || ...)
{
  ... when != if (...) S1 else S2
      when != E = E1
* E->f
  ... when any
  return ...;
}
else S3
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/dvb/firewire/firedtv-1394.c       |    2 +-
 drivers/media/video/hdpvr/hdpvr-video.c         |    2 +-
 drivers/media/video/usbvision/usbvision-video.c |    3 +--
 3 files changed, 3 insertions(+), 4 deletions(-)

diff -puN drivers/media/dvb/firewire/firedtv-1394.c~drivers-media-eliminate-a-null-pointer-dereference drivers/media/dvb/firewire/firedtv-1394.c
--- a/drivers/media/dvb/firewire/firedtv-1394.c~drivers-media-eliminate-a-null-pointer-dereference
+++ a/drivers/media/dvb/firewire/firedtv-1394.c
@@ -58,7 +58,7 @@ static void rawiso_activity_cb(struct hp
 	num = hpsb_iso_n_ready(iso);
 
 	if (!fdtv) {
-		dev_err(fdtv->device, "received at unknown iso channel\n");
+		pr_err("received at unknown iso channel\n");
 		goto out;
 	}
 
diff -puN drivers/media/video/hdpvr/hdpvr-video.c~drivers-media-eliminate-a-null-pointer-dereference drivers/media/video/hdpvr/hdpvr-video.c
--- a/drivers/media/video/hdpvr/hdpvr-video.c~drivers-media-eliminate-a-null-pointer-dereference
+++ a/drivers/media/video/hdpvr/hdpvr-video.c
@@ -366,7 +366,7 @@ static int hdpvr_open(struct file *file)
 
 	dev = (struct hdpvr_device *)video_get_drvdata(video_devdata(file));
 	if (!dev) {
-		v4l2_err(&dev->v4l2_dev, "open failing with with ENODEV\n");
+		pr_err("open failing with with ENODEV\n");
 		retval = -ENODEV;
 		goto err;
 	}
diff -puN drivers/media/video/usbvision/usbvision-video.c~drivers-media-eliminate-a-null-pointer-dereference drivers/media/video/usbvision/usbvision-video.c
--- a/drivers/media/video/usbvision/usbvision-video.c~drivers-media-eliminate-a-null-pointer-dereference
+++ a/drivers/media/video/usbvision/usbvision-video.c
@@ -1671,8 +1671,7 @@ static void __devexit usbvision_disconne
 	PDEBUG(DBG_PROBE, "");
 
 	if (usbvision == NULL) {
-		dev_err(&usbvision->dev->dev,
-			"%s: usb_get_intfdata() failed\n", __func__);
+		pr_err("%s: usb_get_intfdata() failed\n", __func__);
 		return;
 	}
 
_

Patches currently in -mm which might be from julia@diku.dk are

origin.patch
linux-next.patch
arch-x86-kernel-add-missing-spin_unlock.patch
arch-x86-kernel-add-missing-spin_unlock-fix2.patch
fs-btrfs-use-memdup_user.patch
fs-btrfs-use-err_cast.patch
drivers-media-use-memdup_user.patch
drivers-media-video-pvrusb2-add-missing-mutex_unlock.patch
drivers-video-omap2-displays-add-missing-mutex_unlock.patch
drivers-i2c-use-memdup_user.patch
arch-ia64-kvm-add-missing-spin_unlock.patch
drivers-ide-use-memdup_user.patch
fs-ubifs-use-err_cast.patch
drivers-net-wireless-prism54-use-memdup_user.patch
fs-ocfs2-dlm-add-missing-spin_unlock.patch
drivers-s390-net-use-memdup_user.patch
drivers-scsi-libsas-use-sam_good.patch
drivers-scsi-remove-unnecessary-null-test.patch
drivers-message-move-dereference-after-null-test.patch
drivers-scsi-correct-the-size-argument-to-kmalloc.patch
drivers-scsi-use-memdup_user.patch
drivers-block-use-memdup_user.patch
drivers-staging-dream-camera-use-memdup_user.patch
drivers-staging-vme-bridges-add-missing-unlocks.patch
drivers-usb-gadget-use-memdup_user.patch
mm-use-memdup_user.patch
mm-use-err_cast.patch
drivers-message-i2o-exec-osmc-add-missing-mutex_unlock.patch
drivers-char-n_gsmc-add-missing-spin_unlock_irqrestore.patch
drivers-usb-serial-eliminate-a-null-pointer-dereference.patch
arch-sparc-kernel-eliminate-what-looks-like-a-null-pointer-dereference.patch
drivers-dma-eliminate-a-null-pointer-dereference.patch
drivers-media-eliminate-a-null-pointer-dereference.patch
drivers-staging-eliminate-a-null-pointer-dereference.patch

