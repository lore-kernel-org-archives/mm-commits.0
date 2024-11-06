Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA61317DFF1
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 01:01:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730854876; cv=none; b=AYcmhFAg0Np0xmxvpOmtTq6Do62fQFtO7Nbq+u8NEE47nan7kxRHZEqW5z6Ds/tyB24ggFods5I7dk+6/H1SmWllOJ6/HOmVC1umBEkHiajYWfTiSwN6uAx9E7zZLbJYIrJPzwUeXi8VyAr12QrsyAbqpnHC/rmT7+ZHhrZWBhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730854876; c=relaxed/simple;
	bh=pRuquO99jT1uMkctZuP5jnTrTy3vBeb8rN6bQcEMSAc=;
	h=Date:To:From:Subject:Message-Id; b=S0rZ54lH5pvzmrh/J/I53dtby4pQ+T86XM1r35w+6a9IEedt4aHO029fs240YBj2iu/6cZ3q9twzgj0CrMM6HpM7mj/wBqvC+TyxvDcySo3Jy/L2gudIFXg1sYxI8eobfWqig/ZSBDEqi/DbdbLaNrVfPzqDrOBDuOjFcng6ou8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=x/XkbrEA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="x/XkbrEA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DB44C4CECF;
	Wed,  6 Nov 2024 01:01:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730854876;
	bh=pRuquO99jT1uMkctZuP5jnTrTy3vBeb8rN6bQcEMSAc=;
	h=Date:To:From:Subject:From;
	b=x/XkbrEA8W0W72cGhtE4sZrGf+g4pHgg69QKYD+8ZK++7Gamu/eqIIvd80IC/oyna
	 obn6a7y3qOBc4vwSuDTUwAVik6r1knPFVOgaMBq3RfUHTLNCkmMU7p4pTvs6wsqRIi
	 khxpMl34RL0empVq7cKZ2zHob+6IeLzN6zfJ6UjI=
Date: Tue, 05 Nov 2024 17:01:16 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,hughd@google.com,hannes@cmpxchg.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-v1-no-need-for-memcg-locking-for-dirty-tracking.patch removed from -mm tree
Message-Id: <20241106010116.9DB44C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg-v1: no need for memcg locking for dirty tracking
has been removed from the -mm tree.  Its filename was
     memcg-v1-no-need-for-memcg-locking-for-dirty-tracking.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Hugh Dickins <hughd@google.com>
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


