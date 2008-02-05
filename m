From: akpm@linux-foundation.org
Subject: - agp-alpha-nopage.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:33:56 -0800
Message-ID: <200802052233.m15MXb8F012439@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49973 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762691AbYBEWme (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:42:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, ink@jurassic.park.msu.ru, rth@twiddle.net, mm-commits@vger.kernel.org


The patch titled
     agp: alpha nopage
has been removed from the -mm tree.  Its filename was
     agp-alpha-nopage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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

origin.patch
mm-special-mapping-nopage.patch
drm-convert-from-nopage-to-fault.patch
git-kvm.patch
nfs-use-gfp_nofs-preloads-for-radix-tree-insertion.patch
sg-nopage.patch
vt-bitlock-fix.patch
inotify-fix-race.patch
inotify-remove-debug-code.patch
relay-nopage.patch
uio-nopage.patch
ext2-xip-check-fix.patch
fb-defio-nopage.patch
rewrite-rd.patch
rewrite-rd-fix.patch
rewrite-rd-fix-2.patch
rd-support-xip.patch
mm-remove-nopage.patch
buffer_head-fix-private_list-handling.patch
reiser4.patch
reiser4-correct-references-to-filemap_nopage.patch
