Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BFA0EB64DA
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:20:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229453AbjFSXUu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:20:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbjFSXUp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:20:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5C34E71
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:20:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8270F60F0D
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:20:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBC31C433C0;
        Mon, 19 Jun 2023 23:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687216837;
        bh=/BsYF/iXJUSWJ55Od/SMhX7FRCmdMJQor+rG1c+Zu9g=;
        h=Date:To:From:Subject:From;
        b=TEWwrBxM55WNieGwNK1CZk9UHQeXchTqeoyF8W7LXqgESZpPJ+jz5r4wQm/Zn9q7z
         dRZOrJfH+TcO3M7/Verw8A19rLbarhrGr0T4mEytCbgH4im+gXSAgWUvRlxLfW4and
         m8dspaJhQq7s/6ECH1d5vTfZYoxXtQbzMwHQsz10=
Date:   Mon, 19 Jun 2023 16:20:36 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        wangkefeng.wang@huawei.com, vishal.moola@gmail.com,
        sunnanyong@huawei.com, songmuchun@bytedance.com,
        sidhartha.kumar@oracle.com, mike.kravetz@oracle.com,
        zhangpeng362@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-use-a-folio-in-copy_hugetlb_page_range.patch removed from -mm tree
Message-Id: <20230619232036.DBC31C433C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/hugetlb: use a folio in copy_hugetlb_page_range()
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-use-a-folio-in-copy_hugetlb_page_range.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: ZhangPeng <zhangpeng362@huawei.com>
Subject: mm/hugetlb: use a folio in copy_hugetlb_page_range()
Date: Tue, 6 Jun 2023 14:20:11 +0800

Patch series "Convert several functions in hugetlb.c to use a folio", v2.

This patch series converts three functions in hugetlb.c to use a folio,
which can remove several implicit calls to compound_head().


This patch (of 3):

We can replace five implict calls to compound_head() with one by using
pte_folio.  The page we get back is always a head page, so we just convert
ptepage to pte_folio.

Link: https://lkml.kernel.org/r/20230606062013.2947002-1-zhangpeng362@huawei.com
Link: https://lkml.kernel.org/r/20230606062013.2947002-2-zhangpeng362@huawei.com
Signed-off-by: ZhangPeng <zhangpeng362@huawei.com>
Suggested-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-use-a-folio-in-copy_hugetlb_page_range
+++ a/mm/hugetlb.c
@@ -5016,7 +5016,7 @@ int copy_hugetlb_page_range(struct mm_st
 			    struct vm_area_struct *src_vma)
 {
 	pte_t *src_pte, *dst_pte, entry;
-	struct page *ptepage;
+	struct folio *pte_folio;
 	unsigned long addr;
 	bool cow = is_cow_mapping(src_vma->vm_flags);
 	struct hstate *h = hstate_vma(src_vma);
@@ -5115,8 +5115,8 @@ again:
 				set_huge_pte_at(dst, addr, dst_pte, entry);
 		} else {
 			entry = huge_ptep_get(src_pte);
-			ptepage = pte_page(entry);
-			get_page(ptepage);
+			pte_folio = page_folio(pte_page(entry));
+			folio_get(pte_folio);
 
 			/*
 			 * Failing to duplicate the anon rmap is a rare case
@@ -5128,10 +5128,10 @@ again:
 			 * need to be without the pgtable locks since we could
 			 * sleep during the process.
 			 */
-			if (!PageAnon(ptepage)) {
-				page_dup_file_rmap(ptepage, true);
-			} else if (page_try_dup_anon_rmap(ptepage, true,
-							  src_vma)) {
+			if (!folio_test_anon(pte_folio)) {
+				page_dup_file_rmap(&pte_folio->page, true);
+			} else if (page_try_dup_anon_rmap(&pte_folio->page,
+							  true, src_vma)) {
 				pte_t src_pte_old = entry;
 				struct folio *new_folio;
 
@@ -5140,14 +5140,14 @@ again:
 				/* Do not use reserve as it's private owned */
 				new_folio = alloc_hugetlb_folio(dst_vma, addr, 1);
 				if (IS_ERR(new_folio)) {
-					put_page(ptepage);
+					folio_put(pte_folio);
 					ret = PTR_ERR(new_folio);
 					break;
 				}
 				ret = copy_user_large_folio(new_folio,
-						      page_folio(ptepage),
-						      addr, dst_vma);
-				put_page(ptepage);
+							    pte_folio,
+							    addr, dst_vma);
+				folio_put(pte_folio);
 				if (ret) {
 					folio_put(new_folio);
 					break;
_

Patches currently in -mm which might be from zhangpeng362@huawei.com are


