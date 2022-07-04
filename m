Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3302AC433EF
	for <mm-commits@archiver.kernel.org>; Mon,  4 Jul 2022 00:02:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230101AbiGDACV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 3 Jul 2022 20:02:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229918AbiGDACU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 3 Jul 2022 20:02:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E11B60EA
        for <mm-commits@vger.kernel.org>; Sun,  3 Jul 2022 17:02:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B54D6B80BD1
        for <mm-commits@vger.kernel.org>; Mon,  4 Jul 2022 00:02:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 591AEC341C6;
        Mon,  4 Jul 2022 00:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656892937;
        bh=kOqyaYBAf437Zqc61zndAf+GUkUoQYrCj4XXNJgBVs0=;
        h=Date:To:From:Subject:From;
        b=ukUaQiBlUCB0WNi4CJJQHSSrNgjmlE5oMiXlaQBHu2YyjPsGQnnQHsc8qDzSaWqYE
         2miy1J18d24C9ov9Ufe4zPRdF2p1DkCl+KrNl6TjA3MCXNoyyJS2wNk3jKBDEKg8Ud
         J+U+LSB9gRJSQbXcq6sYTq4GlUBa8qH4zLya6qNY=
Date:   Sun, 03 Jul 2022 17:02:16 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        sfr@canb.auug.org.au, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-convert-destroy_compound_page-to-destroy_large_folio-fix.patch removed from -mm tree
Message-Id: <20220704000217.591AEC341C6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-convert-destroy_compound_page-to-destroy_large_folio-fix
has been removed from the -mm tree.  Its filename was
     mm-convert-destroy_compound_page-to-destroy_large_folio-fix.patch

This patch was dropped because it was folded into mm-convert-destroy_compound_page-to-destroy_large_folio.patch

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
@@ -744,6 +744,14 @@ void prep_compound_page(struct page *pag
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

mm-convert-destroy_compound_page-to-destroy_large_folio.patch
mm-madvise-minor-cleanup-for-swapin_walk_pmd_entry-fix.patch
mm-docs-fix-comments-that-mention-mem_hotplug_end-fix.patch
android-binder-stop-saving-a-pointer-to-the-vma-fix.patch
mm-remove-the-vma-linked-list-fix-2-fix.patch
mm-drop-oom-code-from-exit_mmap-fix-fix.patch
mm-add-merging-after-mremap-resize-checkpatch-fixes.patch
mm-handling-non-lru-pages-returned-by-vm_normal_pages-fix.patch
mm-factor-helpers-for-memory_failure_dev_pagemap-fix.patch
xfs-support-cow-in-fsdax-mode-fix.patch
mm-thp-kill-transparent_hugepage_active-fix.patch
mm-thp-kill-transparent_hugepage_active-fix-fix.patch
x86-mm-move-protection_map-inside-the-platform-fix.patch

