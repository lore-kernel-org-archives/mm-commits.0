Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DD23C47089
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 00:01:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230029AbiLAAA7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 19:00:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230038AbiLAAAk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 19:00:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6326287C98
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 16:00:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DCA6C61E22
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 00:00:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3003CC433D7;
        Thu,  1 Dec 2022 00:00:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669852834;
        bh=IR2MWIaxNtIHJEwb0Rhgn/pBL+nWyykoUrmyDd6Q9Rs=;
        h=Date:To:From:Subject:From;
        b=ep0PmKHQo0lg9G22pPWc2qjrSiYYB3xZmR0FnYEpJhgG6LdPXykRaG9Us0MZgQmAX
         Xi3iQUY1vyVcRwIN2M6hQl6XdBJZY4x/8BOxXxX3p5rBKBrNutrqcRhtfhN1tYKD9Y
         hHX1tusXhyiEa2atffrQjaR5br7K9r9X2r5iI2lU=
Date:   Wed, 30 Nov 2022 16:00:33 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        songmuchun@bytedance.com, minhquangbui99@gmail.com,
        mike.kravetz@oracle.com, linmiaohe@huawei.com,
        aneesh.kumar@linux.ibm.com, almasrymina@google.com,
        sidhartha.kumar@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-convert-move_hugetlb_state-to-folios.patch removed from -mm tree
Message-Id: <20221201000034.3003CC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/hugetlb: convert move_hugetlb_state() to folios
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-convert-move_hugetlb_state-to-folios.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: mm/hugetlb: convert move_hugetlb_state() to folios
Date: Tue, 1 Nov 2022 15:30:59 -0700

Clean up unmap_and_move_huge_page() by converting move_hugetlb_state() to
take in folios.

[akpm@linux-foundation.org: fix CONFIG_HUGETLB_PAGE=n build]
Link: https://lkml.kernel.org/r/20221101223059.460937-10-sidhartha.kumar@oracle.com
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

 include/linux/hugetlb.h |   11 ++++++++---
 mm/hugetlb.c            |   22 ++++++++++++----------
 mm/migrate.c            |    4 ++--
 3 files changed, 22 insertions(+), 15 deletions(-)

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
 
@@ -991,6 +991,11 @@ void hugetlb_unregister_node(struct node
 #else	/* CONFIG_HUGETLB_PAGE */
 struct hstate {};
 
+static inline struct hugepage_subpool *hugetlb_folio_subpool(struct folio *folio)
+{
+	return NULL;
+}
+
 static inline struct hugepage_subpool *hugetlb_page_subpool(struct page *hpage)
 {
 	return NULL;
--- a/mm/hugetlb.c~mm-hugetlb-convert-move_hugetlb_state-to-folios
+++ a/mm/hugetlb.c
@@ -7324,15 +7324,15 @@ void putback_active_hugepage(struct page
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
@@ -7341,12 +7341,14 @@ void move_hugetlb_state(struct page *old
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

