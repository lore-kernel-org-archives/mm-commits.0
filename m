From: akpm@linux-foundation.org
Subject: + mm-hwpoison-fix-wrong-num_poisoned_pages-account.patch added to -mm tree
Date: Tue, 05 Apr 2016 14:11:12 -0700
Message-ID: <570429f0.rrDwHboVOGwHnaux%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51960 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760118AbcDEVLO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Apr 2016 17:11:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, n-horiguchi@ah.jp.nec.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hwpoison: fix wrong num_poisoned_pages accounting
has been added to the -mm tree.  Its filename is
     mm-hwpoison-fix-wrong-num_poisoned_pages-account.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hwpoison-fix-wrong-num_poisoned_pages-account.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hwpoison-fix-wrong-num_poisoned_pages-account.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: mm/hwpoison: fix wrong num_poisoned_pages accounting

Currently, migration code increses num_poisoned_pages on *failed*
migration page as well as successfully migrated one at the trial of
memory-failure.  It will make the stat wrong.  As well, it marks the page
as PG_HWPoison even if the migration trial failed.  It would mean we
cannot recover the corrupted page using memory-failure facility.

This patches fixes it.

Signed-off-by: Minchan Kim <minchan@kernel.org>
Acked-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN mm/migrate.c~mm-hwpoison-fix-wrong-num_poisoned_pages-account mm/migrate.c
--- a/mm/migrate.c~mm-hwpoison-fix-wrong-num_poisoned_pages-account
+++ a/mm/migrate.c
@@ -975,7 +975,13 @@ out:
 		dec_zone_page_state(page, NR_ISOLATED_ANON +
 				page_is_file_cache(page));
 		/* Soft-offlined page shouldn't go through lru cache list */
-		if (reason == MR_MEMORY_FAILURE) {
+		if (reason == MR_MEMORY_FAILURE && rc == MIGRATEPAGE_SUCCESS) {
+			/*
+			 * With this release, we free successfully migrated
+			 * page and set PG_HWPoison on just freed page
+			 * intentionally. Although it's rather weird, it's how
+			 * HWPoison flag works at the moment.
+			 */
 			put_page(page);
 			if (!test_set_page_hwpoison(page))
 				num_poisoned_pages_inc();
_

Patches currently in -mm which might be from minchan@kernel.org are

mm-vmscan-reclaim-highmem-zone-if-buffer_heads-is-over-limit.patch
mm-call-swap_slot_free_notify-with-holding-page-lock.patch
mm-hwpoison-fix-wrong-num_poisoned_pages-account.patch
zsmalloc-use-first_page-rather-than-page.patch
zsmalloc-clean-up-many-bug_on.patch
zsmalloc-reordering-function-parameter.patch
zsmalloc-remove-unused-pool-param-in-obj_free.patch
mm-use-put_page-to-free-page-instead-of-putback_lru_page.patch
mm-compaction-support-non-lru-movable-page-migration.patch
mm-add-non-lru-movable-page-support-document.patch
mm-balloon-use-general-movable-page-feature-into-balloon.patch
zsmalloc-keep-max_object-in-size_class.patch
zsmalloc-squeeze-inuse-into-page-mapping.patch
zsmalloc-remove-page_mapcount_reset.patch
zsmalloc-squeeze-freelist-into-page-mapping.patch
zsmalloc-move-struct-zs_meta-from-mapping-to-freelist.patch
zsmalloc-factor-page-chain-functionality-out.patch
zsmalloc-separate-free_zspage-from-putback_zspage.patch
zsmalloc-zs_compact-refactoring.patch
zsmalloc-migrate-head-page-of-zspage.patch
zsmalloc-use-single-linked-list-for-page-chain.patch
zsmalloc-migrate-tail-pages-in-zspage.patch
zram-use-__gfp_movable-for-memory-allocation.patch

