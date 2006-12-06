From: akpm@osdl.org
Subject: + libata-simulate-report-luns-for-atapi-devices.patch added to -mm tree
Date: Tue, 05 Dec 2006 23:23:11 -0800
Message-ID: <200612060723.kB67NBru027003@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:38278 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760281AbWLFHXS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 6 Dec 2006 02:23:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: djwong@us.ibm.com


The patch titled
     libata: simulate REPORT LUNS for ATAPI devices
has been added to the -mm tree.  Its filename is
     libata-simulate-report-luns-for-atapi-devices.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: libata: simulate REPORT LUNS for ATAPI devices
From: "Darrick J. Wong" <djwong@us.ibm.com>

The Quantum GoVault SATAPI removable disk device returns ATA_ERR in
response to a REPORT LUNS packet.  If this happens to an ATAPI device that
is attached to a SAS controller (this is the case with sas_ata), the device
does not load because SCSI won't touch a "SCSI device" that won't report
its LUNs.  Since most ATAPI devices don't support multiple LUNs anyway, we
might as well fake a response like we do for ATA devices.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/ata/libata-scsi.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff -puN drivers/ata/libata-scsi.c~libata-simulate-report-luns-for-atapi-devices drivers/ata/libata-scsi.c
--- a/drivers/ata/libata-scsi.c~libata-simulate-report-luns-for-atapi-devices
+++ a/drivers/ata/libata-scsi.c
@@ -2715,8 +2715,13 @@ static inline int __ata_scsi_queuecmd(st
 			rc = ata_scsi_translate(dev, cmd, done, xlat_func);
 		else
 			ata_scsi_simulate(dev, cmd, done);
-	} else
-		rc = ata_scsi_translate(dev, cmd, done, atapi_xlat);
+	} else {
+		/* Simulate REPORT LUNS for ATAPI devices */
+		if (cmd->cmnd[0] == REPORT_LUNS)
+			ata_scsi_simulate(dev, cmd, done);
+		else
+			rc = ata_scsi_translate(dev, cmd, done, atapi_xlat);
+	}
 
 	return rc;
 }
_

Patches currently in -mm which might be from djwong@us.ibm.com are

libata-simulate-report-luns-for-atapi-devices.patch
git-scsi-misc.patch
git-sas.patch
git-sas-kconfig-fix.patch
aic94xx-dont-call-pci_map_sg-for-already-mapped-scatterlists.patch

