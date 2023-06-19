Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1C42EB64DC
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:20:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbjFSXUv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:20:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229769AbjFSXUp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:20:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B45DE76
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:20:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AB73A60F1B
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:20:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 112ECC433C0;
        Mon, 19 Jun 2023 23:20:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687216839;
        bh=pRVyOeuf5H9W3xk5P0w3FnP9gbCpPPHR04ZkgIyLzkg=;
        h=Date:To:From:Subject:From;
        b=SYOlu13IGWnz6Eu3LPF2+38pAfFBmOZT/tgbo+QUBKl5AAp03EB0PeCvFBYX87nmM
         nTn9br6ORiKSZBytxaydD+ai4sVEraPcT4S5r9xae57gmrUzIPuFG737takIpx5wFP
         qD5cC5FVM2N/RA6udXrrJcSLneLdLTI4UFgp/UbA=
Date:   Mon, 19 Jun 2023 16:20:38 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        wangkefeng.wang@huawei.com, vishal.moola@gmail.com,
        sunnanyong@huawei.com, songmuchun@bytedance.com,
        mike.kravetz@oracle.com, zhangpeng362@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-use-a-folio-in-hugetlb_fault.patch removed from -mm tree
Message-Id: <20230619232039.112ECC433C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/hugetlb: use a folio in hugetlb_fault()
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-use-a-folio-in-hugetlb_fault.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: ZhangPeng <zhangpeng362@huawei.com>
Subject: mm/hugetlb: use a folio in hugetlb_fault()
Date: Tue, 6 Jun 2023 14:20:13 +0800

We can replace seven implicit calls to compound_head() with one by using
folio.

[akpm@linux-foundation.org: update comment, per Sidhartha]
Link: https://lkml.kernel.org/r/20230606062013.2947002-4-zhangpeng362@huawei.com
Signed-off-by: ZhangPeng <zhangpeng362@huawei.com>
Reviewed-by Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

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
@@ -6179,16 +6179,16 @@ vm_fault_t hugetlb_fault(struct mm_struc
 	/*
 	 * hugetlb_wp() requires page locks of pte_page(entry) and
 	 * pagecache_folio, so here we need take the former one
-	 * when page != pagecache_folio or !pagecache_folio.
+	 * when folio != pagecache_folio or !pagecache_folio.
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


