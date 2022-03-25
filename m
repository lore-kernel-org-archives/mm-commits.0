Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43005C43219
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:32:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356309AbiCYBdy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:33:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357464AbiCYBdN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:33:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCDEDBF518
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:31:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 464BA61929
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:31:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B5EEC340ED;
        Fri, 25 Mar 2022 01:31:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171878;
        bh=C5MDUpU+MwSYkiJmMFELgCsYFsEFIbwpuwRlx22m1fQ=;
        h=Date:To:From:Subject:From;
        b=LXZ7egTSeLpW3bJJij/Ic04DL8k/6Qs5NGmZogjyy+ociUk8O/cHgo5OwxonVk+c+
         why8EvPXJAkNTq+4jBnWz4y6VW7sz//fA0aVT24TbHL+jGChgjVzcPn5oiT0HOihJ8
         6flvhSJqmMk4NHQ43ikTHw8J3MK+ZNta+wArkC7c=
Date:   Thu, 24 Mar 2022 18:31:18 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        nsaenzju@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-page_alloc-dont-pass-pfn-to-free_unref_page_commit.patch removed from -mm tree
Message-Id: <20220325013118.9B5EEC340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: don't pass pfn to free_unref_page_commit()
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-dont-pass-pfn-to-free_unref_page_commit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Nicolas Saenz Julienne <nsaenzju@redhat.com>
Subject: mm/page_alloc: don't pass pfn to free_unref_page_commit()

free_unref_page_commit() doesn't make use of its pfn argument, so get
rid of it.

Link: https://lkml.kernel.org/r/20220202140451.415928-1-nsaenzju@redhat.com
Signed-off-by: Nicolas Saenz Julienne <nsaenzju@redhat.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-dont-pass-pfn-to-free_unref_page_commit
+++ a/mm/page_alloc.c
@@ -3366,8 +3366,8 @@ static int nr_pcp_high(struct per_cpu_pa
 	return min(READ_ONCE(pcp->batch) << 2, high);
 }
 
-static void free_unref_page_commit(struct page *page, unsigned long pfn,
-				   int migratetype, unsigned int order)
+static void free_unref_page_commit(struct page *page, int migratetype,
+				   unsigned int order)
 {
 	struct zone *zone = page_zone(page);
 	struct per_cpu_pages *pcp;
@@ -3416,7 +3416,7 @@ void free_unref_page(struct page *page,
 	}
 
 	local_lock_irqsave(&pagesets.lock, flags);
-	free_unref_page_commit(page, pfn, migratetype, order);
+	free_unref_page_commit(page, migratetype, order);
 	local_unlock_irqrestore(&pagesets.lock, flags);
 }
 
@@ -3426,13 +3426,13 @@ void free_unref_page(struct page *page,
 void free_unref_page_list(struct list_head *list)
 {
 	struct page *page, *next;
-	unsigned long flags, pfn;
+	unsigned long flags;
 	int batch_count = 0;
 	int migratetype;
 
 	/* Prepare pages for freeing */
 	list_for_each_entry_safe(page, next, list, lru) {
-		pfn = page_to_pfn(page);
+		unsigned long pfn = page_to_pfn(page);
 		if (!free_unref_page_prepare(page, pfn, 0)) {
 			list_del(&page->lru);
 			continue;
@@ -3448,15 +3448,10 @@ void free_unref_page_list(struct list_he
 			free_one_page(page_zone(page), page, pfn, 0, migratetype, FPI_NONE);
 			continue;
 		}
-
-		set_page_private(page, pfn);
 	}
 
 	local_lock_irqsave(&pagesets.lock, flags);
 	list_for_each_entry_safe(page, next, list, lru) {
-		pfn = page_private(page);
-		set_page_private(page, 0);
-
 		/*
 		 * Non-isolated types over MIGRATE_PCPTYPES get added
 		 * to the MIGRATE_MOVABLE pcp list.
@@ -3466,7 +3461,7 @@ void free_unref_page_list(struct list_he
 			migratetype = MIGRATE_MOVABLE;
 
 		trace_mm_page_free_batched(page);
-		free_unref_page_commit(page, pfn, migratetype, 0);
+		free_unref_page_commit(page, migratetype, 0);
 
 		/*
 		 * Guard against excessive IRQ disabled times when we get
_

Patches currently in -mm which might be from nsaenzju@redhat.com are


