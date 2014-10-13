From: akpm@linux-foundation.org
Subject: [folded-merged]
 drivers-dma-contiguous-add-initialization-from-device-tree-fix.patch
 removed from -mm tree
Date: Mon, 13 Oct 2014 14:08:50 -0700
Message-ID: <543c3f62.yo5rH3K98S7w9RoR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33254 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188AbaJMVIu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Oct 2014 17:08:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mina86@mina86.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers-dma-contiguous-add-initialization-from-device-tree-fix
has been removed from the -mm tree.  Its filename was
     drivers-dma-contiguous-add-initialization-from-device-tree-fix.patch

This patch was dropped because it was folded into drivers-dma-contiguous-add-initialization-from-device-tree.patch

------------------------------------------------------
From: Michal Nazarewicz <mina86@mina86.com>
Subject: drivers-dma-contiguous-add-initialization-from-device-tree-fix



Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/dma-contiguous.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff -puN drivers/base/dma-contiguous.c~drivers-dma-contiguous-add-initialization-from-device-tree-fix drivers/base/dma-contiguous.c
--- a/drivers/base/dma-contiguous.c~drivers-dma-contiguous-add-initialization-from-device-tree-fix
+++ a/drivers/base/dma-contiguous.c
@@ -223,13 +223,9 @@ bool dma_release_from_contiguous(struct
 #undef pr_fmt
 #define pr_fmt(fmt) fmt
 
-static int rmem_cma_device_init(struct reserved_mem *rmem, struct device *dev)
+static void rmem_cma_device_init(struct reserved_mem *rmem, struct device *dev)
 {
-	struct cma *cma = rmem->priv;
-	if (!cma)
-		return -ENODEV;
