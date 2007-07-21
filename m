From: akpm@linux-foundation.org
Subject: - ps3-bd-dvd-cd-rom-storage-driver-updates-after-final-review.patch removed from -mm tree
Date: Sat, 21 Jul 2007 04:34:57 -0700
Message-ID: <200707211134.l6LBYv6i014251@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60673 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933128AbXGULgE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 21 Jul 2007 07:36:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Geert.Uytterhoeven@sonycom.com, James.Bottomley@steeleye.com, benh@kernel.crashing.org, geoffrey.levand@am.sony.com, jens.axboe@oracle.com, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     ps3rom: updates after final review
has been removed from the -mm tree.  Its filename was
     ps3-bd-dvd-cd-rom-storage-driver-updates-after-final-review.patch

This patch was dropped because it was folded into ps3-bd-dvd-cd-rom-storage-driver.patch

------------------------------------------------------
Subject: ps3rom: updates after final review
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

ps3rom: updates after final review:
  o Kill confusing ps3rom_priv() macro, open code it instead
  o kmap_atomic() cannot fail

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Geoff Levand <geoffrey.levand@am.sony.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/ps3rom.c |   15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff -puN drivers/scsi/ps3rom.c~ps3-bd-dvd-cd-rom-storage-driver-updates-after-final-review drivers/scsi/ps3rom.c
--- a/drivers/scsi/ps3rom.c~ps3-bd-dvd-cd-rom-storage-driver-updates-after-final-review
+++ a/drivers/scsi/ps3rom.c
@@ -42,7 +42,6 @@ struct ps3rom_private {
 	struct ps3_storage_device *dev;
 	struct scsi_cmnd *curr_cmd;
 };
-#define ps3rom_priv(dev)	((dev)->sbd.core.driver_data)
 
 
 #define LV1_STORAGE_SEND_ATAPI_COMMAND	(1)
@@ -113,8 +112,6 @@ static int fill_from_dev_buffer(struct s
 	for (k = 0, req_len = 0, act_len = 0; k < cmd->use_sg; ++k, ++sgpnt) {
 		if (active) {
 			kaddr = kmap_atomic(sgpnt->page, KM_IRQ0);
-			if (!kaddr)
-				return -1;
 			len = sgpnt->length;
 			if ((req_len + len) > buflen) {
 				active = 0;
@@ -151,8 +148,6 @@ static int fetch_to_dev_buffer(struct sc
 	sgpnt = cmd->request_buffer;
 	for (k = 0, req_len = 0, fin = 0; k < cmd->use_sg; ++k, ++sgpnt) {
 		kaddr = kmap_atomic(sgpnt->page, KM_IRQ0);
-		if (!kaddr)
-			return -1;
 		len = sgpnt->length;
 		if ((req_len + len) > buflen) {
 			len = buflen - req_len;
@@ -379,7 +374,7 @@ static irqreturn_t ps3rom_interrupt(int 
 		return IRQ_HANDLED;
 	}
 
-	host = ps3rom_priv(dev);
+	host = dev->sbd.core.driver_data;
 	priv = shost_priv(host);
 	cmd = priv->curr_cmd;
 
@@ -469,7 +464,7 @@ static int __devinit ps3rom_probe(struct
 	}
 
 	priv = shost_priv(host);
-	ps3rom_priv(dev) = host;
+	dev->sbd.core.driver_data = host;
 	priv->dev = dev;
 
 	/* One device/LUN per SCSI bus */
@@ -489,7 +484,7 @@ static int __devinit ps3rom_probe(struct
 
 fail_host_put:
 	scsi_host_put(host);
-	ps3rom_priv(dev) = NULL;
+	dev->sbd.core.driver_data = NULL;
 fail_teardown:
 	ps3stor_teardown(dev);
 fail_free_bounce:
@@ -500,12 +495,12 @@ fail_free_bounce:
 static int ps3rom_remove(struct ps3_system_bus_device *_dev)
 {
 	struct ps3_storage_device *dev = to_ps3_storage_device(&_dev->core);
-	struct Scsi_Host *host = ps3rom_priv(dev);
+	struct Scsi_Host *host = dev->sbd.core.driver_data;
 
 	scsi_remove_host(host);
 	ps3stor_teardown(dev);
 	scsi_host_put(host);
-	ps3rom_priv(dev) = NULL;
+	dev->sbd.core.driver_data = NULL;
 	kfree(dev->bounce_buf);
 	return 0;
 }
_

Patches currently in -mm which might be from Geert.Uytterhoeven@sonycom.com are

origin.patch
ps3-disk-storage-driver.patch
ps3-bd-dvd-cd-rom-storage-driver.patch
ps3-bd-dvd-cd-rom-storage-driver-updates-after-final-review.patch
ps3-flash-rom-storage-driver.patch
ps3-flash-rom-storage-driver-updates-after-final-review.patch
ps3fb-enable-vt_hw_console_binding-for-proper-kexec.patch
ps3fb-shrink-default-virtual-frame-buffer-size-from-18-to-9-mib.patch
ps3fb-set-fbinfo_reads_fast-to-speed-up-text-console-scrolling.patch
