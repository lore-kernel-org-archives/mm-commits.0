Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0332DC433FE
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:08:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229666AbiJCVIB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:08:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229770AbiJCVF4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:05:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 885C3DF07
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:05:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1BD31610E7
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:05:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C907C433C1;
        Mon,  3 Oct 2022 21:05:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831132;
        bh=g6ljQ7fVUQeyDsCLvwViVn5eubtPDWFhs9OAWS+UzHY=;
        h=Date:To:From:Subject:From;
        b=z+yyypPHVQcKOUyMwGQHte526zH7L8vjBEBQsLYXPkxnErN/egNydm6kYnAUcBff7
         P5rLZeNoiXIIh5rM4gGlQ9zdY+h6OdU4ZYJTmH+w8e5NhQrRfhM9W2HebEMbhUe7h/
         8Pk/1+5UrckSXC6bwQcRn237hL06msaHVjXjENVU=
Date:   Mon, 03 Oct 2022 14:05:31 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] rmap-convert-page_move_anon_rmap-to-use-a-folio.patch removed from -mm tree
Message-Id: <20221003210532.6C907C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: rmap: convert page_move_anon_rmap() to use a folio
has been removed from the -mm tree.  Its filename was
     rmap-convert-page_move_anon_rmap-to-use-a-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: rmap: convert page_move_anon_rmap() to use a folio
Date: Fri, 2 Sep 2022 20:46:45 +0100

Removes one call to compound_head() and a reference to page->mapping.

Link: https://lkml.kernel.org/r/20220902194653.1739778-50-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

--- a/mm/rmap.c~rmap-convert-page_move_anon_rmap-to-use-a-folio
+++ a/mm/rmap.c
@@ -1099,22 +1099,20 @@ int pfn_mkclean_range(unsigned long pfn,
  */
 void page_move_anon_rmap(struct page *page, struct vm_area_struct *vma)
 {
-	struct anon_vma *anon_vma = vma->anon_vma;
-	struct page *subpage = page;
+	void *anon_vma = vma->anon_vma;
+	struct folio *folio = page_folio(page);
 
-	page = compound_head(page);
-
-	VM_BUG_ON_PAGE(!PageLocked(page), page);
+	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
 	VM_BUG_ON_VMA(!anon_vma, vma);
 
-	anon_vma = (void *) anon_vma + PAGE_MAPPING_ANON;
+	anon_vma += PAGE_MAPPING_ANON;
 	/*
 	 * Ensure that anon_vma and the PAGE_MAPPING_ANON bit are written
 	 * simultaneously, so a concurrent reader (eg folio_referenced()'s
 	 * folio_test_anon()) will not see one without the other.
 	 */
-	WRITE_ONCE(page->mapping, (struct address_space *) anon_vma);
-	SetPageAnonExclusive(subpage);
+	WRITE_ONCE(folio->mapping, anon_vma);
+	SetPageAnonExclusive(page);
 }
 
 /**
_

Patches currently in -mm which might be from willy@infradead.org are


