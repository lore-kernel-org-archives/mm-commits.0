Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E59A54E50B5
	for <mm-commits@vger.kernel.org>; Tue, 29 Sep 2026 21:32:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790717560; cv=none; b=surz2Oi9iNHtswLU6UvIVKX0TfAJ7GGP1jVmSZqUwPocBVYp7D2imPMrKXIu/wVqwpRRJ7LtUjFIURwMlXgs7Ts+N41vCX+qW66600JIw/gbZcZGURCUbsOZhxOJSeCUCJ0v8xS9rv5kDD26jGoNWoJOLvuV3Ss3V6h8cASX2A0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790717560; c=relaxed/simple;
	bh=Q06et4xYP3I55Vu9F+pVlUJRGqShNUhuvFqsPu1Yv5Q=;
	h=Date:To:From:Subject:Message-Id; b=mOVPPefAL8YuR+4yyH+CpGwC1u1e9I8CrhIh21IUQ9vo95G1rsvFTPqHRT/HQmO6x0/xmIWUIcUcfIYCFlBqZtsoU8l/L202h63/THcP0rTDl8Ns4RezJFDPkQfncQbx4xQsJkiBVR93c8wlT8S57q7oLb5e/RT6HYqWJh6y9GQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QZK5rO7Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QZK5rO7Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8C1E1F00893;
	Tue, 29 Sep 2026 21:32:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790717557;
	bh=b/fwRqB2yz8yo843USoc/6/V2FcwDgHRiu3lg4pYQFg=;
	h=Date:To:From:Subject;
	b=QZK5rO7QUBEZvungoXXQFTmw4apmxk5vJ/DbHcRhM3fN8Hvb7UkCQVkQWCIwll01e
	 Zc2NPkVjg2Hbat6vHy63K8Hbmu3dXViTooePLMFDOUaZ83fWycKtT0wd0bBsB2y5S4
	 S13rqlq77+eNASDxz7UhjQGChtwPw1L/VCWEk0H4=
Date: Tue, 29 Sep 2026 14:32:37 -0700
To: mm-commits@vger.kernel.org,muchun.song@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-sparse-vmemmap-support-device-dax-in-common-vmemmap-path.patch added to mm-new branch
Message-Id: <20260929213237.A8C1E1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/sparse-vmemmap: support device DAX in common vmemmap path
has been added to the -mm mm-new branch.  Its filename is
     mm-sparse-vmemmap-support-device-dax-in-common-vmemmap-path.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-sparse-vmemmap-support-device-dax-in-common-vmemmap-path.patch

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
From: Muchun Song <muchun.song@linux.dev>
Subject: mm/sparse-vmemmap: support device DAX in common vmemmap path
Date: Tue, 29 Sep 2026 13:32:27 +0800

The common vmemmap population path cannot yet handle optimized Device DAX
mappings on its own.  It uses pfn_to_zone() to find the shared tail page,
but Device DAX populates its vmemmap at runtime before the ZONE_DEVICE
span is initialized.

Teach the common path to use device_zone() for runtime optimized vmemmap
population while retaining pfn_to_zone() for early boot.  This allows the
same path to support both early boot mappings and Device DAX.

The backing PFN supplied by the Device DAX-specific population path is no
longer used, allowing the redundant lookup and population code to be
removed later.

Link: https://lore.kernel.org/20260929053231.66085-3-songmuchun@bytedance.com
Signed-off-by: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Christophe Leroy <chleroy@kernel.org>
Cc: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Cc: Shrikanth Hegde <sshegde@linux.ibm.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
---

 mm/sparse-vmemmap.c |   62 +++++++++++++++++++++++-------------------
 1 file changed, 34 insertions(+), 28 deletions(-)

--- a/mm/sparse-vmemmap.c~mm-sparse-vmemmap-support-device-dax-in-common-vmemmap-path
+++ a/mm/sparse-vmemmap.c
@@ -237,18 +237,43 @@ static __meminit void *vmemmap_alloc_pte
 	struct page *page;
 	const unsigned int order = pfn_to_section_compound_order(pfn);
 
-	/*
-	 * Device DAX still relies on vmemmap_populate_compound_pages() for
-	 * head/first-tail allocation and tail-page reuse.
-	 */
 	if (!vmemmap_optimizable_pfn(pfn))
 		return vmemmap_alloc_block_buf(PAGE_SIZE, node, altmap);
 
-	zone = pfn_to_zone(pfn, node);
+	/*
+	 * Before slab is available, vmemmap optimization is used for early
+	 * system RAM, whose zone can be determined from the PFN.
+	 *
+	 * Once slab is available, only ZONE_DEVICE memory reaches this
+	 * optimized population path. Its zone span has not been initialized
+	 * while its vmemmap is being populated, so pfn_to_zone() cannot be
+	 * used. Obtain ZONE_DEVICE directly from the node instead.
+	 */
+	zone = slab_is_available() ? device_zone(node) : pfn_to_zone(pfn, node);
 	page = vmemmap_shared_tail_page(order, zone);
 	if (!page)
 		return NULL;
 
+	/*
+	 * During early vmemmap population, the shared tail vmemmap backing
+	 * page is allocated from memblock before its struct page can safely
+	 * participate in page refcounting. Therefore, no reference can be
+	 * held for each shared PTE mapping, and the mappings must be unshared
+	 * before the vmemmap is depopulated.
+	 *
+	 * Once slab is available, the shared backing page is allocated from
+	 * the buddy allocator and can be refcounted. Hold one reference for
+	 * each shared PTE mapping. The architecture vmemmap teardown drops
+	 * the reference through __free_pages() when removing the mapping,
+	 * preventing the backing page from being freed while it is shared.
+	 *
+	 * The backing page may be shared by enough PTE mappings to exhaust
+	 * the positive range of its reference count. Stop populating the
+	 * vmemmap if another reference cannot be acquired.
+	 */
+	if (slab_is_available() && !try_get_page(page))
+		return NULL;
+
 	return page_address(page);
 }
 
@@ -260,31 +285,12 @@ static pte_t * __meminit vmemmap_pte_pop
 
 	if (pte_none(ptep_get(pte))) {
 		pte_t entry;
+		void *p = vmemmap_alloc_pte(pfn, node, altmap);
 
-		if (ptpfn == (unsigned long)-1) {
-			void *p = vmemmap_alloc_pte(pfn, node, altmap);
+		if (!p)
+			return NULL;
 
-			if (!p)
-				return NULL;
-			ptpfn = PHYS_PFN(__pa(p));
-		} else {
-			/*
-			 * When a PTE/PMD entry is freed from the init_mm
-			 * there's a free_pages() call to this page allocated
-			 * above. Thus this try_get_page() is paired with the
-			 * put_page_testzero() on the freeing path.
-			 * This can only called by certain ZONE_DEVICE path,
-			 * and through vmemmap_populate_compound_pages() when
-			 * slab is available.
-			 *
-			 * Use try_get_page() to prevent the shared page refcount
-			 * from overflowing.
-			 */
-			if (slab_is_available() &&
-			    !try_get_page(pfn_to_page(ptpfn)))
-				return NULL;
-		}
-		entry = pfn_pte(ptpfn, PAGE_KERNEL);
+		entry = pfn_pte(PHYS_PFN(__pa(p)), PAGE_KERNEL);
 		set_pte_at(&init_mm, addr, pte, entry);
 	} else if (WARN_ON_ONCE(vmemmap_optimizable_pfn(pfn)))
 		return NULL;
_

Patches currently in -mm which might be from muchun.song@linux.dev are

mm-sparse-vmemmap-factor-out-shared-vmemmap-tail-page-allocation.patch
mm-sparse-vmemmap-allocate-shared-tail-page-array-dynamically.patch
mm-sparse-vmemmap-introduce-config_vmemmap_optimization.patch
mm-sparse-vmemmap-open-code-init_compound_tail.patch
mm-sparse-vmemmap-prepare-dax-vmemmap-population-for-compound-page-orders.patch
mm-sparse-vmemmap-set-compound-page-order-for-device-dax.patch
mm-sparse-vmemmap-switch-device-dax-to-shared-tail-vmemmap-pages.patch
mm-sparse-vmemmap-switch-device-dax-to-shared-tail-vmemmap-pages-fix.patch
mm-sparse-vmemmap-move-vmemmap-optimization-helpers-to-a-public-header.patch
powerpc-mm-switch-device-dax-to-shared-tail-vmemmap-pages.patch
mm-sparse-vmemmap-drop-the-extra-tail-page-from-device-dax-reservation.patch
mm-sparse-vmemmap-drop-unused-section_nr_vmemmap_pages-arguments.patch
documentation-mm-update-dax-vmemmap-deduplication-docs.patch
mm-sparse-vmemmap-drop-vmemmap_populate_dax.patch
mm-sparse-vmemmap-support-device-dax-in-common-vmemmap-path.patch
mm-sparse-vmemmap-drop-device-dax-specific-population-path.patch
mm-sparse-vmemmap-remove-the-unused-ptpfn-argument.patch
mm-sparse-vmemmap-open-code-vmemmap_populate_address.patch
mm-mm_init-add-zone-mismatch-warning-during-page-init.patch

