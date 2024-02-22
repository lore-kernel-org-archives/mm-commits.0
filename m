Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EE1B17566
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:03:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560195; cv=none; b=U4tQIhKz4dqrIOvLQro3cO9dyL79mfOCeaZPqDkIRrUoOduOeUmYWcxFRpIi6F+kDhT/Xpv5WNr/rqoeMoI8ZgLnopPjo02xOBIQJcCJID9tHryHjwoQTYoU7XyMsu6Rb3qME2kyH47C4UXETmVhsIilWV7o4cPWC+xHuZ3vUVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560195; c=relaxed/simple;
	bh=y5mcBD+3jQ/hUEaT4Z8VrqfMhC+agDZj8+DaOkbDb2c=;
	h=Date:To:From:Subject:Message-Id; b=a7l+ycXfhONYrupP3i49a85e0ktVtyxUbAiz+Qdvc9F2+Cqgp5c9oHEM/8d1kaFIqnkhFDg/Rra/dofdzHP/5LOrk8oQzggc6rAlKfGhfEqEILfor4SdAhtpTZktQfQtYqmtCY2gYyf028VLaOXO/SCd9WbcL/SqfNUlOb1r2bc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kS0f5+WQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kS0f5+WQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 030ADC43394;
	Thu, 22 Feb 2024 00:03:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560195;
	bh=y5mcBD+3jQ/hUEaT4Z8VrqfMhC+agDZj8+DaOkbDb2c=;
	h=Date:To:From:Subject:From;
	b=kS0f5+WQOD1lUyf1zWfEy5y1OYKh6gw1HQPqQ6jncUkVXYx50b0cBU3D6nNx+dhLr
	 iMD+S7jp7AodCBFbexQco8nAN88uTINy2v8J04q/u72AqNcOl5I2hIIZAbcJsrsDEJ
	 cBdW3I2OtTh5T4diTCt5YBcwS/NINPFSWfx+swVo=
Date: Wed, 21 Feb 2024 16:03:14 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,nphamcs@gmail.com,hannes@cmpxchg.org,zhouchengming@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-zswap-invalidate-zswap-entry-when-swap-entry-free.patch removed from -mm tree
Message-Id: <20240222000315.030ADC43394@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/zswap: invalidate zswap entry when swap entry free
has been removed from the -mm tree.  Its filename was
     mm-zswap-invalidate-zswap-entry-when-swap-entry-free.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Chengming Zhou <zhouchengming@bytedance.com>
Subject: mm/zswap: invalidate zswap entry when swap entry free
Date: Sun, 04 Feb 2024 03:06:00 +0000

During testing I found there are some times the zswap_writeback_entry()
return -ENOMEM, which is not we expected:

bpftrace -e 'kr:zswap_writeback_entry {@[(int32)retval]=count()}'
@[-12]: 1563
@[0]: 277221

The reason is that __read_swap_cache_async() return NULL because
swapcache_prepare() failed.  The reason is that we won't invalidate zswap
entry when swap entry freed to the per-cpu pool, these zswap entries are
still on the zswap tree and lru list.

This patch moves the invalidation ahead to when swap entry freed to the
per-cpu pool, since there is no any benefit to leave trashy zswap entry on
the tree and lru list.

With this patch:
bpftrace -e 'kr:zswap_writeback_entry {@[(int32)retval]=count()}'
@[0]: 259744

Note: large folio can't have zswap entry for now, so don't bother
to add zswap entry invalidation in the large folio swap free path.

Link: https://lkml.kernel.org/r/20240201-b4-zswap-invalidate-entry-v2-2-99d4084260a0@bytedance.com
Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/zswap.h |    4 ++--
 mm/swap_slots.c       |    3 +++
 mm/swapfile.c         |    1 -
 mm/zswap.c            |    5 +++--
 4 files changed, 8 insertions(+), 5 deletions(-)

--- a/include/linux/zswap.h~mm-zswap-invalidate-zswap-entry-when-swap-entry-free
+++ a/include/linux/zswap.h
@@ -29,7 +29,7 @@ struct zswap_lruvec_state {
 
 bool zswap_store(struct folio *folio);
 bool zswap_load(struct folio *folio);
-void zswap_invalidate(int type, pgoff_t offset);
+void zswap_invalidate(swp_entry_t swp);
 int zswap_swapon(int type, unsigned long nr_pages);
 void zswap_swapoff(int type);
 void zswap_memcg_offline_cleanup(struct mem_cgroup *memcg);
@@ -50,7 +50,7 @@ static inline bool zswap_load(struct fol
 	return false;
 }
 
-static inline void zswap_invalidate(int type, pgoff_t offset) {}
+static inline void zswap_invalidate(swp_entry_t swp) {}
 static inline int zswap_swapon(int type, unsigned long nr_pages)
 {
 	return 0;
--- a/mm/swapfile.c~mm-zswap-invalidate-zswap-entry-when-swap-entry-free
+++ a/mm/swapfile.c
@@ -744,7 +744,6 @@ static void swap_range_free(struct swap_
 		swap_slot_free_notify = NULL;
 	while (offset <= end) {
 		arch_swap_invalidate_page(si->type, offset);
-		zswap_invalidate(si->type, offset);
 		if (swap_slot_free_notify)
 			swap_slot_free_notify(si->bdev, offset);
 		offset++;
--- a/mm/swap_slots.c~mm-zswap-invalidate-zswap-entry-when-swap-entry-free
+++ a/mm/swap_slots.c
@@ -273,6 +273,9 @@ void free_swap_slot(swp_entry_t entry)
 {
 	struct swap_slots_cache *cache;
 
+	/* Large folio swap slot is not covered. */
+	zswap_invalidate(entry);
+
 	cache = raw_cpu_ptr(&swp_slots);
 	if (likely(use_swap_slot_cache && cache->slots_ret)) {
 		spin_lock_irq(&cache->free_lock);
--- a/mm/zswap.c~mm-zswap-invalidate-zswap-entry-when-swap-entry-free
+++ a/mm/zswap.c
@@ -1739,9 +1739,10 @@ bool zswap_load(struct folio *folio)
 	return true;
 }
 
-void zswap_invalidate(int type, pgoff_t offset)
+void zswap_invalidate(swp_entry_t swp)
 {
-	struct zswap_tree *tree = swap_zswap_tree(swp_entry(type, offset));
+	pgoff_t offset = swp_offset(swp);
+	struct zswap_tree *tree = swap_zswap_tree(swp);
 	struct zswap_entry *entry;
 
 	spin_lock(&tree->lock);
_

Patches currently in -mm which might be from zhouchengming@bytedance.com are

mm-zsmalloc-fix-migrate_write_lock-when-config_compaction.patch
mm-zsmalloc-remove-migrate_write_lock_nested.patch
mm-zsmalloc-remove-unused-zspage-isolated.patch
mm-zswap-global-lru-and-shrinker-shared-by-all-zswap_pools.patch
mm-zswap-change-zswap_pool-kref-to-percpu_ref.patch
mm-zsmalloc-remove-set_zspage_mapping.patch
mm-zsmalloc-remove_zspage-dont-need-fullness-parameter.patch
mm-zsmalloc-remove-get_zspage_mapping.patch
maintainers-add-chengming-zhou-as-a-zswap-reviewer.patch

