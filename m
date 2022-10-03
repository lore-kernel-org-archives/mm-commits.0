Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4357C433FE
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:05:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229733AbiJCVFL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:05:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbiJCVEm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:04:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE26562D5
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:04:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8F753B811C4
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:04:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 411D2C433D7;
        Mon,  3 Oct 2022 21:04:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831078;
        bh=NXLz5mR33j4E8g0EZPIOYBgctqzYA/AUiXLOcS+nFgQ=;
        h=Date:To:From:Subject:From;
        b=Vy+eDxpyTbFNKxgFCF3hAGjn2Fjp3gP/BrkbiGGmwiW/JTGIfSi8M+Fyf7uc+yYRU
         wPP+/g5oWE+xfkq98N6aMkU+YoRf/pWZG9jryaKhZRTA1Za4i1JYwDwXSba8WGWoE3
         gOP3yQGw0gavAq2WUvAU6NWvL2GBy4Dc+g56Dc1w=
Date:   Mon, 03 Oct 2022 14:04:37 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-add-the-first-tail-page-to-struct-folio.patch removed from -mm tree
Message-Id: <20221003210438.411D2C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: add the first tail page to struct folio
has been removed from the -mm tree.  Its filename was
     mm-add-the-first-tail-page-to-struct-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: add the first tail page to struct folio
Date: Fri, 2 Sep 2022 20:45:58 +0100

Some of the static checkers get confused by extracting the page from the
folio and referring to fields in the first tail page.  Adding these fields
to struct folio lets us avoid doing that.  It has the risk that people
will refer to those fields without checking that the folio is actually a
large folio, so prefix them with underscores and document the preferred
function to use instead.

Link: https://lkml.kernel.org/r/20220902194653.1739778-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |   30 +++++++++++++++++++++++++++++-
 1 file changed, 29 insertions(+), 1 deletion(-)

--- a/include/linux/mm_types.h~mm-add-the-first-tail-page-to-struct-folio
+++ a/include/linux/mm_types.h
@@ -245,6 +245,13 @@ struct page {
  * @_refcount: Do not access this member directly.  Use folio_ref_count()
  *    to find how many references there are to this folio.
  * @memcg_data: Memory Control Group data.
+ * @_flags_1: For large folios, additional page flags.
+ * @__head: Points to the folio.  Do not use.
+ * @_folio_dtor: Which destructor to use for this folio.
+ * @_folio_order: Do not use directly, call folio_order().
+ * @_total_mapcount: Do not use directly, call folio_entire_mapcount().
+ * @_pincount: Do not use directly, call folio_maybe_dma_pinned().
+ * @_folio_nr_pages: Do not use directly, call folio_nr_pages().
  *
  * A folio is a physically, virtually and logically contiguous set
  * of bytes.  It is a power-of-two in size, and it is aligned to that
@@ -283,9 +290,17 @@ struct folio {
 		};
 		struct page page;
 	};
+	unsigned long _flags_1;
+	unsigned long __head;
+	unsigned char _folio_dtor;
+	unsigned char _folio_order;
+	atomic_t _total_mapcount;
+	atomic_t _pincount;
+#ifdef CONFIG_64BIT
+	unsigned int _folio_nr_pages;
+#endif
 };
 
-static_assert(sizeof(struct page) == sizeof(struct folio));
 #define FOLIO_MATCH(pg, fl)						\
 	static_assert(offsetof(struct page, pg) == offsetof(struct folio, fl))
 FOLIO_MATCH(flags, flags);
@@ -300,6 +315,19 @@ FOLIO_MATCH(_refcount, _refcount);
 FOLIO_MATCH(memcg_data, memcg_data);
 #endif
 #undef FOLIO_MATCH
+#define FOLIO_MATCH(pg, fl)						\
+	static_assert(offsetof(struct folio, fl) ==			\
+			offsetof(struct page, pg) + sizeof(struct page))
+FOLIO_MATCH(flags, _flags_1);
+FOLIO_MATCH(compound_head, __head);
+FOLIO_MATCH(compound_dtor, _folio_dtor);
+FOLIO_MATCH(compound_order, _folio_order);
+FOLIO_MATCH(compound_mapcount, _total_mapcount);
+FOLIO_MATCH(compound_pincount, _pincount);
+#ifdef CONFIG_64BIT
+FOLIO_MATCH(compound_nr, _folio_nr_pages);
+#endif
+#undef FOLIO_MATCH
 
 static inline atomic_t *folio_mapcount_ptr(struct folio *folio)
 {
_

Patches currently in -mm which might be from willy@infradead.org are


