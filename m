Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94BBC28DB46
	for <mm-commits@vger.kernel.org>; Mon,  9 Mar 2026 17:49:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773078598; cv=none; b=nzB4E8dxMMj3i8uPQHNXcjrKm2iUooY1ViqE3VKaGQLQj4U/5HKIie0UW25hIDFKQRPDrP7hf0rTx38TFpH3XQURaGU8RYD1uJIS1FYzfMMZwqShm74E/v8KhohllyINmKu/2CyDlcmrxFAbTO6uj0ub5dISlW54jgTyU9RgKlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773078598; c=relaxed/simple;
	bh=B8iprO8Kg54D29vTYwoSaLJMdTLcbc8UaU/O1HUi8oU=;
	h=Date:To:From:Subject:Message-Id; b=i9nUFXTXinlSHduwozqNqCFPcUyZAB3stoyNtaEnA71+PfxgVenGL6Qfm4hi/ErLmOZYwiRMvxRO9KUUWRAkY6FxgYAX40mRtCYPAfgivGXnEjWojMQEgxzsbnKLVHHrbLSSiGWEACFZbKThUd7v2+ohl6ASgkLpF48/6aWBKQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uyxuc1GV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uyxuc1GV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E4FEC4CEF7;
	Mon,  9 Mar 2026 17:49:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773078598;
	bh=B8iprO8Kg54D29vTYwoSaLJMdTLcbc8UaU/O1HUi8oU=;
	h=Date:To:From:Subject:From;
	b=uyxuc1GVHxPr3MBVo7wr1lHioiOGBGCQXSR46DjR3SbYF+qlFJ/VytY7HoR6U4Ib0
	 Kpqv6XZh0guwzGK0rIW5om6TLGufsWtoMJ3d+VCF1Gxij2BJLeoG3/gzBdzEGZVeJk
	 ICOwEgtcSTOPgmSlhvSfzEkg3xNalsJxW/2+lRV0=
Date: Mon, 09 Mar 2026 10:49:57 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,rppt@kernel.org,pfalcato@suse.de,pbonzini@redhat.com,osalvador@suse.de,npiggin@gmail.com,muchun.song@linux.dev,mpe@ellerman.id.au,mhocko@suse.com,maddy@linux.ibm.com,ljs@kernel.org,liam.howlett@oracle.com,jannh@google.com,dan.j.williams@intel.com,chleroy@kernel.org,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-move-vma_mmu_pagesize-from-hugetlb-to-vmac.patch added to mm-new branch
Message-Id: <20260309174958.0E4FEC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: move vma_mmu_pagesize() from hugetlb to vma.c
has been added to the -mm mm-new branch.  Its filename is
     mm-move-vma_mmu_pagesize-from-hugetlb-to-vmac.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-move-vma_mmu_pagesize-from-hugetlb-to-vmac.patch

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
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: mm: move vma_mmu_pagesize() from hugetlb to vma.c
Date: Mon, 9 Mar 2026 16:18:59 +0100

vma_mmu_pagesize() is also queried on non-hugetlb VMAs and does not really
belong into hugetlb.c.

PPC64 provides a custom overwrite with CONFIG_HUGETLB_PAGE, see
arch/powerpc/mm/book3s64/slice.c, so we cannot easily make this a static
inline function.

So let's move it to vma.c and add some proper kerneldoc.

To make vma tests happy, add a simple vma_kernel_pagesize() stub in
tools/testing/vma/include/custom.h.

Link: https://lkml.kernel.org/r/20260309151901.123947-3-david@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h            |    7 -------
 include/linux/mm.h                 |    2 ++
 mm/hugetlb.c                       |   11 -----------
 mm/vma.c                           |   21 +++++++++++++++++++++
 tools/testing/vma/include/custom.h |    5 +++++
 5 files changed, 28 insertions(+), 18 deletions(-)

--- a/include/linux/hugetlb.h~mm-move-vma_mmu_pagesize-from-hugetlb-to-vmac
+++ a/include/linux/hugetlb.h
@@ -777,8 +777,6 @@ static inline unsigned long huge_page_si
 	return (unsigned long)PAGE_SIZE << h->order;
 }
 
-extern unsigned long vma_mmu_pagesize(struct vm_area_struct *vma);
-
 static inline unsigned long huge_page_mask(struct hstate *h)
 {
 	return h->mask;
@@ -1186,11 +1184,6 @@ static inline unsigned long huge_page_ma
 	return PAGE_MASK;
 }
 
-static inline unsigned long vma_mmu_pagesize(struct vm_area_struct *vma)
-{
-	return PAGE_SIZE;
-}
-
 static inline unsigned int huge_page_order(struct hstate *h)
 {
 	return 0;
--- a/include/linux/mm.h~mm-move-vma_mmu_pagesize-from-hugetlb-to-vmac
+++ a/include/linux/mm.h
@@ -1379,6 +1379,8 @@ static inline unsigned long vma_kernel_p
 	return PAGE_SIZE;
 }
 
+unsigned long vma_mmu_pagesize(struct vm_area_struct *vma);
+
 static inline
 struct vm_area_struct *vma_find(struct vma_iterator *vmi, unsigned long max)
 {
--- a/mm/hugetlb.c~mm-move-vma_mmu_pagesize-from-hugetlb-to-vmac
+++ a/mm/hugetlb.c
@@ -1007,17 +1007,6 @@ static long region_count(struct resv_map
 }
 
 /*
- * Return the page size being used by the MMU to back a VMA. In the majority
- * of cases, the page size used by the kernel matches the MMU size. On
- * architectures where it differs, an architecture-specific 'strong'
- * version of this symbol is required.
- */
-__weak unsigned long vma_mmu_pagesize(struct vm_area_struct *vma)
-{
-	return vma_kernel_pagesize(vma);
-}
-
-/*
  * Flags for MAP_PRIVATE reservations.  These are stored in the bottom
  * bits of the reservation map pointer, which are always clear due to
  * alignment.
--- a/mm/vma.c~mm-move-vma_mmu_pagesize-from-hugetlb-to-vmac
+++ a/mm/vma.c
@@ -3300,3 +3300,24 @@ int insert_vm_struct(struct mm_struct *m
 
 	return 0;
 }
+
+/**
+ * vma_mmu_pagesize - Default MMU page size granularity for this VMA.
+ * @vma: The user mapping.
+ *
+ * In the common case, the default page size used by the MMU matches the
+ * default page size used by the kernel (see vma_kernel_pagesize()). On
+ * architectures where it differs, an architecture-specific 'strong' version
+ * of this symbol is required.
+ *
+ * The default MMU page size is not affected by Transparent Huge Pages
+ * being in effect, or any usage of larger MMU page sizes (either through
+ * architectural huge-page mappings or other explicit/implicit coalescing of
+ * virtual ranges performed by the MMU).
+ *
+ * Return: The default MMU page size granularity for this VMA.
+ */
+__weak unsigned long vma_mmu_pagesize(struct vm_area_struct *vma)
+{
+	return vma_kernel_pagesize(vma);
+}
--- a/tools/testing/vma/include/custom.h~mm-move-vma_mmu_pagesize-from-hugetlb-to-vmac
+++ a/tools/testing/vma/include/custom.h
@@ -118,3 +118,8 @@ static __always_inline vma_flags_t __mk_
 			vma_flags_set_flag(&flags, bits[i]);
 	return flags;
 }
+
+static inline unsigned long vma_kernel_pagesize(struct vm_area_struct *vma)
+{
+	return PAGE_SIZE;
+}
_

Patches currently in -mm which might be from david@kernel.org are

mm-centralizefix-comments-about-compound_mapcount-in-new-sync_with_folio_pmd_zap.patch
mm-pagewalk-drop-fw_migration.patch
mm-madvise-drop-range-checks-in-madvise_free_single_vma.patch
mm-memory-remove-zap_details-parameter-from-zap_page_range_single.patch
mm-memory-remove-zap_details-parameter-from-zap_page_range_single-fix.patch
mm-memory-inline-unmap_mapping_range_vma-into-unmap_mapping_range_tree.patch
mm-memory-simplify-calculation-in-unmap_mapping_range_tree.patch
mm-oom_kill-use-mmu_notify_clear-in-__oom_reap_task_mm.patch
mm-oom_kill-factor-out-zapping-of-vma-into-zap_vma_for_reaping.patch
mm-memory-rename-unmap_single_vma-to-__zap_vma_range.patch
mm-memory-move-adjusting-of-address-range-to-unmap_vmas.patch
mm-memory-convert-details-even_cows-into-details-skip_cows.patch
mm-memory-use-__zap_vma_range-in-zap_vma_for_reaping.patch
mm-memory-inline-unmap_page_range-into-__zap_vma_range.patch
mm-rename-zap_vma_pages-to-zap_vma.patch
mm-rename-zap_page_range_single_batched-to-zap_vma_range_batched.patch
mm-rename-zap_page_range_single-to-zap_vma_range.patch
mm-rename-zap_vma_ptes-to-zap_special_vma_range.patch
mm-memory-support-vm_mixedmap-in-zap_special_vma_range.patch
kasan-docs-slub-is-the-only-remaining-slab-implementation.patch
mm-move-vma_kernel_pagesize-from-hugetlb-to-mmh.patch
mm-move-vma_mmu_pagesize-from-hugetlb-to-vmac.patch
kvm-remove-hugetlbh-inclusion.patch
kvm-ppc-remove-hugetlbh-inclusion.patch

