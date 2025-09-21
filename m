Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9C2521D3C0
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 21:25:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758489946; cv=none; b=B1c7YCdG4YAweNokz4T0saP2soWHKIH9lsdMSOTzKvZicOTm0QObycNvphzLu59ldUVJqcenTSJwwJA138OW2qQpTqFi8aCbnvA1EsRyzpgYPPRdwBNiBAobIH6Ch69mfpRPGWgS6LhJdhP/sFgAdnFQlUosbUMa+nWrZE5iAww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758489946; c=relaxed/simple;
	bh=RH9gXH1K0GUvyERoK0gCwZ3vnvxuXijk1bRoYGbW8X4=;
	h=Date:To:From:Subject:Message-Id; b=EVUcv8j8A2puY8z5g/Fj9MuyY+of7xAIc5JF1EDfVZi45GulXmExBBj2faT5ztn2OGpv2+CprAHO+mRMM/E3l2HFauicTAzHn+6cBvIlhHdO+c6oWyOsbqe9Bw6eNcoCZsyFzXD0+4Ot2gn9aShSWBhEjf77FX2g8W7DX4GWoeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WpON54Uw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WpON54Uw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF722C4CEE7;
	Sun, 21 Sep 2025 21:25:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758489945;
	bh=RH9gXH1K0GUvyERoK0gCwZ3vnvxuXijk1bRoYGbW8X4=;
	h=Date:To:From:Subject:From;
	b=WpON54Uw2BtRQ6YWyoAoeyil2VE+b6sqTZp+xIS4OrGmSn85XDYZ5WA02gW5T9Ezq
	 //OGmOL/q6VwDBsR7JWvNJPnxd9kIZU/h9Z2V1F3hcHTUzEWt1EpniUYF0I6KieJD/
	 udvLe0P7IQhraPZQcbM+Ztf7HADZ7ZaYxpjkX+Yw=
Date: Sun, 21 Sep 2025 14:25:45 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yosryahmed@google.com,ying.huang@linux.alibaba.com,willy@infradead.org,sj@kernel.org,shikemeng@huaweicloud.com,oliver.sang@intel.com,nphamcs@gmail.com,lorenzo.stoakes@oracle.com,hughd@google.com,hannes@cmpxchg.org,david@redhat.com,chrisl@kernel.org,bhe@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-wrap-swap-cache-replacement-with-a-helper.patch removed from -mm tree
Message-Id: <20250921212545.BF722C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm, swap: wrap swap cache replacement with a helper
has been removed from the -mm tree.  Its filename was
     mm-swap-wrap-swap-cache-replacement-with-a-helper.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm, swap: wrap swap cache replacement with a helper
Date: Wed, 17 Sep 2025 00:00:55 +0800

There are currently three swap cache users that are trying to replace an
existing folio with a new one: huge memory splitting, migration, and shmem
replacement.  What they are doing is quite similar.

Introduce a common helper for this.  In later commits, this can be easily
switched to use the swap table by updating this helper.

The newly added helper also makes the swap cache API better defined, and
make debugging easier by adding a few more debug checks.

Migration and shmem replace are meant to clone the folio, including
content, swap entry value, and flags.  And splitting will adjust each sub
folio's swap entry according to order, which could be non-uniform in the
future.  So document it clearly that it's the caller's responsibility to
set up the new folio's swap entries and flags before calling the helper. 
The helper will just follow the new folio's entry value.

This also prepares for replacing high-order folios in the swap cache. 
Currently, only splitting to order 0 is allowed for swap cache folios. 
Using the new helper, we can handle high-order folio splitting better.

Link: https://lkml.kernel.org/r/20250916160100.31545-11-ryncsn@gmail.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Chris Li <chrisl@kernel.org>
Suggested-by: Chris Li <chrisl@kernel.org>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: kernel test robot <oliver.sang@intel.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    4 +---
 mm/migrate.c     |   11 +++--------
 mm/shmem.c       |   11 ++---------
 mm/swap.h        |    5 +++++
 mm/swap_state.c  |   33 +++++++++++++++++++++++++++++++++
 5 files changed, 44 insertions(+), 20 deletions(-)

--- a/mm/huge_memory.c~mm-swap-wrap-swap-cache-replacement-with-a-helper
+++ a/mm/huge_memory.c
@@ -3798,9 +3798,7 @@ static int __folio_split(struct folio *f
 			 * NOTE: shmem in swap cache is not supported yet.
 			 */
 			if (swap_cache) {
-				__xa_store(&swap_cache->i_pages,
-					   swap_cache_index(new_folio->swap),
-					   new_folio, 0);
+				__swap_cache_replace_folio(folio, new_folio);
 				continue;
 			}
 
--- a/mm/migrate.c~mm-swap-wrap-swap-cache-replacement-with-a-helper
+++ a/mm/migrate.c
@@ -566,7 +566,6 @@ static int __folio_migrate_mapping(struc
 	struct zone *oldzone, *newzone;
 	int dirty;
 	long nr = folio_nr_pages(folio);
-	long entries, i;
 
 	if (!mapping) {
 		/* Take off deferred split queue while frozen and memcg set */
@@ -615,9 +614,6 @@ static int __folio_migrate_mapping(struc
 	if (folio_test_swapcache(folio)) {
 		folio_set_swapcache(newfolio);
 		newfolio->private = folio_get_private(folio);
-		entries = nr;
-	} else {
-		entries = 1;
 	}
 
 	/* Move dirty while folio refs frozen and newfolio not yet exposed */
@@ -627,11 +623,10 @@ static int __folio_migrate_mapping(struc
 		folio_set_dirty(newfolio);
 	}
 
-	/* Swap cache still stores N entries instead of a high-order entry */
-	for (i = 0; i < entries; i++) {
+	if (folio_test_swapcache(folio))
+		__swap_cache_replace_folio(folio, newfolio);
+	else
 		xas_store(&xas, newfolio);
-		xas_next(&xas);
-	}
 
 	/*
 	 * Drop cache reference from old folio by unfreezing
--- a/mm/shmem.c~mm-swap-wrap-swap-cache-replacement-with-a-helper
+++ a/mm/shmem.c
@@ -2086,10 +2086,8 @@ static int shmem_replace_folio(struct fo
 	struct folio *new, *old = *foliop;
 	swp_entry_t entry = old->swap;
 	struct address_space *swap_mapping = swap_address_space(entry);
-	pgoff_t swap_index = swap_cache_index(entry);
-	XA_STATE(xas, &swap_mapping->i_pages, swap_index);
 	int nr_pages = folio_nr_pages(old);
-	int error = 0, i;
+	int error = 0;
 
 	/*
 	 * We have arrived here because our zones are constrained, so don't
@@ -2118,13 +2116,8 @@ static int shmem_replace_folio(struct fo
 	new->swap = entry;
 	folio_set_swapcache(new);
 
-	/* Swap cache still stores N entries instead of a high-order entry */
 	xa_lock_irq(&swap_mapping->i_pages);
-	for (i = 0; i < nr_pages; i++) {
-		WARN_ON_ONCE(xas_store(&xas, new) != old);
-		xas_next(&xas);
-	}
-
+	__swap_cache_replace_folio(old, new);
 	mem_cgroup_replace_folio(old, new);
 	shmem_update_stats(new, nr_pages);
 	shmem_update_stats(old, -nr_pages);
--- a/mm/swap.h~mm-swap-wrap-swap-cache-replacement-with-a-helper
+++ a/mm/swap.h
@@ -185,6 +185,7 @@ int swap_cache_add_folio(struct folio *f
 void swap_cache_del_folio(struct folio *folio);
 void __swap_cache_del_folio(struct folio *folio,
 			    swp_entry_t entry, void *shadow);
+void __swap_cache_replace_folio(struct folio *old, struct folio *new);
 void swap_cache_clear_shadow(int type, unsigned long begin,
 			     unsigned long end);
 
@@ -336,6 +337,10 @@ static inline void __swap_cache_del_foli
 {
 }
 
+static inline void __swap_cache_replace_folio(struct folio *old, struct folio *new)
+{
+}
+
 static inline unsigned int folio_swap_flags(struct folio *folio)
 {
 	return 0;
--- a/mm/swap_state.c~mm-swap-wrap-swap-cache-replacement-with-a-helper
+++ a/mm/swap_state.c
@@ -235,6 +235,39 @@ void swap_cache_del_folio(struct folio *
 }
 
 /**
+ * __swap_cache_replace_folio - Replace a folio in the swap cache.
+ * @old: The old folio to be replaced.
+ * @new: The new folio.
+ *
+ * Replace an existing folio in the swap cache with a new folio. The
+ * caller is responsible for setting up the new folio's flag and swap
+ * entries. Replacement will take the new folio's swap entry value as
+ * the starting offset to override all slots covered by the new folio.
+ *
+ * Context: Caller must ensure both folios are locked, also lock the
+ * swap address_space that holds the old folio to avoid races.
+ */
+void __swap_cache_replace_folio(struct folio *old, struct folio *new)
+{
+	swp_entry_t entry = new->swap;
+	unsigned long nr_pages = folio_nr_pages(new);
+	unsigned long offset = swap_cache_index(entry);
+	unsigned long end = offset + nr_pages;
+
+	XA_STATE(xas, &swap_address_space(entry)->i_pages, offset);
+
+	VM_WARN_ON_ONCE(!folio_test_swapcache(old) || !folio_test_swapcache(new));
+	VM_WARN_ON_ONCE(!folio_test_locked(old) || !folio_test_locked(new));
+	VM_WARN_ON_ONCE(!entry.val);
+
+	/* Swap cache still stores N entries instead of a high-order entry */
+	do {
+		WARN_ON_ONCE(xas_store(&xas, new) != old);
+		xas_next(&xas);
+	} while (++offset < end);
+}
+
+/**
  * swap_cache_clear_shadow - Clears a set of shadows in the swap cache.
  * @type: Indicates the swap device.
  * @begin: Beginning offset of the range.
_

Patches currently in -mm which might be from kasong@tencent.com are


