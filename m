From: akpm@linux-foundation.org
Subject: + drivers-staging-vme-bridges-add-missing-unlocks.patch added to -mm tree
Date: Tue, 01 Jun 2010 14:19:10 -0700
Message-ID: <201006012119.o51LJADH019319@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42902 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757422Ab0FAVTS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Jun 2010 17:19:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, gregkh@suse.de, martyn.welch@ge.com


The patch titled
     drivers/staging/vme/bridges: add missing unlocks
has been added to the -mm tree.  Its filename is
     drivers-staging-vme-bridges-add-missing-unlocks.patch

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
Subject: drivers/staging/vme/bridges: add missing unlocks
From: Julia Lawall <julia@diku.dk>

Add a spin_unlock and mutex_unlock missing on the error path.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression E1;
@@

* spin_lock(E1,...);
  <+... when != E1
  if (...) {
    ... when != E1
*   return ...;
  }
  ...+>
* spin_unlock(E1,...);
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Martyn Welch <martyn.welch@ge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/vme/bridges/vme_ca91cx42.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/staging/vme/bridges/vme_ca91cx42.c~drivers-staging-vme-bridges-add-missing-unlocks drivers/staging/vme/bridges/vme_ca91cx42.c
--- a/drivers/staging/vme/bridges/vme_ca91cx42.c~drivers-staging-vme-bridges-add-missing-unlocks
+++ a/drivers/staging/vme/bridges/vme_ca91cx42.c
@@ -900,7 +900,8 @@ unsigned int ca91cx42_master_rmw(struct 
 	/* Address must be 4-byte aligned */
 	if (pci_addr & 0x3) {
 		dev_err(dev, "RMW Address not 4-byte aligned\n");
-		return -EINVAL;
+		result = -EINVAL;
+		goto out;
 	}
 
 	/* Ensure RMW Disabled whilst configuring */
@@ -921,6 +922,7 @@ unsigned int ca91cx42_master_rmw(struct 
 	/* Disable RMW */
 	iowrite32(0, bridge->base + SCYC_CTL);
 
+out:
 	spin_unlock(&(image->lock));
 
 	mutex_unlock(&(bridge->vme_rmw));
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

