From: akpm@osdl.org
Subject: - scsi-megaraid_mmmbox-init-fix-for-kdump.patch removed from -mm tree
Date: Mon, 22 Jan 2007 12:47:08 -0800
Message-ID: <200701222047.l0MKl8d5001604@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50498 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932583AbXAVUr2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Jan 2007 15:47:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sumantp@lsil.com, Neela.Kolli@engenio.com, sumant.patro@lsi.com, vgoyal@in.ibm.com, mm-commits@vger.kernel.org


The patch titled
     scsi: megaraid_{mm,mbox} init fix for kdump
has been removed from the -mm tree.  Its filename was
     scsi-megaraid_mmmbox-init-fix-for-kdump.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: scsi: megaraid_{mm,mbox} init fix for kdump
From: Sumant Patro <sumantp@lsil.com>

1.      Changes in Initialization to fix kdump failure.
        Send SYNC command on loading.
        This command clears the pending commands in the adapter
        and re-initialize its internal RAID structure.
        Without this change, megaraid driver either panics or fails to
        initialize the adapter during kdump's second kernel boot
        if there are pending commands or interrupts from other devices
        sharing the same IRQ.
2.      Authors email-id domain name changed from lsil.com to lsi.com.
        Also modified the MODULE_AUTHOR to megaraidlinux@lsi.com

Signed-off-by: Sumant Patro <sumant.patro@lsi.com>
Cc: "Kolli, Neela Syam" <Neela.Kolli@engenio.com>
Cc: Vivek Goyal <vgoyal@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 Documentation/scsi/ChangeLog.megaraid |   16 ++
 drivers/scsi/megaraid/megaraid_mbox.c |  140 +++++++++++++++++++-----
 drivers/scsi/megaraid/megaraid_mbox.h |    4 
 3 files changed, 130 insertions(+), 30 deletions(-)

diff -puN Documentation/scsi/ChangeLog.megaraid~scsi-megaraid_mmmbox-init-fix-for-kdump Documentation/scsi/ChangeLog.megaraid
--- a/Documentation/scsi/ChangeLog.megaraid~scsi-megaraid_mmmbox-init-fix-for-kdump
+++ a/Documentation/scsi/ChangeLog.megaraid
@@ -1,3 +1,19 @@
+Release Date	: Thu Nov 16 15:32:35 EST 2006 -
+				Sumant Patro <sumant.patro@lsi.com>
+Current Version : 2.20.5.1 (scsi module), 2.20.2.6 (cmm module)
+Older Version	: 2.20.4.9 (scsi module), 2.20.2.6 (cmm module)
+
+1.	Changes in Initialization to fix kdump failure.
+	Send SYNC command on loading.
+	This command clears the pending commands in the adapter
+	and re-initialize its internal RAID structure.
+	Without this change, megaraid driver either panics or fails to
+	initialize the adapter during kdump's second kernel boot
+	if there are pending commands or interrupts from other devices
+	sharing the same IRQ.
+2. 	Authors email-id domain name changed from lsil.com to lsi.com.
+	Also modified the MODULE_AUTHOR to megaraidlinux@lsi.com
+
 Release Date	: Fri May 19 09:31:45 EST 2006 - Seokmann Ju <sju@lsil.com>
 Current Version : 2.20.4.9 (scsi module), 2.20.2.6 (cmm module)
 Older Version	: 2.20.4.8 (scsi module), 2.20.2.6 (cmm module)
diff -puN drivers/scsi/megaraid/megaraid_mbox.c~scsi-megaraid_mmmbox-init-fix-for-kdump drivers/scsi/megaraid/megaraid_mbox.c
--- a/drivers/scsi/megaraid/megaraid_mbox.c~scsi-megaraid_mmmbox-init-fix-for-kdump
+++ a/drivers/scsi/megaraid/megaraid_mbox.c
@@ -10,13 +10,13 @@
  *	   2 of the License, or (at your option) any later version.
  *
  * FILE		: megaraid_mbox.c
- * Version	: v2.20.4.9 (Jul 16 2006)
+ * Version	: v2.20.5.1 (Nov 16 2006)
  *
  * Authors:
- * 	Atul Mukker		<Atul.Mukker@lsil.com>
- * 	Sreenivas Bagalkote	<Sreenivas.Bagalkote@lsil.com>
- * 	Manoj Jose		<Manoj.Jose@lsil.com>
- * 	Seokmann Ju		<Seokmann.Ju@lsil.com>
+ * 	Atul Mukker		<Atul.Mukker@lsi.com>
+ * 	Sreenivas Bagalkote	<Sreenivas.Bagalkote@lsi.com>
+ * 	Manoj Jose		<Manoj.Jose@lsi.com>
+ * 	Seokmann Ju
  *
  * List of supported controllers
  *
@@ -107,6 +107,7 @@ static int megaraid_mbox_support_random_
 static int megaraid_mbox_get_max_sg(adapter_t *);
 static void megaraid_mbox_enum_raid_scsi(adapter_t *);
 static void megaraid_mbox_flush_cache(adapter_t *);
+static int megaraid_mbox_fire_sync_cmd(adapter_t *);
 
 static void megaraid_mbox_display_scb(adapter_t *, scb_t *);
 static void megaraid_mbox_setup_device_map(adapter_t *);
@@ -137,7 +138,7 @@ static int wait_till_fw_empty(adapter_t 
 
 
 
-MODULE_AUTHOR("sju@lsil.com");
+MODULE_AUTHOR("megaraidlinux@lsi.com");
 MODULE_DESCRIPTION("LSI Logic MegaRAID Mailbox Driver");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(MEGARAID_VERSION);
@@ -779,33 +780,39 @@ megaraid_init_mbox(adapter_t *adapter)
 		goto out_release_regions;
 	}
 
-	//
-	// Setup the rest of the soft state using the library of FW routines
-	//
+	/* initialize the mutual exclusion lock for the mailbox */
+	spin_lock_init(&raid_dev->mailbox_lock);
+
+	/* allocate memory required for commands */
+	if (megaraid_alloc_cmd_packets(adapter) != 0)
+		goto out_iounmap;
 
-	// request IRQ and register the interrupt service routine
+	/*
+	 * Issue SYNC cmd to flush the pending cmds in the adapter
+	 * and initialize its internal state
+	 */
+
+	if (megaraid_mbox_fire_sync_cmd(adapter))
+		con_log(CL_ANN, ("megaraid: sync cmd failed\n"));
+
+	/*
+	 * Setup the rest of the soft state using the library of
+	 * FW routines
+	 */
+
+	/* request IRQ and register the interrupt service routine */
 	if (request_irq(adapter->irq, megaraid_isr, IRQF_SHARED, "megaraid",
 		adapter)) {
 
 		con_log(CL_ANN, (KERN_WARNING
 			"megaraid: Couldn't register IRQ %d!\n", adapter->irq));
+		goto out_alloc_cmds;
 
-		goto out_iounmap;
-	}
-
-
-	// initialize the mutual exclusion lock for the mailbox
-	spin_lock_init(&raid_dev->mailbox_lock);
-
-	// allocate memory required for commands
-	if (megaraid_alloc_cmd_packets(adapter) != 0) {
-		goto out_free_irq;
 	}
 
 	// Product info
-	if (megaraid_mbox_product_info(adapter) != 0) {
-		goto out_alloc_cmds;
-	}
+	if (megaraid_mbox_product_info(adapter) != 0)
+		goto out_free_irq;
 
 	// Do we support extended CDBs
 	adapter->max_cdb_sz = 10;
@@ -874,9 +881,8 @@ megaraid_init_mbox(adapter_t *adapter)
 	 * Allocate resources required to issue FW calls, when sysfs is
 	 * accessed
 	 */
-	if (megaraid_sysfs_alloc_resources(adapter) != 0) {
-		goto out_alloc_cmds;
-	}
+	if (megaraid_sysfs_alloc_resources(adapter) != 0)
+		goto out_free_irq;
 
 	// Set the DMA mask to 64-bit. All supported controllers as capable of
 	// DMA in this range
@@ -920,10 +926,10 @@ megaraid_init_mbox(adapter_t *adapter)
 
 out_free_sysfs_res:
 	megaraid_sysfs_free_resources(adapter);
-out_alloc_cmds:
-	megaraid_free_cmd_packets(adapter);
 out_free_irq:
 	free_irq(adapter->irq, adapter);
+out_alloc_cmds:
+	megaraid_free_cmd_packets(adapter);
 out_iounmap:
 	iounmap(raid_dev->baseaddr);
 out_release_regions:
@@ -3380,6 +3386,84 @@ megaraid_mbox_flush_cache(adapter_t *ada
 
 
 /**
+ * megaraid_mbox_fire_sync_cmd - fire the sync cmd
+ * @param adapter	: soft state for the controller
+ *
+ * Clears the pending cmds in FW and reinits its RAID structs
+ */
+static int
+megaraid_mbox_fire_sync_cmd(adapter_t *adapter)
+{
+	mbox_t	*mbox;
+	uint8_t	raw_mbox[sizeof(mbox_t)];
+	mraid_device_t	*raid_dev = ADAP2RAIDDEV(adapter);
+	mbox64_t *mbox64;
+	int	status = 0;
+	int i;
+	uint32_t dword;
+
+	mbox = (mbox_t *)raw_mbox;
+
+	memset((caddr_t)raw_mbox, 0, sizeof(mbox_t));
+
+	raw_mbox[0] = 0xFF;
+
+	mbox64	= raid_dev->mbox64;
+	mbox	= raid_dev->mbox;
+
+	/* Wait until mailbox is free */
+	if (megaraid_busywait_mbox(raid_dev) != 0) {
+		status = 1;
+		goto blocked_mailbox;
+	}
+
+	/* Copy mailbox data into host structure */
+	memcpy((caddr_t)mbox, (caddr_t)raw_mbox, 16);
+	mbox->cmdid		= 0xFE;
+	mbox->busy		= 1;
+	mbox->poll		= 0;
+	mbox->ack		= 0;
+	mbox->numstatus		= 0;
+	mbox->status		= 0;
+
+	wmb();
+	WRINDOOR(raid_dev, raid_dev->mbox_dma | 0x1);
+
+	/* Wait for maximum 1 min for status to post.
+	 * If the Firmware SUPPORTS the ABOVE COMMAND,
+	 * mbox->cmd will be set to 0
+	 * else
+	 * the firmware will reject the command with
+	 * mbox->numstatus set to 1
+	 */
+
+	i = 0;
+	status = 0;
+	while (!mbox->numstatus && mbox->cmd == 0xFF) {
+		rmb();
+		msleep(1);
+		i++;
+		if (i > 1000 * 60) {
+			status = 1;
+			break;
+		}
+	}
+	if (mbox->numstatus == 1)
+		status = 1; /*cmd not supported*/
+
+	/* Check for interrupt line */
+	dword = RDOUTDOOR(raid_dev);
+	WROUTDOOR(raid_dev, dword);
+	WRINDOOR(raid_dev,2);
+
+	return status;
+
+blocked_mailbox:
+	con_log(CL_ANN, (KERN_WARNING "megaraid: blocked mailbox\n"));
+	return status;
+}
+
+/**
  * megaraid_mbox_display_scb - display SCB information, mostly debug purposes
  * @param adapter	: controllers' soft state
  * @param scb		: SCB to be displayed
diff -puN drivers/scsi/megaraid/megaraid_mbox.h~scsi-megaraid_mmmbox-init-fix-for-kdump drivers/scsi/megaraid/megaraid_mbox.h
--- a/drivers/scsi/megaraid/megaraid_mbox.h~scsi-megaraid_mmmbox-init-fix-for-kdump
+++ a/drivers/scsi/megaraid/megaraid_mbox.h
@@ -21,8 +21,8 @@
 #include "megaraid_ioctl.h"
 
 
-#define MEGARAID_VERSION	"2.20.4.9"
-#define MEGARAID_EXT_VERSION	"(Release Date: Sun Jul 16 12:27:22 EST 2006)"
+#define MEGARAID_VERSION	"2.20.5.1"
+#define MEGARAID_EXT_VERSION	"(Release Date: Thu Nov 16 15:32:35 EST 2006)"
 
 
 /*
_

Patches currently in -mm which might be from sumantp@lsil.com are

origin.patch
git-scsi-misc.patch
