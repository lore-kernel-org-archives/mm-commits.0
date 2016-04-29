From: akpm@linux-foundation.org
Subject: [merged] mm-hwpoison-fix-wrong-num_poisoned_pages-account.patch
 removed from -mm tree
Date: Fri, 29 Apr 2016 15:05:32 -0700
Message-ID: <5723daac.+1bosFKOnL6mHuGf%akpm__41381.6160792068$1461967553$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45429 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753077AbcD2WFd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 29 Apr 2016 18:05:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, n-horiguchi@ah.jp.nec.com, stable@vger.kernel.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hwpoison: fix wrong num_poisoned_pages accounting
has been removed from the -mm tree.  Its filename was
     mm-hwpoison-fix-wrong-num_poisoned_pages-account.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Reported-by: Vlastimil Babka <vbabka@suse.cz>
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

zsmalloc-use-first_page-rather-than-page.patch
zsmalloc-clean-up-many-bug_on.patch
zsmalloc-reordering-function-parameter.patch
zsmalloc-remove-unused-pool-param-in-obj_free.patch

