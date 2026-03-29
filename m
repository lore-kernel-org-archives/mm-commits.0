Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6D66248886
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:40:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744846; cv=none; b=UlbkS292quduSkz099Km6T4HoDur938AB5r4hAIu0RHhEG44nlaxgb43OBHix2csVkFakX2g7V5fZuloZq5UjRPFidR3YfcZV3Di53b4ufz8MmGUlgr7lNVU+901tMeJs3/+8pQM0rQmHE3YW7YVD08qDtZO2nyZYGIlXYjedNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744846; c=relaxed/simple;
	bh=ggVyEz5MWEALBvoIZtFkgjcaLZDfv/6xiMK22GDw5Yg=;
	h=Date:To:From:Subject:Message-Id; b=iRx2+qHJzwUIm8rMutqg2DYmTdlEgdXnM5ji5h0a2OYvB295vBOUvK03GpD9vFzIAif/hfPbieTn+DIZpmEz3ZXItVg+VXvmgkYZPn8ro+0JkE2mNMFftoifmGPUl1mRaGhGucO8AV7yW4omfhztbig3k/a99zdko9uEEcjq21Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eT8EdiRS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eT8EdiRS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DD33C4CEF7;
	Sun, 29 Mar 2026 00:40:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744846;
	bh=ggVyEz5MWEALBvoIZtFkgjcaLZDfv/6xiMK22GDw5Yg=;
	h=Date:To:From:Subject:From;
	b=eT8EdiRSwsbXfNl5PilMmZuxH4C6btIYgs7PfLypmxO9uAc/DAPUb7gFbziji7yKf
	 P1I08adc+H7XCWCuIwyVQQEmnluJ1XgLRAosPUgba+xhggNNMF5+UDiuV9dms/CKGX
	 PPTM2ozr50CPRwNPqZMam/wVa9XgtA3a1eUJLcUg=
Date: Sat, 28 Mar 2026 17:40:46 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,rppt@kernel.org,pfalcato@suse.de,pbonzini@redhat.com,osalvador@suse.de,npiggin@gmail.com,muchun.song@linux.dev,mpe@ellerman.id.au,mhocko@suse.com,maddy@linux.ibm.com,ljs@kernel.org,liam.howlett@oracle.com,jannh@google.com,dan.j.williams@intel.com,chleroy@kernel.org,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-move-vma_mmu_pagesize-from-hugetlb-to-vmac.patch removed from -mm tree
Message-Id: <20260329004046.9DD33C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: move vma_mmu_pagesize() from hugetlb to vma.c
has been removed from the -mm tree.  Its filename was
     mm-move-vma_mmu_pagesize-from-hugetlb-to-vmac.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -1175,11 +1173,6 @@ static inline unsigned long huge_page_ma
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
@@ -1371,6 +1371,8 @@ static inline unsigned long vma_kernel_p
 	return PAGE_SIZE;
 }
 
+unsigned long vma_mmu_pagesize(struct vm_area_struct *vma);
+
 static inline
 struct vm_area_struct *vma_find(struct vma_iterator *vmi, unsigned long max)
 {
--- a/mm/hugetlb.c~mm-move-vma_mmu_pagesize-from-hugetlb-to-vmac
+++ a/mm/hugetlb.c
@@ -1018,17 +1018,6 @@ static pgoff_t vma_hugecache_offset(stru
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


