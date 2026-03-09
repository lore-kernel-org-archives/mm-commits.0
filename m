Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 667F02E0413
	for <mm-commits@vger.kernel.org>; Mon,  9 Mar 2026 17:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773078595; cv=none; b=dJKodbWHNW1wSK9fVPLk6fgMNCIXDX5dVimNxX4BEpgjzy/A3OnUjZ4EsnwLoznFErL9x9Yl0sMHAngCEJfxKUF9sJYYKheFkdoxmy4OuSjatMWOABxdjMCDPoiUr3Gkp2FkfyFahWNm7XDGIZQEqbXxbs+VDYxF1IQfJXWe9o4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773078595; c=relaxed/simple;
	bh=WN69H9E6OXp6sVPOrzhie01/eVvp897l+HKbzZVEQfg=;
	h=Date:To:From:Subject:Message-Id; b=o+gDmbzKZw49o07EyGz+rY6GjJgqQkw6qjTHeV9qdWcdZOaFAAbuJlMm2zGPnHPlP255aPNL8DJgIQ5yxuokPx7CP4gx8MphgZhkQORq1bzyeh3EBK12Wka2Orgtd9pAmQbO+SzkFYGDuX8S7byth9mps/8O84ob//kAAjX2+i8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yMqYKCLn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yMqYKCLn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5B3BC4CEF7;
	Mon,  9 Mar 2026 17:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773078594;
	bh=WN69H9E6OXp6sVPOrzhie01/eVvp897l+HKbzZVEQfg=;
	h=Date:To:From:Subject:From;
	b=yMqYKCLnLUcARBIMFCbdRAFVDUCsbKIyVzfJU4kIf4CW5pKqi5x6ogXm6B/nddQIz
	 m47StKWmTH1COWlin1NhLgkHKxEoLP0jQvz6BXGLoZaMAOsxjNtMYZ/lQ1YhOr4rOn
	 SKcjPFVF7OCe5gzghTtELqGfB/YP2iyodmxQiP9M=
Date: Mon, 09 Mar 2026 10:49:54 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,rppt@kernel.org,pfalcato@suse.de,pbonzini@redhat.com,osalvador@suse.de,npiggin@gmail.com,muchun.song@linux.dev,mpe@ellerman.id.au,mhocko@suse.com,maddy@linux.ibm.com,ljs@kernel.org,liam.howlett@oracle.com,jannh@google.com,dan.j.williams@intel.com,chleroy@kernel.org,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-move-vma_kernel_pagesize-from-hugetlb-to-mmh.patch added to mm-new branch
Message-Id: <20260309174954.D5B3BC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: move vma_kernel_pagesize() from hugetlb to mm.h
has been added to the -mm mm-new branch.  Its filename is
     mm-move-vma_kernel_pagesize-from-hugetlb-to-mmh.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-move-vma_kernel_pagesize-from-hugetlb-to-mmh.patch

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
Subject: mm: move vma_kernel_pagesize() from hugetlb to mm.h
Date: Mon, 9 Mar 2026 16:18:58 +0100

Patch series "mm: move vma_(kernel|mmu)_pagesize() out of hugetlb.c", v2.

Looking into vma_(kernel|mmu)_pagesize(), I realized that there is one
scenario where DAX would not do the right thing when the kernel is not
compiled with hugetlb support.

Without hugetlb support, vma_(kernel|mmu)_pagesize() will always return
PAGE_SIZE instead of using the ->pagesize() result provided by dax-device
code.

Fix that by moving vma_kernel_pagesize() to core MM code, where it
belongs.  I don't think this is stable material, but am not 100% sure.

Also, move vma_mmu_pagesize() while at it.  Remove the unnecessary
hugetlb.h inclusion from KVM code.


This patch (of 4):

In the past, only hugetlb had special "vma_kernel_pagesize()"
requirements, so it provided its own implementation.

In commit 05ea88608d4e ("mm, hugetlbfs: introduce ->pagesize() to
vm_operations_struct") we generalized that approach by providing a
vm_ops->pagesize() callback to be used by device-dax.

Once device-dax started using that callback in commit c1d53b92b95c
("device-dax: implement ->pagesize() for smaps to report MMUPageSize") it
was missed that CONFIG_DEV_DAX does not depend on hugetlb support.

So building a kernel with CONFIG_DEV_DAX but without CONFIG_HUGETLBFS
would not pick up that value.

Fix it by moving vma_kernel_pagesize() to mm.h, providing only a single
implementation.  While at it, improve the kerneldoc a bit.

Ideally, we'd move vma_mmu_pagesize() as well to the header.  However, its
__weak symbol might be overwritten by a PPC variant in hugetlb code.  So
let's leave it in there for now, as it really only matters for some
hugetlb oddities.

This was found by code inspection.

Link: https://lkml.kernel.org/r/20260309151901.123947-1-david@kernel.org
Link: https://lkml.kernel.org/r/20260309151901.123947-2-david@kernel.org
Fixes: c1d53b92b95c ("device-dax: implement ->pagesize() for smaps to report MMUPageSize")
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
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

 include/linux/hugetlb.h |    7 -------
 include/linux/mm.h      |   20 ++++++++++++++++++++
 mm/hugetlb.c            |   17 -----------------
 3 files changed, 20 insertions(+), 24 deletions(-)

--- a/include/linux/hugetlb.h~mm-move-vma_kernel_pagesize-from-hugetlb-to-mmh
+++ a/include/linux/hugetlb.h
@@ -777,8 +777,6 @@ static inline unsigned long huge_page_si
 	return (unsigned long)PAGE_SIZE << h->order;
 }
 
-extern unsigned long vma_kernel_pagesize(struct vm_area_struct *vma);
-
 extern unsigned long vma_mmu_pagesize(struct vm_area_struct *vma);
 
 static inline unsigned long huge_page_mask(struct hstate *h)
@@ -1188,11 +1186,6 @@ static inline unsigned long huge_page_ma
 	return PAGE_MASK;
 }
 
-static inline unsigned long vma_kernel_pagesize(struct vm_area_struct *vma)
-{
-	return PAGE_SIZE;
-}
-
 static inline unsigned long vma_mmu_pagesize(struct vm_area_struct *vma)
 {
 	return PAGE_SIZE;
--- a/include/linux/mm.h~mm-move-vma_kernel_pagesize-from-hugetlb-to-mmh
+++ a/include/linux/mm.h
@@ -1359,6 +1359,26 @@ static inline bool vma_is_shared_maywrit
 	return is_shared_maywrite(&vma->flags);
 }
 
+/**
+ * vma_kernel_pagesize - Default page size granularity for this VMA.
+ * @vma: The user mapping.
+ *
+ * The kernel page size specifies in which granularity VMA modifications
+ * can be performed. Folios in this VMA will be aligned to, and at least
+ * the size of the number of bytes returned by this function.
+ *
+ * The default kernel page size is not affected by Transparent Huge Pages
+ * being in effect.
+ *
+ * Return: The default page size granularity for this VMA.
+ */
+static inline unsigned long vma_kernel_pagesize(struct vm_area_struct *vma)
+{
+	if (unlikely(vma->vm_ops && vma->vm_ops->pagesize))
+		return vma->vm_ops->pagesize(vma);
+	return PAGE_SIZE;
+}
+
 static inline
 struct vm_area_struct *vma_find(struct vma_iterator *vmi, unsigned long max)
 {
--- a/mm/hugetlb.c~mm-move-vma_kernel_pagesize-from-hugetlb-to-mmh
+++ a/mm/hugetlb.c
@@ -1006,23 +1006,6 @@ static long region_count(struct resv_map
 	return chg;
 }
 
-/**
- * vma_kernel_pagesize - Page size granularity for this VMA.
- * @vma: The user mapping.
- *
- * Folios in this VMA will be aligned to, and at least the size of the
- * number of bytes returned by this function.
- *
- * Return: The default size of the folios allocated when backing a VMA.
- */
-unsigned long vma_kernel_pagesize(struct vm_area_struct *vma)
-{
-	if (vma->vm_ops && vma->vm_ops->pagesize)
-		return vma->vm_ops->pagesize(vma);
-	return PAGE_SIZE;
-}
-EXPORT_SYMBOL_GPL(vma_kernel_pagesize);
-
 /*
  * Return the page size being used by the MMU to back a VMA. In the majority
  * of cases, the page size used by the kernel matches the MMU size. On
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

