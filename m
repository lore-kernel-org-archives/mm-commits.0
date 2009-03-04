From: akpm@linux-foundation.org
Subject: [folded] sdio-driver-for-marvell-socs-update.patch removed from -mm tree
Date: Wed, 04 Mar 2009 11:47:58 -0800
Message-ID: <200903041947.n24Jlwre027194@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56733 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755862AbZCDTsF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Mar 2009 14:48:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: maen@marvell.com, drzeus-mmc@drzeus.cx, nico@marvell.com, mm-commits@vger.kernel.org


The patch titled
     sdio-driver-for-marvell-socs update
has been removed from the -mm tree.  Its filename was
     sdio-driver-for-marvell-socs-update.patch

This patch was dropped because it was folded into sdio-driver-for-marvell-socs.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sdio-driver-for-marvell-socs update
From: Maen Suleiman <maen@marvell.com>

fix leak

Signed-off-by: Nicolas Pitre <nico@marvell.com>
Cc: Maen Suleiman <maen@marvell.com>
Cc: Pierre Ossman <drzeus-mmc@drzeus.cx>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/mvsdio.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/mmc/host/mvsdio.c~sdio-driver-for-marvell-socs-update drivers/mmc/host/mvsdio.c
--- a/drivers/mmc/host/mvsdio.c~sdio-driver-for-marvell-socs-update
+++ a/drivers/mmc/host/mvsdio.c
@@ -688,6 +688,7 @@ static int __init mvsd_probe(struct plat
 
 	mmc = mmc_alloc_host(sizeof(struct mvsd_host), &pdev->dev);
 	if (!mmc) {
+		release_resource(r);
 		ret = -ENOMEM;
 		goto out;
 	}
_

Patches currently in -mm which might be from maen@marvell.com are

sdio-driver-for-marvell-socs.patch
sdio-driver-for-marvell-socs-update.patch

