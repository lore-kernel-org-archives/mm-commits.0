Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D95C3C10BE;
	Wed,  5 Aug 2026 02:26:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785896802; cv=none; b=Tk5dP1m8o7ahANzGrpDFTfynQh4awlFNGPf5UKVy7SAj4XE/eVdTeYOtcHUVzAiaxL0UHCt9KLJzq2+avsUwurHQPRsN786EEbU2hZsbZhCEeiDhSPkdAqYA6vQhTLGrUXMZCspt2bwxsHBaVaxla1cqBS1QzDoiGiXBogUVG+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785896802; c=relaxed/simple;
	bh=TuYJTWU8bxNDplJ/7J3FcSi3vzU+b/rsFhCyQ5DTXXg=;
	h=Date:To:From:Subject:Message-Id; b=LqPIZiMqf9Yg9GdZ/w5DFQFRH4RY0lrQR6Jc6FgGE4PKQOjbHkATkdAOYugm5mWjxhwR0j+8rTql1u+EB+gp0r60GXm1y+g91QpGT3kaohNFOdZgky9Z1wFyrtj3uLFCA8z1d4aXpA8HzBbBUFvP/R+61VDeez2AhY12y8dTCRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SDchLVqb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SDchLVqb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2428A1F00A3A;
	Wed,  5 Aug 2026 02:26:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785896801;
	bh=N/eTzHWkpgdxudyTf/J4zs8xjYEQADnZNgYH0gOEB1I=;
	h=Date:To:From:Subject;
	b=SDchLVqbCjU3sRo8lzHqz/4NxJIySNLrqm5ScPQZZyxujBUrqyUMjZWfIluFE79Gw
	 dIEgyl87jJsTV3P72RdrWtekEkuNqPcl/8D/xfAt8yekl5qaeJeF1DbODGwWEvF0Je
	 eYEr321mW9uG8RNrB/vJoPFy9BjDcpG0IVj5WmVg=
Date: Tue, 04 Aug 2026 19:26:40 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,vbabka@kernel.org,stable@vger.kernel.org,shakeel.butt@linux.dev,sashiko-bot@kernel.org,ryan.roberts@arm.com,rakie.kim@sk.com,npache@redhat.com,matthew.brost@intel.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,joshua.hahnjy@gmail.com,jannh@google.com,hannes@cmpxchg.org,gourry@gourry.net,dev.jain@arm.com,david@kernel.org,byungchul@sk.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,balbirs@nvidia.com,apopple@nvidia.com,usama.arif@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-madvise-skip-device-private-pmds-in-cold-and-pageout-walks.patch removed from -mm tree
Message-Id: <20260805022641.2428A1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/madvise: skip device-private PMDs in cold and pageout walks
has been removed from the -mm tree.  Its filename was
     mm-madvise-skip-device-private-pmds-in-cold-and-pageout-walks.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Usama Arif <usama.arif@linux.dev>
Subject: mm/madvise: skip device-private PMDs in cold and pageout walks
Date: Fri, 10 Jul 2026 03:55:22 -0700

madvise_cold_or_pageout_pte_range() takes pmd_trans_huge_lock(), whose
pmd_is_huge() check returns true for a device-private PMD.  The subsequent
!pmd_present() branch has a VM_BUG_ON() asserting migration is the only
allowed non-present case; a device-private PMD trips it.

Skip device-private PMDs in that non-present branch and continue to
huge_unlock before calling pmd_folio().  Downgrade the check to
VM_WARN_ON_ONCE() so an unexpected PMD softleaf logs a warning rather than
panicking.  Drop the thp_migration_supported() guard: it expands to
IS_ENABLED(CONFIG_ARCH_SUPPORTS_PMD_SOFTLEAF), and both
pmd_is_migration_entry() and pmd_is_device_private_entry() already return
false when that config is not selected, so the guard suppresses only the
case where the warning would already be silent.

Potential trigger: an HMM-based GPU driver races with
madvise(MADV_COLD)/MADV_PAGEOUT: pmd_trans_huge(*pmd) reads true, then
migrate_vma_pages() flips the PMD to a device-private entry before the PMD
lock is acquired.

Link: https://lore.kernel.org/20260710105557.1987433-3-usama.arif@linux.dev
Fixes: 368076f52ebe ("mm/huge_memory: add device-private THP support to PMD operations")
Signed-off-by: Usama Arif <usama.arif@linux.dev>
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Link: https://sashiko.dev/#/patchset/20260703173903.3789516-1-usama.arif%40linux.dev?part=6
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Balbir Singh <balbirs@nvidia.com>
Reviewed-by: Gregory Price <gourry@gourry.net>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Byungchul Park <byungchul@sk.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Jann Horn <jannh@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/madvise.c~mm-madvise-skip-device-private-pmds-in-cold-and-pageout-walks
+++ a/mm/madvise.c
@@ -388,8 +388,8 @@ static int madvise_cold_or_pageout_pte_r
 			goto huge_unlock;
 
 		if (unlikely(!pmd_present(orig_pmd))) {
-			VM_BUG_ON(thp_migration_supported() &&
-					!pmd_is_migration_entry(orig_pmd));
+			VM_WARN_ON_ONCE(!pmd_is_migration_entry(orig_pmd) &&
+					!pmd_is_device_private_entry(orig_pmd));
 			goto huge_unlock;
 		}
 
_

Patches currently in -mm which might be from usama.arif@linux.dev are

mm-vmstat-mm-memcontrol-add-_monotonic-vmstat-readers.patch
mm-vmscan-add-pgrotate_anon-and-pgrotate_file-vmstat-counters.patch
mm-vmscan-reduce-lru_lock-contention-via-vmstat-derived-scan-balance-cost.patch

