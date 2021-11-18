Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3141BC433F5
	for <mm-commits@archiver.kernel.org>; Thu, 18 Nov 2021 22:20:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 07ACA61AA7
	for <mm-commits@archiver.kernel.org>; Thu, 18 Nov 2021 22:20:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229634AbhKRWXk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 18 Nov 2021 17:23:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:52794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229600AbhKRWXj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 18 Nov 2021 17:23:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CC40061A64;
        Thu, 18 Nov 2021 22:20:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637274039;
        bh=ByQ/pSoEDMiGlBIrHmsxgOW1R4gODVBnaSV/d0q+k08=;
        h=Date:From:To:Subject:From;
        b=w+Idd0/+nTM+PdFeKXYOH4NfCPhKqL3pVAqRcAEHPcYduUQJWbCPSk6SuplgLJmy1
         RRtLz3swCpJn5pLmH7mGlDcCaL+/uhn4uHGd3QHExdRcCtkAMTwbFRW0NFLNsBus2k
         Z3L1z0JoQhZRQOxQIPPLU1TPgNMofwB+qE/AAK9c=
Date:   Thu, 18 Nov 2021 14:20:38 -0800
From:   akpm@linux-foundation.org
To:     mgorman@techsingularity.net, mhocko@suse.com,
        mm-commits@vger.kernel.org, neilb@suse.de,
        thierry.reding@gmail.com, willy@infradead.org
Subject:  + mm-discard-__gfp_atomic.patch added to -mm tree
Message-ID: <20211118222038.DYEW7Dwbb%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: discard __GFP_ATOMIC
has been added to the -mm tree.  Its filename is
     mm-discard-__gfp_atomic.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-discard-__gfp_atomic.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-discard-__gfp_atomic.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "NeilBrown" <neilb@suse.de>
Subject: mm: discard __GFP_ATOMIC

__GFP_ATOMIC serves little purpose.  Its main effect is to set
ALLOC_HARDER which adds a few little boosts to increase the chance of an
allocation succeeding, one of which is to lower the water-mark at which it
will succeed.

It is *always* paired with __GFP_HIGH which sets ALLOC_HIGH which also
adjusts this watermark.  It is probable that other users of __GFP_HIGH
should benefit from the other little bonuses that __GFP_ATOMIC gets.

__GFP_ATOMIC also gives a warning if used with __GFP_DIRECT_RECLAIM. 
There is little point to this.  We already get a might_sleep() warning if
__GFP_DIRECT_RECLAIM is set.

__GFP_ATOMIC allows the "watermark_boost" to be side-stepped.  It is
probable that testing ALLOC_HARDER is a better fit here.

__GFP_ATOMIC is used by tegra-smmu.c to check if the allocation might
sleep.  This should test __GFP_DIRECT_RECLAIM instead.

This patch:
 - removes __GFP_ATOMIC
 - causes __GFP_HIGH to set ALLOC_HARDER unless __GFP_NOMEMALLOC is set
   (as well as ALLOC_HIGH).
 - makes other adjustments as suggested by the above.

The net result is not change to GFP_ATOMIC allocations.  Other
allocations that use __GFP_HIGH will benefit from a few different extra
privileges.  This affects:
  xen, dm, md, ntfs3
  the vermillion frame buffer
  hibernation
  ksm
  swap
all of which likely produce more benefit than cost if these selected
allocation are more likely to succeed quickly.

Link: https://lkml.kernel.org/r/163712397076.13692.4727608274002939094@noble.neil.brown.name
Signed-off-by: NeilBrown <neilb@suse.de>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Thierry Reding <thierry.reding@gmail.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/balance.rst         |    2 +-
 drivers/iommu/tegra-smmu.c           |    4 ++--
 include/linux/gfp.h                  |   12 ++++--------
 include/trace/events/mmflags.h       |    1 -
 lib/test_printf.c                    |    8 ++++----
 mm/internal.h                        |    3 +--
 mm/memcontrol.c                      |    2 +-
 mm/page_alloc.c                      |   16 ++++------------
 tools/perf/builtin-kmem.c            |    1 -
 tools/testing/radix-tree/linux/gfp.h |    3 +--
 10 files changed, 18 insertions(+), 34 deletions(-)

--- a/Documentation/vm/balance.rst~mm-discard-__gfp_atomic
+++ a/Documentation/vm/balance.rst
@@ -6,7 +6,7 @@ Memory Balancing
 
 Started Jan 2000 by Kanoj Sarcar <kanoj@sgi.com>
 
-Memory balancing is needed for !__GFP_ATOMIC and !__GFP_KSWAPD_RECLAIM as
+Memory balancing is needed for !__GFP_HIGH and !__GFP_KSWAPD_RECLAIM as
 well as for non __GFP_IO allocations.
 
 The first reason why a caller may avoid reclaim is that the caller can not
--- a/drivers/iommu/tegra-smmu.c~mm-discard-__gfp_atomic
+++ a/drivers/iommu/tegra-smmu.c
@@ -676,12 +676,12 @@ static struct page *as_get_pde_page(stru
 	 * allocate page in a sleeping context if GFP flags permit. Hence
 	 * spinlock needs to be unlocked and re-locked after allocation.
 	 */
-	if (!(gfp & __GFP_ATOMIC))
+	if (gfp & __GFP_DIRECT_RECLAIM)
 		spin_unlock_irqrestore(&as->lock, *flags);
 
 	page = alloc_page(gfp | __GFP_DMA | __GFP_ZERO);
 
-	if (!(gfp & __GFP_ATOMIC))
+	if (gfp & __GFP_DIRECT_RECLAIM)
 		spin_lock_irqsave(&as->lock, *flags);
 
 	/*
--- a/include/linux/gfp.h~mm-discard-__gfp_atomic
+++ a/include/linux/gfp.h
@@ -39,7 +39,7 @@ struct vm_area_struct;
 #define ___GFP_IO		0x40u
 #define ___GFP_FS		0x80u
 #define ___GFP_ZERO		0x100u
-#define ___GFP_ATOMIC		0x200u
+/* 0x200u unused */
 #define ___GFP_DIRECT_RECLAIM	0x400u
 #define ___GFP_KSWAPD_RECLAIM	0x800u
 #define ___GFP_WRITE		0x1000u
@@ -116,11 +116,8 @@ struct vm_area_struct;
  *
  * %__GFP_HIGH indicates that the caller is high-priority and that granting
  * the request is necessary before the system can make forward progress.
- * For example, creating an IO context to clean pages.
- *
- * %__GFP_ATOMIC indicates that the caller cannot reclaim or sleep and is
- * high priority. Users are typically interrupt handlers. This may be
- * used in conjunction with %__GFP_HIGH
+ * For example creating an IO context to clean pages and requests
+ * from atomic context.
  *
  * %__GFP_MEMALLOC allows access to all memory. This should only be used when
  * the caller guarantees the allocation will allow more memory to be freed
@@ -135,7 +132,6 @@ struct vm_area_struct;
  * %__GFP_NOMEMALLOC is used to explicitly forbid access to emergency reserves.
  * This takes precedence over the %__GFP_MEMALLOC flag if both are set.
  */
-#define __GFP_ATOMIC	((__force gfp_t)___GFP_ATOMIC)
 #define __GFP_HIGH	((__force gfp_t)___GFP_HIGH)
 #define __GFP_MEMALLOC	((__force gfp_t)___GFP_MEMALLOC)
 #define __GFP_NOMEMALLOC ((__force gfp_t)___GFP_NOMEMALLOC)
@@ -320,7 +316,7 @@ struct vm_area_struct;
  * version does not attempt reclaim/compaction at all and is by default used
  * in page fault path, while the non-light is used by khugepaged.
  */
-#define GFP_ATOMIC	(__GFP_HIGH|__GFP_ATOMIC|__GFP_KSWAPD_RECLAIM)
+#define GFP_ATOMIC	(__GFP_HIGH|__GFP_KSWAPD_RECLAIM)
 #define GFP_KERNEL	(__GFP_RECLAIM | __GFP_IO | __GFP_FS)
 #define GFP_KERNEL_ACCOUNT (GFP_KERNEL | __GFP_ACCOUNT)
 #define GFP_NOWAIT	(__GFP_KSWAPD_RECLAIM)
--- a/include/trace/events/mmflags.h~mm-discard-__gfp_atomic
+++ a/include/trace/events/mmflags.h
@@ -29,7 +29,6 @@
 	{(unsigned long)__GFP_HIGHMEM,		"__GFP_HIGHMEM"},	\
 	{(unsigned long)GFP_DMA32,		"GFP_DMA32"},		\
 	{(unsigned long)__GFP_HIGH,		"__GFP_HIGH"},		\
-	{(unsigned long)__GFP_ATOMIC,		"__GFP_ATOMIC"},	\
 	{(unsigned long)__GFP_IO,		"__GFP_IO"},		\
 	{(unsigned long)__GFP_FS,		"__GFP_FS"},		\
 	{(unsigned long)__GFP_NOWARN,		"__GFP_NOWARN"},	\
--- a/lib/test_printf.c~mm-discard-__gfp_atomic
+++ a/lib/test_printf.c
@@ -673,17 +673,17 @@ flags(void)
 	gfp = GFP_ATOMIC|__GFP_DMA;
 	test("GFP_ATOMIC|GFP_DMA", "%pGg", &gfp);
 
-	gfp = __GFP_ATOMIC;
-	test("__GFP_ATOMIC", "%pGg", &gfp);
+	gfp = __GFP_HIGH;
+	test("__GFP_HIGH", "%pGg", &gfp);
 
 	/* Any flags not translated by the table should remain numeric */
 	gfp = ~__GFP_BITS_MASK;
 	snprintf(cmp_buffer, BUF_SIZE, "%#lx", (unsigned long) gfp);
 	test(cmp_buffer, "%pGg", &gfp);
 
-	snprintf(cmp_buffer, BUF_SIZE, "__GFP_ATOMIC|%#lx",
+	snprintf(cmp_buffer, BUF_SIZE, "__GFP_HIGH|%#lx",
 							(unsigned long) gfp);
-	gfp |= __GFP_ATOMIC;
+	gfp |= __GFP_HIGH;
 	test(cmp_buffer, "%pGg", &gfp);
 
 	kfree(cmp_buffer);
--- a/mm/internal.h~mm-discard-__gfp_atomic
+++ a/mm/internal.h
@@ -20,8 +20,7 @@
  */
 #define GFP_RECLAIM_MASK (__GFP_RECLAIM|__GFP_HIGH|__GFP_IO|__GFP_FS|\
 			__GFP_NOWARN|__GFP_RETRY_MAYFAIL|__GFP_NOFAIL|\
-			__GFP_NORETRY|__GFP_MEMALLOC|__GFP_NOMEMALLOC|\
-			__GFP_ATOMIC)
+			__GFP_NORETRY|__GFP_MEMALLOC|__GFP_NOMEMALLOC)
 
 /* The GFP flags allowed during early boot */
 #define GFP_BOOT_MASK (__GFP_BITS_MASK & ~(__GFP_RECLAIM|__GFP_IO|__GFP_FS))
--- a/mm/memcontrol.c~mm-discard-__gfp_atomic
+++ a/mm/memcontrol.c
@@ -2627,7 +2627,7 @@ retry:
 	 * put the burden of reclaim on regular allocation requests
 	 * and let these go through as privileged allocations.
 	 */
-	if (gfp_mask & __GFP_ATOMIC)
+	if (gfp_mask & __GFP_HIGH)
 		goto force;
 
 	/*
--- a/mm/page_alloc.c~mm-discard-__gfp_atomic
+++ a/mm/page_alloc.c
@@ -3932,12 +3932,12 @@ static inline bool zone_watermark_fast(s
 					free_pages))
 		return true;
 	/*
-	 * Ignore watermark boosting for GFP_ATOMIC order-0 allocations
+	 * Ignore watermark boosting for GFP_HIGH order-0 allocations
 	 * when checking the min watermark. The min watermark is the
 	 * point where boosting is ignored so that kswapd is woken up
 	 * when below the low watermark.
 	 */
-	if (unlikely(!order && (gfp_mask & __GFP_ATOMIC) && z->watermark_boost
+	if (unlikely(!order && (alloc_flags & ALLOC_HARDER) && z->watermark_boost
 		&& ((alloc_flags & ALLOC_WMARK_MASK) == WMARK_MIN))) {
 		mark = z->_watermark[WMARK_MIN];
 		return __zone_watermark_ok(z, order, mark, highest_zoneidx,
@@ -4661,12 +4661,12 @@ gfp_to_alloc_flags(gfp_t gfp_mask)
 	 * The caller may dip into page reserves a bit more if the caller
 	 * cannot run direct reclaim, or if the caller has realtime scheduling
 	 * policy or is asking for __GFP_HIGH memory.  GFP_ATOMIC requests will
-	 * set both ALLOC_HARDER (__GFP_ATOMIC) and ALLOC_HIGH (__GFP_HIGH).
+	 * set both ALLOC_HARDER (unless __GFP_NOMEMALLOC) and ALLOC_HIGH.
 	 */
 	alloc_flags |= (__force int)
 		(gfp_mask & (__GFP_HIGH | __GFP_KSWAPD_RECLAIM));
 
-	if (gfp_mask & __GFP_ATOMIC) {
+	if (gfp_mask & __GFP_HIGH) {
 		/*
 		 * Not worth trying to allocate harder for __GFP_NOMEMALLOC even
 		 * if it can't schedule.
@@ -4859,14 +4859,6 @@ __alloc_pages_slowpath(gfp_t gfp_mask, u
 	unsigned int cpuset_mems_cookie;
 	int reserve_flags;
 
-	/*
-	 * We also sanity check to catch abuse of atomic reserves being used by
-	 * callers that are not in atomic context.
-	 */
-	if (WARN_ON_ONCE((gfp_mask & (__GFP_ATOMIC|__GFP_DIRECT_RECLAIM)) ==
-				(__GFP_ATOMIC|__GFP_DIRECT_RECLAIM)))
-		gfp_mask &= ~__GFP_ATOMIC;
-
 retry_cpuset:
 	compaction_retries = 0;
 	no_progress_loops = 0;
--- a/tools/perf/builtin-kmem.c~mm-discard-__gfp_atomic
+++ a/tools/perf/builtin-kmem.c
@@ -640,7 +640,6 @@ static const struct {
 	{ "__GFP_HIGHMEM",		"HM" },
 	{ "GFP_DMA32",			"D32" },
 	{ "__GFP_HIGH",			"H" },
-	{ "__GFP_ATOMIC",		"_A" },
 	{ "__GFP_IO",			"I" },
 	{ "__GFP_FS",			"F" },
 	{ "__GFP_NOWARN",		"NWR" },
--- a/tools/testing/radix-tree/linux/gfp.h~mm-discard-__gfp_atomic
+++ a/tools/testing/radix-tree/linux/gfp.h
@@ -12,7 +12,6 @@
 #define __GFP_FS		0x80u
 #define __GFP_NOWARN		0x200u
 #define __GFP_ZERO		0x8000u
-#define __GFP_ATOMIC		0x80000u
 #define __GFP_ACCOUNT		0x100000u
 #define __GFP_DIRECT_RECLAIM	0x400000u
 #define __GFP_KSWAPD_RECLAIM	0x2000000u
@@ -20,7 +19,7 @@
 #define __GFP_RECLAIM	(__GFP_DIRECT_RECLAIM|__GFP_KSWAPD_RECLAIM)
 
 #define GFP_ZONEMASK	0x0fu
-#define GFP_ATOMIC	(__GFP_HIGH|__GFP_ATOMIC|__GFP_KSWAPD_RECLAIM)
+#define GFP_ATOMIC	(__GFP_HIGH|__GFP_KSWAPD_RECLAIM)
 #define GFP_KERNEL	(__GFP_RECLAIM | __GFP_IO | __GFP_FS)
 #define GFP_NOWAIT	(__GFP_KSWAPD_RECLAIM)
 
_

Patches currently in -mm which might be from neilb@suse.de are

mm-discard-__gfp_atomic.patch

