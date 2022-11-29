Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B96D3C433FE
	for <mm-commits@archiver.kernel.org>; Tue, 29 Nov 2022 21:56:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235880AbiK2V4f (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 29 Nov 2022 16:56:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236188AbiK2V42 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 29 Nov 2022 16:56:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F4CC6D951
        for <mm-commits@vger.kernel.org>; Tue, 29 Nov 2022 13:56:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EEDB86190F
        for <mm-commits@vger.kernel.org>; Tue, 29 Nov 2022 21:56:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 522A3C433D6;
        Tue, 29 Nov 2022 21:56:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669758985;
        bh=Ekk0fb3UAKDAB7IkGd6T1vDQOBswfGJ1DWKZbe0V4g4=;
        h=Date:To:From:Subject:From;
        b=ki1PpvfGln/tyIdRONlzG2McFd862oeiwGYEuYoF7+12yUUyzTQhx5oSLnaMoBmQ3
         Sg8snK2aJoYBZVQ0rhFqNmLMVdIDDLaLtPfiOinXBQ/EPnINH8XZkpXtAUCFAkiTJ5
         ptWzS3GsywMJIWig8O5XUPPF+8pabvdgNprg7v4A=
Date:   Tue, 29 Nov 2022 13:56:24 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        mszeredi@redhat.com, mike.kravetz@oracle.com,
        vishal.moola@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + khugepage-replace-lru_cache_add-with-folio_add_lru.patch added to mm-unstable branch
Message-Id: <20221129215625.522A3C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: khugepage: replace lru_cache_add() with folio_add_lru()
has been added to the -mm mm-unstable branch.  Its filename is
     khugepage-replace-lru_cache_add-with-folio_add_lru.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/khugepage-replace-lru_cache_add-with-folio_add_lru.patch

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
Subject: khugepage: replace lru_cache_add() with folio_add_lru()
Date: Tue, 1 Nov 2022 10:53:25 -0700

Replaces some calls with their folio equivalents.  This is in preparation
for the removal of lru_cache_add().  This replaces 3 calls to
compound_head() with 1.

Link: https://lkml.kernel.org/r/20221101175326.13265-5-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/mm/khugepaged.c~khugepage-replace-lru_cache_add-with-folio_add_lru
+++ a/mm/khugepaged.c
@@ -2013,6 +2013,7 @@ xa_unlocked:
 
 	if (result == SCAN_SUCCEED) {
 		struct page *page, *tmp;
+		struct folio *folio;
 
 		/*
 		 * Replacing old pages with new one has succeeded, now we
@@ -2040,11 +2041,13 @@ xa_unlocked:
 			index++;
 		}
 
-		SetPageUptodate(hpage);
-		page_ref_add(hpage, HPAGE_PMD_NR - 1);
+		folio = page_folio(hpage);
+		folio_mark_uptodate(folio);
+		folio_ref_add(folio, HPAGE_PMD_NR - 1);
+
 		if (is_shmem)
-			set_page_dirty(hpage);
-		lru_cache_add(hpage);
+			folio_mark_dirty(folio);
+		folio_add_lru(folio);
 
 		/*
 		 * Remove pte page tables, so we can re-fault the page as huge.
_

Patches currently in -mm which might be from vishal.moola@gmail.com are

ext4-convert-move_extent_per_page-to-use-folios.patch
khugepage-replace-try_to_release_page-with-filemap_release_folio.patch
memory-failure-convert-truncate_error_page-to-use-folio.patch
folio-compat-remove-try_to_release_page.patch
filemap-convert-replace_page_cache_page-to-replace_page_cache_folio.patch
fuse-convert-fuse_try_move_page-to-use-folios.patch
userfualtfd-replace-lru_cache-functions-with-folio_add-functions.patch
khugepage-replace-lru_cache_add-with-folio_add_lru.patch
folio-compat-remove-lru_cache_add.patch

