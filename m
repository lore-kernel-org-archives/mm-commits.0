Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EACA92DEA7B;
	Wed,  7 Oct 2026 00:50:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334253; cv=none; b=q8Y2FlluL9l1BQ3g1RWfZZwX3I1O/057wgbILtEkby5CzyDo4N3LolZObCMswTM1IYuzR44s003yOZp6lM0hqbaGkTZfo70LC/BHgrWDyEQIHhratLfAfOuFRm1/I2Yv6lfzUKVTTi4XqcCWWKB70u+YqqO0vTn4dFSbQVu7Ans=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334253; c=relaxed/simple;
	bh=fCRU6JP/I25ZWafqbv3lw9P88cVHVEKhoU1PsRUwS0I=;
	h=Date:To:From:Subject:Message-Id; b=DiIMe8WA8K3VZvG1fC1djlhMac7EBC2fcM27Svs/8v/MCoEOFHNZ6Dy3V3sUQyS5N/I1HhjO2qI2BEQheGVzM/mxqfSoVl6Rl1N2iN2iwJ3VZzB+dQyP+sMQGgcdaJ7kOTdQ2fuBvgZ3QhqmtpiHWifcGSk9P5m5MqkhvLyeBWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xcqT7hi5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xcqT7hi5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5B791F0089C;
	Wed,  7 Oct 2026 00:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334251;
	bh=mGMMN/PsER/9xIWmXKsNdjhK94fak7WLw3mGjhe/m8k=;
	h=Date:To:From:Subject;
	b=xcqT7hi5nlVDwUmAbbUMWP83euqM9aFOTedIvBBPnV7Fq6LRiKAln8KvDAz+gjGKf
	 a5DTs81yNSz9xpnrxDyMiev/uMJyJ9Sa8FBVi6w3jvJYftyLVjlnTi/p4PuaEojQCn
	 mKNMOLtXyShrXFSowkSBO0HYgwIpmjpCa6MrcLtc=
Date: Tue, 06 Oct 2026 17:50:51 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,vbabka@kernel.org,stable@vger.kernel.org,ryan.roberts@arm.com,rakie.kim@sk.com,matthew.brost@intel.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,joshua.hahnjy@gmail.com,jannh@google.com,dev.jain@arm.com,david@kernel.org,byungchul@sk.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,balbirs@nvidia.com,apopple@nvidia.com,gourry@gourry.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mempolicy-skip-zone-device-folios-when-queueing-folios.patch removed from -mm tree
Message-Id: <20261007005051.C5B791F0089C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mempolicy: skip zone device folios when queueing folios
has been removed from the -mm tree.  Its filename was
     mm-mempolicy-skip-zone-device-folios-when-queueing-folios.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Gregory Price <gourry@gourry.net>
Subject: mm/mempolicy: skip zone device folios when queueing folios
Date: Mon, 17 Aug 2026 18:08:10 -0400

queue_folios_pte_range() already pairs vm_normal_folio() with an explicit
folio_is_zone_device() check before adding folios to the migration
pagelist.

vm_normal_folio() alone does not reject zone device memory (a present
device-coherent page in a normal VMA is returned as "normal").

Mirror the explicit check in queue_folios_pmd() as well.

queue_folios_pmd() uses pmd_folio() directly and can encounter a present
zone device PMD - e.g. a device-coherent THP.

This is not filtered by existing checks:
  !pmd_present()   - only rejects non-present device-private and
                     migration entries

  vma_migratable() - excludes DAX and VM_PFNMAP.

The early return also means such a folio is no longer counted in
qp->nr_failed under MPOL_MF_STRICT.  This is the same pattern used by
queue_folios_pte_range() (skipping zone device without failing).

Link: https://lore.kernel.org/20260817220810.1175596-4-gourry@gourry.net
Fixes: a30b48bf1b24 ("mm/migrate_device: implement THP migration of zone device pages")
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Balbir Singh <balbirs@nvidia.com>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
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

 mm/mempolicy.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/mempolicy.c~mm-mempolicy-skip-zone-device-folios-when-queueing-folios
+++ a/mm/mempolicy.c
@@ -679,6 +679,8 @@ static void queue_folios_pmd(pmd_t *pmd,
 		return;
 	}
 	folio = pmd_folio(pmdval);
+	if (folio_is_zone_device(folio))
+		return;
 	if (is_huge_zero_folio(folio)) {
 		walk->action = ACTION_CONTINUE;
 		return;
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

