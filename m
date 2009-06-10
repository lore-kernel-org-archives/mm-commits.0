From: akpm@linux-foundation.org
Subject: [to-be-updated] mmc-align-data-size-for-host-which-only-supports-power-of-2-block.patch removed from -mm tree
Date: Wed, 10 Jun 2009 12:51:20 -0700
Message-ID: <200906101951.n5AJpK58005182@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43951 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755139AbZFJTwc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Jun 2009 15:52:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cliff.cai@analog.com, cooloney@kernel.org, drzeus@drzeus.cx, mm-commits@vger.kernel.org


The patch titled
     mmc: align data size for host which only supports power-of-2 block
has been removed from the -mm tree.  Its filename was
     mmc-align-data-size-for-host-which-only-supports-power-of-2-block.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mmc: align data size for host which only supports power-of-2 block
From: Cliff Cai <cliff.cai@analog.com>

Signed-off-by: Cliff Cai <cliff.cai@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Cc: Pierre Ossman <drzeus@drzeus.cx>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/core/core.c  |    8 +++++++-
 include/linux/mmc/host.h |    1 +
 2 files changed, 8 insertions(+), 1 deletion(-)

diff -puN drivers/mmc/core/core.c~mmc-align-data-size-for-host-which-only-supports-power-of-2-block drivers/mmc/core/core.c
--- a/drivers/mmc/core/core.c~mmc-align-data-size-for-host-which-only-supports-power-of-2-block
+++ a/drivers/mmc/core/core.c
@@ -337,7 +337,13 @@ unsigned int mmc_align_data_size(struct 
 	 * the core about its problems yet, so for now we just 32-bit
 	 * align the size.
 	 */
-	sz = ((sz + 3) / 4) * 4;
+
+	/* Align size for host which only supports power-of-2 block */
+	if (card->host->powerof2_block) {
+		if (sz & (sz - 1))
+			sz = 1 << fls(sz);
+	} else
+		sz = ((sz + 3) / 4) * 4;
 
 	return sz;
 }
diff -puN include/linux/mmc/host.h~mmc-align-data-size-for-host-which-only-supports-power-of-2-block include/linux/mmc/host.h
--- a/include/linux/mmc/host.h~mmc-align-data-size-for-host-which-only-supports-power-of-2-block
+++ a/include/linux/mmc/host.h
@@ -162,6 +162,7 @@ struct mmc_host {
 	struct dentry		*debugfs_root;
 
 	unsigned long		private[0] ____cacheline_aligned;
+	unsigned int		powerof2_block;	/* host only supports power-of-2 block */
 };
 
 extern struct mmc_host *mmc_alloc_host(int extra, struct device *);
_

Patches currently in -mm which might be from cliff.cai@analog.com are

linux-next.patch
mmc-align-data-size-for-host-which-only-supports-power-of-2-block.patch

