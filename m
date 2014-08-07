From: akpm@linux-foundation.org
Subject: [merged] mm-cma-clean-up-cma-allocation-error-path.patch removed
 from -mm tree
Date: Thu, 07 Aug 2014 13:04:07 -0700
Message-ID: <53e3dbb7.FSJbbgYfWuicvplp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pa0-f73.google.com ([209.85.220.73]:39736 "EHLO
	mail-pa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755333AbaHGUEI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:04:08 -0400
Received: by mail-pa0-f73.google.com with SMTP id kx10so1175692pab.2
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:04:07 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, agraf@suse.de, aneesh.kumar@linux.vnet.ibm.com, benh@kernel.crashing.org, gleb@kernel.org, m.szyprowski@samsung.com, mina86@mina86.com, minchan@kernel.org, paulus@samba.org, pbonzini@redhat.com, zhangyanfei@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, CMA: clean-up CMA allocation error path
has been removed from the -mm tree.  Its filename was
     mm-cma-clean-up-cma-allocation-error-path.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm, CMA: clean-up CMA allocation error path

We can remove one call sites for clear_cma_bitmap() if we first
call it before checking error number.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Reviewed-by: Michal Nazarewicz <mina86@mina86.com>
Reviewed-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Alexander Graf <agraf@suse.de>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Gleb Natapov <gleb@kernel.org>
Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN mm/cma.c~mm-cma-clean-up-cma-allocation-error-path mm/cma.c
--- a/mm/cma.c~mm-cma-clean-up-cma-allocation-error-path
+++ a/mm/cma.c
@@ -285,11 +285,12 @@ struct page *cma_alloc(struct cma *cma,
 		if (ret == 0) {
 			page = pfn_to_page(pfn);
 			break;
-		} else if (ret != -EBUSY) {
-			cma_clear_bitmap(cma, pfn, count);
-			break;
 		}
+
 		cma_clear_bitmap(cma, pfn, count);
+		if (ret != -EBUSY)
+			break;
+
 		pr_debug("%s(): memory range at %p is busy, retrying\n",
 			 __func__, pfn_to_page(pfn));
 		/* try again with a bit different memory target */
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

origin.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
page-owners-correct-page-order-when-to-free-page.patch

