Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40FC9C4332F
	for <mm-commits@archiver.kernel.org>; Fri,  4 Nov 2022 22:53:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229537AbiKDWxZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 4 Nov 2022 18:53:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230312AbiKDWwj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 4 Nov 2022 18:52:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0279431ED6
        for <mm-commits@vger.kernel.org>; Fri,  4 Nov 2022 15:52:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 865E2B8301B
        for <mm-commits@vger.kernel.org>; Fri,  4 Nov 2022 22:52:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24BC6C43145;
        Fri,  4 Nov 2022 22:52:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667602354;
        bh=jeMfezq5RtPp251/BJwrQgKhCKkhSltwemKaBTjYa6Q=;
        h=Date:To:From:Subject:From;
        b=JkU2wFsov4W9CtX/osnxZBELL2kMB3Lxa1JO9CiGuBSJ8BzpmUwuEQym4F1cWN0oK
         GG9JoIAJmWhkKCDp0alfCjNjnKODiy5W8WEGiWcX1MEBFxp4NBG6kub6Ug9zvfrBse
         WIWdvgX3HVCESKgbI7VExd4bEa5DOe5BN6LPluO8=
Date:   Fri, 04 Nov 2022 15:52:33 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org, svens@linux.ibm.com,
        peterz@infradead.org, npiggin@gmail.com, nadav.amit@gmail.com,
        jhubbard@nvidia.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, borntraeger@linux.ibm.com,
        aneesh.kumar@linux.ibm.com, agordeev@linux.ibm.com,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-introduce-simplified-versions-of-page_remove_rmap.patch added to mm-unstable branch
Message-Id: <20221104225234.24BC6C43145@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: introduce simplified versions of 'page_remove_rmap()'
has been added to the -mm mm-unstable branch.  Its filename is
     mm-introduce-simplified-versions-of-page_remove_rmap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-introduce-simplified-versions-of-page_remove_rmap.patch

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
From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: mm: introduce simplified versions of 'page_remove_rmap()'
Date: Sun Oct 30 13:26:07 2022 -0700

The rmap handling is proving a bit problematic, and part of it comes from
the complexities of all the different cases of our implementation of
'page_remove_rmap()'.

And a large part of that complexity comes from the fact that while we have
multiple different versions of _adding_ an rmap, this 'remove rmap'
function tries to deal with all possible cases.

So we have these specific versions for page_add_anon_rmap(),
page_add_new_anon_rmap() and page_add_file_rmap() which all do slightly
different things, but then 'page_remove_rmap()' has to handle all the
cases.

That's particularly annoying for 'zap_pte_range()', which already knows
which special case it's dealing with.  It already checked for its own
reasons whether it's an anonymous page, and it already knows it's not the
compound page case and passed in an unconditional 'false' argument.

So this introduces the specialized versions of 'page_remove_rmap()' for
the cases that zap_pte_range() wants.  We also make it the job of the
caller to do the munlock_vma_page(), which is really unrelated and is the
only thing that cares about the 'vma'.

This just means that we end up with several simplifications:

 - there's no 'vma' argument any more, because it's not used

 - there's no 'compound' argument any more, because it was always false

 - we can get rid of the tests for 'compound' and 'PageAnon()' since we
   know what they are

and so instead of having that fairly complicated page_remove_rmap()
function, we end up with a couple of specialized functions that are _much_
simpler.

There is supposed to be no semantic difference from this change, although
this does end up simplifying the code further by moving the
atomic_add_negative() on the PageAnon mapcount to outside the memcg
locking.

That locking protects other data structures (the page state statistics),
and this avoids not only an ugly 'goto', but means that we don't need to
take and release the lock when we're not actually doing anything with the
state statistics.

We also remove the test for PageTransCompound(), since this is only called
for the final pte level from zap_pte_range().

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nadav Amit <nadav.amit@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Aneesh Kumar <aneesh.kumar@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Nick Piggin <npiggin@gmail.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h |    2 +
 mm/memory.c          |    6 +++--
 mm/rmap.c            |   42 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 48 insertions(+), 2 deletions(-)

--- a/include/linux/rmap.h~mm-introduce-simplified-versions-of-page_remove_rmap
+++ a/include/linux/rmap.h
@@ -196,6 +196,8 @@ void page_add_new_anon_rmap(struct page
 		unsigned long address);
 void page_add_file_rmap(struct page *, struct vm_area_struct *,
 		bool compound);
+void page_zap_file_rmap(struct page *);
+void page_zap_anon_rmap(struct page *);
 void page_remove_rmap(struct page *, struct vm_area_struct *,
 		bool compound);
 
--- a/mm/memory.c~mm-introduce-simplified-versions-of-page_remove_rmap
+++ a/mm/memory.c
@@ -1402,9 +1402,11 @@ again:
 				if (pte_young(ptent) &&
 				    likely(!(vma->vm_flags & VM_SEQ_READ)))
 					mark_page_accessed(page);
-			}
+				page_zap_file_rmap(page);
+			} else
+				page_zap_anon_rmap(page);
+			munlock_vma_page(page, vma, false);
 			rss[mm_counter(page)]--;
-			page_remove_rmap(page, vma, false);
 			if (unlikely(page_mapcount(page) < 0))
 				print_bad_pte(vma, addr, ptent, page);
 			if (unlikely(__tlb_remove_page(tlb, page))) {
--- a/mm/rmap.c~mm-introduce-simplified-versions-of-page_remove_rmap
+++ a/mm/rmap.c
@@ -1413,6 +1413,48 @@ static void page_remove_anon_compound_rm
 }
 
 /**
+ * page_zap_file_rmap - take down non-anon pte mapping from a page
+ * @page:	page to remove mapping from
+ *
+ * This is the simplified form of page_remove_rmap(), with:
+ *  - we've already checked for '!PageAnon(page)'
+ *  - 'compound' is always false
+ *  - the caller does 'munlock_vma_page(page, vma, compound)' separately
+ * which allows for a much simpler calling convention.
+ *
+ * The caller holds the pte lock.
+ */
+void page_zap_file_rmap(struct page *page)
+{
+	lock_page_memcg(page);
+	page_remove_file_rmap(page, false);
+	unlock_page_memcg(page);
+}
+
+/**
+ * page_zap_anon_rmap(page) - take down non-anon pte mapping from a page
+ * @page:	page to remove mapping from
+ *
+ * This is the simplified form of page_remove_rmap(), with:
+ *  - we've already checked for 'PageAnon(page)'
+ *  - 'compound' is always false
+ *  - the caller does 'munlock_vma_page(page, vma, compound)' separately
+ * which allows for a much simpler calling convention.
+ *
+ * The caller holds the pte lock.
+ */
+void page_zap_anon_rmap(struct page *page)
+{
+	/* page still mapped by someone else? */
+	if (!atomic_add_negative(-1, &page->_mapcount))
+		return;
+
+	lock_page_memcg(page);
+	__dec_lruvec_page_state(page, NR_ANON_MAPPED);
+	unlock_page_memcg(page);
+}
+
+/**
  * page_remove_rmap - take down pte mapping from a page
  * @page:	page to remove mapping from
  * @vma:	the vm area from which the mapping is removed
_

Patches currently in -mm which might be from torvalds@linux-foundation.org are

mm-introduce-simplified-versions-of-page_remove_rmap.patch
mm-inline-simpler-case-of-page_remove_file_rmap.patch
mm-re-unify-the-simplified-page_zap__rmap-function.patch
mm-delay-rmap-removal-until-after-tlb-flush.patch

