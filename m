Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A49421C16A
	for <mm-commits@vger.kernel.org>; Fri, 26 Jun 2026 00:47:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782434855; cv=none; b=CfW1caF16mCqyu8fTqVkhc29LTTYruzramYvZZBGZFaRSRSQFSkqiFomby5ZHnmQiTrA8RQdr0OGGyLQTuJZucx+GmHHJMcmaZoSkLexeiwkb+3vZ8UfgX+Yfp5PtpknjDXbzdFfYPYtQSK4s7UJ8m57OTQO4r8YW6D5z9h90yw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782434855; c=relaxed/simple;
	bh=dql7nvxFwt3DuW+UEHpdpLxfbCCmmoZTbr/E/8ICuNI=;
	h=Date:To:From:Subject:Message-Id; b=t5z7AuIKisEjLsormAU8ylh3CmI6OfBNz1c+r5F5sTIfBRB/g/tzsbLWR1jt2S6ot1jOdm7A2uH96xQ2PdS7YVqBAuCpk/ROOPu/C9N8MfA9mydJH23SJgM6/4Equyu80qRUetkbEhS9EZXiTEB1wlvc02H+hK8TMPxwQY/dgfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Nbn3yYya; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Nbn3yYya"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3DC01F000E9;
	Fri, 26 Jun 2026 00:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782434853;
	bh=SNIKLyN7TjCJQyXwCwB97eDRg20AUiDn1RXfoFTFR7U=;
	h=Date:To:From:Subject;
	b=Nbn3yYyaH5DXcMXcKEWeXSCqSoAqN8j+iugreHklgnHwNCgy+MRp6IMvT+4bTNKi4
	 X3YjvbWEoLItj4i7pATIDNvZ0gaE+/BnHOZpnJULyO8mnRnBAp06SFs+F6/ed5dk8p
	 P3PPH0tiT2y+R66r8AdRgW1eaqUIVAHrDoUgAnQU=
Date: Thu, 25 Jun 2026 17:47:33 -0700
To: mm-commits@vger.kernel.org,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb_cma-validate-hugetlb-cma-range-by-zone-at-reserve-time.patch added to mm-new branch
Message-Id: <20260626004733.D3DC01F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb_cma: validate hugetlb CMA range by zone at reserve time
has been added to the -mm mm-new branch.  Its filename is
     mm-hugetlb_cma-validate-hugetlb-cma-range-by-zone-at-reserve-time.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb_cma-validate-hugetlb-cma-range-by-zone-at-reserve-time.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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

mm-hugetlb-fix-boot-panic-with-config_debug_vm-and-hvo-bootmem-pages.patch
mm-hugetlb_vmemmap-fix-__hugetlb_vmemmap_optimize_folios.patch
powerpc-mm-fix-wrong-addr_pfn-tracking-in-compound-vmemmap-population.patch
mm-hugetlb-initialize-gigantic-bootmem-hugepage-struct-pages-earlier.patch
mm-mm_init-simplify-deferred_free_pages-migratetype-init.patch
mm-sparse-panic-on-memmap-and-usemap-allocation-failure.patch
mm-sparse-move-subsection_map_init-into-sparse_init.patch
mm-mm_init-defer-sparse_init-until-after-zone-initialization.patch
mm-mm_init-defer-hugetlb-reservation-until-after-zone-initialization.patch
mm-mm_init-remove-set_pageblock_order-call-from-sparse_init.patch
mm-sparse-move-sparse_vmemmap_init_nid_late-into-sparse_init_nid.patch
mm-hugetlb_cma-validate-hugetlb-cma-range-by-zone-at-reserve-time.patch
mm-hugetlb-refactor-early-boot-gigantic-hugepage-allocation.patch
mm-hugetlb-free-cross-zone-bootmem-gigantic-pages-after-allocation.patch
mm-hugetlb_vmemmap-move-bootmem-hvo-setup-to-early-init.patch
mm-hugetlb-remove-obsolete-bootmem-cross-zone-checks.patch
mm-sparse-vmemmap-remove-sparse_vmemmap_init_nid_late.patch
mm-hugetlb-remove-unused-bootmem-cma-field.patch
mm-mm_init-fold-__init_page_from_nid-into-__init_deferred_page.patch

