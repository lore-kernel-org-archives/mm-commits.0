Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 550F4EB64DB
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:27:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230055AbjFSX1U (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:27:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229908AbjFSXZX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:25:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75516139
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:23:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 553A260FB7
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:23:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B06A9C433C8;
        Mon, 19 Jun 2023 23:23:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687217004;
        bh=UP7tUanckO62qoIJf+ZcLi7OhjgTjb+LezturiWDtcc=;
        h=Date:To:From:Subject:From;
        b=Q11oOdrt+9AdU0g+JTQzD/l3C+8p+VwAi5dqtvHwpDV7Q1Mdl5Lh1/QuE3e6iTB4p
         /lLrcdAa/NjWtC4Ts7hRZa5BsWvouXm7dmsCIBIT6vwPe0ZlyhKoVNfWeGcx6fGy4o
         yuRdx1pDHtHZtPTxiclSIaNuYezVISsEmIou9I3g=
Date:   Mon, 19 Jun 2023 16:23:24 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        lstoakes@gmail.com, vishal.moola@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-gup_testc-convert-verify_dma_pinned-to-us-folios.patch removed from -mm tree
Message-Id: <20230619232324.B06A9C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/gup_test.c: convert verify_dma_pinned() to us folios
has been removed from the -mm tree.  Its filename was
     mm-gup_testc-convert-verify_dma_pinned-to-us-folios.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: mm/gup_test.c: convert verify_dma_pinned() to us folios
Date: Tue, 13 Jun 2023 19:13:10 -0700

verify_dma_pinned() checks that pages are dma-pinned.  We can convert this
to use folios.

Link: https://lkml.kernel.org/r/20230614021312.34085-4-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Lorenzo Stoakes <lstoakes@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup_test.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/mm/gup_test.c~mm-gup_testc-convert-verify_dma_pinned-to-us-folios
+++ a/mm/gup_test.c
@@ -40,24 +40,25 @@ static void verify_dma_pinned(unsigned i
 			      unsigned long nr_pages)
 {
 	unsigned long i;
-	struct page *page;
+	struct folio *folio;
 
 	switch (cmd) {
 	case PIN_FAST_BENCHMARK:
 	case PIN_BASIC_TEST:
 	case PIN_LONGTERM_BENCHMARK:
 		for (i = 0; i < nr_pages; i++) {
-			page = pages[i];
-			if (WARN(!page_maybe_dma_pinned(page),
+			folio = page_folio(pages[i]);
+
+			if (WARN(!folio_maybe_dma_pinned(folio),
 				 "pages[%lu] is NOT dma-pinned\n", i)) {
 
-				dump_page(page, "gup_test failure");
+				dump_page(&folio->page, "gup_test failure");
 				break;
 			} else if (cmd == PIN_LONGTERM_BENCHMARK &&
-				WARN(!is_longterm_pinnable_page(page),
+				WARN(!folio_is_longterm_pinnable(folio),
 				     "pages[%lu] is NOT pinnable but pinned\n",
 				     i)) {
-				dump_page(page, "gup_test failure");
+				dump_page(&folio->page, "gup_test failure");
 				break;
 			}
 		}
_

Patches currently in -mm which might be from vishal.moola@gmail.com are

afs-fix-dangling-folio-ref-counts-in-writeback.patch
afs-fix-waiting-for-writeback-then-skipping-folio.patch

