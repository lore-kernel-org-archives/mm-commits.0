From: akpm@linux-foundation.org
Subject: [merged] mmc_core-fix-data-timeout-for-send_ext_csd.patch removed from -mm tree
Date: Mon, 09 Mar 2009 11:27:37 -0700
Message-ID: <200903091827.n29IRb1L024847@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50833 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752176AbZCIS21 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Mar 2009 14:28:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ext-adrian.hunter@nokia.com, drzeus@drzeus.cx, matt@console-pimps.org, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     mmc_core: fix data timeout for SEND_EXT_CSD
has been removed from the -mm tree.  Its filename was
     mmc_core-fix-data-timeout-for-send_ext_csd.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mmc_core: fix data timeout for SEND_EXT_CSD
From: Adrian Hunter <ext-adrian.hunter@nokia.com>

Commit 0d3e0460f307e84904968aad6cff97bd688583d8 "MMC: CSD and CID timeout
values" inadvertently broke the timeout for the MMC command SEND_EXT_CSD.

This patch puts it back again.

Signed-off-by: Adrian Hunter <ext-adrian.hunter@nokia.com>
Cc: Matt Fleming <matt@console-pimps.org>
Cc: Pierre Ossman <drzeus@drzeus.cx>
Cc: <stable@kernel.org>		[2.6.28.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/core/mmc_ops.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff -puN drivers/mmc/core/mmc_ops.c~mmc_core-fix-data-timeout-for-send_ext_csd drivers/mmc/core/mmc_ops.c
--- a/drivers/mmc/core/mmc_ops.c~mmc_core-fix-data-timeout-for-send_ext_csd
+++ a/drivers/mmc/core/mmc_ops.c
@@ -248,12 +248,16 @@ mmc_send_cxd_data(struct mmc_card *card,
 
 	sg_init_one(&sg, data_buf, len);
 
-	/*
-	 * The spec states that CSR and CID accesses have a timeout
-	 * of 64 clock cycles.
-	 */
-	data.timeout_ns = 0;
-	data.timeout_clks = 64;
+	if (!mmc_host_is_spi(host) && opcode == MMC_SEND_EXT_CSD)
+		mmc_set_data_timeout(&data, card);
+	else {
+		/*
+		 * The spec states that CSR and CID accesses have a timeout
+		 * of 64 clock cycles (8 for SPI).
+		 */
+		data.timeout_ns = 0;
+		data.timeout_clks = 64;
+	}
 
 	mmc_wait_for_req(host, &mrq);
 
_

Patches currently in -mm which might be from ext-adrian.hunter@nokia.com are

fs-new-inode-i_state-corruption-fix.patch
linux-next.patch
mmc-add-extended-csd-register-to-debugfs.patch
mtd-onenand-add-write-while-program-support.patch

