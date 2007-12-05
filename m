From: akpm@linux-foundation.org
Subject: + agp-alpha-nopage.patch added to -mm tree
Date: Wed, 05 Dec 2007 14:44:56 -0800
Message-ID: <200712052244.lB5MiuE3028886@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50579 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752608AbXLEWpP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Dec 2007 17:45:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de, ink@jurassic.park.msu.ru, rth@twiddle.net


The patch titled
     agp: alpha nopage
has been added to the -mm tree.  Its filename is
     agp-alpha-nopage.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: agp: alpha nopage
From: Nick Piggin <npiggin@suse.de>

Convert AGP alpha driver from nopage to fault.
NULL is NOPAGE_SIGBUS, so we aren't changing behaviour there.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/agp/alpha-agp.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff -puN drivers/char/agp/alpha-agp.c~agp-alpha-nopage drivers/char/agp/alpha-agp.c
--- a/drivers/char/agp/alpha-agp.c~agp-alpha-nopage
+++ a/drivers/char/agp/alpha-agp.c
@@ -11,29 +11,28 @@
 
 #include "agp.h"
 
-static struct page *alpha_core_agp_vm_nopage(struct vm_area_struct *vma,
-					     unsigned long address,
-					     int *type)
+static int alpha_core_agp_vm_fault(struct vm_area_struct *vma,
+					struct vm_fault *vmf)
 {
 	alpha_agp_info *agp = agp_bridge->dev_private_data;
 	dma_addr_t dma_addr;
 	unsigned long pa;
 	struct page *page;
 
-	dma_addr = address - vma->vm_start + agp->aperture.bus_base;
+	dma_addr = (unsigned long)vmf->virtual_address - vma->vm_start
+						+ agp->aperture.bus_base;
 	pa = agp->ops->translate(agp, dma_addr);
 
 	if (pa == (unsigned long)-EINVAL)
-		return NULL;	/* no translation */
+		return VM_FAULT_SIGBUS;	/* no translation */
 
 	/*
 	 * Get the page, inc the use count, and return it
 	 */
 	page = virt_to_page(__va(pa));
 	get_page(page);
-	if (type)
-		*type = VM_FAULT_MINOR;
-	return page;
+	vmf->page = page;
+	return 0;
 }
 
 static struct aper_size_info_fixed alpha_core_agp_sizes[] =
@@ -42,7 +41,7 @@ static struct aper_size_info_fixed alpha
 };
 
 struct vm_operations_struct alpha_core_agp_vm_ops = {
-	.nopage = alpha_core_agp_vm_nopage,
+	.fault = alpha_core_agp_vm_fault,
 };
 
 
_

Patches currently in -mm which might be from npiggin@suse.de are

mm-fix-xip-file-writes.patch
git-jfs.patch
nfs-use-gfp_nofs-preloads-for-radix-tree-insertion.patch
slub-use-non-atomic-bit-unlock.patch
radix-tree-avoid-atomic-allocations-for-preloaded-insertions.patch
mm-dont-allow-ioremapping-of-ranges-larger-than-vmalloc-space.patch
vt-bitlock-fix.patch
radix_treeh-trivial-comment-correction.patch
inotify-fix-race.patch
inotify-remove-debug-code.patch
rewrite-rd.patch
rewrite-rd-fix.patch
rd-support-xip.patch
reiser4.patch
ia64-ia32-nopage.patch
relay-nopage.patch
uio-nopage.patch
ieee1394-nopage.patch
v4l-nopage.patch
fb-defio-nopage.patch
agp-alpha-nopage.patch
sg-nopage.patch
ib-nopage.patch
usb-mon-nopage.patch
alsa-nopage.patch
alsa-usx2y-nopage.patch
mm-special-mapping-nopage.patch
