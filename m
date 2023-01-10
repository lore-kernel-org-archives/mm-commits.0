Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 109D2C54EBC
	for <mm-commits@archiver.kernel.org>; Tue, 10 Jan 2023 23:54:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbjAJXyQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 Jan 2023 18:54:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233103AbjAJXyO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 Jan 2023 18:54:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19EF95792C
        for <mm-commits@vger.kernel.org>; Tue, 10 Jan 2023 15:54:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 983DD61826
        for <mm-commits@vger.kernel.org>; Tue, 10 Jan 2023 23:54:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE263C433D2;
        Tue, 10 Jan 2023 23:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673394852;
        bh=zu6VyiIcvCtDsR4AAqB4ioKfzIS3mW/cgEYMXAeR/yY=;
        h=Date:To:From:Subject:From;
        b=mrBshtoZ2foOwk/S9znLGJ4ffIDUb/TFR85RDbIr87CWTwu5sRvVkgIv+t5c6L/Ue
         x9BSkzrQlLaArLOy7Qr7+u5YvAZPl8y33nMaz8p5K+ZG2Uc3aWNfYQ7MYkfft0D444
         ugg7yI3MNdPNh/h1j/MK7c4VdcaCglzlXqvlQ2zo=
Date:   Tue, 10 Jan 2023 15:54:11 -0800
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, xhao@linux.alibaba.com,
        willy@infradead.org, shy828301@gmail.com, osalvador@suse.de,
        bharata@amd.com, baolin.wang@linux.alibaba.com, apopple@nvidia.com,
        ying.huang@intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + migrate_pages-split-unmap_and_move-to-_unmap-and-_move.patch added to mm-unstable branch
Message-Id: <20230110235411.EE263C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: migrate_pages: split unmap_and_move() to _unmap() and _move()
has been added to the -mm mm-unstable branch.  Its filename is
     migrate_pages-split-unmap_and_move-to-_unmap-and-_move.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/migrate_pages-split-unmap_and_move-to-_unmap-and-_move.patch

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
Subject: migrate_pages: split unmap_and_move() to _unmap() and _move()
Date: Tue, 10 Jan 2023 15:53:22 +0800

This is a preparation patch to batch the folio unmapping and moving.

In this patch, unmap_and_move() is split to migrate_folio_unmap() and
migrate_folio_move().  So, we can batch _unmap() and _move() in different
loops later.  To pass some information between unmap and move, the
original unused dst->mapping and dst->private are used.

Link: https://lkml.kernel.org/r/20230110075327.590514-5-ying.huang@intel.com
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

 include/linux/migrate.h |    1 
 mm/migrate.c            |  169 ++++++++++++++++++++++++++++----------
 2 files changed, 128 insertions(+), 42 deletions(-)

--- a/include/linux/migrate.h~migrate_pages-split-unmap_and_move-to-_unmap-and-_move
+++ a/include/linux/migrate.h
@@ -18,6 +18,7 @@ struct migration_target_control;
  * - zero on page migration success;
  */
 #define MIGRATEPAGE_SUCCESS		0
+#define MIGRATEPAGE_UNMAP		1
 
 /**
  * struct movable_operations - Driver page migration
--- a/mm/migrate.c~migrate_pages-split-unmap_and_move-to-_unmap-and-_move
+++ a/mm/migrate.c
@@ -1026,11 +1026,53 @@ out:
 	return rc;
 }
 
-static int __unmap_and_move(struct folio *src, struct folio *dst,
+/*
+ * To record some information during migration, we uses some unused
+ * fields (mapping and private) of struct folio of the newly allocated
+ * destination folio.  This is safe because nobody is using them
+ * except us.
+ */
+static void __migrate_folio_record(struct folio *dst,
+				   unsigned long page_was_mapped,
+				   struct anon_vma *anon_vma)
+{
+	dst->mapping = (void *)anon_vma;
+	dst->private = (void *)page_was_mapped;
+}
+
+static void __migrate_folio_extract(struct folio *dst,
+				   int *page_was_mappedp,
+				   struct anon_vma **anon_vmap)
+{
+	*anon_vmap = (void *)dst->mapping;
+	*page_was_mappedp = (unsigned long)dst->private;
+	dst->mapping = NULL;
+	dst->private = NULL;
+}
+
+/* Cleanup src folio upon migration success */
+static void migrate_folio_done(struct folio *src,
+			       enum migrate_reason reason)
+{
+	/*
+	 * Compaction can migrate also non-LRU pages which are
+	 * not accounted to NR_ISOLATED_*. They can be recognized
+	 * as __PageMovable
+	 */
+	if (likely(!__folio_test_movable(src)))
+		mod_node_page_state(folio_pgdat(src), NR_ISOLATED_ANON +
+				    folio_is_file_lru(src), -folio_nr_pages(src));
+
+	if (reason != MR_MEMORY_FAILURE)
+		/* We release the page in page_handle_poison. */
+		folio_put(src);
+}
+
+static int __migrate_folio_unmap(struct folio *src, struct folio *dst,
 				int force, enum migrate_mode mode)
 {
 	int rc = -EAGAIN;
-	bool page_was_mapped = false;
+	int page_was_mapped = 0;
 	struct anon_vma *anon_vma = NULL;
 	bool is_lru = !__PageMovable(&src->page);
 
@@ -1106,8 +1148,8 @@ static int __unmap_and_move(struct folio
 		goto out_unlock;
 
 	if (unlikely(!is_lru)) {
-		rc = move_to_new_folio(dst, src, mode);
-		goto out_unlock_both;
+		__migrate_folio_record(dst, page_was_mapped, anon_vma);
+		return MIGRATEPAGE_UNMAP;
 	}
 
 	/*
@@ -1132,11 +1174,40 @@ static int __unmap_and_move(struct folio
 		VM_BUG_ON_FOLIO(folio_test_anon(src) &&
 			       !folio_test_ksm(src) && !anon_vma, src);
 		try_to_migrate(src, 0);
-		page_was_mapped = true;
+		page_was_mapped = 1;
 	}
 
-	if (!folio_mapped(src))
-		rc = move_to_new_folio(dst, src, mode);
+	if (!folio_mapped(src)) {
+		__migrate_folio_record(dst, page_was_mapped, anon_vma);
+		return MIGRATEPAGE_UNMAP;
+	}
+
+
+	if (page_was_mapped)
+		remove_migration_ptes(src, src, false);
+
+out_unlock_both:
+	folio_unlock(dst);
+out_unlock:
+	/* Drop an anon_vma reference if we took one */
+	if (anon_vma)
+		put_anon_vma(anon_vma);
+	folio_unlock(src);
+out:
+
+	return rc;
+}
+
+static int __migrate_folio_move(struct folio *src, struct folio *dst,
+				enum migrate_mode mode)
+{
+	int rc;
+	int page_was_mapped = 0;
+	struct anon_vma *anon_vma = NULL;
+
+	__migrate_folio_extract(dst, &page_was_mapped, &anon_vma);
+
+	rc = move_to_new_folio(dst, src, mode);
 
 	/*
 	 * When successful, push dst to LRU immediately: so that if it
@@ -1157,14 +1228,11 @@ static int __unmap_and_move(struct folio
 		remove_migration_ptes(src,
 			rc == MIGRATEPAGE_SUCCESS ? dst : src, false);
 
-out_unlock_both:
 	folio_unlock(dst);
-out_unlock:
 	/* Drop an anon_vma reference if we took one */
 	if (anon_vma)
 		put_anon_vma(anon_vma);
 	folio_unlock(src);
-out:
 	/*
 	 * If migration is successful, decrease refcount of dst,
 	 * which will not free the page because new page owner increased
@@ -1176,19 +1244,15 @@ out:
 	return rc;
 }
 
-/*
- * Obtain the lock on folio, remove all ptes and migrate the folio
- * to the newly allocated folio in dst.
- */
-static int unmap_and_move(new_page_t get_new_page,
-				   free_page_t put_new_page,
-				   unsigned long private, struct folio *src,
-				   int force, enum migrate_mode mode,
-				   enum migrate_reason reason,
-				   struct list_head *ret)
+/* Obtain the lock on page, remove all ptes. */
+static int migrate_folio_unmap(new_page_t get_new_page, free_page_t put_new_page,
+			       unsigned long private, struct folio *src,
+			       struct folio **dstp, int force,
+			       enum migrate_mode mode, enum migrate_reason reason,
+			       struct list_head *ret)
 {
 	struct folio *dst;
-	int rc = MIGRATEPAGE_SUCCESS;
+	int rc = MIGRATEPAGE_UNMAP;
 	struct page *newpage = NULL;
 
 	if (!thp_migration_supported() && folio_test_transhuge(src))
@@ -1199,20 +1263,50 @@ static int unmap_and_move(new_page_t get
 		folio_clear_active(src);
 		folio_clear_unevictable(src);
 		/* free_pages_prepare() will clear PG_isolated. */
-		goto out;
+		list_del(&src->lru);
+		migrate_folio_done(src, reason);
+		return MIGRATEPAGE_SUCCESS;
 	}
 
 	newpage = get_new_page(&src->page, private);
 	if (!newpage)
 		return -ENOMEM;
 	dst = page_folio(newpage);
+	*dstp = dst;
 
 	dst->private = NULL;
-	rc = __unmap_and_move(src, dst, force, mode);
+	rc = __migrate_folio_unmap(src, dst, force, mode);
+	if (rc == MIGRATEPAGE_UNMAP)
+		return rc;
+
+	/*
+	 * A page that has not been migrated will have kept its
+	 * references and be restored.
+	 */
+	/* restore the folio to right list. */
+	if (rc != -EAGAIN)
+		list_move_tail(&src->lru, ret);
+
+	if (put_new_page)
+		put_new_page(&dst->page, private);
+	else
+		folio_put(dst);
+
+	return rc;
+}
+
+/* Migrate the folio to the newly allocated folio in dst. */
+static int migrate_folio_move(free_page_t put_new_page, unsigned long private,
+			      struct folio *src, struct folio *dst,
+			      enum migrate_mode mode, enum migrate_reason reason,
+			      struct list_head *ret)
+{
+	int rc;
+
+	rc = __migrate_folio_move(src, dst, mode);
 	if (rc == MIGRATEPAGE_SUCCESS)
 		set_page_owner_migrate_reason(&dst->page, reason);
 
-out:
 	if (rc != -EAGAIN) {
 		/*
 		 * A folio that has been migrated has all references
@@ -1228,20 +1322,7 @@ out:
 	 * we want to retry.
 	 */
 	if (rc == MIGRATEPAGE_SUCCESS) {
-		/*
-		 * Compaction can migrate also non-LRU folios which are
-		 * not accounted to NR_ISOLATED_*. They can be recognized
-		 * as __folio_test_movable
-		 */
-		if (likely(!__folio_test_movable(src)))
-			mod_node_page_state(folio_pgdat(src), NR_ISOLATED_ANON +
-					folio_is_file_lru(src), -folio_nr_pages(src));
-
-		if (reason != MR_MEMORY_FAILURE)
-			/*
-			 * We release the folio in page_handle_poison.
-			 */
-			folio_put(src);
+		migrate_folio_done(src, reason);
 	} else {
 		if (rc != -EAGAIN)
 			list_add_tail(&src->lru, ret);
@@ -1533,7 +1614,7 @@ static int migrate_pages_batch(struct li
 	int pass = 0;
 	bool is_large = false;
 	bool is_thp = false;
-	struct folio *folio, *folio2;
+	struct folio *folio, *folio2, *dst = NULL;
 	int rc, nr_pages;
 	LIST_HEAD(split_folios);
 	bool nosplit = (reason == MR_NUMA_MISPLACED);
@@ -1560,9 +1641,13 @@ split_folio_migration:
 
 			cond_resched();
 
-			rc = unmap_and_move(get_new_page, put_new_page,
-					    private, folio, pass > 2, mode,
-					    reason, ret_folios);
+			rc = migrate_folio_unmap(get_new_page, put_new_page, private,
+						 folio, &dst, pass > 2, mode,
+						 reason, ret_folios);
+			if (rc == MIGRATEPAGE_UNMAP)
+				rc = migrate_folio_move(put_new_page, private,
+							folio, dst, mode,
+							reason, ret_folios);
 			/*
 			 * The rules are:
 			 *	Success: folio will be freed
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

