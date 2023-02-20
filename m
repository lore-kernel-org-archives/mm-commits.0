Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86F05C64ED9
	for <mm-commits@archiver.kernel.org>; Mon, 20 Feb 2023 20:47:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231951AbjBTUrI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 20 Feb 2023 15:47:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231993AbjBTUrG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 20 Feb 2023 15:47:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEAF9172D
        for <mm-commits@vger.kernel.org>; Mon, 20 Feb 2023 12:47:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 78DB4B80DCC
        for <mm-commits@vger.kernel.org>; Mon, 20 Feb 2023 20:47:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C173C433EF;
        Mon, 20 Feb 2023 20:47:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1676926021;
        bh=1UdWzrlv4kXghZdYnNMLsLbBwVQOVc9jzGiyafCT8Fc=;
        h=Date:To:From:Subject:From;
        b=rqUhe0gm1Tcb5IfGc1lA3dEH4ivC4DrjmyHCCt2qiSlzdzQxdogg8jPB+gIfkqr9A
         J3S90IHo9Sl+EUivGo83voVUKNxQDzmVSZb6hZsUVXXzHkxxOI4xmpU+yyhbcz15fD
         sPpI8Kb4jwYpGYZPUj2AEtuLr/D9BvidqRVZNR2o=
Date:   Mon, 20 Feb 2023 12:47:00 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        torvalds@linux-foundation.org, sj@kernel.org,
        mike.kravetz@oracle.com, david@redhat.com,
        baolin.wang@linux.alibaba.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-change-to-return-bool-for-isolate_hugetlb.patch removed from -mm tree
Message-Id: <20230220204701.2C173C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: hugetlb: change to return bool for isolate_hugetlb()
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-change-to-return-bool-for-isolate_hugetlb.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: hugetlb: change to return bool for isolate_hugetlb()
Date: Wed, 15 Feb 2023 18:39:36 +0800

Now the isolate_hugetlb() only returns 0 or -EBUSY, and most users did not
care about the negative value, thus we can convert the isolate_hugetlb()
to return a boolean value to make code more clear when checking the
hugetlb isolation state.  Moreover converts 2 users which will consider
the negative value returned by isolate_hugetlb().

No functional changes intended.

[akpm@linux-foundation.org: shorten locked section, per SeongJae Park]
Link: https://lkml.kernel.org/r/12a287c5bebc13df304387087bbecc6421510849.1676424378.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/include/linux/hugetlb.h~mm-hugetlb-change-to-return-bool-for-isolate_hugetlb
+++ a/include/linux/hugetlb.h
@@ -171,7 +171,7 @@ bool hugetlb_reserve_pages(struct inode
 						vm_flags_t vm_flags);
 long hugetlb_unreserve_pages(struct inode *inode, long start, long end,
 						long freed);
-int isolate_hugetlb(struct folio *folio, struct list_head *list);
+bool isolate_hugetlb(struct folio *folio, struct list_head *list);
 int get_hwpoison_hugetlb_folio(struct folio *folio, bool *hugetlb, bool unpoison);
 int get_huge_page_for_hwpoison(unsigned long pfn, int flags,
 				bool *migratable_cleared);
@@ -413,9 +413,9 @@ static inline pte_t *huge_pte_offset(str
 	return NULL;
 }
 
-static inline int isolate_hugetlb(struct folio *folio, struct list_head *list)
+static inline bool isolate_hugetlb(struct folio *folio, struct list_head *list)
 {
-	return -EBUSY;
+	return false;
 }
 
 static inline int get_hwpoison_hugetlb_folio(struct folio *folio, bool *hugetlb, bool unpoison)
--- a/mm/hugetlb.c~mm-hugetlb-change-to-return-bool-for-isolate_hugetlb
+++ a/mm/hugetlb.c
@@ -2925,12 +2925,15 @@ retry:
 		 */
 		goto free_new;
 	} else if (folio_ref_count(old_folio)) {
+		bool isolated;
+
 		/*
 		 * Someone has grabbed the folio, try to isolate it here.
 		 * Fail with -EBUSY if not possible.
 		 */
 		spin_unlock_irq(&hugetlb_lock);
-		ret = isolate_hugetlb(old_folio, list);
+		isolated = isolate_hugetlb(old_folio, list);
+		ret = isolated ? 0 : -EBUSY;
 		spin_lock_irq(&hugetlb_lock);
 		goto free_new;
 	} else if (!folio_test_hugetlb_freed(old_folio)) {
@@ -3005,7 +3008,7 @@ int isolate_or_dissolve_huge_page(struct
 	if (hstate_is_gigantic(h))
 		return -ENOMEM;
 
-	if (folio_ref_count(folio) && !isolate_hugetlb(folio, list))
+	if (folio_ref_count(folio) && isolate_hugetlb(folio, list))
 		ret = 0;
 	else if (!folio_ref_count(folio))
 		ret = alloc_and_dissolve_hugetlb_folio(h, folio, list);
@@ -7251,15 +7254,15 @@ __weak unsigned long hugetlb_mask_last_p
  * These functions are overwritable if your architecture needs its own
  * behavior.
  */
-int isolate_hugetlb(struct folio *folio, struct list_head *list)
+bool isolate_hugetlb(struct folio *folio, struct list_head *list)
 {
-	int ret = 0;
+	bool ret = true;
 
 	spin_lock_irq(&hugetlb_lock);
 	if (!folio_test_hugetlb(folio) ||
 	    !folio_test_hugetlb_migratable(folio) ||
 	    !folio_try_get(folio)) {
-		ret = -EBUSY;
+		ret = false;
 		goto unlock;
 	}
 	folio_clear_hugetlb_migratable(folio);
--- a/mm/memory-failure.c~mm-hugetlb-change-to-return-bool-for-isolate_hugetlb
+++ a/mm/memory-failure.c
@@ -2508,7 +2508,7 @@ static bool isolate_page(struct page *pa
 	bool isolated = false;
 
 	if (PageHuge(page)) {
-		isolated = !isolate_hugetlb(page_folio(page), pagelist);
+		isolated = isolate_hugetlb(page_folio(page), pagelist);
 	} else {
 		bool lru = !__PageMovable(page);
 
--- a/mm/mempolicy.c~mm-hugetlb-change-to-return-bool-for-isolate_hugetlb
+++ a/mm/mempolicy.c
@@ -609,7 +609,7 @@ static int queue_folios_hugetlb(pte_t *p
 	if (flags & (MPOL_MF_MOVE_ALL) ||
 	    (flags & MPOL_MF_MOVE && folio_estimated_sharers(folio) == 1 &&
 	     !hugetlb_pmd_shared(pte))) {
-		if (isolate_hugetlb(folio, qp->pagelist) &&
+		if (!isolate_hugetlb(folio, qp->pagelist) &&
 			(flags & MPOL_MF_STRICT))
 			/*
 			 * Failed to isolate folio but allow migrating pages
--- a/mm/migrate.c~mm-hugetlb-change-to-return-bool-for-isolate_hugetlb
+++ a/mm/migrate.c
@@ -2095,6 +2095,7 @@ static int add_page_for_migration(struct
 	struct vm_area_struct *vma;
 	struct page *page;
 	int err;
+	bool isolated;
 
 	mmap_read_lock(mm);
 	err = -EFAULT;
@@ -2126,13 +2127,11 @@ static int add_page_for_migration(struct
 
 	if (PageHuge(page)) {
 		if (PageHead(page)) {
-			err = isolate_hugetlb(page_folio(page), pagelist);
-			if (!err)
-				err = 1;
+			isolated = isolate_hugetlb(page_folio(page), pagelist);
+			err = isolated ? 1 : -EBUSY;
 		}
 	} else {
 		struct page *head;
-		bool isolated;
 
 		head = compound_head(page);
 		isolated = isolate_lru_page(head);
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are


