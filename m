From: akpm@osdl.org
Subject: + scsi-scan-fix-logging-message-for-pq3-devices.patch added to -mm tree
Date: Mon, 08 Jan 2007 20:36:48 -0800
Message-ID: <200701090436.l094am2v028525@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40232 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751010AbXAIEgy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 8 Jan 2007 23:36:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kurt@garloff.de, garloff@suse.de


The patch titled
     SCSI scan: fix logging message for PQ3 devices
has been added to the -mm tree.  Its filename is
     scsi-scan-fix-logging-message-for-pq3-devices.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: SCSI scan: fix logging message for PQ3 devices
From: Kurt Garloff <kurt@garloff.de>

The blacklist flags BLIST_ATTACH_PQ3 has value 0x1000000, not 0x800000.

Signed-off-by: Kurt Garloff <garloff@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/scsi_scan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/scsi_scan.c~scsi-scan-fix-logging-message-for-pq3-devices drivers/scsi/scsi_scan.c
--- a/drivers/scsi/scsi_scan.c~scsi-scan-fix-logging-message-for-pq3-devices
+++ a/drivers/scsi/scsi_scan.c
@@ -1029,7 +1029,7 @@ static int scsi_probe_and_add_lun(struct
 
 				sdev_printk(KERN_INFO, sdev,
 					"scsi scan: consider passing scsi_mod."
-					"dev_flags=%s:%s:0x240 or 0x800240\n",
+					"dev_flags=%s:%s:0x240 or 0x1000240\n",
 					scsi_inq_str(vend, result, 8, 16),
 					scsi_inq_str(mod, result, 16, 32));
 			});
_

Patches currently in -mm which might be from kurt@garloff.de are

scsi-scan-fix-logging-message-for-pq3-devices.patch
