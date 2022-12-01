Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 137C2C4321E
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 00:01:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230214AbiLAABO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 19:01:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229903AbiLAAAk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 19:00:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7071C87CA7
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 16:00:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2AA20B81AD6
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 00:00:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA8B6C433D6;
        Thu,  1 Dec 2022 00:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669852833;
        bh=2hkH5fdcwVL8v/HIfL+y8pcseyQe7MeY+gBDomutwE8=;
        h=Date:To:From:Subject:From;
        b=miW7TyRNHR4sLoR4W0Z8I10tMmUgoN/LETD0aq6+C/qiU/0qpz9VR6QcBJy3ireH1
         VxtwFMKgH+DvsUa8a8dCVgnLGKkJkiIKC4VoF6cb1C54XPPGLmJLGxWOwjpMmKHvOz
         NpdJMmIDv8iMXHxSl6vdzu5eB5VudNPqn4JdjEtQ=
Date:   Wed, 30 Nov 2022 16:00:32 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        songmuchun@bytedance.com, minhquangbui99@gmail.com,
        mike.kravetz@oracle.com, linmiaohe@huawei.com,
        aneesh.kumar@linux.ibm.com, almasrymina@google.com,
        sidhartha.kumar@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugeltb_cgroup-convert-hugetlb_cgroup_commit_charge-to-folios.patch removed from -mm tree
Message-Id: <20221201000032.DA8B6C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/hugeltb_cgroup: convert hugetlb_cgroup_commit_charge*() to folios
has been removed from the -mm tree.  Its filename was
     mm-hugeltb_cgroup-convert-hugetlb_cgroup_commit_charge-to-folios.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: mm/hugeltb_cgroup: convert hugetlb_cgroup_commit_charge*() to folios
Date: Tue, 1 Nov 2022 15:30:58 -0700

Convert hugetlb_cgroup_commit_charge*() to internally use folios to clean
up the code after __set_hugetlb_cgroup() was changed to take a folio.

Link: https://lkml.kernel.org/r/20221101223059.460937-9-sidhartha.kumar@oracle.com
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

 mm/hugetlb_cgroup.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

--- a/mm/hugetlb_cgroup.c~mm-hugeltb_cgroup-convert-hugetlb_cgroup_commit_charge-to-folios
+++ a/mm/hugetlb_cgroup.c
@@ -310,21 +310,21 @@ int hugetlb_cgroup_charge_cgroup_rsvd(in
 /* Should be called with hugetlb_lock held */
 static void __hugetlb_cgroup_commit_charge(int idx, unsigned long nr_pages,
 					   struct hugetlb_cgroup *h_cg,
-					   struct page *page, bool rsvd)
+					   struct folio *folio, bool rsvd)
 {
 	if (hugetlb_cgroup_disabled() || !h_cg)
 		return;
 
-	__set_hugetlb_cgroup(page_folio(page), h_cg, rsvd);
+	__set_hugetlb_cgroup(folio, h_cg, rsvd);
 	if (!rsvd) {
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
 			   usage + nr_pages);
 	}
 }
@@ -333,14 +333,18 @@ void hugetlb_cgroup_commit_charge(int id
 				  struct hugetlb_cgroup *h_cg,
 				  struct page *page)
 {
-	__hugetlb_cgroup_commit_charge(idx, nr_pages, h_cg, page, false);
+	struct folio *folio = page_folio(page);
+
+	__hugetlb_cgroup_commit_charge(idx, nr_pages, h_cg, folio, false);
 }
 
 void hugetlb_cgroup_commit_charge_rsvd(int idx, unsigned long nr_pages,
 				       struct hugetlb_cgroup *h_cg,
 				       struct page *page)
 {
-	__hugetlb_cgroup_commit_charge(idx, nr_pages, h_cg, page, true);
+	struct folio *folio = page_folio(page);
+
+	__hugetlb_cgroup_commit_charge(idx, nr_pages, h_cg, folio, true);
 }
 
 /*
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

