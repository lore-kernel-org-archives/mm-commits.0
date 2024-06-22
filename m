Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 922F14C91
	for <mm-commits@vger.kernel.org>; Sat, 22 Jun 2024 02:19:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719022763; cv=none; b=d50GZ8EYatrj5Tx2X71G1ZpBwXYMIThQQcPTywRAZlin7TXMf1E19m9dELW49CFE5PwrXveWazRmfseTNInTEPGXJ+R527PugC0zsThCSL8faojaBAnoV5hPi8Zy33bkETDQvj84QDEfTHXngwYarBa+j/upW16AwjG/eqEGja4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719022763; c=relaxed/simple;
	bh=jCSkAFZVdBfW4dGaKsNnyV1v9Ta0r++JQGJHCp4ug1I=;
	h=Date:To:From:Subject:Message-Id; b=s2rDm59yeNdwsEztciG/RjtFQaDtDdtVY3/DZljh9l8WoHlH9wKAa6fatN5oIqQ2IYQFTcoBc527zDqYr9vvGNwaJQmegK1ITFCWSXobkQYNkvv+o6j/Ls9G7tf/MhKcQi5FjGLUvIx/3K/52qP+MXr4yTWaEKOHfpSQVP/ae6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=N7Z6B3T5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="N7Z6B3T5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6C77C2BBFC;
	Sat, 22 Jun 2024 02:19:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719022762;
	bh=jCSkAFZVdBfW4dGaKsNnyV1v9Ta0r++JQGJHCp4ug1I=;
	h=Date:To:From:Subject:From;
	b=N7Z6B3T5yzvGdgRWw2+bCbqXSY1t4onpMHC85E/2xtqt3Ntigi9zI6tpXPLWkKJCc
	 Q25losC1x5cXwRoV3jFeCIo2BauZ0UH/KawCbc8XzXaRzUcIdcVqEIAFFwYALc6FjO
	 3i151yI+EtUcQF7b3UfvwxnVahwzvdruNsZMd6fk=
Date: Fri, 21 Jun 2024 19:19:22 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,donettom@linux.ibm.com,baolin.wang@linux.alibaba.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migrate-move-numa-hinting-fault-folio-isolation-checks-under-ptl.patch added to mm-unstable branch
Message-Id: <20240622021922.D6C77C2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/migrate: move NUMA hinting fault folio isolation + checks under PTL
has been added to the -mm mm-unstable branch.  Its filename is
     mm-migrate-move-numa-hinting-fault-folio-isolation-checks-under-ptl.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-migrate-move-numa-hinting-fault-folio-isolation-checks-under-ptl.patch

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
From: David Hildenbrand <david@redhat.com>
Subject: mm/migrate: move NUMA hinting fault folio isolation + checks under PTL
Date: Thu, 20 Jun 2024 23:29:35 +0200

Currently we always take a folio reference even if migration will not even
be tried or isolation failed, requiring us to grab+drop an additional
reference.

Further, we end up calling folio_likely_mapped_shared() while the folio
might have already been unmapped, because after we dropped the PTL, that
can easily happen.  We want to stop touching mapcounts and friends from
such context, and only call folio_likely_mapped_shared() while the folio
is still mapped: mapcount information is pretty much stale and unreliable
otherwise.

So let's move checks into numamigrate_isolate_folio(), rename that
function to migrate_misplaced_folio_prepare(), and call that function from
callsites where we call migrate_misplaced_folio(), but still with the PTL
held.

We can now stop taking temporary folio references, and really only take a
reference if folio isolation succeeded.  Doing the
folio_likely_mapped_shared() + folio isolation under PT lock is now
similar to how we handle MADV_PAGEOUT.

While at it, combine the folio_is_file_lru() checks.

Link: https://lkml.kernel.org/r/20240620212935.656243-3-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Tested-by: Donet Tom <donettom@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/migrate.h |    7 +++
 mm/huge_memory.c        |    8 ++-
 mm/memory.c             |    9 ++--
 mm/migrate.c            |   81 +++++++++++++++++---------------------
 4 files changed, 55 insertions(+), 50 deletions(-)

--- a/include/linux/migrate.h~mm-migrate-move-numa-hinting-fault-folio-isolation-checks-under-ptl
+++ a/include/linux/migrate.h
@@ -139,9 +139,16 @@ const struct movable_operations *page_mo
 }
 
 #ifdef CONFIG_NUMA_BALANCING
+int migrate_misplaced_folio_prepare(struct folio *folio,
+		struct vm_area_struct *vma, int node);
 int migrate_misplaced_folio(struct folio *folio, struct vm_area_struct *vma,
 			   int node);
 #else
+static inline int migrate_misplaced_folio_prepare(struct folio *folio,
+		struct vm_area_struct *vma, int node)
+{
+	return -EAGAIN; /* can't migrate now */
+}
 static inline int migrate_misplaced_folio(struct folio *folio,
 					 struct vm_area_struct *vma, int node)
 {
--- a/mm/huge_memory.c~mm-migrate-move-numa-hinting-fault-folio-isolation-checks-under-ptl
+++ a/mm/huge_memory.c
@@ -1688,11 +1688,13 @@ vm_fault_t do_huge_pmd_numa_page(struct
 	if (node_is_toptier(nid))
 		last_cpupid = folio_last_cpupid(folio);
 	target_nid = numa_migrate_prep(folio, vmf, haddr, nid, &flags);
-	if (target_nid == NUMA_NO_NODE) {
-		folio_put(folio);
+	if (target_nid == NUMA_NO_NODE)
+		goto out_map;
+	if (migrate_misplaced_folio_prepare(folio, vma, target_nid)) {
+		flags |= TNF_MIGRATE_FAIL;
 		goto out_map;
 	}
-
+	/* The folio is isolated and isolation code holds a folio reference. */
 	spin_unlock(vmf->ptl);
 	writable = false;
 
--- a/mm/memory.c~mm-migrate-move-numa-hinting-fault-folio-isolation-checks-under-ptl
+++ a/mm/memory.c
@@ -5207,8 +5207,6 @@ int numa_migrate_prep(struct folio *foli
 {
 	struct vm_area_struct *vma = vmf->vma;
 
-	folio_get(folio);
-
 	/* Record the current PID acceesing VMA */
 	vma_set_access_pid_bit(vma);
 
@@ -5345,10 +5343,13 @@ static vm_fault_t do_numa_page(struct vm
 	else
 		last_cpupid = folio_last_cpupid(folio);
 	target_nid = numa_migrate_prep(folio, vmf, vmf->address, nid, &flags);
-	if (target_nid == NUMA_NO_NODE) {
-		folio_put(folio);
+	if (target_nid == NUMA_NO_NODE)
+		goto out_map;
+	if (migrate_misplaced_folio_prepare(folio, vma, target_nid)) {
+		flags |= TNF_MIGRATE_FAIL;
 		goto out_map;
 	}
+	/* The folio is isolated and isolation code holds a folio reference. */
 	pte_unmap_unlock(vmf->pte, vmf->ptl);
 	writable = false;
 	ignore_writable = true;
--- a/mm/migrate.c~mm-migrate-move-numa-hinting-fault-folio-isolation-checks-under-ptl
+++ a/mm/migrate.c
@@ -2530,9 +2530,37 @@ static struct folio *alloc_misplaced_dst
 	return __folio_alloc_node(gfp, order, nid);
 }
 
-static int numamigrate_isolate_folio(pg_data_t *pgdat, struct folio *folio)
+/*
+ * Prepare for calling migrate_misplaced_folio() by isolating the folio if
+ * permitted. Must be called with the PTL still held.
+ */
+int migrate_misplaced_folio_prepare(struct folio *folio,
+		struct vm_area_struct *vma, int node)
 {
 	int nr_pages = folio_nr_pages(folio);
+	pg_data_t *pgdat = NODE_DATA(node);
+
+	if (folio_is_file_lru(folio)) {
+		/*
+		 * Do not migrate file folios that are mapped in multiple
+		 * processes with execute permissions as they are probably
+		 * shared libraries.
+		 *
+		 * See folio_likely_mapped_shared() on possible imprecision
+		 * when we cannot easily detect if a folio is shared.
+		 */
+		if ((vma->vm_flags & VM_EXEC) &&
+		    folio_likely_mapped_shared(folio))
+			return -EACCES;
+
+		/*
+		 * Do not migrate dirty folios as not all filesystems can move
+		 * dirty folios in MIGRATE_ASYNC mode which is a waste of
+		 * cycles.
+		 */
+		if (folio_test_dirty(folio))
+			return -EAGAIN;
+	}
 
 	/* Avoid migrating to a node that is nearly full */
 	if (!migrate_balanced_pgdat(pgdat, nr_pages)) {
@@ -2550,65 +2578,37 @@ static int numamigrate_isolate_folio(pg_
 		 * further.
 		 */
 		if (z < 0)
-			return 0;
+			return -EAGAIN;
 
 		wakeup_kswapd(pgdat->node_zones + z, 0,
 			      folio_order(folio), ZONE_MOVABLE);
-		return 0;
+		return -EAGAIN;
 	}
 
 	if (!folio_isolate_lru(folio))
-		return 0;
+		return -EAGAIN;
 
 	node_stat_mod_folio(folio, NR_ISOLATED_ANON + folio_is_file_lru(folio),
 			    nr_pages);
-
-	/*
-	 * Isolating the folio has taken another reference, so the
-	 * caller's reference can be safely dropped without the folio
-	 * disappearing underneath us during migration.
-	 */
-	folio_put(folio);
-	return 1;
+	return 0;
 }
 
 /*
  * Attempt to migrate a misplaced folio to the specified destination
- * node. Caller is expected to have an elevated reference count on
- * the folio that will be dropped by this function before returning.
+ * node. Caller is expected to have isolated the folio by calling
+ * migrate_misplaced_folio_prepare(), which will result in an
+ * elevated reference count on the folio. This function will un-isolate the
+ * folio, dereferencing the folio before returning.
  */
 int migrate_misplaced_folio(struct folio *folio, struct vm_area_struct *vma,
 			    int node)
 {
 	pg_data_t *pgdat = NODE_DATA(node);
-	int isolated;
 	int nr_remaining;
 	unsigned int nr_succeeded;
 	LIST_HEAD(migratepages);
 	int nr_pages = folio_nr_pages(folio);
 
-	/*
-	 * Don't migrate file folios that are mapped in multiple processes
-	 * with execute permissions as they are probably shared libraries.
-	 *
-	 * See folio_likely_mapped_shared() on possible imprecision when we
-	 * cannot easily detect if a folio is shared.
-	 */
-	if (folio_likely_mapped_shared(folio) && folio_is_file_lru(folio) &&
-	    (vma->vm_flags & VM_EXEC))
-		goto out;
-
-	/*
-	 * Also do not migrate dirty folios as not all filesystems can move
-	 * dirty folios in MIGRATE_ASYNC mode which is a waste of cycles.
-	 */
-	if (folio_is_file_lru(folio) && folio_test_dirty(folio))
-		goto out;
-
-	isolated = numamigrate_isolate_folio(pgdat, folio);
-	if (!isolated)
-		goto out;
-
 	list_add(&folio->lru, &migratepages);
 	nr_remaining = migrate_pages(&migratepages, alloc_misplaced_dst_folio,
 				     NULL, node, MIGRATE_ASYNC,
@@ -2620,7 +2620,6 @@ int migrate_misplaced_folio(struct folio
 					folio_is_file_lru(folio), -nr_pages);
 			folio_putback_lru(folio);
 		}
-		isolated = 0;
 	}
 	if (nr_succeeded) {
 		count_vm_numa_events(NUMA_PAGE_MIGRATE, nr_succeeded);
@@ -2629,11 +2628,7 @@ int migrate_misplaced_folio(struct folio
 					    nr_succeeded);
 	}
 	BUG_ON(!list_empty(&migratepages));
-	return isolated ? 0 : -EAGAIN;
-
-out:
-	folio_put(folio);
-	return -EAGAIN;
+	return nr_remaining ? -EAGAIN : 0;
 }
 #endif /* CONFIG_NUMA_BALANCING */
 #endif /* CONFIG_NUMA */
_

Patches currently in -mm which might be from david@redhat.com are

mm-memory-move-page_count-check-into-validate_page_before_insert.patch
mm-memory-cleanly-support-zeropage-in-vm_insert_page-vm_map_pages-and-vmf_insert_mixed.patch
mm-rmap-sanity-check-that-zeropages-are-not-passed-to-rmap.patch
fs-proc-task_mmu-indicate-pm_file-for-pmd-mapped-file-thp.patch
fs-proc-task_mmu-dont-indicate-pm_mmap_exclusive-without-pm_present.patch
fs-proc-task_mmu-properly-detect-pm_mmap_exclusive-per-page-of-pmd-mapped-thps.patch
fs-proc-task_mmu-account-non-present-entries-as-maybe-shared-but-no-idea-how-often.patch
fs-proc-move-page_mapcount-to-fs-proc-internalh.patch
documentation-admin-guide-mm-pagemaprst-drop-using-pagemap-to-do-something-useful.patch
mm-pass-meminit_context-to-__free_pages_core.patch
mm-pass-meminit_context-to-__free_pages_core-fix.patch
mm-pass-meminit_context-to-__free_pages_core-fix-2.patch
mm-pass-meminit_context-to-__free_pages_core-fix-3.patch
mm-memory_hotplug-initialize-memmap-of-zone_device-with-pageoffline-instead-of-pagereserved.patch
mm-memory_hotplug-skip-adjust_managed_page_count-for-pageoffline-pages-when-offlining.patch
mm-highmem-reimplement-totalhigh_pages-by-walking-zones.patch
mm-highmem-reimplement-totalhigh_pages-by-walking-zones-fix.patch
mm-highmem-make-nr_free_highpages-return-unsigned-long.patch
mm-read-page_type-using-read_once.patch
mm-migrate-make-migrate_misplaced_folio-return-0-on-success.patch
mm-migrate-move-numa-hinting-fault-folio-isolation-checks-under-ptl.patch

