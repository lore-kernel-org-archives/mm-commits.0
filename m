Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9602C4167B
	for <mm-commits@archiver.kernel.org>; Tue, 29 Nov 2022 21:56:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236188AbiK2V4g (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 29 Nov 2022 16:56:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236315AbiK2V4a (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 29 Nov 2022 16:56:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACE626C73A
        for <mm-commits@vger.kernel.org>; Tue, 29 Nov 2022 13:56:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5E5FFB8197B
        for <mm-commits@vger.kernel.org>; Tue, 29 Nov 2022 21:56:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DE5AC433D6;
        Tue, 29 Nov 2022 21:56:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669758987;
        bh=UZg09HTQdMs9q7XGYgtGrl4gGsU1ZFDxjG+rwFZJiMA=;
        h=Date:To:From:Subject:From;
        b=1SYu6/48EVJTJmW++kQ8rI47v1wOeK1YJ/DgN91kG1ZRi+KRDMJiDwjJyxkabJuIp
         Qyp0jlwe902rrhvtfVm+P7OV9RGx3NBHkzQENlqRfjIFE6gELiFgwbwf3o6L+KD1fi
         Hmoa0Mt3lLTd7q1ZkGAy08zhKYnD0MdiHRGUHH/c=
Date:   Tue, 29 Nov 2022 13:56:26 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        mszeredi@redhat.com, mike.kravetz@oracle.com,
        vishal.moola@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + folio-compat-remove-lru_cache_add.patch added to mm-unstable branch
Message-Id: <20221129215627.0DE5AC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: folio-compat: remove lru_cache_add()
has been added to the -mm mm-unstable branch.  Its filename is
     folio-compat-remove-lru_cache_add.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/folio-compat-remove-lru_cache_add.patch

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
Subject: folio-compat: remove lru_cache_add()
Date: Tue, 1 Nov 2022 10:53:26 -0700

There are no longer any callers of lru_cache_add(), so remove it.  This
saves 107 bytes of kernel text.  Also cleanup some comments such that they
reference the new folio_add_lru() instead.

Link: https://lkml.kernel.org/r/20221101175326.13265-6-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    1 -
 mm/folio-compat.c    |    6 ------
 mm/truncate.c        |    2 +-
 mm/workingset.c      |    5 ++++-
 4 files changed, 5 insertions(+), 9 deletions(-)

--- a/include/linux/swap.h~folio-compat-remove-lru_cache_add
+++ a/include/linux/swap.h
@@ -381,7 +381,6 @@ void lru_note_cost(struct lruvec *lruvec
 void lru_note_cost_refault(struct folio *);
 void folio_add_lru(struct folio *);
 void folio_add_lru_vma(struct folio *, struct vm_area_struct *);
-void lru_cache_add(struct page *);
 void mark_page_accessed(struct page *);
 void folio_mark_accessed(struct folio *);
 
--- a/mm/folio-compat.c~folio-compat-remove-lru_cache_add
+++ a/mm/folio-compat.c
@@ -76,12 +76,6 @@ bool redirty_page_for_writepage(struct w
 }
 EXPORT_SYMBOL(redirty_page_for_writepage);
 
-void lru_cache_add(struct page *page)
-{
-	folio_add_lru(page_folio(page));
-}
-EXPORT_SYMBOL(lru_cache_add);
-
 void lru_cache_add_inactive_or_unevictable(struct page *page,
 		struct vm_area_struct *vma)
 {
--- a/mm/truncate.c~folio-compat-remove-lru_cache_add
+++ a/mm/truncate.c
@@ -565,7 +565,7 @@ EXPORT_SYMBOL(invalidate_mapping_pages);
  * refcount.  We do this because invalidate_inode_pages2() needs stronger
  * invalidation guarantees, and cannot afford to leave pages behind because
  * shrink_page_list() has a temp ref on them, or because they're transiently
- * sitting in the lru_cache_add() pagevecs.
+ * sitting in the folio_add_lru() pagevecs.
  */
 static int invalidate_complete_folio2(struct address_space *mapping,
 					struct folio *folio)
--- a/mm/workingset.c~folio-compat-remove-lru_cache_add
+++ a/mm/workingset.c
@@ -492,7 +492,10 @@ void workingset_refault(struct folio *fo
 	/* Folio was active prior to eviction */
 	if (workingset) {
 		folio_set_workingset(folio);
-		/* XXX: Move to lru_cache_add() when it supports new vs putback */
+		/*
+		 * XXX: Move to folio_add_lru() when it supports new vs
+		 * putback
+		 */
 		lru_note_cost_refault(folio);
 		mod_lruvec_state(lruvec, WORKINGSET_RESTORE_BASE + file, nr);
 	}
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

