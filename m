From: akpm@linux-foundation.org
Subject: [folded-merged]
 common-dma-mapping-introduce-common-remapping-functions-fix.patch removed
 from -mm tree
Date: Thu, 09 Oct 2014 13:35:00 -0700
Message-ID: <5436f174.UPxmHthlGwUQdf7t%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35462 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030AbaJIUfA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Oct 2014 16:35:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lauraa@codeaurora.org, fengguang.wu@intel.com, james.hogan@imgtec.com, mm-commits@vger.kernel.org


The patch titled
     Subject: common: dma-mapping: Swap function order
has been removed from the -mm tree.  Its filename was
     common-dma-mapping-introduce-common-remapping-functions-fix.patch

This patch was dropped because it was folded into common-dma-mapping-introduce-common-remapping-functions.patch

------------------------------------------------------
From: Laura Abbott <lauraa@codeaurora.org>
Subject: common: dma-mapping: Swap function order

Fix the order of dma_common_contiguous_remap and
dma_common_pages_remap to avoid function declaration errors:

drivers/base/dma-mapping.c: In function 'dma_common_contiguous_remap':
drivers/base/dma-mapping.c:294: error: implicit declaration of
function 'dma_common_pages_remap'
drivers/base/dma-mapping.c:294: warning: assignment makes pointer from
integer without a cast
drivers/base/dma-mapping.c: At top level:
drivers/base/dma-mapping.c:308: error: conflicting types for
'dma_common_pages_remap'
drivers/base/dma-mapping.c:294: error: previous implicit declaration
of 'dma_common_pages_remap' was here

Reported-by: James Hogan <james.hogan@imgtec.com>
Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Laura Abbott <lauraa@codeaurora.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/dma-mapping.c |   44 +++++++++++++++++------------------
 1 file changed, 22 insertions(+), 22 deletions(-)

diff -puN drivers/base/dma-mapping.c~common-dma-mapping-introduce-common-remapping-functions-fix drivers/base/dma-mapping.c
--- a/drivers/base/dma-mapping.c~common-dma-mapping-introduce-common-remapping-functions-fix
+++ a/drivers/base/dma-mapping.c
@@ -271,6 +271,28 @@ int dma_common_mmap(struct device *dev,
 EXPORT_SYMBOL(dma_common_mmap);
 
 /*
+ * remaps an array of PAGE_SIZE pages into another vm_area
+ * Cannot be used in non-sleeping contexts
+ */
+void *dma_common_pages_remap(struct page **pages, size_t size,
+			unsigned long vm_flags, pgprot_t prot,
+			const void *caller)
+{
+	struct vm_struct *area;
+
+	area = get_vm_area_caller(size, vm_flags, caller);
+	if (!area)
+		return NULL;
+
+	if (map_vm_area(area, prot, pages)) {
+		vunmap(area->addr);
+		return NULL;
+	}
+
+	return area->addr;
+}
+
+/*
  * remaps an allocated contiguous region into another vm_area.
  * Cannot be used in non-sleeping contexts
  */
@@ -299,28 +321,6 @@ void *dma_common_contiguous_remap(struct
 }
 
 /*
- * remaps an array of PAGE_SIZE pages into another vm_area
- * Cannot be used in non-sleeping contexts
- */
-void *dma_common_pages_remap(struct page **pages, size_t size,
-			unsigned long vm_flags, pgprot_t prot,
-			const void *caller)
-{
-	struct vm_struct *area;
-
-	area = get_vm_area_caller(size, vm_flags, caller);
-	if (!area)
-		return NULL;
-
-	if (map_vm_area(area, prot, pages)) {
-		vunmap(area->addr);
-		return NULL;
-	}
-
-	return area->addr;
-}
