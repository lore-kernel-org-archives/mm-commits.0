Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C776C5479D
	for <mm-commits@archiver.kernel.org>; Mon,  9 Jan 2023 23:46:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237890AbjAIXqH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 9 Jan 2023 18:46:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237880AbjAIXoy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jan 2023 18:44:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1988C3FC84
        for <mm-commits@vger.kernel.org>; Mon,  9 Jan 2023 15:44:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B73D7B810A5
        for <mm-commits@vger.kernel.org>; Mon,  9 Jan 2023 23:44:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54060C433EF;
        Mon,  9 Jan 2023 23:44:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673307889;
        bh=ImrCGTn9F1jop3hiDfV53QH1iELhCo9Zr6UxLjapueA=;
        h=Date:To:From:Subject:From;
        b=gTNuuZHRZzm2jVtwsDnpKS9qTSD92taO/K12H9Bzbxx0+WrFK/A3hdNCvr3waWvx0
         n0kfzCx+2GGfGpordCq+b+eJYU+0a0Db+hyD9ip9164dwd/o7q0MfPZ8ip2vi7sbbO
         QCKcdkKcGLkxFNkME1oTLJePsC0MP62PxyNla+/M=
Date:   Mon, 09 Jan 2023 15:44:48 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        thierry.reding@gmail.com, mhocko@suse.com,
        mgorman@techsingularity.net, neilb@suse.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-discard-__gfp_atomic.patch added to mm-unstable branch
Message-Id: <20230109234449.54060C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: discard __GFP_ATOMIC
has been added to the -mm mm-unstable branch.  Its filename is
     mm-discard-__gfp_atomic.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-discard-__gfp_atomic.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: NeilBrown <neilb@suse.de>
Subject: mm: discard __GFP_ATOMIC
Date: Mon, 9 Jan 2023 15:16:31 +0000

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
 - allows __GFP_HIGH allocations to ignore watermark boosting as well
   as GFP_ATOMIC requests.
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

[mgorman@techsingularity.net: minor adjustments to rework on top of a series]
Link: https://lkml.kernel.org/r/163712397076.13692.4727608274002939094@noble.neil.brown.name
Link: https://lkml.kernel.org/r/20230109151631.24923-8-mgorman@techsingularity.net
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Thierry Reding <thierry.reding@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/balance.rst   |    2 +-
 drivers/iommu/tegra-smmu.c     |    4 ++--
 include/linux/gfp_types.h      |   12 ++++--------
 include/trace/events/mmflags.h |    1 -
 lib/test_printf.c              |    8 ++++----
 mm/internal.h                  |    2 +-
 mm/page_alloc.c                |   13 +++----------
 tools/perf/builtin-kmem.c      |    1 -
 8 files changed, 15 insertions(+), 28 deletions(-)

--- a/Documentation/mm/balance.rst~mm-discard-__gfp_atomic
+++ a/Documentation/mm/balance.rst
@@ -6,7 +6,7 @@ Memory Balancing
 
 Started Jan 2000 by Kanoj Sarcar <kanoj@sgi.com>
 
-Memory balancing is needed for !__GFP_ATOMIC and !__GFP_KSWAPD_RECLAIM as
+Memory balancing is needed for !__GFP_HIGH and !__GFP_KSWAPD_RECLAIM as
 well as for non __GFP_IO allocations.
 
 The first reason why a caller may avoid reclaim is that the caller can not
--- a/drivers/iommu/tegra-smmu.c~mm-discard-__gfp_atomic
+++ a/drivers/iommu/tegra-smmu.c
@@ -671,12 +671,12 @@ static struct page *as_get_pde_page(stru
 	 * allocate page in a sleeping context if GFP flags permit. Hence
 	 * spinlock needs to be unlocked and re-locked after allocation.
 	 */
-	if (!(gfp & __GFP_ATOMIC))
+	if (gfpflags_allow_blocking(gfp))
 		spin_unlock_irqrestore(&as->lock, *flags);
 
 	page = alloc_page(gfp | __GFP_DMA | __GFP_ZERO);
 
-	if (!(gfp & __GFP_ATOMIC))
+	if (gfpflags_allow_blocking(gfp))
 		spin_lock_irqsave(&as->lock, *flags);
 
 	/*
--- a/include/linux/gfp_types.h~mm-discard-__gfp_atomic
+++ a/include/linux/gfp_types.h
@@ -31,7 +31,7 @@ typedef unsigned int __bitwise gfp_t;
 #define ___GFP_IO		0x40u
 #define ___GFP_FS		0x80u
 #define ___GFP_ZERO		0x100u
-#define ___GFP_ATOMIC		0x200u
+/* 0x200u unused */
 #define ___GFP_DIRECT_RECLAIM	0x400u
 #define ___GFP_KSWAPD_RECLAIM	0x800u
 #define ___GFP_WRITE		0x1000u
@@ -116,11 +116,8 @@ typedef unsigned int __bitwise gfp_t;
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
@@ -135,7 +132,6 @@ typedef unsigned int __bitwise gfp_t;
  * %__GFP_NOMEMALLOC is used to explicitly forbid access to emergency reserves.
  * This takes precedence over the %__GFP_MEMALLOC flag if both are set.
  */
-#define __GFP_ATOMIC	((__force gfp_t)___GFP_ATOMIC)
 #define __GFP_HIGH	((__force gfp_t)___GFP_HIGH)
 #define __GFP_MEMALLOC	((__force gfp_t)___GFP_MEMALLOC)
 #define __GFP_NOMEMALLOC ((__force gfp_t)___GFP_NOMEMALLOC)
@@ -329,7 +325,7 @@ typedef unsigned int __bitwise gfp_t;
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
@@ -31,7 +31,6 @@
 	gfpflag_string(__GFP_HIGHMEM),		\
 	gfpflag_string(GFP_DMA32),		\
 	gfpflag_string(__GFP_HIGH),		\
-	gfpflag_string(__GFP_ATOMIC),		\
 	gfpflag_string(__GFP_IO),		\
 	gfpflag_string(__GFP_FS),		\
 	gfpflag_string(__GFP_NOWARN),		\
--- a/lib/test_printf.c~mm-discard-__gfp_atomic
+++ a/lib/test_printf.c
@@ -674,17 +674,17 @@ flags(void)
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
@@ -24,7 +24,7 @@ struct folio_batch;
 #define GFP_RECLAIM_MASK (__GFP_RECLAIM|__GFP_HIGH|__GFP_IO|__GFP_FS|\
 			__GFP_NOWARN|__GFP_RETRY_MAYFAIL|__GFP_NOFAIL|\
 			__GFP_NORETRY|__GFP_MEMALLOC|__GFP_NOMEMALLOC|\
-			__GFP_ATOMIC|__GFP_NOLOCKDEP)
+			__GFP_NOLOCKDEP)
 
 /* The GFP flags allowed during early boot */
 #define GFP_BOOT_MASK (__GFP_BITS_MASK & ~(__GFP_RECLAIM|__GFP_IO|__GFP_FS))
--- a/mm/page_alloc.c~mm-discard-__gfp_atomic
+++ a/mm/page_alloc.c
@@ -4101,13 +4101,14 @@ static inline bool zone_watermark_fast(s
 	if (__zone_watermark_ok(z, order, mark, highest_zoneidx, alloc_flags,
 					free_pages))
 		return true;
+
 	/*
-	 * Ignore watermark boosting for GFP_ATOMIC order-0 allocations
+	 * Ignore watermark boosting for __GFP_HIGH order-0 allocations
 	 * when checking the min watermark. The min watermark is the
 	 * point where boosting is ignored so that kswapd is woken up
 	 * when below the low watermark.
 	 */
-	if (unlikely(!order && (gfp_mask & __GFP_ATOMIC) && z->watermark_boost
+	if (unlikely(!order && (alloc_flags & ALLOC_MIN_RESERVE) && z->watermark_boost
 		&& ((alloc_flags & ALLOC_WMARK_MASK) == WMARK_MIN))) {
 		mark = z->_watermark[WMARK_MIN];
 		return __zone_watermark_ok(z, order, mark, highest_zoneidx,
@@ -5072,14 +5073,6 @@ __alloc_pages_slowpath(gfp_t gfp_mask, u
 	unsigned int zonelist_iter_cookie;
 	int reserve_flags;
 
-	/*
-	 * We also sanity check to catch abuse of atomic reserves being used by
-	 * callers that are not in atomic context.
-	 */
-	if (WARN_ON_ONCE((gfp_mask & (__GFP_ATOMIC|__GFP_DIRECT_RECLAIM)) ==
-				(__GFP_ATOMIC|__GFP_DIRECT_RECLAIM)))
-		gfp_mask &= ~__GFP_ATOMIC;
-
 restart:
 	compaction_retries = 0;
 	no_progress_loops = 0;
--- a/tools/perf/builtin-kmem.c~mm-discard-__gfp_atomic
+++ a/tools/perf/builtin-kmem.c
@@ -641,7 +641,6 @@ static const struct {
 	{ "__GFP_HIGHMEM",		"HM" },
 	{ "GFP_DMA32",			"D32" },
 	{ "__GFP_HIGH",			"H" },
-	{ "__GFP_ATOMIC",		"_A" },
 	{ "__GFP_IO",			"I" },
 	{ "__GFP_FS",			"F" },
 	{ "__GFP_NOWARN",		"NWR" },
_

Patches currently in -mm which might be from neilb@suse.de are

mm-discard-__gfp_atomic.patch

