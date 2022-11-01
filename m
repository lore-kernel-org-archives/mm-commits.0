Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D553C4332F
	for <mm-commits@archiver.kernel.org>; Tue,  1 Nov 2022 22:41:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230456AbiKAWlD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 1 Nov 2022 18:41:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231282AbiKAWk6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 1 Nov 2022 18:40:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 633162DDF
        for <mm-commits@vger.kernel.org>; Tue,  1 Nov 2022 15:40:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 09B8F6170B
        for <mm-commits@vger.kernel.org>; Tue,  1 Nov 2022 22:40:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 637DDC433D6;
        Tue,  1 Nov 2022 22:40:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667342456;
        bh=0zRyYJu+EGtWiNOqJush9U9S6QFA/cFQCgT6uYKlLco=;
        h=Date:To:From:Subject:From;
        b=ZJ37zHlvNlFr6IgS4bXyVu1jeYECmY/lEoG+JHXuZdqJznfOz3TT1yDnzf+HYvBHD
         VoZMnTLgMDST3ebz2Pb1W1BZDFN/ElV0gwhE0S8gKucadVG2BVslCv65HjVR9/zH8Y
         SYF/vFENvogKtTuGLHXxZqfncfBzgFm0ntDiAELM=
Date:   Tue, 01 Nov 2022 15:40:55 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        songmuchun@bytedance.com, minhquangbui99@gmail.com,
        mike.kravetz@oracle.com, linmiaohe@huawei.com,
        aneesh.kumar@linux.ibm.com, almasrymina@google.com,
        sidhartha.kumar@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-convert-free_huge_page-to-folios.patch added to mm-unstable branch
Message-Id: <20221101224056.637DDC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: convert free_huge_page to folios
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-convert-free_huge_page-to-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-convert-free_huge_page-to-folios.patch

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
Subject: mm/hugetlb: convert free_huge_page to folios
Date: Tue, 1 Nov 2022 15:30:56 -0700

Use folios inside free_huge_page(), this is in preparation for converting
hugetlb_cgroup_uncharge_page() to take in a folio.

Link: https://lkml.kernel.org/r/20221101223059.460937-7-sidhartha.kumar@oracle.com
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

 mm/hugetlb.c |   27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-convert-free_huge_page-to-folios
+++ a/mm/hugetlb.c
@@ -1704,21 +1704,22 @@ void free_huge_page(struct page *page)
 	 * Can't pass hstate in here because it is called from the
 	 * compound page destructor.
 	 */
-	struct hstate *h = page_hstate(page);
-	int nid = page_to_nid(page);
-	struct hugepage_subpool *spool = hugetlb_page_subpool(page);
+	struct folio *folio = page_folio(page);
+	struct hstate *h = folio_hstate(folio);
+	int nid = folio_nid(folio);
+	struct hugepage_subpool *spool = hugetlb_folio_subpool(folio);
 	bool restore_reserve;
 	unsigned long flags;
 
-	VM_BUG_ON_PAGE(page_count(page), page);
-	VM_BUG_ON_PAGE(page_mapcount(page), page);
+	VM_BUG_ON_FOLIO(folio_ref_count(folio), folio);
+	VM_BUG_ON_FOLIO(folio_mapcount(folio), folio);
 
-	hugetlb_set_page_subpool(page, NULL);
-	if (PageAnon(page))
-		__ClearPageAnonExclusive(page);
-	page->mapping = NULL;
-	restore_reserve = HPageRestoreReserve(page);
-	ClearHPageRestoreReserve(page);
+	hugetlb_set_folio_subpool(folio, NULL);
+	if (folio_test_anon(folio))
+		__ClearPageAnonExclusive(&folio->page);
+	folio->mapping = NULL;
+	restore_reserve = folio_test_hugetlb_restore_reserve(folio);
+	folio_clear_hugetlb_restore_reserve(folio);
 
 	/*
 	 * If HPageRestoreReserve was set on page, page allocation consumed a
@@ -1740,7 +1741,7 @@ void free_huge_page(struct page *page)
 	}
 
 	spin_lock_irqsave(&hugetlb_lock, flags);
-	ClearHPageMigratable(page);
+	folio_clear_hugetlb_migratable(folio);
 	hugetlb_cgroup_uncharge_page(hstate_index(h),
 				     pages_per_huge_page(h), page);
 	hugetlb_cgroup_uncharge_page_rsvd(hstate_index(h),
@@ -1748,7 +1749,7 @@ void free_huge_page(struct page *page)
 	if (restore_reserve)
 		h->resv_huge_pages++;
 
-	if (HPageTemporary(page)) {
+	if (folio_test_hugetlb_temporary(folio)) {
 		remove_hugetlb_page(h, page, false);
 		spin_unlock_irqrestore(&hugetlb_lock, flags);
 		update_and_free_page(h, page, true);
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

