From: akpm@linux-foundation.org
Subject: - cleanup-libata-hpa-support-fix.patch removed from -mm tree
Date: Wed, 23 May 2007 14:25:09 -0700
Message-ID: <200705232125.l4NLPAOK032500@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:46031 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754854AbXEWVZU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 May 2007 17:25:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ben.collins@ubuntu.com, kyle@ubuntu.com, mm-commits@vger.kernel.org


The patch titled
     Cleanup libata HPA support (fix)
has been removed from the -mm tree.  Its filename was
     cleanup-libata-hpa-support-fix.patch

This patch was dropped because it was folded into cleanup-libata-hpa-support.patch

------------------------------------------------------
Subject: Cleanup libata HPA support (fix)
From: Ben Collins <ben.collins@ubuntu.com>

Added error check for ata_dev_read_id (Thanks tj)

Also, since hpa is disabled by default, print the native size, even when
HPA isn't asked for (so users and developers can know that it may need
to be used).

Cc: Kyle McMartin <kyle@ubuntu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/libata-core.c |   28 ++++++++++++++++++----------
 1 files changed, 18 insertions(+), 10 deletions(-)

diff -puN drivers/ata/libata-core.c~cleanup-libata-hpa-support-fix drivers/ata/libata-core.c
--- a/drivers/ata/libata-core.c~cleanup-libata-hpa-support-fix
+++ a/drivers/ata/libata-core.c
@@ -1015,20 +1015,19 @@ static u64 ata_id_n_sectors(const u16 *i
  *	it if required to the full size of the media.
  */
 
-static void ata_hpa_resize(struct ata_device *dev)
+static int ata_hpa_resize(struct ata_device *dev)
 {
 	u64 hpa_sectors;
 
-	if (!ata_id_hpa_enabled(dev->id) || !ata_ignore_hpa)
-		return;
+	if (!ata_id_hpa_enabled(dev->id))
+		return 0;
 
 	hpa_sectors = ata_hpa_get_native_size(dev);
 
-	/* if no hpa, both should be equal */
-	ata_dev_printk(dev, KERN_INFO, "%s 1: sectors = %lld, hpa_sectors = %lld\n",
+	ata_dev_printk(dev, KERN_INFO, "%s: sectors = %lld, hpa_sectors = %lld\n",
 		__FUNCTION__, dev->n_sectors, hpa_sectors);
 
-	if (hpa_sectors > dev->n_sectors) {
+	if (ata_ignore_hpa && hpa_sectors > dev->n_sectors) {
 		u64 ret_sectors;
 
 		ata_dev_printk(dev, KERN_INFO,
@@ -1053,13 +1052,20 @@ static void ata_hpa_resize(struct ata_de
 			rc = ata_dev_read_id(dev, &dev->class,
 					     ATA_READID_POSTRESET, id);
 
-			dev->n_sectors = ata_id_n_sectors(id);
+			if (rc) {
+				ata_dev_printk(dev, KERN_ERR,
+					"Failed to reread ID after SET_MAX (%d)\n",
+					rc);
+				return -EIO;
+			}
+
+			memcpy(dev->id, id, sizeof(id[0]) * ATA_ID_WORDS);
+			dev->n_sectors = ata_id_n_sectors(dev->id);
 
 			if (dev->n_sectors == hpa_sectors) {
 				ata_dev_printk(dev, KERN_INFO,
 					"Native size increased to %llu sectors\n",
 					hpa_sectors);
-				memcpy(dev->id, id, sizeof(id[0]) * ATA_ID_WORDS);
 			} else {
 				ata_dev_printk(dev, KERN_ERR,
 					"Failed to set native size, "
@@ -1068,7 +1074,7 @@ static void ata_hpa_resize(struct ata_de
 			}
 		}
 	}
-	return;
+	return 0;
 }
 
 static u64 ata_id_n_sectors(const u16 *id)
@@ -1968,7 +1974,9 @@ int ata_dev_configure(struct ata_device 
 			}
 
 			/* Check for HPA, and resize if requested */
-			ata_hpa_resize(dev);
+			rc = ata_hpa_resize(dev);
+			if (rc)
+				goto err_out_nosup;
 
 			/* config NCQ */
 			ata_dev_config_ncq(dev, ncq_desc, sizeof(ncq_desc));
_

Patches currently in -mm which might be from ben.collins@ubuntu.com are

origin.patch
avoid-zero-size-allocation-in-cache_k8_northbridges.patch
cleanup-libata-hpa-support.patch
cleanup-libata-hpa-support-fix.patch
