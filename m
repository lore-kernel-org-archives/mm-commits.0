Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B47E0C7EE20
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 23:33:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231265AbjDRXdz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Apr 2023 19:33:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231309AbjDRXdv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2023 19:33:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E2537D9A
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 16:33:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9E964639F3
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 23:33:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01394C433EF;
        Tue, 18 Apr 2023 23:33:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681860829;
        bh=SjVNk8HiMDxnkWoWQ0mg8381awfF0yyJNh243boojuM=;
        h=Date:To:From:Subject:From;
        b=nu2ERjKfwOm3zVAQzj+4if1TRE2V56w5qbnlE+SLD6iX7+MGVd2CaJw+FAgpoff4h
         KP4kEsZA550PKI7j/PNdYeXdG17tjyWWMs1wgsNwSPYp0gkI5ulsoc5x+jA1aA2rF6
         V1HcYTvjoAR7xBtXm6Pznf1nkmdGDskmxFSDmva4=
Date:   Tue, 18 Apr 2023 16:33:48 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        sidhartha.kumar@oracle.com, mike.kravetz@oracle.com,
        david@redhat.com, willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] hugetlb-remove-pageheadhuge.patch removed from -mm tree
Message-Id: <20230418233349.01394C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: hugetlb: remove PageHeadHuge()
has been removed from the -mm tree.  Its filename was
     hugetlb-remove-pageheadhuge.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: hugetlb: remove PageHeadHuge()
Date: Mon, 27 Mar 2023 16:10:50 +0100

Sidhartha Kumar removed the last caller of PageHeadHuge(), so we can now
remove it and make folio_test_hugetlb() the real implementation.  Add
kernel-doc for folio_test_hugetlb().

Link: https://lkml.kernel.org/r/20230327151050.1787744-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    7 +------
 mm/hugetlb.c               |   18 +++++++++++-------
 2 files changed, 12 insertions(+), 13 deletions(-)

--- a/include/linux/page-flags.h~hugetlb-remove-pageheadhuge
+++ a/include/linux/page-flags.h
@@ -815,14 +815,9 @@ static inline void ClearPageCompound(str
 
 #ifdef CONFIG_HUGETLB_PAGE
 int PageHuge(struct page *page);
-int PageHeadHuge(struct page *page);
-static inline bool folio_test_hugetlb(struct folio *folio)
-{
-	return PageHeadHuge(&folio->page);
-}
+bool folio_test_hugetlb(struct folio *folio);
 #else
 TESTPAGEFLAG_FALSE(Huge, hugetlb)
-TESTPAGEFLAG_FALSE(HeadHuge, headhuge)
 #endif
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
--- a/mm/hugetlb.c~hugetlb-remove-pageheadhuge
+++ a/mm/hugetlb.c
@@ -2050,19 +2050,23 @@ int PageHuge(struct page *page)
 }
 EXPORT_SYMBOL_GPL(PageHuge);
 
-/*
- * PageHeadHuge() only returns true for hugetlbfs head page, but not for
- * normal or transparent huge pages.
+/**
+ * folio_test_hugetlb - Determine if the folio belongs to hugetlbfs
+ * @folio: The folio to test.
+ *
+ * Context: Any context.  Caller should have a reference on the folio to
+ * prevent it from being turned into a tail page.
+ * Return: True for hugetlbfs folios, false for anon folios or folios
+ * belonging to other filesystems.
  */
-int PageHeadHuge(struct page *page_head)
+bool folio_test_hugetlb(struct folio *folio)
 {
-	struct folio *folio = (struct folio *)page_head;
 	if (!folio_test_large(folio))
-		return 0;
+		return false;
 
 	return folio->_folio_dtor == HUGETLB_PAGE_DTOR;
 }
-EXPORT_SYMBOL_GPL(PageHeadHuge);
+EXPORT_SYMBOL_GPL(folio_test_hugetlb);
 
 /*
  * Find and lock address space (mapping) in write mode.
_

Patches currently in -mm which might be from willy@infradead.org are


