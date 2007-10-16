From: akpm@linux-foundation.org
Subject: - pcmcia-use-dma_mask_none-for-the-default-for-all.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:29:52 -0700
Message-ID: <200710162029.l9GKTq7w014346@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35914 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762871AbXJPUb1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 16:31:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: James.Bottomley@SteelEye.com, alan@lxorguk.ukuu.org.uk, andi@firstfloor.org, htejun@gmail.com, jgarzik@pobox.com, linux@dominikbrodowski.net, protasnb@gmail.com, rmk@arm.linux.org.uk


The patch titled
     pcmcia: use DMA_MASK_NONE for the default for all pcmcia devices
has been removed from the -mm tree.  Its filename was
     pcmcia-use-dma_mask_none-for-the-default-for-all.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: pcmcia: use DMA_MASK_NONE for the default for all pcmcia devices
From: James Bottomley <James.Bottomley@SteelEye.com>

Most non cardbus devices can't do dma, so flag them as such in the device
creation routine.

Signed-off-by: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Tejun Heo <htejun@gmail.com>
Cc: Natalie Protasevich <protasnb@gmail.com>
Cc: Jeff Garzik <jgarzik@pobox.com>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pcmcia/ds.c |    4 ++++
 include/pcmcia/ds.h |    1 +
 2 files changed, 5 insertions(+)

diff -puN drivers/pcmcia/ds.c~pcmcia-use-dma_mask_none-for-the-default-for-all drivers/pcmcia/ds.c
--- a/drivers/pcmcia/ds.c~pcmcia-use-dma_mask_none-for-the-default-for-all
+++ a/drivers/pcmcia/ds.c
@@ -23,6 +23,7 @@
 #include <linux/crc32.h>
 #include <linux/firmware.h>
 #include <linux/kref.h>
+#include <linux/dma-mapping.h>
 
 #define IN_CARD_SERVICES
 #include <pcmcia/cs_types.h>
@@ -670,6 +671,9 @@ struct pcmcia_device * pcmcia_device_add
 	p_dev->dev.bus = &pcmcia_bus_type;
 	p_dev->dev.parent = s->dev.parent;
 	p_dev->dev.release = pcmcia_release_dev;
+	/* by default don't allow DMA */
+	p_dev->dma_mask = DMA_MASK_NONE;
+	p_dev->dev.dma_mask = &p_dev->dma_mask;
 	bus_id_len = sprintf (p_dev->dev.bus_id, "%d.%d", p_dev->socket->sock, p_dev->device_no);
 
 	p_dev->devname = kmalloc(6 + bus_id_len + 1, GFP_KERNEL);
diff -puN include/pcmcia/ds.h~pcmcia-use-dma_mask_none-for-the-default-for-all include/pcmcia/ds.h
--- a/include/pcmcia/ds.h~pcmcia-use-dma_mask_none-for-the-default-for-all
+++ a/include/pcmcia/ds.h
@@ -184,6 +184,7 @@ struct pcmcia_device {
 
 	char *			prod_id[4];
 
+	u64			dma_mask;
 	struct device		dev;
 
 #ifdef CONFIG_PCMCIA_IOCTL
_

Patches currently in -mm which might be from James.Bottomley@SteelEye.com are

origin.patch
git-scsi-misc.patch
git-scsi-misc-gdth-fix.patch
change-struct-marker-users.patch
