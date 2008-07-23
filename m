From: akpm@linux-foundation.org
Subject: - fsl-diu-fb-update-freescale-diu-driver-to-use-page_alloc_exact-update.patch removed from -mm tree
Date: Wed, 23 Jul 2008 16:40:16 -0700
Message-ID: <200807232352.m6NNqrb8018796@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59310 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755049AbYGWXxA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Jul 2008 19:53:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: timur@freescale.com, mm-commits@vger.kernel.org


The patch titled
     fsl-diu-fb-update-freescale-diu-driver-to-use-page_alloc_exact-update
has been removed from the -mm tree.  Its filename was
     fsl-diu-fb-update-freescale-diu-driver-to-use-page_alloc_exact-update.patch

This patch was dropped because it was folded into fsl-diu-fb-update-freescale-diu-driver-to-use-page_alloc_exact.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fsl-diu-fb-update-freescale-diu-driver-to-use-page_alloc_exact-update
From: Timur Tabi <timur@freescale.com>

Fix printk format specifiers, per Andrew Morton.

Signed-off-by: Timur Tabi <timur@freescale.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/fsl-diu-fb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/fsl-diu-fb.c~fsl-diu-fb-update-freescale-diu-driver-to-use-page_alloc_exact-update drivers/video/fsl-diu-fb.c
--- a/drivers/video/fsl-diu-fb.c~fsl-diu-fb-update-freescale-diu-driver-to-use-page_alloc_exact-update
+++ a/drivers/video/fsl-diu-fb.c
@@ -295,7 +295,7 @@ static void *fsl_diu_alloc(size_t size, 
 	virt = alloc_pages_exact(size, GFP_DMA | __GFP_ZERO);
 	if (virt) {
 		*phys = virt_to_phys(virt);
-		pr_debug("virt=%p, phys=%llx\n", virt,
+		pr_debug("virt=%p phys=%llx\n", virt,
 			(unsigned long long)*phys);
 	}
 
_

Patches currently in -mm which might be from timur@freescale.com are

origin.patch
mm-add-alloc_pages_exact-and-free_pages_exact.patch
fsl-diu-fb-update-freescale-diu-driver-to-use-page_alloc_exact.patch
fsl-diu-fb-update-freescale-diu-driver-to-use-page_alloc_exact-update.patch

