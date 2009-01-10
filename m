From: akpm@linux-foundation.org
Subject: - ata-replace-byteshifting-with-unaligned-endian-helpers.patch removed from -mm tree
Date: Fri, 09 Jan 2009 16:16:59 -0800
Message-ID: <200901100033.n0A0XPrq007371@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59104 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755956AbZAJAd5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jan 2009 19:33:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, mm-commits@vger.kernel.org


The patch titled
     ata: replace byteshifting with unaligned endian helpers
has been removed from the -mm tree.  Its filename was
     ata-replace-byteshifting-with-unaligned-endian-helpers.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ata: replace byteshifting with unaligned endian helpers
From: Harvey Harrison <harvey.harrison@gmail.com>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/libata-scsi.c |   50 +++++-------------------------------
 1 file changed, 7 insertions(+), 43 deletions(-)

diff -puN drivers/ata/libata-scsi.c~ata-replace-byteshifting-with-unaligned-endian-helpers drivers/ata/libata-scsi.c
--- a/drivers/ata/libata-scsi.c~ata-replace-byteshifting-with-unaligned-endian-helpers
+++ a/drivers/ata/libata-scsi.c
@@ -46,6 +46,7 @@
 #include <linux/libata.h>
 #include <linux/hdreg.h>
 #include <linux/uaccess.h>
+#include <asm/unaligned.h>
 
 #include "libata.h"
 
@@ -1384,19 +1385,10 @@ static unsigned int ata_scsi_flush_xlat(
  */
 static void scsi_6_lba_len(const u8 *cdb, u64 *plba, u32 *plen)
 {
-	u64 lba = 0;
-	u32 len;
-
 	VPRINTK("six-byte command\n");
 
-	lba |= ((u64)(cdb[1] & 0x1f)) << 16;
-	lba |= ((u64)cdb[2]) << 8;
-	lba |= ((u64)cdb[3]);
-
-	len = cdb[4];
-
-	*plba = lba;
-	*plen = len;
+	*plba = load_be32_noalign((__be32 *)&cdb[0]) & 0x1fffff;
+	*plen = cdb[4];
 }
 
 /**
@@ -1411,21 +1403,10 @@ static void scsi_6_lba_len(const u8 *cdb
  */
 static void scsi_10_lba_len(const u8 *cdb, u64 *plba, u32 *plen)
 {
-	u64 lba = 0;
-	u32 len = 0;
-
 	VPRINTK("ten-byte command\n");
 
-	lba |= ((u64)cdb[2]) << 24;
-	lba |= ((u64)cdb[3]) << 16;
-	lba |= ((u64)cdb[4]) << 8;
-	lba |= ((u64)cdb[5]);
-
-	len |= ((u32)cdb[7]) << 8;
-	len |= ((u32)cdb[8]);
-
-	*plba = lba;
-	*plen = len;
+	*plba = load_be32_noalign((__be32 *)&cdb[2]);
+	*plen = load_be16_noalign((__be16 *)&cdb[7]);
 }
 
 /**
@@ -1440,27 +1421,10 @@ static void scsi_10_lba_len(const u8 *cd
  */
 static void scsi_16_lba_len(const u8 *cdb, u64 *plba, u32 *plen)
 {
-	u64 lba = 0;
-	u32 len = 0;
-
 	VPRINTK("sixteen-byte command\n");
 
-	lba |= ((u64)cdb[2]) << 56;
-	lba |= ((u64)cdb[3]) << 48;
-	lba |= ((u64)cdb[4]) << 40;
-	lba |= ((u64)cdb[5]) << 32;
-	lba |= ((u64)cdb[6]) << 24;
-	lba |= ((u64)cdb[7]) << 16;
-	lba |= ((u64)cdb[8]) << 8;
-	lba |= ((u64)cdb[9]);
-
-	len |= ((u32)cdb[10]) << 24;
-	len |= ((u32)cdb[11]) << 16;
-	len |= ((u32)cdb[12]) << 8;
-	len |= ((u32)cdb[13]);
