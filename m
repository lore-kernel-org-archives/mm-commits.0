From: akpm@linux-foundation.org
Subject: [merged] virtio_blk-add-missing-__devinitexit-markings.patch removed from -mm tree
Date: Tue, 09 Jun 2009 11:12:35 -0700
Message-ID: <200906091812.n59ICZXq018806@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46534 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758873AbZFISMh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jun 2009 14:12:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier@gentoo.org, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     virtio_blk: add missing __dev{init,exit} markings
has been removed from the -mm tree.  Its filename was
     virtio_blk-add-missing-__devinitexit-markings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
shm-fix-unused-warnings-on-nommu.patch
linux-next.patch
pcmcia-yenta-add-missing-__devexit-marking.patch
drivers-hvc-add-missing-__devexit_p.patch
kmap_types-make-most-arches-use-generic-header-file.patch
gitignore-ignore-patch-files.patch
drivers-char-rtc-disable-legacy-rtc-driver-on-blackfin-systems.patch
gpio-max7301-add-missing-__devexit-marking.patch
istallion-add-missing-__devexit-marking.patch
edac-add-missing-__devexit_p.patch

