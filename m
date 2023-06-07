Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F139C7EE2F
	for <mm-commits@archiver.kernel.org>; Wed,  7 Jun 2023 02:47:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240825AbjFGCrn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jun 2023 22:47:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240803AbjFGCre (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Jun 2023 22:47:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44DF21BC8
        for <mm-commits@vger.kernel.org>; Tue,  6 Jun 2023 19:47:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C8034639F3
        for <mm-commits@vger.kernel.org>; Wed,  7 Jun 2023 02:47:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D2CDC433EF;
        Wed,  7 Jun 2023 02:47:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686106049;
        bh=X+V9J6QdXOQFF4ZAXfHIKZhK4LPPseFaWAgCTFT1sYg=;
        h=Date:To:From:Subject:From;
        b=u22O+4ta/dsNu6jVFpqh/5m/vE3t2MXaCLbh00lwQfiVFol4ar7S6bOVhSlm/rUH4
         vpCumQO3r0cjrH+l82bmh2tuMDZ+/4ADdjKLJaAMGkH6Gnmv0bBQG5R/zy7tJo4mSb
         ofLDfVvU6b/IBE3jr8dsirb1EVs/hnoBJXGur0ss=
Date:   Tue, 06 Jun 2023 19:47:28 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        wangkefeng.wang@huawei.com, vishal.moola@gmail.com,
        sunnanyong@huawei.com, songmuchun@bytedance.com,
        mike.kravetz@oracle.com, zhangpeng362@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-use-a-folio-in-hugetlb_fault.patch added to mm-unstable branch
Message-Id: <20230607024729.2D2CDC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: use a folio in hugetlb_fault()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-use-a-folio-in-hugetlb_fault.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-use-a-folio-in-hugetlb_fault.patch

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
From: ZhangPeng <zhangpeng362@huawei.com>
Subject: mm/hugetlb: use a folio in hugetlb_fault()
Date: Tue, 6 Jun 2023 14:20:13 +0800

We can replace seven implicit calls to compound_head() with one by using
folio.

Link: https://lkml.kernel.org/r/20230606062013.2947002-4-zhangpeng362@huawei.com
Signed-off-by: ZhangPeng <zhangpeng362@huawei.com>
Reviewed-by Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-use-a-folio-in-hugetlb_fault
+++ a/mm/hugetlb.c
@@ -6062,7 +6062,7 @@ vm_fault_t hugetlb_fault(struct mm_struc
 	vm_fault_t ret;
 	u32 hash;
 	pgoff_t idx;
-	struct page *page = NULL;
+	struct folio *folio = NULL;
 	struct folio *pagecache_folio = NULL;
 	struct hstate *h = hstate_vma(vma);
 	struct address_space *mapping;
@@ -6181,14 +6181,14 @@ vm_fault_t hugetlb_fault(struct mm_struc
 	 * pagecache_folio, so here we need take the former one
 	 * when page != pagecache_folio or !pagecache_folio.
 	 */
-	page = pte_page(entry);
-	if (page_folio(page) != pagecache_folio)
-		if (!trylock_page(page)) {
+	folio = page_folio(pte_page(entry));
+	if (folio != pagecache_folio)
+		if (!folio_trylock(folio)) {
 			need_wait_lock = 1;
 			goto out_ptl;
 		}
 
-	get_page(page);
+	folio_get(folio);
 
 	if (flags & (FAULT_FLAG_WRITE|FAULT_FLAG_UNSHARE)) {
 		if (!huge_pte_write(entry)) {
@@ -6204,9 +6204,9 @@ vm_fault_t hugetlb_fault(struct mm_struc
 						flags & FAULT_FLAG_WRITE))
 		update_mmu_cache(vma, haddr, ptep);
 out_put_page:
-	if (page_folio(page) != pagecache_folio)
-		unlock_page(page);
-	put_page(page);
+	if (folio != pagecache_folio)
+		folio_unlock(folio);
+	folio_put(folio);
 out_ptl:
 	spin_unlock(ptl);
 
@@ -6225,7 +6225,7 @@ out_mutex:
 	 * here without taking refcount.
 	 */
 	if (need_wait_lock)
-		wait_on_page_locked(page);
+		folio_wait_locked(folio);
 	return ret;
 }
 
_

Patches currently in -mm which might be from zhangpeng362@huawei.com are

mm-hugetlb-use-a-folio-in-copy_hugetlb_page_range.patch
mm-hugetlb-use-a-folio-in-hugetlb_wp.patch
mm-hugetlb-use-a-folio-in-hugetlb_fault.patch

