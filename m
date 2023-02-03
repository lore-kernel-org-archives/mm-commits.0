Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 846BBC636CC
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:36:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232316AbjBCGgg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:36:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232171AbjBCGf5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:35:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48B188C1EA
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:35:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DAC1961DA6
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:35:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A43DC433D2;
        Fri,  3 Feb 2023 06:35:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406150;
        bh=UX7fEt4gHxLUAFDikR38nq5UrMZfi504WJ6ecXFGgk0=;
        h=Date:To:From:Subject:From;
        b=XVU2RTxepcaAGpJY/a6tsN6MIIAY0j+S2rDAMWT+cMi5fY6GWgeEamYBkoaEXyjQf
         /fL9Wa/X6Pq90eyIZNdiH7Kf/o9mPLB91NgOxYGVUzmrzKYOoIqofVev5c7y+Gk6wJ
         5+VBAyKtKyqsrPbxVwSSUiQHX/0G9cBenug0zLqA=
Date:   Thu, 02 Feb 2023 22:35:49 -0800
To:     mm-commits@vger.kernel.org, hughd@google.com, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-reimplement-compound_nr.patch removed from -mm tree
Message-Id: <20230203063550.3A43DC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: reimplement compound_nr()
has been removed from the -mm tree.  Its filename was
     mm-reimplement-compound_nr.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: reimplement compound_nr()
Date: Wed, 11 Jan 2023 14:29:03 +0000

Turn compound_nr() into a wrapper around folio_nr_pages().  Similarly to
compound_order(), casting the struct page directly to struct folio
preserves the existing behaviour, while calling page_folio() would change
the behaviour.  Move thp_nr_pages() down in the file so that compound_nr()
can be after folio_nr_pages().

[willy@infradead.org: fix assertion triggering]
  Link: https://lkml.kernel.org/r/Y8AFgZEEjnUIaCbf@casper.infradead.org
Link: https://lkml.kernel.org/r/20230111142915.1001531-18-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/include/linux/mm.h~mm-reimplement-compound_nr
+++ a/include/linux/mm.h
@@ -1005,18 +1005,6 @@ static inline void set_compound_order(st
 #endif
 }
 
-/* Returns the number of pages in this potentially compound page. */
-static inline unsigned long compound_nr(struct page *page)
-{
-	if (!PageHead(page))
-		return 1;
-#ifdef CONFIG_64BIT
-	return page[1].compound_nr;
-#else
-	return 1UL << compound_order(page);
-#endif
-}
-
 /* Returns the number of bytes in this potentially compound page. */
 static inline unsigned long page_size(struct page *page)
 {
@@ -1040,16 +1028,6 @@ static inline unsigned int thp_order(str
 }
 
 /**
- * thp_nr_pages - The number of regular pages in this huge page.
- * @page: The head page of a huge page.
- */
-static inline int thp_nr_pages(struct page *page)
-{
-	VM_BUG_ON_PGFLAGS(PageTail(page), page);
-	return compound_nr(page);
-}
-
-/**
  * thp_size - Size of a transparent huge page.
  * @page: Head page of a transparent huge page.
  *
@@ -1758,6 +1736,33 @@ static inline long folio_nr_pages(struct
 #endif
 }
 
+/*
+ * compound_nr() returns the number of pages in this potentially compound
+ * page.  compound_nr() can be called on a tail page, and is defined to
+ * return 1 in that case.
+ */
+static inline unsigned long compound_nr(struct page *page)
+{
+	struct folio *folio = (struct folio *)page;
+
+	if (!test_bit(PG_head, &folio->flags))
+		return 1;
+#ifdef CONFIG_64BIT
+	return folio->_folio_nr_pages;
+#else
+	return 1L << folio->_folio_order;
+#endif
+}
+
+/**
+ * thp_nr_pages - The number of regular pages in this huge page.
+ * @page: The head page of a huge page.
+ */
+static inline int thp_nr_pages(struct page *page)
+{
+	return folio_nr_pages((struct folio *)page);
+}
+
 /**
  * folio_next - Move to the next physical folio.
  * @folio: The folio we're currently operating on.
_

Patches currently in -mm which might be from willy@infradead.org are


