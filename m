Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEE26C433F5
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:07:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229897AbiJCVHY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:07:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229641AbiJCVFs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:05:48 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB7561A38B
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:05:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 001BDCE0E6D
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:05:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E405C433D6;
        Mon,  3 Oct 2022 21:05:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831118;
        bh=Tf4TGx/35cdYa77n4ffvChmUr4KS7THpH3t0LasOYpU=;
        h=Date:To:From:Subject:From;
        b=rwQKQ0M0FAgeZVvCqyJYArtWdPeZI0ShF6Ks1i6/MsN3jL0WQMDZB8mIzgxmYA8nL
         kJ+6+WqtMKis+XdPy+/ZoeuAk/wcmB0nvbwowphRW5/bWGBu0nW3vh8tLLGH65CtDu
         78Z7fi4bV4cjkx+7FMNndcRGgYMAFswpnsaZPQZI=
Date:   Mon, 03 Oct 2022 14:05:17 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-convert-do_swap_page-to-use-swap_cache_get_folio.patch removed from -mm tree
Message-Id: <20221003210518.3E405C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: convert do_swap_page() to use swap_cache_get_folio()
has been removed from the -mm tree.  Its filename was
     mm-convert-do_swap_page-to-use-swap_cache_get_folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: convert do_swap_page() to use swap_cache_get_folio()
Date: Fri, 2 Sep 2022 20:46:33 +0100

Saves a folio->page->folio conversion.

Link: https://lkml.kernel.org/r/20220902194653.1739778-38-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/memory.c~mm-convert-do_swap_page-to-use-swap_cache_get_folio
+++ a/mm/memory.c
@@ -3767,9 +3767,9 @@ vm_fault_t do_swap_page(struct vm_fault
 	if (unlikely(!si))
 		goto out;
 
-	page = lookup_swap_cache(entry, vma, vmf->address);
-	if (page)
-		folio = page_folio(page);
+	folio = swap_cache_get_folio(entry, vma, vmf->address);
+	if (folio)
+		page = folio_file_page(folio, swp_offset(entry));
 	swapcache = folio;
 
 	if (!folio) {
_

Patches currently in -mm which might be from willy@infradead.org are


