Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDF8C3BB10C
	for <mm-commits@vger.kernel.org>; Wed,  5 Aug 2026 02:25:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785896751; cv=none; b=Pb892JAwbt82+XFS21V2JlJdFdAIZ973DHGx8FKSO1g3tbECqzi8m/eDg9u9Nh2o1/cKIvchPgUW1939RThAwBN6k/MnIG0kqxeOiKDlrbPJkqgemnAF+as8e3RFAmgm1ijbSGK280blnPEG09EUa3jbZbB91Gh2ynEJ+s0H/nI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785896751; c=relaxed/simple;
	bh=2+AEkHdDu0BZlxwxSzTeGIYi+Sa/Vmeb/bmVcQm6p+Y=;
	h=Date:To:From:Subject:Message-Id; b=Q76Eowp/+T8W8DnHrRghNMsI43YUPj7WnXGH4rLqPCJMI6W1OIhcMczfkYA6eUrpmGG5adLW0qCPBvSWlkvxNL2ddP6ASKkxeCeK0hm0DPieLrb+k2Yll2exJGhLHNsigmT7Lj9uyho1E28m+4gvLNl/HTTetfar7Nmk8FEBXVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=djNNg7Ko; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="djNNg7Ko"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B564D1F00A3A;
	Wed,  5 Aug 2026 02:25:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785896749;
	bh=ZVSLqo5lgyr1EgLpM/XSNc+6KF4UNA16yM+669Zb74s=;
	h=Date:To:From:Subject;
	b=djNNg7Ko8KZkmA9kyESxscVdQ4kjlDZb9cFEpFNPWhZMzznnhDD8ufS2NOClH0Pi+
	 T86tV5Va2P9xFPH4C5vQsCUWrioWYZr93xjFa9Yk+4XvrFWcismgrHPuYCe/q0yTWu
	 DHBOPMgABGWe5cBRbdyxEyaJ5Y/KjQjq7g/Kab+Y=
Date: Tue, 04 Aug 2026 19:25:49 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,tzimmermann@suse.de,sj@kernel.org,pfalcato@suse.de,m.szyprowski@samsung.com,liam@infradead.org,kai.huang@intel.com,gourry@gourry.net,david@kernel.org,ackerleytng@google.com,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-introduce-and-use-vma_end_pgoff.patch removed from -mm tree
Message-Id: <20260805022549.B564D1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: introduce and use vma_end_pgoff()
has been removed from the -mm tree.  Its filename was
     mm-introduce-and-use-vma_end_pgoff.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <ljs@kernel.org>
Subject: mm: introduce and use vma_end_pgoff()
Date: Fri, 10 Jul 2026 21:16:45 +0100

We already have vma_last_pgoff() which retrieves the last page offset
within a VMA.

However, code often wishes to span a page offset range, which requires the
exclusive end of this range.

So provide this in vma_end_pgoff() and update vma_last_pgoff() to use this
function.

Also update the VMA userland tests to reflect the change.

No functional change intended.

Link: https://lore.kernel.org/20260710-b4-pre-scalable-cow-v2-4-2a5aa403d977@kernel.org
Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
Reviewed-by: Gregory Price <gourry@gourry.net>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Ackerley Tng <ackerleytng@google.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Kai Huang <kai.huang@intel.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: SJ Park <sj@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Liam R. Howlett (Oracle) <liam@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h              |   19 ++++++++++++++++++-
 tools/testing/vma/include/dup.h |    5 +++++
 2 files changed, 23 insertions(+), 1 deletion(-)

--- a/include/linux/mm.h~mm-introduce-and-use-vma_end_pgoff
+++ a/include/linux/mm.h
@@ -4336,6 +4336,23 @@ static inline pgoff_t vma_start_pgoff(co
 }
 
 /**
+ * vma_end_pgoff() - Get the page offset of the exclusive end of @vma
+ * @vma: The VMA whose end page offset is required.
+ *
+ * This returns the exclusive end page offset of @vma, which is useful for
+ * expressing page offset ranges.
+ *
+ * See the description of vma_start_pgoff() for a description of VMA page
+ * offsets.
+ *
+ * Returns: The exclusive end page offset of @vma.
+ */
+static inline pgoff_t vma_end_pgoff(const struct vm_area_struct *vma)
+{
+	return vma_start_pgoff(vma) + vma_pages(vma);
+}
+
+/**
  * vma_last_pgoff() - Get the page offset of the last page in @vma
  * @vma: The VMA whose last page offset is required.
  *
@@ -4348,7 +4365,7 @@ static inline pgoff_t vma_start_pgoff(co
  */
 static inline pgoff_t vma_last_pgoff(const struct vm_area_struct *vma)
 {
-	return vma_start_pgoff(vma) + vma_pages(vma) - 1;
+	return vma_end_pgoff(vma) - 1;
 }
 
 static inline unsigned long vma_desc_size(const struct vm_area_desc *desc)
--- a/tools/testing/vma/include/dup.h~mm-introduce-and-use-vma_end_pgoff
+++ a/tools/testing/vma/include/dup.h
@@ -1306,6 +1306,11 @@ static inline pgoff_t vma_start_pgoff(co
 	return vma->vm_pgoff;
 }
 
+static inline pgoff_t vma_end_pgoff(const struct vm_area_struct *vma)
+{
+	return vma_start_pgoff(vma) + vma_pages(vma);
+}
+
 static inline int vfs_mmap_prepare(struct file *file, struct vm_area_desc *desc)
 {
 	return file->f_op->mmap_prepare(desc);
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

