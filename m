Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30CC7C43334
	for <mm-commits@archiver.kernel.org>; Tue, 21 Jun 2022 22:29:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230174AbiFUW3X (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 21 Jun 2022 18:29:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353601AbiFUW3T (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 21 Jun 2022 18:29:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F5383190A
        for <mm-commits@vger.kernel.org>; Tue, 21 Jun 2022 15:29:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0213AB81B2F
        for <mm-commits@vger.kernel.org>; Tue, 21 Jun 2022 22:29:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2459AC3411C;
        Tue, 21 Jun 2022 22:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655850550;
        bh=Y9QpRQbkCC4OcdAbbh+5bJDIlsLorR4PCazGb/m6+bg=;
        h=Date:To:From:Subject:From;
        b=WGgguAPLeooDA7gLzSRL9P4yS/GdMGloHoHwcLwSJ+FhwGccrHuz3imFOw15H2vb3
         xLtfoYGboeQXprRHbvBsnxYhNFBKhhp6ZNxCK5p6V34zB3bCePAWPB43Au0jphvIOo
         csftzGG4jMCmpDVFlug/ldAS5NZT3+Jwi9gZcZbQ=
Date:   Tue, 21 Jun 2022 15:29:02 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        sfr@canb.auug.org.au, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-convert-destroy_compound_page-to-destroy_large_folio-fix.patch added to mm-unstable branch
Message-Id: <20220621222909.2459AC3411C@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-convert-destroy_compound_page-to-destroy_large_folio-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-convert-destroy_compound_page-to-destroy_large_folio-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-convert-destroy_compound_page-to-destroy_large_folio-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-convert-destroy_compound_page-to-destroy_large_folio-fix
Date: Tue Jun 21 03:24:15 PM PDT 2022

uninline destroy_large_folio() to fix build issue

Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    8 +-------
 mm/page_alloc.c    |    8 ++++++++
 2 files changed, 9 insertions(+), 7 deletions(-)

--- a/include/linux/mm.h~mm-convert-destroy_compound_page-to-destroy_large_folio-fix
+++ a/include/linux/mm.h
@@ -923,13 +923,7 @@ static inline void set_compound_page_dto
 	page[1].compound_dtor = compound_dtor;
 }
 
-static inline void destroy_large_folio(struct folio *folio)
-{
-	enum compound_dtor_id dtor = folio_page(folio, 1)->compound_dtor;
-
-	VM_BUG_ON_FOLIO(dtor >= NR_COMPOUND_DTORS, folio);
-	compound_page_dtors[dtor](&folio->page);
-}
+void destroy_large_folio(struct folio *folio);
 
 static inline int head_compound_pincount(struct page *head)
 {
--- a/mm/page_alloc.c~mm-convert-destroy_compound_page-to-destroy_large_folio-fix
+++ a/mm/page_alloc.c
@@ -822,6 +822,14 @@ void prep_compound_page(struct page *pag
 	prep_compound_head(page, order);
 }
 
+void destroy_large_folio(struct folio *folio)
+{
+	enum compound_dtor_id dtor = folio_page(folio, 1)->compound_dtor;
+
+	VM_BUG_ON_FOLIO(dtor >= NR_COMPOUND_DTORS, folio);
+	compound_page_dtors[dtor](&folio->page);
+}
+
 #ifdef CONFIG_DEBUG_PAGEALLOC
 unsigned int _debug_guardpage_minorder;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-start-tracking-vmas-with-maple-tree-fix.patch
damon-convert-__damon_va_three_regions-to-use-the-vma-iterator-fix.patch
mm-mmap-use-advanced-maple-tree-api-for-mmap_region-fix-checkpatch-fixes.patch
mm-remove-the-vma-linked-list-fix-fix.patch
mm-remove-the-vma-linked-list-fix-fix-fix.patch
mm-handling-non-lru-pages-returned-by-vm_normal_pages-fix.patch
mm-shrinkers-introduce-debugfs-interface-for-memory-shrinkers-fix.patch
mm-shrinkers-add-scan-interface-for-shrinker-debugfs-fix-fix.patch
mm-drop-oom-code-from-exit_mmap-fix-fix.patch
mm-add-merging-after-mremap-resize-checkpatch-fixes.patch
mm-factor-helpers-for-memory_failure_dev_pagemap-fix.patch
xfs-support-cow-in-fsdax-mode-fix.patch
mm-page_alloc-replace-local_lock-with-normal-spinlock-fix.patch
mm-convert-destroy_compound_page-to-destroy_large_folio-fix.patch
mm-madvise-minor-cleanup-for-swapin_walk_pmd_entry-fix.patch

