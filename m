Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18F492D7DE9
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:50:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334231; cv=none; b=CommIOz3+ZamE1bQSWoMhf+7tQTR7d+MxMvVldIKwMpq1bi2bwj5eMn4m9jDNq5xDOZyTcn21gzgPCcY2CsYncCndRRQI/oLB7zdPlFeXyx45lhbLLCJXhN+1WWrF7BY5gi8tG5d1groY2WR+K99/wIpRwOrcEIOEfKgXCyUazw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334231; c=relaxed/simple;
	bh=wDpC+dxnp/rawVfxE81YTA7YWiglTOHep1ZF2EOr9go=;
	h=Date:To:From:Subject:Message-Id; b=IyUJuz/8Mc8nZ9psrsVWqQ+I1uzKZ2h5tzYpebfkhFsklyA7GWEx7V1uY67qbR0YytvAJwLdIAEX4nHJiOT8KkJcdlfR2WRvGy00BJzi6dY3cg5IoxZhX9Cw6cAbkNnfjtLFkneaDfd4/zq/om+g5fbVwOL18dmKpkLCa7gttGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OdLsIy63; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OdLsIy63"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E17941F0089C;
	Wed,  7 Oct 2026 00:50:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334230;
	bh=CNAhmi+64W3PtiEX910ErZSoBVQxyUl6y+fQXbf/Tqk=;
	h=Date:To:From:Subject;
	b=OdLsIy63nur0FLCe5TDaAIqkr7GNzbqgLEKW2/KV75lV0NuZz4PYFfp8MGlgf6JXc
	 TmO+vbzv2qd8z8DtyrI6KXwTJF0xyhpk14uWDHtmvV3KQkM3ms6N7HiQYRFkokNkIg
	 YlvZvbnOTvx9b7pIMCGfKM1DyyGEKYraxg0hxIVI=
Date: Tue, 06 Oct 2026 17:50:29 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,ljs@kernel.org,hannes@cmpxchg.org,tz2294@columbia.edu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_io-use-swap-entries-directly-in-zeromap-helpers.patch removed from -mm tree
Message-Id: <20261007005029.E17941F0089C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_io: use swap entries directly in zeromap helpers
has been removed from the -mm tree.  Its filename was
     mm-page_io-use-swap-entries-directly-in-zeromap-helpers.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Tal Zussman <tz2294@columbia.edu>
Subject: mm/page_io: use swap entries directly in zeromap helpers
Date: Sat, 29 Aug 2026 15:09:02 -0400

Increment swp_entry_t::val directly instead of recomputing each entry with
page_swap_entry().  This removes the last struct page usage in page_io.c
and saves one call to compound_head() per page.

Link: https://lore.kernel.org/20260829-b4-page_io-folios-v2-3-649728091117@columbia.edu
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---

 mm/page_io.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/page_io.c~mm-page_io-use-swap-entries-directly-in-zeromap-helpers
+++ a/mm/page_io.c
@@ -160,7 +160,7 @@ static void swap_zeromap_folio_set(struc
 	struct obj_cgroup *objcg = get_obj_cgroup_from_folio(folio);
 	int nr_pages = folio_nr_pages(folio);
 	struct swap_cluster_info *ci;
-	swp_entry_t entry;
+	swp_entry_t entry = folio->swap;
 	unsigned int i;
 
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_swapcache(folio), folio);
@@ -168,8 +168,8 @@ static void swap_zeromap_folio_set(struc
 
 	ci = swap_cluster_get_and_lock(folio);
 	for (i = 0; i < folio_nr_pages(folio); i++) {
-		entry = page_swap_entry(folio_page(folio, i));
 		__swap_table_set_zero(ci, swp_cluster_offset(entry));
+		entry.val++;
 	}
 	swap_cluster_unlock(ci);
 
@@ -183,7 +183,7 @@ static void swap_zeromap_folio_set(struc
 static void swap_zeromap_folio_clear(struct folio *folio)
 {
 	struct swap_cluster_info *ci;
-	swp_entry_t entry;
+	swp_entry_t entry = folio->swap;
 	unsigned int i;
 
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_swapcache(folio), folio);
@@ -191,8 +191,8 @@ static void swap_zeromap_folio_clear(str
 
 	ci = swap_cluster_get_and_lock(folio);
 	for (i = 0; i < folio_nr_pages(folio); i++) {
-		entry = page_swap_entry(folio_page(folio, i));
 		__swap_table_clear_zero(ci, swp_cluster_offset(entry));
+		entry.val++;
 	}
 	swap_cluster_unlock(ci);
 }
_

Patches currently in -mm which might be from tz2294@columbia.edu are

mm-remove-pagewriteback.patch
mm-swap-add-folio_swap_entry-and-folio_page_swap_entry.patch
mm-swap-add-folio_swap_entry-and-folio_page_swap_entry-fix.patch
mm-huge_memory-add-a-comment-to-the-open-coded-swap-entry.patch
mm-rmap-use-folio_page_swap_entry-in-ttu_anon_swapbacked_folio.patch
mm-zswap-use-folio_swap_entry-in-zswap_store_page.patch
mm-swapfile-use-folio_page_swap_entry.patch
arm64-mte-make-mte_save_tags-and-mte_restore_tags-static.patch
arm64-mte-pass-the-swap-entry-to-mte_save_tags.patch
mm-swap-remove-page_swap_entry.patch
mm-memcontrol-take-a-const-folio-in-folio_memcg-and-friends.patch
mm-memcontrol-constify-obj_cgroup_memcg-and-friends.patch
mm-memcontrol-constify-the-lruvec-helpers.patch
mm-page_io-take-a-const-folio-in-bio_associate_blkg_from_folio.patch
mm-memcontrol-constify-the-mem_cgroup-accessors.patch
mm-page_counter-constify-page_counter_read-and-page_counter_margin.patch
mm-memcontrol-constify-the-reclaim-protection-helpers.patch
mm-memcontrol-constify-the-memcg-and-lruvec-stat-readers.patch
mm-memcontrol-constify-the-swap-accounting-helpers.patch
mm-memcontrol-constify-mem_cgroup_swappiness-and-mem_cgroup_get_max.patch
mm-memcontrol-constify-the-zswap-and-socket-pressure-helpers.patch
vmcore-convert-mmap_vmcore_fault-to-use-folios.patch

