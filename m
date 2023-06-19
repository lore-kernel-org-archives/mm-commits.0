Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71EFDEB64D9
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:25:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229985AbjFSXZy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:25:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229983AbjFSXXv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:23:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93D6019A2
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:22:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7537360FBB
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:22:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC6BCC433C0;
        Mon, 19 Jun 2023 23:22:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687216973;
        bh=f9hg8WmKHMnIU3b3nXEXwxTClQt34uTlHjd77EDGIFQ=;
        h=Date:To:From:Subject:From;
        b=ij530KH7wFqiEr0hnbEqe1yqpyUEhA60zCY08fvoL8JpeU/Vl2snuoQAkNE5XfYG7
         3NG8hSjUcOFP4bhyJwVtgHMSivFDm0jIoQ6UW2l8tK5ixuhJH08TCd6LVWk/noURs1
         oahY/vXy7kvD1U07NQY1BbplB/TQ/JCPrUpKCbPs=
Date:   Mon, 19 Jun 2023 16:22:53 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        songmuchun@bytedance.com, mike.kravetz@oracle.com,
        gerald.schaefer@linux.ibm.com, aneesh.kumar@linux.ibm.com,
        tsahu@linux.ibm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-folio-replace-set_compound_order-with-folio_set_order.patch removed from -mm tree
Message-Id: <20230619232253.CC6BCC433C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/folio: replace set_compound_order with folio_set_order
has been removed from the -mm tree.  Its filename was
     mm-folio-replace-set_compound_order-with-folio_set_order.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Tarun Sahu <tsahu@linux.ibm.com>
Subject: mm/folio: replace set_compound_order with folio_set_order
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
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
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


