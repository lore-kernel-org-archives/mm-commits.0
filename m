Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 154F1C11F66
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:52:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0097361474
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:52:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238427AbhGAByd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:54:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:44050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238418AbhGAByc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:54:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9E4FB6146D;
        Thu,  1 Jul 2021 01:52:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625104322;
        bh=sSdelPm01ave48Y2ecTahcYVqBfBy+Uk6DbljjcyDcg=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=QMfJ/jrhIbIGgcwM6Jt5ykMi7HeLBOyFxXMwWjlDWn5NgrfMENHji5/Zd8/kWHyWn
         vmkca7UsJVbr+axUI75Y0yialawADmoC1oOcjzI1v621UQBPxck7NmKKJ3UbBNHVRC
         sUkb+q7aOc5DKea8o8r8ILMzJhkkfiwsHhSla3KQ=
Date:   Wed, 30 Jun 2021 18:52:01 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, apopple@nvidia.com, hughd@google.com,
        jack@suse.cz, juew@google.com, kirill.shutemov@linux.intel.com,
        linmiaohe@huawei.com, linux-mm@kvack.org, minchan@kernel.org,
        mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        osalvador@suse.de, peterx@redhat.com, rcampbell@nvidia.com,
        shakeelb@google.com, shy828301@gmail.com,
        torvalds@linux-foundation.org, wangyugui@e16-tech.com,
        willy@infradead.org, ziy@nvidia.com
Subject:  [patch 091/192] mm: rmap: make try_to_unmap() void
 function
Message-ID: <20210701015201.N4tR2xm1a%akpm@linux-foundation.org>
In-Reply-To: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Yang Shi <shy828301@gmail.com>
Subject: mm: rmap: make try_to_unmap() void function

Currently try_to_unmap() return bool value by checking page_mapcount(),
however this may return false positive since page_mapcount() doesn't check
all subpages of compound page.  The total_mapcount() could be used
instead, but its cost is higher since it traverses all subpages.

Actually the most callers of try_to_unmap() don't care about the return
value at all.  So just need check if page is still mapped by page_mapped()
when necessary.  And page_mapped() does bail out early when it finds
mapped subpage.

Link: https://lkml.kernel.org/r/bb27e3fe-6036-b637-5086-272befbfe3da@google.com
Suggested-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Yang Shi <shy828301@gmail.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jue Wang <juew@google.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Wang Yugui <wangyugui@e16-tech.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h |    2 +-
 mm/memory-failure.c  |   15 +++++++--------
 mm/rmap.c            |   15 ++++-----------
 mm/vmscan.c          |    3 ++-
 4 files changed, 14 insertions(+), 21 deletions(-)

--- a/include/linux/rmap.h~mm-rmap-make-try_to_unmap-void-function
+++ a/include/linux/rmap.h
@@ -195,7 +195,7 @@ static inline void page_dup_rmap(struct
 int page_referenced(struct page *, int is_locked,
 			struct mem_cgroup *memcg, unsigned long *vm_flags);
 
-bool try_to_unmap(struct page *, enum ttu_flags flags);
+void try_to_unmap(struct page *, enum ttu_flags flags);
 
 /* Avoid racy checks */
 #define PVMW_SYNC		(1 << 0)
--- a/mm/memory-failure.c~mm-rmap-make-try_to_unmap-void-function
+++ a/mm/memory-failure.c
@@ -1269,7 +1269,7 @@ static bool hwpoison_user_mappings(struc
 	enum ttu_flags ttu = TTU_IGNORE_MLOCK;
 	struct address_space *mapping;
 	LIST_HEAD(tokill);
-	bool unmap_success = true;
+	bool unmap_success;
 	int kill = 1, forcekill;
 	struct page *hpage = *hpagep;
 	bool mlocked = PageMlocked(hpage);
@@ -1332,7 +1332,7 @@ static bool hwpoison_user_mappings(struc
 		collect_procs(hpage, &tokill, flags & MF_ACTION_REQUIRED);
 
 	if (!PageHuge(hpage)) {
-		unmap_success = try_to_unmap(hpage, ttu);
+		try_to_unmap(hpage, ttu);
 	} else {
 		if (!PageAnon(hpage)) {
 			/*
@@ -1344,17 +1344,16 @@ static bool hwpoison_user_mappings(struc
 			 */
 			mapping = hugetlb_page_mapping_lock_write(hpage);
 			if (mapping) {
-				unmap_success = try_to_unmap(hpage,
-						     ttu|TTU_RMAP_LOCKED);
+				try_to_unmap(hpage, ttu|TTU_RMAP_LOCKED);
 				i_mmap_unlock_write(mapping);
-			} else {
+			} else
 				pr_info("Memory failure: %#lx: could not lock mapping for mapped huge page\n", pfn);
-				unmap_success = false;
-			}
 		} else {
-			unmap_success = try_to_unmap(hpage, ttu);
+			try_to_unmap(hpage, ttu);
 		}
 	}
+
+	unmap_success = !page_mapped(hpage);
 	if (!unmap_success)
 		pr_err("Memory failure: %#lx: failed to unmap page (mapcount=%d)\n",
 		       pfn, page_mapcount(hpage));
--- a/mm/rmap.c~mm-rmap-make-try_to_unmap-void-function
+++ a/mm/rmap.c
@@ -1405,7 +1405,7 @@ static bool try_to_unmap_one(struct page
 	/*
 	 * When racing against e.g. zap_pte_range() on another cpu,
 	 * in between its ptep_get_and_clear_full() and page_remove_rmap(),
-	 * try_to_unmap() may return false when it is about to become true,
+	 * try_to_unmap() may return before page_mapped() has become false,
 	 * if page table locking is skipped: use TTU_SYNC to wait for that.
 	 */
 	if (flags & TTU_SYNC)
@@ -1756,9 +1756,10 @@ static int page_not_mapped(struct page *
  * Tries to remove all the page table entries which are mapping this
  * page, used in the pageout path.  Caller must hold the page lock.
  *
- * If unmap is successful, return true. Otherwise, false.
+ * It is the caller's responsibility to check if the page is still
+ * mapped when needed (use TTU_SYNC to prevent accounting races).
  */
-bool try_to_unmap(struct page *page, enum ttu_flags flags)
+void try_to_unmap(struct page *page, enum ttu_flags flags)
 {
 	struct rmap_walk_control rwc = {
 		.rmap_one = try_to_unmap_one,
@@ -1783,14 +1784,6 @@ bool try_to_unmap(struct page *page, enu
 		rmap_walk_locked(page, &rwc);
 	else
 		rmap_walk(page, &rwc);
-
-	/*
-	 * When racing against e.g. zap_pte_range() on another cpu,
-	 * in between its ptep_get_and_clear_full() and page_remove_rmap(),
-	 * try_to_unmap() may return false when it is about to become true,
-	 * if page table locking is skipped: use TTU_SYNC to wait for that.
-	 */
-	return !page_mapcount(page);
 }
 
 /**
--- a/mm/vmscan.c~mm-rmap-make-try_to_unmap-void-function
+++ a/mm/vmscan.c
@@ -1499,7 +1499,8 @@ static unsigned int shrink_page_list(str
 			if (unlikely(PageTransHuge(page)))
 				flags |= TTU_SPLIT_HUGE_PMD;
 
-			if (!try_to_unmap(page, flags)) {
+			try_to_unmap(page, flags);
+			if (page_mapped(page)) {
 				stat->nr_unmap_fail += nr_pages;
 				if (!was_swapbacked && PageSwapBacked(page))
 					stat->nr_lazyfree_fail += nr_pages;
_
