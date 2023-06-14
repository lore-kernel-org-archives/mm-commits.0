Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D40C9EB64D9
	for <mm-commits@archiver.kernel.org>; Wed, 14 Jun 2023 20:05:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235533AbjFNUFa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Jun 2023 16:05:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235535AbjFNUF1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Jun 2023 16:05:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAAB82101
        for <mm-commits@vger.kernel.org>; Wed, 14 Jun 2023 13:05:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 587D160AE1
        for <mm-commits@vger.kernel.org>; Wed, 14 Jun 2023 20:05:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE0BCC433C8;
        Wed, 14 Jun 2023 20:05:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686773125;
        bh=5SjVPbasT2/FoMyhKou9UufgIGsi7VqdHhyYaggB6Vw=;
        h=Date:To:From:Subject:From;
        b=f0JtkNtr4OFAncH3nTic+FlhXsygF4e65RNCW4Bdh9WQHis91KpcjcZ0ysuFjOLQC
         6eBC6QcDQFyFJm9T5wdiE80uyuhJ/w4dtzNkE71gSEo2RkL/zy0sUZXTJcVFTxZN+N
         +dSmg54BXiWdzIMWWpbtAw1DhzIPQ0N5XsZ0G+a0=
Date:   Wed, 14 Jun 2023 13:05:24 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        vishal.moola@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-is_longterm_pinnable_page-and-reimplement-folio_is_longterm_pinnable.patch added to mm-unstable branch
Message-Id: <20230614200525.AE0BCC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove is_longterm_pinnable_page() and Reimplement folio_is_longterm_pinnable()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-is_longterm_pinnable_page-and-reimplement-folio_is_longterm_pinnable.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-is_longterm_pinnable_page-and-reimplement-folio_is_longterm_pinnable.patch

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
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: mm: remove is_longterm_pinnable_page() and Reimplement folio_is_longterm_pinnable()
Date: Tue, 13 Jun 2023 19:13:12 -0700

folio_is_longterm_pinnable() already exists as a wrapper function.  Now
that the whole implementation of is_longterm_pinnable_page() can be
implemented using folios, folio_is_longterm_pinnable() can be made its own
standalone function - and we can remove is_longterm_pinnable_page().

Link: https://lkml.kernel.org/r/20230614021312.34085-6-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
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
mmzone-introduce-folio_is_zone_movable.patch
mmzone-introduce-folio_migratetype.patch
mm-gup_testc-convert-verify_dma_pinned-to-us-folios.patch
mm-gupc-reorganize-try_get_folio.patch
mm-remove-is_longterm_pinnable_page-and-reimplement-folio_is_longterm_pinnable.patch

