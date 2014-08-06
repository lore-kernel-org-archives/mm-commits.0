From: akpm@linux-foundation.org
Subject: [folded-merged]
 dma-cma-support-arbitrary-bitmap-granularity-fix.patch removed from -mm
 tree
Date: Wed, 06 Aug 2014 15:44:57 -0700
Message-ID: <53e2afe9.3mQAp9ObOZgIW7Bs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pd0-f201.google.com ([209.85.192.201]:59869 "EHLO
	mail-pd0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754429AbaHFWo6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Aug 2014 18:44:58 -0400
Received: by mail-pd0-f201.google.com with SMTP id g10so839645pdj.2
        for <mm-commits@vger.kernel.org>; Wed, 06 Aug 2014 15:44:58 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, agraf@suse.de, aneesh.kumar@linux.vnet.ibm.com, benh@kernel.crashing.org, gleb@kernel.org, iamjoonsoo.kim@lge.com, m.szyprowski@samsung.com, mina86@mina86.com, minchan@kernel.org, paulus@samba.org, pbonzini@redhat.com, zhangyanfei@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: dma-cma-support-arbitrary-bitmap-granularity-fix
has been removed from the -mm tree.  Its filename was
     dma-cma-support-arbitrary-bitmap-granularity-fix.patch

This patch was dropped because it was folded into dma-cma-support-arbitrary-bitmap-granularity.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: dma-cma-support-arbitrary-bitmap-granularity-fix

s/1/1UL/

Cc: Alexander Graf <agraf@suse.de>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Gleb Natapov <gleb@kernel.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/dma-contiguous.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/base/dma-contiguous.c~dma-cma-support-arbitrary-bitmap-granularity-fix drivers/base/dma-contiguous.c
--- a/drivers/base/dma-contiguous.c~dma-cma-support-arbitrary-bitmap-granularity-fix
+++ a/drivers/base/dma-contiguous.c
@@ -160,7 +160,7 @@ static DEFINE_MUTEX(cma_mutex);
 
 static unsigned long cma_bitmap_aligned_mask(struct cma *cma, int align_order)
 {
-	return (1 << (align_order >> cma->order_per_bit)) - 1;
+	return (1UL << (align_order >> cma->order_per_bit)) - 1;
 }
 
 static unsigned long cma_bitmap_maxno(struct cma *cma)
@@ -171,7 +171,7 @@ static unsigned long cma_bitmap_maxno(st
 static unsigned long cma_bitmap_pages_to_bits(struct cma *cma,
 						unsigned long pages)
 {
-	return ALIGN(pages, 1 << cma->order_per_bit) >> cma->order_per_bit;
+	return ALIGN(pages, 1UL << cma->order_per_bit) >> cma->order_per_bit;
 }
 
 static void cma_clear_bitmap(struct cma *cma, unsigned long pfn, int count)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
fsnotify-rename-event-handling-functions.patch
kbuild-explain-stack-protector-strong-config-logic.patch
slub-use-new-node-functions.patch
slab-use-get_node-and-kmem_cache_node-functions.patch
slab-change-int-to-size_t-for-representing-allocation-size.patch
mm-page_allocc-unexport-alloc_pages_exact_nid.patch
dma-cma-support-arbitrary-bitmap-granularity.patch
mm-vmallocc-add-a-schedule-point-to-vmalloc-fix.patch
include-linux-mmdebugh-add-vm_warn_once.patch
mm-catch-memory-commitment-underflow-fix.patch
mm-hugetlb-generalize-writes-to-nr_hugepages-fix.patch
mm-oom-ensure-memoryless-node-zonelist-always-includes-zones-fix.patch
list-fix-order-of-arguments-for-hlist_add_after_rcu-checkpatch-fixes.patch
add-lib-globc-fix.patch
lib-list_sortc-convert-to-pr_foo.patch
lib-list_sortc-convert-to-pr_foo-fix.patch
checkpatch-add-test-for-commit-id-formatting-style-in-commit-log.patch

