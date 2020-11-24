Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4D9DC6379D
	for <mm-commits@archiver.kernel.org>; Tue, 24 Nov 2020 02:54:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9FFE12071E
	for <mm-commits@archiver.kernel.org>; Tue, 24 Nov 2020 02:54:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MTbpI5AB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728291AbgKXCxw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 23 Nov 2020 21:53:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:37526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727381AbgKXCxw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 23 Nov 2020 21:53:52 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3CEA620719;
        Tue, 24 Nov 2020 02:53:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1606186430;
        bh=tbMq/L0rPiyD9uNaRlf2xwBz1p0S1jYbMZy+x7mmMaU=;
        h=Date:From:To:Subject:From;
        b=MTbpI5ABi3817ecHVoc5nse+f0OEEabQ5pv+qAHZcRiKZF/mnoBfl219Y/IsrTMLF
         pJMRL54k0Rc0ZyMtVWaHqxBwseS4NoHi2RNMFWNSMnuoCwW00sGA0EGkpaU8akTxME
         /LRXzPK5MqVsZoE3K4zrnvep66WhNDZ6q1nUYfCE=
Date:   Mon, 23 Nov 2020 18:53:47 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, alex.shi@linux.alibaba.com,
        hughd@google.com, mhocko@suse.com, mm-commits@vger.kernel.org,
        vbabka@suse.cz, willy@infradead.org, yuzhao@google.com
Subject:  + mm-vmscan-__isolate_lru_page_prepare-clean-up.patch
 added to -mm tree
Message-ID: <20201124025347.xGaMMXvcS%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmscan: __isolate_lru_page_prepare() cleanup
has been added to the -mm tree.  Its filename is
     mm-vmscan-__isolate_lru_page_prepare-clean-up.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-vmscan-__isolate_lru_page_prepare-clean-up.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscan-__isolate_lru_page_prepare-clean-up.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: mm/vmscan: __isolate_lru_page_prepare() cleanup

The function just returns 2 results, so using a 'switch' to deal with its
result is unnecessary.  Also simplify it to a bool func as Vlastimil
suggested.

Also remove 'goto' by reusing list_move(), and take Matthew Wilcox's
suggestion to update comments in function.

Link: https://lkml.kernel.org/r/728874d7-2d93-4049-68c1-dcc3b2d52ccd@linux.alibaba.com
Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    2 -
 mm/compaction.c      |    2 -
 mm/vmscan.c          |   68 ++++++++++++++++++-----------------------
 3 files changed, 33 insertions(+), 39 deletions(-)

--- a/include/linux/swap.h~mm-vmscan-__isolate_lru_page_prepare-clean-up
+++ a/include/linux/swap.h
@@ -356,7 +356,7 @@ extern void lru_cache_add_inactive_or_un
 extern unsigned long zone_reclaimable_pages(struct zone *zone);
 extern unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
 					gfp_t gfp_mask, nodemask_t *mask);
-extern int __isolate_lru_page_prepare(struct page *page, isolate_mode_t mode);
+extern bool __isolate_lru_page_prepare(struct page *page, isolate_mode_t mode);
 extern unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
 						  unsigned long nr_pages,
 						  gfp_t gfp_mask,
--- a/mm/compaction.c~mm-vmscan-__isolate_lru_page_prepare-clean-up
+++ a/mm/compaction.c
@@ -988,7 +988,7 @@ isolate_migratepages_block(struct compac
 		if (unlikely(!get_page_unless_zero(page)))
 			goto isolate_fail;
 
-		if (__isolate_lru_page_prepare(page, isolate_mode) != 0)
+		if (!__isolate_lru_page_prepare(page, isolate_mode))
 			goto isolate_fail_put;
 
 		/* Try isolate the page */
--- a/mm/vmscan.c~mm-vmscan-__isolate_lru_page_prepare-clean-up
+++ a/mm/vmscan.c
@@ -1536,19 +1536,17 @@ unsigned int reclaim_clean_pages_from_li
  * page:	page to consider
  * mode:	one of the LRU isolation modes defined above
  *
- * returns 0 on success, -ve errno on failure.
+ * returns true on success, false on failure.
  */
-int __isolate_lru_page_prepare(struct page *page, isolate_mode_t mode)
+bool __isolate_lru_page_prepare(struct page *page, isolate_mode_t mode)
 {
-	int ret = -EBUSY;
-
 	/* Only take pages on the LRU. */
 	if (!PageLRU(page))
-		return ret;
+		return false;
 
 	/* Compaction should not handle unevictable pages but CMA can do so */
 	if (PageUnevictable(page) && !(mode & ISOLATE_UNEVICTABLE))
-		return ret;
+		return false;
 
 	/*
 	 * To minimise LRU disruption, the caller can indicate that it only
@@ -1561,7 +1559,7 @@ int __isolate_lru_page_prepare(struct pa
 	if (mode & ISOLATE_ASYNC_MIGRATE) {
 		/* All the caller can do on PageWriteback is block */
 		if (PageWriteback(page))
-			return ret;
+			return false;
 
 		if (PageDirty(page)) {
 			struct address_space *mapping;
@@ -1577,20 +1575,20 @@ int __isolate_lru_page_prepare(struct pa
 			 * from the page cache.
 			 */
 			if (!trylock_page(page))
-				return ret;
+				return false;
 
 			mapping = page_mapping(page);
 			migrate_dirty = !mapping || mapping->a_ops->migratepage;
 			unlock_page(page);
 			if (!migrate_dirty)
-				return ret;
+				return false;
 		}
 	}
 
 	if ((mode & ISOLATE_UNMAPPED) && page_mapped(page))
-		return ret;
+		return false;
 
-	return 0;
+	return true;
 }
 
 /*
@@ -1674,35 +1672,31 @@ static unsigned long isolate_lru_pages(u
 		 * only when the page is being freed somewhere else.
 		 */
 		scan += nr_pages;
-		switch (__isolate_lru_page_prepare(page, mode)) {
-		case 0:
-			/*
-			 * Be careful not to clear PageLRU until after we're
-			 * sure the page is not being freed elsewhere -- the
-			 * page release code relies on it.
-			 */
-			if (unlikely(!get_page_unless_zero(page)))
-				goto busy;
+		if (!__isolate_lru_page_prepare(page, mode)) {
+			/* It is being freed elsewhere */
+			list_move(&page->lru, src);
+			continue;
+		}
+		/*
+		 * Be careful not to clear PageLRU until after we're
+		 * sure the page is not being freed elsewhere -- the
+		 * page release code relies on it.
+		 */
+		if (unlikely(!get_page_unless_zero(page))) {
+			list_move(&page->lru, src);
+			continue;
+		}
 
-			if (!TestClearPageLRU(page)) {
-				/*
-				 * This page may in other isolation path,
-				 * but we still hold lru_lock.
-				 */
-				put_page(page);
-				goto busy;
-			}
-
-			nr_taken += nr_pages;
-			nr_zone_taken[page_zonenum(page)] += nr_pages;
-			list_move(&page->lru, dst);
-			break;
-
-		default:
-busy:
-			/* else it is being freed elsewhere */
+		if (!TestClearPageLRU(page)) {
+			/* Another thread is already isolating this page */
+			put_page(page);
 			list_move(&page->lru, src);
+			continue;
 		}
+
+		nr_taken += nr_pages;
+		nr_zone_taken[page_zonenum(page)] += nr_pages;
+		list_move(&page->lru, dst);
 	}
 
 	/*
_

Patches currently in -mm which might be from alex.shi@linux.alibaba.com are

mm-filemap-add-static-for-function-__add_to_page_cache_locked.patch
fs-ntfs-remove-unused-varibles.patch
fs-ntfs-remove-unused-varible-attr_len.patch
mm-truncate-add-parameter-explanation-for-invalidate_mapping_pagevec.patch
mm-memcg-update-page-struct-member-in-comments.patch
mm-thp-move-lru_add_page_tail-func-to-huge_memoryc.patch
mm-thp-use-head-for-head-page-in-lru_add_page_tail.patch
mm-thp-simplify-lru_add_page_tail.patch
mm-thp-narrow-lru-locking.patch
mm-vmscan-remove-unnecessary-lruvec-adding.patch
mm-rmap-stop-store-reordering-issue-on-page-mapping.patch
mm-rmap-stop-store-reordering-issue-on-page-mapping-fix.patch
mm-memcg-add-debug-checking-in-lock_page_memcg.patch
mm-swapc-fold-vm-event-pgrotated-into-pagevec_move_tail_fn.patch
mm-lru-move-lock-into-lru_note_cost.patch
mm-vmscan-remove-lruvec-reget-in-move_pages_to_lru.patch
mm-mlock-remove-lru_lock-on-testclearpagemlocked.patch
mm-mlock-remove-__munlock_isolate_lru_page.patch
mm-lru-introduce-testclearpagelru.patch
mm-compaction-do-page-isolation-first-in-compaction.patch
mm-swapc-serialize-memcg-changes-in-pagevec_lru_move_fn.patch
mm-lru-replace-pgdat-lru_lock-with-lruvec-lock.patch
mm-lru-replace-pgdat-lru_lock-with-lruvec-lock-fix.patch
mm-lru-replace-pgdat-lru_lock-with-lruvec-lock-fix-2.patch
mm-lru-introduce-the-relock_page_lruvec-function-fix.patch
mm-memcg-remove-incorrect-comments.patch
mm-mapping_dirty_helpers-enhance-the-kernel-doc-markups.patch
mm-add-colon-to-fix-kernel-doc-markups-error-for-check_pte.patch
mm-vmalloc-add-align-parameter-explanation-for-pvm_determine_end_from_reverse.patch
docs-vm-remove-unused-3-items-explanation-for-proc-vmstat.patch
khugepaged-add-couples-parameter-explanation-for-kernel-doc-markup.patch
mm-vmscan-__isolate_lru_page_prepare-clean-up.patch
gcov-fix-kernel-doc-markup-issue.patch
mm-swapc-reduce-lock-contention-in-lru_cache_add.patch
mm-memcg-bail-early-from-swap-accounting-if-memcg-disabled.patch
mm-memcg-warning-on-memcg-after-readahead-page-charged.patch
mm-memcontrol-rewrite-mem_cgroup_page_lruvec-fix.patch

