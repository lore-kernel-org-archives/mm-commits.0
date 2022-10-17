Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C47CEC43217
	for <mm-commits@archiver.kernel.org>; Mon, 17 Oct 2022 00:44:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229979AbiJQAoI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 16 Oct 2022 20:44:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229988AbiJQAn6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 16 Oct 2022 20:43:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D6543742E
        for <mm-commits@vger.kernel.org>; Sun, 16 Oct 2022 17:43:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7C57760EB2
        for <mm-commits@vger.kernel.org>; Mon, 17 Oct 2022 00:43:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D335CC433C1;
        Mon, 17 Oct 2022 00:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1665967429;
        bh=c75se59+e1FIOXy/w/kc+Ehh0RAkquesdY+c6ZI0Nww=;
        h=Date:To:From:Subject:From;
        b=oPUG2sEdWzaH7M7Gi7G0WpkTRs29ENIDa4lZcymC5Itu72pCin7VTSJp8iX5AYrAh
         Nd5qY0lFZ6dvUBZm5+iDRTKdM70XMt90kd/0DhE6T3gnnidbGmfp4aGZN3lX4DtkzO
         DqZHX5MOU8KQ0HWGIchn5LGJuld46pIpvEpAAcaU=
Date:   Sun, 16 Oct 2022 17:43:49 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        songmuchun@bytedance.com, minhquangbui99@gmail.com,
        mike.kravetz@oracle.com, linmiaohe@huawei.com,
        aneesh.kumar@linux.ibm.com, almasrymina@google.com,
        sidhartha.kumar@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb_cgroup-convert-hugetlb_cgroup_uncharge_page-to-folios.patch added to mm-unstable branch
Message-Id: <20221017004349.D335CC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb_cgroup: convert hugetlb_cgroup_uncharge_page() to folios
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb_cgroup-convert-hugetlb_cgroup_uncharge_page-to-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb_cgroup-convert-hugetlb_cgroup_uncharge_page-to-folios.patch

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
Subject: mm/hugetlb_cgroup: convert hugetlb_cgroup_uncharge_page() to folios
Date: Thu, 13 Oct 2022 20:13:01 -0700

Continue to use a folio inside free_huge_page() by converting
hugetlb_cgroup_uncharge_page*() to folios.

Link: https://lkml.kernel.org/r/20221014031303.231740-8-sidhartha.kumar@oracle.com
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

 include/linux/hugetlb_cgroup.h |   16 ++++++++--------
 mm/hugetlb.c                   |   15 +++++++++------
 mm/hugetlb_cgroup.c            |   21 ++++++++++-----------
 3 files changed, 27 insertions(+), 25 deletions(-)

--- a/include/linux/hugetlb_cgroup.h~mm-hugetlb_cgroup-convert-hugetlb_cgroup_uncharge_page-to-folios
+++ a/include/linux/hugetlb_cgroup.h
@@ -158,10 +158,10 @@ extern void hugetlb_cgroup_commit_charge
 extern void hugetlb_cgroup_commit_charge_rsvd(int idx, unsigned long nr_pages,
 					      struct hugetlb_cgroup *h_cg,
 					      struct page *page);
-extern void hugetlb_cgroup_uncharge_page(int idx, unsigned long nr_pages,
-					 struct page *page);
-extern void hugetlb_cgroup_uncharge_page_rsvd(int idx, unsigned long nr_pages,
-					      struct page *page);
+extern void hugetlb_cgroup_uncharge_folio(int idx, unsigned long nr_pages,
+					 struct folio *folio);
+extern void hugetlb_cgroup_uncharge_folio_rsvd(int idx, unsigned long nr_pages,
+					      struct folio *folio);
 
 extern void hugetlb_cgroup_uncharge_cgroup(int idx, unsigned long nr_pages,
 					   struct hugetlb_cgroup *h_cg);
@@ -254,14 +254,14 @@ hugetlb_cgroup_commit_charge_rsvd(int id
 {
 }
 
-static inline void hugetlb_cgroup_uncharge_page(int idx, unsigned long nr_pages,
-						struct page *page)
+static inline void hugetlb_cgroup_uncharge_folio(int idx, unsigned long nr_pages,
+						struct folio *folio)
 {
 }
 
-static inline void hugetlb_cgroup_uncharge_page_rsvd(int idx,
+static inline void hugetlb_cgroup_uncharge_folio_rsvd(int idx,
 						     unsigned long nr_pages,
-						     struct page *page)
+						     struct folio *folio)
 {
 }
 static inline void hugetlb_cgroup_uncharge_cgroup(int idx,
--- a/mm/hugetlb.c~mm-hugetlb_cgroup-convert-hugetlb_cgroup_uncharge_page-to-folios
+++ a/mm/hugetlb.c
@@ -1734,10 +1734,10 @@ void free_huge_page(struct page *page)
 
 	spin_lock_irqsave(&hugetlb_lock, flags);
 	folio_clear_hugetlb_migratable(folio);
-	hugetlb_cgroup_uncharge_page(hstate_index(h),
-				     pages_per_huge_page(h), page);
-	hugetlb_cgroup_uncharge_page_rsvd(hstate_index(h),
-					  pages_per_huge_page(h), page);
+	hugetlb_cgroup_uncharge_folio(hstate_index(h),
+				     pages_per_huge_page(h), folio);
+	hugetlb_cgroup_uncharge_folio_rsvd(hstate_index(h),
+					  pages_per_huge_page(h), folio);
 	if (restore_reserve)
 		h->resv_huge_pages++;
 
@@ -2862,6 +2862,7 @@ struct page *alloc_huge_page(struct vm_a
 	struct hugepage_subpool *spool = subpool_vma(vma);
 	struct hstate *h = hstate_vma(vma);
 	struct page *page;
+	struct folio *folio;
 	long map_chg, map_commit;
 	long gbl_chg;
 	int ret, idx;
@@ -2925,6 +2926,7 @@ struct page *alloc_huge_page(struct vm_a
 	 * a reservation exists for the allocation.
 	 */
 	page = dequeue_huge_page_vma(h, vma, addr, avoid_reserve, gbl_chg);
+
 	if (!page) {
 		spin_unlock_irq(&hugetlb_lock);
 		page = alloc_buddy_huge_page_with_mpol(h, vma, addr);
@@ -2939,6 +2941,7 @@ struct page *alloc_huge_page(struct vm_a
 		set_page_refcounted(page);
 		/* Fall through */
 	}
+	folio = page_folio(page);
 	hugetlb_cgroup_commit_charge(idx, pages_per_huge_page(h), h_cg, page);
 	/* If allocation is not consuming a reservation, also store the
 	 * hugetlb_cgroup pointer on the page.
@@ -2968,8 +2971,8 @@ struct page *alloc_huge_page(struct vm_a
 		rsv_adjust = hugepage_subpool_put_pages(spool, 1);
 		hugetlb_acct_memory(h, -rsv_adjust);
 		if (deferred_reserve)
-			hugetlb_cgroup_uncharge_page_rsvd(hstate_index(h),
-					pages_per_huge_page(h), page);
+			hugetlb_cgroup_uncharge_folio_rsvd(hstate_index(h),
+					pages_per_huge_page(h), folio);
 	}
 	return page;
 
--- a/mm/hugetlb_cgroup.c~mm-hugetlb_cgroup-convert-hugetlb_cgroup_uncharge_page-to-folios
+++ a/mm/hugetlb_cgroup.c
@@ -346,11 +346,10 @@ void hugetlb_cgroup_commit_charge_rsvd(i
 /*
  * Should be called with hugetlb_lock held
  */
-static void __hugetlb_cgroup_uncharge_page(int idx, unsigned long nr_pages,
-					   struct page *page, bool rsvd)
+static void __hugetlb_cgroup_uncharge_folio(int idx, unsigned long nr_pages,
+					   struct folio *folio, bool rsvd)
 {
 	struct hugetlb_cgroup *h_cg;
-	struct folio *folio = page_folio(page);
 
 	if (hugetlb_cgroup_disabled())
 		return;
@@ -368,27 +367,27 @@ static void __hugetlb_cgroup_uncharge_pa
 		css_put(&h_cg->css);
 	else {
 		unsigned long usage =
-			h_cg->nodeinfo[page_to_nid(page)]->usage[idx];
+			h_cg->nodeinfo[folio_nid(folio)]->usage[idx];
 		/*
 		 * This write is not atomic due to fetching usage and writing
 		 * to it, but that's fine because we call this with
 		 * hugetlb_lock held anyway.
 		 */
-		WRITE_ONCE(h_cg->nodeinfo[page_to_nid(page)]->usage[idx],
+		WRITE_ONCE(h_cg->nodeinfo[folio_nid(folio)]->usage[idx],
 			   usage - nr_pages);
 	}
 }
 
-void hugetlb_cgroup_uncharge_page(int idx, unsigned long nr_pages,
-				  struct page *page)
+void hugetlb_cgroup_uncharge_folio(int idx, unsigned long nr_pages,
+				  struct folio *folio)
 {
-	__hugetlb_cgroup_uncharge_page(idx, nr_pages, page, false);
+	__hugetlb_cgroup_uncharge_folio(idx, nr_pages, folio, false);
 }
 
-void hugetlb_cgroup_uncharge_page_rsvd(int idx, unsigned long nr_pages,
-				       struct page *page)
+void hugetlb_cgroup_uncharge_folio_rsvd(int idx, unsigned long nr_pages,
+				       struct folio *folio)
 {
-	__hugetlb_cgroup_uncharge_page(idx, nr_pages, page, true);
+	__hugetlb_cgroup_uncharge_folio(idx, nr_pages, folio, true);
 }
 
 static void __hugetlb_cgroup_uncharge_cgroup(int idx, unsigned long nr_pages,
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

