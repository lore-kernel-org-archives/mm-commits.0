Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 486FBC433E0
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:18:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2109D64EE4
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:18:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230022AbhBZBRy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 20:17:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:48936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229990AbhBZBRh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 20:17:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EB19D64F14;
        Fri, 26 Feb 2021 01:17:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614302242;
        bh=Z4OHlgasObe9I4YqEC3YmoTOEWdzb1EqS/GlEV19qm4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=CI9zTa73g+a8a5AZsdI1q2la97BDpyWCax53CatqFzB5ASleGwDI8UVNx3xCQtPOv
         KF40bcb7vlZ3W2HND8spemmGNE7VsREJLjAGrOtIre+4+95tuOGrLIiFMGJO0Fmj6O
         In9nigy59e4R/6TAKoG5o1QpaWA9rvfdv0Y7x6kM=
Date:   Thu, 25 Feb 2021 17:17:21 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com, linmiaohe@huawei.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 032/118] mm/memory_hotplug: use helper function
 zone_end_pfn() to get end_pfn
Message-ID: <20210226011721.ghyGpeBIK%akpm@linux-foundation.org>
In-Reply-To: <20210225171452.713967e96554bb6a53e44a19@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/memory_hotplug: use helper function zone_end_pfn() to get end_pfn

Commit 108bcc96ef70 ("mm: add & use zone_end_pfn() and zone_spans_pfn()")
introduced the helper zone_end_pfn() to calculate the zone end pfn.  But
update_pgdat_span() forgot to use it.

Use this helper and rename local variable zone_end_pfn to end_pfn to avoid
a naming conflict with the existing zone_end_pfn().

Link: https://lkml.kernel.org/r/20210127093211.37714-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-use-helper-function-zone_end_pfn-to-get-end_pfn
+++ a/mm/memory_hotplug.c
@@ -493,20 +493,19 @@ static void update_pgdat_span(struct pgl
 
 	for (zone = pgdat->node_zones;
 	     zone < pgdat->node_zones + MAX_NR_ZONES; zone++) {
-		unsigned long zone_end_pfn = zone->zone_start_pfn +
-					     zone->spanned_pages;
+		unsigned long end_pfn = zone_end_pfn(zone);
 
 		/* No need to lock the zones, they can't change. */
 		if (!zone->spanned_pages)
 			continue;
 		if (!node_end_pfn) {
 			node_start_pfn = zone->zone_start_pfn;
-			node_end_pfn = zone_end_pfn;
+			node_end_pfn = end_pfn;
 			continue;
 		}
 
-		if (zone_end_pfn > node_end_pfn)
-			node_end_pfn = zone_end_pfn;
+		if (end_pfn > node_end_pfn)
+			node_end_pfn = end_pfn;
 		if (zone->zone_start_pfn < node_start_pfn)
 			node_start_pfn = zone->zone_start_pfn;
 	}
_
