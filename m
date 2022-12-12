Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E23CFC001B2
	for <mm-commits@archiver.kernel.org>; Mon, 12 Dec 2022 02:15:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231341AbiLLCPP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Dec 2022 21:15:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231265AbiLLCOc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Dec 2022 21:14:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A9ABDECE
        for <mm-commits@vger.kernel.org>; Sun, 11 Dec 2022 18:14:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AC2CA60EB9
        for <mm-commits@vger.kernel.org>; Mon, 12 Dec 2022 02:14:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1176FC433D2;
        Mon, 12 Dec 2022 02:14:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670811253;
        bh=b9VKesBjpncgGVtIYGYM9chl/LD39F7mHmMIQ45FaXM=;
        h=Date:To:From:Subject:From;
        b=Kl5fNAIDeDvzu+vDXpQolJcVA2iOGkO9AiJFXSCNs74SUReIuc6CSLbmwyxzRlUTn
         GLx+xU8uaH7ykhhNp/XKBMu6R0h9MPddvlXSAH4y4bA88wu01B2I30jPw4NaxjfrKI
         SM+O19pQ8fDJjJCIhpKCMKYpsoTDaq4VNP6HxN24=
Date:   Sun, 11 Dec 2022 18:14:12 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        mszeredi@redhat.com, mike.kravetz@oracle.com,
        vishal.moola@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] folio-compat-remove-lru_cache_add.patch removed from -mm tree
Message-Id: <20221212021413.1176FC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: folio-compat: remove lru_cache_add()
has been removed from the -mm tree.  Its filename was
     folio-compat-remove-lru_cache_add.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: folio-compat: remove lru_cache_add()
Date: Tue, 1 Nov 2022 10:53:26 -0700

There are no longer any callers of lru_cache_add(), so remove it.  This
saves 79 bytes of kernel text.  Also cleanup some comments such that
they reference the new folio_add_lru() instead.

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


