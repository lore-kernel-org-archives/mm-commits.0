From: akpm@linux-foundation.org
Subject: - goku_udc-remove-crude-cache-coherency-code.patch removed from -mm tree
Date: Wed, 28 Feb 2007 15:53:54 -0800
Message-ID: <200702282353.l1SNrsIe031156@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:48626 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932784AbXB1X5P (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Feb 2007 18:57:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ralf@linux-mips.org, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     usb: goku_udc: Remove crude cache coherency code
has been removed from the -mm tree.  Its filename was
     goku_udc-remove-crude-cache-coherency-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: usb: goku_udc: Remove crude cache coherency code
From: Ralf Baechle <ralf@linux-mips.org>

This is deep architecture specific magic and does should not to exist in a
driver.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/gadget/goku_udc.c |   29 -----------------------------
 1 file changed, 29 deletions(-)

diff -puN drivers/usb/gadget/goku_udc.c~goku_udc-remove-crude-cache-coherency-code drivers/usb/gadget/goku_udc.c
--- a/drivers/usb/gadget/goku_udc.c~goku_udc-remove-crude-cache-coherency-code
+++ a/drivers/usb/gadget/goku_udc.c
@@ -297,27 +297,6 @@ goku_free_request(struct usb_ep *_ep, st
 
 /*-------------------------------------------------------------------------*/
 
-#undef USE_KMALLOC
-
-/* many common platforms have dma-coherent caches, which means that it's
- * safe to use kmalloc() memory for all i/o buffers without using any
- * cache flushing calls.  (unless you're trying to share cache lines
- * between dma and non-dma activities, which is a slow idea in any case.)
- *
- * other platforms need more care, with 2.6 having a moderately general
- * solution except for the common "buffer is smaller than a page" case.
- */
-#if	defined(CONFIG_X86)
-#define USE_KMALLOC
-
-#elif	defined(CONFIG_MIPS) && !defined(CONFIG_DMA_NONCOHERENT)
-#define USE_KMALLOC
-
-#elif	defined(CONFIG_PPC) && !defined(CONFIG_NOT_COHERENT_CACHE)
-#define USE_KMALLOC
-
-#endif
-
 /* allocating buffers this way eliminates dma mapping overhead, which
  * on some platforms will mean eliminating a per-io buffer copy.  with
  * some kinds of system caches, further tweaks may still be needed.
@@ -334,11 +313,6 @@ goku_alloc_buffer(struct usb_ep *_ep, un
 		return NULL;
 	*dma = DMA_ADDR_INVALID;
 
-#if	defined(USE_KMALLOC)
-	retval = kmalloc(bytes, gfp_flags);
-	if (retval)
-		*dma = virt_to_phys(retval);
-#else
 	if (ep->dma) {
 		/* the main problem with this call is that it wastes memory
 		 * on typical 1/N page allocations: it allocates 1-N pages.
@@ -348,7 +322,6 @@ goku_alloc_buffer(struct usb_ep *_ep, un
 				bytes, dma, gfp_flags);
 	} else
 		retval = kmalloc(bytes, gfp_flags);
-#endif
 	return retval;
 }
 
@@ -356,7 +329,6 @@ static void
 goku_free_buffer(struct usb_ep *_ep, void *buf, dma_addr_t dma, unsigned bytes)
 {
 	/* free memory into the right allocator */
-#ifndef	USE_KMALLOC
 	if (dma != DMA_ADDR_INVALID) {
 		struct goku_ep	*ep;
 
@@ -365,7 +337,6 @@ goku_free_buffer(struct usb_ep *_ep, voi
 			return;
 		dma_free_coherent(&ep->dev->pdev->dev, bytes, buf, dma);
 	} else
-#endif
 		kfree (buf);
 }
 
_

Patches currently in -mm which might be from ralf@linux-mips.org are

linux-sysdevh-needs-to-include-linux-moduleh.patch
serial-driver-pmc-msp71xx.patch
rm9000-serial-driver.patch
rm9000-serial-driver-tidy.patch
simplify-the-stacktrace-code.patch
fixes-and-cleanups-for-earlyprintk-aka-boot-console.patch
mips-convert-to-use-shared-apm-emulation-fix.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-mips.patch
local_t-mips-extension.patch
local_t-mips-extension-fix.patch
local_t-mips-extension-shrink-duplicated-mips-32-64-bits-functions-from-localh.patch
local_t-mips-extension-shrink-duplicated-mips-32-64-bits-functions-from-localh-fix.patch
