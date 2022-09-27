Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E79CC32771
	for <mm-commits@archiver.kernel.org>; Tue, 27 Sep 2022 02:47:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229935AbiI0Cra (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 26 Sep 2022 22:47:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229943AbiI0Cr0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 26 Sep 2022 22:47:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06AE161D40
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 19:47:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0A93DB81902
        for <mm-commits@vger.kernel.org>; Tue, 27 Sep 2022 02:47:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B64CFC433D6;
        Tue, 27 Sep 2022 02:47:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664246840;
        bh=HgxLkYIrE5v1mqcqTTqkoSE6FSNwuAAl/ol57LQEUZ4=;
        h=Date:To:From:Subject:From;
        b=BIcYtufEwa5v3iKyrSExx9vKLAuoJGmfyCg/etaW5L+G4oso02apAfd5cvIv/8ZVZ
         cg5O5EyNpzftnZeWeMMQ4Q03av6tWV6gFX1dItU9Gd9C3SMUmZ5fycZlDNJYyMLOkS
         L2j1BCVEmmqcd5Nukncbbwku4TOoChu9rWQhtEDo=
Date:   Mon, 26 Sep 2022 19:47:19 -0700
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hwpoison-use-__pagemovable-to-detect-non-lru-movable-pages.patch removed from -mm tree
Message-Id: <20220927024720.B64CFC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm, hwpoison: use __PageMovable() to detect non-lru movable pages
has been removed from the -mm tree.  Its filename was
     mm-hwpoison-use-__pagemovable-to-detect-non-lru-movable-pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm, hwpoison: use __PageMovable() to detect non-lru movable pages
Date: Tue, 30 Aug 2022 20:36:00 +0800

It's more recommended to use __PageMovable() to detect non-lru movable
pages. We can avoid bumping page refcnt via isolate_movable_page() for
the isolated lru pages. Also if pages become PageLRU just after they're
checked but before trying to isolate them, isolate_lru_page() will be
called to do the right work.

[linmiaohe@huawei.com: fixes per Naoya Horiguchi]
  Link: https://lkml.kernel.org/r/1f7ee86e-7d28-0d8c-e0de-b7a5a94519e8@huawei.com
Link: https://lkml.kernel.org/r/20220830123604.25763-3-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

--- a/mm/memory-failure.c~mm-hwpoison-use-__pagemovable-to-detect-non-lru-movable-pages
+++ a/mm/memory-failure.c
@@ -2407,24 +2407,26 @@ EXPORT_SYMBOL(unpoison_memory);
 static bool isolate_page(struct page *page, struct list_head *pagelist)
 {
 	bool isolated = false;
-	bool lru = PageLRU(page);
 
 	if (PageHuge(page)) {
 		isolated = !isolate_hugetlb(page, pagelist);
 	} else {
+		bool lru = !__PageMovable(page);
+
 		if (lru)
 			isolated = !isolate_lru_page(page);
 		else
-			isolated = !isolate_movable_page(page, ISOLATE_UNEVICTABLE);
+			isolated = !isolate_movable_page(page,
+							 ISOLATE_UNEVICTABLE);
 
-		if (isolated)
+		if (isolated) {
 			list_add(&page->lru, pagelist);
+			if (lru)
+				inc_node_page_state(page, NR_ISOLATED_ANON +
+						    page_is_file_lru(page));
+		}
 	}
 
-	if (isolated && lru)
-		inc_node_page_state(page, NR_ISOLATED_ANON +
-				    page_is_file_lru(page));
-
 	/*
 	 * If we succeed to isolate the page, we grabbed another refcount on
 	 * the page, so we can safely drop the one we got from get_any_pages().
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

writeback-remove-unused-macro-dirty_full_scope.patch
mm-page_alloc-ensure-kswapd-doesnt-accidentally-go-to-sleep.patch
mm-page_alloc-make-zone_pcp_update-static.patch
mm-remove-obsolete-macro-nr_pcp_order_mask-and-nr_pcp_order_width.patch
mm-page_alloc-remove-obsolete-comment-in-zone_statistics.patch
mm-page_alloc-add-__init-annotations-to-init_mem_debugging_and_hardening.patch
mm-page_alloc-fix-freeing-static-percpu-memory.patch
mm-remove-obsolete-pgdat_is_empty.patch
mm-page_alloc-add-missing-is_migrate_isolate-check-in-set_page_guard.patch
mm-page_alloc-use-local-variable-zone_idx-directly.patch
mm-memory_hotplug-remove-obsolete-generic_free_nodedata.patch
mm-page_alloc-make-boot_nodestats-static.patch
mm-page_alloc-use-helper-macro-sz_1km.patch
mm-page_alloc-init-local-variable-buddy_pfn.patch
mm-page_alloc-use-costly_order-in-warn_on_once_gfp.patch
mm-page_alloc-remove-obsolete-gfpflags_normal_context.patch
mm-page_alloc-remove-obsolete-gfpflags_normal_context-fix.patch
mm-page_alloc-fix-obsolete-comment-in-deferred_pfn_valid.patch

