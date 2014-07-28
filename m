From: akpm@linux-foundation.org
Subject: + mm-fix-page_allocc-kernel-doc-warnings.patch added to -mm tree
Date: Mon, 28 Jul 2014 15:26:10 -0700
Message-ID: <53d6ce02.lOrPxtiVvvwAvYdw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:56367 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509AbaG1W0M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 28 Jul 2014 18:26:12 -0400
Received: by mail-vc0-f202.google.com with SMTP id hq11so1303782vcb.3
        for <mm-commits@vger.kernel.org>; Mon, 28 Jul 2014 15:26:10 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rdunlap@infradead.org, mgorman@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix page_alloc.c kernel-doc warnings
has been added to the -mm tree.  Its filename is
     mm-fix-page_allocc-kernel-doc-warnings.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fix-page_allocc-kernel-doc-warnings.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-page_allocc-kernel-doc-warnings.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: mm: fix page_alloc.c kernel-doc warnings

Fix kernel-doc warnings and function name in mm/page_alloc.c:

Warning(..//mm/page_alloc.c:6074): No description found for parameter 'pfn'
Warning(..//mm/page_alloc.c:6074): No description found for parameter 'mask'
Warning(..//mm/page_alloc.c:6074): Excess function parameter 'start_bitidx' description in 'get_pfnblock_flags_mask'
Warning(..//mm/page_alloc.c:6102): No description found for parameter 'pfn'
Warning(..//mm/page_alloc.c:6102): No description found for parameter 'mask'
Warning(..//mm/page_alloc.c:6102): Excess function parameter 'start_bitidx' description in 'set_pfnblock_flags_mask'

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff -puN mm/page_alloc.c~mm-fix-page_allocc-kernel-doc-warnings mm/page_alloc.c
--- a/mm/page_alloc.c~mm-fix-page_allocc-kernel-doc-warnings
+++ a/mm/page_alloc.c
@@ -6062,11 +6062,13 @@ static inline int pfn_to_bitidx(struct z
 }
 
 /**
- * get_pageblock_flags_group - Return the requested group of flags for the pageblock_nr_pages block of pages
+ * get_pfnblock_flags_mask - Return the requested group of flags for the pageblock_nr_pages block of pages
  * @page: The page within the block of interest
- * @start_bitidx: The first bit of interest to retrieve
- * @end_bitidx: The last bit of interest
- * returns pageblock_bits flags
+ * @pfn: The target page frame number
+ * @end_bitidx: The last bit of interest to retrieve
+ * @mask: mask of bits that the caller is interested in
+ *
+ * Return: pageblock_bits flags
  */
 unsigned long get_pfnblock_flags_mask(struct page *page, unsigned long pfn,
 					unsigned long end_bitidx,
@@ -6091,9 +6093,10 @@ unsigned long get_pfnblock_flags_mask(st
 /**
  * set_pfnblock_flags_mask - Set the requested group of flags for a pageblock_nr_pages block of pages
  * @page: The page within the block of interest
- * @start_bitidx: The first bit of interest
- * @end_bitidx: The last bit of interest
  * @flags: The flags to set
+ * @pfn: The target page frame number
+ * @end_bitidx: The last bit of interest
+ * @mask: mask of bits that the caller is interested in
  */
 void set_pfnblock_flags_mask(struct page *page, unsigned long flags,
 					unsigned long pfn,
_

Patches currently in -mm which might be from rdunlap@infradead.org are

mm-fix-filemapc-pagecache_get_page-kernel-doc-warnings.patch
mm-fix-filemapc-pagecache_get_page-kernel-doc-warnings-fix.patch
mm-fix-filemapc-pagecache_get_page-kernel-doc-warnings-fix-checkpatch-fixes.patch
mm-fix-page_allocc-kernel-doc-warnings.patch
kbuild-explain-stack-protector-strong-config-logic.patch
add-lib-globc.patch
lib-globc-add-config_glob_selftest.patch
libata-use-glob_match-from-lib-globc.patch
panic-add-taint_softlockup.patch
panic-add-taint_softlockup-fix.patch
linux-next.patch
debugging-keep-track-of-page-owners.patch

