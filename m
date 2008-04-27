From: akpm@linux-foundation.org
Subject: + dma-document-dma_map_attrs-interfaces-fix.patch added to -mm tree
Date: Sun, 27 Apr 2008 12:23:10 -0700
Message-ID: <200804271923.m3RJNA5P020980@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52096 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753342AbYD0TXR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 27 Apr 2008 15:23:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: markn@au1.ibm.com, akepner@sgi.com


The patch titled
     fix up for dma-add-dma_map_attrs-interfaces and update docs
has been added to the -mm tree.  Its filename is
     dma-document-dma_map_attrs-interfaces-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fix up for dma-add-dma_map_attrs-interfaces and update docs
From: Mark Nelson <markn@au1.ibm.com>

Fix up the documentation for the new dma attrs (still refers to
DECLARE_DMA_ATTRS and the arguments to dma_{set,get}_attr() have been swapped
around).

Signed-off-by: Mark Nelson <markn@au1.ibm.com>
Cc: Arthur Kepner <akepner@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/DMA-API.txt |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN Documentation/DMA-API.txt~dma-document-dma_map_attrs-interfaces-fix Documentation/DMA-API.txt
--- a/Documentation/DMA-API.txt~dma-document-dma_map_attrs-interfaces-fix
+++ a/Documentation/DMA-API.txt
@@ -439,8 +439,8 @@ for DMA:
  * documented in Documentation/DMA-attributes.txt */
 ...
 
-	DECLARE_DMA_ATTRS(attrs);
-	dma_set_attr(&attrs, DMA_ATTR_FOO);
+	DEFINE_DMA_ATTRS(attrs);
+	dma_set_attr(DMA_ATTR_FOO, &attrs);
 	....
 	n = dma_map_sg_attrs(dev, sg, nents, DMA_TO_DEVICE, &attr);
 	....
@@ -454,7 +454,7 @@ void whizco_dma_map_sg_attrs(struct devi
 			     struct dma_attrs *attrs)
 {
 	....
-	int foo =  dma_get_attr(attrs, DMA_ATTR_FOO);
+	int foo =  dma_get_attr(DMA_ATTR_FOO, attrs);
 	....
 	if (foo)
 		/* twizzle the frobnozzle */
_

Patches currently in -mm which might be from markn@au1.ibm.com are

dma-add-dma_map_attrs-interfaces-fix.patch
dma-document-dma_map_attrs-interfaces-fix.patch

