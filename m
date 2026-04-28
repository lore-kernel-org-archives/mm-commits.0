Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3AD7406268
	for <mm-commits@vger.kernel.org>; Tue, 28 Apr 2026 13:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777384482; cv=none; b=kYapFpk+uEx31sKV5mRTIL5zEkK3+B0OImNCWeZr+qm9OIGUb1yWsK7aWBtooiFeCfemTiTujHc4MmLU5pfciJEJJiwpcTEjTlLNCjbFEweE9CSkv7+9W8nTbmQWNscuh83oarVZU7PyAcPlRoeTbfFWQKvsKnUtEeEA+TwcDsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777384482; c=relaxed/simple;
	bh=xsrWXfmmrJs9oat/fSU1QcTdW83c6GRtziZ/yPCIHPQ=;
	h=Date:To:From:Subject:Message-Id; b=Thnk2bxc6pWKIvGTA0Jxhe0SQMNgrqaNxoFW+vfpe646To1IaLfik27/bS+zM2d4dmpmoTvIh7LaltEOR5THrHLpPYdP0M1Cykem9yf3LK+yhyPJ0FxWx0hQtgjMgacNpeF1q8l4FMhmDdBRMiTT7xxmKPC6GtXkzILhtNdDYSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pHCLJRM0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pHCLJRM0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A49CC2BCAF;
	Tue, 28 Apr 2026 13:54:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777384482;
	bh=xsrWXfmmrJs9oat/fSU1QcTdW83c6GRtziZ/yPCIHPQ=;
	h=Date:To:From:Subject:From;
	b=pHCLJRM0LhqazFdFIWK09hsZ2U3Q/3EKurx+FZ4Ty+q6LSGdu+kn0FfXxSyAEuXUD
	 gmkDAptupM5coI66orJzlKgIn25kO/JBpgkXzI1PbuYqFgzrFJpV10LWkpDT9wxc5B
	 brIlYMVLEj5DjX8sCbj2BlpfB//mkEh7jUastt3o=
Date: Tue, 28 Apr 2026 06:54:42 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,willy@infradead.org,rakie.kim@sk.com,matthew.brost@intel.com,lance.yang@linux.dev,joshua.hahnjy@gmail.com,gourry@gourry.net,david@kernel.org,byungchul@sk.com,baolin.wang@linux.alibaba.com,apopple@nvidia.com,shivankg@amd.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migrate-rename-page_-migration-flags-to-folio_.patch added to mm-new branch
Message-Id: <20260428135442.8A49CC2BCAF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/migrate: rename PAGE_ migration flags to FOLIO_
has been added to the -mm mm-new branch.  Its filename is
     mm-migrate-rename-page_-migration-flags-to-folio_.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-migrate-rename-page_-migration-flags-to-folio_.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Shivank Garg <shivankg@amd.com>
Subject: mm/migrate: rename PAGE_ migration flags to FOLIO_
Date: Tue, 24 Mar 2026 19:07:09 +0000

These flags only track folio-specific state during migration and are not
used for movable_ops pages.  Rename the enum values and the old_page_state
variable to match.

No functional change.

Link: https://lore.kernel.org/20260324190706.964555-4-shivankg@amd.com
Signed-off-by: Shivank Garg <shivankg@amd.com>
Suggested-by: David Hildenbrand <david@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Shivank Garg <shivankg@amd.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |   48 +++++++++++++++++++++++-------------------------
 1 file changed, 23 insertions(+), 25 deletions(-)

--- a/mm/migrate.c~mm-migrate-rename-page_-migration-flags-to-folio_
+++ a/mm/migrate.c
@@ -1135,26 +1135,24 @@ static int move_to_new_folio(struct foli
  * This is safe because nobody is using it except us.
  */
 enum {
-	PAGE_WAS_MAPPED = BIT(0),
-	PAGE_WAS_MLOCKED = BIT(1),
-	PAGE_OLD_STATES = PAGE_WAS_MAPPED | PAGE_WAS_MLOCKED,
+	FOLIO_WAS_MAPPED = BIT(0),
+	FOLIO_WAS_MLOCKED = BIT(1),
+	FOLIO_OLD_STATES = FOLIO_WAS_MAPPED | FOLIO_WAS_MLOCKED,
 };
 
 static void __migrate_folio_record(struct folio *dst,
-				   int old_page_state,
-				   struct anon_vma *anon_vma)
+		int old_folio_state, struct anon_vma *anon_vma)
 {
-	dst->private = (void *)anon_vma + old_page_state;
+	dst->private = (void *)anon_vma + old_folio_state;
 }
 
 static void __migrate_folio_extract(struct folio *dst,
-				   int *old_page_state,
-				   struct anon_vma **anon_vmap)
+		int *old_folio_state, struct anon_vma **anon_vmap)
 {
 	unsigned long private = (unsigned long)dst->private;
 
-	*anon_vmap = (struct anon_vma *)(private & ~PAGE_OLD_STATES);
-	*old_page_state = private & PAGE_OLD_STATES;
+	*anon_vmap = (struct anon_vma *)(private & ~FOLIO_OLD_STATES);
+	*old_folio_state = private & FOLIO_OLD_STATES;
 	dst->private = NULL;
 }
 
@@ -1209,7 +1207,7 @@ static int migrate_folio_unmap(new_folio
 {
 	struct folio *dst;
 	int rc = -EAGAIN;
-	int old_page_state = 0;
+	int old_folio_state = 0;
 	struct anon_vma *anon_vma = NULL;
 	bool locked = false;
 	bool dst_locked = false;
@@ -1253,7 +1251,7 @@ static int migrate_folio_unmap(new_folio
 	}
 	locked = true;
 	if (folio_test_mlocked(src))
-		old_page_state |= PAGE_WAS_MLOCKED;
+		old_folio_state |= FOLIO_WAS_MLOCKED;
 
 	if (folio_test_writeback(src)) {
 		/*
@@ -1302,7 +1300,7 @@ static int migrate_folio_unmap(new_folio
 	dst_locked = true;
 
 	if (unlikely(page_has_movable_ops(&src->page))) {
-		__migrate_folio_record(dst, old_page_state, anon_vma);
+		__migrate_folio_record(dst, old_folio_state, anon_vma);
 		return 0;
 	}
 
@@ -1328,11 +1326,11 @@ static int migrate_folio_unmap(new_folio
 		VM_BUG_ON_FOLIO(folio_test_anon(src) &&
 			       !folio_test_ksm(src) && !anon_vma, src);
 		try_to_migrate(src, mode == MIGRATE_ASYNC ? TTU_BATCH_FLUSH : 0);
-		old_page_state |= PAGE_WAS_MAPPED;
+		old_folio_state |= FOLIO_WAS_MAPPED;
 	}
 
 	if (!folio_mapped(src)) {
-		__migrate_folio_record(dst, old_page_state, anon_vma);
+		__migrate_folio_record(dst, old_folio_state, anon_vma);
 		return 0;
 	}
 
@@ -1344,7 +1342,7 @@ out:
 	if (rc == -EAGAIN)
 		ret = NULL;
 
-	migrate_folio_undo_src(src, old_page_state & PAGE_WAS_MAPPED,
+	migrate_folio_undo_src(src, old_folio_state & FOLIO_WAS_MAPPED,
 			       anon_vma, locked, ret);
 	migrate_folio_undo_dst(dst, dst_locked, put_new_folio, private);
 
@@ -1358,13 +1356,13 @@ static int migrate_folio_move(free_folio
 			      struct list_head *ret)
 {
 	int rc;
-	int old_page_state = 0;
+	int old_folio_state = 0;
 	struct anon_vma *anon_vma = NULL;
 	bool src_deferred_split = false;
 	bool src_partially_mapped = false;
 	struct list_head *prev;
 
-	__migrate_folio_extract(dst, &old_page_state, &anon_vma);
+	__migrate_folio_extract(dst, &old_folio_state, &anon_vma);
 	prev = dst->lru.prev;
 	list_del(&dst->lru);
 
@@ -1404,10 +1402,10 @@ static int migrate_folio_move(free_folio
 	 * isolated from the unevictable LRU: but this case is the easiest.
 	 */
 	folio_add_lru(dst);
-	if (old_page_state & PAGE_WAS_MLOCKED)
+	if (old_folio_state & FOLIO_WAS_MLOCKED)
 		lru_add_drain();
 
-	if (old_page_state & PAGE_WAS_MAPPED)
+	if (old_folio_state & FOLIO_WAS_MAPPED)
 		remove_migration_ptes(src, dst, 0);
 
 out_unlock_both:
@@ -1439,11 +1437,11 @@ out:
 	 */
 	if (rc == -EAGAIN) {
 		list_add(&dst->lru, prev);
-		__migrate_folio_record(dst, old_page_state, anon_vma);
+		__migrate_folio_record(dst, old_folio_state, anon_vma);
 		return rc;
 	}
 
-	migrate_folio_undo_src(src, old_page_state & PAGE_WAS_MAPPED,
+	migrate_folio_undo_src(src, old_folio_state & FOLIO_WAS_MAPPED,
 			       anon_vma, true, ret);
 	migrate_folio_undo_dst(dst, true, put_new_folio, private);
 
@@ -1777,11 +1775,11 @@ static void migrate_folios_undo(struct l
 	dst = list_first_entry(dst_folios, struct folio, lru);
 	dst2 = list_next_entry(dst, lru);
 	list_for_each_entry_safe(folio, folio2, src_folios, lru) {
-		int old_page_state = 0;
+		int old_folio_state = 0;
 		struct anon_vma *anon_vma = NULL;
 
-		__migrate_folio_extract(dst, &old_page_state, &anon_vma);
-		migrate_folio_undo_src(folio, old_page_state & PAGE_WAS_MAPPED,
+		__migrate_folio_extract(dst, &old_folio_state, &anon_vma);
+		migrate_folio_undo_src(folio, old_folio_state & FOLIO_WAS_MAPPED,
 				anon_vma, true, ret_folios);
 		list_del(&dst->lru);
 		migrate_folio_undo_dst(dst, true, put_new_folio, private);
_

Patches currently in -mm which might be from shivankg@amd.com are

mm-migrate-rename-page_-migration-flags-to-folio_.patch

