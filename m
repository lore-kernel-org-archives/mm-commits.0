Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE612EB64D8
	for <mm-commits@archiver.kernel.org>; Wed, 14 Jun 2023 20:05:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235614AbjFNUF3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Jun 2023 16:05:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235333AbjFNUFX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Jun 2023 16:05:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07B6FB5
        for <mm-commits@vger.kernel.org>; Wed, 14 Jun 2023 13:05:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 96BC460AE1
        for <mm-commits@vger.kernel.org>; Wed, 14 Jun 2023 20:05:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E84AFC433C0;
        Wed, 14 Jun 2023 20:05:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686773122;
        bh=21F18XR2js7YqBbbklCgFbBUokV5k1qE6Q/FJhtaEw0=;
        h=Date:To:From:Subject:From;
        b=s2f6gfgP5AG1eBBbaCRXWDhsZHzSJfAdL5zbRqc8nhwYCCg0Xga9IZ2MkvgplrWp7
         LQbRMO6iN2JFdXJhmC7/VCR8b/Cl/vwexGW+6xUfc50A1KNmQA7RKm8UvaQ30+yHXQ
         exFMdf3X2EwGd2CEt5+5BXMKbsbcqrm1pSRmVYfg=
Date:   Wed, 14 Jun 2023 13:05:21 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        vishal.moola@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gup_testc-convert-verify_dma_pinned-to-us-folios.patch added to mm-unstable branch
Message-Id: <20230614200521.E84AFC433C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/gup_test.c: convert verify_dma_pinned() to us folios
has been added to the -mm mm-unstable branch.  Its filename is
     mm-gup_testc-convert-verify_dma_pinned-to-us-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-gup_testc-convert-verify_dma_pinned-to-us-folios.patch

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
Subject: mm/gup_test.c: convert verify_dma_pinned() to us folios
Date: Tue, 13 Jun 2023 19:13:10 -0700

verify_dma_pinned() checks that pages are dma-pinned.  We can convert this
to use folios.

Link: https://lkml.kernel.org/r/20230614021312.34085-4-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
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
mmzone-introduce-folio_is_zone_movable.patch
mmzone-introduce-folio_migratetype.patch
mm-gup_testc-convert-verify_dma_pinned-to-us-folios.patch
mm-gupc-reorganize-try_get_folio.patch
mm-remove-is_longterm_pinnable_page-and-reimplement-folio_is_longterm_pinnable.patch

