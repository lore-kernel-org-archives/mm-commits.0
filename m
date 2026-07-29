Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22E29364941
	for <mm-commits@vger.kernel.org>; Wed, 29 Jul 2026 03:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785297355; cv=none; b=Ocln+ds4hK/ATFVItmOWzmJ6CuBALwg/ro/7wX9ZXEsi91+tyT8jnQOztbykm8iGdFm8LdTEX/qxNJwcpa67oeHZ0YyFsZqQIgMusWNlMV0vfuCdJNTs2zTh4pzlvCy21DyKCPpDWNqltiHkxgwvJ2/icFpYrxx3awz95yv29/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785297355; c=relaxed/simple;
	bh=mmqHPVyVvMKsN7LHrPzqkNKt+tKQlCIHlrIzb0YhHYM=;
	h=Date:To:From:Subject:Message-Id; b=jdWZByNd/OPYyxT5/3iacTOj+jwk9i8/raXruyuRC2zraeKxjsri9rGNu97t+S4D8zeGMrDg30k5r9+FWqltsqUUtzEq/8u23ePTYBw2dYaWzXbvN8s/+SqoNBuxtDXnU8+fu6TX8UNpm4NXr29HWFiYXMUuVKZf0Ze/FRpjVB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KzG9Sgzu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KzG9Sgzu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A50E41F000E9;
	Wed, 29 Jul 2026 03:55:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785297353;
	bh=o1HRtoQchkLIrdv1izPWuFHp+U+OzIW89I1uDko0QMg=;
	h=Date:To:From:Subject;
	b=KzG9SgzuSRq6+iRXrLrzZcq9fVB9bBFLrPXungzC+3uoaudJaLbw5UCCTMOda9s04
	 uJCvZ+SBOw4R9ZihErpIHz9OSEZ5I6CvaC3ySsbA/Hl9E64FzibuGVrw2XZOXCr+6d
	 1aXyD5HzeCQM7Nk6/1IvWcbfqgfR2wD7oG5Pkrfo=
Date: Tue, 28 Jul 2026 20:55:53 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,tj@kernel.org,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,roman.gushchin@linux.dev,mkoutny@suse.com,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,hannes@cmpxchg.org,david@kernel.org,usama.arif@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-vmpressure-skip-tree=true-accounting-on-cgroup-v2-fix.patch removed from -mm tree
Message-Id: <20260729035553.A50E41F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-vmpressure-skip-tree=true-accounting-on-cgroup-v2-fix
has been removed from the -mm tree.  Its filename was
     mm-vmpressure-skip-tree=true-accounting-on-cgroup-v2-fix.patch

This patch was dropped because it was folded into mm-vmpressure-skip-tree=true-accounting-on-cgroup-v2.patch

------------------------------------------------------
From: Usama Arif <usama.arif@linux.dev>
Subject: mm-vmpressure-skip-tree=true-accounting-on-cgroup-v2-fix
Date: Tue, 30 Jun 2026 09:25:05 -0700

Simplify the guard. Both cgroup_subsys_on_dfl() and tree are bool, so
the two combinations that have no consumer (v1 + tree=false, v2 +
tree=true) are exactly the cases where dfl == tree.

Link: https://lore.kernel.org/e8e1a409-48d8-4fa7-ae98-49485a1607f6@linux.dev
Signed-off-by: Usama Arif <usama.arif@linux.dev>
Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmpressure.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/vmpressure.c~mm-vmpressure-skip-tree=true-accounting-on-cgroup-v2-fix
+++ a/mm/vmpressure.c
@@ -251,8 +251,7 @@ void vmpressure(gfp_t gfp, int order, st
 	 *   cgroup v1 + tree=true  -> userspace eventfds (memory.pressure_level)
 	 * Skip the other two: nothing consumes the result.
 	 */
-	if ((!cgroup_subsys_on_dfl(memory_cgrp_subsys) && !tree) ||
-	    (cgroup_subsys_on_dfl(memory_cgrp_subsys) && tree))
+	if (cgroup_subsys_on_dfl(memory_cgrp_subsys) == tree)
 		return;
 
 	vmpr = memcg_to_vmpressure(memcg);
_

Patches currently in -mm which might be from usama.arif@linux.dev are

mm-swap_state-remove-unnecessary-lru_add_drain-from-readahead.patch
mm-add-softleaf_to_pmd-and-convert-existing-callers.patch
mm-extract-mm_prepare_for_swap_entries-helper.patch
fs-proc-use-softleaf_has_pfn-in-pagemap-pmd-walker.patch
mm-huge_memory-move-softleaf_to_folio-inside-migration-branch.patch
mm-migrate_device-move-softleaf_to_folio-inside-device-private-branch.patch
mm-rename-arch_enable_thp_migration-to-arch_has_pmd_softleaves.patch
mm-vmpressure-skip-tree=true-accounting-on-cgroup-v2.patch
mm-vmpressure-move-v1-userspace-eventfd-code-into-memcontrol-v1c.patch
mm-migrate_device-pin-large-folios-before-splitting.patch
mm-migrate_device-pin-large-folios-before-splitting-fix.patch
mm-mempolicy-skip-non-present-pmds-when-queueing-folios.patch
mm-madvise-skip-device-private-pmds-in-cold-and-pageout-walks.patch
mm-huge_memory-skip-device-private-pmds-in-madvise_free_huge_pmd.patch
mm-vmstat-mm-memcontrol-add-_monotonic-vmstat-readers.patch
mm-vmscan-reduce-lru_lock-contention-via-vmstat-derived-scan-balance-cost.patch

