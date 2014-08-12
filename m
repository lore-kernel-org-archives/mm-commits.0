From: akpm@linux-foundation.org
Subject: [merged] i810-use-pci_zalloc_consistent.patch removed from -mm
 tree
Date: Tue, 12 Aug 2014 12:42:27 -0700
Message-ID: <53ea6e23.ImjDDvyXoxpGlC4H%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ig0-f201.google.com ([209.85.213.201]:40114 "EHLO
	mail-ig0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754606AbaHLTm2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:42:28 -0400
Received: by mail-ig0-f201.google.com with SMTP id h3so1069982igd.2
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:42:27 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, airlied@linux.ie, mm-commits@vger.kernel.org


The patch titled
     Subject: i810: use pci_zalloc_consistent
has been removed from the -mm tree.  Its filename was
     i810-use-pci_zalloc_consistent.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: i810: use pci_zalloc_consistent

Remove the now unnecessary memset too.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: David Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/i810/i810_dma.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN drivers/gpu/drm/i810/i810_dma.c~i810-use-pci_zalloc_consistent drivers/gpu/drm/i810/i810_dma.c
--- a/drivers/gpu/drm/i810/i810_dma.c~i810-use-pci_zalloc_consistent
+++ a/drivers/gpu/drm/i810/i810_dma.c
@@ -393,15 +393,14 @@ static int i810_dma_initialize(struct dr
 
 	/* Program Hardware Status Page */
 	dev_priv->hw_status_page =
-	    pci_alloc_consistent(dev->pdev, PAGE_SIZE,
-				 &dev_priv->dma_status_page);
+		pci_zalloc_consistent(dev->pdev, PAGE_SIZE,
+				      &dev_priv->dma_status_page);
 	if (!dev_priv->hw_status_page) {
 		dev->dev_private = (void *)dev_priv;
 		i810_dma_cleanup(dev);
 		DRM_ERROR("Can not allocate hardware status page\n");
 		return -ENOMEM;
 	}
-	memset(dev_priv->hw_status_page, 0, PAGE_SIZE);
 	DRM_DEBUG("hw status page @ %p\n", dev_priv->hw_status_page);
 
 	I810_WRITE(0x02080, dev_priv->dma_status_page);
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
mm-utilc-add-kstrimdup.patch
fs-isofs-logging-clean-up.patch
linux-next.patch

