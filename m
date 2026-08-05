Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF07D3C13FB;
	Wed,  5 Aug 2026 02:26:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785896804; cv=none; b=uTJITeYKAKTn83ZW6xb0cXt9b2RNmFL1IMwW7Z1GbU2LuNmmY0x56eUuRbiqy3McqTC5+QOBEl5q84oyDGgws9dFRLXo2bQ1vixJtTMLF8sxxCNVdCKq0+c8wYOA5mDgshev8Ihazc9vYlveVB0eY4ivzL3Xc0bpdvRmI4NrQ9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785896804; c=relaxed/simple;
	bh=w8bZh6zehs0SE43hUE5oZ2ixq4UoeM9h4jIqfGRV4nM=;
	h=Date:To:From:Subject:Message-Id; b=BUN/pC0v0RB6tqO+izae4WmgjDhIb58Vnqx4bMfgJaYHA2AXL7zbrHGsR5Dem014nl7+Jfnjb3+HRgt3U1F9n4hVn2xG1xe3y8n6BeyzyForEwduv5uSfFRU7GxoD+dEOXvQ1zl3geziWKCfauBwuENGNNqFulWdKM8CbbByXyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OyQm98fY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OyQm98fY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B33DB1F000E9;
	Wed,  5 Aug 2026 02:26:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785896802;
	bh=UXXC++WGex/1sJbBPTL4/pUfd+OogxY4d4RMs1tMmFA=;
	h=Date:To:From:Subject;
	b=OyQm98fYnfI/QRn8FUx3+pr57Gq6caerEAb9adgzdAjY1VTG/IEJWUP/vdJvoq5iF
	 YQfTYyZozKWa5ls3m0eiEGdKd9JYyoK/IiGtrbe8UNxzia7gEzwmA9SnxhbTL9tnJm
	 pKsDRw7/DAkB5BemebHVVMIt0/pD1KUtd0sIoNgY=
Date: Tue, 04 Aug 2026 19:26:42 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,vbabka@kernel.org,stable@vger.kernel.org,shakeel.butt@linux.dev,sashiko-bot@kernel.org,ryan.roberts@arm.com,rakie.kim@sk.com,npache@redhat.com,matthew.brost@intel.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,joshua.hahnjy@gmail.com,jannh@google.com,hannes@cmpxchg.org,gourry@gourry.net,dev.jain@arm.com,david@kernel.org,byungchul@sk.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,balbirs@nvidia.com,apopple@nvidia.com,usama.arif@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-huge_memory-skip-device-private-pmds-in-madvise_free_huge_pmd.patch removed from -mm tree
Message-Id: <20260805022642.B33DB1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/huge_memory: skip device-private PMDs in madvise_free_huge_pmd
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-skip-device-private-pmds-in-madvise_free_huge_pmd.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Usama Arif <usama.arif@linux.dev>
Subject: mm/huge_memory: skip device-private PMDs in madvise_free_huge_pmd
Date: Fri, 10 Jul 2026 03:55:23 -0700

madvise_free_pte_range() checks pmd_trans_huge(*pmd) unlocked, then
madvise_free_huge_pmd() takes pmd_trans_huge_lock().  pmd_is_huge()
returns true for a device-private PMD, so orig_pmd can be device-private
and enter the !pmd_present() branch.

Skip device-private PMDs in that non-present branch and continue to out
before calling pmd_folio().  Downgrade the check to VM_WARN_ON_ONCE() so
an unexpected PMD softleaf logs a warning rather than panicking.  Drop the
thp_migration_supported() guard: it expands to
IS_ENABLED(CONFIG_ARCH_SUPPORTS_PMD_SOFTLEAF), and both
pmd_is_migration_entry() and pmd_is_device_private_entry() already return
false when that config is not selected, so the guard suppresses only the
case where the warning would already be silent.

Potential trigger: an HMM-based GPU driver races with madvise(MADV_FREE):
migrate_vma_pages() flips the PMD to a device-private entry between the
caller's pmd_trans_huge() check and the callee's pmd_trans_huge_lock().

Link: https://lore.kernel.org/20260710105557.1987433-4-usama.arif@linux.dev
Fixes: 368076f52ebe ("mm/huge_memory: add device-private THP support to PMD operations")
Signed-off-by: Usama Arif <usama.arif@linux.dev>
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Balbir Singh <balbirs@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Gregory Price <gourry@gourry.net>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Byungchul Park <byungchul@sk.com>
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
Cc: sashiko-bot <sashiko-bot@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-skip-device-private-pmds-in-madvise_free_huge_pmd
+++ a/mm/huge_memory.c
@@ -2331,8 +2331,8 @@ bool madvise_free_huge_pmd(struct mmu_ga
 		goto out;
 
 	if (unlikely(!pmd_present(orig_pmd))) {
-		VM_BUG_ON(thp_migration_supported() &&
-				  !pmd_is_migration_entry(orig_pmd));
+		VM_WARN_ON_ONCE(!pmd_is_migration_entry(orig_pmd) &&
+				!pmd_is_device_private_entry(orig_pmd));
 		goto out;
 	}
 
_

Patches currently in -mm which might be from usama.arif@linux.dev are

mm-vmstat-mm-memcontrol-add-_monotonic-vmstat-readers.patch
mm-vmscan-add-pgrotate_anon-and-pgrotate_file-vmstat-counters.patch
mm-vmscan-reduce-lru_lock-contention-via-vmstat-derived-scan-balance-cost.patch

