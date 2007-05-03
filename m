From: akpm@linux-foundation.org
Subject: + libata-add-support-for-ata_16-on-atapi.patch added to -mm tree
Date: Thu, 03 May 2007 01:32:22 -0700
Message-ID: <200705030832.l438WMQj008137@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:38416 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751564AbXECIcm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 May 2007 04:32:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: liml@rtr.ca, alan@lxorguk.ukuu.org.uk, htejun@gmail.com, jeff@garzik.org, mlord@pobox.com


The patch titled
     libata: add support for ATA_16 on ATAPI
has been added to the -mm tree.  Its filename is
     libata-add-support-for-ata_16-on-atapi.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: libata: add support for ATA_16 on ATAPI
From: Mark Lord <liml@rtr.ca>

Add support for issuing ATA_16 passthru commands to ATAPI devices managed by
libata.  It requires the previous CDB length fix patch.

A boot/module parameter, "ata16_passthru=1" can be used to globally disable
this feature, if ever desired.

Signed-off-by: Mark Lord <mlord@pobox.com>
Acked-by: Tejun Heo <htejun@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/libata-core.c |    4 ++++
 drivers/ata/libata-scsi.c |   33 +++++++++++++++++++--------------
 drivers/ata/libata.h      |    1 +
 3 files changed, 24 insertions(+), 14 deletions(-)

diff -puN drivers/ata/libata-core.c~libata-add-support-for-ata_16-on-atapi drivers/ata/libata-core.c
--- a/drivers/ata/libata-core.c~libata-add-support-for-ata_16-on-atapi
+++ a/drivers/ata/libata-core.c
@@ -86,6 +86,10 @@ int atapi_dmadir = 0;
 module_param(atapi_dmadir, int, 0444);
 MODULE_PARM_DESC(atapi_dmadir, "Enable ATAPI DMADIR bridge support (0=off, 1=on)");
 
+int ata16_passthru = 0;
+module_param(ata16_passthru, int, 0444);
+MODULE_PARM_DESC(ata16_passthru, "Enable passthru of SCSI opcode 0x85 to ATAPI devices (0=off, 1=on)");
+
 int libata_fua = 0;
 module_param_named(fua, libata_fua, int, 0444);
 MODULE_PARM_DESC(fua, "FUA support (0=off, 1=on)");
diff -puN drivers/ata/libata.h~libata-add-support-for-ata_16-on-atapi drivers/ata/libata.h
--- a/drivers/ata/libata.h~libata-add-support-for-ata_16-on-atapi
+++ a/drivers/ata/libata.h
@@ -56,6 +56,7 @@ extern unsigned int ata_print_id;
 extern struct workqueue_struct *ata_aux_wq;
 extern int atapi_enabled;
 extern int atapi_dmadir;
+extern int ata16_passthru;
 extern int libata_fua;
 extern int libata_noacpi;
 extern struct ata_queued_cmd *ata_qc_new_init(struct ata_device *dev);
diff -puN drivers/ata/libata-scsi.c~libata-add-support-for-ata_16-on-atapi drivers/ata/libata-scsi.c
--- a/drivers/ata/libata-scsi.c~libata-add-support-for-ata_16-on-atapi
+++ a/drivers/ata/libata-scsi.c
@@ -2744,6 +2744,10 @@ static unsigned int ata_scsi_pass_thru(s
 
 static inline ata_xlat_func_t ata_get_xlat_func(struct ata_device *dev, u8 cmd)
 {
+	if (dev->class == ATA_DEV_ATAPI)
+		if (cmd != ATA_16 || ata16_passthru)
+			return atapi_xlat;
+
 	switch (cmd) {
 	case READ_6:
 	case READ_10:
@@ -2802,27 +2806,28 @@ static inline int __ata_scsi_queuecmd(st
 				      void (*done)(struct scsi_cmnd *),
 				      struct ata_device *dev)
 {
-	int rc = 0;
+	ata_xlat_func_t xlat_func;
+	int rc = 0, max_len;
+	u8 scsi_op = scmd->cmnd[0];
+
+	if (scsi_op == ATA_16 && dev->class == ATA_DEV_ATAPI && !ata16_passthru)
+		max_len = 16;
+	else
+		max_len = dev->cdb_len;
 
-	if (unlikely(!scmd->cmd_len || scmd->cmd_len > dev->cdb_len)) {
+	if (unlikely(!scmd->cmd_len || scmd->cmd_len > max_len)) {
 		DPRINTK("bad CDB len=%u, max=%u\n",
-			scmd->cmd_len, dev->cdb_len);
+			scmd->cmd_len, max_len);
 		scmd->result = DID_ERROR << 16;
 		done(scmd);
 		return 0;
 	}
 
-	if (dev->class == ATA_DEV_ATA) {
-		ata_xlat_func_t xlat_func = ata_get_xlat_func(dev,
-							      scmd->cmnd[0]);
-
-		if (xlat_func)
-			rc = ata_scsi_translate(dev, scmd, done, xlat_func);
-		else
-			ata_scsi_simulate(dev, scmd, done);
-	} else
-		rc = ata_scsi_translate(dev, scmd, done, atapi_xlat);
-
+	xlat_func = ata_get_xlat_func(dev, scsi_op);
+	if (xlat_func)
+		rc = ata_scsi_translate(dev, scmd, done, xlat_func);
+	else
+		ata_scsi_simulate(dev, scmd, done);
 	return rc;
 }
 
_

Patches currently in -mm which might be from liml@rtr.ca are

origin.patch
libata-add-support-for-ata_16-on-atapi.patch
