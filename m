Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C701FECAAA1
	for <mm-commits@archiver.kernel.org>; Fri,  2 Sep 2022 23:26:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229490AbiIBX0N (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 2 Sep 2022 19:26:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229995AbiIBX0M (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 2 Sep 2022 19:26:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A56A985BE
        for <mm-commits@vger.kernel.org>; Fri,  2 Sep 2022 16:26:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5B54AB82E0B
        for <mm-commits@vger.kernel.org>; Fri,  2 Sep 2022 23:26:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03818C433C1;
        Fri,  2 Sep 2022 23:26:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662161168;
        bh=6+gcx4zGSzHgJ425XURpTnLuvrESz+JGE7iq00uCZRE=;
        h=Date:To:From:Subject:From;
        b=c9atPwE3HrGfaHJ0Ppkg6UC1oFNrCss2a/hlsyVNQ7cwKEgCdtNSnYZwG5VXhGvS/
         w0vnwVARJCPNYj+upecbBmtqZhYGnvJeTowo5BSBCzTBUfzf21bX+czMFG7rOAaJyt
         z5grzQiRfouGotwN6NTi15O8o8zZj9dXItSPAPgU=
Date:   Fri, 02 Sep 2022 16:26:07 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, willy@infradead.org,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-fix-a-lot-of-comments-vs-mglru.patch added to mm-unstable branch
Message-Id: <20220902232608.03818C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-vmscan-fix-a-lot-of-comments-vs-mglru
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmscan-fix-a-lot-of-comments-vs-mglru.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-fix-a-lot-of-comments-vs-mglru.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-vmscan-fix-a-lot-of-comments-vs-mglru
Date: Fri Sep  2 03:39:50 PM PDT 2022

fixups for mglru additions

Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-fix-a-lot-of-comments-vs-mglru
+++ a/mm/vmscan.c
@@ -3643,7 +3643,7 @@ static int folio_update_gen(struct folio
 	do {
 		/* lru_gen_del_folio() has isolated this page? */
 		if (!(old_flags & LRU_GEN_MASK)) {
-			/* for shrink_page_list() */
+			/* for shrink_folio_list() */
 			new_flags = old_flags | BIT(PG_referenced);
 			continue;
 		}
@@ -4571,7 +4571,7 @@ static void lru_gen_age_node(struct pgli
 }
 
 /*
- * This function exploits spatial locality when shrink_page_list() walks the
+ * This function exploits spatial locality when shrink_folio_list() walks the
  * rmap. It scans the adjacent PTEs of a young PTE and promotes hot pages. If
  * the scan was done cacheline efficiently, it adds the PMD entry pointing to
  * the PTE table to the Bloom filter. This forms a feedback loop between the
@@ -4790,7 +4790,7 @@ static bool isolate_folio(struct lruvec
 	if (!folio_test_referenced(folio))
 		set_mask_bits(&folio->flags, LRU_REFS_MASK | LRU_REFS_FLAGS, 0);
 
-	/* for shrink_page_list() */
+	/* for shrink_folio_list() */
 	folio_clear_reclaim(folio);
 	folio_clear_referenced(folio);
 
@@ -4993,7 +4993,7 @@ static int evict_folios(struct lruvec *l
 	if (list_empty(&list))
 		return scanned;
 
-	reclaimed = shrink_page_list(&list, pgdat, sc, &stat, false);
+	reclaimed = shrink_folio_list(&list, pgdat, sc, &stat, false);
 
 	list_for_each_entry(folio, &list, lru) {
 		/* restore LRU_REFS_FLAGS cleared by isolate_folio() */
@@ -5010,7 +5010,7 @@ static int evict_folios(struct lruvec *l
 
 	spin_lock_irq(&lruvec->lru_lock);
 
-	move_pages_to_lru(lruvec, &list);
+	move_folios_to_lru(lruvec, &list);
 
 	walk = current->reclaim_state->mm_walk;
 	if (walk && walk->batched)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-page_alloc-fix-race-condition-between-build_all_zonelists-and-page-allocation-fix.patch
procfs-add-path-to-proc-pid-fdinfo-fix.patch
zsmalloc-zs_object_copy-add-clarifying-comment-fix.patch
mm-gupc-simplify-and-fix-check_and_migrate_movable_pages-return-codes-fix-fix.patch
mm-oom_kill-add-trace-logs-in-process_mrelease-system-call-fix.patch
zsmalloc-zs_object_copy-replace-email-link-to-doc-checkpatch-fixes.patch
mm-demotion-add-support-for-explicit-memory-tiers-fix.patch
mm-demotion-update-node_is_toptier-to-work-with-memory-tiers-fix-2.patch
mm-drop-oom-code-from-exit_mmap-fix-fix.patch
mm-delete-unused-mmf_oom_victim-flag-vs-mglru.patch
mm-add-merging-after-mremap-resize-checkpatch-fixes.patch
mm-gupc-refactor-check_and_migrate_movable_pages-fix.patch
hugetlb-rename-remove_huge_page-to-hugetlb_delete_from_page_cache-fix.patch
hugetlb-handle-truncate-racing-with-page-faults-fix-fix.patch
mm-reduce-noise-in-show_mem-for-lowmem-allocations-vs-mapletree.patch
mm-reduce-noise-in-show_mem-for-lowmem-allocations-vs-mapletree-fix.patch
page_ext-introduce-boot-parameter-early_page_ext-fix.patch
mm-fix-null-ptr-deref-in-kswapd_is_running-fix.patch
mm-vmscan-fix-a-lot-of-comments-vs-mglru.patch
ia64-fix-clock_getresclock_monotonic-to-report-itc-frequency-checkpatch-fixes.patch

