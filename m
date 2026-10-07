Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE22F2FD1CA;
	Wed,  7 Oct 2026 00:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334252; cv=none; b=B2kgSpAoKIr473YxXiTmIVkBCa+zEPzGI4Bi7fkdQEV+++/QuSwgL67hkYqLLMD+aueoJPe0pT07gI+N6ajj2HrLrtgJxDSqSfvWav22MSIG2rKWyxhMIVKM/zaAed0jwb+1yWJUokK3JH+KeTbd4SF6U5S4v97iyDwr5Jzuvvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334252; c=relaxed/simple;
	bh=nbQj0vSGgYUAJLYB1K+uSwMg+Kukbral5WUjgDZz+vc=;
	h=Date:To:From:Subject:Message-Id; b=fE1mpHK1U0ByTRU7+jU6gL1PDTh5aphimKodld0/0e2tC9xTxpW8GsevqoTsQVJFOBAeXMzqo0NpMHzyOojQTfW/h10BVo/XMMjUB/UCNLurr9ifYyaLxRApNLFH+rpHfl3IySZb5EJeICDq8lwl6+tHsSWlqvqujt1El+5YKjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UD/lH1RZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UD/lH1RZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B84551F0089B;
	Wed,  7 Oct 2026 00:50:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334250;
	bh=r5F+av7MbvOlGh5vZBsF6l8r9m5xnFKc/aTq6VcCPGY=;
	h=Date:To:From:Subject;
	b=UD/lH1RZuFgyGPGtwZ+q5M0u/ePeXvTLmcTUENMguj+48oEsWtcFXehcCG2p0jza5
	 L4SfTzxhjDgZazn2V/J79L0LedmfRb9lDc19akl4Gzm0Af18p/RnT14wsh66M1BemI
	 cCR5fkIprwaQzgBtMuGI4sTj/AErD6O1x52Z315w=
Date: Tue, 06 Oct 2026 17:50:50 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,vbabka@kernel.org,stable@vger.kernel.org,ryan.roberts@arm.com,rakie.kim@sk.com,matthew.brost@intel.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,joshua.hahnjy@gmail.com,jannh@google.com,dev.jain@arm.com,david@kernel.org,byungchul@sk.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,balbirs@nvidia.com,apopple@nvidia.com,gourry@gourry.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-madvise-skip-zone-device-folios-in-cold-pageout-pmd-range.patch removed from -mm tree
Message-Id: <20261007005050.B84551F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/madvise: skip zone device folios in cold/pageout PMD range
has been removed from the -mm tree.  Its filename was
     mm-madvise-skip-zone-device-folios-in-cold-pageout-pmd-range.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Gregory Price <gourry@gourry.net>
Subject: mm/madvise: skip zone device folios in cold/pageout PMD range
Date: Mon, 17 Aug 2026 18:08:09 -0400

madvise_cold_or_pageout_pte_range() resolves the folio backing a PMD via
pmd_folio() and ages or reclaims it without checking for zone device
memory.

The surrounding guards do not cover every zone device case:

  - can_madv_lru_vma() excludes VM_PFNMAP and VM_HUGETLB VMAs
    (so device DAX is filtered)

  - !pmd_present() branch above rejects device-private and
    migration entries, which are non-present.

  - A present zone device PMD - e.g. a device-coherent THP - is
    not filtered by any of these, nor by pmd_folio() (unlike
    vm_normal_page_pmd(), it performs no special/pfnmap check),
    and would be aged or paged out here.

Skip ZONE_DEVICE folios explicitly during MADV_COLD/PAGEOUT.

Link: https://lore.kernel.org/20260817220810.1175596-3-gourry@gourry.net
Fixes: a30b48bf1b24 ("mm/migrate_device: implement THP migration of zone device pages")
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Balbir Singh <balbirs@nvidia.com>
Tested-by: Lance Yang <lance.yang@linux.dev>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Jann Horn <jannh@google.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>
---

 mm/madvise.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/madvise.c~mm-madvise-skip-zone-device-folios-in-cold-pageout-pmd-range
+++ a/mm/madvise.c
@@ -404,6 +404,9 @@ static int madvise_cold_or_pageout_pte_r
 
 		folio = pmd_folio(orig_pmd);
 
+		if (folio_is_zone_device(folio))
+			goto huge_unlock;
+
 		/* Do not interfere with other mappings of this folio */
 		if (folio_maybe_mapped_shared(folio))
 			goto huge_unlock;
_

Patches currently in -mm which might be from gourry@gourry.net are

mm-memory_hotplug-factor-out-node_is_memoryless.patch
mm-mempolicy-use-vm_normal_folio_pmd-in-queue_folios_pmd.patch
mm-madvise-use-vm_normal_folio_pmd-in-cold-pageout-pmd-range.patch
mm-refactor-find_next_best_node-to-find_next_best_node_in.patch
mm-page_alloc-refactor-build_node_zonelist-out-of-build_zonelists.patch
proc-task_mmu-handle-special-pmds-in-clear_refs-and-pagemap.patch
mm-madvise-reclaim-isolated-folios-if-pte-restart-fails.patch
mm-madvise-use-folio_trylock-in-the-cold-pageout-pmd-split.patch

