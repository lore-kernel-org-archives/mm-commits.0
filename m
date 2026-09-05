Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AE415478D;
	Sat,  5 Sep 2026 18:48:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788634090; cv=none; b=b/uZx/odGsRu+3M0bZ1l3yIzsr7klsbLnfwtQTN5RY8FTgIZ09z8pdRfUBeV1imNhVztnt4nZ1YH7CwtlcJxBBy0wuLGoyFMxO2xGCNWBT3r5iS0qw4ByCm9fI5uancQN/juqcG2QQ/4JQEzmu2rzB8G48nCRrs3Jht0CzUUnyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788634090; c=relaxed/simple;
	bh=udFvITsnvIhSY/MPk2MhZDn535w+91kb/b9JCEEtU78=;
	h=Date:To:From:Subject:Message-Id; b=IPSZVso4ekYWqAJVEkXxvTvjAWihhUdQOQeqbt93/0LztsGxzfLgC/yGsoTeKa0hIdjp0w5drOUMx3OI4sNHS9NfTsy/N/NQtnEG61cKidvHC463VmXsFrNuka1csMeGsc66VEgo6PMbwjsSMFHTFnVohldI/U/+rWbP+tRrf0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ju1+/rr+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ju1+/rr+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B94B81F00A3A;
	Sat,  5 Sep 2026 18:48:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788634088;
	bh=ycEAbdjQ92e8uYTru9iK552ET8xDhXY5zPrQqkum/3c=;
	h=Date:To:From:Subject;
	b=Ju1+/rr+Fori2x8rVpQmS8hOsDJfwEenP9CbgIZ9iisk0gdir8GL0DOQ2Co1V8RHG
	 c2RxzQ0d+b9XTtOZlq7bNwHH2L5hSMHPAJNhQhmlaEZcwuE9X0odnjVv7kqoCU72L6
	 C4EqAmT8MEOOu6YLNQwTeRr8ANZeJ/AYseV56J/A=
Date: Sat, 05 Sep 2026 11:48:08 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,stable@vger.kernel.org,sj@kernel.org,saravanand@crusoe.ai,ryan.roberts@arm.com,peterx@redhat.com,liam@infradead.org,lance.yang@linux.dev,jgg@ziepe.ca,dev.jain@arm.com,david@kernel.org,clg@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-huge_memory-bypass-thp-tuneables-for-huge-pfnmap-mappings.patch removed from -mm tree
Message-Id: <20260905184808.B94B81F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/huge_memory: bypass THP tuneables for huge pfnmap mappings
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-bypass-thp-tuneables-for-huge-pfnmap-mappings.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: mm/huge_memory: bypass THP tuneables for huge pfnmap mappings
Date: Thu, 27 Aug 2026 20:55:57 +0100

The sysfs THP tuneables at /sys/kernel/mm/transparent_huge_pages/ rather
confusingly only control the behaviour of THP in some instances.

They are not applicable to MADV_COLLAPSE operations, nor to DAX mappings.

Long-term, THP is predicated upon compaction being able to obtain large
folios to populate THP ranges.

However, vm_normal_folio() returns NULL for PFN map mappings, thus their
reference count is maintained by the driver, not core mm.

As a consequence, the folios are not subject to reclaim nor compaction, so
are not truly part of the THP mechanism at all.

However, since commit 5dd40721f147 ("mm: allow THP orders for PFNMAPs")
introduced the ability to establish huge PFN maps, they have been subject
to THP tuneables.

This is incorrect - if a huge PFN map is available (defined by
vma->vm_ops->huge_fault being non-NULL for a VMA_PFNMAP_BIT VMA), then it
should be mapped huge upon fault-in.

Correct this by explicitly checking for this while ensuring that smaps
continues to accurately report THPeligible statistics.

While here, abstract the entire file-backed THP check in
vma_can_map_huge_file(), with sensible separation of logic into helper
functions.

Note that drm_gem_shmem_mmap() and panthor_gem_mmap() establish huge PFN
maps of shmem folios, however they are marked unevictable in
drm_gem_get_pages(), and in any case would fail the reference check in
__remove_mapping() even if they weren't.

Failing to map huge PFN maps has resulted in significant real-world
performance degradation, see links for details.

[ziy@nvidia.com: rename some functions]
  Link: https://lore.kernel.org/DL1HIHWYJ7TB.1CY76SJS0V03L@nvidia.com
Link: https://lore.kernel.org/20260827-hugepfn-allowable-orders-v1-1-94819c8807c8@kernel.org
Fixes: 5dd40721f147 ("mm: allow THP orders for PFNMAPs")
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reported-by: Cedric Le Goater <clg@redhat.com>
Closes: https://lore.kernel.org/linux-mm/20260805055544.1568534-1-clg@redhat.com/
Reported-by: Saravanan D <saravanand@crusoe.ai>
Closes: https://lore.kernel.org/linux-mm/20260821070520.25759-1-saravanand@crusoe.ai/
Reviewed-by: Zi Yan <ziy@nvidia.com>
Tested-by: Saravanan D <saravanand@crusoe.ai>
Tested-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: SJ Park <sj@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   86 +++++++++++++++++++++++++++++++++------------
 1 file changed, 64 insertions(+), 22 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-bypass-thp-tuneables-for-huge-pfnmap-mappings
+++ a/mm/huge_memory.c
@@ -92,7 +92,7 @@ unsigned long huge_anon_orders_madvise _
 unsigned long huge_anon_orders_inherit __read_mostly;
 static bool anon_orders_configured __initdata;
 
-static inline bool file_thp_enabled(struct vm_area_struct *vma)
+static inline bool file_thp_enabled(const struct vm_area_struct *vma)
 {
 	struct inode *inode;
 
@@ -118,6 +118,67 @@ static bool vma_is_special_huge(const st
 	return vma_test_any(vma, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT);
 }
 
+static bool vma_file_bypass_thp_tuneables(const struct vm_area_struct *vma,
+		enum tva_type type)
+{
+	const bool has_huge_fault = vma->vm_ops->huge_fault;
+
+	/* MADV_COLLAPSE ignores tuneables. */
+	if (type == TVA_FORCED_COLLAPSE)
+		return true;
+	/* Huge PFN mappings are uncompactable so the policy doesn't apply. */
+	if (vma_test(vma, VMA_PFNMAP_BIT) && has_huge_fault)
+		return true;
+	return false;
+}
+
+static bool vma_file_allow_thp_tuneables(vm_flags_t vm_flags)
+{
+	/* THP=always? */
+	if (hugepage_global_always())
+		return true;
+	/* THP=madvise and marked MADV_HUGEPAGE? */
+	if (hugepage_global_enabled() && (vm_flags & VM_HUGEPAGE))
+		return true;
+	return false;
+}
+
+static bool vma_file_check_thp_tuneables(const struct vm_area_struct *vma,
+		vm_flags_t vm_flags, enum tva_type type)
+{
+	return vma_file_bypass_thp_tuneables(vma, type) ||
+		vma_file_allow_thp_tuneables(vm_flags);
+}
+
+static bool vma_can_map_huge_file(const struct vm_area_struct *vma,
+		vm_flags_t vm_flags, enum tva_type type)
+{
+	const bool has_huge_fault = vma->vm_ops->huge_fault;
+
+	/*
+	 * Enforce THP collapse requirements as necessary. Anonymous vmas
+	 * were already handled in thp_vma_allowable_orders().
+	 */
+	if (!vma_file_check_thp_tuneables(vma, vm_flags, type))
+		return false;
+
+	switch (type) {
+	case TVA_PAGEFAULT:
+		/*
+		 * Trust that ->huge_fault() handlers know what they are doing
+		 * in fault path.
+		 */
+		return has_huge_fault;
+	case TVA_SMAPS:
+		if (has_huge_fault)
+			return true;
+		fallthrough;
+	default:
+		/* Only regular file is valid in collapse path. */
+		return file_thp_enabled(vma);
+	}
+}
+
 unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
 					 vm_flags_t vm_flags,
 					 enum tva_type type,
@@ -190,27 +251,8 @@ unsigned long __thp_vma_allowable_orders
 						   vma, vma_start_pgoff(vma), 0,
 						   forced_collapse);
 
-	if (!vma_is_anonymous(vma)) {
-		/*
-		 * Enforce THP collapse requirements as necessary. Anonymous vmas
-		 * were already handled in thp_vma_allowable_orders().
-		 */
-		if (!forced_collapse &&
-		    (!hugepage_global_enabled() || (!(vm_flags & VM_HUGEPAGE) &&
-						    !hugepage_global_always())))
-			return 0;
-
-		/*
-		 * Trust that ->huge_fault() handlers know what they are doing
-		 * in fault path.
-		 */
-		if (((in_pf || smaps)) && vma->vm_ops->huge_fault)
-			return orders;
-		/* Only regular file is valid in collapse path */
-		if (((!in_pf || smaps)) && file_thp_enabled(vma))
-			return orders;
-		return 0;
-	}
+	if (!vma_is_anonymous(vma))
+		return vma_can_map_huge_file(vma, vm_flags, type) ? orders : 0;
 
 	if (vma_is_temporary_stack(vma))
 		return 0;
_

Patches currently in -mm which might be from ljs@kernel.org are

mm-vma-correctly-unaccount-on-mmap_prepare-failure.patch
mm-vmpressure-remove-window-size-todo.patch
tools-testing-selftests-mm-add-missing-gitignore-entries.patch
mm-move-drivers-char-memc-to-mm-char-memc.patch
mm-implement-file_is_dev_zero-to-uniquely-identify-dev-zero.patch
mm-vma-only-permit-map_private-dev-zero-to-be-mapped-anonymous.patch
mm-vma-make-map_private-mapped-dev-zero-mappings-truly-anonymous.patch
tools-testing-vma-add-test-to-assert-map_private-dev-zero-is-anon.patch
tools-testing-selftests-mm-add-map_private-dev-zero-merge-tests.patch

