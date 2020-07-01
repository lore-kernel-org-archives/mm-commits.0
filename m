From: akpm@linux-foundation.org
Subject: + mm-page_alloc-fallbacks-at-most-has-3-elements.patch
 added to -mm tree
Date: Tue, 30 Jun 2020 19:49:04 -0700
Message-ID: <20200701024904.w3AU5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:41302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725988AbgGACtG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 30 Jun 2020 22:49:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, david@redhat.com, richard.weiyang@linux.alibaba.com


The patch titled
     Subject: mm/page_alloc: fallbacks at most has 3 elements
has been added to the -mm tree.  Its filename is
     mm-page_alloc-fallbacks-at-most-has-3-elements.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-fallbacks-at-most-has-3-elements.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-fallbacks-at-most-has-3-elements.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wei Yang <richard.weiyang@linux.alibaba.com>
Subject: mm/page_alloc: fallbacks at most has 3 elements

MIGRAGE_TYPES is used to be the mark of end and there are at most 3
elements for the one dimension array.

Reduce to 3 to save little memory.

Link: http://lkml.kernel.org/r/20200625231022.18784-1-richard.weiyang@linux.alibaba.com
Signed-off-by: Wei Yang <richard.weiyang@linux.alibaba.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_alloc-fallbacks-at-most-has-3-elements
+++ a/mm/page_alloc.c
@@ -2270,7 +2270,7 @@ struct page *__rmqueue_smallest(struct z
  * This array describes the order lists are fallen back to when
  * the free lists for the desirable migrate type are depleted
  */
-static int fallbacks[MIGRATE_TYPES][4] = {
+static int fallbacks[MIGRATE_TYPES][3] = {
 	[MIGRATE_UNMOVABLE]   = { MIGRATE_RECLAIMABLE, MIGRATE_MOVABLE,   MIGRATE_TYPES },
 	[MIGRATE_MOVABLE]     = { MIGRATE_RECLAIMABLE, MIGRATE_UNMOVABLE, MIGRATE_TYPES },
 	[MIGRATE_RECLAIMABLE] = { MIGRATE_UNMOVABLE,   MIGRATE_MOVABLE,   MIGRATE_TYPES },
_

Patches currently in -mm which might be from richard.weiyang@linux.alibaba.com are

mm-mremap-format-the-check-in-move_normal_pmd-same-as-move_huge_pmd.patch
mm-mremap-it-is-sure-to-have-enough-space-when-extent-meets-requirement.patch
mm-mremap-calculate-extent-in-one-place.patch
mm-mremap-start-addresses-are-properly-aligned.patch
mm-sparse-never-partially-remove-memmap-for-early-section.patch
mm-page_allocc-replace-the-definition-of-nr_migratetype_bits-with-pb_migratetype_bits.patch
mm-page_allocc-extract-the-common-part-in-pfn_to_bitidx.patch
mm-page_allocc-simplify-pageblock-bitmap-access.patch
mm-page_allocc-remove-unnecessary-end_bitidx-for-_pfnblock_flags_mask.patch
mm-page_alloc-fallbacks-at-most-has-3-elements.patch
