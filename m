From: akpm@linux-foundation.org
Subject: + update-the-old-macro-dma_nbit_mask-related-documentations.patch added to -mm tree
Date: Thu, 19 Feb 2009 15:14:46 -0800
Message-ID: <200902192314.n1JNEk1v029822@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37252 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752516AbZBSXUn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Feb 2009 18:20:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yanghy@cn.fujitsu.com


The patch titled
     dma-mapping: update the old macro DMA_nBIT_MASK related documentations
has been added to the -mm tree.  Its filename is
     update-the-old-macro-dma_nbit_mask-related-documentations.patch

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
Subject: dma-mapping: update the old macro DMA_nBIT_MASK related documentations
From: Yang Hongyang <yanghy@cn.fujitsu.com>

Update the old macro DMA_nBIT_MASK related documentations

Signed-off-by: Yang Hongyang<yanghy@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/DMA-mapping.txt                                |   18 +++++-----
 Documentation/sound/alsa/DocBook/writing-an-alsa-driver.tmpl |    8 ++--
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
diff -puN Documentation/sound/alsa/DocBook/writing-an-alsa-driver.tmpl~update-the-old-macro-dma_nbit_mask-related-documentations Documentation/sound/alsa/DocBook/writing-an-alsa-driver.tmpl
--- a/Documentation/sound/alsa/DocBook/writing-an-alsa-driver.tmpl~update-the-old-macro-dma_nbit_mask-related-documentations
+++ a/Documentation/sound/alsa/DocBook/writing-an-alsa-driver.tmpl
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

replace-all-dma_64bit_mask-macro-with-dma_bit_mask64.patch
replace-all-dma_48bit_mask-macro-with-dma_bit_mask48.patch
replace-all-dma_40bit_mask-macro-with-dma_bit_mask40.patch
replace-all-dma_39bit_mask-macro-with-dma_bit_mask39.patch
replace-all-dma_35bit_mask-macro-with-dma_bit_mask35.patch
replace-all-dma_32bit_mask-macro-with-dma_bit_mask32.patch
replace-all-dma_31bit_mask-macro-with-dma_bit_mask31.patch
replace-all-dma_30bit_mask-macro-with-dma_bit_mask30.patch
replace-all-dma_28bit_mask-macro-with-dma_bit_mask28.patch
replace-all-dma_24bit_mask-macro-with-dma_bit_mask24.patch
update-the-old-macro-dma_nbit_mask-related-documentations.patch
update-related-documentations.patch

