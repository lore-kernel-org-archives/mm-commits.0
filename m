Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7676BC35273
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 00:08:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3902622D05
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 00:08:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725922AbgLPAAi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 19:00:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:34580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730265AbgLOX2S (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 18:28:18 -0500
Date:   Tue, 15 Dec 2020 15:24:31 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608074671;
        bh=umPm25mdXkZMduWjutDf2nNRR613bg2tpS29hVMS1gw=;
        h=From:To:Subject:From;
        b=kl2a+tP5kGZbRWc0Z5l4dMahIIolUoXfQOz5PP7om7HxJ7PczCbhhEx1lm4IiM2bs
         1AdHWRCYTHAAprAmCspu0YV/tuzIX7J1yirHA8q3Et8NhjAbD/vs4vGslXkWmx36mX
         b8dJ7tTjwoh52pPdSfMVNnZMuoLUCjtRBztPc3QI=
From:   akpm@linux-foundation.org
To:     mchehab+huawei@kernel.org, mm-commits@vger.kernel.org,
        willy@infradead.org
Subject:  [merged] mm-fix-kernel-doc-markups.patch removed from -mm
 tree
Message-ID: <20201215232431.1Vv-lBRq6%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix kernel-doc markups
has been removed from the -mm tree.  Its filename was
     mm-fix-kernel-doc-markups.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: mm: fix kernel-doc markups

Kernel-doc markups should use this format:
        identifier - description

Fix some issues on mm files:

1) The definition for get_user_pages_locked() doesn't follow it.  Also,
   it expects a short descrpition at the header, followed by a long one,
   after the parameters.  Fix it.

2) Kernel-doc requires that a kernel-doc markup to be immediately below
   the function prototype, as otherwise it will rename it.  So, move
   get_pfnblock_flags_mask() description to the right place.

3) Make invalidate_mapping_pagevec() to also follow the expected
   kernel-doc format.

While here, fix a few minor English syntax issues, as suggested
by Matthew:
	will used -> will be used
	similar with -> similar to

Link: https://lkml.kernel.org/r/80e85dddc92d333bc2159ee8a2294921612e8745.1605521731.git.mchehab+huawei@kernel.org
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Suggested-by: Mattew Wilcox <willy@infradead.org>	[English fixes]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c        |   24 +++++++++++++-----------
 mm/page_alloc.c |   16 ++++++++--------
 mm/truncate.c   |    6 +++---
 3 files changed, 24 insertions(+), 22 deletions(-)

--- a/mm/gup.c~mm-fix-kernel-doc-markups
+++ a/mm/gup.c
@@ -1845,7 +1845,19 @@ long get_user_pages(unsigned long start,
 EXPORT_SYMBOL(get_user_pages);
 
 /**
- * get_user_pages_locked() is suitable to replace the form:
+ * get_user_pages_locked() - variant of get_user_pages()
+ *
+ * @start:      starting user address
+ * @nr_pages:   number of pages from start to pin
+ * @gup_flags:  flags modifying lookup behaviour
+ * @pages:      array that receives pointers to the pages pinned.
+ *              Should be at least nr_pages long. Or NULL, if caller
+ *              only intends to ensure the pages are faulted in.
+ * @locked:     pointer to lock flag indicating whether lock is held and
+ *              subsequently whether VM_FAULT_RETRY functionality can be
+ *              utilised. Lock must initially be held.
+ *
+ * It is suitable to replace the form:
  *
  *      mmap_read_lock(mm);
  *      do_something()
@@ -1861,16 +1873,6 @@ EXPORT_SYMBOL(get_user_pages);
  *      if (locked)
  *          mmap_read_unlock(mm);
  *
- * @start:      starting user address
- * @nr_pages:   number of pages from start to pin
- * @gup_flags:  flags modifying lookup behaviour
- * @pages:      array that receives pointers to the pages pinned.
- *              Should be at least nr_pages long. Or NULL, if caller
- *              only intends to ensure the pages are faulted in.
- * @locked:     pointer to lock flag indicating whether lock is held and
- *              subsequently whether VM_FAULT_RETRY functionality can be
- *              utilised. Lock must initially be held.
- *
  * We can leverage the VM_FAULT_RETRY functionality in the page fault
  * paths better by using either get_user_pages_locked() or
  * get_user_pages_unlocked().
--- a/mm/page_alloc.c~mm-fix-kernel-doc-markups
+++ a/mm/page_alloc.c
@@ -470,14 +470,6 @@ static inline int pfn_to_bitidx(struct p
 	return (pfn >> pageblock_order) * NR_PAGEBLOCK_BITS;
 }
 
-/**
- * get_pfnblock_flags_mask - Return the requested group of flags for the pageblock_nr_pages block of pages
- * @page: The page within the block of interest
- * @pfn: The target page frame number
- * @mask: mask of bits that the caller is interested in
- *
- * Return: pageblock_bits flags
- */
 static __always_inline
 unsigned long __get_pfnblock_flags_mask(struct page *page,
 					unsigned long pfn,
@@ -496,6 +488,14 @@ unsigned long __get_pfnblock_flags_mask(
 	return (word >> bitidx) & mask;
 }
 
+/**
+ * get_pfnblock_flags_mask - Return the requested group of flags for the pageblock_nr_pages block of pages
+ * @page: The page within the block of interest
+ * @pfn: The target page frame number
+ * @mask: mask of bits that the caller is interested in
+ *
+ * Return: pageblock_bits flags
+ */
 unsigned long get_pfnblock_flags_mask(struct page *page, unsigned long pfn,
 					unsigned long mask)
 {
--- a/mm/truncate.c~mm-fix-kernel-doc-markups
+++ a/mm/truncate.c
@@ -643,9 +643,9 @@ EXPORT_SYMBOL(invalidate_mapping_pages);
  * @end: the offset 'to' which to invalidate (inclusive)
  * @nr_pagevec: invalidate failed page number for caller
  *
- * This helper is similar with invalidate_mapping_pages, except that it accounts
- * for pages that failed to invalidate on a pagevec and count them in
- * @nr_pagevec, which will used by the caller.
+ * This helper is similar to invalidate_mapping_pages(), except that it accounts
+ * for pages that are likely on a pagevec and counts them in @nr_pagevec, which
+ * will be used by the caller.
  */
 void invalidate_mapping_pagevec(struct address_space *mapping,
 		pgoff_t start, pgoff_t end, unsigned long *nr_pagevec)
_

Patches currently in -mm which might be from mchehab+huawei@kernel.org are

resource-fix-kernel-doc-markups.patch

