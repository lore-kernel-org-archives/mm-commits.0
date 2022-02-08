Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91C9EC3527A
	for <mm-commits@archiver.kernel.org>; Tue,  8 Feb 2022 22:26:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387641AbiBHWZ5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Feb 2022 17:25:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387086AbiBHVyF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Feb 2022 16:54:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA850C0612B8
        for <mm-commits@vger.kernel.org>; Tue,  8 Feb 2022 13:54:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 82ABD614EB
        for <mm-commits@vger.kernel.org>; Tue,  8 Feb 2022 21:54:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5E1AC340ED;
        Tue,  8 Feb 2022 21:54:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1644357244;
        bh=r2FvIVkVRFePV4cjuyxHMqhD8e/yWFTLQyJDYCeGogM=;
        h=Date:To:From:Subject:From;
        b=2hip3evAA76u3phrWtcOjCeCKb3Os5h2o5aGmPCBirEwRcsOFCH1oKcI7/RH1UZtU
         JC4T6B6dU1BGEL/bjRHiaZwY8DTxxhPzZedPxrBJCYo+306jrFkmDIlAXGLevtg9ml
         qUzvZHRxD9pb24FG5CQiX0cmasrVWReT7MLAnPLg=
Date:   Tue, 08 Feb 2022 13:54:03 -0800
To:     mm-commits@vger.kernel.org, yuzhao@google.com, willy@infradead.org,
        vbabka@suse.cz, surenb@google.com, shakeelb@google.com,
        riel@surriel.com, mhocko@suse.com, kirill@shutemov.name,
        hannes@cmpxchg.org, gthelen@google.com, david@redhat.com,
        apopple@nvidia.com, hughd@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migrate-__unmap_and_move-push-good-newpage-to-lru.patch added to -mm tree
Message-Id: <20220208215403.D5E1AC340ED@smtp.kernel.org>
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

Link: https://lkml.kernel.org/r/33fb71cf-ea55-123a-bf9d-fdad297cae1@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
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
Cc: Vlastimil Babka <vbabka@suse.cz>
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

