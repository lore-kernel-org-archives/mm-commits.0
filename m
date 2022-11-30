Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95482C47088
	for <mm-commits@archiver.kernel.org>; Wed, 30 Nov 2022 23:51:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229507AbiK3XvF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 18:51:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbiK3XvE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 18:51:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4280970DDC
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 15:51:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CFEA061E5B
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 23:51:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D5F2C433D6;
        Wed, 30 Nov 2022 23:51:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669852262;
        bh=jkz/pMjIYSRKxr9lrVdqf/V694PMCmMy6geiaSILmLc=;
        h=Date:To:From:Subject:From;
        b=hj5XfJcQx+jv1FUsx8HYCg1CJPy3zMZgGOdlqo1Iinn7eiv115WY5VSsH6/6YnEyl
         1Mj/GrpG/mqIR3qhJ2ofZQNMsauPCoS5nzsWj8OL7uPslxlhJcG+wnSlYl9o6Qkpt7
         6aPIizW0/9TPTEM08F9C9LxHjQ3I7GVmk/ael+1I=
Date:   Wed, 30 Nov 2022 15:51:01 -0800
To:     mm-commits@vger.kernel.org, vbabka@suse.cz,
        mgorman@techsingularity.net, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-page_alloc-leave-irqs-enabled-for-per-cpu-page-allocations-fix.patch removed from -mm tree
Message-Id: <20221130235102.1D5F2C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/page_alloc: leave IRQs enabled for per-cpu page allocations -fix
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-leave-irqs-enabled-for-per-cpu-page-allocations-fix.patch

This patch was dropped because it was folded into mm-page_alloc-leave-irqs-enabled-for-per-cpu-page-allocations.patch

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm/page_alloc: leave IRQs enabled for per-cpu page allocations -fix
Date: Tue, 22 Nov 2022 13:12:28 +0000

As noted by Vlastimil Babka, the migratetype might be wrong if a PCP was
not locked so check the migrate type early.  Similarly the !pcp check is
generally unlikely so explicitly tagging it makes sense.

This is a fix for the mm-unstable patch
mm-page_alloc-leave-irqs-enabled-for-per-cpu-page-allocations.patch

Link: https://lkml.kernel.org/r/20221122131229.5263-2-mgorman@techsingularity.net
Reported-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-leave-irqs-enabled-for-per-cpu-page-allocations-fix
+++ a/mm/page_alloc.c
@@ -3523,6 +3523,7 @@ void free_unref_page_list(struct list_he
 		struct zone *zone = page_zone(page);
 
 		list_del(&page->lru);
+		migratetype = get_pcppage_migratetype(page);
 
 		/* Different zone, different pcp lock. */
 		if (zone != locked_zone) {
@@ -3537,7 +3538,7 @@ void free_unref_page_list(struct list_he
 			 */
 			pcp_trylock_prepare(UP_flags);
 			pcp = pcp_spin_trylock(zone->per_cpu_pageset);
-			if (!pcp) {
+			if (unlikely(!pcp)) {
 				pcp_trylock_finish(UP_flags);
 				free_one_page(zone, page, page_to_pfn(page),
 					      0, migratetype, FPI_NONE);
@@ -3552,7 +3553,6 @@ void free_unref_page_list(struct list_he
 		 * Non-isolated types over MIGRATE_PCPTYPES get added
 		 * to the MIGRATE_MOVABLE pcp list.
 		 */
-		migratetype = get_pcppage_migratetype(page);
 		if (unlikely(migratetype >= MIGRATE_PCPTYPES))
 			migratetype = MIGRATE_MOVABLE;
 
_

Patches currently in -mm which might be from mgorman@techsingularity.net are

mm-page_alloc-always-remove-pages-from-temporary-list.patch
mm-page_alloc-leave-irqs-enabled-for-per-cpu-page-allocations.patch
mm-page_alloc-simplify-locking-during-free_unref_page_list.patch

