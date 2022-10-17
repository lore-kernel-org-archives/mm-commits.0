Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37895C4332F
	for <mm-commits@archiver.kernel.org>; Mon, 17 Oct 2022 00:43:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229876AbiJQAn4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 16 Oct 2022 20:43:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229840AbiJQAnw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 16 Oct 2022 20:43:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 939583847A
        for <mm-commits@vger.kernel.org>; Sun, 16 Oct 2022 17:43:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5FDA1B80D5B
        for <mm-commits@vger.kernel.org>; Mon, 17 Oct 2022 00:43:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 038F2C433D6;
        Mon, 17 Oct 2022 00:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1665967423;
        bh=sxBb1Kv+/TQ2JAmV8iItAXi+Qhlg7UtdA/UoTkNMGGE=;
        h=Date:To:From:Subject:From;
        b=qb1sOWTxgJvLGyp44WNVLZUI5AdjvOwDdG90EtThvmBAhKh0ZaqLGpHDyOS3Nm3SA
         8Eb5KlqCfigvMAUv18VGszmpCvZzesIKzuRXxioSGvW2xjAdQVWC0TNI3yHITGRTdn
         i676LnlgdDB17kElq/vLIBc2Lbu9mGlgqGXE9NbM=
Date:   Sun, 16 Oct 2022 17:43:42 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        songmuchun@bytedance.com, minhquangbui99@gmail.com,
        mike.kravetz@oracle.com, linmiaohe@huawei.com,
        aneesh.kumar@linux.ibm.com, almasrymina@google.com,
        sidhartha.kumar@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb_cgroup-convert-hugetlb_cgroup_migrate-to-folios.patch added to mm-unstable branch
Message-Id: <20221017004343.038F2C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb_cgroup: convert hugetlb_cgroup_migrate to folios
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb_cgroup-convert-hugetlb_cgroup_migrate-to-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb_cgroup-convert-hugetlb_cgroup_migrate-to-folios.patch

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
Subject: mm/hugetlb_cgroup: convert hugetlb_cgroup_migrate to folios
Date: Thu, 13 Oct 2022 20:12:58 -0700

Cleans up intermediate page to folio conversion code in
hugetlb_cgroup_migrate() by changing its arguments from pages to folios.

Link: https://lkml.kernel.org/r/20221014031303.231740-5-sidhartha.kumar@oracle.com
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
@@ -7314,7 +7314,7 @@ void move_hugetlb_state(struct page *old
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

mm-hugetlb_cgroup-convert-__set_hugetlb_cgroup-to-folios.patch
mm-hugetlb_cgroup-convert-hugetlb_cgroup_from_page-to-folios.patch
mm-hugetlb_cgroup-convert-set_hugetlb_cgroup-to-folios.patch
mm-hugetlb_cgroup-convert-hugetlb_cgroup_migrate-to-folios.patch
mm-hugetlb-convert-isolate_or_dissolve_huge_page-to-folios.patch
mm-hugetlb-convert-free_huge_page-to-folios.patch
mm-hugetlb_cgroup-convert-hugetlb_cgroup_uncharge_page-to-folios.patch
mm-hugeltb_cgroup-convert-hugetlb_cgroup_commit_charge-to-folios.patch
mm-hugetlb-convert-move_hugetlb_state-to-folios.patch

