Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8F18C63797
	for <mm-commits@archiver.kernel.org>; Mon, 16 Jan 2023 21:36:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233779AbjAPVgr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 16 Jan 2023 16:36:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230238AbjAPVgq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 16 Jan 2023 16:36:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BA6E2BEDE
        for <mm-commits@vger.kernel.org>; Mon, 16 Jan 2023 13:36:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 386766114C
        for <mm-commits@vger.kernel.org>; Mon, 16 Jan 2023 21:36:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CCE7C433F0;
        Mon, 16 Jan 2023 21:36:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673905003;
        bh=Od0zKaR+Sug+E/1MqDFj5FyoCumim4+b7EU8vguph/8=;
        h=Date:To:From:Subject:From;
        b=remwyiqL985KxRtBUsk7rEHUsuqPi39n1HbuP3Vw0CvLlKjyGxxcJBhAAYbWJ7Dq/
         1WlK1v7nJrSEDLJvSNCc/FiUTxEbpSszVBC6gCaIn6s+7tm3Ze4p2Yay1q6vfRw38o
         yMTI5S4gLue8AViX978o9Xz9ZBFKWiRB6SFxSHGw=
Date:   Mon, 16 Jan 2023 13:36:42 -0800
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, xhao@linux.alibaba.com,
        willy@infradead.org, shy828301@gmail.com, osalvador@suse.de,
        minchan@kernel.org, bharata@amd.com, baolin.wang@linux.alibaba.com,
        apopple@nvidia.com, ying.huang@intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + migrate_pages-batch-flushing-tlb.patch added to mm-unstable branch
Message-Id: <20230116213643.8CCE7C433F0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: migrate_pages: batch flushing TLB
has been added to the -mm mm-unstable branch.  Its filename is
     migrate_pages-batch-flushing-tlb.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/migrate_pages-batch-flushing-tlb.patch

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
From: Huang Ying <ying.huang@intel.com>
Subject: migrate_pages: batch flushing TLB
Date: Mon, 16 Jan 2023 14:30:56 +0800

The TLB flushing will cost quite some CPU cycles during the folio
migration in some situations.  For example, when migrate a folio of a
process with multiple active threads that run on multiple CPUs.  After
batching the _unmap and _move in migrate_pages(), the TLB flushing can be
batched easily with the existing TLB flush batching mechanism.  This patch
implements that.

We use the following test case to test the patch.

On a 2-socket Intel server,

- Run pmbench memory accessing benchmark

- Run `migratepages` to migrate pages of pmbench between node 0 and
  node 1 back and forth.

With the patch, the TLB flushing IPI reduces 99.1% during the test and the
number of pages migrated successfully per second increases 291.7%.

NOTE: TLB flushing is batched only for normal folios, not for THP folios. 
Because the overhead of TLB flushing for THP folios is much lower than
that for normal folios (about 1/512 on x86 platform).

Link: https://lkml.kernel.org/r/20230116063057.653862-9-ying.huang@intel.com
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Bharata B Rao <bharata@amd.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: haoxin <xhao@linux.alibaba.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/migrate.c~migrate_pages-batch-flushing-tlb
+++ a/mm/migrate.c
@@ -1247,7 +1247,7 @@ static int migrate_folio_unmap(new_page_
 		/* Establish migration ptes */
 		VM_BUG_ON_FOLIO(folio_test_anon(src) &&
 			       !folio_test_ksm(src) && !anon_vma, src);
-		try_to_migrate(src, 0);
+		try_to_migrate(src, TTU_BATCH_FLUSH);
 		page_was_mapped = 1;
 	}
 
@@ -1797,6 +1797,8 @@ retry:
 	stats->nr_thp_failed += thp_retry;
 	stats->nr_failed_pages += nr_retry_pages;
 move:
+	try_to_unmap_flush();
+
 	retry = 1;
 	for (pass = 0;
 	     pass < NR_MAX_MIGRATE_PAGES_RETRY && (retry || large_retry);
--- a/mm/rmap.c~migrate_pages-batch-flushing-tlb
+++ a/mm/rmap.c
@@ -1951,7 +1951,21 @@ static bool try_to_migrate_one(struct fo
 		} else {
 			flush_cache_page(vma, address, pte_pfn(*pvmw.pte));
 			/* Nuke the page table entry. */
-			pteval = ptep_clear_flush(vma, address, pvmw.pte);
+			if (should_defer_flush(mm, flags)) {
+				/*
+				 * We clear the PTE but do not flush so potentially
+				 * a remote CPU could still be writing to the folio.
+				 * If the entry was previously clean then the
+				 * architecture must guarantee that a clear->dirty
+				 * transition on a cached TLB entry is written through
+				 * and traps if the PTE is unmapped.
+				 */
+				pteval = ptep_get_and_clear(mm, address, pvmw.pte);
+
+				set_tlb_ubc_flush_pending(mm, pte_dirty(pteval));
+			} else {
+				pteval = ptep_clear_flush(vma, address, pvmw.pte);
+			}
 		}
 
 		/* Set the dirty flag on the folio now the pte is gone. */
@@ -2123,10 +2137,10 @@ void try_to_migrate(struct folio *folio,
 
 	/*
 	 * Migration always ignores mlock and only supports TTU_RMAP_LOCKED and
-	 * TTU_SPLIT_HUGE_PMD and TTU_SYNC flags.
+	 * TTU_SPLIT_HUGE_PMD, TTU_SYNC, and TTU_BATCH_FLUSH flags.
 	 */
 	if (WARN_ON_ONCE(flags & ~(TTU_RMAP_LOCKED | TTU_SPLIT_HUGE_PMD |
-					TTU_SYNC)))
+					TTU_SYNC | TTU_BATCH_FLUSH)))
 		return;
 
 	if (folio_is_zone_device(folio) &&
_

Patches currently in -mm which might be from ying.huang@intel.com are

migrate_pages-organize-stats-with-struct-migrate_pages_stats.patch
migrate_pages-separate-hugetlb-folios-migration.patch
migrate_pages-restrict-number-of-pages-to-migrate-in-batch.patch
migrate_pages-split-unmap_and_move-to-_unmap-and-_move.patch
migrate_pages-batch-_unmap-and-_move.patch
migrate_pages-move-migrate_folio_unmap.patch
migrate_pages-share-more-code-between-_unmap-and-_move.patch
migrate_pages-batch-flushing-tlb.patch
migrate_pages-move-thp-hugetlb-migration-support-check-to-simplify-code.patch

