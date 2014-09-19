From: akpm@linux-foundation.org
Subject: +
 common-dma-mapping-introduce-common-remapping-functions-fix-4.patch added
 to -mm tree
Date: Fri, 19 Sep 2014 14:07:43 -0700
Message-ID: <541c9b1f.KEwsLXlSJu+oSiNh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54878 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757740AbaISVHo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 19 Sep 2014 17:07:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lauraa@codeaurora.org, mitchelh@codeaurora.org, mm-commits@vger.kernel.org


The patch titled
     Subject: common: dma-mapping: Store page array in vm_struct
has been added to the -mm tree.  Its filename is
     common-dma-mapping-introduce-common-remapping-functions-fix-4.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/common-dma-mapping-introduce-common-remapping-functions-fix-4.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/common-dma-mapping-introduce-common-remapping-functions-fix-4.patch

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
Subject: common: dma-mapping: Store page array in vm_struct

Commit 54329ac (common: dma-mapping: introduce common remapping functions)
factored out common code for remapping arrays of pages.  The code before
the refactor relied on setting area->pages with the array of mapped pages
for easy access later.  The refactor dropped this, breaking parts of the
ARM DMA API.  Fix this by setting the page array in the same place.

Signed-off-by: Laura Abbott <lauraa@codeaurora.org>
Reported-by: Mitchel Humpherys <mitchelh@codeaurora.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/dma-mapping.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/base/dma-mapping.c~common-dma-mapping-introduce-common-remapping-functions-fix-4 drivers/base/dma-mapping.c
--- a/drivers/base/dma-mapping.c~common-dma-mapping-introduce-common-remapping-functions-fix-4
+++ a/drivers/base/dma-mapping.c
@@ -285,6 +285,8 @@ void *dma_common_pages_remap(struct page
 	if (!area)
 		return NULL;
 
+	area->pages = pages;
+
 	if (map_vm_area(area, prot, pages)) {
 		vunmap(area->addr);
 		return NULL;
_

Patches currently in -mm which might be from lauraa@codeaurora.org are

lib-genallocc-add-power-aligned-algorithm.patch
lib-genallocc-add-genpool-range-check-function.patch
common-dma-mapping-introduce-common-remapping-functions.patch
common-dma-mapping-introduce-common-remapping-functions-fix.patch
common-dma-mapping-introduce-common-remapping-functions-fix-2.patch
common-dma-mapping-introduce-common-remapping-functions-fix-4.patch
arm-use-genalloc-for-the-atomic-pool.patch
arm64-add-atomic-pool-for-non-coherent-and-cma-allocations.patch
linux-next.patch
debugging-keep-track-of-page-owners.patch

