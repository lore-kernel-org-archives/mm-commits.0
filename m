Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9112C19F2A
	for <mm-commits@archiver.kernel.org>; Thu, 11 Aug 2022 21:17:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235852AbiHKVRk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 11 Aug 2022 17:17:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233685AbiHKVRj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 11 Aug 2022 17:17:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 525329AFF3
        for <mm-commits@vger.kernel.org>; Thu, 11 Aug 2022 14:17:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D3DF761316
        for <mm-commits@vger.kernel.org>; Thu, 11 Aug 2022 21:17:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EC8CC433C1;
        Thu, 11 Aug 2022 21:17:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660252657;
        bh=jV9f972G92hy0WZemrFl3TnJXLa41wMsbRMkYCNQBnc=;
        h=Date:To:From:Subject:From;
        b=f4JCliViA3XXPYYmutl4Jr1N7XVz80njHwS4/2nuK1AtIU85gSJPl8JYF9v4fJkhP
         Gzeg7BU+GJFx2iP/sh9Qruu3MiXEzSssDt9wWMgv67NEf/xfOjo6J6DmrwrPnqZU2c
         seAAtxnkjJKx+FZ1CvzhxHXboXNgzhx23GOVUhjw=
Date:   Thu, 11 Aug 2022 14:17:36 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com, vbabka@suse.cz,
        nadav.amit@gmail.com, minchan@kernel.org, kirill@shutemov.name,
        hughd@google.com, david@redhat.com, apopple@nvidia.com,
        andi.kleen@intel.com, aarcange@redhat.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-x86-use-swp_type_bits-in-3-level-swap-macros.patch added to mm-unstable branch
Message-Id: <20220811211737.1EC8CC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/x86: use SWP_TYPE_BITS in 3-level swap macros
has been added to the -mm mm-unstable branch.  Its filename is
     mm-x86-use-swp_type_bits-in-3-level-swap-macros.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-x86-use-swp_type_bits-in-3-level-swap-macros.patch

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
From: Peter Xu <peterx@redhat.com>
Subject: mm/x86: use SWP_TYPE_BITS in 3-level swap macros
Date: Thu, 11 Aug 2022 12:13:25 -0400

Patch series "mm: Remember a/d bits for migration entries", v4.


Problem
=======

When migrating a page, right now we always mark the migrated page as old &
clean.

However that could lead to at least two problems:

  (1) We lost the real hot/cold information while we could have persisted.
      That information shouldn't change even if the backing page is changed
      after the migration,

  (2) There can be always extra overhead on the immediate next access to
      any migrated page, because hardware MMU needs cycles to set the young
      bit again for reads, and dirty bits for write, as long as the
      hardware MMU supports these bits.

Many of the recent upstream works showed that (2) is not something trivial
and actually very measurable.  In my test case, reading 1G chunk of memory
- jumping in page size intervals - could take 99ms just because of the
extra setting on the young bit on a generic x86_64 system, comparing to
4ms if young set.

This issue is originally reported by Andrea Arcangeli.

Solution
========

To solve this problem, this patchset tries to remember the young/dirty
bits in the migration entries and carry them over when recovering the
ptes.

We have the chance to do so because in many systems the swap offset is not
really fully used.  Migration entries use swp offset to store PFN only,
while the PFN is normally not as large as swp offset and normally smaller.
It means we do have some free bits in swp offset that we can use to store
things like A/D bits, and that's how this series tried to approach this
problem.

max_swapfile_size() is used here to detect per-arch offset length in swp
entries.  We'll automatically remember the A/D bits when we find that we
have enough swp offset field to keep both the PFN and the extra bits.

Since max_swapfile_size() can be slow, the last two patches cache the
results for it and also swap_migration_ad_supported as a whole.

Known Issues / TODOs
====================

We still haven't taught madvise() to recognize the new A/D bits in
migration entries, namely MADV_COLD/MADV_FREE.  E.g.  when MADV_COLD upon
a migration entry.  It's not clear yet on whether we should clear the A
bit, or we should just drop the entry directly.

We didn't teach idle page tracking on the new migration entries, because
it'll need larger rework on the tree on rmap pgtable walk.  However it
should make it already better because before this patchset page will be
old page after migration, so the series will fix potential false negative
of idle page tracking when pages were migrated before observing.

The other thing is migration A/D bits will not start to working for
private device swap entries.  The code is there for completeness but since
private device swap entries do not yet have fields to store A/D bits, even
if we'll persistent A/D across present pte switching to migration entry,
we'll lose it again when the migration entry converted to private device
swap entry.

Tests
=====

After the patchset applied, the immediate read access test [1] of above 1G
chunk after migration can shrink from 99ms to 4ms.  The test is done by
moving 1G pages from node 0->1->0 then read it in page size jumps.  The
test is with Intel(R) Xeon(R) CPU E5-2630 v4 @ 2.20GHz.

Similar effect can also be measured when writting the memory the 1st time
after migration.

After applying the patchset, both initial immediate read/write after page
migrated will perform similarly like before migration happened.

Patch Layout
============

Patch 1-2:  Cleanups from either previous versions or on swapops.h macros.

Patch 3-4:  Prepare for the introduction of migration A/D bits

Patch 5:    The core patch to remember young/dirty bit in swap offsets.

Patch 6-7:  Cache relevant fields to make migration_entry_supports_ad() fast.

[1] https://github.com/xzpeter/clibs/blob/master/misc/swap-young.c


This patch (of 7):

Replace all the magic "5" with the macro.

Link: https://lkml.kernel.org/r/20220811161331.37055-1-peterx@redhat.com
Link: https://lkml.kernel.org/r/20220811161331.37055-2-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Huang Ying <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: "Kirill A . Shutemov" <kirill@shutemov.name>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Andi Kleen <andi.kleen@intel.com>
Cc: Nadav Amit <nadav.amit@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/pgtable-3level.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/arch/x86/include/asm/pgtable-3level.h~mm-x86-use-swp_type_bits-in-3-level-swap-macros
+++ a/arch/x86/include/asm/pgtable-3level.h
@@ -256,10 +256,10 @@ static inline pud_t native_pudp_get_and_
 /* We always extract/encode the offset by shifting it all the way up, and then down again */
 #define SWP_OFFSET_SHIFT	(SWP_OFFSET_FIRST_BIT + SWP_TYPE_BITS)
 
-#define MAX_SWAPFILES_CHECK() BUILD_BUG_ON(MAX_SWAPFILES_SHIFT > 5)
-#define __swp_type(x)			(((x).val) & 0x1f)
-#define __swp_offset(x)			((x).val >> 5)
-#define __swp_entry(type, offset)	((swp_entry_t){(type) | (offset) << 5})
+#define MAX_SWAPFILES_CHECK() BUILD_BUG_ON(MAX_SWAPFILES_SHIFT > SWP_TYPE_BITS)
+#define __swp_type(x)			(((x).val) & ((1UL << SWP_TYPE_BITS) - 1))
+#define __swp_offset(x)			((x).val >> SWP_TYPE_BITS)
+#define __swp_entry(type, offset)	((swp_entry_t){(type) | (offset) << SWP_TYPE_BITS})
 
 /*
  * Normally, __swp_entry() converts from arch-independent swp_entry_t to
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-smaps-dont-access-young-dirty-bit-if-pte-unpresent.patch
mm-uffd-reset-write-protection-when-unregister-with-wp-mode.patch
mm-x86-use-swp_type_bits-in-3-level-swap-macros.patch
mm-swap-comment-all-the-ifdef-in-swapopsh.patch
mm-swap-add-swp_offset_pfn-to-fetch-pfn-from-swap-entry.patch
mm-thp-carry-over-dirty-bit-when-thp-splits-on-pmd.patch
mm-remember-young-dirty-bit-for-page-migrations.patch
mm-swap-cache-maximum-swapfile-size-when-init-swap.patch
mm-swap-cache-swap-migration-a-d-bits-support.patch

