Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E22EC433FE
	for <mm-commits@archiver.kernel.org>; Wed, 16 Feb 2022 00:30:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241008AbiBPAax (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Feb 2022 19:30:53 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245135AbiBPAap (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 15 Feb 2022 19:30:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 130A8FA203
        for <mm-commits@vger.kernel.org>; Tue, 15 Feb 2022 16:30:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A2DB661659
        for <mm-commits@vger.kernel.org>; Wed, 16 Feb 2022 00:30:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F15F2C340EB;
        Wed, 16 Feb 2022 00:30:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1644971426;
        bh=LELsqL4EtrXyIu0DbtYd16EM9l4BOZI/jXhEHemQi+I=;
        h=Date:To:From:Subject:From;
        b=k6Su47eLDbHRgZoCx1Oos7vllPJY+XMWrkp2vrvqbfojc6dWo+8GhxmQ4UBRlCE/h
         lNn+doNW29PAxiQbzscXm5ZTtFksxWTz6yfGKWy0e+edLZ02az916nMmSSFgSyXlpD
         Rv8nDNpkswQBcJwpYKWtE9rpeEwwcqM1OVBvZaVs=
Date:   Tue, 15 Feb 2022 16:30:25 -0800
To:     mm-commits@vger.kernel.org, yuzhao@google.com, willy@infradead.org,
        vbabka@suse.cz, surenb@google.com, shakeelb@google.com,
        riel@surriel.com, mhocko@suse.com, kirill@shutemov.name,
        hannes@cmpxchg.org, gthelen@google.com, david@redhat.com,
        apopple@nvidia.com, hughd@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migrate-__unmap_and_move-push-good-newpage-to-lru.patch added to -mm tree
Message-Id: <20220216003025.F15F2C340EB@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/migrate: __unmap_and_move() push good newpage to LRU
has been added to the -mm tree.  Its filename is
     mm-migrate-__unmap_and_move-push-good-newpage-to-lru.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-migrate-__unmap_and_move-push-good-newpage-to-lru.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-migrate-__unmap_and_move-push-good-newpage-to-lru.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm/migrate: __unmap_and_move() push good newpage to LRU

Compaction, NUMA page movement, THP collapse/split, and memory failure do
isolate unevictable pages from their "LRU", losing the record of
mlock_count in doing so (isolators are likely to use page->lru for their
own private lists, so mlock_count has to be presumed lost).

That's unfortunate, and we should put in some work to correct that: one
can imagine a function to build up the mlock_count again - but it would
require i_mmap_rwsem for read, so be careful where it's called.  Or
page_referenced_one() and try_to_unmap_one() might do that extra work.

But one place that can very easily be improved is page migration's
__unmap_and_move(): a small adjustment to where the successful new page is
put back on LRU, and its mlock_count (if any) is built back up by
remove_migration_ptes().

Link: https://lkml.kernel.org/r/269eec24-978a-984a-8a85-1d29f36ad343@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |   31 +++++++++++++++++++------------
 1 file changed, 19 insertions(+), 12 deletions(-)

--- a/mm/migrate.c~mm-migrate-__unmap_and_move-push-good-newpage-to-lru
+++ a/mm/migrate.c
@@ -1034,6 +1034,21 @@ static int __unmap_and_move(struct page
 	if (!page_mapped(page))
 		rc = move_to_new_page(newpage, page, mode);
 
+	/*
+	 * When successful, push newpage to LRU immediately: so that if it
+	 * turns out to be an mlocked page, remove_migration_ptes() will
+	 * automatically build up the correct newpage->mlock_count for it.
+	 *
+	 * We would like to do something similar for the old page, when
+	 * unsuccessful, and other cases when a page has been temporarily
+	 * isolated from the unevictable LRU: but this case is the easiest.
+	 */
+	if (rc == MIGRATEPAGE_SUCCESS) {
+		lru_cache_add(newpage);
+		if (page_was_mapped)
+			lru_add_drain();
+	}
+
 	if (page_was_mapped)
 		remove_migration_ptes(page,
 			rc == MIGRATEPAGE_SUCCESS ? newpage : page, false);
@@ -1047,20 +1062,12 @@ out_unlock:
 	unlock_page(page);
 out:
 	/*
-	 * If migration is successful, decrease refcount of the newpage
+	 * If migration is successful, decrease refcount of the newpage,
 	 * which will not free the page because new page owner increased
-	 * refcounter. As well, if it is LRU page, add the page to LRU
-	 * list in here. Use the old state of the isolated source page to
-	 * determine if we migrated a LRU page. newpage was already unlocked
-	 * and possibly modified by its owner - don't rely on the page
-	 * state.
+	 * refcounter.
 	 */
-	if (rc == MIGRATEPAGE_SUCCESS) {
-		if (unlikely(!is_lru))
-			put_page(newpage);
-		else
-			putback_lru_page(newpage);
-	}
+	if (rc == MIGRATEPAGE_SUCCESS)
+		put_page(newpage);
 
 	return rc;
 }
_

Patches currently in -mm which might be from hughd@google.com are

mm-munlock-delete-page_mlock-and-all-its-works.patch
mm-munlock-delete-foll_mlock-and-foll_populate.patch
mm-munlock-delete-munlock_vma_pages_all-allow-oomreap.patch
mm-munlock-rmap-call-mlock_vma_page-munlock_vma_page.patch
mm-munlock-replace-clear_page_mlock-by-final-clearance.patch
mm-munlock-maintain-page-mlock_count-while-unevictable.patch
mm-munlock-mlock_pte_range-when-mlocking-or-munlocking.patch
mm-migrate-__unmap_and_move-push-good-newpage-to-lru.patch
mm-munlock-delete-smp_mb-from-__pagevec_lru_add_fn.patch
mm-munlock-mlock_page-munlock_page-batch-by-pagevec.patch
mm-munlock-page-migration-needs-mlock-pagevec-drained.patch
mm-thp-collapse_file-do-try_to_unmapttu_batch_flush.patch
mm-thp-shrink_page_list-avoid-splitting-vm_locked-thp.patch

