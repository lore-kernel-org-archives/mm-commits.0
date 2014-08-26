From: akpm@linux-foundation.org
Subject: +
 common-dma-mapping-introduce-common-remapping-functions-fix.patch added to
 -mm tree
Date: Tue, 26 Aug 2014 13:25:53 -0700
Message-ID: <53fced51.aNQ7IZ1QgtpOVCBb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ie0-f202.google.com ([209.85.223.202]:45725 "EHLO
	mail-ie0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753060AbaHZUZy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Aug 2014 16:25:54 -0400
Received: by mail-ie0-f202.google.com with SMTP id rl12so1751743iec.5
        for <mm-commits@vger.kernel.org>; Tue, 26 Aug 2014 13:25:54 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lauraa@codeaurora.org, fengguang.wu@intel.com, james.hogan@imgtec.com, mm-commits@vger.kernel.org


The patch titled
     Subject: common: dma-mapping: Swap function order
has been added to the -mm tree.  Its filename is
     common-dma-mapping-introduce-common-remapping-functions-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/common-dma-mapping-introduce-common-remapping-functions-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/common-dma-mapping-introduce-common-remapping-functions-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
