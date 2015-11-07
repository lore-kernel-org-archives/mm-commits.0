From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-page_alloc-hide-some-gfp-internals-and-document-the-bit-and-flag-combinations-fix.patch removed from -mm tree
Date: Fri, 06 Nov 2015 16:10:52 -0800
Message-ID: <563d418c.sepxMNF5zW96dNWK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52652 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755665AbbKGAKx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 19:10:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@techsingularity.net, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-page_alloc-hide-some-gfp-internals-and-document-the-bit-and-flag-combinations-fix
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-hide-some-gfp-internals-and-document-the-bit-and-flag-combinations-fix.patch

This patch was dropped because it was folded into mm-page_alloc-hide-some-GFP-internals-and-document-the-bit-and-flag-combinations.patch

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm-page_alloc-hide-some-gfp-internals-and-document-the-bit-and-flag-combinations-fix

This patch address minor comment nitpicks from Vlastimil. It is a fix for the
mmotm patch
mm-page_alloc-hide-some-GFP-internals-and-document-the-bit-and-flag-combinations.patch

Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |   23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff -puN include/linux/gfp.h~mm-page_alloc-hide-some-gfp-internals-and-document-the-bit-and-flag-combinations-fix include/linux/gfp.h
--- a/include/linux/gfp.h~mm-page_alloc-hide-some-gfp-internals-and-document-the-bit-and-flag-combinations-fix
+++ a/include/linux/gfp.h
@@ -111,17 +111,18 @@ struct vm_area_struct;
  *
  * __GFP_IO can start physical IO.
  *
- * __GFP_FS can call down to the low-level FS. Avoids the allocator
- *   recursing into the filesystem which might already be holding locks.
+ * __GFP_FS can call down to the low-level FS. Clearing the flag avoids the
+ *   allocator recursing into the filesystem which might already be holding
+ *   locks.
  *
  * __GFP_DIRECT_RECLAIM indicates that the caller may enter direct reclaim.
  *   This flag can be cleared to avoid unnecessary delays when a fallback
  *   option is available.
  *
- * __GFP_KSWAPD_RECLAIM indicates that the caller wants kswapd when the low
- *   watermark is reached and have it reclaim pages until the high watermark
- *   is reached. A caller may wish to clear this flag when fallback options
- *   are available and the reclaim is likely to disrupt the system. The
+ * __GFP_KSWAPD_RECLAIM indicates that the caller wants to wake kswapd when
+ *   the low watermark is reached and have it reclaim pages until the high
+ *   watermark is reached. A caller may wish to clear this flag when fallback
+ *   options are available and the reclaim is likely to disrupt the system. The
  *   canonical example is THP allocation where a fallback is cheap but
  *   reclaim/compaction may cause indirect stalls.
  *
@@ -209,11 +210,6 @@ struct vm_area_struct;
  *   for buffers that are mapped to userspace (e.g. graphics) that hardware
  *   still must DMA to. cpuset limits are enforced for these allocations.
  *
- * GFP_HIGHUSER is for userspace allocations that may be mapped to userspace,
- *   do not need to be directly accessible by the kernel but that cannot
- *   move once in use. An example may be a hardware allocation that maps
- *   data directly into userspace but has no addressing limitations.
- *
  * GFP_DMA exists for historical reasons and should be avoided where possible.
  *   The flags indicates that the caller requires that the lowest zone be
  *   used (ZONE_DMA or 16M on x86-64). Ideally, this would be removed but
@@ -224,6 +220,11 @@ struct vm_area_struct;
  * GFP_DMA32 is similar to GFP_DMA except that the caller requires a 32-bit
  *   address.
  *
+ * GFP_HIGHUSER is for userspace allocations that may be mapped to userspace,
+ *   do not need to be directly accessible by the kernel but that cannot
+ *   move once in use. An example may be a hardware allocation that maps
+ *   data directly into userspace but has no addressing limitations.
+ *
  * GFP_HIGHUSER_MOVABLE is for userspace allocations that the kernel does not
  *   need direct access to but can use kmap() when access is required. They
  *   are expected to be movable via page reclaim or page migration. Typically,
_

Patches currently in -mm which might be from mgorman@techsingularity.net are

mm-page_alloc-remove-unnecessary-parameter-from-zone_watermark_ok_safe.patch
mm-page_alloc-remove-unnecessary-recalculations-for-dirty-zone-balancing.patch
mm-page_alloc-remove-unnecessary-taking-of-a-seqlock-when-cpusets-are-disabled.patch
mm-page_alloc-use-masks-and-shifts-when-converting-gfp-flags-to-migrate-types.patch
mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd.patch
mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd-fix.patch
mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim.patch
mm-page_alloc-delete-the-zonelist_cache.patch
mm-page_alloc-remove-migrate_reserve.patch
mm-page_alloc-reserve-pageblocks-for-high-order-atomic-allocations-on-demand.patch
mm-page_alloc-only-enforce-watermarks-for-order-0-allocations.patch
mm-page_alloc-hide-some-GFP-internals-and-document-the-bit-and-flag-combinations.patch

