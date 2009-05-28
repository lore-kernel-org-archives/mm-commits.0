From: akpm@linux-foundation.org
Subject: + virtio_blk-add-missing-__devinitexit-markings.patch added to -mm tree
Date: Wed, 27 May 2009 23:25:06 -0700
Message-ID: <200905280625.n4S6P6Gc001774@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48344 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751097AbZE1GZL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 May 2009 02:25:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier@gentoo.org, rusty@rustcorp.com.au


The patch titled
     virtio_blk: add missing __dev{init,exit} markings
has been added to the -mm tree.  Its filename is
     virtio_blk-add-missing-__devinitexit-markings.patch

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
Subject: virtio_blk: add missing __dev{init,exit} markings
From: Mike Frysinger <vapier@gentoo.org>

The remove member of the virtio_driver structure uses __devexit_p(), so
the remove function itself should be marked with __devexit.  And where
there be __devexit on the remove, so is there __devinit on the probe.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/virtio_blk.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/block/virtio_blk.c~virtio_blk-add-missing-__devinitexit-markings drivers/block/virtio_blk.c
--- a/drivers/block/virtio_blk.c~virtio_blk-add-missing-__devinitexit-markings
+++ a/drivers/block/virtio_blk.c
@@ -223,7 +223,7 @@ static int index_to_minor(int index)
 	return index << PART_BITS;
 }
 
-static int virtblk_probe(struct virtio_device *vdev)
+static int __devinit virtblk_probe(struct virtio_device *vdev)
 {
 	struct virtio_blk *vblk;
 	int err;
@@ -364,7 +364,7 @@ out:
 	return err;
 }
 
-static void virtblk_remove(struct virtio_device *vdev)
+static void __devexit virtblk_remove(struct virtio_device *vdev)
 {
 	struct virtio_blk *vblk = vdev->priv;
 
_

Patches currently in -mm which might be from vapier@gentoo.org are

origin.patch
linux-next.patch
pcmcia-yenta-add-missing-__devexit-marking.patch
drivers-hvc-add-missing-__devexit_p.patch
plat_nand-add-missing-__devexit_p.patch
irda-new-blackfin-on-chip-sir-irda-driver.patch
crypto-hifn_795x-fix-__devinitexit-markings.patch
drivers-char-rtc-disable-legacy-rtc-driver-on-blackfin-systems.patch
gpio-max7301-add-missing-__devexit-marking.patch
istallion-add-missing-__devexit-marking.patch
edac-add-missing-__devexit_p.patch
virtio_blk-add-missing-__devinitexit-markings.patch

