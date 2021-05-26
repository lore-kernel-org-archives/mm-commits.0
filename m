Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D774CC47088
	for <mm-commits@archiver.kernel.org>; Wed, 26 May 2021 20:28:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B8A32613DC
	for <mm-commits@archiver.kernel.org>; Wed, 26 May 2021 20:28:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232626AbhEZUaS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 26 May 2021 16:30:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:47874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232201AbhEZUaR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 26 May 2021 16:30:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 027F6613DC;
        Wed, 26 May 2021 20:28:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1622060925;
        bh=7xYjTjT1GOnIludr4mB/BFKr3mv/Q0I3ojmtw4jS82Y=;
        h=Date:From:To:Subject:From;
        b=t2b0ON3wtEmgUCcYDabdhX/iWsWiOTOXkAJ5dciLsQDID7A017BT3hpzV+1OR8nRT
         dYIcbVlW9siqm8+DEykCJZrzIifKIKP6nDDOEDch+eGdg29GdUPeW9F0R4czr0vlIZ
         lPk4kx1zz5vzReB5bfzQj/NWtlNYS3Se7u72ikAs=
Date:   Wed, 26 May 2021 13:28:44 -0700
From:   akpm@linux-foundation.org
To:     hughd@google.com, mm-commits@vger.kernel.org, shy828301@gmail.com
Subject:  + mm-rmap-make-try_to_unmap-void-function.patch added to
 -mm tree
Message-ID: <20210526202844.-Ou8Nr5zS%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: rmap: make try_to_unmap() void function
has been added to the -mm tree.  Its filename is
     mm-rmap-make-try_to_unmap-void-function.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-rmap-make-try_to_unmap-void-function.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-rmap-make-try_to_unmap-void-function.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Suggested-by: Hugh Dickins <hughd@google.com>
Acked-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Yang Shi <shy828301@gmail.com>
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
@@ -1660,9 +1660,10 @@ static int page_not_mapped(struct page *
  * page and the compound page it belongs to, used in the pageout path.
  * Caller must hold the page lock.
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
@@ -1948,8 +1949,6 @@ bool try_to_migrate(struct page *page, e
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

mm-thp-check-total_mapcount-instead-of-page_mapcount.patch
mm-memory-add-orig_pmd-to-struct-vm_fault.patch
mm-memory-make-numa_migrate_prep-non-static.patch
mm-thp-refactor-numa-fault-handling.patch
mm-migrate-account-thp-numa-migration-counters-correctly.patch
mm-migrate-dont-split-thp-for-misplaced-numa-page.patch
mm-migrate-check-mapcount-for-thp-instead-of-refcount.patch
mm-thp-skip-make-pmd-prot_none-if-thp-migration-is-not-supported.patch
mm-rmap-make-try_to_unmap-void-function.patch

