Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B204EB64DB
	for <mm-commits@archiver.kernel.org>; Wed, 14 Jun 2023 20:05:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235333AbjFNUFa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Jun 2023 16:05:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235533AbjFNUFZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Jun 2023 16:05:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0AB110EC
        for <mm-commits@vger.kernel.org>; Wed, 14 Jun 2023 13:05:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6574E61500
        for <mm-commits@vger.kernel.org>; Wed, 14 Jun 2023 20:05:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDAD7C433C8;
        Wed, 14 Jun 2023 20:05:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686773123;
        bh=cxqNNW2TdvcBd4iGraa3A87BLoc7Xtw7q54DCWv8QnE=;
        h=Date:To:From:Subject:From;
        b=rP4T+7wachNP/RXIpQkGm98TXg/WQfXqvpfgD1agQpR4eKkQ+OPdLFMosggZbn6Je
         DUGGgnUS13VSHAyZF1glNVtTeIvGHhSHWSmtOj5hkcnAmjqcedKjf4uFBBNUqfB1Hk
         zD6Tythf54mAibZ16Xr4fnygZnXepyuz1H5DfnPg=
Date:   Wed, 14 Jun 2023 13:05:23 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        vishal.moola@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gupc-reorganize-try_get_folio.patch added to mm-unstable branch
Message-Id: <20230614200523.BDAD7C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/gup.c: reorganize try_get_folio()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-gupc-reorganize-try_get_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-gupc-reorganize-try_get_folio.patch

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
Subject: mm/gup.c: reorganize try_get_folio()
Date: Tue, 13 Jun 2023 19:13:11 -0700

try_get_folio() takes in a page, then chooses to do some folio operations
based on the flags (either FOLL_GET or FOLL_PIN).  We can rewrite this
function to be more purpose oriented.

After calling try_get_folio(), if neither FOLL_GET nor FOLL_PIN are set,
warn and fail.  If FOLL_GET is set we can return the result.  If FOLL_GET
is not set then FOLL_PIN is set, so we pin the folio.

This change assists with folio conversions, and makes the function more
readable.

Link: https://lkml.kernel.org/r/20230614021312.34085-5-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |   88 ++++++++++++++++++++++++++---------------------------
 1 file changed, 44 insertions(+), 44 deletions(-)

--- a/mm/gup.c~mm-gupc-reorganize-try_get_folio
+++ a/mm/gup.c
@@ -124,58 +124,58 @@ retry:
  */
 struct folio *try_grab_folio(struct page *page, int refs, unsigned int flags)
 {
+	struct folio *folio;
+
+	if (WARN_ON_ONCE((flags & (FOLL_GET | FOLL_PIN)) == 0))
+		return NULL;
+
 	if (unlikely(!(flags & FOLL_PCI_P2PDMA) && is_pci_p2pdma_page(page)))
 		return NULL;
 
+	folio = try_get_folio(page, refs);
+
 	if (flags & FOLL_GET)
-		return try_get_folio(page, refs);
-	else if (flags & FOLL_PIN) {
-		struct folio *folio;
-
-		/*
-		 * Can't do FOLL_LONGTERM + FOLL_PIN gup fast path if not in a
-		 * right zone, so fail and let the caller fall back to the slow
-		 * path.
-		 */
-		if (unlikely((flags & FOLL_LONGTERM) &&
-			     !is_longterm_pinnable_page(page)))
-			return NULL;
-
-		/*
-		 * CAUTION: Don't use compound_head() on the page before this
-		 * point, the result won't be stable.
-		 */
-		folio = try_get_folio(page, refs);
-		if (!folio)
-			return NULL;
-
-		/*
-		 * When pinning a large folio, use an exact count to track it.
-		 *
-		 * However, be sure to *also* increment the normal folio
-		 * refcount field at least once, so that the folio really
-		 * is pinned.  That's why the refcount from the earlier
-		 * try_get_folio() is left intact.
-		 */
-		if (folio_test_large(folio))
-			atomic_add(refs, &folio->_pincount);
-		else
-			folio_ref_add(folio,
-					refs * (GUP_PIN_COUNTING_BIAS - 1));
-		/*
-		 * Adjust the pincount before re-checking the PTE for changes.
-		 * This is essentially a smp_mb() and is paired with a memory
-		 * barrier in page_try_share_anon_rmap().
-		 */
-		smp_mb__after_atomic();
+		return folio;
 
-		node_stat_mod_folio(folio, NR_FOLL_PIN_ACQUIRED, refs);
+	/* FOLL_PIN is set */
+	if (!folio)
+		return NULL;
 
-		return folio;
+	/*
+	 * Can't do FOLL_LONGTERM + FOLL_PIN gup fast path if not in a
+	 * right zone, so fail and let the caller fall back to the slow
+	 * path.
+	 */
+	if (unlikely((flags & FOLL_LONGTERM) &&
+		     !folio_is_longterm_pinnable(folio))) {
+		if (!put_devmap_managed_page_refs(&folio->page, refs))
+			folio_put_refs(folio, refs);
+		return NULL;
 	}
 
-	WARN_ON_ONCE(1);
-	return NULL;
+	/*
+	 * When pinning a large folio, use an exact count to track it.
+	 *
+	 * However, be sure to *also* increment the normal folio
+	 * refcount field at least once, so that the folio really
+	 * is pinned.  That's why the refcount from the earlier
+	 * try_get_folio() is left intact.
+	 */
+	if (folio_test_large(folio))
+		atomic_add(refs, &folio->_pincount);
+	else
+		folio_ref_add(folio,
+				refs * (GUP_PIN_COUNTING_BIAS - 1));
+	/*
+	 * Adjust the pincount before re-checking the PTE for changes.
+	 * This is essentially a smp_mb() and is paired with a memory
+	 * barrier in page_try_share_anon_rmap().
+	 */
+	smp_mb__after_atomic();
+
+	node_stat_mod_folio(folio, NR_FOLL_PIN_ACQUIRED, refs);
+
+	return folio;
 }
 
 static void gup_put_folio(struct folio *folio, int refs, unsigned int flags)
_

Patches currently in -mm which might be from vishal.moola@gmail.com are

afs-fix-dangling-folio-ref-counts-in-writeback.patch
afs-fix-waiting-for-writeback-then-skipping-folio.patch
mmzone-introduce-folio_is_zone_movable.patch
mmzone-introduce-folio_migratetype.patch
mm-gup_testc-convert-verify_dma_pinned-to-us-folios.patch
mm-gupc-reorganize-try_get_folio.patch
mm-remove-is_longterm_pinnable_page-and-reimplement-folio_is_longterm_pinnable.patch

