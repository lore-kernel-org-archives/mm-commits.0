Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B66FBEB64DC
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:27:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229966AbjFSX1U (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:27:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229957AbjFSXZt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:25:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74B0D197
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:23:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 53DB460FAF
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:23:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD7CBC433C0;
        Mon, 19 Jun 2023 23:23:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687217005;
        bh=KW9x0R6zJ5yQpYu8BEaWdndDVmrw6RN6sxuZH/AARVo=;
        h=Date:To:From:Subject:From;
        b=KGgg74M2917THTz56aONTYkUxYibHtRrQg1Hgy4fA6wnA1HTfblEUd4tDA0qu8FSW
         S44F232AAl94iowyOVV1zwHvZb/RCW39aTyuIx9mdOt1DBTyErTLo7eWmajghMhhYw
         WOhg0FyLatbkH6DCtE9PHJf3R6pths2OX5zNM3JE=
Date:   Mon, 19 Jun 2023 16:23:25 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        vishal.moola@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-gupc-reorganize-try_get_folio.patch removed from -mm tree
Message-Id: <20230619232325.AD7CBC433C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/gup.c: reorganize try_get_folio()
has been removed from the -mm tree.  Its filename was
     mm-gupc-reorganize-try_get_folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

