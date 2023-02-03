Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 204E3C636D7
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:36:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232075AbjBCGgY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:36:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232157AbjBCGf4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:35:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 015818C1D1
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:35:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 930BB61D98
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:35:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4FF3C4339B;
        Fri,  3 Feb 2023 06:35:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406148;
        bh=4GG11/SVw737x/Z4/IFuqZjQVq5eOlgjP+uO2oGQwzU=;
        h=Date:To:From:Subject:From;
        b=UstEEHpVSOZSpyUIzFxG9q0fKBSsafjIgUDAC4zIWN44RU4iebGsY8XCDz6POjf8E
         uTzTS33QH+Wv++gCyLFTWl1Ma8Pqm7lnJMIGoUO6YwnAj3WFXG5G5OktMHZ2P7fOev
         tF8DA/wA09D5J9wbPd7KsHPINw9dMY74kDCh9p3k=
Date:   Thu, 02 Feb 2023 22:35:47 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-head_compound_mapcount-and-_ptr-functions.patch removed from -mm tree
Message-Id: <20230203063547.E4FF3C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: remove head_compound_mapcount() and _ptr functions
has been removed from the -mm tree.  Its filename was
     mm-remove-head_compound_mapcount-and-_ptr-functions.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: remove head_compound_mapcount() and _ptr functions
Date: Wed, 11 Jan 2023 14:29:01 +0000

folio_mapcount_ptr(), compound_mapcount_ptr() and subpages_mapcount_ptr()
are all now unused.

Link: https://lkml.kernel.org/r/20230111142915.1001531-16-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/include/linux/mm.h~mm-remove-head_compound_mapcount-and-_ptr-functions
+++ a/include/linux/mm.h
@@ -831,16 +831,7 @@ static inline int is_vmalloc_or_module_a
 static inline int folio_entire_mapcount(struct folio *folio)
 {
 	VM_BUG_ON_FOLIO(!folio_test_large(folio), folio);
-	return atomic_read(folio_mapcount_ptr(folio)) + 1;
-}
-
-/*
- * Mapcount of compound page as a whole, does not include mapped sub-pages.
- * Must be called only on head of compound page.
- */
-static inline int head_compound_mapcount(struct page *head)
-{
-	return atomic_read(compound_mapcount_ptr(head)) + 1;
+	return atomic_read(&folio->_entire_mapcount) + 1;
 }
 
 /*
@@ -905,11 +896,11 @@ static inline int total_mapcount(struct
 static inline bool folio_large_is_mapped(struct folio *folio)
 {
 	/*
-	 * Reading folio_mapcount_ptr() below could be omitted if hugetlb
+	 * Reading _entire_mapcount below could be omitted if hugetlb
 	 * participated in incrementing nr_pages_mapped when compound mapped.
 	 */
 	return atomic_read(&folio->_nr_pages_mapped) > 0 ||
-		atomic_read(folio_mapcount_ptr(folio)) >= 0;
+		atomic_read(&folio->_entire_mapcount) >= 0;
 }
 
 /**
--- a/include/linux/mm_types.h~mm-remove-head_compound_mapcount-and-_ptr-functions
+++ a/include/linux/mm_types.h
@@ -421,22 +421,6 @@ FOLIO_MATCH(hugetlb_cgroup_rsvd, _hugetl
 FOLIO_MATCH(hugetlb_hwpoison, _hugetlb_hwpoison);
 #undef FOLIO_MATCH
 
-static inline atomic_t *folio_mapcount_ptr(struct folio *folio)
-{
-	struct page *tail = &folio->page + 1;
-	return &tail->compound_mapcount;
-}
-
-static inline atomic_t *compound_mapcount_ptr(struct page *page)
-{
-	return &page[1].compound_mapcount;
-}
-
-static inline atomic_t *subpages_mapcount_ptr(struct page *page)
-{
-	return &page[1].subpages_mapcount;
-}
-
 /*
  * Used for sizing the vmemmap region on some architectures
  */
_

Patches currently in -mm which might be from willy@infradead.org are


