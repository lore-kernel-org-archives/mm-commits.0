From: akpm@linux-foundation.org
Subject: +
 mm-cma-adjust-address-limit-to-avoid-hitting-low-high-memory-boundary.patch added to -mm tree
Date: Tue, 26 Aug 2014 16:10:08 -0700
Message-ID: <53fd13d0.gHFYKvCqLVlXs7vN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qg0-f73.google.com ([209.85.192.73]:44674 "EHLO
	mail-qg0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754005AbaHZXKK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Aug 2014 19:10:10 -0400
Received: by mail-qg0-f73.google.com with SMTP id i50so1380844qgf.0
        for <mm-commits@vger.kernel.org>; Tue, 26 Aug 2014 16:10:09 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: m.szyprowski@samsung.com, drake@endlessm.com, iamjoonsoo.kim@lge.com, mina86@mina86.com, minchan@kernel.org, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: cma: adjust address limit to avoid hitting low/high memory boundary
has been added to the -mm tree.  Its filename is
     mm-cma-adjust-address-limit-to-avoid-hitting-low-high-memory-boundary.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-cma-adjust-address-limit-to-avoid-hitting-low-high-memory-boundary.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-cma-adjust-address-limit-to-avoid-hitting-low-high-memory-boundary.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: mm: cma: adjust address limit to avoid hitting low/high memory boundary

Russell King recently noticed that limiting default CMA region only to low
memory on ARM architecture causes serious memory management issues with
machines having a lot of memory (which is mainly available as high
memory).  More information can be found the following thread:
http://thread.gmane.org/gmane.linux.ports.arm.kernel/348441/

Those two patches removes this limit letting kernel to put default CMA
region into high memory when this is possible (there is enough high memory
available and architecture specific DMA limit fits).

This should solve strange OOM issues on systems with lots of RAM (i.e. 
>1GiB) and large (>256M) CMA area.


This patch (of 2):

Automatically allocated regions should not cross low/high memory boundary,
because such regions cannot be later correctly initialized due to spanning
across two memory zones.  This patch adds a check for this case and a
simple code for moving region to low memory if automatically selected
address might not fit completely into high memory.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Acked-by: Michal Nazarewicz <mina86@mina86.com>
Cc: Daniel Drake <drake@endlessm.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma.c |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff -puN mm/cma.c~mm-cma-adjust-address-limit-to-avoid-hitting-low-high-memory-boundary mm/cma.c
--- a/mm/cma.c~mm-cma-adjust-address-limit-to-avoid-hitting-low-high-memory-boundary
+++ a/mm/cma.c
@@ -32,6 +32,7 @@
 #include <linux/slab.h>
 #include <linux/log2.h>
 #include <linux/cma.h>
+#include <linux/highmem.h>
 
 struct cma {
 	unsigned long	base_pfn;
@@ -163,6 +164,8 @@ int __init cma_declare_contiguous(phys_a
 			bool fixed, struct cma **res_cma)
 {
 	struct cma *cma;
+	phys_addr_t memblock_end = memblock_end_of_DRAM();
+	phys_addr_t highmem_start = __pa(high_memory);
 	int ret = 0;
 
 	pr_debug("%s(size %lx, base %08lx, limit %08lx alignment %08lx)\n",
@@ -196,6 +199,24 @@ int __init cma_declare_contiguous(phys_a
 	if (!IS_ALIGNED(size >> PAGE_SHIFT, 1 << order_per_bit))
 		return -EINVAL;
 
+	/*
+	 * adjust limit to avoid crossing low/high memory boundary for
+	 * automatically allocated regions
+	 */
+	if (((limit == 0 || limit > memblock_end) &&
+	     (memblock_end - size < highmem_start &&
+	      memblock_end > highmem_start)) ||
+	    (!fixed && limit > highmem_start && limit - size < highmem_start)) {
+		limit = highmem_start;
+	}
+
+	if (fixed && base < highmem_start && base+size > highmem_start) {
+		ret = -EINVAL;
+		pr_err("Region at %08lx defined on low/high memory boundary (%08lx)\n",
+			(unsigned long)base, (unsigned long)highmem_start);
+		goto err;
+	}
+
 	/* Reserve memory */
 	if (base && fixed) {
 		if (memblock_is_region_reserved(base, size) ||
_

Patches currently in -mm which might be from m.szyprowski@samsung.com are

mm-cma-adjust-address-limit-to-avoid-hitting-low-high-memory-boundary.patch
arm-mm-dont-limit-default-cma-region-only-to-low-memory.patch
linux-next.patch

