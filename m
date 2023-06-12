Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7815C7EE2F
	for <mm-commits@archiver.kernel.org>; Mon, 12 Jun 2023 21:00:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238376AbjFLVAa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 12 Jun 2023 17:00:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239256AbjFLVAQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Jun 2023 17:00:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D5D75FE1
        for <mm-commits@vger.kernel.org>; Mon, 12 Jun 2023 13:55:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 607206201C
        for <mm-commits@vger.kernel.org>; Mon, 12 Jun 2023 20:54:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB726C433EF;
        Mon, 12 Jun 2023 20:54:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686603255;
        bh=9piIqYLfywiLSG4VqXn3q+SBqeUabMLLNsLPyGlSZ+4=;
        h=Date:To:From:Subject:From;
        b=XKq87Z68IscV8clUS7LYxj8AnBi8GI0VHod+HX592m/LBPeSPItWAHm0Iey30ymWz
         5LF81kTMRRLrlP8rMteAFN0EVfV+uNnovbwaFW7+9m8RwTLKHWa1yMtIFONRDsyERg
         GezFf1e4i7zf/67NXSxDz3mKEs+8ap+28b8MVU1E=
Date:   Mon, 12 Jun 2023 13:54:15 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        muchun.song@linux.dev, mike.kravetz@oracle.com,
        gerald.schaefer@linux.ibm.com, aneesh.kumar@linux.ibm.com,
        tsahu@linux.ibm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-folio-replace-set_compound_order-with-folio_set_order.patch added to mm-unstable branch
Message-Id: <20230612205415.BB726C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: [mm-unstable] mm/folio: Replace set_compound_order with folio_set_order
has been added to the -mm mm-unstable branch.  Its filename is
     mm-folio-replace-set_compound_order-with-folio_set_order.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-folio-replace-set_compound_order-with-folio_set_order.patch

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
From: Tarun Sahu <tsahu@linux.ibm.com>
Subject: [mm-unstable] mm/folio: Replace set_compound_order with folio_set_order
Date: Mon, 12 Jun 2023 15:05:14 +0530

The patch ("mm/folio: Avoid special handling for order value 0 in
folio_set_order") [1] removed the need for special handling of order = 0
in folio_set_order.  Now, folio_set_order and set_compound_order becomes
similar function.  This patch removes the set_compound_order and uses
folio_set_order instead.

[1] https://lore.kernel.org/all/20230609183032.13E08C433D2@smtp.kernel.org/

Link: https://lkml.kernel.org/r/20230612093514.689846-1-tsahu@linux.ibm.com
Signed-off-by: Tarun Sahu <tsahu@linux.ibm.com>
Reviewed-by Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   10 ----------
 mm/internal.h      |   32 ++++++++++++++++----------------
 2 files changed, 16 insertions(+), 26 deletions(-)

--- a/include/linux/mm.h~mm-folio-replace-set_compound_order-with-folio_set_order
+++ a/include/linux/mm.h
@@ -1232,16 +1232,6 @@ static inline void folio_set_compound_dt
 
 void destroy_large_folio(struct folio *folio);
 
-static inline void set_compound_order(struct page *page, unsigned int order)
-{
-	struct folio *folio = (struct folio *)page;
-
-	folio->_folio_order = order;
-#ifdef CONFIG_64BIT
-	folio->_folio_nr_pages = 1U << order;
-#endif
-}
-
 /* Returns the number of bytes in this potentially compound page. */
 static inline unsigned long page_size(struct page *page)
 {
--- a/mm/internal.h~mm-folio-replace-set_compound_order-with-folio_set_order
+++ a/mm/internal.h
@@ -387,12 +387,27 @@ extern void memblock_free_pages(struct p
 					unsigned int order);
 extern void __free_pages_core(struct page *page, unsigned int order);
 
+/*
+ * This will have no effect, other than possibly generating a warning, if the
+ * caller passes in a non-large folio.
+ */
+static inline void folio_set_order(struct folio *folio, unsigned int order)
+{
+	if (WARN_ON_ONCE(!order || !folio_test_large(folio)))
+		return;
+
+	folio->_folio_order = order;
+#ifdef CONFIG_64BIT
+	folio->_folio_nr_pages = 1U << order;
+#endif
+}
+
 static inline void prep_compound_head(struct page *page, unsigned int order)
 {
 	struct folio *folio = (struct folio *)page;
 
 	folio_set_compound_dtor(folio, COMPOUND_PAGE_DTOR);
-	set_compound_order(page, order);
+	folio_set_order(folio, order);
 	atomic_set(&folio->_entire_mapcount, -1);
 	atomic_set(&folio->_nr_pages_mapped, 0);
 	atomic_set(&folio->_pincount, 0);
@@ -432,21 +447,6 @@ void memmap_init_range(unsigned long, in
 int split_free_page(struct page *free_page,
 			unsigned int order, unsigned long split_pfn_offset);
 
-/*
- * This will have no effect, other than possibly generating a warning, if the
- * caller passes in a non-large folio.
- */
-static inline void folio_set_order(struct folio *folio, unsigned int order)
-{
-	if (WARN_ON_ONCE(!order || !folio_test_large(folio)))
-		return;
-
-	folio->_folio_order = order;
-#ifdef CONFIG_64BIT
-	folio->_folio_nr_pages = 1U << order;
-#endif
-}
-
 #if defined CONFIG_COMPACTION || defined CONFIG_CMA
 
 /*
_

Patches currently in -mm which might be from tsahu@linux.ibm.com are

mm-folio-avoid-special-handling-for-order-value-0-in-folio_set_order.patch
mm-folio-replace-set_compound_order-with-folio_set_order.patch

