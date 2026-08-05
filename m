Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E1A23C0A1A
	for <mm-commits@vger.kernel.org>; Wed,  5 Aug 2026 02:26:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785896772; cv=none; b=upJKTP0aNo5aZNsIMqzZIE5HDN3RpPR/+1rqRoWppedq9U+CpZBSg18ekH9GDBv/6oHkg/oet7xoS2ZHCMCkMeNCDUQv46uTOvGAONBzPPSA5LyNDhHte8BIyLUumU9IGS4JHlgGCaqxGm39bFKQKkfha/U1On3FdH/0JVCdPHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785896772; c=relaxed/simple;
	bh=nsOKAW2d7BDaUGwFob4jXSXsCEUifLy/9gbLG+2wmt4=;
	h=Date:To:From:Subject:Message-Id; b=tFjWFRD0sMr1WDGfgUK2O+Xdaupr/wwvWPCBnLtGgJznxaWU3Wl2wubkAfB+C5v4WgObjsBqzZV8njhaSxI5xCB+EIo29iCvDzSW0E/+HYu//reH4OC+nTauZ5pUgPZwI/AfM4/MMX8jNhCvc3ddDwV9k4CtiN7uhBR77th+hv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ySn5eyqb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ySn5eyqb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05C291F000E9;
	Wed,  5 Aug 2026 02:26:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785896771;
	bh=KpMPimZYx2LuKnUnSrBb7LOC682k4IswRXN5uxV2HaE=;
	h=Date:To:From:Subject;
	b=ySn5eyqbAI//4oo9wl3kiXUOXoc/uQSQhws8OzHOlJr17O/f4Y7q9nLi+T4LrcpDc
	 9StAJ1mloKG45gFZQ8gazGPmTnGz6pV4WWkWsgQBaHtUXuTT6LCNyCi/aZP3HCBnrM
	 ft+xapG+nViynvVmy/olv4H7Kr7591cbw0iaBfVg=
Date: Tue, 04 Aug 2026 19:26:10 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,tzimmermann@suse.de,sj@kernel.org,pfalcato@suse.de,m.szyprowski@samsung.com,liam@infradead.org,kai.huang@intel.com,gourry@gourry.net,david@kernel.org,ackerleytng@google.com,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-introduce-and-use-linear_page_delta.patch removed from -mm tree
Message-Id: <20260805022611.05C291F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: introduce and use linear_page_delta()
has been removed from the -mm tree.  Its filename was
     mm-introduce-and-use-linear_page_delta.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <ljs@kernel.org>
Subject: mm: introduce and use linear_page_delta()
Date: Fri, 10 Jul 2026 21:16:58 +0100

It's often useful to obtain the number of pages a given address lies at
within a VMA.

Add linear_page_delta() to determine this and update linear_page_index() to
make use of it.

Add comments to describe both linear_page_delta() and linear_page_index().

We refer the reader to the comment for vma_start_pgoff() so we don't
duplicate information about the meaning of a VMA's page offset, which is
also less likely to result in bitrot.

No functional change intended.

Link: https://lore.kernel.org/20260710-b4-pre-scalable-cow-v2-17-2a5aa403d977@kernel.org
Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
Reviewed-by: Ackerley Tng <ackerleytng@google.com>
Reviewed-by: Gregory Price <gourry@gourry.net>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Kai Huang <kai.huang@intel.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: SJ Park <sj@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Liam R. Howlett (Oracle) <liam@infradead.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |   33 +++++++++++++++++++++++++++++++--
 1 file changed, 31 insertions(+), 2 deletions(-)

--- a/include/linux/pagemap.h~mm-introduce-and-use-linear_page_delta
+++ a/include/linux/pagemap.h
@@ -1063,11 +1063,40 @@ static inline pgoff_t folio_pgoff(const
 	return folio->index;
 }
 
+/**
+ * linear_page_delta() - Determine the relative page offset of @address within
+ * @vma.
+ * @vma: The VMA in which @address resides.
+ * @address: The address whose relative page offset is required.
+ *
+ * The result is identical for both file-backed and anonymous mappings and
+ * simply determines how many pages @address lies from @vma->vm_start.
+ *
+ * Returns: The number of pages @address is offset by within @vma.
+ */
+static inline pgoff_t linear_page_delta(const struct vm_area_struct *vma,
+					const unsigned long address)
+{
+	return (address - vma->vm_start) >> PAGE_SHIFT;
+}
+
+/**
+ * linear_page_index() - Determine the absolute page offset of @address within
+ * @vma.
+ * @vma: The VMA in which @address resides.
+ * @address: The address whose absolute page offset is required.
+ *
+ * See the comment for vma_start_pgoff() for a description of what the page
+ * offset signifies.
+ *
+ * Returns: The absolute page offset of @address within @vma.
+ */
 static inline pgoff_t linear_page_index(const struct vm_area_struct *vma,
 					const unsigned long address)
 {
 	pgoff_t pgoff;
-	pgoff = (address - vma->vm_start) >> PAGE_SHIFT;
+
+	pgoff = linear_page_delta(vma, address);
 	pgoff += vma->vm_pgoff;
 	return pgoff;
 }
@@ -1219,7 +1248,7 @@ static inline vm_fault_t folio_lock_or_r
 void folio_wait_bit(struct folio *folio, int bit_nr);
 int folio_wait_bit_killable(struct folio *folio, int bit_nr);
 
-/* 
+/*
  * Wait for a folio to be unlocked.
  *
  * This must be called with the caller "holding" the folio,
_

Patches currently in -mm which might be from ljs@kernel.org are

mm-vmalloc-acquire-init_mm-lock-on-huge-vmap-to-avoid-ptdump-uaf.patch
mm-ptdump-always-stabilise-against-page-table-freeing-using-init_mm.patch
arm64-remove-redundant-concurrent-ptdump-uaf-mitigation.patch
mm-huge_memory-fix-huge_zero_pfn-race.patch
mm-huge_memory-separate-out-config_persistent_huge_zero_folio-logic.patch
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
mm-vma-introduce-vma-virtual-page-offset-field-and-add-helpers.patch
mm-introduce-linear_virt_page_index.patch
mm-abstract-vma_address-and-introduce-vma_anon_address.patch
mm-update-print_bad_page_map-to-show-virtual-page-index.patch
mm-introduce-and-use-vma_filebacked_address.patch
mm-propagate-vma-virtual-page-offset-on-map-remap-split-merge.patch
mm-rmap-track-whether-the-page-vma-mapped-walk-is-anonymous.patch
mm-introduce-and-use-linear_folio_page_index.patch
mm-rmap-use-virt-pgoff-for-map_private-file-backed-anon-folios.patch
tools-testing-vma-expand-vma-merge-tests-to-assert-virt-pgoff.patch
tools-testing-selftests-mm-test-virtual-page-offset-merge-behaviour.patch
mm-vma-only-permit-map_private-dev-zero-to-be-mapped-anonymous.patch
mm-vma-make-map_private-mapped-dev-zero-mappings-truly-anonymous.patch
tools-testing-vma-add-test-to-assert-map_private-dev-zero-is-anon.patch
tools-testing-selftests-mm-add-map_private-dev-zero-merge-tests.patch
mm-add-some-missing-includes-to-mm-local-headers.patch

