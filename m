Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CA50C6FD1D
	for <mm-commits@archiver.kernel.org>; Mon, 27 Mar 2023 20:14:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232573AbjC0UOf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 27 Mar 2023 16:14:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232543AbjC0UOe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Mar 2023 16:14:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47FA135BC
        for <mm-commits@vger.kernel.org>; Mon, 27 Mar 2023 13:14:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E9EC9B81910
        for <mm-commits@vger.kernel.org>; Mon, 27 Mar 2023 20:14:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88FBFC4339E;
        Mon, 27 Mar 2023 20:14:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1679948064;
        bh=5e+0pickQEMxuSWPeubkdl2jn/aAGd5ttc++z1j4FSk=;
        h=Date:To:From:Subject:From;
        b=SYcpCusaQfcTDoIAkYLs+NZbzIzxKn6KRTzogUoKQ7v6KNsgCWPbKGo6mJ9ItunwU
         KJ1DgwqUcE0rY+1e5Jot6nIoLH+KhNzeBm8foUzc1Nn2jrvo4ZM3PSk9vErPqVKPv+
         doYm0ACXkEKFhFVjtVb8h6LXIBoEExNtg9hoHYnw=
Date:   Mon, 27 Mar 2023 13:14:23 -0700
To:     mm-commits@vger.kernel.org, sidhartha.kumar@oracle.com,
        muchun.song@linux.dev, mike.kravetz@oracle.com,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + hugetlb-remove-pageheadhuge.patch added to mm-unstable branch
Message-Id: <20230327201424.88FBFC4339E@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: remove PageHeadHuge()
has been added to the -mm mm-unstable branch.  Its filename is
     hugetlb-remove-pageheadhuge.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hugetlb-remove-pageheadhuge.patch

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
Cc: Muchun Song <muchun.song@linux.dev>
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

xfs-remove-xfs_filemap_map_pages-wrapper.patch
afs-split-afs_pagecache_valid-out-of-afs_validate.patch
mm-hold-the-rcu-read-lock-over-calls-to-map_pages.patch
hugetlb-remove-pageheadhuge.patch

