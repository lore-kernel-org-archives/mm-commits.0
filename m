From: akpm@linux-foundation.org
Subject: [merged] sdhci-improve-sdhci-sdhci_set_adma_desc-code.patch removed from -mm tree
Date: Tue, 09 Mar 2010 11:08:06 -0800
Message-ID: <201003091908.o29J86OK031414__30922.5557059564$1268161769$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50408 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753153Ab0CITJW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:09:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ben-linux@fluff.org, linux-mmc@vger.kernel.org, pierre@ossman.eu, mm-commits@vger.kernel.org


The patch titled
     sdhci: improve sdhci sdhci_set_adma_desc() code
has been removed from the -mm tree.  Its filename was
     sdhci-improve-sdhci-sdhci_set_adma_desc-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sdhci: improve sdhci sdhci_set_adma_desc() code
From: Ben Dooks <ben-linux@fluff.org>

sdhci_set_adma_desc() is using byte-writes to write data in a specified
order into memory.  Change to using __le16 for the two byte and __le32 for
the four byte cases and use the cpu_to_{le16,le32} to do the conversion
before writing.

This will reduce the size of the code and the number of writes as we no
longer need to chop the data up before writing.

As an example on ARM S3C64XX SoC, in little-endian configuration:

 000000d4 <sdhci_set_adma_desc>:
-      d8:	e1a0c423 	lsr	ip, r3, #8
-      dc:	e1a0ec21 	lsr	lr, r1, #24
-      e0:	e1a04821 	lsr	r4, r1, #16
-      e4:	e1a05421 	lsr	r5, r1, #8
-      e8:	e1a06442 	asr	r6, r2, #8
-      ec:	e5c0c001 	strb	ip, [r0, #1]
-      f0:	e5c0e007 	strb	lr, [r0, #7]
-      f4:	e5c04006 	strb	r4, [r0, #6]
-      f8:	e5c05005 	strb	r5, [r0, #5]
-      fc:	e5c01004 	strb	r1, [r0, #4]
-     100:	e5c06003 	strb	r6, [r0, #3]
-     104:	e5c02002 	strb	r2, [r0, #2]
-     108:	e5c03000 	strb	r3, [r0]
+      d4:	e5801004 	str	r1, [r0, #4]
+      d8:	e1c030b0 	strh	r3, [r0]
+      dc:	e1c020b2 	strh	r2, [r0, #2]

Signed-off-by: Ben Dooks <ben-linux@fluff.org>
Cc: Pierre Ossman <pierre@ossman.eu>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/sdhci.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN drivers/mmc/host/sdhci.c~sdhci-improve-sdhci-sdhci_set_adma_desc-code drivers/mmc/host/sdhci.c
--- a/drivers/mmc/host/sdhci.c~sdhci-improve-sdhci-sdhci_set_adma_desc-code
+++ a/drivers/mmc/host/sdhci.c
@@ -378,16 +378,16 @@ static void sdhci_kunmap_atomic(void *bu
 
 static void sdhci_set_adma_desc(u8 *desc, u32 addr, int len, unsigned cmd)
 {
-	desc[7] = (addr >> 24) & 0xff;
-	desc[6] = (addr >> 16) & 0xff;
-	desc[5] = (addr >> 8) & 0xff;
-	desc[4] = (addr >> 0) & 0xff;
+	__le32 *dataddr = (__le32 __force *)(desc + 4);
+	__le16 *cmdlen = (__le16 __force *)desc;
 
-	desc[3] = (len >> 8) & 0xff;
-	desc[2] = (len >> 0) & 0xff;
+	/* SDHCI specification says ADMA descriptors should be 4 byte
+	 * aligned, so using 16 or 32bit operations should be safe. */
 
-	desc[0] = cmd & 0xff;
-	desc[1] = cmd >> 8;
+	cmdlen[0] = cpu_to_le16(cmd);
+	cmdlen[1] = cpu_to_le16(len);
+
+	dataddr[0] = cpu_to_le32(addr);
 }
 
 static int sdhci_adma_table_pre(struct sdhci_host *host,
_

Patches currently in -mm which might be from ben-linux@fluff.org are

linux-next.patch

