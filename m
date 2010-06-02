From: akpm@linux-foundation.org
Subject: + drivers-usb-serial-eliminate-a-null-pointer-dereference.patch added to -mm tree
Date: Tue, 01 Jun 2010 22:57:41 -0700
Message-ID: <201006020557.o525vcqo007927@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42485 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752231Ab0FBF5o (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Jun 2010 01:57:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, greg@kroah.com


The patch titled
     drivers/usb/serial: eliminate a NULL pointer dereference
has been added to the -mm tree.  Its filename is
     drivers-usb-serial-eliminate-a-null-pointer-dereference.patch

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
Subject: drivers/usb/serial: eliminate a NULL pointer dereference
From: Julia Lawall <julia@diku.dk>

If port is NULL, then the call to dev_err will dereference a value that is
a small offset from NULL.

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
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/serial/digi_acceleport.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/usb/serial/digi_acceleport.c~drivers-usb-serial-eliminate-a-null-pointer-dereference drivers/usb/serial/digi_acceleport.c
--- a/drivers/usb/serial/digi_acceleport.c~drivers-usb-serial-eliminate-a-null-pointer-dereference
+++ a/drivers/usb/serial/digi_acceleport.c
@@ -1239,8 +1239,7 @@ static void digi_write_bulk_callback(str
 
 	/* port and serial sanity check */
 	if (port == NULL || (priv = usb_get_serial_port_data(port)) == NULL) {
-		dev_err(&port->dev,
-			"%s: port or port->private is NULL, status=%d\n",
+		pr_err("%s: port or port->private is NULL, status=%d\n",
 			__func__, status);
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

