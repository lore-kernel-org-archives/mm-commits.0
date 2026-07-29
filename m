Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D2273921E9
	for <mm-commits@vger.kernel.org>; Wed, 29 Jul 2026 04:14:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785298469; cv=none; b=riCRPWsZpYj3wD6XO6N692ua8CeXBMn5lq9zI4y2Q/KR+DYtgIaIAnvFeRI9tyWkSzcQ3FiQQMS1lkgYM1hfctSKCyxfnURsBlOAneoKanRm5nEEa/9uRmo7rgLYI86URI3SMeZLBdGoJLDO2fHilL9AdglOqfgRApXtNEHmFpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785298469; c=relaxed/simple;
	bh=qQw1sZmxr8ARCa8xFNnfLo1vXoKdbb3mEuVn2yLOzmU=;
	h=Date:To:From:Subject:Message-Id; b=EzRElvSMrmqGFO8b4zCp3DRZNiGAVEeZacK4Dtx5NqZYwL+ELWpuBg9SKo74rce9Sb4SmIkCt1JsmQ1KIoVOZMQ9atcoxhBUCfZJXGjbTr2rggA05ZKwgTsXHgA/SPeympAwur2/Jz4sZDKbZsduhaeOmpL++Lz5YOU8Tc73rwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ca1scatT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ca1scatT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4A541F00A3A;
	Wed, 29 Jul 2026 04:14:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785298467;
	bh=Qnp7hs/nTMQ1ddYi3rhj/K/x8pdSqdBlVO0UNAkJ4nI=;
	h=Date:To:From:Subject;
	b=Ca1scatTXNgouOTcHvEJuLtahw4A1QgSqNFtJfTOK+ienGhn/NoLVSBCNSUClLFgb
	 EZi24IAOe/DG5/ep4o1MAsb2n4P3F4SLZi5n7XgqkPNTUC6yKjIhYGn3HujzqxJdiX
	 Ua+PnMEOvdo5NmWK5zTZ9pqgeKRg4JQ5wxQlqtkQ=
Date: Tue, 28 Jul 2026 21:14:27 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,usama.arif@linux.dev,rppt@kernel.org,ritesh.list@gmail.com,osalvador@suse.de,osalvador@kernel.org,npiggin@gmail.com,mpe@ellerman.id.au,maddy@linux.ibm.com,ljs@kernel.org,liam@infradead.org,fvdl@google.com,david@kernel.org,aneesh.kumar@linux.ibm.com,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb_cma-validate-hugetlb-cma-range-by-zone-at-reserve-time.patch removed from -mm tree
Message-Id: <20260729041427.C4A541F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb_cma: validate hugetlb CMA range by zone at reserve time
has been removed from the -mm tree.  Its filename was
     mm-hugetlb_cma-validate-hugetlb-cma-range-by-zone-at-reserve-time.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm/hugetlb_cma: validate hugetlb CMA range by zone at reserve time
Date: Fri, 12 Jun 2026 11:58:56 +0800

Hugetlb CMA allocation currently has to cope with CMA areas that span
multiple zones.

Validate the reserved CMA range up front in hugetlb_cma_reserve() so later
hugetlb CMA allocations can assume a zone-consistent area.

Also drop the pfn_valid() check from cma_validate_zones().  mem_section is
not fully initialized at this point, so the check can trigger false
warnings.  Keep the sanity check in cma_activate_area() instead.

Link: https://lore.kernel.org/20260612035903.2468601-13-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Oscar Salvador (SUSE) <osalvador@suse.de>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Frank van der Linden <fvdl@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oscar Salvador (SUSE) <osalvador@kernel.org>
Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma.c         |    3 ++-
 mm/hugetlb_cma.c |    6 ++++--
 2 files changed, 6 insertions(+), 3 deletions(-)

--- a/mm/cma.c~mm-hugetlb_cma-validate-hugetlb-cma-range-by-zone-at-reserve-time
+++ a/mm/cma.c
@@ -126,7 +126,6 @@ bool cma_validate_zones(struct cma *cma)
 		 * to be in the same zone. Simplify by forcing the entire
 		 * CMA resv range to be in the same zone.
 		 */
-		WARN_ON_ONCE(!pfn_valid(base_pfn));
 		if (pfn_range_intersects_zones(cma->nid, base_pfn, cmr->count)) {
 			set_bit(CMA_ZONES_INVALID, &cma->flags);
 			return false;
@@ -165,6 +164,8 @@ static void __init cma_activate_area(str
 			bitmap_set(cmr->bitmap, 0, bitmap_count);
 		}
 
+		WARN_ON_ONCE(!pfn_valid(cmr->base_pfn));
+
 		for (pfn = early_pfn[r]; pfn < cmr->base_pfn + cmr->count;
 		     pfn += pageblock_nr_pages)
 			init_cma_reserved_pageblock(pfn_to_page(pfn));
--- a/mm/hugetlb_cma.c~mm-hugetlb_cma-validate-hugetlb-cma-range-by-zone-at-reserve-time
+++ a/mm/hugetlb_cma.c
@@ -231,9 +231,11 @@ void __init hugetlb_cma_reserve(void)
 		res = cma_declare_contiguous_multi(size, gigantic_page_size,
 					HUGETLB_PAGE_ORDER, name,
 					&hugetlb_cma[nid], nid);
-		if (res) {
-			pr_warn("hugetlb_cma: reservation failed: err %d, node %d",
+		if (res || !cma_validate_zones(hugetlb_cma[nid])) {
+			pr_warn("hugetlb_cma: %s: err %d, node %d\n",
+				res ? "reservation failed" : "reserved area spans zones",
 				res, nid);
+			hugetlb_cma[nid] = NULL;
 			continue;
 		}
 
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

selftests-mm-remove-obsolete-hugetlb-vmemmap-test.patch

