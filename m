Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A782C433EF
	for <mm-commits@archiver.kernel.org>; Thu,  3 Feb 2022 00:01:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230495AbiBCAB1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 2 Feb 2022 19:01:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230203AbiBCAB0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 2 Feb 2022 19:01:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FBE8C061714
        for <mm-commits@vger.kernel.org>; Wed,  2 Feb 2022 16:01:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 60BCDB832CC
        for <mm-commits@vger.kernel.org>; Thu,  3 Feb 2022 00:01:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3903C004E1;
        Thu,  3 Feb 2022 00:01:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643846483;
        bh=9rFn0VZXfOVwpNLwmDvcslaCgNTaroDGCOg0emPP490=;
        h=Date:To:From:Subject:From;
        b=VIHQRqf9cvUZoGi3hTyoX/3biG/huQagD/QTt/iQIToMrW49nI9x5e6Gu+ECENtQW
         XLRhhVu9K912z9Ap+Te2YkA6b0SPR6FDiycC16D7bza+eQoU1ez8h/Ci38nEZIXLc9
         M/mLjnewn2oO/e/bJMxZxgsHrvBXBAkaIqdfJV5k=
Received: by hp1 (sSMTP sendmail emulation); Wed, 02 Feb 2022 16:01:21 -0800
Date:   Wed, 02 Feb 2022 16:01:21 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        nsaenzju@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-dont-pass-pfn-to-free_unref_page_commit.patch added to -mm tree
Message-Id: <20220203000121.E3903C004E1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: don't pass pfn to free_unref_page_commit()
has been added to the -mm tree.  Its filename is
     mm-page_alloc-dont-pass-pfn-to-free_unref_page_commit.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-dont-pass-pfn-to-free_unref_page_commit.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-dont-pass-pfn-to-free_unref_page_commit.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -3422,8 +3422,8 @@ static int nr_pcp_high(struct per_cpu_pa
 	return min(READ_ONCE(pcp->batch) << 2, high);
 }
 
-static void free_unref_page_commit(struct page *page, unsigned long pfn,
-				   int migratetype, unsigned int order)
+static void free_unref_page_commit(struct page *page, int migratetype,
+				   unsigned int order)
 {
 	struct zone *zone = page_zone(page);
 	struct per_cpu_pages *pcp;
@@ -3472,7 +3472,7 @@ void free_unref_page(struct page *page,
 	}
 
 	local_lock_irqsave(&pagesets.lock, flags);
-	free_unref_page_commit(page, pfn, migratetype, order);
+	free_unref_page_commit(page, migratetype, order);
 	local_unlock_irqrestore(&pagesets.lock, flags);
 }
 
@@ -3482,13 +3482,13 @@ void free_unref_page(struct page *page,
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
@@ -3504,15 +3504,10 @@ void free_unref_page_list(struct list_he
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
@@ -3522,7 +3517,7 @@ void free_unref_page_list(struct list_he
 			migratetype = MIGRATE_MOVABLE;
 
 		trace_mm_page_free_batched(page);
-		free_unref_page_commit(page, pfn, migratetype, 0);
+		free_unref_page_commit(page, migratetype, 0);
 
 		/*
 		 * Guard against excessive IRQ disabled times when we get
_

Patches currently in -mm which might be from nsaenzju@redhat.com are

mm-page_alloc-dont-pass-pfn-to-free_unref_page_commit.patch

