Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA2803C09F4
	for <mm-commits@vger.kernel.org>; Wed,  5 Aug 2026 02:26:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785896778; cv=none; b=Be7LqvB0gGB9hRaDNgTwaF4TtYEuIEAtjBDkNxCulqac8OakMUogPGB9nLptlugOxZayj40pWp9w5Yy9XJSeDef/JBXhLNZofc5LKfwAku6KQhOpdBFSQAdUIc+uNNLmwL8GMHdsRZdZ5pKniQS7vz2VAFrcnRekBdoyrpef4IE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785896778; c=relaxed/simple;
	bh=qZi8JP6IRiSVgs6IL46ERFZ3Bw7HYNZhUo18iAEXieE=;
	h=Date:To:From:Subject:Message-Id; b=rB8f2llJG9ABvoSbcJp2TNYKItbR2TUi/wUZfZdroQ8d1WNmAP+24NlooVu7b8P+ZD5ADg9Z+fMIEDSGaQYRT5TUV8UDn1wbk6hOvx3LUEV7oCkBpnLi7s9LrZjANnKvI92EbllC8vnWy339yAWapazO62jE9M42ZgfoUVernx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QqPcjply; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QqPcjply"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B28EB1F00A3A;
	Wed,  5 Aug 2026 02:26:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785896776;
	bh=yvRtFCwR2+aAebFu+Y9sGqMpwtP4Xy3u514ERmLEWtQ=;
	h=Date:To:From:Subject;
	b=QqPcjply3mul2rvU3SxGicnhs3+Sa4Sh4LK5R5TDxX4aA65lHfoZss4RacPph4z8i
	 8e1vADeFFO+VhqXSn8S1e1NMKeO8e1jnjMbxJJRWo/+k6F+feH10Q3Cb4d5k40QB11
	 mpZNfVLGlQyjJPBlA1OGJGsJkLdbVtHgrh+83+nQ=
Date: Tue, 04 Aug 2026 19:26:16 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,tzimmermann@suse.de,sj@kernel.org,pfalcato@suse.de,m.szyprowski@samsung.com,liam@infradead.org,kai.huang@intel.com,gourry@gourry.net,david@kernel.org,ackerleytng@google.com,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vma-remove-duplicative-vma_pgoff_offset-helper.patch removed from -mm tree
Message-Id: <20260805022616.B28EB1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vma: remove duplicative vma_pgoff_offset() helper
has been removed from the -mm tree.  Its filename was
     mm-vma-remove-duplicative-vma_pgoff_offset-helper.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <ljs@kernel.org>
Subject: mm/vma: remove duplicative vma_pgoff_offset() helper
Date: Fri, 10 Jul 2026 21:17:01 +0100

This is doing what linear_page_index() does, so eliminate it and replace it
with linear_page_index().

Update the VMA userland tests to reflect this change.

No functional change intended.

Link: https://lore.kernel.org/20260710-b4-pre-scalable-cow-v2-20-2a5aa403d977@kernel.org
Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Gregory Price <gourry@gourry.net>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Ackerley Tng <ackerleytng@google.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Kai Huang <kai.huang@intel.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: SJ Park <sj@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Liam R. Howlett (Oracle) <liam@infradead.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vma.h                        |    9 +--------
 tools/testing/vma/include/dup.h |   16 ++++++++++++++++
 2 files changed, 17 insertions(+), 8 deletions(-)

--- a/mm/vma.h~mm-vma-remove-duplicative-vma_pgoff_offset-helper
+++ a/mm/vma.h
@@ -247,13 +247,6 @@ static inline pgoff_t vmg_end_pgoff(cons
 	return vmg_start_pgoff(vmg) + vmg_pages(vmg);
 }
 
-/* Assumes addr >= vma->vm_start. */
-static inline pgoff_t vma_pgoff_offset(struct vm_area_struct *vma,
-				       unsigned long addr)
-{
-	return vma->vm_pgoff + PHYS_PFN(addr - vma->vm_start);
-}
-
 #define VMG_STATE(name, mm_, vmi_, start_, end_, vma_flags_, pgoff_)	\
 	struct vma_merge_struct name = {				\
 		.mm = mm_,						\
@@ -275,7 +268,7 @@ static inline pgoff_t vma_pgoff_offset(s
 		.start = start_,				\
 		.end = end_,					\
 		.vm_flags = vma_->vm_flags,			\
-		.pgoff = vma_pgoff_offset(vma_, start_),	\
+		.pgoff = linear_page_index(vma_, start_),	\
 		.file = vma_->vm_file,				\
 		.anon_vma = vma_->anon_vma,			\
 		.policy = vma_policy(vma_),			\
--- a/tools/testing/vma/include/dup.h~mm-vma-remove-duplicative-vma_pgoff_offset-helper
+++ a/tools/testing/vma/include/dup.h
@@ -1548,3 +1548,19 @@ static inline pgprot_t vma_get_page_prot
 
 	return vm_get_page_prot(vm_flags);
 }
+
+static inline pgoff_t linear_page_delta(const struct vm_area_struct *vma,
+					const unsigned long address)
+{
+	return (address - vma->vm_start) >> PAGE_SHIFT;
+}
+
+static inline pgoff_t linear_page_index(const struct vm_area_struct *vma,
+					const unsigned long address)
+{
+	pgoff_t pgoff;
+
+	pgoff = linear_page_delta(vma, address);
+	pgoff += vma_start_pgoff(vma);
+	return pgoff;
+}
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

