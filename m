From: akpm@osdl.org
Subject: - aic94xx-increase-can_queue-and-cmds_per_lun.patch removed from -mm tree
Date: Fri, 08 Dec 2006 03:04:56 -0800
Message-ID: <200612081104.kB8B4uIE018601@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:48692 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1425370AbWLHLFL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 06:05:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: djwong@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     aic94xx: Increase can_queue and cmds_per_lun
has been removed from the -mm tree.  Its filename was
     aic94xx-increase-can_queue-and-cmds_per_lun.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: aic94xx: Increase can_queue and cmds_per_lun
From: "Darrick J. Wong" <djwong@us.ibm.com>

Set sets cmd_per_lun and can_queue in the aic94xx driver's
scsi_host_template to better performing values than what's there currently.
 The cmd_per_lun setting is stolen straight out of the adp94xx source, and
can_queue is derived from the max_scb value that we calculate in
asd_init_hw.  To the best of my (admittedly limited) knowledge, this method
provides the correct values (can_queue = 443 in both adp94xx and aic94xx on
my 9405W) but if anybody knows better, please enlighten me.  :)

That said, the effect of leaving these values set to 1 is terrible
performance in the case of either (a) certain Maxtor SAS drives flying solo
or (b) flooding several disks with I/O simultaneously (md-raid).  There may
be more scenarios where we see similar problems that I haven't uncovered.

Just for grins, I ran bogodisk (an O_DIRECT-enabled read speed test)
against three different scenarios:

1) adp94xx 1.0.8-6, pounded into 2.6.18-rc4 [green]
2) aic94xx 1.0.2, without this patch        [red]
3) aic94xx 1.0.2, with this                 [blue]

...with these results:

http://sweaglesw.net/~djwong/programs/bogodisk/bd_graphs/bad_sas.0.png

As you can see, the read performance is cut in half by the aic94xx driver
not getting a chance to have multiple I/Os in flight at any given time. 
With the patch, the two drivers are fairly close bandwidth-wise.  Also
thanks to Mike Anderson for helping me figure this out.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/aic94xx/aic94xx_hwi.h  |    3 +++
 drivers/scsi/aic94xx/aic94xx_init.c |   10 +++++++---
 2 files changed, 10 insertions(+), 3 deletions(-)

diff -puN drivers/scsi/aic94xx/aic94xx_hwi.h~aic94xx-increase-can_queue-and-cmds_per_lun drivers/scsi/aic94xx/aic94xx_hwi.h
--- a/drivers/scsi/aic94xx/aic94xx_hwi.h~aic94xx-increase-can_queue-and-cmds_per_lun
+++ a/drivers/scsi/aic94xx/aic94xx_hwi.h
@@ -36,6 +36,9 @@
 #include "aic94xx.h"
 #include "aic94xx_sas.h"
 
+/* Leave a few empty data buffers. */
+#define ASD_FREE_SCBS      3
+
 /* Define ASD_MAX_PHYS to the maximum phys ever. Currently 8. */
 #define ASD_MAX_PHYS       8
 #define ASD_PCBA_SN_SIZE   12
diff -puN drivers/scsi/aic94xx/aic94xx_init.c~aic94xx-increase-can_queue-and-cmds_per_lun drivers/scsi/aic94xx/aic94xx_init.c
--- a/drivers/scsi/aic94xx/aic94xx_init.c~aic94xx-increase-can_queue-and-cmds_per_lun
+++ a/drivers/scsi/aic94xx/aic94xx_init.c
@@ -71,7 +71,7 @@ static struct scsi_host_template aic94xx
 	.change_queue_type	= sas_change_queue_type,
 	.bios_param		= sas_bios_param,
 	.can_queue		= 1,
-	.cmd_per_lun		= 1,
+	.cmd_per_lun		= 2,
 	.this_id		= -1,
 	.sg_tablesize		= SG_ALL,
 	.max_sectors		= SCSI_DEFAULT_MAX_SECTORS,
@@ -612,13 +612,17 @@ static int __devinit asd_pci_probe(struc
 		goto Err_free_cache;
 
 	asd_printk("device %s: SAS addr %llx, PCBA SN %s, %d phys, %d enabled "
-		   "phys, flash %s, BIOS %s%d\n",
+		   "phys, flash %s, BIOS %s%d, SCBs %d\n",
 		   pci_name(dev), SAS_ADDR(asd_ha->hw_prof.sas_addr),
 		   asd_ha->hw_prof.pcba_sn, asd_ha->hw_prof.max_phys,
 		   asd_ha->hw_prof.num_phys,
 		   asd_ha->hw_prof.flash.present ? "present" : "not present",
 		   asd_ha->hw_prof.bios.present ? "build " : "not present",
-		   asd_ha->hw_prof.bios.bld);
+		   asd_ha->hw_prof.bios.bld,
+		   asd_ha->hw_prof.max_scbs);
+
+	aic94xx_sht.can_queue = asd_ha->hw_prof.max_scbs - ASD_FREE_SCBS;
+	shost->can_queue = aic94xx_sht.can_queue;
 
 	if (use_msi)
 		pci_enable_msi(asd_ha->pcidev);
_

Patches currently in -mm which might be from djwong@us.ibm.com are

origin.patch
libata-simulate-report-luns-for-atapi-devices.patch
git-sas.patch
git-sas-kconfig-fix.patch

