From: akpm@linux-foundation.org
Subject: + rapidio-tsi721-modify-mport-name-assignment.patch added to -mm tree
Date: Fri, 24 Aug 2012 14:05:09 -0700
Message-ID: <20120824210512.42C475C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:53845 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030446Ab2HXVFP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Aug 2012 17:05:15 -0400
Received: by lbbge1 with SMTP id ge1so111037lbb.1
        for <mm-commits@vger.kernel.org>; Fri, 24 Aug 2012 14:05:13 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alexandre.bounine@idt.com, mporter@kernel.crashing.org


The patch titled
     Subject: rapidio/tsi721: modify mport name assignment
has been added to the -mm tree.  Its filename is
     rapidio-tsi721-modify-mport-name-assignment.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexandre Bounine <alexandre.bounine@idt.com>
Subject: rapidio/tsi721: modify mport name assignment

Modify mport device name assignment to provide clear reference to devices
in systems with multiple Tsi721 bridges.

This patch is applicable to kernel versions starting from v3.2.

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

rapidio-tsi721-modify-mport-name-assignment.patch
rapidio-apply-rx-tx-enable-to-active-switch-ports-only.patch

