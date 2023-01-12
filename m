Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B7F9C677F1
	for <mm-commits@archiver.kernel.org>; Thu, 12 Jan 2023 22:07:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239969AbjALWHQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 12 Jan 2023 17:07:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239928AbjALWG3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 12 Jan 2023 17:06:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE19876ADE
        for <mm-commits@vger.kernel.org>; Thu, 12 Jan 2023 13:55:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6448662122
        for <mm-commits@vger.kernel.org>; Thu, 12 Jan 2023 21:55:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFBD0C433D2;
        Thu, 12 Jan 2023 21:55:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673560509;
        bh=OLyql2LfnkBZImUmi67l4gkdQCM2hP5b/Lj6nPtE2WU=;
        h=Date:To:From:Subject:From;
        b=byez1ZCNLZNFjLctFDqqBMYv6eQEJUfQn9jkwz38fM8ubfAkYK4ksA2ArIqI3FHYB
         ubGePrP+gbz7VY5vOQ/gxCGJ/7CfFMIqM97VYExfpKx/zoGFd7GrCL5foKkWFg/TXT
         75F18II9ColW1VFn8F/X/+dPLAhXsZdyMHOL9nfY=
Date:   Thu, 12 Jan 2023 13:55:08 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        william.kucharski@oracle.com, vbabka@suse.cz, rppt@kernel.org,
        Liam.Howlett@oracle.com, joel@joelfernandes.org, hughd@google.com,
        geert@linux-m68k.org, corbet@lwn.net, brauner@kernel.org,
        lstoakes@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + documentation-mm-update-references-to-__mlock_page-to-_folio.patch added to mm-unstable branch
Message-Id: <20230112215509.AFBD0C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Documentation/mm: update references to __m[un]lock_page() to *_folio()
has been added to the -mm mm-unstable branch.  Its filename is
     documentation-mm-update-references-to-__mlock_page-to-_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/documentation-mm-update-references-to-__mlock_page-to-_folio.patch

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
From: Lorenzo Stoakes <lstoakes@gmail.com>
Subject: Documentation/mm: update references to __m[un]lock_page() to *_folio()
Date: Thu, 12 Jan 2023 12:39:32 +0000

We now pass folios to these functions, so update the documentation
accordingly.

Additionally, correct the outdated reference to __pagevec_lru_add_fn(),
the referenced action occurs in __munlock_folio() directly now, replace
reference to lru_cache_add_inactive_or_unevictable() with the modern folio
equivalent folio_add_lru_vma() and reference folio flags by the flag name
rather than accessor.

Link: https://lkml.kernel.org/r/898c487169d98a7f09c1c1e57a7dfdc2b3f6bf0f.1673526881.git.lstoakes@gmail.com
Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Joel Fernandes (Google) <joel@joelfernandes.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: William Kucharski <william.kucharski@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/unevictable-lru.rst |   30 ++++++++++++-------------
 1 file changed, 15 insertions(+), 15 deletions(-)

--- a/Documentation/mm/unevictable-lru.rst~documentation-mm-update-references-to-__mlock_page-to-_folio
+++ a/Documentation/mm/unevictable-lru.rst
@@ -308,22 +308,22 @@ do end up getting faulted into this VM_L
 fault path - which is also how mlock2()'s MLOCK_ONFAULT areas are handled.
 
 For each PTE (or PMD) being faulted into a VMA, the page add rmap function
-calls mlock_vma_page(), which calls mlock_page() when the VMA is VM_LOCKED
+calls mlock_vma_page(), which calls mlock_folio() when the VMA is VM_LOCKED
 (unless it is a PTE mapping of a part of a transparent huge page).  Or when
-it is a newly allocated anonymous page, lru_cache_add_inactive_or_unevictable()
-calls mlock_new_page() instead: similar to mlock_page(), but can make better
+it is a newly allocated anonymous page, folio_add_lru_vma() calls
+mlock_new_folio() instead: similar to mlock_folio(), but can make better
 judgments, since this page is held exclusively and known not to be on LRU yet.
 
-mlock_page() sets PageMlocked immediately, then places the page on the CPU's
-mlock pagevec, to batch up the rest of the work to be done under lru_lock by
-__mlock_page().  __mlock_page() sets PageUnevictable, initializes mlock_count
+mlock_folio() sets PG_mlocked immediately, then places the page on the CPU's
+mlock folio batch, to batch up the rest of the work to be done under lru_lock by
+__mlock_folio().  __mlock_folio() sets PG_unevictable, initializes mlock_count
 and moves the page to unevictable state ("the unevictable LRU", but with
-mlock_count in place of LRU threading).  Or if the page was already PageLRU
-and PageUnevictable and PageMlocked, it simply increments the mlock_count.
+mlock_count in place of LRU threading).  Or if the page was already PG_lru
+and PG_unevictable and PG_mlocked, it simply increments the mlock_count.
 
 But in practice that may not work ideally: the page may not yet be on an LRU, or
 it may have been temporarily isolated from LRU.  In such cases the mlock_count
-field cannot be touched, but will be set to 0 later when __pagevec_lru_add_fn()
+field cannot be touched, but will be set to 0 later when __munlock_folio()
 returns the page to "LRU".  Races prohibit mlock_count from being set to 1 then:
 rather than risk stranding a page indefinitely as unevictable, always err with
 mlock_count on the low side, so that when munlocked the page will be rescued to
@@ -377,8 +377,8 @@ that it is munlock() being performed.
 
 munlock_page() uses the mlock pagevec to batch up work to be done under
 lru_lock by  __munlock_page().  __munlock_page() decrements the page's
-mlock_count, and when that reaches 0 it clears PageMlocked and clears
-PageUnevictable, moving the page from unevictable state to inactive LRU.
+mlock_count, and when that reaches 0 it clears PG_mlocked and clears
+PG_unevictable, moving the page from unevictable state to inactive LRU.
 
 But in practice that may not work ideally: the page may not yet have reached
 "the unevictable LRU", or it may have been temporarily isolated from it.  In
@@ -488,8 +488,8 @@ munlock_vma_page(), which calls munlock_
 
 munlock_page() uses the mlock pagevec to batch up work to be done under
 lru_lock by  __munlock_page().  __munlock_page() decrements the page's
-mlock_count, and when that reaches 0 it clears PageMlocked and clears
-PageUnevictable, moving the page from unevictable state to inactive LRU.
+mlock_count, and when that reaches 0 it clears PG_mlocked and clears
+PG_unevictable, moving the page from unevictable state to inactive LRU.
 
 But in practice that may not work ideally: the page may not yet have reached
 "the unevictable LRU", or it may have been temporarily isolated from it.  In
@@ -515,7 +515,7 @@ munlocking by clearing VM_LOCKED from a
 present, if one of those pages were unmapped by truncation or hole punch before
 mlock_pte_range() reached it, it would not be recognized as mlocked by this VMA,
 and would not be counted out of mlock_count.  In this rare case, a page may
-still appear as PageMlocked after it has been fully unmapped: and it is left to
+still appear as PG_mlocked after it has been fully unmapped: and it is left to
 release_pages() (or __page_cache_release()) to clear it and update statistics
 before freeing (this event is counted in /proc/vmstat unevictable_pgs_cleared,
 which is usually 0).
@@ -527,7 +527,7 @@ Page Reclaim in shrink_*_list()
 vmscan's shrink_active_list() culls any obviously unevictable pages -
 i.e. !page_evictable(page) pages - diverting those to the unevictable list.
 However, shrink_active_list() only sees unevictable pages that made it onto the
-active/inactive LRU lists.  Note that these pages do not have PageUnevictable
+active/inactive LRU lists.  Note that these pages do not have PG_unevictable
 set - otherwise they would be on the unevictable list and shrink_active_list()
 would never see them.
 
_

Patches currently in -mm which might be from lstoakes@gmail.com are

mm-vmalloc-correct-use-of-__gfp_nowarn-mask-in-__vmalloc_area_node.patch
selftest-vm-add-mremap-expand-merge-offset-test.patch
mm-pagevec-add-folio_batch_reinit.patch
mm-mlock-use-folios-and-a-folio-batch-internally.patch
m68k-mm-motorola-specify-pmd_page-type.patch
mm-mlock-update-the-interface-to-use-folios.patch
documentation-mm-update-references-to-__mlock_page-to-_folio.patch

