Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0796C4332F
	for <mm-commits@archiver.kernel.org>; Mon, 17 Oct 2022 00:43:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229981AbiJQAno (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 16 Oct 2022 20:43:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229966AbiJQAnj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 16 Oct 2022 20:43:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4EFF36435
        for <mm-commits@vger.kernel.org>; Sun, 16 Oct 2022 17:43:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 933CEB80DAC
        for <mm-commits@vger.kernel.org>; Mon, 17 Oct 2022 00:43:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3907CC433D6;
        Mon, 17 Oct 2022 00:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1665967415;
        bh=qOLY9W5BOJA1/Z/vO73VlL3OFzVxgbBFo0G4LFu2RDs=;
        h=Date:To:From:Subject:From;
        b=mZc6lhozp62JzzpXj54oErUtZkxzlvODdA+IgEHIloynBdwgOgt71k+4TQdhRaYED
         JbbLFAVIn08duThZd1++7me0Ty3xDsX7Nhq3FndGW9OfCeg5AJkv75ADSp73iysPYD
         A7B7Hb58mlETv94I43/vDPUCC6EUuqymIyAjT1Ak=
Date:   Sun, 16 Oct 2022 17:43:34 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        songmuchun@bytedance.com, minhquangbui99@gmail.com,
        mike.kravetz@oracle.com, linmiaohe@huawei.com,
        aneesh.kumar@linux.ibm.com, almasrymina@google.com,
        sidhartha.kumar@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb_cgroup-convert-__set_hugetlb_cgroup-to-folios.patch added to mm-unstable branch
Message-Id: <20221017004335.3907CC433D6@smtp.kernel.org>
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
Date: Thu, 13 Oct 2022 20:12:55 -0700

Patch series "convert hugetlb_cgroup helper functions to folios:.

This patch series continues the conversion of hugetlb code from being
managed in pages to folios by converting many of the hugetlb_cgroup helper
functions to use folios.  This allows the core hugetlb functions to pass
in a folio to these helper functions.


This patch (of 9):

Change __set_hugetlb_cgroup() to use folios so it is explicit that the
function operates on a head page.

Link: https://lkml.kernel.org/r/20221014031303.231740-1-sidhartha.kumar@oracle.com
Link: https://lkml.kernel.org/r/20221014031303.231740-2-sidhartha.kumar@oracle.com
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

mm-hugetlb_cgroup-convert-__set_hugetlb_cgroup-to-folios.patch
mm-hugetlb_cgroup-convert-hugetlb_cgroup_from_page-to-folios.patch
mm-hugetlb_cgroup-convert-set_hugetlb_cgroup-to-folios.patch
mm-hugetlb_cgroup-convert-hugetlb_cgroup_migrate-to-folios.patch
mm-hugetlb-convert-isolate_or_dissolve_huge_page-to-folios.patch
mm-hugetlb-convert-free_huge_page-to-folios.patch
mm-hugetlb_cgroup-convert-hugetlb_cgroup_uncharge_page-to-folios.patch
mm-hugeltb_cgroup-convert-hugetlb_cgroup_commit_charge-to-folios.patch
mm-hugetlb-convert-move_hugetlb_state-to-folios.patch

