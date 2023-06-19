Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC7F5C0015E
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:27:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229933AbjFSX1V (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:27:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229914AbjFSXZt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:25:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70E6E10CF
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:23:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4FE6160F79
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:23:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6351C433C8;
        Mon, 19 Jun 2023 23:23:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687217006;
        bh=KJ86LU+wcofcnO0MiDT6kRkCVqUWnUNZ3pHuEAmaa7w=;
        h=Date:To:From:Subject:From;
        b=wDKpLIx/gc9+civsbv428y9avqF4N1W9DCbOngWaII1MaC/KrDlWQ4eSJiPYGYkJP
         SUDipyDczmKEo/UtaabXVxwaKJbrFrIK5w0dIGeztN4X4+7YafN2P2PC61sQhWG/X4
         ND4C1teg3eJcefCCRxJ7JMo8Rd0Mpp7Jk6U/x9Es=
Date:   Mon, 19 Jun 2023 16:23:26 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        lstoakes@gmail.com, vishal.moola@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-is_longterm_pinnable_page-and-reimplement-folio_is_longterm_pinnable.patch removed from -mm tree
Message-Id: <20230619232326.A6351C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: remove is_longterm_pinnable_page() and reimplement folio_is_longterm_pinnable()
has been removed from the -mm tree.  Its filename was
     mm-remove-is_longterm_pinnable_page-and-reimplement-folio_is_longterm_pinnable.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: mm: remove is_longterm_pinnable_page() and reimplement folio_is_longterm_pinnable()
Date: Tue, 13 Jun 2023 19:13:12 -0700

folio_is_longterm_pinnable() already exists as a wrapper function.  Now
that the whole implementation of is_longterm_pinnable_page() can be
implemented using folios, folio_is_longterm_pinnable() can be made its own
standalone function - and we can remove is_longterm_pinnable_page().

Link: https://lkml.kernel.org/r/20230614021312.34085-6-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Lorenzo Stoakes <lstoakes@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   22 +++++++++-------------
 1 file changed, 9 insertions(+), 13 deletions(-)

--- a/include/linux/mm.h~mm-remove-is_longterm_pinnable_page-and-reimplement-folio_is_longterm_pinnable
+++ a/include/linux/mm.h
@@ -1902,39 +1902,35 @@ static inline bool page_needs_cow_for_dm
 	return page_maybe_dma_pinned(page);
 }
 
-/* MIGRATE_CMA and ZONE_MOVABLE do not allow pin pages */
+/* MIGRATE_CMA and ZONE_MOVABLE do not allow pin folios */
 #ifdef CONFIG_MIGRATION
-static inline bool is_longterm_pinnable_page(struct page *page)
+static inline bool folio_is_longterm_pinnable(struct folio *folio)
 {
 #ifdef CONFIG_CMA
-	int mt = get_pageblock_migratetype(page);
+	int mt = folio_migratetype(folio);
 
 	if (mt == MIGRATE_CMA || mt == MIGRATE_ISOLATE)
 		return false;
 #endif
 	/* The zero page may always be pinned */
-	if (is_zero_pfn(page_to_pfn(page)))
+	if (is_zero_pfn(folio_pfn(folio)))
 		return true;
 
 	/* Coherent device memory must always allow eviction. */
-	if (is_device_coherent_page(page))
+	if (folio_is_device_coherent(folio))
 		return false;
 
-	/* Otherwise, non-movable zone pages can be pinned. */
-	return !is_zone_movable_page(page);
+	/* Otherwise, non-movable zone folios can be pinned. */
+	return !folio_is_zone_movable(folio);
+
 }
 #else
-static inline bool is_longterm_pinnable_page(struct page *page)
+static inline bool folio_is_longterm_pinnable(struct folio *folio)
 {
 	return true;
 }
 #endif
 
-static inline bool folio_is_longterm_pinnable(struct folio *folio)
-{
-	return is_longterm_pinnable_page(&folio->page);
-}
-
 static inline void set_page_zone(struct page *page, enum zone_type zone)
 {
 	page->flags &= ~(ZONES_MASK << ZONES_PGSHIFT);
_

Patches currently in -mm which might be from vishal.moola@gmail.com are

afs-fix-dangling-folio-ref-counts-in-writeback.patch
afs-fix-waiting-for-writeback-then-skipping-folio.patch

