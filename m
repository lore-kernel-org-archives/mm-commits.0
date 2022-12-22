Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AB0AC4167B
	for <mm-commits@archiver.kernel.org>; Thu, 22 Dec 2022 21:32:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229743AbiLVVcJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 22 Dec 2022 16:32:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbiLVVcB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 22 Dec 2022 16:32:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AEDD23162
        for <mm-commits@vger.kernel.org>; Thu, 22 Dec 2022 13:32:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C9BD7B81F77
        for <mm-commits@vger.kernel.org>; Thu, 22 Dec 2022 21:31:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 701C6C433EF;
        Thu, 22 Dec 2022 21:31:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1671744717;
        bh=QbOWTzwicpQwtCaW1020dTayfqoPtGzThw2zeEfn0G8=;
        h=Date:To:From:Subject:From;
        b=Q2AtCigBz279wSDFBcLvdFR07n6I91IevPl/skAP+JPxS9IdrljaQcqjkffzXBri/
         CEVDq2eSRxpQ6BSal+g6y+OVJm3uS/D4SXysfrqQkx9h/Pd5gDtK44fSwmPHTWWkaL
         5CH8BO4arZare7PHODAOPLQyrcxlZtMxhBysi6C4=
Date:   Thu, 22 Dec 2022 13:31:56 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        william.kucharski@oracle.com, vbabka@suse.cz, rppt@kernel.org,
        liam.howlett@oracle.com, joel@joelfernandes.org, hughd@google.com,
        corbet@lwn.net, brauner@kernel.org, lstoakes@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + documentation-mm-update-references-to-__mlock_page-to-_folio.patch added to mm-unstable branch
Message-Id: <20221222213157.701C6C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Documentation/mm: Update references to __m[un]lock_page() to *_folio()
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
Subject: Documentation/mm: Update references to __m[un]lock_page() to *_folio()
Date: Thu, 22 Dec 2022 19:48:33 +0000

We now pass folios to these functions, so update the documentation
accordingly.

Additionally, correct the outdated reference to __pagevec_lru_add_fn(), the
referenced action occurs in __munlock_folio() directly now.

Link: https://lkml.kernel.org/r/c0d134f9ef47d803d27c08e347e5133227ca07bf.1671738120.git.lstoakes@gmail.com
Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Joel Fernandes (Google) <joel@joelfernandes.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: William Kucharski <william.kucharski@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/Documentation/mm/unevictable-lru.rst~documentation-mm-update-references-to-__mlock_page-to-_folio
+++ a/Documentation/mm/unevictable-lru.rst
@@ -308,22 +308,22 @@ do end up getting faulted into this VM_L
 fault path - which is also how mlock2()'s MLOCK_ONFAULT areas are handled.
 
 For each PTE (or PMD) being faulted into a VMA, the page add rmap function
-calls mlock_vma_page(), which calls mlock_page() when the VMA is VM_LOCKED
+calls mlock_vma_page(), which calls mlock_folio() when the VMA is VM_LOCKED
 (unless it is a PTE mapping of a part of a transparent huge page).  Or when
 it is a newly allocated anonymous page, lru_cache_add_inactive_or_unevictable()
-calls mlock_new_page() instead: similar to mlock_page(), but can make better
+calls mlock_new_folio() instead: similar to mlock_folio(), but can make better
 judgments, since this page is held exclusively and known not to be on LRU yet.
 
-mlock_page() sets PageMlocked immediately, then places the page on the CPU's
-mlock pagevec, to batch up the rest of the work to be done under lru_lock by
-__mlock_page().  __mlock_page() sets PageUnevictable, initializes mlock_count
+mlock_folio() sets PageMlocked immediately, then places the page on the CPU's
+mlock folio batch, to batch up the rest of the work to be done under lru_lock by
+__mlock_folio().  __mlock_folio() sets PageUnevictable, initializes mlock_count
 and moves the page to unevictable state ("the unevictable LRU", but with
 mlock_count in place of LRU threading).  Or if the page was already PageLRU
 and PageUnevictable and PageMlocked, it simply increments the mlock_count.
 
 But in practice that may not work ideally: the page may not yet be on an LRU, or
 it may have been temporarily isolated from LRU.  In such cases the mlock_count
-field cannot be touched, but will be set to 0 later when __pagevec_lru_add_fn()
+field cannot be touched, but will be set to 0 later when __munlock_folio()
 returns the page to "LRU".  Races prohibit mlock_count from being set to 1 then:
 rather than risk stranding a page indefinitely as unevictable, always err with
 mlock_count on the low side, so that when munlocked the page will be rescued to
_

Patches currently in -mm which might be from lstoakes@gmail.com are

selftest-vm-add-mremap-expand-merge-offset-test.patch
mm-vmalloc-correct-use-of-__gfp_nowarn-mask-in-__vmalloc_area_node.patch
mm-pagevec-add-folio_batch_reinit.patch
mm-mlock-use-folios-and-a-folio-batch-internally.patch
mm-mlock-update-the-interface-to-use-folios.patch
documentation-mm-update-references-to-__mlock_page-to-_folio.patch

