Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 581A9C4332F
	for <mm-commits@archiver.kernel.org>; Tue, 22 Nov 2022 22:39:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235035AbiKVWjS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Nov 2022 17:39:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230365AbiKVWjR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Nov 2022 17:39:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9260B94A1
        for <mm-commits@vger.kernel.org>; Tue, 22 Nov 2022 14:39:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4800F617F3
        for <mm-commits@vger.kernel.org>; Tue, 22 Nov 2022 22:39:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 909D5C433D6;
        Tue, 22 Nov 2022 22:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669156755;
        bh=tCM1m5BEYsX4Wx6jRvjoArDx0Aki8GCe/dhEEUD2hg8=;
        h=Date:To:From:Subject:From;
        b=OCSwneV9DXGNcIhUrBEtuxue4zc7UEJWBXoJWLHgIKjlIsbU0jHlnLK8O3cYLhZM5
         tlJF1eEXEd+pFDYV4t8DpmlgULkeogG6Vu+L/Cj9qgjSzCzxdMaYqJ6A1RXg0ovn01
         Uru3ok53If1PPLLq1YlwMLn75UX7AuROyHL7tYvA=
Date:   Tue, 22 Nov 2022 14:39:14 -0800
To:     mm-commits@vger.kernel.org, vbabka@suse.cz,
        mgorman@techsingularity.net, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-leave-irqs-enabled-for-per-cpu-page-allocations-fix.patch added to mm-unstable branch
Message-Id: <20221122223915.909D5C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: leave IRQs enabled for per-cpu page allocations -fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-leave-irqs-enabled-for-per-cpu-page-allocations-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-leave-irqs-enabled-for-per-cpu-page-allocations-fix.patch

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
@@ -3538,6 +3538,7 @@ void free_unref_page_list(struct list_he
 		struct zone *zone = page_zone(page);
 
 		list_del(&page->lru);
+		migratetype = get_pcppage_migratetype(page);
 
 		/* Different zone, different pcp lock. */
 		if (zone != locked_zone) {
@@ -3552,7 +3553,7 @@ void free_unref_page_list(struct list_he
 			 */
 			pcp_trylock_prepare(UP_flags);
 			pcp = pcp_spin_trylock(zone->per_cpu_pageset);
-			if (!pcp) {
+			if (unlikely(!pcp)) {
 				pcp_trylock_finish(UP_flags);
 				free_one_page(zone, page, page_to_pfn(page),
 					      0, migratetype, FPI_NONE);
@@ -3567,7 +3568,6 @@ void free_unref_page_list(struct list_he
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
mm-page_alloc-leave-irqs-enabled-for-per-cpu-page-allocations-fix.patch

