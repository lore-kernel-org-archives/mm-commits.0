Return-Path: <SRS0=YRC/=A3=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAB64C433E1
	for <mm-commits@archiver.kernel.org>; Thu, 16 Jul 2020 21:46:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8BFDA20809
	for <mm-commits@archiver.kernel.org>; Thu, 16 Jul 2020 21:46:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594935990;
	bh=E21ZQ67TEGt/fIwWC/ZucbqKiRznOo8UBRF/dy3W83U=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=XxgNrJMyktbqtQTCdjs5NAES7R5FJ3Qk+Rw04xJcosk0ArU8EsReH8OuWrsVr2Wsy
	 qi2uLxXAGboXrYpYcxJiUDNZbWzWXySPDIOsCL+m/HAWK9vETswR05b0yE1uowdKt0
	 yhsVftGz5qvjdQk7hpTysJZNZwnFDI4QXUQCGXS4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726599AbgGPVq1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Jul 2020 17:46:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:46076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726546AbgGPVq0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 16 Jul 2020 17:46:26 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D863F207DD;
        Thu, 16 Jul 2020 21:46:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594935985;
        bh=E21ZQ67TEGt/fIwWC/ZucbqKiRznOo8UBRF/dy3W83U=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Rr3AjheGayO7LhjmPjRSbEvyntLqT8VxF31bYA72wBFh72QYrUxXtH/2nMbnKBBRI
         cDUt3tG44Bgk9fkgUZjcYXRjBTsJe7RNy0QMJIE/lC0DcxdSaWxctAKCbr492OG4I2
         FnaixC+reSFg1bKNTWAmmTGjs3Ki8uA7uVkUIFys=
Date:   Thu, 16 Jul 2020 14:46:24 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     aneesh.kumar@linux.vnet.ibm.com, dave.hansen@intel.com,
        david@redhat.com, mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com,
        naoya.horiguchi@nec.com, osalvador@suse.com, osalvador@suse.de,
        tony.luck@intel.com, zeil@yandex-team.ru
Subject:  +
 mmhwpoison-refactor-soft_offline_huge_page-and-__soft_offline_page.patch
 added to -mm tree
Message-ID: <20200716214624.UFVUONbq8%akpm@linux-foundation.org>
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm,hwpoison: refactor soft_offline_huge_page and __soft_offline_page
has been added to the -mm tree.  Its filename is
     mmhwpoison-refactor-soft_offline_huge_page-and-__soft_offline_page.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mmhwpoison-refactor-soft_offline_huge_page-and-__soft_offline_page.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mmhwpoison-refactor-soft_offline_huge_page-and-__soft_offline_page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Oscar Salvador <osalvador@suse.de>
Subject: mm,hwpoison: refactor soft_offline_huge_page and __soft_offline_page

Merging soft_offline_huge_page and __soft_offline_page let us get rid of
quite some duplicated code, and makes the code much easier to follow.

Now, __soft_offline_page will handle both normal and hugetlb pages.

Note that move put_page() block to the beginning of page_handle_poison()
with drain_all_pages() in order to make sure that the target page is freed
and sent into free list to make take_page_off_buddy() work properly.

Link: http://lkml.kernel.org/r/20200716123810.25292-14-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.com>
Signed-off-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dmitry Yakunin <zeil@yandex-team.ru>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |  141 +++++++++++++++---------------------------
 1 file changed, 52 insertions(+), 89 deletions(-)

--- a/mm/memory-failure.c~mmhwpoison-refactor-soft_offline_huge_page-and-__soft_offline_page
+++ a/mm/memory-failure.c
@@ -1723,62 +1723,50 @@ static int get_any_page(struct page *pag
 	return ret;
 }
 
-static int soft_offline_huge_page(struct page *page)
+static bool isolate_page(struct page *page, struct list_head *pagelist)
 {
-	int ret = -EBUSY;
-	unsigned long pfn = page_to_pfn(page);
-	struct page *hpage = compound_head(page);
-	LIST_HEAD(pagelist);
+	bool isolated = false;
+	bool lru = PageLRU(page);
 
-	/*
-	 * This double-check of PageHWPoison is to avoid the race with
-	 * memory_failure(). See also comment in __soft_offline_page().
-	 */
-	lock_page(hpage);
-	if (PageHWPoison(hpage)) {
-		unlock_page(hpage);
-		put_page(hpage);
-		pr_info("soft offline: %#lx hugepage already poisoned\n", pfn);
-		return -EBUSY;
+	if (PageHuge(page)) {
+		isolated = isolate_huge_page(page, pagelist);
+	} else {
+		if (lru)
+			isolated = !isolate_lru_page(page);
+		else
+			isolated = !isolate_movable_page(page, ISOLATE_UNEVICTABLE);
+
+		if (isolated)
+			list_add(&page->lru, pagelist);
 	}
-	unlock_page(hpage);
 
-	ret = isolate_huge_page(hpage, &pagelist);
+	if (isolated && lru)
+		inc_node_page_state(page, NR_ISOLATED_ANON +
+				    page_is_file_lru(page));
+
 	/*
-	 * get_any_page() and isolate_huge_page() takes a refcount each,
-	 * so need to drop one here.
+	 * If we succeed to isolate the page, we grabbed another refcount on
+	 * the page, so we can safely drop the one we got from get_any_pages().
+	 * If we failed to isolate the page, it means that we cannot go further
+	 * and we will return an error, so drop the reference we got from
+	 * get_any_pages() as well.
 	 */
-	put_page(hpage);
-	if (!ret) {
-		pr_info("soft offline: %#lx hugepage failed to isolate\n", pfn);
-		return -EBUSY;
-	}
-
-	ret = migrate_pages(&pagelist, new_page, NULL, MPOL_MF_MOVE_ALL,
-				MIGRATE_SYNC, MR_MEMORY_FAILURE);
-	if (ret) {
-		pr_info("soft offline: %#lx: hugepage migration failed %d, type %lx (%pGp)\n",
-			pfn, ret, page->flags, &page->flags);
-		if (!list_empty(&pagelist))
-			putback_movable_pages(&pagelist);
-		if (ret > 0)
-			ret = -EIO;
-	} else {
-		/*
-		 * At this point the page cannot be in-use since we do not
-		 * let the page to go back to hugetlb freelists.
-		 * In that case we just need to dissolve it.
-		 * page_handle_poison will take care of it.
-		 */
-		page_handle_poison(page, true, true, true);
-	}
-	return ret;
+	put_page(page);
+	return isolated;
 }
 
+/*
+ * __soft_offline_page handles hugetlb-pages and non-hugetlb pages.
+ * If the page is a non-dirty unmapped page-cache page, it simply invalidates.
+ */
 static int __soft_offline_page(struct page *page)
 {
-	int ret;
+	int ret = 0;
 	unsigned long pfn = page_to_pfn(page);
+	struct page *hpage = compound_head(page);
+	const char *msg_page[] = {"page", "hugepage"};
+	bool huge = PageHuge(page);
+	LIST_HEAD(pagelist);
 
 	/*
 	 * Check PageHWPoison again inside page lock because PageHWPoison
@@ -1787,88 +1775,63 @@ static int __soft_offline_page(struct pa
 	 * so there's no race between soft_offline_page() and memory_failure().
 	 */
 	lock_page(page);
-	wait_on_page_writeback(page);
+	if (!PageHuge(page))
+		wait_on_page_writeback(page);
 	if (PageHWPoison(page)) {
 		unlock_page(page);
 		put_page(page);
 		pr_info("soft offline: %#lx page already poisoned\n", pfn);
 		return -EBUSY;
 	}
-	/*
-	 * Try to invalidate first. This should work for
-	 * non dirty unmapped page cache pages.
-	 */
-	ret = invalidate_inode_page(page);
+
+	if (!PageHuge(page))
+		/*
+		 * Try to invalidate first. This should work for
+		 * non dirty unmapped page cache pages.
+		 */
+		ret = invalidate_inode_page(page);
 	unlock_page(page);
+
 	/*
 	 * RED-PEN would be better to keep it isolated here, but we
 	 * would need to fix isolation locking first.
 	 */
 	if (ret == 1) {
 		pr_info("soft_offline: %#lx: invalidated\n", pfn);
-		page_handle_poison(page, true, true, false);
+		page_handle_poison(page, false, true, false);
 		return 0;
 	}
 
-	/*
-	 * Simple invalidation didn't work.
-	 * Try to migrate to a new page instead. migrate.c
-	 * handles a large number of cases for us.
-	 */
-	if (PageLRU(page))
-		ret = isolate_lru_page(page);
-	else
-		ret = isolate_movable_page(page, ISOLATE_UNEVICTABLE);
-	/*
-	 * Drop page reference which is came from get_any_page()
-	 * successful isolate_lru_page() already took another one.
-	 */
-	put_page(page);
-	if (!ret) {
-		LIST_HEAD(pagelist);
-		/*
-		 * After isolated lru page, the PageLRU will be cleared,
-		 * so use !__PageMovable instead for LRU page's mapping
-		 * cannot have PAGE_MAPPING_MOVABLE.
-		 */
-		if (!__PageMovable(page))
-			inc_node_page_state(page, NR_ISOLATED_ANON +
-						page_is_file_lru(page));
-		list_add(&page->lru, &pagelist);
-		ret = migrate_pages(&pagelist, new_page, NULL, MPOL_MF_MOVE_ALL,
+	if (isolate_page(hpage, &pagelist)) {
+	ret = migrate_pages(&pagelist, new_page, NULL, MPOL_MF_MOVE_ALL,
 					MIGRATE_SYNC, MR_MEMORY_FAILURE);
 		if (!ret) {
-			page_handle_poison(page, true, true, false);
+			page_handle_poison(page, true, true, huge);
 		} else {
 			if (!list_empty(&pagelist))
 				putback_movable_pages(&pagelist);
 
-			pr_info("soft offline: %#lx: migration failed %d, type %lx (%pGp)\n",
-				pfn, ret, page->flags, &page->flags);
+			pr_info("soft offline: %#lx: %s migration failed %d, type %lx (%pGp)\n",
+				 pfn, msg_page[huge], ret, page->flags, &page->flags);
 			if (ret > 0)
 				ret = -EIO;
 		}
 	} else {
-		pr_info("soft offline: %#lx: isolation failed: %d, page count %d, type %lx (%pGp)\n",
-			pfn, ret, page_count(page), page->flags, &page->flags);
+		pr_info("soft offline: %#lx: %s isolation failed: %d, page count %d, type %lx (%pGp)\n",
+			 pfn, msg_page[huge], ret, page_count(page), page->flags, &page->flags);
 	}
 	return ret;
 }
 
 static int soft_offline_in_use_page(struct page *page)
 {
-	int ret;
 	struct page *hpage = compound_head(page);
 
 	if (!PageHuge(page) && PageTransHuge(hpage))
 		if (try_to_split_thp_page(page, "soft offline") < 0)
 			return -EBUSY;
 
-	if (PageHuge(page))
-		ret = soft_offline_huge_page(page);
-	else
-		ret = __soft_offline_page(page);
-	return ret;
+	return __soft_offline_page(page);
 }
 
 static int soft_offline_free_page(struct page *page)
_

Patches currently in -mm which might be from osalvador@suse.de are

mmmadvise-refactor-madvise_inject_error.patch
mmhwpoison-un-export-get_hwpoison_page-and-make-it-static.patch
mmhwpoison-kill-put_hwpoison_page.patch
mmhwpoison-unify-thp-handling-for-hard-and-soft-offline.patch
mmhwpoison-rework-soft-offline-for-free-pages.patch
mmhwpoison-rework-soft-offline-for-in-use-pages.patch
mmhwpoison-refactor-soft_offline_huge_page-and-__soft_offline_page.patch
mmhwpoison-return-0-if-the-page-is-already-poisoned-in-soft-offline.patch
mmhwpoison-introduce-mf_msg_unsplit_thp.patch

