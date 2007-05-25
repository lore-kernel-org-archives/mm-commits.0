From: akpm@linux-foundation.org
Subject: - cleanup-libata-hpa-support.patch removed from -mm tree
Date: Thu, 24 May 2007 21:41:58 -0700
Message-ID: <200705250441.l4P4fv5H011229@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:60847 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751439AbXEYEmE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 May 2007 00:42:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ben.collins@ubuntu.com, bcollins@ubuntu.com, kyle@ubuntu.com, mm-commits@vger.kernel.org


The patch titled
     Cleanup libata HPA support
has been removed from the -mm tree.  Its filename was
     cleanup-libata-hpa-support.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: Cleanup libata HPA support
From: Ben Collins <ben.collins@ubuntu.com>

The original HPA patch that Kyle worked on has gone into current git
without some fixes that we worked through late in the Ubuntu feisty
release.  Here's the main copy of the notes I sent to Alan a few weeks ago
in regards to the original patch, and a repatch against current git to fix
things up.  Note we have released feisty with the patch attached (albeit we
have HPA enabled by default), and we have not had any reports directly
attributed to it.  However, in gutsy (devel for next release, based on
current stock linux-2.6.git), we are already seeing reports of the same
issues we already fixed.

The issues we saw were mainly that some controllers didn't return the
correct size from the SET_MAX command (sata_nv is a good example).  So I
added a re IDENTIFY after the SET_MAX, and compared all the numbers.  If
re-id was correct, but return value from SET_MAX wasn't we print a warning
and use the IDENTIFY value regardless (since that's what the device is
going to use).

ata_hpa_resize() was changed to handle everything in a single call (checks
for HPA support of the device, and whether ignore_hpa is set or not), and
it also sets dev->n_sectors before returning.

So far with this patch, we were able to fix all the problems we were seeing
with it (except the sata_nv issue where we had to revert to not using adma
for NO_DATA transactions, already reported to libata-dev).  We've not had
any reports of further problems.

Cc: Kyle McMartin <kyle@ubuntu.com>
Signed-off-by: Ben Collins <bcollins@ubuntu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/libata-core.c |  140 +++++++++++++++++++++++++-----------
 1 files changed, 100 insertions(+), 40 deletions(-)

diff -puN drivers/ata/libata-core.c~cleanup-libata-hpa-support drivers/ata/libata-core.c
--- a/drivers/ata/libata-core.c~cleanup-libata-hpa-support
+++ a/drivers/ata/libata-core.c
@@ -819,16 +819,19 @@ void ata_id_c_string(const u16 *id, unsi
 
 static u64 ata_tf_to_lba48(struct ata_taskfile *tf)
 {
-	u64 sectors = 0;
+	u64 sectors;
+	u32 high, low;
 
-	sectors |= ((u64)(tf->hob_lbah & 0xff)) << 40;
-	sectors |= ((u64)(tf->hob_lbam & 0xff)) << 32;
-	sectors |= (tf->hob_lbal & 0xff) << 24;
-	sectors |= (tf->lbah & 0xff) << 16;
-	sectors |= (tf->lbam & 0xff) << 8;
-	sectors |= (tf->lbal & 0xff);
+	high = (tf->hob_lbah << 16) |
+	       (tf->hob_lbam <<  8) |
+		tf->hob_lbal;
+	low  = (tf->lbah << 16) |
+	       (tf->lbam <<  8) |
+		tf->lbal;
 
-	return ++sectors;
+	sectors = ((u64)high << 24) | low;
+
+	return sectors + 1;
 }
 
 static u64 ata_tf_to_lba(struct ata_taskfile *tf)
@@ -970,52 +973,107 @@ static u64 ata_set_native_max_address(st
 }
 
 /**
+ *	ata_hpa_get_native_size	-	Get the native size of a disk
+ *	@dev: Device to get the size for
+ *
+ *	Read the size of an LBA28 or LBA48 disk with HPA features and
+ *	return the native size. Caller must check that the drive has HPA
+ *	feature set enabled.
+ */
+static u64 ata_hpa_get_native_size(struct ata_device *dev)
+{
+	if (ata_id_has_lba48(dev->id))
+		return ata_read_native_max_address_ext(dev);
+	else
+		return ata_read_native_max_address(dev);
+}
+
+
+static u64 ata_hpa_set_native_size(struct ata_device *dev, u64 new_sectors)
+{
+	if (ata_id_has_lba48(dev->id))
+		return ata_set_native_max_address_ext(dev, new_sectors);
+	else
+		return ata_set_native_max_address(dev, new_sectors);
+}
+
+static unsigned long long sectors_to_MB(unsigned long long n)
+{
+	n <<= 9;		/* make it bytes */
+	do_div(n, 1000000);	/* make it MB */
+	return n;
+}
+
+static u64 ata_id_n_sectors(const u16 *id);
+
+/**
  *	ata_hpa_resize		-	Resize a device with an HPA set
  *	@dev: Device to resize
  *
  *	Read the size of an LBA28 or LBA48 disk with HPA features and resize
- *	it if required to the full size of the media. The caller must check
- *	the drive has the HPA feature set enabled.
+ *	it if required to the full size of the media.
  */
 
-static u64 ata_hpa_resize(struct ata_device *dev)
+static int ata_hpa_resize(struct ata_device *dev)
 {
-	u64 sectors = dev->n_sectors;
 	u64 hpa_sectors;
 
-	if (ata_id_has_lba48(dev->id))
-		hpa_sectors = ata_read_native_max_address_ext(dev);
-	else
-		hpa_sectors = ata_read_native_max_address(dev);
+	if (!ata_id_hpa_enabled(dev->id))
+		return 0;
+
+	hpa_sectors = ata_hpa_get_native_size(dev);
 
-	/* if no hpa, both should be equal */
-	ata_dev_printk(dev, KERN_INFO, "%s 1: sectors = %lld, "
-				"hpa_sectors = %lld\n",
-		__FUNCTION__, (long long)sectors, (long long)hpa_sectors);
+	ata_dev_printk(dev, KERN_INFO, "%s: sectors = %lld, hpa_sectors = %lld\n",
+		__FUNCTION__, dev->n_sectors, hpa_sectors);
+
+	if (ata_ignore_hpa && hpa_sectors > dev->n_sectors) {
+		u64 ret_sectors;
 
-	if (hpa_sectors > sectors) {
 		ata_dev_printk(dev, KERN_INFO,
-			"Host Protected Area detected:\n"
-			"\tcurrent size: %lld sectors\n"
-			"\tnative size: %lld sectors\n",
-			(long long)sectors, (long long)hpa_sectors);
-
-		if (ata_ignore_hpa) {
-			if (ata_id_has_lba48(dev->id))
-				hpa_sectors = ata_set_native_max_address_ext(dev, hpa_sectors);
-			else
-				hpa_sectors = ata_set_native_max_address(dev,
-								hpa_sectors);
+			"Host Protected Area detected.\n"
+			"     current size : %llu sectors (%llu MB)\n"
+			"     native  size : %llu sectors (%llu MB)\n",
+			dev->n_sectors, sectors_to_MB(dev->n_sectors),
+			hpa_sectors, sectors_to_MB(hpa_sectors));
+
+		ret_sectors = ata_hpa_set_native_size(dev, hpa_sectors);
+		if (ret_sectors != hpa_sectors) {
+			ata_dev_printk(dev, KERN_ERR,
+				"SET of native returned %llu, expected %llu\n",
+				ret_sectors, hpa_sectors);
+		}
+
+		if (ret_sectors) {
+			u16 *id = (void *)dev->ap->sector_buf;
+			int rc;
+
+			/* Re read the IDENTITY to see if the set took */
+			rc = ata_dev_read_id(dev, &dev->class,
+					     ATA_READID_POSTRESET, id);
 
-			if (hpa_sectors) {
-				ata_dev_printk(dev, KERN_INFO, "native size "
-					"increased to %lld sectors\n",
-					(long long)hpa_sectors);
-				return hpa_sectors;
+			if (rc) {
+				ata_dev_printk(dev, KERN_ERR,
+					"Failed to reread ID after SET_MAX (%d)\n",
+					rc);
+				return -EIO;
+			}
+
+			memcpy(dev->id, id, sizeof(id[0]) * ATA_ID_WORDS);
+			dev->n_sectors = ata_id_n_sectors(dev->id);
+
+			if (dev->n_sectors == hpa_sectors) {
+				ata_dev_printk(dev, KERN_INFO,
+					"Native size increased to %llu sectors\n",
+					hpa_sectors);
+			} else {
+				ata_dev_printk(dev, KERN_ERR,
+					"Failed to set native size, "
+					"drive reports %llu sectors\n",
+					dev->n_sectors);
 			}
 		}
 	}
-	return sectors;
+	return 0;
 }
 
 static u64 ata_id_n_sectors(const u16 *id)
@@ -1914,8 +1972,10 @@ int ata_dev_configure(struct ata_device 
 					dev->flags |= ATA_DFLAG_FLUSH_EXT;
 			}
 
-			if (ata_id_hpa_enabled(dev->id))
-				dev->n_sectors = ata_hpa_resize(dev);
+			/* Check for HPA, and resize if requested */
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
