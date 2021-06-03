Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0F56C47082
	for <mm-commits@archiver.kernel.org>; Thu,  3 Jun 2021 22:54:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C7C161407
	for <mm-commits@archiver.kernel.org>; Thu,  3 Jun 2021 22:54:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229697AbhFCWzt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 3 Jun 2021 18:55:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:51398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229610AbhFCWzs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 3 Jun 2021 18:55:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 83BE06140A;
        Thu,  3 Jun 2021 22:54:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1622760843;
        bh=Lk4YCOiC//knP1hQliat0ec/2nXEiO1vs+xiC4wmEEk=;
        h=Date:From:To:Subject:From;
        b=TmAhPbxP03ODLImL6UE3r4gfJwAHm7Ks4kUy5lZ9kuGqLqNUvb9gXYGnrIWv093Lb
         CGZHyS5mCAhGYItYCxAahCBsl7qz3UlbMzOcUr3cc+DnAJyK4ejfBUJMm2ZMnDN6Lu
         5wz4rNxR+3mohL9834BcKxj4zuKbE0OTPSLwg6xw=
Date:   Thu, 03 Jun 2021 15:54:03 -0700
From:   akpm@linux-foundation.org
To:     hughd@google.com, minchan@kernel.org, mm-commits@vger.kernel.org,
        shakeelb@google.com, shy828301@gmail.com
Subject:  [obsolete] mm-rmap-make-try_to_unmap-void-function.patch
 removed from -mm tree
Message-ID: <20210603225403.Ks48FGEwP%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: rmap: make try_to_unmap() void function
has been removed from the -mm tree.  Its filename was
     mm-rmap-make-try_to_unmap-void-function.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Yang Shi <shy828301@gmail.com>
Subject: mm: rmap: make try_to_unmap() void function

Currently try_to_unmap() return bool value by checking page_mapcount(),
however this may return false positive since page_mapcount() doesn't
check all subpages of compound page.  The total_mapcount() could be used
instead, but its cost is higher since it traverses all subpages.

Actually the most callers of try_to_unmap() don't care about the
return value at all.  So just need check if page is still mapped by
page_mapped() when necessary.  And page_mapped() does bail out early
when it finds mapped subpage.

Link: https://lkml.kernel.org/r/20210526201239.3351-2-shy828301@gmail.com
Signed-off-by: Yang Shi <shy828301@gmail.com>
Suggested-by: Hugh Dickins <hughd@google.com>
Acked-by: Hugh Dickins <hughd@google.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h |    2 +-
 mm/memory-failure.c  |   15 +++++++--------
 mm/rmap.c            |    7 +++----
 mm/vmscan.c          |    3 ++-
 4 files changed, 13 insertions(+), 14 deletions(-)

--- a/include/linux/rmap.h~mm-rmap-make-try_to_unmap-void-function
+++ a/include/linux/rmap.h
@@ -191,7 +191,7 @@ int page_referenced(struct page *, int i
 			struct mem_cgroup *memcg, unsigned long *vm_flags);
 
 bool try_to_migrate(struct page *page, enum ttu_flags flags);
-bool try_to_unmap(struct page *, enum ttu_flags flags);
+void try_to_unmap(struct page *, enum ttu_flags flags);
 
 int make_device_exclusive_range(struct mm_struct *mm, unsigned long start,
 				unsigned long end, struct page **pages,
--- a/mm/memory-failure.c~mm-rmap-make-try_to_unmap-void-function
+++ a/mm/memory-failure.c
@@ -1206,7 +1206,7 @@ static bool hwpoison_user_mappings(struc
 	enum ttu_flags ttu = TTU_IGNORE_MLOCK;
 	struct address_space *mapping;
 	LIST_HEAD(tokill);
-	bool unmap_success = true;
+	bool unmap_success;
 	int kill = 1, forcekill;
 	struct page *hpage = *hpagep;
 	bool mlocked = PageMlocked(hpage);
@@ -1269,7 +1269,7 @@ static bool hwpoison_user_mappings(struc
 		collect_procs(hpage, &tokill, flags & MF_ACTION_REQUIRED);
 
 	if (!PageHuge(hpage)) {
-		unmap_success = try_to_unmap(hpage, ttu);
+		try_to_unmap(hpage, ttu);
 	} else {
 		if (!PageAnon(hpage)) {
 			/*
@@ -1281,17 +1281,16 @@ static bool hwpoison_user_mappings(struc
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
@@ -1658,9 +1658,10 @@ static int page_not_mapped(struct page *
  * Tries to remove all the page table entries which are mapping this
  * page, used in the pageout path.  Caller must hold the page lock.
  *
- * If unmap is successful, return true. Otherwise, false.
+ * It is the callers' responsibility to check if the page is still
+ * mapped when needed.
  */
-bool try_to_unmap(struct page *page, enum ttu_flags flags)
+void try_to_unmap(struct page *page, enum ttu_flags flags)
 {
 	struct rmap_walk_control rwc = {
 		.rmap_one = try_to_unmap_one,
@@ -1946,8 +1947,6 @@ bool try_to_migrate(struct page *page, e
 		rmap_walk_locked(page, &rwc);
 	else
 		rmap_walk(page, &rwc);
-
-	return !page_mapcount(page) ? true : false;
 }
 
 /*
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

Patches currently in -mm which might be from shy828301@gmail.com are

mm-memory-add-orig_pmd-to-struct-vm_fault.patch
mm-memory-make-numa_migrate_prep-non-static.patch
mm-thp-refactor-numa-fault-handling.patch
mm-migrate-account-thp-numa-migration-counters-correctly.patch
mm-migrate-dont-split-thp-for-misplaced-numa-page.patch
mm-migrate-check-mapcount-for-thp-instead-of-refcount.patch
mm-thp-skip-make-pmd-prot_none-if-thp-migration-is-not-supported.patch

