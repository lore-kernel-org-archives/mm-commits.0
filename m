From: akpm@linux-foundation.org
Subject: + ata-replace-byteshifting-with-unaligned-endian-helpers.patch added to -mm tree
Date: Sat, 06 Dec 2008 19:33:14 -0800
Message-ID: <200812070333.mB73XElH015725@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33294 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753366AbYLGDdR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 6 Dec 2008 22:33:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com


The patch titled
     ata: replace byteshifting with unaligned endian helpers
has been added to the -mm tree.  Its filename is
     ata-replace-byteshifting-with-unaligned-endian-helpers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
-
-	*plba = lba;
-	*plen = len;
+	*plba = load_be64_noalign((__be64 *)&cdb[2]);
+	*plen = load_be32_noalign((__be32 *)&cdb[10]);
 }
 
 /**
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
linux-next.patch
arm-use-the-new-byteorder-headers.patch
i2c-misannotation-in-i2c-pmcmspc.patch
i2c-trivial-endian-casting-fixes-in-i2c-highlanderc.patch
ia64-use-the-new-byteorder-headers.patch
input-ads7846c-sparse-lock-annotation.patch
input-strict_strtoul-takes-unsigned-long.patch
m32r-use-the-new-byteorder-headers.patch
blackfin-use-the-new-byteorder-headers.patch
parisc-use-the-new-byteorder-headers.patch
scsi-replace-__inline-with-inline.patch
scsi-use-the-common-hex_asc-array-rather-than-a-private-one.patch
scsi-gdthc-use-unaligned-access-helpers.patch
scsi-annotate-gdth_rdcap_data-gdth_rdcap16_data-endianness.patch
frv-use-the-new-byteorder-headers.patch
m68knommu-use-the-new-byteorder-headers.patch
h8300-use-the-new-byteorder-headers.patch
alpha-use-the-new-byteorder-headers.patch
lib-fix-sparse-shadowed-variable-warning.patch
lib-radix_treec-make-percpu-variable-static.patch
lib-proportionsc-trivial-sparse-lock-annotation.patch
ibmpex-add-endian-annotation-to-extract_data-helper.patch
blackfin-remove-__function__-in-video-driver.patch
fb-carminefb-trivial-annotation-packing-color-register.patch
memstick-annotate-endianness-of-attribute-structs.patch
byteorder-add-load_-store_endian-api.patch
unaligned-consolidate-unaligned-headers-add-load_-store_endian_noalign.patch
unaligned-wire-up-trivial-arches-for-new-common-unaligned-header.patch
sh-wire-up-arch-overrides-for-unaligned-access-on-the-sh4a.patch
unaligned-wire-up-h8300-and-m32r-arches.patch
unaligned-wire-up-arm-arch-overrides-for-unaligned-access.patch
unaligned-remove-the-old-implementation.patch
ata-replace-byteshifting-with-unaligned-endian-helpers.patch
crypto-replace-private-helper-with-common-unaligned-endian-helper.patch

