Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01920C2D0A3
	for <mm-commits@archiver.kernel.org>; Mon, 16 Nov 2020 20:23:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A8EF0221EB
	for <mm-commits@archiver.kernel.org>; Mon, 16 Nov 2020 20:23:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="MMnESKaB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730292AbgKPUXs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 16 Nov 2020 15:23:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:53590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730075AbgKPUXs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 16 Nov 2020 15:23:48 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D3B7620781;
        Mon, 16 Nov 2020 20:23:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605558227;
        bh=NwlaeqchM6WYntpa4OqamGl83vJ0KxpsVBDh669V6G4=;
        h=Date:From:To:Subject:From;
        b=MMnESKaB8hSIu9jdajy0KKyaK7PE0dkKgCXZI8afqQ4JGHIX+W+mskp6CEAkPHvTd
         2FWS0xOdaosw5vaM4y9uz5Lw9CLdX34ZBzPEyPJor/sxq02zKKpa4ovr63uyQ8KCyG
         3LZlFCJ8JtYdm+9/2abuB7fKGm54hyfr2OgBPdWk=
Date:   Mon, 16 Nov 2020 12:23:46 -0800
From:   akpm@linux-foundation.org
To:     mchehab+huawei@kernel.org, mm-commits@vger.kernel.org,
        willy@infradead.org
Subject:  + mm-fix-kernel-doc-markups.patch added to -mm tree
Message-ID: <20201116202346.1IWd_gK_S%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix kernel-doc markups
has been added to the -mm tree.  Its filename is
     mm-fix-kernel-doc-markups.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-fix-kernel-doc-markups.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-kernel-doc-markups.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: mm: fix kernel-doc markups

Kernel-doc markups should use this format:
        identifier - description

Fix some issues on mm files:

1) The definition for get_user_pages_locked() doesn't follow
   it. Also, it expects a short descrpition at the header,
   followed by a long one, after the parameters. Fix it.

2) Kernel-doc requires that a kernel-doc markup to be immediatly
   below the function prototype, as otherwise it will rename it.
   So, move get_pfnblock_flags_mask() description to the right
   place.

3) Make invalidate_mapping_pagevec() to also follow the
   expected kernel-doc format.

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
 mm/truncate.c   |   10 ++++++++--
 3 files changed, 29 insertions(+), 21 deletions(-)

--- a/mm/gup.c~mm-fix-kernel-doc-markups
+++ a/mm/gup.c
@@ -1932,7 +1932,19 @@ long get_user_pages(unsigned long start,
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
@@ -1948,16 +1960,6 @@ EXPORT_SYMBOL(get_user_pages);
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
@@ -468,14 +468,6 @@ static inline int pfn_to_bitidx(struct p
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
@@ -494,6 +486,14 @@ unsigned long __get_pfnblock_flags_mask(
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
@@ -580,9 +580,15 @@ unsigned long invalidate_mapping_pages(s
 EXPORT_SYMBOL(invalidate_mapping_pages);
 
 /**
- * This helper is similar with the above one, except that it accounts for pages
- * that are likely on a pagevec and count them in @nr_pagevec, which will used by
+ * invalidate_mapping_pagevec - This helper is similar to
+ * invalidate_mapping_pages(), except that it accounts for pages that are
+ * likely on a pagevec and count them in @nr_pagevec, which will be used by
  * the caller.
+ *
+ * @mapping: the address_space which holds the pages to invalidate
+ * @start: the offset 'from' which to invalidate
+ * @end: the offset 'to' which to invalidate (inclusive)
+ *
  */
 void invalidate_mapping_pagevec(struct address_space *mapping,
 		pgoff_t start, pgoff_t end, unsigned long *nr_pagevec)
_

Patches currently in -mm which might be from mchehab+huawei@kernel.org are

mm-fix-kernel-doc-markups.patch
resource-fix-kernel-doc-markups.patch

