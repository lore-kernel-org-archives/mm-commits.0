Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5A1A3C09F4
	for <mm-commits@vger.kernel.org>; Wed,  5 Aug 2026 02:26:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785896781; cv=none; b=illgqzj+IloQe0jJI62QNC3Yf3kEAsuGFsiH9PLyyV8n+Jbr8FFd/A04WNqCJOsnqDtCgemZSl/PgK9FDINe/vWhb1sipGVjQiPHhXlO+5RSiBZPjMdrpglR38UpnsXo68ZI2ovc6wqSzJ09EiB3SLUsicdxGPwyyBlrZREHgZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785896781; c=relaxed/simple;
	bh=5EDiQTOmkdcfWwArTxbKMMYiypC+GQXEc4fuZN2PbnA=;
	h=Date:To:From:Subject:Message-Id; b=gEwuQJvrv4TduyihRNBWmE89/TYaCXsC9xCbx+lXMA5r/83xx8zBXHBwK7A72NqtJRsD7H2s1KBjh1fNyCr/FGtQI1RXFp9LBjoz0nhb4YeiFLhoWMfkYJnoa3l72k5iB8U01s6dJp9ow57RqID6LE0Yiaqx0tSFBZSjuGrboq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=enosrV2N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="enosrV2N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DD241F00A3A;
	Wed,  5 Aug 2026 02:26:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785896779;
	bh=BgI5VEMi+COG6o5CIpIZzeqEsa7EnDdnv3gsdrIGLLI=;
	h=Date:To:From:Subject;
	b=enosrV2NcQy25ZwQ9mKvANTNg24BfZXDqczKnr1Nf8JxINWC+LyREOezKRvCnQPqh
	 KSSitrf9ZzkWMF/eTJOf8cxYiWPPzAsGnS+fWNU5DhUybPiOxJKM9q9yEJ9kHUXHYE
	 ZJ82jjsU3qTzc4ldweqUwcLyHEPWOv8DvxXre8to=
Date: Tue, 04 Aug 2026 19:26:19 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,tzimmermann@suse.de,sj@kernel.org,pfalcato@suse.de,m.szyprowski@samsung.com,liam@infradead.org,kai.huang@intel.com,gourry@gourry.net,david@kernel.org,ackerleytng@google.com,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vma-introduce-vma_assert_can_modify.patch removed from -mm tree
Message-Id: <20260805022619.8DD241F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vma: introduce vma_assert_can_modify()
has been removed from the -mm tree.  Its filename was
     mm-vma-introduce-vma_assert_can_modify.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <ljs@kernel.org>
Subject: mm/vma: introduce vma_assert_can_modify()
Date: Fri, 10 Jul 2026 21:17:03 +0100

vma_assert_write_locked() and vma_assert_attached() are useful for their
own purposes, however VMA code absolutely does allow the modification of
non-write locked VMAs if they are at that point detached (i.e. unreachable
from anywhere).

It's therefore useful to be able to assert that a VMA is either
detached (modification doesn't matter) or write locked (you're explicitly
locked for modification).

Therefore introduce vma_assert_can_modify() for this purpose.

While we're here, make vma_is_attached() available generally - if
!CONFIG_PER_VMA_LOCK, then there's no sense in which a VMA is
detached (vma_mark_detached() is a noop), so have this default to true in
this case.

Also update VMA userland tests to reflect this change, correcting the
previously open-coded vma_assert_[attached,detached]() there.

Link: https://lore.kernel.org/20260710-b4-pre-scalable-cow-v2-22-2a5aa403d977@kernel.org
Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
Reviewed-by: Gregory Price <gourry@gourry.net>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Ackerley Tng <ackerleytng@google.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Kai Huang <kai.huang@intel.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: SJ Park <sj@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Liam R. Howlett (Oracle) <liam@infradead.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmap_lock.h       |    8 ++++++++
 tools/testing/vma/include/dup.h |   15 +++++++++++++--
 2 files changed, 21 insertions(+), 2 deletions(-)

--- a/include/linux/mmap_lock.h~mm-vma-introduce-vma_assert_can_modify
+++ a/include/linux/mmap_lock.h
@@ -506,6 +506,8 @@ static inline __must_check
 int vma_start_write_killable(struct vm_area_struct *vma) { return 0; }
 static inline void vma_assert_write_locked(struct vm_area_struct *vma)
 		{ mmap_assert_write_locked(vma->vm_mm); }
+static inline bool vma_is_attached(struct vm_area_struct *vma)
+		{ return true; }
 static inline void vma_assert_attached(struct vm_area_struct *vma) {}
 static inline void vma_assert_detached(struct vm_area_struct *vma) {}
 static inline void vma_mark_attached(struct vm_area_struct *vma) {}
@@ -530,6 +532,12 @@ static inline void vma_assert_stabilised
 
 #endif /* CONFIG_PER_VMA_LOCK */
 
+static inline void vma_assert_can_modify(struct vm_area_struct *vma)
+{
+	if (vma_is_attached(vma))
+		vma_assert_write_locked(vma);
+}
+
 static inline void mmap_write_lock(struct mm_struct *mm)
 {
 	__mmap_lock_trace_start_locking(mm, true);
--- a/tools/testing/vma/include/dup.h~mm-vma-introduce-vma_assert_can_modify
+++ a/tools/testing/vma/include/dup.h
@@ -1163,6 +1163,11 @@ static inline struct vm_area_struct *vma
 	return mas_find(&vmi->mas, ULONG_MAX);
 }
 
+static inline bool vma_is_attached(struct vm_area_struct *vma)
+{
+	return refcount_read(&vma->vm_refcnt);
+}
+
 /*
  * WARNING: to avoid racing with vma_mark_attached()/vma_mark_detached(), these
  * assertions should be made either under mmap_write_lock or when the object
@@ -1170,12 +1175,12 @@ static inline struct vm_area_struct *vma
  */
 static inline void vma_assert_attached(struct vm_area_struct *vma)
 {
-	WARN_ON_ONCE(!refcount_read(&vma->vm_refcnt));
+	WARN_ON_ONCE(!vma_is_attached(vma));
 }
 
 static inline void vma_assert_detached(struct vm_area_struct *vma)
 {
-	WARN_ON_ONCE(refcount_read(&vma->vm_refcnt));
+	WARN_ON_ONCE(vma_is_attached(vma));
 }
 
 static inline void vma_assert_write_locked(struct vm_area_struct *);
@@ -1564,3 +1569,9 @@ static inline pgoff_t linear_page_index(
 	pgoff += vma_start_pgoff(vma);
 	return pgoff;
 }
+
+static inline void vma_assert_can_modify(struct vm_area_struct *vma)
+{
+	if (vma_is_attached(vma))
+		vma_assert_write_locked(vma);
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

