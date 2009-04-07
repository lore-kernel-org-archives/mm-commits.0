From: akpm@linux-foundation.org
Subject: [merged] update-the-old-macro-dma_nbit_mask-related-documentations.patch removed from -mm tree
Date: Tue, 07 Apr 2009 12:08:08 -0700
Message-ID: <200904071908.n37J880P011670@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45498 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756376AbZDGTJc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Apr 2009 15:09:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yanghy@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     dma-mapping: update the old macro DMA_nBIT_MASK related documentations
has been removed from the -mm tree.  Its filename was
     update-the-old-macro-dma_nbit_mask-related-documentations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dma-mapping: update the old macro DMA_nBIT_MASK related documentations
From: Yang Hongyang <yanghy@cn.fujitsu.com>

Update the old macro DMA_nBIT_MASK related documentations

Signed-off-by: Yang Hongyang<yanghy@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/DMA-mapping.txt                     |   18 ++++++------
 Documentation/DocBook/writing-an-alsa-driver.tmpl |    8 ++---
 2 files changed, 13 insertions(+), 13 deletions(-)

diff -puN Documentation/DMA-mapping.txt~update-the-old-macro-dma_nbit_mask-related-documentations Documentation/DMA-mapping.txt
--- a/Documentation/DMA-mapping.txt~update-the-old-macro-dma_nbit_mask-related-documentations
+++ a/Documentation/DMA-mapping.txt
@@ -136,7 +136,7 @@ exactly why.
 The standard 32-bit addressing PCI device would do something like
 this:
 
-	if (pci_set_dma_mask(pdev, DMA_32BIT_MASK)) {
+	if (pci_set_dma_mask(pdev, DMA_BIT_MASK(32))) {
 		printk(KERN_WARNING
 		       "mydev: No suitable DMA available.\n");
 		goto ignore_this_device;
@@ -155,9 +155,9 @@ all 64-bits when accessing streaming DMA
 
 	int using_dac;
 
-	if (!pci_set_dma_mask(pdev, DMA_64BIT_MASK)) {
+	if (!pci_set_dma_mask(pdev, DMA_BIT_MASK(64))) {
 		using_dac = 1;
-	} else if (!pci_set_dma_mask(pdev, DMA_32BIT_MASK)) {
+	} else if (!pci_set_dma_mask(pdev, DMA_BIT_MASK(32))) {
 		using_dac = 0;
 	} else {
 		printk(KERN_WARNING
@@ -170,14 +170,14 @@ the case would look like this:
 
 	int using_dac, consistent_using_dac;
 
-	if (!pci_set_dma_mask(pdev, DMA_64BIT_MASK)) {
+	if (!pci_set_dma_mask(pdev, DMA_BIT_MASK(64))) {
 		using_dac = 1;
 	   	consistent_using_dac = 1;
-		pci_set_consistent_dma_mask(pdev, DMA_64BIT_MASK);
-	} else if (!pci_set_dma_mask(pdev, DMA_32BIT_MASK)) {
+		pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64));
+	} else if (!pci_set_dma_mask(pdev, DMA_BIT_MASK(32))) {
 		using_dac = 0;
 		consistent_using_dac = 0;
-		pci_set_consistent_dma_mask(pdev, DMA_32BIT_MASK);
+		pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
 	} else {
 		printk(KERN_WARNING
 		       "mydev: No suitable DMA available.\n");
@@ -192,7 +192,7 @@ check the return value from pci_set_cons
 Finally, if your device can only drive the low 24-bits of
 address during PCI bus mastering you might do something like:
 
-	if (pci_set_dma_mask(pdev, DMA_24BIT_MASK)) {
+	if (pci_set_dma_mask(pdev, DMA_BIT_MASK(24))) {
 		printk(KERN_WARNING
 		       "mydev: 24-bit DMA addressing not available.\n");
 		goto ignore_this_device;
@@ -213,7 +213,7 @@ most specific mask.
 
 Here is pseudo-code showing how this might be done:
 
-	#define PLAYBACK_ADDRESS_BITS	DMA_32BIT_MASK
+	#define PLAYBACK_ADDRESS_BITS	DMA_BIT_MASK(32)
 	#define RECORD_ADDRESS_BITS	0x00ffffff
 
 	struct my_sound_card *card;
diff -puN Documentation/DocBook/writing-an-alsa-driver.tmpl~update-the-old-macro-dma_nbit_mask-related-documentations Documentation/DocBook/writing-an-alsa-driver.tmpl
--- a/Documentation/DocBook/writing-an-alsa-driver.tmpl~update-the-old-macro-dma_nbit_mask-related-documentations
+++ a/Documentation/DocBook/writing-an-alsa-driver.tmpl
@@ -1137,8 +1137,8 @@
           if (err < 0)
                   return err;
           /* check PCI availability (28bit DMA) */
-          if (pci_set_dma_mask(pci, DMA_28BIT_MASK) < 0 ||
-              pci_set_consistent_dma_mask(pci, DMA_28BIT_MASK) < 0) {
+          if (pci_set_dma_mask(pci, DMA_BIT_MASK(28)) < 0 ||
+              pci_set_consistent_dma_mask(pci, DMA_BIT_MASK(28)) < 0) {
                   printk(KERN_ERR "error to set 28bit mask DMA\n");
                   pci_disable_device(pci);
                   return -ENXIO;
@@ -1252,8 +1252,8 @@
   err = pci_enable_device(pci);
   if (err < 0)
           return err;
-  if (pci_set_dma_mask(pci, DMA_28BIT_MASK) < 0 ||
-      pci_set_consistent_dma_mask(pci, DMA_28BIT_MASK) < 0) {
+  if (pci_set_dma_mask(pci, DMA_BIT_MASK(28)) < 0 ||
+      pci_set_consistent_dma_mask(pci, DMA_BIT_MASK(28)) < 0) {
           printk(KERN_ERR "error to set 28bit mask DMA\n");
           pci_disable_device(pci);
           return -ENXIO;
_

Patches currently in -mm which might be from yanghy@cn.fujitsu.com are

origin.patch

