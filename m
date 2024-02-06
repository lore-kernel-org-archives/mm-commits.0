Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2935838D
	for <mm-commits@vger.kernel.org>; Tue,  6 Feb 2024 00:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707178522; cv=none; b=fqM7VyRdseBHCuD9w0vTVupvZUM5/txzhMiJomRxBPN2PlvvhCBGP3cqt/n1GN6SiDv/fh+kMcmge6u1JYVUEib5EEXsPIjESyt9yTwWYkNF9VrtoIc47+pa2G4RrXc/qzKy4ZiWBblVBK1eHAXDAwF8I2ZGzRPe9MthOeYm7i8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707178522; c=relaxed/simple;
	bh=f8zy9qE7uNn0On3h3Ec8tNUPQC0LvaZckkjOAbQY+9Y=;
	h=Date:To:From:Subject:Message-Id; b=QXmtnNoeqPzwWYQ5+4AIOOiyH3TZ032rWVp5K8ZpMlZ1oDMOeO77jjUbm4TYFE2qFWome63qRGcLY8QyKjMBG9KyXYW9tU7BKAk16at30VpZGk1Qv5CqDyP3Khg9huZ38w7DzyFiQpfp0xjjYKwHckmjhR8XdSg+jcBYIhTcW1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bAcsKkLZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bAcsKkLZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D47FC433F1;
	Tue,  6 Feb 2024 00:15:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707178521;
	bh=f8zy9qE7uNn0On3h3Ec8tNUPQC0LvaZckkjOAbQY+9Y=;
	h=Date:To:From:Subject:From;
	b=bAcsKkLZlS2/nEwhUYMt+GtflYB7xcCnYVc5H2ScLmPPWNEQNMICRbQ/9XwJXUG07
	 hem9njHElxkWdnIMvXCzS7Kt7pOEnbXl5jCXQOeyEn60SJ0+V0Nyu9GTEKEEpinNzE
	 IOlGBOQPjEuP5xMN56dKbyLwL6wXpER8kDwco+Fw=
Date: Mon, 05 Feb 2024 16:15:21 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,nphamcs@gmail.com,hannes@cmpxchg.org,zhouchengming@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-invalidate-zswap-entry-when-swap-entry-free.patch added to mm-unstable branch
Message-Id: <20240206001521.8D47FC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/zswap: invalidate zswap entry when swap entry free
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zswap-invalidate-zswap-entry-when-swap-entry-free.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-invalidate-zswap-entry-when-swap-entry-free.patch

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
@@ -1738,9 +1738,10 @@ bool zswap_load(struct folio *folio)
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

mm-zswap-dont-return-lru_skip-if-we-have-dropped-lru-lock.patch
mm-zswap-make-sure-each-swapfile-always-have-zswap-rb-tree.patch
mm-zswap-split-zswap-rb-tree.patch
mm-zswap-fix-race-between-lru-writeback-and-swapoff.patch
mm-list_lru-remove-list_lru_putback.patch
mm-zswap-add-more-comments-in-shrink_memcg_cb.patch
mm-zswap-invalidate-zswap-entry-when-swap-entry-free.patch
mm-zswap-stop-lru-list-shrinking-when-encounter-warm-region.patch
mm-zswap-remove-duplicate_entry-debug-value.patch
mm-zswap-only-support-zswap_exclusive_loads_enabled.patch
mm-zswap-zswap-entry-doesnt-need-refcount-anymore.patch

