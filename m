Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6E18F516
	for <mm-commits@vger.kernel.org>; Thu, 21 Mar 2024 23:25:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711063528; cv=none; b=Jv4HMzB6MJCrSMDlwtNk26fSPphdLWGLixXCu4yLs0eXcJnNVaXi6lI5xrlJR8dAZzKvDUD7tVarcdi0q9OGEloq1Ja6s3s716PVpeJg/Alc36y3rLrWk/BuZ+rirOL29vHGF3Jx3N6Rp8kNLfxPNecyjKzEQ1o79+CP86kxDPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711063528; c=relaxed/simple;
	bh=u7xTgq0ePRxLfCL3ORsDY8oQIncbfvpSfvjoBuTe/Dc=;
	h=Date:To:From:Subject:Message-Id; b=kjwTU5Jo/UIyC8vVxIPP8w/RaRJUaC7s+SkcOtQ0Y2Pb5cPsRRGX65L3NkEG2LPIs0Az7FdXXwEK8EbND2uXtJ+ky2WiEPCEmjhAMXVOI4KcqvvBHS2sQ6mnw45ekiEfaYn8khmurPF1LIPEaA41ID9Flg4mQ670POvtrWB+Njk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WCL/G8IA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WCL/G8IA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 216C5C433F1;
	Thu, 21 Mar 2024 23:25:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711063528;
	bh=u7xTgq0ePRxLfCL3ORsDY8oQIncbfvpSfvjoBuTe/Dc=;
	h=Date:To:From:Subject:From;
	b=WCL/G8IAbXXMp4ZcXBBnSbYAtz7BWxLMpbUQCp3QEggohzJ8SNwAtBP3xdxpb40WI
	 WHt7kdSrSQ3AWFl8GV9eA/M7onQVN3BuMgXUCN812kjt8/j20wgQdxT/KetPbvcKHw
	 /EKydJMBdWaL4s+W3+N6m9z5w/Zxkcm0yDpPBwGQ=
Date: Thu, 21 Mar 2024 16:25:27 -0700
To: mm-commits@vger.kernel.org,ying.huang@intel.com,willy@infradead.org,shy828301@gmail.com,ryan.roberts@arm.com,kirill.shutemov@linux.intel.com,fengwei.yin@intel.com,baolin.wang@linux.alibaba.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-migrate-split-source-folio-if-it-is-on-deferred-split-list.patch removed from -mm tree
Message-Id: <20240321232528.216C5C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/migrate: split source folio if it is on deferred split list
has been removed from the -mm tree.  Its filename was
     mm-migrate-split-source-folio-if-it-is-on-deferred-split-list.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: mm/migrate: split source folio if it is on deferred split list
Date: Tue, 19 Mar 2024 11:47:53 -0400

If the source folio is on deferred split list, it is likely some subpages
are not used.  Split it before migration to avoid migrating unused
subpages.

Commit 616b8371539a6 ("mm: thp: enable thp migration in generic path") did
not check if a THP is on deferred split list before migration, thus, the
destination THP is never put on deferred split list even if the source THP
might be.  The opportunity of reclaiming free pages in a partially mapped
THP during deferred list scanning is lost, but no other harmful
consequence is present[1].

[1]: https://lore.kernel.org/linux-mm/03CE3A00-917C-48CC-8E1C-6A98713C817C@nvidia.com/

Link: https://lkml.kernel.org/r/20240319154753.253262-1-zi.yan@sent.com
Fixes: 616b8371539a ("mm: thp: enable thp migration in generic path")
Signed-off-by: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Huang, Ying <ying.huang@intel.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yin Fengwei <fengwei.yin@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   22 ----------------
 mm/internal.h    |   23 +++++++++++++++++
 mm/migrate.c     |   60 ++++++++++++++++++++++++++++++++++++---------
 3 files changed, 72 insertions(+), 33 deletions(-)

--- a/mm/huge_memory.c~mm-migrate-split-source-folio-if-it-is-on-deferred-split-list
+++ a/mm/huge_memory.c
@@ -766,28 +766,6 @@ pmd_t maybe_pmd_mkwrite(pmd_t pmd, struc
 	return pmd;
 }
 
-#ifdef CONFIG_MEMCG
-static inline
-struct deferred_split *get_deferred_split_queue(struct folio *folio)
-{
-	struct mem_cgroup *memcg = folio_memcg(folio);
-	struct pglist_data *pgdat = NODE_DATA(folio_nid(folio));
-
-	if (memcg)
-		return &memcg->deferred_split_queue;
-	else
-		return &pgdat->deferred_split_queue;
-}
-#else
-static inline
-struct deferred_split *get_deferred_split_queue(struct folio *folio)
-{
-	struct pglist_data *pgdat = NODE_DATA(folio_nid(folio));
-
-	return &pgdat->deferred_split_queue;
-}
-#endif
-
 void folio_prep_large_rmappable(struct folio *folio)
 {
 	if (!folio || !folio_test_large(folio))
--- a/mm/internal.h~mm-migrate-split-source-folio-if-it-is-on-deferred-split-list
+++ a/mm/internal.h
@@ -1106,6 +1106,29 @@ struct page *follow_trans_huge_pmd(struc
 				   unsigned long addr, pmd_t *pmd,
 				   unsigned int flags);
 
+#ifdef CONFIG_MEMCG
+static inline
+struct deferred_split *get_deferred_split_queue(struct folio *folio)
+{
+	struct mem_cgroup *memcg = folio_memcg(folio);
+	struct pglist_data *pgdat = NODE_DATA(folio_nid(folio));
+
+	if (memcg)
+		return &memcg->deferred_split_queue;
+	else
+		return &pgdat->deferred_split_queue;
+}
+#else
+static inline
+struct deferred_split *get_deferred_split_queue(struct folio *folio)
+{
+	struct pglist_data *pgdat = NODE_DATA(folio_nid(folio));
+
+	return &pgdat->deferred_split_queue;
+}
+#endif
+
+
 /*
  * mm/mmap.c
  */
--- a/mm/migrate.c~mm-migrate-split-source-folio-if-it-is-on-deferred-split-list
+++ a/mm/migrate.c
@@ -1654,25 +1654,63 @@ static int migrate_pages_batch(struct li
 
 			/*
 			 * Large folio migration might be unsupported or
-			 * the allocation might be failed so we should retry
-			 * on the same folio with the large folio split
+			 * the folio is on deferred split list so we should
+			 * retry on the same folio with the large folio split
 			 * to normal folios.
 			 *
 			 * Split folios are put in split_folios, and
 			 * we will migrate them after the rest of the
 			 * list is processed.
 			 */
-			if (!thp_migration_supported() && is_thp) {
-				nr_failed++;
-				stats->nr_thp_failed++;
-				if (!try_split_folio(folio, split_folios)) {
-					stats->nr_thp_split++;
-					stats->nr_split++;
+			if (is_thp) {
+				bool is_on_deferred_list = false;
+
+				/*
+				 * Check without taking split_queue_lock to
+				 * reduce locking overheads. The worst case is
+				 * that if the folio is put on the deferred
+				 * split list after the check, it will be
+				 * migrated and not put back on the list.
+				 * The migrated folio will not be split
+				 * via shrinker during memory pressure.
+				 */
+				if (!data_race(list_empty(&folio->_deferred_list))) {
+					struct deferred_split *ds_queue;
+					unsigned long flags;
+
+					ds_queue =
+						get_deferred_split_queue(folio);
+					spin_lock_irqsave(&ds_queue->split_queue_lock,
+							  flags);
+					/*
+					 * Only check if the folio is on
+					 * deferred split list without removing
+					 * it. Since the folio can be on
+					 * deferred_split_scan() local list and
+					 * removing it can cause the local list
+					 * corruption. Folio split process
+					 * below can handle it with the help of
+					 * folio_ref_freeze().
+					 */
+					is_on_deferred_list =
+						!list_empty(&folio->_deferred_list);
+					spin_unlock_irqrestore(&ds_queue->split_queue_lock,
+							       flags);
+				}
+				if (!thp_migration_supported() ||
+						is_on_deferred_list) {
+					nr_failed++;
+					stats->nr_thp_failed++;
+					if (!try_split_folio(folio,
+							     split_folios)) {
+						stats->nr_thp_split++;
+						stats->nr_split++;
+						continue;
+					}
+					stats->nr_failed_pages += nr_pages;
+					list_move_tail(&folio->lru, ret_folios);
 					continue;
 				}
-				stats->nr_failed_pages += nr_pages;
-				list_move_tail(&folio->lru, ret_folios);
-				continue;
 			}
 
 			rc = migrate_folio_unmap(get_new_folio, put_new_folio,
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-page_alloc-set-migratetype-inside-move_freepages.patch

