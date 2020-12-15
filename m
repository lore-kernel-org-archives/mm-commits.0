Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A918AC47434
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 00:00:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7B0B522EBD
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 00:00:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725864AbgLOX7z (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 18:59:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:60868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729823AbgLOX0I (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 18:26:08 -0500
Date:   Tue, 15 Dec 2020 15:18:19 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608074299;
        bh=aWj+w0DQvP4iVMhfTMEWWkyzN6ymCScTXeMFpM9M7Iw=;
        h=From:To:Subject:From;
        b=nUM08d3OUB8B60tZFVceIGt4d+kSu8Z5XFQ0qDaSMjv4Ns8biJDn4asGu5tkduuCQ
         XfttBAnsOIOgmffNGdudMwwP3oePKzl/zX7v+n411ArqKKAob7Rh02FamGVN25OZKO
         kPJLu/JUbWABT7xp86H++EROZtDdEG4DMw037hl8=
From:   akpm@linux-foundation.org
To:     alex.shi@linux.alibaba.com, guro@fb.com, hannes@cmpxchg.org,
        mhocko@kernel.org, mm-commits@vger.kernel.org,
        vdavydov.dev@gmail.com
Subject:  [merged]
 mm-memcg-update-page-struct-member-in-comments.patch removed from -mm tree
Message-ID: <20201215231819.n6JzewVoq%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memcg: update page struct member in comments
has been removed from the -mm tree.  Its filename was
     mm-memcg-update-page-struct-member-in-comments.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: mm/memcg: update page struct member in comments

The page->mem_cgroup member is replaced by memcg_data, and add a helper
page_memcg() for it.  Need to update comments to avoid confusing.

Link: https://lkml.kernel.org/r/1491c150-1cc0-6062-08ea-9c891548a3bc@linux.alibaba.com
Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Acked-by: Roman Gushchin <guro@fb.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-update-page-struct-member-in-comments
+++ a/mm/memcontrol.c
@@ -1324,7 +1324,7 @@ int mem_cgroup_scan_tasks(struct mem_cgr
  * @page: the page
  * @pgdat: pgdat of the page
  *
- * This function relies on page->mem_cgroup being stable - see the
+ * This function relies on page's memcg being stable - see the
  * access rules in commit_charge().
  */
 struct lruvec *mem_cgroup_page_lruvec(struct page *page, struct pglist_data *pgdat)
@@ -2879,7 +2879,7 @@ static void commit_charge(struct page *p
 {
 	VM_BUG_ON_PAGE(page->mem_cgroup, page);
 	/*
-	 * Any of the following ensures page->mem_cgroup stability:
+	 * Any of the following ensures page's memcg stability:
 	 *
 	 * - the page lock
 	 * - LRU isolation
_

Patches currently in -mm which might be from alex.shi@linux.alibaba.com are

mm-thp-move-lru_add_page_tail-func-to-huge_memoryc.patch
mm-thp-use-head-for-head-page-in-lru_add_page_tail.patch
mm-thp-simplify-lru_add_page_tail.patch
mm-thp-narrow-lru-locking.patch
mm-vmscan-remove-unnecessary-lruvec-adding.patch
mm-rmap-stop-store-reordering-issue-on-page-mapping.patch
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
mm-vmscan-__isolate_lru_page_prepare-clean-up.patch
fs-nilfs2-remove-some-unused-macros-to-tame-gcc.patch
gcov-fix-kernel-doc-markup-issue.patch
mm-memcg-bail-early-from-swap-accounting-if-memcg-disabled.patch
mm-memcg-warning-on-memcg-after-readahead-page-charged.patch
mm-memcontrol-rewrite-mem_cgroup_page_lruvec-fix.patch

