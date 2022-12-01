Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F10CC352A1
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 00:00:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229879AbiLAAAy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 19:00:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230002AbiLAAAj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 19:00:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EF8C87C8D
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 16:00:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 09763B81AD6
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 00:00:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C621C433D7;
        Thu,  1 Dec 2022 00:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669852827;
        bh=qEECIkM7bWDk9u0GhUHv0xBeGHs+iPQfCLv6T5lcaF8=;
        h=Date:To:From:Subject:From;
        b=r/46elRbNc5lck++p7I6DJUgPra7m6KjrZCmGvytzeQ6jsAWdOdpUffBbynZU+L4t
         biE+PCwyMeNam6HZSGsTFIQCGBG2FcoAK78R3U5hDU7Ty4hDPd6iueTiFvj2zivQ83
         2kioxls5kqoWt5Gxh+8v/Ax5CX0Ls9QHiVCsmXp0=
Date:   Wed, 30 Nov 2022 16:00:26 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        songmuchun@bytedance.com, minhquangbui99@gmail.com,
        mike.kravetz@oracle.com, linmiaohe@huawei.com,
        aneesh.kumar@linux.ibm.com, almasrymina@google.com,
        sidhartha.kumar@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb_cgroup-convert-hugetlb_cgroup_migrate-to-folios.patch removed from -mm tree
Message-Id: <20221201000027.9C621C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/hugetlb_cgroup: convert hugetlb_cgroup_migrate to folios
has been removed from the -mm tree.  Its filename was
     mm-hugetlb_cgroup-convert-hugetlb_cgroup_migrate-to-folios.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: mm/hugetlb_cgroup: convert hugetlb_cgroup_migrate to folios
Date: Tue, 1 Nov 2022 15:30:54 -0700

Cleans up intermediate page to folio conversion code in
hugetlb_cgroup_migrate() by changing its arguments from pages to folios.

Link: https://lkml.kernel.org/r/20221101223059.460937-5-sidhartha.kumar@oracle.com
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

 include/linux/hugetlb_cgroup.h |    8 ++++----
 mm/hugetlb.c                   |    2 +-
 mm/hugetlb_cgroup.c            |    8 +++-----
 3 files changed, 8 insertions(+), 10 deletions(-)

--- a/include/linux/hugetlb_cgroup.h~mm-hugetlb_cgroup-convert-hugetlb_cgroup_migrate-to-folios
+++ a/include/linux/hugetlb_cgroup.h
@@ -177,8 +177,8 @@ extern void hugetlb_cgroup_uncharge_file
 						bool region_del);
 
 extern void hugetlb_cgroup_file_init(void) __init;
-extern void hugetlb_cgroup_migrate(struct page *oldhpage,
-				   struct page *newhpage);
+extern void hugetlb_cgroup_migrate(struct folio *old_folio,
+				   struct folio *new_folio);
 
 #else
 static inline void hugetlb_cgroup_uncharge_file_region(struct resv_map *resv,
@@ -286,8 +286,8 @@ static inline void hugetlb_cgroup_file_i
 {
 }
 
-static inline void hugetlb_cgroup_migrate(struct page *oldhpage,
-					  struct page *newhpage)
+static inline void hugetlb_cgroup_migrate(struct folio *old_folio,
+					  struct folio *new_folio)
 {
 }
 
--- a/mm/hugetlb.c~mm-hugetlb_cgroup-convert-hugetlb_cgroup_migrate-to-folios
+++ a/mm/hugetlb.c
@@ -7325,7 +7325,7 @@ void move_hugetlb_state(struct page *old
 {
 	struct hstate *h = page_hstate(oldpage);
 
-	hugetlb_cgroup_migrate(oldpage, newpage);
+	hugetlb_cgroup_migrate(page_folio(oldpage), page_folio(newpage));
 	set_page_owner_migrate_reason(newpage, reason);
 
 	/*
--- a/mm/hugetlb_cgroup.c~mm-hugetlb_cgroup-convert-hugetlb_cgroup_migrate-to-folios
+++ a/mm/hugetlb_cgroup.c
@@ -885,13 +885,11 @@ void __init hugetlb_cgroup_file_init(voi
  * hugetlb_lock will make sure a parallel cgroup rmdir won't happen
  * when we migrate hugepages
  */
-void hugetlb_cgroup_migrate(struct page *oldhpage, struct page *newhpage)
+void hugetlb_cgroup_migrate(struct folio *old_folio, struct folio *new_folio)
 {
 	struct hugetlb_cgroup *h_cg;
 	struct hugetlb_cgroup *h_cg_rsvd;
-	struct hstate *h = page_hstate(oldhpage);
-	struct folio *old_folio = page_folio(oldhpage);
-	struct folio *new_folio = page_folio(newhpage);
+	struct hstate *h = folio_hstate(old_folio);
 
 	if (hugetlb_cgroup_disabled())
 		return;
@@ -905,7 +903,7 @@ void hugetlb_cgroup_migrate(struct page
 	/* move the h_cg details to new cgroup */
 	set_hugetlb_cgroup(new_folio, h_cg);
 	set_hugetlb_cgroup_rsvd(new_folio, h_cg_rsvd);
-	list_move(&newhpage->lru, &h->hugepage_activelist);
+	list_move(&new_folio->lru, &h->hugepage_activelist);
 	spin_unlock_irq(&hugetlb_lock);
 	return;
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

