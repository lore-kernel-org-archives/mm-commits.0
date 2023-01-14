Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 310C0C3DA78
	for <mm-commits@archiver.kernel.org>; Sat, 14 Jan 2023 04:40:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229874AbjANEkw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 Jan 2023 23:40:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbjANEkk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2023 23:40:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BE19AF
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2023 20:40:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4320CB822C0
        for <mm-commits@vger.kernel.org>; Sat, 14 Jan 2023 04:40:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1AF7C433D2;
        Sat, 14 Jan 2023 04:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673671236;
        bh=9TRJtua45vqv3Z/rBSg1grnVK8eRCGgB3o6w9sE1PU0=;
        h=Date:To:From:Subject:From;
        b=hQpofd36KKrmjN8upAq8aQCLaBXYot5qWfYnlY7O2wFE8T6MqjJ4dxtRneYhwZMbT
         gLwDku4cq4Jc7d74YgU7/BIroABgxQlCbroN14GsgEJdWhVOL1+YSTdr0U7XL4bz8v
         VT2nkvEqeTw3QeT8Kf0M1lwo8UsjDUFSCIgXN2sE=
Date:   Fri, 13 Jan 2023 20:40:36 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        thierry.reding@gmail.com, neilb@suse.de, mhocko@suse.com,
        mgorman@techsingularity.net, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-explicitly-define-what-alloc-flags-deplete-min-reserves.patch added to mm-unstable branch
Message-Id: <20230114044036.D1AF7C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: explicitly define what alloc flags deplete min reserves
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-explicitly-define-what-alloc-flags-deplete-min-reserves.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-explicitly-define-what-alloc-flags-deplete-min-reserves.patch

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
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm/page_alloc: explicitly define what alloc flags deplete min reserves
Date: Fri, 13 Jan 2023 11:12:15 +0000

As there are more ALLOC_ flags that affect reserves, define what flags
affect reserves and clarify the effect of each flag.

Link: https://lkml.kernel.org/r/20230113111217.14134-5-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: NeilBrown <neilb@suse.de>
Cc: Thierry Reding <thierry.reding@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/internal.h~mm-page_alloc-explicitly-define-what-alloc-flags-deplete-min-reserves
+++ a/mm/internal.h
@@ -792,6 +792,9 @@ unsigned int reclaim_clean_pages_from_li
 #define ALLOC_HIGHATOMIC	0x200 /* Allows access to MIGRATE_HIGHATOMIC */
 #define ALLOC_KSWAPD		0x800 /* allow waking of kswapd, __GFP_KSWAPD_RECLAIM set */
 
+/* Flags that allow allocations below the min watermark. */
+#define ALLOC_RESERVES (ALLOC_HARDER|ALLOC_MIN_RESERVE|ALLOC_HIGHATOMIC|ALLOC_OOM)
+
 enum ttu_flags;
 struct tlbflush_unmap_batch;
 
--- a/mm/page_alloc.c~mm-page_alloc-explicitly-define-what-alloc-flags-deplete-min-reserves
+++ a/mm/page_alloc.c
@@ -3967,15 +3967,14 @@ ALLOW_ERROR_INJECTION(should_fail_alloc_
 static inline long __zone_watermark_unusable_free(struct zone *z,
 				unsigned int order, unsigned int alloc_flags)
 {
-	const bool alloc_harder = (alloc_flags & (ALLOC_HARDER|ALLOC_OOM));
 	long unusable_free = (1 << order) - 1;
 
 	/*
-	 * If the caller does not have rights to ALLOC_HARDER then subtract
-	 * the high-atomic reserves. This will over-estimate the size of the
-	 * atomic reserve but it avoids a search.
+	 * If the caller does not have rights to reserves below the min
+	 * watermark then subtract the high-atomic reserves. This will
+	 * over-estimate the size of the atomic reserve but it avoids a search.
 	 */
-	if (likely(!alloc_harder))
+	if (likely(!(alloc_flags & ALLOC_RESERVES)))
 		unusable_free += z->nr_reserved_highatomic;
 
 #ifdef CONFIG_CMA
@@ -3999,25 +3998,36 @@ bool __zone_watermark_ok(struct zone *z,
 {
 	long min = mark;
 	int o;
-	const bool alloc_harder = (alloc_flags & (ALLOC_HARDER|ALLOC_OOM));
 
 	/* free_pages may go negative - that's OK */
 	free_pages -= __zone_watermark_unusable_free(z, order, alloc_flags);
 
-	if (alloc_flags & ALLOC_MIN_RESERVE)
-		min -= min / 2;
+	if (unlikely(alloc_flags & ALLOC_RESERVES)) {
+		/*
+		 * __GFP_HIGH allows access to 50% of the min reserve as well
+		 * as OOM.
+		 */
+		if (alloc_flags & ALLOC_MIN_RESERVE)
+			min -= min / 2;
+
+		/*
+		 * Non-blocking allocations can access some of the reserve
+		 * with more access if also __GFP_HIGH. The reasoning is that
+		 * a non-blocking caller may incur a more severe penalty
+		 * if it cannot get memory quickly, particularly if it's
+		 * also __GFP_HIGH.
+		 */
+		if (alloc_flags & ALLOC_HARDER)
+			min -= min / 4;
 
-	if (unlikely(alloc_harder)) {
 		/*
-		 * OOM victims can try even harder than normal ALLOC_HARDER
+		 * OOM victims can try even harder than the normal reserve
 		 * users on the grounds that it's definitely going to be in
 		 * the exit path shortly and free memory. Any allocation it
 		 * makes during the free path will be small and short-lived.
 		 */
 		if (alloc_flags & ALLOC_OOM)
 			min -= min / 2;
-		else
-			min -= min / 4;
 	}
 
 	/*
_

Patches currently in -mm which might be from mgorman@techsingularity.net are

mm-page_alloc-rename-alloc_high-to-alloc_min_reserve.patch
mm-page_alloc-treat-rt-tasks-similar-to-__gfp_high.patch
mm-page_alloc-explicitly-record-high-order-atomic-allocations-in-alloc_flags.patch
mm-page_alloc-explicitly-define-what-alloc-flags-deplete-min-reserves.patch
mm-page_alloc-explicitly-define-how-__gfp_high-non-blocking-allocations-accesses-reserves.patch

