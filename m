Return-Path: <SRS0=GeP8=CC=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1F2AC433DF
	for <mm-commits@archiver.kernel.org>; Mon, 24 Aug 2020 21:51:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B134A2078D
	for <mm-commits@archiver.kernel.org>; Mon, 24 Aug 2020 21:51:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598305877;
	bh=2R58xQq00GRxb9lGgRRnYFxjj3abZHaTVwoOs6+YwYk=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=M0HSjYA4hAkxSXQv57uJJc8X/X1R+PZ1onFNMo4CoAZcJYRIL7LfqZbLV7Idl/2lw
	 6SZw5QNKNGcJ424DLbuXdMcx+eVcoMqeV2TDlqYZH07tjS5Lb9tLDqWgtDpz18ozvt
	 XfPdKa82hVLxWG8hgsi5wgirhsY4bRJesJXJg5KA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726519AbgHXVvR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 24 Aug 2020 17:51:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:41660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726090AbgHXVvQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 24 Aug 2020 17:51:16 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CC6342072D;
        Mon, 24 Aug 2020 21:51:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598305876;
        bh=2R58xQq00GRxb9lGgRRnYFxjj3abZHaTVwoOs6+YwYk=;
        h=Date:From:To:Subject:From;
        b=wYlZfKTaiYQxy0TMuHbqI2/fiSBqV5QeLR2PdEnAOMRlIwLjYnOJH2/rIHql6udOB
         mIyTJiUjJby349jRN6U2pjXflbC6tvdOpJUrdMcgUkEnncJnzWW6xJ9nmfIQGTpFR6
         muD0MlSYR+YBEkjLS/WRjAjObmVrBdrxs+nsktfg=
Date:   Mon, 24 Aug 2020 14:51:15 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, willy@infradead.org, ziy@nvidia.com
Subject:  + mm-simplify-pagedoublemap-with-pf_second-policy.patch
 added to -mm tree
Message-ID: <20200824215115.Joz3BgipP%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: simplify PageDoubleMap with PF_SECOND policy
has been added to the -mm tree.  Its filename is
     mm-simplify-pagedoublemap-with-pf_second-policy.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-simplify-pagedoublemap-with-pf_second-policy.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-simplify-pagedoublemap-with-pf_second-policy.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
@@ -232,6 +232,9 @@ static inline void page_init_poison(stru
  *
  * PF_NO_COMPOUND:
  *     the page flag is not relevant for compound pages.
+ *
+ * PF_SECOND:
+ *     the page flag is stored in the first tail page.
  */
 #define PF_POISONED_CHECK(page) ({					\
 		VM_BUG_ON_PGFLAGS(PagePoisoned(page), page);		\
@@ -247,6 +250,9 @@ static inline void page_init_poison(stru
 #define PF_NO_COMPOUND(page, enforce) ({				\
 		VM_BUG_ON_PGFLAGS(enforce && PageCompound(page), page);	\
 		PF_POISONED_CHECK(page); })
+#define PF_SECOND(page, enforce) ({					\
+		VM_BUG_ON_PGFLAGS(!PageHead(page), page);		\
+		PF_POISONED_CHECK(&page[1]); })
 
 /*
  * Macros to create function definitions for page flags
@@ -685,42 +691,15 @@ static inline int PageTransTail(struct p
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
@@ -885,6 +864,7 @@ static inline int page_has_private(struc
 #undef PF_ONLY_HEAD
 #undef PF_NO_TAIL
 #undef PF_NO_COMPOUND
+#undef PF_SECOND
 #endif /* !__GENERATING_BOUNDS_H */
 
 #endif	/* PAGE_FLAGS_H */
_

Patches currently in -mm which might be from willy@infradead.org are

mm-debug-do-not-dereference-i_ino-blindly.patch
mm-account-pmd-tables-like-pte-tables.patch
mm-move-pagedoublemap-bit.patch
mm-simplify-pagedoublemap-with-pf_second-policy.patch
harden-autofs-ioctl-table.patch

