Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0065C433FE
	for <mm-commits@archiver.kernel.org>; Tue,  1 Nov 2022 22:40:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230000AbiKAWks (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 1 Nov 2022 18:40:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229741AbiKAWkr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 1 Nov 2022 18:40:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5538B630E
        for <mm-commits@vger.kernel.org>; Tue,  1 Nov 2022 15:40:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D347161742
        for <mm-commits@vger.kernel.org>; Tue,  1 Nov 2022 22:40:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36CEEC433D6;
        Tue,  1 Nov 2022 22:40:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667342445;
        bh=gAZnvS1xJh055IwAz/f4YrNdRQKrwfRGS6FSgFMR2B4=;
        h=Date:To:From:Subject:From;
        b=uWsTiKoR0P1RCLO5zI9EyAZY6TN09neWxVkefwgsaYGmo++dHjzTWD3+K6LA+F7qZ
         Ib5qFkeLlTaGv5+g7kQJycE51zqOecxcQ6FluKbA0Y5h8rFXjMHCOP7mkky7iqOWHW
         V2JhYzT2dC9Lte9ZosO+myYKadkNDGtSqnTcA2cg=
Date:   Tue, 01 Nov 2022 15:40:44 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        songmuchun@bytedance.com, minhquangbui99@gmail.com,
        mike.kravetz@oracle.com, linmiaohe@huawei.com,
        aneesh.kumar@linux.ibm.com, almasrymina@google.com,
        sidhartha.kumar@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb_cgroup-convert-__set_hugetlb_cgroup-to-folios.patch added to mm-unstable branch
Message-Id: <20221101224045.36CEEC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb_cgroup: convert __set_hugetlb_cgroup() to folios
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb_cgroup-convert-__set_hugetlb_cgroup-to-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb_cgroup-convert-__set_hugetlb_cgroup-to-folios.patch

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
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Bui Quang Minh <minhquangbui99@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Muchun Song <songmuchun@bytedance.com>
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

mm-hugetlb-add-folio-support-to-hugetlb-specific-flag-macros.patch
mm-add-private-field-of-first-tail-to-struct-page-and-struct-folio.patch
mm-hugetlb-add-hugetlb_folio_subpool-helpers.patch
hugetlbfs-convert-hugetlb_delete_from_page_cache-to-use-folios.patch
mm-hugetlb-add-folio_hstate.patch
mm-hugetlb_cgroup-convert-__set_hugetlb_cgroup-to-folios.patch
mm-hugetlb_cgroup-convert-hugetlb_cgroup_from_page-to-folios.patch
mm-hugetlb_cgroup-convert-set_hugetlb_cgroup-to-folios.patch
mm-hugetlb_cgroup-convert-hugetlb_cgroup_migrate-to-folios.patch
mm-hugetlb-convert-isolate_or_dissolve_huge_page-to-folios.patch
mm-hugetlb-convert-free_huge_page-to-folios.patch
mm-hugetlb_cgroup-convert-hugetlb_cgroup_uncharge_page-to-folios.patch
mm-hugeltb_cgroup-convert-hugetlb_cgroup_commit_charge-to-folios.patch
mm-hugetlb-convert-move_hugetlb_state-to-folios.patch

