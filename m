Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 283EDC433F5
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:08:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbiJCVIL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:08:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiJCVGK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:06:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3D354D161
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:05:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 80E73610D5
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:05:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D57CEC433C1;
        Mon,  3 Oct 2022 21:05:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831136;
        bh=5EzH+LfOhBohZz0radGwPTZVip2pLvJ8PTza352I43M=;
        h=Date:To:From:Subject:From;
        b=DdfA+ZTjIu+KfjdekZZ7+oqCU0HER95OzUIL8XYRuoXoReZdRe1BKsLALOs+Ynp4j
         eHEOSLwdxfD9HEEdU+fh1Ejs8DUzBaVgR8S+YfOnN1RiDsr+EogKuTl+kqzZkd85gO
         Xzlze47kSwo044EHdXbrxtMfktFjTK3msiUrb5jM=
Date:   Mon, 03 Oct 2022 14:05:36 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] huge_memory-convert-unmap_page-to-unmap_folio.patch removed from -mm tree
Message-Id: <20221003210536.D57CEC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: huge_memory: convert unmap_page() to unmap_folio()
has been removed from the -mm tree.  Its filename was
     huge_memory-convert-unmap_page-to-unmap_folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: huge_memory: convert unmap_page() to unmap_folio()
Date: Fri, 2 Sep 2022 20:46:49 +0100

Remove a folio->page->folio conversion.

Link: https://lkml.kernel.org/r/20220902194653.1739778-54-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

--- a/mm/huge_memory.c~huge_memory-convert-unmap_page-to-unmap_folio
+++ a/mm/huge_memory.c
@@ -2355,13 +2355,12 @@ void vma_adjust_trans_huge(struct vm_are
 	}
 }
 
-static void unmap_page(struct page *page)
+static void unmap_folio(struct folio *folio)
 {
-	struct folio *folio = page_folio(page);
 	enum ttu_flags ttu_flags = TTU_RMAP_LOCKED | TTU_SPLIT_HUGE_PMD |
 		TTU_SYNC;
 
-	VM_BUG_ON_PAGE(!PageHead(page), page);
+	VM_BUG_ON_FOLIO(!folio_test_large(folio), folio);
 
 	/*
 	 * Anon pages need migration entries to preserve them, but file
@@ -2378,7 +2377,7 @@ static void remap_page(struct folio *fol
 {
 	int i = 0;
 
-	/* If unmap_page() uses try_to_migrate() on file, remove this check */
+	/* If unmap_folio() uses try_to_migrate() on file, remove this check */
 	if (!folio_test_anon(folio))
 		return;
 	for (;;) {
@@ -2428,7 +2427,7 @@ static void __split_huge_page_tail(struc
 	 * for example lock_page() which set PG_waiters.
 	 *
 	 * Note that for mapped sub-pages of an anonymous THP,
-	 * PG_anon_exclusive has been cleared in unmap_page() and is stored in
+	 * PG_anon_exclusive has been cleared in unmap_folio() and is stored in
 	 * the migration entry instead from where remap_page() will restore it.
 	 * We can still have PG_anon_exclusive set on effectively unmapped and
 	 * unreferenced sub-pages of an anonymous THP: we can simply drop
@@ -2700,7 +2699,7 @@ int split_huge_page_to_list(struct page
 	}
 
 	/*
-	 * Racy check if we can split the page, before unmap_page() will
+	 * Racy check if we can split the page, before unmap_folio() will
 	 * split PMDs
 	 */
 	if (!can_split_folio(folio, &extra_pins)) {
@@ -2708,7 +2707,7 @@ int split_huge_page_to_list(struct page
 		goto out_unlock;
 	}
 
-	unmap_page(&folio->page);
+	unmap_folio(folio);
 
 	/* block interrupt reentry in xa_lock and spinlock */
 	local_irq_disable();
_

Patches currently in -mm which might be from willy@infradead.org are


