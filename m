Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FD90429013
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 06:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525617; cv=none; b=MnpwEb+KMCZQ1HScPOp9zCoinTdvnz6PKNEz0HHFc4vnUbFjbbKZOdw56e0eNVdArJllQ46m/X6rXXao74i2UEU9xTNaizWhWQUPvdZS5axVn1pNbQySSlafc2M+jFWUvaT9C58O2FW4dVVsC42TsBFQUjufg6dMtEXvmOMqC1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525617; c=relaxed/simple;
	bh=S94QAbO3xhl4Vvat8ulqcA8saQr6VXcqBD9AYCYyYgQ=;
	h=Date:To:From:Subject:Message-Id; b=hMloa5lo95JveSL377fPuh/wgGMtSkm2+5Tod6VwZguVw6socedWrPHM0bLQKdqnY5lF8mvEnlgNVS+QBCnO2XEQa1Gh4A0F38KFizOvT05RcM6hLz5fvVbxlgH3QDfctQTlb7GO08BFOfPDdGFWLLWcdVATbzytJiDeys5EQv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CZl9gtUu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CZl9gtUu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 338FF1F00893;
	Fri,  9 Oct 2026 06:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525615;
	bh=dB82Ed4wi/zzxlEqvwerGV4ZS376pqyAs1J8y/dlHCM=;
	h=Date:To:From:Subject;
	b=CZl9gtUu3wfq5tikVdbrhyxjfDNtp13qBOyKwRCOUepnelbrBf29JM4fiTxrmLqW+
	 TSt/W9FQvo3wyQL/pUsBY2PKikBi339oCiTyHJolpG2DQ9CpCCpFwuvr96oMOmaIaj
	 1pJeV9nKFo1oSHVr2Hf0u/DlPvo1BJnERsps6EhA=
Date: Thu, 08 Oct 2026 23:00:14 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,youngjun.park@lge.com,yeoreum.yun@arm.com,vbabka@kernel.org,usama.arif@linux.dev,surenb@google.com,shivamkalra98@zohomail.in,shikemeng@huaweicloud.com,ryncsn@gmail.com,ryan.roberts@arm.com,rppt@kernel.org,nphamcs@gmail.com,nico.pache@linux.dev,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,kas@kernel.org,dev.jain@arm.com,david@kernel.org,chrisl@kernel.org,baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-huge_memory-count-only-swap-cache-refs-in-anon-folio-split.patch removed from -mm tree
Message-Id: <20261009060015.338FF1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/huge_memory: count only swap cache refs in anon folio split
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-count-only-swap-cache-refs-in-anon-folio-split.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm/huge_memory: count only swap cache refs in anon folio split
Date: Wed, 23 Sep 2026 23:32:47 +0200

Only __folio_freeze_split_anon() sees anon folios and swap cache folios
now.  The file split helper only handles page cache folios, which hold
exactly folio_nr_pages() references.

Rename folio_cache_ref_count() to folio_swapcache_ref_count() and drop the
anon check so the helper counts what its name says.  The file split helper
now uses folio_nr_pages() directly.

No feature change.

Link: https://lore.kernel.org/20260923-swap-thp-cleanup-v6-16-ba1b4ba72c6f@tencent.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
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

 mm/huge_memory.c |   35 +++++++++++++++--------------------
 1 file changed, 15 insertions(+), 20 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-count-only-swap-cache-refs-in-anon-folio-split
+++ a/mm/huge_memory.c
@@ -3997,10 +3997,10 @@ int folio_check_splittable(struct folio
 	return 0;
 }
 
-/* Number of folio references from the pagecache or the swapcache. */
-static unsigned int folio_cache_ref_count(const struct folio *folio)
+/* Number of folio references from the swapcache. */
+static unsigned int folio_swapcache_ref_count(const struct folio *folio)
 {
-	if (folio_test_anon(folio) && !folio_test_swapcache(folio))
+	if (!folio_test_swapcache(folio))
 		return 0;
 	return folio_nr_pages(folio);
 }
@@ -4067,7 +4067,7 @@ static int __folio_freeze_split_anon(str
 
 	local_irq_disable();
 
-	if (!folio_ref_freeze(folio, folio_cache_ref_count(folio) + 1)) {
+	if (!folio_ref_freeze(folio, folio_swapcache_ref_count(folio) + 1)) {
 		ret = -EAGAIN;
 		goto out_no_split;
 	}
@@ -4104,7 +4104,7 @@ static int __folio_freeze_split_anon(str
 		next = folio_next(new_folio);
 		zone_device_private_split_cb(folio, new_folio);
 		folio_ref_unfreeze(new_folio,
-				   folio_cache_ref_count(new_folio) + 1);
+				   folio_swapcache_ref_count(new_folio) + 1);
 		if (do_lru)
 			lru_add_split_folio(folio, new_folio, lruvec, list);
 		if (ci)
@@ -4112,7 +4112,7 @@ static int __folio_freeze_split_anon(str
 	}
 
 	zone_device_private_split_cb(folio, NULL);
-	folio_ref_unfreeze(folio, folio_cache_ref_count(folio) + 1);
+	folio_ref_unfreeze(folio, folio_swapcache_ref_count(folio) + 1);
 
 	if (do_lru)
 		lruvec_unlock(lruvec);
@@ -4138,6 +4138,7 @@ static int __folio_freeze_split_file(str
 		unsigned int new_order, struct page *split_at,
 		struct list_head *list, enum split_type split_type)
 {
+	const long old_nr_pages = folio_nr_pages(folio);
 	struct address_space *mapping = folio->mapping;
 	XA_STATE(xas, &mapping->i_pages, folio->index);
 	struct folio *end_folio = folio_next(folio);
@@ -4211,22 +4212,16 @@ static int __folio_freeze_split_file(str
 		goto fail;
 	}
 
-	if (!folio_ref_freeze(folio, folio_cache_ref_count(folio) + 1)) {
+	if (!folio_ref_freeze(folio, old_nr_pages + 1)) {
 		ret = -EAGAIN;
 		goto fail;
 	}
 
-	if (folio_test_pmd_mappable(folio) &&
-	    new_order < HPAGE_PMD_ORDER) {
-		int nr = folio_nr_pages(folio);
-
-		if (folio_test_swapbacked(folio)) {
-			lruvec_stat_mod_folio(folio,
-					NR_SHMEM_THPS, -nr);
-		} else {
-			lruvec_stat_mod_folio(folio,
-					NR_FILE_THPS, -nr);
-		}
+	if (folio_test_pmd_mappable(folio) && new_order < HPAGE_PMD_ORDER) {
+		if (folio_test_swapbacked(folio))
+			lruvec_stat_mod_folio(folio, NR_SHMEM_THPS, -old_nr_pages);
+		else
+			lruvec_stat_mod_folio(folio, NR_FILE_THPS, -old_nr_pages);
 	}
 
 	/* lock lru list/PageCompound, ref frozen by page_ref_freeze */
@@ -4250,7 +4245,7 @@ static int __folio_freeze_split_file(str
 		next = folio_next(new_folio);
 
 		folio_ref_unfreeze(new_folio,
-				   folio_cache_ref_count(new_folio) + 1);
+				   folio_nr_pages(new_folio) + 1);
 
 		lru_add_split_folio(folio, new_folio, lruvec, list);
 
@@ -4277,7 +4272,7 @@ static int __folio_freeze_split_file(str
 	 * Otherwise, a parallel folio_try_get() can grab @folio
 	 * and its caller can see stale page cache entries.
 	 */
-	folio_ref_unfreeze(folio, folio_cache_ref_count(folio) + 1);
+	folio_ref_unfreeze(folio, folio_nr_pages(folio) + 1);
 	lruvec_unlock(lruvec);
 fail:
 	xas_unlock_irq(&xas);
_

Patches currently in -mm which might be from kasong@tencent.com are


