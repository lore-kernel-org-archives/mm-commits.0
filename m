Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0689C43217
	for <mm-commits@archiver.kernel.org>; Thu, 17 Nov 2022 21:25:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240600AbiKQVZn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 17 Nov 2022 16:25:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240838AbiKQVZW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 17 Nov 2022 16:25:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E0AA248C3
        for <mm-commits@vger.kernel.org>; Thu, 17 Nov 2022 13:24:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 529D8B82189
        for <mm-commits@vger.kernel.org>; Thu, 17 Nov 2022 21:23:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10E28C433C1;
        Thu, 17 Nov 2022 21:23:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668720238;
        bh=35efRuBYp3lSZ8XwhGX2+hXUmt9eJhmI8Hq2++Vex2M=;
        h=Date:To:From:Subject:From;
        b=b6qfJgIYv+ioG8NoTAhmG+5z6qeVtjUewPghLcfRFX9LQVXLxzYvhyqx2NOwjrG/F
         Fpexj1POur6g7IAQlwEFuloz8QqL3Vopgs7SnJY0BtNyqoExvYBSy7TDfjOFCbuFlh
         9dHwF1EWTMW6OHc8LagkWnHY+oHxrzo4uA1rVrtE=
Date:   Thu, 17 Nov 2022 13:23:57 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        songmuchun@bytedance.com, mike.kravetz@oracle.com,
        linmiaohe@huawei.com, hughd@google.com, almasrymina@google.com,
        sidhartha.kumar@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-convert-enqueue_huge_page-to-folios.patch added to mm-unstable branch
Message-Id: <20221117212358.10E28C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: convert enqueue_huge_page() to folios
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-convert-enqueue_huge_page-to-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-convert-enqueue_huge_page-to-folios.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: mm/hugetlb: convert enqueue_huge_page() to folios
Date: Thu, 17 Nov 2022 13:14:58 -0800

Convert callers of enqueue_huge_page() to pass in a folio, function is
renamed to enqueue_hugetlb_folio().

Link: https://lkml.kernel.org/r/20221117211501.17150-8-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-convert-enqueue_huge_page-to-folios
+++ a/mm/hugetlb.c
@@ -1127,17 +1127,17 @@ static bool vma_has_reserves(struct vm_a
 	return false;
 }
 
-static void enqueue_huge_page(struct hstate *h, struct page *page)
+static void enqueue_hugetlb_folio(struct hstate *h, struct folio *folio)
 {
-	int nid = page_to_nid(page);
+	int nid = folio_nid(folio);
 
 	lockdep_assert_held(&hugetlb_lock);
-	VM_BUG_ON_PAGE(page_count(page), page);
+	VM_BUG_ON_FOLIO(folio_ref_count(folio), folio);
 
-	list_move(&page->lru, &h->hugepage_freelists[nid]);
+	list_move(&folio->lru, &h->hugepage_freelists[nid]);
 	h->free_huge_pages++;
 	h->free_huge_pages_node[nid]++;
-	SetHPageFreed(page);
+	folio_set_hugetlb_freed(folio);
 }
 
 static struct page *dequeue_huge_page_node_exact(struct hstate *h, int nid)
@@ -1549,7 +1549,7 @@ static void add_hugetlb_folio(struct hst
 		return;
 
 	arch_clear_hugepage_flags(&folio->page);
-	enqueue_huge_page(h, &folio->page);
+	enqueue_hugetlb_folio(h, folio);
 }
 
 static void __update_and_free_page(struct hstate *h, struct page *page)
@@ -1761,7 +1761,7 @@ void free_huge_page(struct page *page)
 		update_and_free_hugetlb_folio(h, folio, true);
 	} else {
 		arch_clear_hugepage_flags(page);
-		enqueue_huge_page(h, page);
+		enqueue_hugetlb_folio(h, folio);
 		spin_unlock_irqrestore(&hugetlb_lock, flags);
 	}
 }
@@ -2436,7 +2436,7 @@ retry:
 		if ((--needed) < 0)
 			break;
 		/* Add the page to the hugetlb allocator */
-		enqueue_huge_page(h, page);
+		enqueue_hugetlb_folio(h, page_folio(page));
 	}
 free:
 	spin_unlock_irq(&hugetlb_lock);
@@ -2802,8 +2802,8 @@ retry:
 		 * Ok, old_page is still a genuine free hugepage. Remove it from
 		 * the freelist and decrease the counters. These will be
 		 * incremented again when calling __prep_account_new_huge_page()
-		 * and enqueue_huge_page() for new_page. The counters will remain
-		 * stable since this happens under the lock.
+		 * and enqueue_hugetlb_folio() for new_folio. The counters will
+		 * remain stable since this happens under the lock.
 		 */
 		remove_hugetlb_folio(h, old_folio, false);
 
@@ -2812,7 +2812,7 @@ retry:
 		 * earlier.  It can be directly added to the pool free list.
 		 */
 		__prep_account_new_huge_page(h, nid);
-		enqueue_huge_page(h, new_page);
+		enqueue_hugetlb_folio(h, new_folio);
 
 		/*
 		 * Pages have been replaced, we can safely free the old one.
_

Patches currently in -mm which might be from sidhartha.kumar@oracle.com are

mm-hugetlb_cgroup-convert-__set_hugetlb_cgroup-to-folios.patch
mm-hugetlb_cgroup-convert-hugetlb_cgroup_from_page-to-folios.patch
mm-hugetlb_cgroup-convert-set_hugetlb_cgroup-to-folios.patch
mm-hugetlb_cgroup-convert-hugetlb_cgroup_migrate-to-folios.patch
mm-hugetlb-convert-isolate_or_dissolve_huge_page-to-folios.patch
mm-hugetlb-convert-free_huge_page-to-folios.patch
mm-hugetlb_cgroup-convert-hugetlb_cgroup_uncharge_page-to-folios.patch
mm-hugeltb_cgroup-convert-hugetlb_cgroup_commit_charge-to-folios.patch
mm-hugetlb-convert-move_hugetlb_state-to-folios.patch
mm-add-folio-dtor-and-order-setter-functions.patch
mm-hugetlb-convert-destroy_compound_gigantic_page-to-folios.patch
mm-hugetlb-convert-dissolve_free_huge_page-to-folios.patch
mm-hugetlb-convert-remove_hugetlb_page-to-folios.patch
mm-hugetlb-convert-update_and_free_page-to-folios.patch
mm-hugetlb-convert-add_hugetlb_page-to-folios-and-add-hugetlb_cma_folio.patch
mm-hugetlb-convert-enqueue_huge_page-to-folios.patch
mm-hugetlb-convert-free_gigantic_page-to-folios.patch
mm-hugetlb-convert-hugetlb-prep-functions-to-folios.patch
mm-hugetlb-change-hugetlb-allocation-functions-to-return-a-folio.patch

