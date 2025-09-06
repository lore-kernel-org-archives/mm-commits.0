Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0354717E4
	for <mm-commits@vger.kernel.org>; Sat,  6 Sep 2025 00:27:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757118438; cv=none; b=L5Za+fqXRBE7ozht2wJj/+80fz35y1wAXUsIcEeTIwKT6Yzk+4ZWrZgcSvgpCUduStEzaOjGSrdhB6JVwkUOE5f1OE4OWVtD5BG0JKFkMvc79jSlj6KHEnHq0uLoDFsSyqz16uom4fuuj21VHWhkCrAEnxe5KigD0pGQuq6qhVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757118438; c=relaxed/simple;
	bh=lRUwFwPCQ2aocRqkXmlDH/QGRXZScvYFj+px3ahS3nY=;
	h=Date:To:From:Subject:Message-Id; b=YOcepMbAhewoaQmcFXMoktAdEQM4XLzs28iHHVO/UuyIzCfk4onXO4IN/zXYilMBqXAvzK0J+cIi4B2qXfCKiztHgCdhUZ2Uw889BkHYiHtq8BRyI+lf2YOFx3pVSzQw1KsvCDnTrq9E/NOIN1rK5NXKajU1KrTcS5SmTv+8iVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Bdm/C5vq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Bdm/C5vq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3EBAC4CEF1;
	Sat,  6 Sep 2025 00:27:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757118437;
	bh=lRUwFwPCQ2aocRqkXmlDH/QGRXZScvYFj+px3ahS3nY=;
	h=Date:To:From:Subject:From;
	b=Bdm/C5vqF9PPjc1e+IMQ8ElkXfJ24M2+lXk/Krnb0Uzy0AuenT3bFpJoK36NNYyT+
	 TPJYbj4mGj5niTq32Dest0XxeNg7zzJyZlIGY9WGdRI/xTGB7PkZ6kz28PPcGit023
	 ZyKXr9sThX8GnovXicpC8sBOcTQqXb4jVQYCrZlw=
Date: Fri, 05 Sep 2025 17:27:17 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yosryahmed@google.com,ying.huang@linux.alibaba.com,willy@infradead.org,shikemeng@huaweicloud.com,oliver.sang@intel.com,nphamcs@gmail.com,lorenzo.stoakes@oracle.com,hughd@google.com,hannes@cmpxchg.org,david@redhat.com,chrisl@kernel.org,bhe@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-wrap-swap-cache-replacement-with-a-helper.patch added to mm-new branch
Message-Id: <20250906002717.C3EBAC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm, swap: wrap swap cache replacement with a helper
has been added to the -mm mm-new branch.  Its filename is
     mm-swap-wrap-swap-cache-replacement-with-a-helper.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-wrap-swap-cache-replacement-with-a-helper.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Kairui Song <kasong@tencent.com>
Subject: mm, swap: wrap swap cache replacement with a helper
Date: Sat, 6 Sep 2025 03:13:52 +0800

There are currently three swap cache users that are trying to replace an
existing folio with a new one: huge memory splitting, migration, and shmem
replacement.  What they are doing is quite similar.

Introduce a common helper for this.  In later commits, they can be easily
switched to use the swap table by updating this helper.

The newly added helper also makes the swap cache API better defined, and
debugging is easier.

Link: https://lkml.kernel.org/r/20250905191357.78298-11-ryncsn@gmail.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    5 ++---
 mm/migrate.c     |   11 +++--------
 mm/shmem.c       |   10 ++--------
 mm/swap.h        |    3 +++
 mm/swap_state.c  |   32 ++++++++++++++++++++++++++++++++
 5 files changed, 42 insertions(+), 19 deletions(-)

--- a/mm/huge_memory.c~mm-swap-wrap-swap-cache-replacement-with-a-helper
+++ a/mm/huge_memory.c
@@ -3798,9 +3798,8 @@ static int __folio_split(struct folio *f
 			 * NOTE: shmem in swap cache is not supported yet.
 			 */
 			if (swap_cache) {
-				__xa_store(&swap_cache->i_pages,
-					   swap_cache_index(new_folio->swap),
-					   new_folio, 0);
+				__swap_cache_replace_folio(swap_cache, new_folio->swap,
+							   folio, new_folio);
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
+		__swap_cache_replace_folio(mapping, folio->swap, folio, newfolio);
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
@@ -2118,12 +2116,8 @@ static int shmem_replace_folio(struct fo
 	new->swap = entry;
 	folio_set_swapcache(new);
 
-	/* Swap cache still stores N entries instead of a high-order entry */
 	xa_lock_irq(&swap_mapping->i_pages);
-	for (i = 0; i < nr_pages; i++) {
-		WARN_ON_ONCE(xas_store(&xas, new));
-		xas_next(&xas);
-	}
+	__swap_cache_replace_folio(swap_mapping, entry, old, new);
 	xa_unlock_irq(&swap_mapping->i_pages);
 
 	mem_cgroup_replace_folio(old, new);
--- a/mm/swap.h~mm-swap-wrap-swap-cache-replacement-with-a-helper
+++ a/mm/swap.h
@@ -182,6 +182,9 @@ int swap_cache_add_folio(struct folio *f
 void swap_cache_del_folio(struct folio *folio);
 void __swap_cache_del_folio(struct folio *folio,
 			    swp_entry_t entry, void *shadow);
+void __swap_cache_replace_folio(struct address_space *address_space,
+				swp_entry_t entry,
+				struct folio *old, struct folio *new);
 void swap_cache_clear_shadow(int type, unsigned long begin,
 			     unsigned long end);
 
--- a/mm/swap_state.c~mm-swap-wrap-swap-cache-replacement-with-a-helper
+++ a/mm/swap_state.c
@@ -235,6 +235,38 @@ void swap_cache_del_folio(struct folio *
 }
 
 /**
+ * __swap_cache_replace_folio - Replace a folio in the swap cache.
+ * @mapping: Swap mapping address space.
+ * @entry: The first swap entry that the new folio corresponds to.
+ * @old: The old folio to be replaced.
+ * @new: The new folio.
+ *
+ * Replace a existing folio in the swap cache with a new folio.
+ *
+ * Context: Caller must ensure both folios are locked, and lock the
+ * swap address_space that holds the entries to be replaced.
+ */
+void __swap_cache_replace_folio(struct address_space *mapping,
+				swp_entry_t entry,
+				struct folio *old, struct folio *new)
+{
+	unsigned long nr_pages = folio_nr_pages(new);
+	unsigned long offset = swap_cache_index(entry);
+	unsigned long end = offset + nr_pages;
+	XA_STATE(xas, &mapping->i_pages, offset);
+
+	VM_WARN_ON_ONCE(entry.val != new->swap.val);
+	VM_WARN_ON_ONCE(!folio_test_locked(old) || !folio_test_locked(new));
+	VM_WARN_ON_ONCE(!folio_test_swapcache(old) || !folio_test_swapcache(new));
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

mm-swap-only-scan-one-cluster-in-fragment-list.patch
mm-swap-remove-fragment-clusters-counter.patch
mm-swap-prefer-nonfull-over-free-clusters.patch
mm-mincore-swap-consolidate-swap-cache-checking-for-mincore.patch
mm-mincore-use-a-helper-for-checking-the-swap-cache.patch
mm-page-writeback-drop-usage-of-folio_index.patch
mm-swap-use-unified-helper-for-swap-cache-look-up.patch
mm-swap-fix-swap-cahe-index-error-when-retrying-reclaim.patch
mm-swap-check-page-poison-flag-after-locking-it.patch
mm-swap-always-lock-and-check-the-swap-cache-folio-before-use.patch
mm-swap-rename-and-move-some-swap-cluster-definition-and-helpers.patch
mm-swap-tidy-up-swap-device-and-cluster-info-helpers.patch
mm-shmem-swap-remove-redundant-error-handling-for-replacing-folio.patch
mm-swap-cleanup-swap-cache-api-and-add-kerneldoc.patch
mm-swap-wrap-swap-cache-replacement-with-a-helper.patch
mm-swap-use-the-swap-table-for-the-swap-cache-and-switch-api.patch
mm-swap-mark-swap-address-space-ro-and-add-context-debug-check.patch
mm-swap-remove-contention-workaround-for-swap-cache.patch
mm-swap-implement-dynamic-allocation-of-swap-table.patch
mm-swap-use-a-single-page-for-swap-table-when-the-size-fits.patch

