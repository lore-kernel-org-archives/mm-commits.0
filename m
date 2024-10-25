Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA654214425
	for <mm-commits@vger.kernel.org>; Fri, 25 Oct 2024 20:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729887518; cv=none; b=kJ2r7h//RarZBkZrpzBaxZ7lSQ95b9jotafVCZMjvsZXRyUISSjn1IgCUOvhPV0s4U3Iw5fnZbiT7xNJ5N2VZ5y+D0LJTFzaMOLcBwXx2b08pCqov1UrYbRM15Wf6g3B7BlwPHj5zknxpgPvqbREIcaiT+gS0GSZ8ZQtXEkr/fQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729887518; c=relaxed/simple;
	bh=DBcwqvU0zsekT7id+vzW/0sYyzMI5/l4xor+WHKm85E=;
	h=Date:To:From:Subject:Message-Id; b=lDml4alEQjNeoG4qEZXUMDo95FWUwx680Fm+Y69CSXwMqXZ3oQcZH6eTkx68QL9nmNcFk6OZVazxX/XW3c8EHcZgKUwD7e2sA23GJ8IadCiljXNF3aCGGcO8D5uksql1uhlkij+rC2KbMoSRW6+0iSzt72vBZVMKY1j9vPaSQdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=urIOIKXR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="urIOIKXR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 341AFC4CECC;
	Fri, 25 Oct 2024 20:18:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729887518;
	bh=DBcwqvU0zsekT7id+vzW/0sYyzMI5/l4xor+WHKm85E=;
	h=Date:To:From:Subject:From;
	b=urIOIKXRDiqJJumxmI/tKP/ztFbnCkjHWOVCHPl71r+G6V/KvU3QlqxiirciFzT38
	 zHX+JFhohtwEnwhc+GJStVWjzOMr9KrafIa9Z9M2A00XBv8oPtVzfxILuQvZ/7VPWn
	 GffAbg15jw+jHIFsN7hs4vGm0yoimVj99unYfObg=
Date: Fri, 25 Oct 2024 13:18:37 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,hughd@google.com,hannes@cmpxchg.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-v1-no-need-for-memcg-locking-for-dirty-tracking.patch added to mm-unstable branch
Message-Id: <20241025201838.341AFC4CECC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg-v1: no need for memcg locking for dirty tracking
has been added to the -mm mm-unstable branch.  Its filename is
     memcg-v1-no-need-for-memcg-locking-for-dirty-tracking.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-v1-no-need-for-memcg-locking-for-dirty-tracking.patch

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
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg-v1: no need for memcg locking for dirty tracking
Date: Thu, 24 Oct 2024 18:23:00 -0700

During the era of memcg charge migration, the kernel has to be make
sure that the dirty stat updates do not race with the charge migration.
Otherwise it might update the dirty stats of the wrong memcg.  Now
with the memcg charge migration gone, there is no more race for dirty
stat updates and the previous locking can be removed.

Link: https://lkml.kernel.org/r/20241025012304.2473312-4-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c         |    5 -----
 mm/page-writeback.c |   16 +++-------------
 2 files changed, 3 insertions(+), 18 deletions(-)

--- a/fs/buffer.c~memcg-v1-no-need-for-memcg-locking-for-dirty-tracking
+++ a/fs/buffer.c
@@ -736,15 +736,12 @@ bool block_dirty_folio(struct address_sp
 	 * Lock out page's memcg migration to keep PageDirty
 	 * synchronized with per-memcg dirty page counters.
 	 */
-	folio_memcg_lock(folio);
 	newly_dirty = !folio_test_set_dirty(folio);
 	spin_unlock(&mapping->i_private_lock);
 
 	if (newly_dirty)
 		__folio_mark_dirty(folio, mapping, 1);
 
-	folio_memcg_unlock(folio);
-
 	if (newly_dirty)
 		__mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
 
@@ -1194,13 +1191,11 @@ void mark_buffer_dirty(struct buffer_hea
 		struct folio *folio = bh->b_folio;
 		struct address_space *mapping = NULL;
 
-		folio_memcg_lock(folio);
 		if (!folio_test_set_dirty(folio)) {
 			mapping = folio->mapping;
 			if (mapping)
 				__folio_mark_dirty(folio, mapping, 0);
 		}
-		folio_memcg_unlock(folio);
 		if (mapping)
 			__mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
 	}
--- a/mm/page-writeback.c~memcg-v1-no-need-for-memcg-locking-for-dirty-tracking
+++ a/mm/page-writeback.c
@@ -2743,8 +2743,6 @@ EXPORT_SYMBOL(noop_dirty_folio);
 /*
  * Helper function for set_page_dirty family.
  *
- * Caller must hold folio_memcg_lock().
- *
  * NOTE: This relies on being atomic wrt interrupts.
  */
 static void folio_account_dirtied(struct folio *folio,
@@ -2777,7 +2775,6 @@ static void folio_account_dirtied(struct
 /*
  * Helper function for deaccounting dirty page without writeback.
  *
- * Caller must hold folio_memcg_lock().
  */
 void folio_account_cleaned(struct folio *folio, struct bdi_writeback *wb)
 {
@@ -2795,9 +2792,8 @@ void folio_account_cleaned(struct folio
  * If warn is true, then emit a warning if the folio is not uptodate and has
  * not been truncated.
  *
- * The caller must hold folio_memcg_lock().  It is the caller's
- * responsibility to prevent the folio from being truncated while
- * this function is in progress, although it may have been truncated
+ * It is the caller's responsibility to prevent the folio from being truncated
+ * while this function is in progress, although it may have been truncated
  * before this function is called.  Most callers have the folio locked.
  * A few have the folio blocked from truncation through other means (e.g.
  * zap_vma_pages() has it mapped and is holding the page table lock).
@@ -2841,14 +2837,10 @@ void __folio_mark_dirty(struct folio *fo
  */
 bool filemap_dirty_folio(struct address_space *mapping, struct folio *folio)
 {
-	folio_memcg_lock(folio);
-	if (folio_test_set_dirty(folio)) {
-		folio_memcg_unlock(folio);
+	if (folio_test_set_dirty(folio))
 		return false;
-	}
 
 	__folio_mark_dirty(folio, mapping, !folio_test_private(folio));
-	folio_memcg_unlock(folio);
 
 	if (mapping->host) {
 		/* !PageAnon && !swapper_space */
@@ -2975,14 +2967,12 @@ void __folio_cancel_dirty(struct folio *
 		struct bdi_writeback *wb;
 		struct wb_lock_cookie cookie = {};
 
-		folio_memcg_lock(folio);
 		wb = unlocked_inode_to_wb_begin(inode, &cookie);
 
 		if (folio_test_clear_dirty(folio))
 			folio_account_cleaned(folio, wb);
 
 		unlocked_inode_to_wb_end(inode, &cookie);
-		folio_memcg_unlock(folio);
 	} else {
 		folio_clear_dirty(folio);
 	}
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

mm-optimize-truncation-of-shadow-entries.patch
mm-optimize-invalidation-of-shadow-entries.patch
mm-truncate-reset-xa_has_values-flag-on-each-iteration.patch
memcg-add-tracing-for-memcg-stat-updates.patch
memcg-add-tracing-for-memcg-stat-updates-v2.patch
memcg-v1-fully-deprecate-move_charge_at_immigrate.patch
memcg-v1-remove-charge-move-code.patch
memcg-v1-no-need-for-memcg-locking-for-dirty-tracking.patch
memcg-v1-no-need-for-memcg-locking-for-writeback-tracking.patch
memcg-v1-no-need-for-memcg-locking-for-mglru.patch
memcg-v1-remove-memcg-move-locking-code.patch

