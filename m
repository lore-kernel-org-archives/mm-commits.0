Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA51EC4708D
	for <mm-commits@archiver.kernel.org>; Wed, 28 Dec 2022 23:23:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231415AbiL1XXh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 28 Dec 2022 18:23:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231607AbiL1XXb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 28 Dec 2022 18:23:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5F3A13EB6
        for <mm-commits@vger.kernel.org>; Wed, 28 Dec 2022 15:23:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5176AB818B4
        for <mm-commits@vger.kernel.org>; Wed, 28 Dec 2022 23:23:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3662C433D2;
        Wed, 28 Dec 2022 23:23:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1672269807;
        bh=PVeuN3tGGqoskzkdVA/GL3AZHElEKa3+Vsd+JaH0WWE=;
        h=Date:To:From:Subject:From;
        b=NOYUQ1UyUwJCu5XNDsRwaEEOLCGoavMIhzgjU4arEbAzVLy/LG/FRXb4b005qfNnF
         +l38bo8q40GAfASLvjp4RN5BSshJMZqr/xFxZ6Ww1sgXwkC1n5ZViOLf6JRO6She9n
         nkethGsEHzIgqJrlBjak4aW4Byv6CfKyEt0Undxs=
Date:   Wed, 28 Dec 2022 15:23:25 -0800
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, xhao@linux.alibaba.com,
        willy@infradead.org, shy828301@gmail.com, osalvador@suse.de,
        mgorman@techsingularity.net, bharata@amd.com,
        baolin.wang@linux.alibaba.com, apopple@nvidia.com,
        ying.huang@intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + migrate_pages-share-more-code-between-_unmap-and-_move.patch added to mm-unstable branch
Message-Id: <20221228232326.E3662C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: migrate_pages: share more code between _unmap and _move
has been added to the -mm mm-unstable branch.  Its filename is
     migrate_pages-share-more-code-between-_unmap-and-_move.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/migrate_pages-share-more-code-between-_unmap-and-_move.patch

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
Subject: migrate_pages: share more code between _unmap and _move
Date: Tue, 27 Dec 2022 08:28:58 +0800

This is a code cleanup patch to reduce the duplicated code between the
_unmap and _move stages of migrate_pages().  No functionality change is
expected.

Link: https://lkml.kernel.org/r/20221227002859.27740-8-ying.huang@intel.com
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Bharata B Rao <bharata@amd.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: haoxin <xhao@linux.alibaba.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/migrate.c~migrate_pages-share-more-code-between-_unmap-and-_move
+++ a/mm/migrate.c
@@ -1047,21 +1047,26 @@ static void __migrate_folio_extract(stru
 static void migrate_folio_undo_src(struct folio *src,
 				   int page_was_mapped,
 				   struct anon_vma *anon_vma,
+				   bool locked,
 				   struct list_head *ret)
 {
 	if (page_was_mapped)
 		remove_migration_ptes(src, src, false);
 	if (anon_vma)
 		put_anon_vma(anon_vma);
-	folio_unlock(src);
-	list_move_tail(&src->lru, ret);
+	if (locked)
+		folio_unlock(src);
+	if (ret)
+		list_move_tail(&src->lru, ret);
 }
 
 static void migrate_folio_undo_dst(struct folio *dst,
+				   bool locked,
 				   free_page_t put_new_page,
 				   unsigned long private)
 {
-	folio_unlock(dst);
+	if (locked)
+		folio_unlock(dst);
 	if (put_new_page)
 		put_new_page(&dst->page, private);
 	else
@@ -1085,14 +1090,44 @@ static void migrate_folio_done(struct fo
 		folio_put(src);
 }
 
-static int __migrate_folio_unmap(struct folio *src, struct folio *dst,
-				 int force, bool force_lock, enum migrate_mode mode)
+/* Obtain the lock on page, remove all ptes. */
+static int migrate_folio_unmap(new_page_t get_new_page, free_page_t put_new_page,
+			       unsigned long private, struct folio *src,
+			       struct folio **dstp, int force, bool force_lock,
+			       enum migrate_mode mode, enum migrate_reason reason,
+			       struct list_head *ret)
 {
-	int rc = -EAGAIN;
+	struct folio *dst;
+	int rc = MIGRATEPAGE_UNMAP;
+	struct page *newpage = NULL;
 	int page_was_mapped = 0;
 	struct anon_vma *anon_vma = NULL;
 	bool is_lru = !__PageMovable(&src->page);
+	bool locked = false;
+	bool dst_locked = false;
 
+	if (!thp_migration_supported() && folio_test_transhuge(src))
+		return -ENOSYS;
+
+	if (folio_ref_count(src) == 1) {
+		/* Folio was freed from under us. So we are done. */
+		folio_clear_active(src);
+		folio_clear_unevictable(src);
+		/* free_pages_prepare() will clear PG_isolated. */
+		list_del(&src->lru);
+		migrate_folio_done(src, reason);
+		return MIGRATEPAGE_SUCCESS;
+	}
+
+	newpage = get_new_page(&src->page, private);
+	if (!newpage)
+		return -ENOMEM;
+	dst = page_folio(newpage);
+	*dstp = dst;
+
+	dst->private = NULL;
+
+	rc = -EAGAIN;
 	if (!folio_trylock(src)) {
 		if (!force || mode == MIGRATE_ASYNC)
 			goto out;
@@ -1120,6 +1155,7 @@ static int __migrate_folio_unmap(struct
 
 		folio_lock(src);
 	}
+	locked = true;
 
 	if (folio_test_writeback(src)) {
 		/*
@@ -1134,10 +1170,10 @@ static int __migrate_folio_unmap(struct
 			break;
 		default:
 			rc = -EBUSY;
-			goto out_unlock;
+			goto out;
 		}
 		if (!force)
-			goto out_unlock;
+			goto out;
 		folio_wait_writeback(src);
 	}
 
@@ -1167,7 +1203,8 @@ static int __migrate_folio_unmap(struct
 	 * This is much like races on refcount of oldpage: just don't BUG().
 	 */
 	if (unlikely(!folio_trylock(dst)))
-		goto out_unlock;
+		goto out;
+	dst_locked = true;
 
 	if (unlikely(!is_lru)) {
 		__migrate_folio_record(dst, page_was_mapped, anon_vma);
@@ -1189,7 +1226,7 @@ static int __migrate_folio_unmap(struct
 	if (!src->mapping) {
 		if (folio_test_private(src)) {
 			try_to_free_buffers(src);
-			goto out_unlock_both;
+			goto out;
 		}
 	} else if (folio_mapped(src)) {
 		/* Establish migration ptes */
@@ -1204,75 +1241,27 @@ static int __migrate_folio_unmap(struct
 		return MIGRATEPAGE_UNMAP;
 	}
 
-
-	if (page_was_mapped)
-		remove_migration_ptes(src, src, false);
-
-out_unlock_both:
-	folio_unlock(dst);
-out_unlock:
-	/* Drop an anon_vma reference if we took one */
-	if (anon_vma)
-		put_anon_vma(anon_vma);
-	folio_unlock(src);
 out:
-
-	return rc;
-}
-
-/* Obtain the lock on page, remove all ptes. */
-static int migrate_folio_unmap(new_page_t get_new_page, free_page_t put_new_page,
-			       unsigned long private, struct folio *src,
-			       struct folio **dstp, int force, bool force_lock,
-			       enum migrate_mode mode, enum migrate_reason reason,
-			       struct list_head *ret)
-{
-	struct folio *dst;
-	int rc = MIGRATEPAGE_UNMAP;
-	struct page *newpage = NULL;
-
-	if (!thp_migration_supported() && folio_test_transhuge(src))
-		return -ENOSYS;
-
-	if (folio_ref_count(src) == 1) {
-		/* Folio was freed from under us. So we are done. */
-		folio_clear_active(src);
-		folio_clear_unevictable(src);
-		/* free_pages_prepare() will clear PG_isolated. */
-		list_del(&src->lru);
-		migrate_folio_done(src, reason);
-		return MIGRATEPAGE_SUCCESS;
-	}
-
-	newpage = get_new_page(&src->page, private);
-	if (!newpage)
-		return -ENOMEM;
-	dst = page_folio(newpage);
-	*dstp = dst;
-
-	dst->private = NULL;
-	rc = __migrate_folio_unmap(src, dst, force, force_lock, mode);
-	if (rc == MIGRATEPAGE_UNMAP)
-		return rc;
-
 	/*
 	 * A page that has not been migrated will have kept its
 	 * references and be restored.
 	 */
 	/* restore the folio to right list. */
-	if (rc != -EAGAIN && rc != -EDEADLOCK)
-		list_move_tail(&src->lru, ret);
+	if (rc == -EAGAIN || rc == -EDEADLOCK)
+		ret = NULL;
 
-	if (put_new_page)
-		put_new_page(&dst->page, private);
-	else
-		folio_put(dst);
+	migrate_folio_undo_src(src, page_was_mapped, anon_vma, locked, ret);
+	if (dst)
+		migrate_folio_undo_dst(dst, dst_locked, put_new_page, private);
 
 	return rc;
 }
 
-static int __migrate_folio_move(struct folio *src, struct folio *dst,
-				enum migrate_mode mode)
+/* Migrate the folio to the newly allocated folio in dst. */
+static int migrate_folio_move(free_page_t put_new_page, unsigned long private,
+			      struct folio *src, struct folio *dst,
+			      enum migrate_mode mode, enum migrate_reason reason,
+			      struct list_head *ret)
 {
 	int rc;
 	int page_was_mapped = 0;
@@ -1281,9 +1270,10 @@ static int __migrate_folio_move(struct f
 	__migrate_folio_extract(dst, &page_was_mapped, &anon_vma);
 
 	rc = move_to_new_folio(dst, src, mode);
+	if (rc)
+		goto out;
 
-	if (rc != -EAGAIN)
-		list_del(&dst->lru);
+	list_del(&dst->lru);
 	/*
 	 * When successful, push dst to LRU immediately: so that if it
 	 * turns out to be an mlocked page, remove_migration_ptes() will
@@ -1293,74 +1283,40 @@ static int __migrate_folio_move(struct f
 	 * unsuccessful, and other cases when a page has been temporarily
 	 * isolated from the unevictable LRU: but this case is the easiest.
 	 */
-	if (rc == MIGRATEPAGE_SUCCESS) {
-		folio_add_lru(dst);
-		if (page_was_mapped)
-			lru_add_drain();
-	}
-
-	if (rc == -EAGAIN) {
-		__migrate_folio_record(dst, page_was_mapped, anon_vma);
-		return rc;
-	}
-
+	folio_add_lru(dst);
 	if (page_was_mapped)
-		remove_migration_ptes(src,
-			rc == MIGRATEPAGE_SUCCESS ? dst : src, false);
+		lru_add_drain();
 
+	if (page_was_mapped)
+		remove_migration_ptes(src, dst, false);
 	folio_unlock(dst);
-	/* Drop an anon_vma reference if we took one */
-	if (anon_vma)
-		put_anon_vma(anon_vma);
-	folio_unlock(src);
+	set_page_owner_migrate_reason(&dst->page, reason);
 	/*
 	 * If migration is successful, decrease refcount of dst,
 	 * which will not free the page because new page owner increased
 	 * refcounter.
 	 */
-	if (rc == MIGRATEPAGE_SUCCESS)
-		folio_put(dst);
-
-	return rc;
-}
-
-/* Migrate the folio to the newly allocated folio in dst. */
-static int migrate_folio_move(free_page_t put_new_page, unsigned long private,
-			      struct folio *src, struct folio *dst,
-			      enum migrate_mode mode, enum migrate_reason reason,
-			      struct list_head *ret)
-{
-	int rc;
-
-	rc = __migrate_folio_move(src, dst, mode);
-	if (rc == MIGRATEPAGE_SUCCESS)
-		set_page_owner_migrate_reason(&dst->page, reason);
-
-	if (rc != -EAGAIN) {
-		/*
-		 * A folio that has been migrated has all references
-		 * removed and will be freed. A folio that has not been
-		 * migrated will have kept its references and be restored.
-		 */
-		list_del(&src->lru);
-	}
+	folio_put(dst);
 
 	/*
-	 * If migration is successful, releases reference grabbed during
-	 * isolation. Otherwise, restore the folio to right list unless
-	 * we want to retry.
+	 * A page that has been migrated has all references removed
+	 * and will be freed.
 	 */
-	if (rc == MIGRATEPAGE_SUCCESS) {
-		migrate_folio_done(src, reason);
-	} else if (rc != -EAGAIN) {
-		list_add_tail(&src->lru, ret);
+	list_del(&src->lru);
+	migrate_folio_undo_src(src, 0, anon_vma, true, NULL);
+	migrate_folio_done(src, reason);
 
-		if (put_new_page)
-			put_new_page(&dst->page, private);
-		else
-			folio_put(dst);
+	return rc;
+out:
+	if (rc == -EAGAIN) {
+		__migrate_folio_record(dst, page_was_mapped, anon_vma);
+		return rc;
 	}
 
+	migrate_folio_undo_src(src, page_was_mapped, anon_vma, true, ret);
+	list_del(&dst->lru);
+	migrate_folio_undo_dst(dst, true, put_new_page, private);
+
 	return rc;
 }
 
@@ -1866,9 +1822,9 @@ out:
 
 		__migrate_folio_extract(dst, &page_was_mapped, &anon_vma);
 		migrate_folio_undo_src(folio, page_was_mapped, anon_vma,
-				       ret_folios);
+				       true, ret_folios);
 		list_del(&dst->lru);
-		migrate_folio_undo_dst(dst, put_new_page, private);
+		migrate_folio_undo_dst(dst, true, put_new_page, private);
 		dst = dst2;
 		dst2 = list_next_entry(dst, lru);
 	}
_

Patches currently in -mm which might be from ying.huang@intel.com are

migrate_pages-organize-stats-with-struct-migrate_pages_stats.patch
migrate_pages-separate-hugetlb-folios-migration.patch
migrate_pages-restrict-number-of-pages-to-migrate-in-batch.patch
migrate_pages-split-unmap_and_move-to-_unmap-and-_move.patch
migrate_pages-batch-_unmap-and-_move.patch
migrate_pages-move-migrate_folio_done-and-migrate_folio_unmap.patch
migrate_pages-share-more-code-between-_unmap-and-_move.patch
migrate_pages-batch-flushing-tlb.patch

