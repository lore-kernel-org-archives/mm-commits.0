From: akpm@linux-foundation.org
Subject: - mtd-diskonchipc-fix-sparse-endian-warnings.patch removed from -mm tree
Date: Mon, 04 Aug 2008 13:06:41 -0700
Message-ID: <200808042006.m74K6fKH027709@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39987 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758173AbYHDUGp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Aug 2008 16:06:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, dwmw2@infradead.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     mtd: diskonchip.c fix sparse endian warnings
has been removed from the -mm tree.  Its filename was
     mtd-diskonchipc-fix-sparse-endian-warnings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mtd: diskonchip.c fix sparse endian warnings
From: Harvey Harrison <harvey.harrison@gmail.com>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/nand/diskonchip.c |   30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff -puN drivers/mtd/nand/diskonchip.c~mtd-diskonchipc-fix-sparse-endian-warnings drivers/mtd/nand/diskonchip.c
--- a/drivers/mtd/nand/diskonchip.c~mtd-diskonchipc-fix-sparse-endian-warnings
+++ a/drivers/mtd/nand/diskonchip.c
@@ -1125,9 +1125,9 @@ static inline int __init nftl_partscan(s
 		goto out;
 	mh = (struct NFTLMediaHeader *)buf;
 
-	mh->NumEraseUnits = le16_to_cpu(mh->NumEraseUnits);
-	mh->FirstPhysicalEUN = le16_to_cpu(mh->FirstPhysicalEUN);
-	mh->FormattedSize = le32_to_cpu(mh->FormattedSize);
+	le16_to_cpus(&mh->NumEraseUnits);
+	le16_to_cpus(&mh->FirstPhysicalEUN);
+	le32_to_cpus(&mh->FormattedSize);
 
 	printk(KERN_INFO "    DataOrgID        = %s\n"
 			 "    NumEraseUnits    = %d\n"
@@ -1235,12 +1235,12 @@ static inline int __init inftl_partscan(
 	doc->mh1_page = doc->mh0_page + (4096 >> this->page_shift);
 	mh = (struct INFTLMediaHeader *)buf;
 
-	mh->NoOfBootImageBlocks = le32_to_cpu(mh->NoOfBootImageBlocks);
-	mh->NoOfBinaryPartitions = le32_to_cpu(mh->NoOfBinaryPartitions);
-	mh->NoOfBDTLPartitions = le32_to_cpu(mh->NoOfBDTLPartitions);
-	mh->BlockMultiplierBits = le32_to_cpu(mh->BlockMultiplierBits);
-	mh->FormatFlags = le32_to_cpu(mh->FormatFlags);
-	mh->PercentUsed = le32_to_cpu(mh->PercentUsed);
+	le32_to_cpus(&mh->NoOfBootImageBlocks);
+	le32_to_cpus(&mh->NoOfBinaryPartitions);
+	le32_to_cpus(&mh->NoOfBDTLPartitions);
+	le32_to_cpus(&mh->BlockMultiplierBits);
+	le32_to_cpus(&mh->FormatFlags);
+	le32_to_cpus(&mh->PercentUsed);
 
 	printk(KERN_INFO "    bootRecordID          = %s\n"
 			 "    NoOfBootImageBlocks   = %d\n"
@@ -1277,12 +1277,12 @@ static inline int __init inftl_partscan(
 	/* Scan the partitions */
 	for (i = 0; (i < 4); i++) {
 		ip = &(mh->Partitions[i]);
-		ip->virtualUnits = le32_to_cpu(ip->virtualUnits);
-		ip->firstUnit = le32_to_cpu(ip->firstUnit);
-		ip->lastUnit = le32_to_cpu(ip->lastUnit);
-		ip->flags = le32_to_cpu(ip->flags);
-		ip->spareUnits = le32_to_cpu(ip->spareUnits);
-		ip->Reserved0 = le32_to_cpu(ip->Reserved0);
+		le32_to_cpus(&ip->virtualUnits);
+		le32_to_cpus(&ip->firstUnit);
+		le32_to_cpus(&ip->lastUnit);
+		le32_to_cpus(&ip->flags);
+		le32_to_cpus(&ip->spareUnits);
+		le32_to_cpus(&ip->Reserved0);
 
 		printk(KERN_INFO	"    PARTITION[%d] ->\n"
 			"        virtualUnits    = %d\n"
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
linux-next.patch
cifs-remove-global_extern-macro.patch
ppc-use-the-common-ascii-hex-helpers.patch
powerpc-replace-__function__-with-__func__.patch
v4l-drx397xdc-sparse-annotations.patch
v4l-drx397xdc-replace-__function__-occurrences.patch
input-ads7846c-sparse-lock-annotation.patch
drivers-net-replace-__function__-with-__func__.patch
scsi-replace-__inline-with-inline.patch
scsi-aic79xx_core-fix-shadowed-variables-add-statics.patch
scsi-aic79xx-aic79xx_pcic-fix-shadowed-variables.patch
scsi-gdthc-use-unaligned-access-helpers.patch
scsi-use-the-common-hex_asc-array-rather-than-a-private-one.patch
wireless-replace-__function__-with-__func__.patch
xfs-use-get_unaligned_-helpers.patch
xtensa-replace-remaining-__function__-occurences.patch
olpc-olpc_batteryc-sparse-endian-annotations.patch
include-replace-__function__-with-__func__.patch
misc-replace-__function__-with-__func__.patch
befs-annotate-fs32-on-tests-for-superblock-endianness.patch
byteorder-add-a-new-include-linux-swabh-to-define-byteswapping-functions.patch
byteorder-add-include-linux-byteorderh-to-define-endian-helpers.patch

