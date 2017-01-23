From: akpm@linux-foundation.org
Subject: + hwpoison-soft-offlining-for-non-lru-movable-page.patch added to -mm tree
Date: Mon, 23 Jan 2017 15:38:21 -0800
Message-ID: <588693ed.REQDuROUSllJ5O2y%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46398 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751829AbdAWXiW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 23 Jan 2017 18:38:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xieyisheng1@huawei.com, mhocko@kernel.org, minchan@kernel.org, n-horiguchi@ah.jp.nec.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: HWPOISON: soft offlining for non-lru movable pages
has been added to the -mm tree.  Its filename is
     hwpoison-soft-offlining-for-non-lru-movable-page.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/hwpoison-soft-offlining-for-non-lru-movable-page.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/hwpoison-soft-offlining-for-non-lru-movable-page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yisheng Xie <xieyisheng1@huawei.com>
Subject: HWPOISON: soft offlining for non-lru movable pages

Extend the soft offlining framework to support non-lru page, which already
support migration after commit bda807d44454 ("mm: migrate: support non-lru
movable page migration")

When memory correction errors occur on a non-lru movable page, we can
choose to stop using it by migrating data onto another page and disable
the original (maybe half-broken) one.

Link: http://lkml.kernel.org/r/1485183010-9276-1-git-send-email-ysxie@foxmail.com
Signed-off-by: Yisheng Xie <xieyisheng1@huawei.com>
Suggested-by: Michal Hocko <mhocko@kernel.org>
Suggested-by: Minchan Kim <minchan@kernel.org>
Acked-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff -puN mm/memory-failure.c~hwpoison-soft-offlining-for-non-lru-movable-page mm/memory-failure.c
--- a/mm/memory-failure.c~hwpoison-soft-offlining-for-non-lru-movable-page
+++ a/mm/memory-failure.c
@@ -1527,7 +1527,8 @@ static int get_any_page(struct page *pag
 {
 	int ret = __get_any_page(page, pfn, flags);
 
-	if (ret == 1 && !PageHuge(page) && !PageLRU(page)) {
+	if (ret == 1 && !PageHuge(page) &&
+	    !PageLRU(page) && !__PageMovable(page)) {
 		/*
 		 * Try to free it.
 		 */
@@ -1649,7 +1650,10 @@ static int __soft_offline_page(struct pa
 	 * Try to migrate to a new page instead. migrate.c
 	 * handles a large number of cases for us.
 	 */
-	ret = isolate_lru_page(page);
+	if (PageLRU(page))
+		ret = isolate_lru_page(page);
+	else
+		ret = !isolate_movable_page(page, ISOLATE_UNEVICTABLE);
 	/*
 	 * Drop page reference which is came from get_any_page()
 	 * successful isolate_lru_page() already took another one.
@@ -1657,18 +1661,20 @@ static int __soft_offline_page(struct pa
 	put_hwpoison_page(page);
 	if (!ret) {
 		LIST_HEAD(pagelist);
-		inc_node_page_state(page, NR_ISOLATED_ANON +
-					page_is_file_cache(page));
+		/*
+		 * After isolated lru page, the PageLRU will be cleared,
+		 * so use !__PageMovable instead for LRU page's mapping
+		 * cannot have PAGE_MAPPING_MOVABLE.
+		 */
+		if (!__PageMovable(page))
+			inc_node_page_state(page, NR_ISOLATED_ANON +
+						page_is_file_cache(page));
 		list_add(&page->lru, &pagelist);
 		ret = migrate_pages(&pagelist, new_page, NULL, MPOL_MF_MOVE_ALL,
 					MIGRATE_SYNC, MR_MEMORY_FAILURE);
 		if (ret) {
-			if (!list_empty(&pagelist)) {
-				list_del(&page->lru);
-				dec_node_page_state(page, NR_ISOLATED_ANON +
-						page_is_file_cache(page));
-				putback_lru_page(page);
-			}
+			if (!list_empty(&pagelist))
+				putback_movable_pages(&pagelist);
 
 			pr_info("soft offline: %#lx: migration failed %d, type %lx\n",
 				pfn, ret, page->flags);
_

Patches currently in -mm which might be from xieyisheng1@huawei.com are

hwpoison-soft-offlining-for-non-lru-movable-page.patch

