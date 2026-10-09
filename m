Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A5FB41D22B
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 05:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525597; cv=none; b=oxda7uhNI9WFX0BkaQQmTtYi6Ns0Sjv/iwxv7OcEooxMPva4PZhyFpWDgl+Nr5Nl4jJ4Yg/m+Mtw4HiRKSbZFWOf+WLOoIxSKpwx5Cd69+ucx/bizTiV6YBNGjYzhT+Ft15Pu5rN3vOXSkhp3x6llEaLYwpOewJ6T4BXgTpA+hY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525597; c=relaxed/simple;
	bh=3/F6X6jQ9k+CwCovp0BQWSE2XBF4OOWk/xf8rl9QimU=;
	h=Date:To:From:Subject:Message-Id; b=nbkXO8f0BrB/HteRrdEnVppMBHMBnyWsCUQUwYjH+9ossW/pFNIrZfDV9k6Ks4NkULjCoToJ7gy/IQxa7jICjlI3PTqxD6htL0BSlUyKG8DWbwicR/wS7OKH5yy0VNGvTm4PdwyL75hObvEtJhHDeZNx4o+QQoaN9ZFGJh3oQVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0Gwtde8L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0Gwtde8L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFCC01F00893;
	Fri,  9 Oct 2026 05:59:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525596;
	bh=ajHgbuATPmy9hPXZMUCLbPdjZaYJbzVg6q5efnIbts4=;
	h=Date:To:From:Subject;
	b=0Gwtde8LCjPRkhiMYkn9bIwnEUFgS2SdtGTq6s7oWuJ3j9JksWnJ25UzAvuvlJl5u
	 vMf9bxpNUaqo1NxwD0gUJ4JYPaqEjzaeqxTH/omq53f5xIOK46+lF6JIDEj6KMJ+NM
	 lMCgbAoS2I8Goz5bB0RfkcvRrSDtafd8gsxmiI74=
Date: Thu, 08 Oct 2026 22:59:55 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,youngjun.park@lge.com,yeoreum.yun@arm.com,vbabka@kernel.org,usama.arif@linux.dev,surenb@google.com,shivamkalra98@zohomail.in,shikemeng@huaweicloud.com,ryncsn@gmail.com,ryan.roberts@arm.com,rppt@kernel.org,nphamcs@gmail.com,nico.pache@linux.dev,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,kas@kernel.org,dev.jain@arm.com,david@kernel.org,chrisl@kernel.org,baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-huge_memory-split-the-routine-for-splitting-anon-and-file-folio.patch removed from -mm tree
Message-Id: <20261009055955.EFCC01F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/huge_memory: split the routine for splitting anon and file folio
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-split-the-routine-for-splitting-anon-and-file-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm/huge_memory: split the routine for splitting anon and file folio
Date: Wed, 23 Sep 2026 23:32:35 +0200

No functional change intended.  Before adding more logic, split
__folio_freeze_and_split_unmapped() into an anon and a file variant so
each path can evolve independently.  The two paths shared little beyond
the folio freeze call, the LRU locking, and the unfreeze skeleton, but
differed in all other per-folio bookkeeping and routines.

While splitting, some cleanups become easy to apply, and helped drop a few
now-redundant checks.

The zone_device_private_split_cb() calls are only kept in the anon
variant, as device private folios can only back anonymous memory, and add
a VM_WARN_ON_ONCE_FOLIO() at the entry of the file variant.

Link: https://lore.kernel.org/20260923-swap-thp-cleanup-v6-4-ba1b4ba72c6f@tencent.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Youngjun Park <youngjun.park@lge.com>
Cc: Shivam Kalra <shivamkalra98@zohomail.in>
Cc: Kairui Song <ryncsn@gmail.com>
---

 mm/huge_memory.c |  124 ++++++++++++++++++++++++++++-----------------
 1 file changed, 78 insertions(+), 46 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-split-the-routine-for-splitting-anon-and-file-folio
+++ a/mm/huge_memory.c
@@ -4007,11 +4007,9 @@ static void folio_reset_partially_mapped
 		      MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
 }
 
-static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int new_order,
-					     struct page *split_at, struct xa_state *xas,
-					     struct address_space *mapping, bool do_lru,
-					     struct list_head *list, enum split_type split_type,
-					     pgoff_t end, int *nr_shmem_dropped)
+static int __folio_freeze_split_anon(struct folio *folio,
+		unsigned int new_order, struct page *split_at, bool do_lru,
+		struct list_head *list, enum split_type split_type)
 {
 	struct folio *end_folio = folio_next(folio);
 	struct swap_cluster_info *ci = NULL;
@@ -4019,8 +4017,6 @@ static int __folio_freeze_and_split_unma
 	struct lruvec *lruvec;
 	int ret = 0;
 
-	VM_WARN_ON_ONCE(!mapping && end);
-
 	if (!folio_ref_freeze(folio, folio_cache_ref_count(folio) + 1))
 		return -EAGAIN;
 
@@ -4035,24 +4031,75 @@ static int __folio_freeze_and_split_unma
 	 */
 	folio_reset_partially_mapped(folio);
 
-	if (mapping) {
+	if (folio_test_swapcache(folio))
+		ci = swap_cluster_get_and_lock(folio);
+
+	if (do_lru)
+		lruvec = folio_lruvec_lock(folio);
+
+	ret = __split_unmapped_folio(folio, new_order, split_at, NULL,
+				     NULL, split_type);
+
+	/*
+	 * Unfreeze the after-split folios and put them back to the right
+	 * place. Keep the head @folio frozen until the end: sub entries
+	 * in swap cache must be updated first, so a concurrent
+	 * swap_cache_get_folio() cannot return the head folio for a sub
+	 * entry (folio_try_get() will fail on the head @folio until unfreeze).
+	 */
+	for (new_folio = folio_next(folio); new_folio != end_folio;
+	     new_folio = next) {
+		next = folio_next(new_folio);
+		zone_device_private_split_cb(folio, new_folio);
+		folio_ref_unfreeze(new_folio,
+				   folio_cache_ref_count(new_folio) + 1);
+		if (do_lru)
+			lru_add_split_folio(folio, new_folio, lruvec, list);
+		if (ci)
+			__swap_cache_replace_folio(ci, folio, new_folio);
+	}
+
+	zone_device_private_split_cb(folio, NULL);
+	folio_ref_unfreeze(folio, folio_cache_ref_count(folio) + 1);
+
+	if (do_lru)
+		lruvec_unlock(lruvec);
+	if (ci)
+		swap_cluster_unlock(ci);
+
+	return ret;
+}
+
+static int __folio_freeze_split_file(struct folio *folio,
+		unsigned int new_order, struct page *split_at,
+		struct xa_state *xas, struct address_space *mapping,
+		bool do_lru, struct list_head *list,
+		enum split_type split_type, pgoff_t end, int *nr_shmem_dropped)
+{
+	struct folio *end_folio = folio_next(folio);
+	struct folio *new_folio, *next;
+	struct lruvec *lruvec;
+	int ret;
+
+	/* Currently device private folios can only back anonymous memory. */
+	VM_WARN_ON_ONCE_FOLIO(folio_is_device_private(folio), folio);
+
+	if (!folio_ref_freeze(folio, folio_cache_ref_count(folio) + 1))
+		return -EAGAIN;
+
+	if (folio_test_pmd_mappable(folio) &&
+	    new_order < HPAGE_PMD_ORDER) {
 		int nr = folio_nr_pages(folio);
 
-		if (folio_test_pmd_mappable(folio) &&
-		    new_order < HPAGE_PMD_ORDER) {
-			if (folio_test_swapbacked(folio)) {
-				lruvec_stat_mod_folio(folio,
-						NR_SHMEM_THPS, -nr);
-			} else {
-				lruvec_stat_mod_folio(folio,
-						NR_FILE_THPS, -nr);
-			}
+		if (folio_test_swapbacked(folio)) {
+			lruvec_stat_mod_folio(folio,
+					NR_SHMEM_THPS, -nr);
+		} else {
+			lruvec_stat_mod_folio(folio,
+					NR_FILE_THPS, -nr);
 		}
 	}
 
-	if (folio_test_swapcache(folio))
-		ci = swap_cluster_get_and_lock(folio);
-
 	/* lock lru list/PageCompound, ref frozen by page_ref_freeze */
 	if (do_lru)
 		lruvec = folio_lruvec_lock(folio);
@@ -4062,7 +4109,7 @@ static int __folio_freeze_and_split_unma
 
 	/*
 	 * Unfreeze after-split folios and put them back to the right
-	 * list. @folio should be kept frozon until page cache
+	 * list. @folio should be kept frozen until page cache
 	 * entries are updated with all the other after-split folios
 	 * to prevent others seeing stale page cache entries.
 	 * As a result, new_folio starts from the next folio of
@@ -4072,29 +4119,15 @@ static int __folio_freeze_and_split_unma
 	     new_folio = next) {
 		unsigned long nr_pages = folio_nr_pages(new_folio);
 
+		/* compute next before the folio can be freed below */
 		next = folio_next(new_folio);
 
-		zone_device_private_split_cb(folio, new_folio);
-
 		folio_ref_unfreeze(new_folio,
 				   folio_cache_ref_count(new_folio) + 1);
 
 		if (do_lru)
 			lru_add_split_folio(folio, new_folio, lruvec, list);
 
-		/*
-		 * Anonymous folio with swap cache.
-		 * NOTE: shmem in swap cache is not supported yet.
-		 */
-		if (ci) {
-			__swap_cache_replace_folio(ci, folio, new_folio);
-			continue;
-		}
-
-		/* Anonymous folio without swap cache */
-		if (!mapping)
-			continue;
-
 		/* Add the new folio to the page cache. */
 		if (new_folio->index < end) {
 			__xa_store(&mapping->i_pages, new_folio->index,
@@ -4113,7 +4146,6 @@ static int __folio_freeze_and_split_unma
 		folio_put_refs(new_folio, nr_pages);
 	}
 
-	zone_device_private_split_cb(folio, NULL);
 	/*
 	 * Unfreeze @folio only after all page cache entries, which
 	 * used to point to it, have been updated with new folios.
@@ -4125,9 +4157,6 @@ static int __folio_freeze_and_split_unma
 	if (do_lru)
 		lruvec_unlock(lruvec);
 
-	if (ci)
-		swap_cluster_unlock(ci);
-
 	return ret;
 }
 
@@ -4269,7 +4298,10 @@ static int __folio_split(struct folio *f
 
 	/* block interrupt reentry in xa_lock and spinlock */
 	local_irq_disable();
-	if (mapping) {
+	if (is_anon) {
+		ret = __folio_freeze_split_anon(folio, new_order, split_at,
+						true, list, split_type);
+	} else {
 		/*
 		 * Check if the folio is present in page cache.
 		 * We assume all tail are present too, if folio is there.
@@ -4280,10 +4312,11 @@ static int __folio_split(struct folio *f
 			ret = -EAGAIN;
 			goto fail;
 		}
+		ret = __folio_freeze_split_file(folio, new_order, split_at, &xas, mapping,
+						true, list, split_type, end,
+						&nr_shmem_dropped);
 	}
 
-	ret = __folio_freeze_and_split_unmapped(folio, new_order, split_at, &xas, mapping,
-						true, list, split_type, end, &nr_shmem_dropped);
 fail:
 	if (mapping)
 		xas_unlock(&xas);
@@ -4383,9 +4416,8 @@ int folio_split_unmapped(struct folio *f
 		return -EAGAIN;
 
 	local_irq_disable();
-	ret = __folio_freeze_and_split_unmapped(folio, new_order, &folio->page, NULL,
-						NULL, false, NULL, SPLIT_TYPE_UNIFORM,
-						0, NULL);
+	ret = __folio_freeze_split_anon(folio, new_order, &folio->page,
+					false, NULL, SPLIT_TYPE_UNIFORM);
 	local_irq_enable();
 	return ret;
 }
_

Patches currently in -mm which might be from kasong@tencent.com are


