From: akpm@linux-foundation.org
Subject: [merged] sdhci-add-adma-descriptor-set-call.patch removed from -mm tree
Date: Tue, 09 Mar 2010 11:08:02 -0800
Message-ID: <201003091908.o29J823o031409@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55045 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756039Ab0CITWs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:22:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ben-linux@fluff.org, linux-mmc@vger.kernel.org, pierre@ossman.eu, mm-commits@vger.kernel.org


The patch titled
     sdhci: add adma descriptor set call
has been removed from the -mm tree.  Its filename was
     sdhci-add-adma-descriptor-set-call.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sdhci: add adma descriptor set call
From: Ben Dooks <ben-linux@fluff.org>

The code to write the ADMA descriptor into memory is repeated several
times throughout sdhci_adma_table_pre, and thus should be moved into a
common function.  This will also be useful if the patch to make the write
more efficient is accepted.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>
Cc: Pierre Ossman <pierre@ossman.eu>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/sdhci.c |   50 ++++++++++++++-----------------------
 1 file changed, 20 insertions(+), 30 deletions(-)

diff -puN drivers/mmc/host/sdhci.c~sdhci-add-adma-descriptor-set-call drivers/mmc/host/sdhci.c
--- a/drivers/mmc/host/sdhci.c~sdhci-add-adma-descriptor-set-call
+++ a/drivers/mmc/host/sdhci.c
@@ -376,6 +376,20 @@ static void sdhci_kunmap_atomic(void *bu
 	local_irq_restore(*flags);
 }
 
+static void sdhci_set_adma_desc(u8 *desc, u32 addr, int len, unsigned cmd)
+{
+	desc[7] = (addr >> 24) & 0xff;
+	desc[6] = (addr >> 16) & 0xff;
+	desc[5] = (addr >> 8) & 0xff;
+	desc[4] = (addr >> 0) & 0xff;
+
+	desc[3] = (len >> 8) & 0xff;
+	desc[2] = (len >> 0) & 0xff;
+
+	desc[0] = cmd & 0xff;
+	desc[1] = cmd >> 8;
+}
+
 static int sdhci_adma_table_pre(struct sdhci_host *host,
 	struct mmc_data *data)
 {
@@ -443,19 +457,11 @@ static int sdhci_adma_table_pre(struct s
 				sdhci_kunmap_atomic(buffer, &flags);
 			}
 
-			desc[7] = (align_addr >> 24) & 0xff;
-			desc[6] = (align_addr >> 16) & 0xff;
-			desc[5] = (align_addr >> 8) & 0xff;
-			desc[4] = (align_addr >> 0) & 0xff;
+			/* tran, valid */
+			sdhci_set_adma_desc(desc, align_addr, offset, 0x21);
 
 			BUG_ON(offset > 65536);
 
-			desc[3] = (offset >> 8) & 0xff;
-			desc[2] = (offset >> 0) & 0xff;
-
-			desc[1] = 0x00;
-			desc[0] = 0x21; /* tran, valid */
-
 			align += 4;
 			align_addr += 4;
 
@@ -465,19 +471,10 @@ static int sdhci_adma_table_pre(struct s
 			len -= offset;
 		}
 
-		desc[7] = (addr >> 24) & 0xff;
-		desc[6] = (addr >> 16) & 0xff;
-		desc[5] = (addr >> 8) & 0xff;
-		desc[4] = (addr >> 0) & 0xff;
-
 		BUG_ON(len > 65536);
 
-		desc[3] = (len >> 8) & 0xff;
-		desc[2] = (len >> 0) & 0xff;
-
-		desc[1] = 0x00;
-		desc[0] = 0x21; /* tran, valid */
-
+		/* tran, valid */
+		sdhci_set_adma_desc(desc, addr, len, 0x21);
 		desc += 8;
 
 		/*
@@ -490,16 +487,9 @@ static int sdhci_adma_table_pre(struct s
 	/*
 	 * Add a terminating entry.
 	 */
-	desc[7] = 0;
-	desc[6] = 0;
-	desc[5] = 0;
-	desc[4] = 0;
