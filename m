Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99464C433E7
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:53:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 59F1421D7B
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:53:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602633236;
	bh=J4ZTY02v407cdzut8iaUPc8VD8ppoj7O9wMqwme4bE0=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=S08btY66S42lNWacg3UXYzQKRga7kRgc6Ew403Ox3FiqcjnE2yPzzOF9yhfQyJoUF
	 BvYEEIdBBuNBXtKU82xEP98JKhbCF4rnum8+x2N76xMRaAxaBuMzr1Tckn6srOfoRC
	 QdsuU3Y8gGVxHabhqedbqItmdmbXcFcED5Zo0YoU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729099AbgJMXx4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:53:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:39046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729683AbgJMXxz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:53:55 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3245F208B3;
        Tue, 13 Oct 2020 23:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602633235;
        bh=J4ZTY02v407cdzut8iaUPc8VD8ppoj7O9wMqwme4bE0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=e0UGQPBqVKaQ79vMOVKJ9eYPHzACD/aPmZcqxEBKHupJDh+lPOCmSaAsmhLMqXXRY
         uvb78AC9HgtDmTplvJ+yU4jx/8cnN3GugDqAMJ6DNt3/7qrCyBZg6sFtOc81i5mNJU
         gFauwbNq3mt1qs/hwptDv4Yn4i+TepPNWoDnc+GA=
Date:   Tue, 13 Oct 2020 16:53:54 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        willy@infradead.org, ziy@nvidia.com
Subject:  [patch 101/181] mm: simplify PageDoubleMap with PF_SECOND
 policy
Message-ID: <20201013235354.7z_wa9Lsg%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: simplify PageDoubleMap with PF_SECOND policy

Introduce the new page policy of PF_SECOND which lets us use the normal
pageflags generation machinery to create the various DoubleMap
manipulation functions.

Link: https://lkml.kernel.org/r/20200629151933.15671-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |   40 ++++++++---------------------------
 1 file changed, 10 insertions(+), 30 deletions(-)

--- a/include/linux/page-flags.h~mm-simplify-pagedoublemap-with-pf_second-policy
+++ a/include/linux/page-flags.h
@@ -235,6 +235,9 @@ static inline void page_init_poison(stru
  *
  * PF_NO_COMPOUND:
  *     the page flag is not relevant for compound pages.
+ *
+ * PF_SECOND:
+ *     the page flag is stored in the first tail page.
  */
 #define PF_POISONED_CHECK(page) ({					\
 		VM_BUG_ON_PGFLAGS(PagePoisoned(page), page);		\
@@ -250,6 +253,9 @@ static inline void page_init_poison(stru
 #define PF_NO_COMPOUND(page, enforce) ({				\
 		VM_BUG_ON_PGFLAGS(enforce && PageCompound(page), page);	\
 		PF_POISONED_CHECK(page); })
+#define PF_SECOND(page, enforce) ({					\
+		VM_BUG_ON_PGFLAGS(!PageHead(page), page);		\
+		PF_POISONED_CHECK(&page[1]); })
 
 /*
  * Macros to create function definitions for page flags
@@ -688,42 +694,15 @@ static inline int PageTransTail(struct p
  *
  * See also __split_huge_pmd_locked() and page_remove_anon_compound_rmap().
  */
-static inline int PageDoubleMap(struct page *page)
-{
-	return PageHead(page) && test_bit(PG_double_map, &page[1].flags);
-}
-
-static inline void SetPageDoubleMap(struct page *page)
-{
-	VM_BUG_ON_PAGE(!PageHead(page), page);
-	set_bit(PG_double_map, &page[1].flags);
-}
-
-static inline void ClearPageDoubleMap(struct page *page)
-{
-	VM_BUG_ON_PAGE(!PageHead(page), page);
-	clear_bit(PG_double_map, &page[1].flags);
-}
-static inline int TestSetPageDoubleMap(struct page *page)
-{
-	VM_BUG_ON_PAGE(!PageHead(page), page);
-	return test_and_set_bit(PG_double_map, &page[1].flags);
-}
-
-static inline int TestClearPageDoubleMap(struct page *page)
-{
-	VM_BUG_ON_PAGE(!PageHead(page), page);
-	return test_and_clear_bit(PG_double_map, &page[1].flags);
-}
-
+PAGEFLAG(DoubleMap, double_map, PF_SECOND)
+	TESTSCFLAG(DoubleMap, double_map, PF_SECOND)
 #else
 TESTPAGEFLAG_FALSE(TransHuge)
 TESTPAGEFLAG_FALSE(TransCompound)
 TESTPAGEFLAG_FALSE(TransCompoundMap)
 TESTPAGEFLAG_FALSE(TransTail)
 PAGEFLAG_FALSE(DoubleMap)
-	TESTSETFLAG_FALSE(DoubleMap)
-	TESTCLEARFLAG_FALSE(DoubleMap)
+	TESTSCFLAG_FALSE(DoubleMap)
 #endif
 
 /*
@@ -888,6 +867,7 @@ static inline int page_has_private(struc
 #undef PF_ONLY_HEAD
 #undef PF_NO_TAIL
 #undef PF_NO_COMPOUND
+#undef PF_SECOND
 #endif /* !__GENERATING_BOUNDS_H */
 
 #endif	/* PAGE_FLAGS_H */
_
