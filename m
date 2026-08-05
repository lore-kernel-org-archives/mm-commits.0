Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C21131D5CFE
	for <mm-commits@vger.kernel.org>; Wed,  5 Aug 2026 01:10:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785892256; cv=none; b=Z3LhKOqgy1HRAogoyjvtlHKtaS3wtoZlbRavTVPeHx1rBKBdH77+0/R9DLR9TjHo6/t5VMa6AVBBRef6XctYpwBasubYY6/4qh67Ie4Ze1e8ofsDdQmM0dYCSVTtiUVIbr0QyL4JWfk/SJUWcAlosUzAziEi7HtnPWoJFqLzkRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785892256; c=relaxed/simple;
	bh=vvenxa8fvtoFDWfzI3NFEOu4AMOo6qFyvOlIzgEKcGo=;
	h=Date:To:From:Subject:Message-Id; b=KBD5ZLMvWwgYnr48aE0bShjFsSfqDk36eSVYqqCRNAietcPKFXELP308ls3sbpsOl+zTqxVrBVpzpAq/gxSelVcz7VFZzbsUe2CGRlYTjgh9jdKBzLK1AmnQlA0F4iw3ms36hYf+N2aeGubTSWx6DYtQhalvIqjsrMSnEWHw8Wc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HWmo51t9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HWmo51t9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 283E01F000E9;
	Wed,  5 Aug 2026 01:10:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785892254;
	bh=U/Mhfxxm4u3eucOfgHH3g54WVM6qvUualbRfxeRzmAE=;
	h=Date:To:From:Subject;
	b=HWmo51t9GZOnclu+9e7FlIIDL0SQgn+7QCGjx2o06VprQ435xSG/zH3v8seV+WCmv
	 wy+9sNYQB9HlJ46clT04Fg9ixQ5JbbaUNWMpZ1r/mII3q/FnGVO3CTXNdHWcaoF68v
	 4jTS+k+DYAuoRrm65RyJfBxxoiwhuc919ridDNcM=
Date: Tue, 04 Aug 2026 18:10:53 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,usama.arif@linux.dev,surenb@google.com,shikemeng@huaweicloud.com,shakeel.butt@linux.dev,rppt@kernel.org,nphamcs@gmail.com,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,kasong@tencent.com,david@kernel.org,chrisl@kernel.org,baoquan.he@linux.dev,baohua@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-avoid-unnecessary-lru-drain-for-wp_can_reuse_anon_folio-fix.patch removed from -mm tree
Message-Id: <20260805011054.283E01F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: rename in_lru_cache to maybe_in_lru_cache
has been removed from the -mm tree.  Its filename was
     mm-avoid-unnecessary-lru-drain-for-wp_can_reuse_anon_folio-fix.patch

This patch was dropped because it was folded into mm-avoid-unnecessary-lru-drain-for-wp_can_reuse_anon_folio.patch

------------------------------------------------------
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
Subject: mm: rename in_lru_cache to maybe_in_lru_cache
Date: Wed, 8 Jul 2026 22:46:43 +0800

!folio_test_lru(folio) doesn't necessarily mean folio is in lru cache.  so
let's put "maybe" prefix.

Link: https://lore.kernel.org/20260708145718.82690-1-baohua@kernel.org
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/memory.c~mm-avoid-unnecessary-lru-drain-for-wp_can_reuse_anon_folio-fix
+++ a/mm/memory.c
@@ -4174,7 +4174,7 @@ static bool __wp_can_reuse_large_anon_fo
 static bool wp_can_reuse_anon_folio(struct folio *folio,
 				    struct vm_area_struct *vma)
 {
-	const bool in_lru_cache = !folio_test_lru(folio);
+	const bool maybe_in_lru_cache = !folio_test_lru(folio);
 	const bool in_swapcache = folio_test_swapcache(folio);
 
 	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) && folio_test_large(folio))
@@ -4188,9 +4188,9 @@ static bool wp_can_reuse_anon_folio(stru
 	 * KSM doesn't necessarily raise the folio refcount.
 	 */
 	if (folio_test_ksm(folio) ||
-	    folio_ref_count(folio) > 1 + in_lru_cache + in_swapcache)
+	    folio_ref_count(folio) > 1 + maybe_in_lru_cache + in_swapcache)
 		return false;
-	if (in_lru_cache)
+	if (maybe_in_lru_cache)
 		/*
 		 * We cannot easily detect+handle references from
 		 * remote LRU caches or references to LRU folios.
_

Patches currently in -mm which might be from baohua@kernel.org are

mm-avoid-unnecessary-lru-drain-for-wp_can_reuse_anon_folio.patch
mm-drop-stale-folio_ref_count==1-check-in-do_swap_page-reuse-logic.patch
mm-entirely-remove-lru_add_drain-in-do_swap_page.patch
mm-clarify-the-folio_free_swap-for-do_swap_page.patch
arm64-hugetlb-extend-batching-of-multiple-cont_pte-in-a-single-pte-setup.patch
arm64-vmalloc-allow-arch_vmap_pte_range_map_size-to-batch-multiple-cont_pte.patch
mm-vmalloc-extend-page-table-walk-to-support-larger-page_shift-sizes-and-eliminate-page-table-rewalk.patch
mm-vmalloc-map-contiguous-pages-in-batches-for-vmap-if-possible.patch
mm-vmalloc-align-vm_area-so-vmap-can-batch-mappings.patch

