Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAFFDC4708D
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 00:00:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229975AbiLAAAn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 19:00:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229898AbiLAAAZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 19:00:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE0A359852
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 16:00:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 678216176C
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 00:00:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B125C433C1;
        Thu,  1 Dec 2022 00:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669852823;
        bh=7OMXDvdF38JTnmOvcMtC0oKcOpp+pVTEh4CJbOjQocY=;
        h=Date:To:From:Subject:From;
        b=odawZD5iZYVwiYYhXLlOhpmfqbY3jySjeZmeLdn2G9Exlwc1mVHR7mhP2LqkqbOKd
         I95Oz+NQ0mWv0dXqsY6IiSOuFh0ne73ANQFexh8re+Gi/hAxZMNDeAM/8HungKN2QV
         WA+iQrn837pYuZAun/IRXi6G25o/k2HqJef6aeY0=
Date:   Wed, 30 Nov 2022 16:00:22 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        songmuchun@bytedance.com, minhquangbui99@gmail.com,
        mike.kravetz@oracle.com, linmiaohe@huawei.com,
        aneesh.kumar@linux.ibm.com, almasrymina@google.com,
        sidhartha.kumar@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb_cgroup-convert-__set_hugetlb_cgroup-to-folios.patch removed from -mm tree
Message-Id: <20221201000023.9B125C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/hugetlb_cgroup: convert __set_hugetlb_cgroup() to folios
has been removed from the -mm tree.  Its filename was
     mm-hugetlb_cgroup-convert-__set_hugetlb_cgroup-to-folios.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: mm/hugetlb_cgroup: convert __set_hugetlb_cgroup() to folios
Date: Tue, 1 Nov 2022 15:30:51 -0700

Patch series "convert hugetlb_cgroup helper functions to folios", v2.

This patch series continues the conversion of hugetlb code from being
managed in pages to folios by converting many of the hugetlb_cgroup helper
functions to use folios.  This allows the core hugetlb functions to pass
in a folio to these helper functions.


This patch (of 9);

Change __set_hugetlb_cgroup() to use folios so it is explicit that the
function operates on a head page.

Link: https://lkml.kernel.org/r/20221101223059.460937-1-sidhartha.kumar@oracle.com
Link: https://lkml.kernel.org/r/20221101223059.460937-2-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Bui Quang Minh <minhquangbui99@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Mina Almasry <almasrymina@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb_cgroup.h |   14 +++++++-------
 mm/hugetlb_cgroup.c            |    4 ++--
 2 files changed, 9 insertions(+), 9 deletions(-)

--- a/include/linux/hugetlb_cgroup.h~mm-hugetlb_cgroup-convert-__set_hugetlb_cgroup-to-folios
+++ a/include/linux/hugetlb_cgroup.h
@@ -90,31 +90,31 @@ hugetlb_cgroup_from_page_rsvd(struct pag
 	return __hugetlb_cgroup_from_page(page, true);
 }
 
-static inline void __set_hugetlb_cgroup(struct page *page,
+static inline void __set_hugetlb_cgroup(struct folio *folio,
 				       struct hugetlb_cgroup *h_cg, bool rsvd)
 {
-	VM_BUG_ON_PAGE(!PageHuge(page), page);
+	VM_BUG_ON_FOLIO(!folio_test_hugetlb(folio), folio);
 
-	if (compound_order(page) < HUGETLB_CGROUP_MIN_ORDER)
+	if (folio_order(folio) < HUGETLB_CGROUP_MIN_ORDER)
 		return;
 	if (rsvd)
-		set_page_private(page + SUBPAGE_INDEX_CGROUP_RSVD,
+		set_page_private(folio_page(folio, SUBPAGE_INDEX_CGROUP_RSVD),
 				 (unsigned long)h_cg);
 	else
-		set_page_private(page + SUBPAGE_INDEX_CGROUP,
+		set_page_private(folio_page(folio, SUBPAGE_INDEX_CGROUP),
 				 (unsigned long)h_cg);
 }
 
 static inline void set_hugetlb_cgroup(struct page *page,
 				     struct hugetlb_cgroup *h_cg)
 {
-	__set_hugetlb_cgroup(page, h_cg, false);
+	__set_hugetlb_cgroup(page_folio(page), h_cg, false);
 }
 
 static inline void set_hugetlb_cgroup_rsvd(struct page *page,
 					  struct hugetlb_cgroup *h_cg)
 {
-	__set_hugetlb_cgroup(page, h_cg, true);
+	__set_hugetlb_cgroup(page_folio(page), h_cg, true);
 }
 
 static inline bool hugetlb_cgroup_disabled(void)
--- a/mm/hugetlb_cgroup.c~mm-hugetlb_cgroup-convert-__set_hugetlb_cgroup-to-folios
+++ a/mm/hugetlb_cgroup.c
@@ -314,7 +314,7 @@ static void __hugetlb_cgroup_commit_char
 	if (hugetlb_cgroup_disabled() || !h_cg)
 		return;
 
-	__set_hugetlb_cgroup(page, h_cg, rsvd);
+	__set_hugetlb_cgroup(page_folio(page), h_cg, rsvd);
 	if (!rsvd) {
 		unsigned long usage =
 			h_cg->nodeinfo[page_to_nid(page)]->usage[idx];
@@ -356,7 +356,7 @@ static void __hugetlb_cgroup_uncharge_pa
 	h_cg = __hugetlb_cgroup_from_page(page, rsvd);
 	if (unlikely(!h_cg))
 		return;
-	__set_hugetlb_cgroup(page, NULL, rsvd);
+	__set_hugetlb_cgroup(page_folio(page), NULL, rsvd);
 
 	page_counter_uncharge(__hugetlb_cgroup_counter_from_cgroup(h_cg, idx,
 								   rsvd),
_

Patches currently in -mm which might be from sidhartha.kumar@oracle.com are

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

