Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B27B4C433FE
	for <mm-commits@archiver.kernel.org>; Tue,  1 Nov 2022 22:41:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230493AbiKAWlV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 1 Nov 2022 18:41:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231168AbiKAWlF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 1 Nov 2022 18:41:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4113FAC4
        for <mm-commits@vger.kernel.org>; Tue,  1 Nov 2022 15:41:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 416E76170B
        for <mm-commits@vger.kernel.org>; Tue,  1 Nov 2022 22:41:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B97AC433D6;
        Tue,  1 Nov 2022 22:41:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667342462;
        bh=mZQ7j8Mgg7XU28fPRr2W6P8xx/J7XwW4rN/k35eKLEs=;
        h=Date:To:From:Subject:From;
        b=lCk1WKnK1PcvDWPVjc2HG5k5XMQPNC4fWC8GVcOyZJkV8X7SbWy5vYZxZxv2KIXbU
         rTebQUzotWWyyhohiHMSMkEuGd4orvFKhHLqs5B7Bv3UCmZWY7kHZINcj3FuDFKrV9
         zLBgG7NFKRm26BljE5jU3kPw8D47JhpsZaiL3+o4=
Date:   Tue, 01 Nov 2022 15:41:02 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        songmuchun@bytedance.com, minhquangbui99@gmail.com,
        mike.kravetz@oracle.com, linmiaohe@huawei.com,
        aneesh.kumar@linux.ibm.com, almasrymina@google.com,
        sidhartha.kumar@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-convert-move_hugetlb_state-to-folios.patch added to mm-unstable branch
Message-Id: <20221101224102.9B97AC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: convert move_hugetlb_state() to folios
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-convert-move_hugetlb_state-to-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-convert-move_hugetlb_state-to-folios.patch

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
Subject: mm/hugetlb: convert move_hugetlb_state() to folios
Date: Tue, 1 Nov 2022 15:30:59 -0700

Clean up unmap_and_move_huge_page() by converting move_hugetlb_state() to
take in folios.

Link: https://lkml.kernel.org/r/20221101223059.460937-10-sidhartha.kumar@oracle.com
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

 include/linux/hugetlb.h |    6 +++---
 mm/hugetlb.c            |   22 ++++++++++++----------
 mm/migrate.c            |    4 ++--
 3 files changed, 17 insertions(+), 15 deletions(-)

--- a/include/linux/hugetlb.h~mm-hugetlb-convert-move_hugetlb_state-to-folios
+++ a/include/linux/hugetlb.h
@@ -187,7 +187,7 @@ int get_hwpoison_huge_page(struct page *
 int get_huge_page_for_hwpoison(unsigned long pfn, int flags,
 				bool *migratable_cleared);
 void putback_active_hugepage(struct page *page);
-void move_hugetlb_state(struct page *oldpage, struct page *newpage, int reason);
+void move_hugetlb_state(struct folio *old_folio, struct folio *new_folio, int reason);
 void free_huge_page(struct page *page);
 void hugetlb_fix_reserve_counts(struct inode *inode);
 extern struct mutex *hugetlb_fault_mutex_table;
@@ -407,8 +407,8 @@ static inline void putback_active_hugepa
 {
 }
 
-static inline void move_hugetlb_state(struct page *oldpage,
-					struct page *newpage, int reason)
+static inline void move_hugetlb_state(struct folio *old_folio,
+					struct folio *new_folio, int reason)
 {
 }
 
--- a/mm/hugetlb.c~mm-hugetlb-convert-move_hugetlb_state-to-folios
+++ a/mm/hugetlb.c
@@ -7317,15 +7317,15 @@ void putback_active_hugepage(struct page
 	put_page(page);
 }
 
-void move_hugetlb_state(struct page *oldpage, struct page *newpage, int reason)
+void move_hugetlb_state(struct folio *old_folio, struct folio *new_folio, int reason)
 {
-	struct hstate *h = page_hstate(oldpage);
+	struct hstate *h = folio_hstate(old_folio);
 
-	hugetlb_cgroup_migrate(page_folio(oldpage), page_folio(newpage));
-	set_page_owner_migrate_reason(newpage, reason);
+	hugetlb_cgroup_migrate(old_folio, new_folio);
+	set_page_owner_migrate_reason(&new_folio->page, reason);
 
 	/*
-	 * transfer temporary state of the new huge page. This is
+	 * transfer temporary state of the new hugetlb folio. This is
 	 * reverse to other transitions because the newpage is going to
 	 * be final while the old one will be freed so it takes over
 	 * the temporary status.
@@ -7334,12 +7334,14 @@ void move_hugetlb_state(struct page *old
 	 * here as well otherwise the global surplus count will not match
 	 * the per-node's.
 	 */
-	if (HPageTemporary(newpage)) {
-		int old_nid = page_to_nid(oldpage);
-		int new_nid = page_to_nid(newpage);
+	if (folio_test_hugetlb_temporary(new_folio)) {
+		int old_nid = folio_nid(old_folio);
+		int new_nid = folio_nid(new_folio);
+
+
+		folio_set_hugetlb_temporary(old_folio);
+		folio_clear_hugetlb_temporary(new_folio);
 
-		SetHPageTemporary(oldpage);
-		ClearHPageTemporary(newpage);
 
 		/*
 		 * There is no need to transfer the per-node surplus state
--- a/mm/migrate.c~mm-hugetlb-convert-move_hugetlb_state-to-folios
+++ a/mm/migrate.c
@@ -1298,7 +1298,7 @@ static int unmap_and_move_huge_page(new_
 	 * folio_mapping() set, hugetlbfs specific move page routine will not
 	 * be called and we could leak usage counts for subpools.
 	 */
-	if (hugetlb_page_subpool(hpage) && !folio_mapping(src)) {
+	if (hugetlb_folio_subpool(src) && !folio_mapping(src)) {
 		rc = -EBUSY;
 		goto out_unlock;
 	}
@@ -1348,7 +1348,7 @@ put_anon:
 		put_anon_vma(anon_vma);
 
 	if (rc == MIGRATEPAGE_SUCCESS) {
-		move_hugetlb_state(hpage, new_hpage, reason);
+		move_hugetlb_state(src, dst, reason);
 		put_new_page = NULL;
 	}
 
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

