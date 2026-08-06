Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F120C47F77C
	for <mm-commits@vger.kernel.org>; Thu,  6 Aug 2026 23:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786058045; cv=none; b=nN6TpW7PgoouuneUhI2h8pebLeVp9DM3YqMH8WSknOgh73t/ULJQGU08OK/u3TDiwY4roaqOKGnU/48bq/m7MtTeuvGHqoHc1QLR5TSgVJ0ky3kw3C3LTNWlQU3GxzA63cIw1zyWXJFfFZIFdDgWS7SyZsKnoqx/BdwmTbzhypY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786058045; c=relaxed/simple;
	bh=Hsg9lBsNJ01tuqfZ4hlsBfSULhpOblBrNc4CRJSxVzM=;
	h=Date:To:From:Subject:Message-Id; b=nwJ/L5YHwqWWgzrFm9MVjgEqFXZn/GlxkqRb1CzSItYhm+p07rAR7ZBgdoU2n5KL9aI40UbOw5KyoZpBT6k4lWcN8RW3ILPGH1bVZNr8QNEarj8IL/pdeeJOzf5BIVPSScv8RDq9IZ57cBbSGggedZ6z7fylF+66Nur97YYBYlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0FxVPy5/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0FxVPy5/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C64551F000E9;
	Thu,  6 Aug 2026 23:14:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786058043;
	bh=DohbiFwByDP4XKhIRYOV6gmp8gwHGl893WRgPSOEWu0=;
	h=Date:To:From:Subject;
	b=0FxVPy5/8BOhoou/ix5Qc8k74R+z7rbT25s7/3VcXY2sxiY7XGQEE7GRDrAUAWMbY
	 8pwpRPOVaKG0XzcijhCY+KvQKmpWTQL+guQNLfzLfWkWvwwZ6kNairDdGml6odYcJn
	 gg7eggf8ZvrZAC1zongVE/uoX3NWpI4sRj/Un3mg=
Date: Thu, 06 Aug 2026 16:14:03 -0700
To: mm-commits@vger.kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-rmap-track-whether-the-page-vma-mapped-walk-is-anonymous.patch removed from -mm tree
Message-Id: <20260806231403.C64551F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/rmap: track whether the page VMA mapped walk is anonymous
has been removed from the -mm tree.  Its filename was
     mm-rmap-track-whether-the-page-vma-mapped-walk-is-anonymous.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: mm/rmap: track whether the page VMA mapped walk is anonymous
Date: Mon, 20 Jul 2026 15:38:33 +0100

Update the page_vma_mapped_walk structure to track whether the walk is
over an anonymous folio or not.

This is necessary in order to determine the correct VMA page offset
(virtual or not) in vma_address_end() ready for a subsequent change which
adjusts which page offset to use depending on this parameter, and update
the comment slightly.

No functional change intended.

Link: https://lore.kernel.org/20260720-b4-scalable-cow-virt-pgoff-v2-7-2d549757a76f@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Gregory Price <gourry@gourry.net>
Cc: Harry Yoo <harry@kernel.org>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: xu xin <xu.xin16@zte.com.cn>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h |    2 ++
 mm/internal.h        |   13 ++++++++-----
 mm/rmap.c            |    2 ++
 3 files changed, 12 insertions(+), 5 deletions(-)

--- a/include/linux/rmap.h~mm-rmap-track-whether-the-page-vma-mapped-walk-is-anonymous
+++ a/include/linux/rmap.h
@@ -871,6 +871,7 @@ struct page_vma_mapped_walk {
 	pte_t *pte;
 	spinlock_t *ptl;
 	unsigned int flags;
+	bool is_anon_walk;
 };
 
 #define DEFINE_FOLIO_VMA_WALK(name, _folio, _vma, _address, _flags)	\
@@ -881,6 +882,7 @@ struct page_vma_mapped_walk {
 		.vma = _vma,						\
 		.address = _address,					\
 		.flags = _flags,					\
+		.is_anon_walk = folio_test_anon(_folio),		\
 	}
 
 static inline void page_vma_mapped_walk_done(struct page_vma_mapped_walk *pvmw)
--- a/mm/internal.h~mm-rmap-track-whether-the-page-vma-mapped-walk-is-anonymous
+++ a/mm/internal.h
@@ -1091,22 +1091,25 @@ static inline unsigned long vma_anon_add
 }
 
 /*
- * Then at what user virtual address will none of the range be found in vma?
+ * At what user virtual address will none of the range be found in vma?
  * Assumes that vma_address() already returned a good starting address.
  */
 static inline unsigned long vma_address_end(struct page_vma_mapped_walk *pvmw)
 {
-	struct vm_area_struct *vma = pvmw->vma;
-	pgoff_t pgoff;
+	const struct vm_area_struct *vma = pvmw->vma;
+	const pgoff_t pgoff = pvmw->pgoff;
+	pgoff_t pgoff_vma_start;
 	unsigned long address;
+	pgoff_t pgoff_end;
 
 	/* Common case, plus ->pgoff is invalid for KSM */
 	if (pvmw->nr_pages == 1)
 		return pvmw->address + PAGE_SIZE;
 
-	pgoff = pvmw->pgoff + pvmw->nr_pages;
+	pgoff_vma_start = vma_start_pgoff(vma);
+	pgoff_end = pgoff + pvmw->nr_pages;
 	address = vma->vm_start +
-		((pgoff - vma_start_pgoff(vma)) << PAGE_SHIFT);
+		((pgoff_end - pgoff_vma_start) << PAGE_SHIFT);
 	/* Check for address beyond vma (or wrapped through 0?) */
 	if (address < vma->vm_start || address > vma->vm_end)
 		address = vma->vm_end;
--- a/mm/rmap.c~mm-rmap-track-whether-the-page-vma-mapped-walk-is-anonymous
+++ a/mm/rmap.c
@@ -1240,6 +1240,7 @@ static bool mapping_wrprotect_range_one(
 		.vma		= vma,
 		.address	= address,
 		.flags		= PVMW_SYNC,
+		.is_anon_walk   = false,
 	};
 
 	state->cleaned += page_vma_mkclean_one(&pvmw);
@@ -1317,6 +1318,7 @@ int pfn_mkclean_range(unsigned long pfn,
 		.pgoff		= pgoff,
 		.vma		= vma,
 		.flags		= PVMW_SYNC,
+		.is_anon_walk   = false,
 	};
 
 	if (invalid_mkclean_vma(vma, NULL))
_

Patches currently in -mm which might be from ljs@kernel.org are

x86-mm-pat-acquire-init_mm-write-lock-on-collapse-to-avoid-uaf.patch
x86-mm-pat-acquire-init_mm-read-lock-on-attribute-change-to-avoid-uaf.patch
x86-mm-pat-allocate-split-page-tables-as-kernel-page-tables.patch
mm-introduce-vma_flags_can_grow-and-vma_can_grow.patch
mm-vma-update-do_mmap-to-use-vma_flags_t.patch
mm-convert-__get_unmapped_area-to-use-vma_flags_t.patch
mm-update-generic_get_unmapped_area-to-use-vma_flags_t.patch
mm-prefer-mm-def_vma_flags-in-mm-logic.patch
mm-vma-convert-vm_pgprot_modify-to-use-vma_flags_t-and-rename.patch
mm-vma-rename-vma_get_page_prot-to-vma_flags_to_page_prot.patch
mm-introduce-vma_get_page_prot-and-use-it.patch
mm-vma-update-create_init_stack_vma-to-use-vma_flags_t.patch
mm-vma-convert-miscellaneous-uses-of-vma-flags-in-core-mm.patch
mm-mlock-convert-mlock-code-to-use-vma_flags_t.patch
mm-mprotect-convert-mprotect-code-to-use-vma_flags_t.patch
mm-mremap-convert-mremap-code-to-use-vma_flags_t.patch
mm-mseal-remove-superfluous-comments-fix-confusion-around-mm.patch
mm-mseal-limit-scope-of-mseal-address-zero-to-address-zero.patch
mm-mseal-remove-further-superfluous-comments-do_mseal.patch
mm-introduce-and-use-linear_folio_page_index.patch
mm-rmap-use-virt-pgoff-for-map_private-file-backed-anon-folios.patch
tools-testing-vma-expand-vma-merge-tests-to-assert-virt-pgoff.patch
tools-testing-selftests-mm-test-virtual-page-offset-merge-behaviour.patch
mm-vma-only-permit-map_private-dev-zero-to-be-mapped-anonymous.patch
mm-vma-make-map_private-mapped-dev-zero-mappings-truly-anonymous.patch
tools-testing-vma-add-test-to-assert-map_private-dev-zero-is-anon.patch
tools-testing-selftests-mm-add-map_private-dev-zero-merge-tests.patch
mm-add-some-missing-includes-to-mm-local-headers.patch

