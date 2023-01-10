Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1FC5C67871
	for <mm-commits@archiver.kernel.org>; Tue, 10 Jan 2023 23:54:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235059AbjAJXyS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 Jan 2023 18:54:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235206AbjAJXyQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 Jan 2023 18:54:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DD315567D
        for <mm-commits@vger.kernel.org>; Tue, 10 Jan 2023 15:54:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1C0D061820
        for <mm-commits@vger.kernel.org>; Tue, 10 Jan 2023 23:54:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B814C433D2;
        Tue, 10 Jan 2023 23:54:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673394854;
        bh=BxnSBaGcBH1eeM81Uj0ihxzrkq9YjEpc+QUso/3tZIQ=;
        h=Date:To:From:Subject:From;
        b=cM56ztT/1Ije5SuBlRDz4xp3UraXuGgCROLPt3fE6YUzMrTV2KQlTqOH5sxYNZmKm
         QlkOUaPfOmYf15cxK0nvrDEmbdneyYvZZSmk3kCNB0ia6CQEe3ezwhrJb0J+DGw8aX
         7l8sssCwxkXkXOA2kAHXEyWe70wvOQABy5Xr0Tqs=
Date:   Tue, 10 Jan 2023 15:54:13 -0800
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, xhao@linux.alibaba.com,
        willy@infradead.org, shy828301@gmail.com, osalvador@suse.de,
        bharata@amd.com, baolin.wang@linux.alibaba.com, apopple@nvidia.com,
        ying.huang@intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + migrate_pages-batch-_unmap-and-_move.patch added to mm-unstable branch
Message-Id: <20230110235414.6B814C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: migrate_pages: batch _unmap and _move
has been added to the -mm mm-unstable branch.  Its filename is
     migrate_pages-batch-_unmap-and-_move.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/migrate_pages-batch-_unmap-and-_move.patch

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
Subject: migrate_pages: batch _unmap and _move
Date: Tue, 10 Jan 2023 15:53:23 +0800

In this patch the _unmap and _move stage of the folio migration is
batched.  That for, previously, it is,

  for each folio
    _unmap()
    _move()

Now, it is,

  for each folio
    _unmap()
  for each folio
    _move()

Based on this, we can batch the TLB flushing and use some hardware
accelerator to copy folios between batched _unmap and batched _move
stages.

Link: https://lkml.kernel.org/r/20230110075327.590514-6-ying.huang@intel.com
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Bharata B Rao <bharata@amd.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: haoxin <xhao@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |  205 +++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 181 insertions(+), 24 deletions(-)

--- a/mm/migrate.c~migrate_pages-batch-_unmap-and-_move
+++ a/mm/migrate.c
@@ -1050,6 +1050,33 @@ static void __migrate_folio_extract(stru
 	dst->private = NULL;
 }
 
+/* Restore the source folio to the original state upon failure */
+static void migrate_folio_undo_src(struct folio *src,
+				   int page_was_mapped,
+				   struct anon_vma *anon_vma,
+				   struct list_head *ret)
+{
+	if (page_was_mapped)
+		remove_migration_ptes(src, src, false);
+	/* Drop an anon_vma reference if we took one */
+	if (anon_vma)
+		put_anon_vma(anon_vma);
+	folio_unlock(src);
+	list_move_tail(&src->lru, ret);
+}
+
+/* Restore the destination folio to the original state upon failure */
+static void migrate_folio_undo_dst(struct folio *dst,
+				   free_page_t put_new_page,
+				   unsigned long private)
+{
+	folio_unlock(dst);
+	if (put_new_page)
+		put_new_page(&dst->page, private);
+	else
+		folio_put(dst);
+}
+
 /* Cleanup src folio upon migration success */
 static void migrate_folio_done(struct folio *src,
 			       enum migrate_reason reason)
@@ -1069,7 +1096,7 @@ static void migrate_folio_done(struct fo
 }
 
 static int __migrate_folio_unmap(struct folio *src, struct folio *dst,
-				int force, enum migrate_mode mode)
+				 int force, bool force_lock, enum migrate_mode mode)
 {
 	int rc = -EAGAIN;
 	int page_was_mapped = 0;
@@ -1096,6 +1123,17 @@ static int __migrate_folio_unmap(struct
 		if (current->flags & PF_MEMALLOC)
 			goto out;
 
+		/*
+		 * We have locked some folios, to avoid deadlock, we cannot
+		 * lock the folio synchronously.  Go out to process (and
+		 * unlock) all the locked folios.  Then we can lock the folio
+		 * synchronously.
+		 */
+		if (!force_lock) {
+			rc = -EDEADLOCK;
+			goto out;
+		}
+
 		folio_lock(src);
 	}
 
@@ -1209,6 +1247,8 @@ static int __migrate_folio_move(struct f
 
 	rc = move_to_new_folio(dst, src, mode);
 
+	if (rc != -EAGAIN)
+		list_del(&dst->lru);
 	/*
 	 * When successful, push dst to LRU immediately: so that if it
 	 * turns out to be an mlocked page, remove_migration_ptes() will
@@ -1224,6 +1264,11 @@ static int __migrate_folio_move(struct f
 			lru_add_drain();
 	}
 
+	if (rc == -EAGAIN) {
+		__migrate_folio_record(dst, page_was_mapped, anon_vma);
+		return rc;
+	}
+
 	if (page_was_mapped)
 		remove_migration_ptes(src,
 			rc == MIGRATEPAGE_SUCCESS ? dst : src, false);
@@ -1247,7 +1292,7 @@ static int __migrate_folio_move(struct f
 /* Obtain the lock on page, remove all ptes. */
 static int migrate_folio_unmap(new_page_t get_new_page, free_page_t put_new_page,
 			       unsigned long private, struct folio *src,
-			       struct folio **dstp, int force,
+			       struct folio **dstp, int force, bool force_lock,
 			       enum migrate_mode mode, enum migrate_reason reason,
 			       struct list_head *ret)
 {
@@ -1275,7 +1320,7 @@ static int migrate_folio_unmap(new_page_
 	*dstp = dst;
 
 	dst->private = NULL;
-	rc = __migrate_folio_unmap(src, dst, force, mode);
+	rc = __migrate_folio_unmap(src, dst, force, force_lock, mode);
 	if (rc == MIGRATEPAGE_UNMAP)
 		return rc;
 
@@ -1284,7 +1329,7 @@ static int migrate_folio_unmap(new_page_
 	 * references and be restored.
 	 */
 	/* restore the folio to right list. */
-	if (rc != -EAGAIN)
+	if (rc != -EAGAIN && rc != -EDEADLOCK)
 		list_move_tail(&src->lru, ret);
 
 	if (put_new_page)
@@ -1323,9 +1368,8 @@ static int migrate_folio_move(free_page_
 	 */
 	if (rc == MIGRATEPAGE_SUCCESS) {
 		migrate_folio_done(src, reason);
-	} else {
-		if (rc != -EAGAIN)
-			list_add_tail(&src->lru, ret);
+	} else if (rc != -EAGAIN) {
+		list_add_tail(&src->lru, ret);
 
 		if (put_new_page)
 			put_new_page(&dst->page, private);
@@ -1605,7 +1649,7 @@ static int migrate_pages_batch(struct li
 		enum migrate_mode mode, int reason, struct list_head *ret_folios,
 		struct migrate_pages_stats *stats)
 {
-	int retry = 1;
+	int retry;
 	int large_retry = 1;
 	int thp_retry = 1;
 	int nr_failed = 0;
@@ -1614,13 +1658,19 @@ static int migrate_pages_batch(struct li
 	int pass = 0;
 	bool is_large = false;
 	bool is_thp = false;
-	struct folio *folio, *folio2, *dst = NULL;
-	int rc, nr_pages;
+	struct folio *folio, *folio2, *dst = NULL, *dst2;
+	int rc, rc_saved, nr_pages;
 	LIST_HEAD(split_folios);
+	LIST_HEAD(unmap_folios);
+	LIST_HEAD(dst_folios);
 	bool nosplit = (reason == MR_NUMA_MISPLACED);
 	bool no_split_folio_counting = false;
+	bool force_lock;
 
-split_folio_migration:
+retry:
+	rc_saved = 0;
+	force_lock = true;
+	retry = 1;
 	for (pass = 0;
 	     pass < NR_MAX_MIGRATE_PAGES_RETRY && (retry || large_retry);
 	     pass++) {
@@ -1642,16 +1692,15 @@ split_folio_migration:
 			cond_resched();
 
 			rc = migrate_folio_unmap(get_new_page, put_new_page, private,
-						 folio, &dst, pass > 2, mode,
-						 reason, ret_folios);
-			if (rc == MIGRATEPAGE_UNMAP)
-				rc = migrate_folio_move(put_new_page, private,
-							folio, dst, mode,
-							reason, ret_folios);
+						 folio, &dst, pass > 2, force_lock,
+						 mode, reason, ret_folios);
 			/*
 			 * The rules are:
 			 *	Success: folio will be freed
+			 *	Unmap: folio will be put on unmap_folios list,
+			 *	       dst folio put on dst_folios list
 			 *	-EAGAIN: stay on the from list
+			 *	-EDEADLOCK: stay on the from list
 			 *	-ENOMEM: stay on the from list
 			 *	-ENOSYS: stay on the from list
 			 *	Other errno: put on ret_folios list
@@ -1686,7 +1735,7 @@ split_folio_migration:
 			case -ENOMEM:
 				/*
 				 * When memory is low, don't bother to try to migrate
-				 * other folios, just exit.
+				 * other folios, move unmapped folios, then exit.
 				 */
 				if (is_large) {
 					nr_large_failed++;
@@ -1725,7 +1774,19 @@ split_folio_migration:
 				/* nr_failed isn't updated for not used */
 				nr_large_failed += large_retry;
 				stats->nr_thp_failed += thp_retry;
-				goto out;
+				rc_saved = rc;
+				if (list_empty(&unmap_folios))
+					goto out;
+				else
+					goto move;
+			case -EDEADLOCK:
+				/*
+				 * The folio cannot be locked for potential deadlock.
+				 * Go move (and unlock) all locked folios.  Then we can
+				 * try again.
+				 */
+				rc_saved = rc;
+				goto move;
 			case -EAGAIN:
 				if (is_large) {
 					large_retry++;
@@ -1739,6 +1800,15 @@ split_folio_migration:
 				stats->nr_succeeded += nr_pages;
 				stats->nr_thp_succeeded += is_thp;
 				break;
+			case MIGRATEPAGE_UNMAP:
+				/*
+				 * We have locked some folios, don't force lock
+				 * to avoid deadlock.
+				 */
+				force_lock = false;
+				list_move_tail(&folio->lru, &unmap_folios);
+				list_add_tail(&dst->lru, &dst_folios);
+				break;
 			default:
 				/*
 				 * Permanent failure (-EBUSY, etc.):
@@ -1762,12 +1832,95 @@ split_folio_migration:
 	nr_large_failed += large_retry;
 	stats->nr_thp_failed += thp_retry;
 	stats->nr_failed_pages += nr_retry_pages;
+move:
+	retry = 1;
+	for (pass = 0;
+	     pass < NR_MAX_MIGRATE_PAGES_RETRY && (retry || large_retry);
+	     pass++) {
+		retry = 0;
+		large_retry = 0;
+		thp_retry = 0;
+		nr_retry_pages = 0;
+
+		dst = list_first_entry(&dst_folios, struct folio, lru);
+		dst2 = list_next_entry(dst, lru);
+		list_for_each_entry_safe(folio, folio2, &unmap_folios, lru) {
+			is_large = folio_test_large(folio);
+			is_thp = is_large && folio_test_pmd_mappable(folio);
+			nr_pages = folio_nr_pages(folio);
+
+			cond_resched();
+
+			rc = migrate_folio_move(put_new_page, private,
+						folio, dst, mode,
+						reason, ret_folios);
+			/*
+			 * The rules are:
+			 *	Success: folio will be freed
+			 *	-EAGAIN: stay on the unmap_folios list
+			 *	Other errno: put on ret_folios list
+			 */
+			switch(rc) {
+			case -EAGAIN:
+				if (is_large) {
+					large_retry++;
+					thp_retry += is_thp;
+				} else if (!no_split_folio_counting) {
+					retry++;
+				}
+				nr_retry_pages += nr_pages;
+				break;
+			case MIGRATEPAGE_SUCCESS:
+				stats->nr_succeeded += nr_pages;
+				stats->nr_thp_succeeded += is_thp;
+				break;
+			default:
+				if (is_large) {
+					nr_large_failed++;
+					stats->nr_thp_failed += is_thp;
+				} else if (!no_split_folio_counting) {
+					nr_failed++;
+				}
+
+				stats->nr_failed_pages += nr_pages;
+				break;
+			}
+			dst = dst2;
+			dst2 = list_next_entry(dst, lru);
+		}
+	}
+	nr_failed += retry;
+	nr_large_failed += large_retry;
+	stats->nr_thp_failed += thp_retry;
+	stats->nr_failed_pages += nr_retry_pages;
+
+	if (rc_saved)
+		rc = rc_saved;
+	else
+		rc = nr_failed + nr_large_failed;
+out:
+	/* Cleanup remaining folios */
+	dst = list_first_entry(&dst_folios, struct folio, lru);
+	dst2 = list_next_entry(dst, lru);
+	list_for_each_entry_safe(folio, folio2, &unmap_folios, lru) {
+		int page_was_mapped = 0;
+		struct anon_vma *anon_vma = NULL;
+
+		__migrate_folio_extract(dst, &page_was_mapped, &anon_vma);
+		migrate_folio_undo_src(folio, page_was_mapped, anon_vma,
+				       ret_folios);
+		list_del(&dst->lru);
+		migrate_folio_undo_dst(dst, put_new_page, private);
+		dst = dst2;
+		dst2 = list_next_entry(dst, lru);
+	}
+
 	/*
 	 * Try to migrate split folios of fail-to-migrate large folios, no
 	 * nr_failed counting in this round, since all split folios of a
 	 * large folio is counted as 1 failure in the first round.
 	 */
-	if (!list_empty(&split_folios)) {
+	if (rc >= 0 && !list_empty(&split_folios)) {
 		/*
 		 * Move non-migrated folios (after NR_MAX_MIGRATE_PAGES_RETRY
 		 * retries) to ret_folios to avoid migrating them again.
@@ -1775,12 +1928,16 @@ split_folio_migration:
 		list_splice_init(from, ret_folios);
 		list_splice_init(&split_folios, from);
 		no_split_folio_counting = true;
-		retry = 1;
-		goto split_folio_migration;
+		goto retry;
 	}
 
-	rc = nr_failed + nr_large_failed;
-out:
+	/*
+	 * We have unlocked all locked folios, so we can force lock now, let's
+	 * try again.
+	 */
+	if (rc == -EDEADLOCK)
+		goto retry;
+
 	return rc;
 }
 
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

