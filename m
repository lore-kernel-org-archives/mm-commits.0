Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C4A8C4332F
	for <mm-commits@archiver.kernel.org>; Mon, 17 Oct 2022 00:43:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229972AbiJQAnp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 16 Oct 2022 20:43:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229979AbiJQAnm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 16 Oct 2022 20:43:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50F1C3686B
        for <mm-commits@vger.kernel.org>; Sun, 16 Oct 2022 17:43:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E1CC360C35
        for <mm-commits@vger.kernel.org>; Mon, 17 Oct 2022 00:43:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44011C433D6;
        Mon, 17 Oct 2022 00:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1665967420;
        bh=RIKkPYOeVVPi+o8LOmZU1ubz/wPeg0sAI6oN2kf9wgg=;
        h=Date:To:From:Subject:From;
        b=b6G2yIy3cE4VfXUenX71jQVVhlcyJiZZG1ON0c/VJ8AOG62cwdhj0R0RjQx3YG91b
         pFPK53Nr+NTC3MMpn9FBw8Qp/9SNzDR0tgfF52w1Ttc7Xn2xJ9XOSVeAf6qEVXCkCa
         Gx1mz4e7iD/M7ADW6NDtrkqHQGTYMe3eTEHmTCn8=
Date:   Sun, 16 Oct 2022 17:43:39 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        songmuchun@bytedance.com, minhquangbui99@gmail.com,
        mike.kravetz@oracle.com, linmiaohe@huawei.com,
        aneesh.kumar@linux.ibm.com, almasrymina@google.com,
        sidhartha.kumar@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb_cgroup-convert-set_hugetlb_cgroup-to-folios.patch added to mm-unstable branch
Message-Id: <20221017004340.44011C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb_cgroup: convert set_hugetlb_cgroup*() to folios
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb_cgroup-convert-set_hugetlb_cgroup-to-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb_cgroup-convert-set_hugetlb_cgroup-to-folios.patch

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
Subject: mm/hugetlb_cgroup: convert set_hugetlb_cgroup*() to folios
Date: Thu, 13 Oct 2022 20:12:57 -0700

Allows __prep_new_huge_page() to operate on a folio by converting
set_hugetlb_cgroup*() to take in a folio.

Link: https://lkml.kernel.org/r/20221014031303.231740-4-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Bui Quang Minh <minhquangbui99@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb_cgroup.h |   12 +++++------
 mm/hugetlb.c                   |   33 +++++++++++++++++--------------
 mm/hugetlb_cgroup.c            |   11 +++++-----
 3 files changed, 31 insertions(+), 25 deletions(-)

--- a/include/linux/hugetlb_cgroup.h~mm-hugetlb_cgroup-convert-set_hugetlb_cgroup-to-folios
+++ a/include/linux/hugetlb_cgroup.h
@@ -112,16 +112,16 @@ static inline void __set_hugetlb_cgroup(
 				 (unsigned long)h_cg);
 }
 
-static inline void set_hugetlb_cgroup(struct page *page,
+static inline void set_hugetlb_cgroup(struct folio *folio,
 				     struct hugetlb_cgroup *h_cg)
 {
-	__set_hugetlb_cgroup(page_folio(page), h_cg, false);
+	__set_hugetlb_cgroup(folio, h_cg, false);
 }
 
-static inline void set_hugetlb_cgroup_rsvd(struct page *page,
+static inline void set_hugetlb_cgroup_rsvd(struct folio *folio,
 					  struct hugetlb_cgroup *h_cg)
 {
-	__set_hugetlb_cgroup(page_folio(page), h_cg, true);
+	__set_hugetlb_cgroup(folio, h_cg, true);
 }
 
 static inline bool hugetlb_cgroup_disabled(void)
@@ -199,12 +199,12 @@ hugetlb_cgroup_from_folio_rsvd(struct fo
 	return NULL;
 }
 
-static inline void set_hugetlb_cgroup(struct page *page,
+static inline void set_hugetlb_cgroup(struct folio *folio,
 				     struct hugetlb_cgroup *h_cg)
 {
 }
 
-static inline void set_hugetlb_cgroup_rsvd(struct page *page,
+static inline void set_hugetlb_cgroup_rsvd(struct folio *folio,
 					  struct hugetlb_cgroup *h_cg)
 {
 }
--- a/mm/hugetlb.c~mm-hugetlb_cgroup-convert-set_hugetlb_cgroup-to-folios
+++ a/mm/hugetlb.c
@@ -1766,19 +1766,21 @@ static void __prep_account_new_huge_page
 	h->nr_huge_pages_node[nid]++;
 }
 
-static void __prep_new_huge_page(struct hstate *h, struct page *page)
+static void __prep_new_hugetlb_folio(struct hstate *h, struct folio *folio)
 {
-	hugetlb_vmemmap_optimize(h, page);
-	INIT_LIST_HEAD(&page->lru);
-	set_compound_page_dtor(page, HUGETLB_PAGE_DTOR);
-	hugetlb_set_page_subpool(page, NULL);
-	set_hugetlb_cgroup(page, NULL);
-	set_hugetlb_cgroup_rsvd(page, NULL);
+	hugetlb_vmemmap_optimize(h, &folio->page);
+	INIT_LIST_HEAD(&folio->lru);
+	folio->_folio_dtor = HUGETLB_PAGE_DTOR;
+	hugetlb_set_folio_subpool(folio, NULL);
+	set_hugetlb_cgroup(folio, NULL);
+	set_hugetlb_cgroup_rsvd(folio, NULL);
 }
 
 static void prep_new_huge_page(struct hstate *h, struct page *page, int nid)
 {
-	__prep_new_huge_page(h, page);
+	struct folio *folio = page_folio(page);
+
+	__prep_new_hugetlb_folio(h, folio);
 	spin_lock_irq(&hugetlb_lock);
 	__prep_account_new_huge_page(h, nid);
 	spin_unlock_irq(&hugetlb_lock);
@@ -2738,8 +2740,10 @@ static int alloc_and_dissolve_huge_page(
 					struct list_head *list)
 {
 	gfp_t gfp_mask = htlb_alloc_mask(h) | __GFP_THISNODE;
-	int nid = page_to_nid(old_page);
+	struct folio *old_folio = page_folio(old_page);
+	int nid = folio_nid(old_folio);
 	struct page *new_page;
+	struct folio *new_folio;
 	int ret = 0;
 
 	/*
@@ -2752,16 +2756,17 @@ static int alloc_and_dissolve_huge_page(
 	new_page = alloc_buddy_huge_page(h, gfp_mask, nid, NULL, NULL);
 	if (!new_page)
 		return -ENOMEM;
-	__prep_new_huge_page(h, new_page);
+	new_folio = page_folio(new_page);
+	__prep_new_hugetlb_folio(h, new_folio);
 
 retry:
 	spin_lock_irq(&hugetlb_lock);
-	if (!PageHuge(old_page)) {
+	if (!folio_test_hugetlb(old_folio)) {
 		/*
 		 * Freed from under us. Drop new_page too.
 		 */
 		goto free_new;
-	} else if (page_count(old_page)) {
+	} else if (folio_ref_count(old_folio)) {
 		/*
 		 * Someone has grabbed the page, try to isolate it here.
 		 * Fail with -EBUSY if not possible.
@@ -2770,7 +2775,7 @@ retry:
 		ret = isolate_hugetlb(old_page, list);
 		spin_lock_irq(&hugetlb_lock);
 		goto free_new;
-	} else if (!HPageFreed(old_page)) {
+	} else if (!folio_test_hugetlb(old_folio)) {
 		/*
 		 * Page's refcount is 0 but it has not been enqueued in the
 		 * freelist yet. Race window is small, so we can succeed here if
@@ -2808,7 +2813,7 @@ retry:
 free_new:
 	spin_unlock_irq(&hugetlb_lock);
 	/* Page has a zero ref count, but needs a ref to be freed */
-	set_page_refcounted(new_page);
+	folio_ref_unfreeze(new_folio, 1);
 	update_and_free_page(h, new_page, false);
 
 	return ret;
--- a/mm/hugetlb_cgroup.c~mm-hugetlb_cgroup-convert-set_hugetlb_cgroup-to-folios
+++ a/mm/hugetlb_cgroup.c
@@ -212,7 +212,7 @@ static void hugetlb_cgroup_move_parent(i
 	/* Take the pages off the local counter */
 	page_counter_cancel(counter, nr_pages);
 
-	set_hugetlb_cgroup(page, parent);
+	set_hugetlb_cgroup(folio, parent);
 out:
 	return;
 }
@@ -891,6 +891,7 @@ void hugetlb_cgroup_migrate(struct page
 	struct hugetlb_cgroup *h_cg_rsvd;
 	struct hstate *h = page_hstate(oldhpage);
 	struct folio *old_folio = page_folio(oldhpage);
+	struct folio *new_folio = page_folio(newhpage);
 
 	if (hugetlb_cgroup_disabled())
 		return;
@@ -898,12 +899,12 @@ void hugetlb_cgroup_migrate(struct page
 	spin_lock_irq(&hugetlb_lock);
 	h_cg = hugetlb_cgroup_from_folio(old_folio);
 	h_cg_rsvd = hugetlb_cgroup_from_folio_rsvd(old_folio);
-	set_hugetlb_cgroup(oldhpage, NULL);
-	set_hugetlb_cgroup_rsvd(oldhpage, NULL);
+	set_hugetlb_cgroup(old_folio, NULL);
+	set_hugetlb_cgroup_rsvd(old_folio, NULL);
 
 	/* move the h_cg details to new cgroup */
-	set_hugetlb_cgroup(newhpage, h_cg);
-	set_hugetlb_cgroup_rsvd(newhpage, h_cg_rsvd);
+	set_hugetlb_cgroup(new_folio, h_cg);
+	set_hugetlb_cgroup_rsvd(new_folio, h_cg_rsvd);
 	list_move(&newhpage->lru, &h->hugepage_activelist);
 	spin_unlock_irq(&hugetlb_lock);
 	return;
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

