From: akpm@linux-foundation.org
Subject: [merged] rapidio-tsi721-modify-mport-name-assignment.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:20:15 -0700
Message-ID: <20121005202015.9F8491E0048@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:54966 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932319Ab2JEUUQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:20:16 -0400
Received: by mail-gg0-f202.google.com with SMTP id i4so236004ggm.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:20:16 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexandre.bounine@idt.com, mporter@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     Subject: rapidio/tsi721: modify mport name assignment
has been removed from the -mm tree.  Its filename was
     rapidio-tsi721-modify-mport-name-assignment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexandre Bounine <alexandre.bounine@idt.com>
Subject: rapidio/tsi721: modify mport name assignment

Modify RapidIO mport device name assignment to include device name of PCIe
side of Tsi721 bridge.  The new name format is intended to provide
definitive reference between RapidIO and PCIe sides of the bridge in
systems with multiple Tsi721 bridges.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/devices/tsi721.c |    3 ++-
 include/linux/rio.h              |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/rapidio/devices/tsi721.c~rapidio-tsi721-modify-mport-name-assignment drivers/rapidio/devices/tsi721.c
--- a/drivers/rapidio/devices/tsi721.c~rapidio-tsi721-modify-mport-name-assignment
+++ a/drivers/rapidio/devices/tsi721.c
@@ -2165,7 +2165,8 @@ static int __devinit tsi721_setup_mport(
 	rio_init_dbell_res(&mport->riores[RIO_DOORBELL_RESOURCE], 0, 0xffff);
 	rio_init_mbox_res(&mport->riores[RIO_INB_MBOX_RESOURCE], 0, 3);
 	rio_init_mbox_res(&mport->riores[RIO_OUTB_MBOX_RESOURCE], 0, 3);
-	strcpy(mport->name, "Tsi721 mport");
+	snprintf(mport->name, RIO_MAX_MPORT_NAME, "%s(%s)",
+		 dev_driver_string(&pdev->dev), dev_name(&pdev->dev));
 
 	/* Hook up interrupt handler */
 
diff -puN include/linux/rio.h~rapidio-tsi721-modify-mport-name-assignment include/linux/rio.h
--- a/include/linux/rio.h~rapidio-tsi721-modify-mport-name-assignment
+++ a/include/linux/rio.h
@@ -30,6 +30,7 @@
 #define RIO_MAX_MPORTS		8
 #define RIO_MAX_MPORT_RESOURCES	16
 #define RIO_MAX_DEV_RESOURCES	16
+#define RIO_MAX_MPORT_NAME	40
 
 #define RIO_GLOBAL_TABLE	0xff	/* Indicates access of a switch's
 					   global routing table if it
@@ -255,7 +256,7 @@ struct rio_mport {
 				 */
 	enum rio_phy_type phy_type;	/* RapidIO phy type */
 	u32 phys_efptr;
-	unsigned char name[40];
+	unsigned char name[RIO_MAX_MPORT_NAME];
 	void *priv;		/* Master port private data */
 #ifdef CONFIG_RAPIDIO_DMA_ENGINE
 	struct dma_device	dma;
_

Patches currently in -mm which might be from alexandre.bounine@idt.com are

origin.patch

