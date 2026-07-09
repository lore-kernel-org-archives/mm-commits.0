Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2484F377009
	for <mm-commits@vger.kernel.org>; Thu,  9 Jul 2026 23:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783638331; cv=none; b=UeMkSkVS6kZshLWziwNzrMETYY4OzwxYRoGBxM9qPmywvd61kcnwg8RFM0qR0ICR6geyE7cfdJ3gcJFyL9qgl/wzosVV+4I3mmD/tN0Yp3MY3qC0sFQWCECdiJj1IqVnDK7R+pXVOUfPtM0LBpzTVFtfr5HL6AQE1SxaRP3bQwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783638331; c=relaxed/simple;
	bh=7IfXAZcToCy/+wzL0TLP/IUE9nNwQxWlZXVfKrALdSY=;
	h=Date:To:From:Subject:Message-Id; b=gR5Lkul9R8dn+v+qXVUVyKbn4vJSnmSwLKeYNfjYOiyC0iEj8RkKMVZi9ugTHg1q8mWGHi3dnOuolq6VLr5doq4qlb+fsOmf+QlGxn3eURYgShspyE27COPsG6tMaAtycKCMyuWHiSc1gv4+LYps0Pc2wbtU7oeqhHNPnloA5HY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WrfCrEmn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WrfCrEmn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2C451F000E9;
	Thu,  9 Jul 2026 23:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783638329;
	bh=4fYX9GjRsUnZCrWa/0c7D1887fQhUD+zEN1Eu0TFnTY=;
	h=Date:To:From:Subject;
	b=WrfCrEmnK7DlT4L4zLB3fNEEsJwaNbtBkEpvwws+4mQze39PMXiGnYtYowiBwWJBN
	 xfHlUXmOon6auqExXZ7hlLVy4leABzS5q+7V8k8zXtMSPvvpln/EqN3tLgPLrsgzXP
	 1jVQbmBJlgGV1ya+r6Rhhk5WR3X0iPWm0Q7/s4m4=
Date: Thu, 09 Jul 2026 16:05:29 -0700
To: mm-commits@vger.kernel.org,xueyuan.chen21@gmail.com,will@kernel.org,urezki@gmail.com,ryan.roberts@arm.com,rppt@kernel.org,leo.yan@arm.com,jiangwenxiaomi@gmail.com,jiangwen6@xiaomi.com,dev.jain@arm.com,david@kernel.org,catalin.marinas@arm.com,anshuman.khandual@arm.com,ajd@linux.ibm.com,baohua@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-align-vm_area-so-vmap-can-batch-mappings.patch added to mm-new branch
Message-Id: <20260709230529.C2C451F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmalloc: align vm_area so vmap() can batch mappings
has been added to the -mm mm-new branch.  Its filename is
     mm-vmalloc-align-vm_area-so-vmap-can-batch-mappings.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-align-vm_area-so-vmap-can-batch-mappings.patch

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
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
Subject: mm/vmalloc: align vm_area so vmap() can batch mappings
Date: Thu, 9 Jul 2026 15:38:23 +0800

Try to align the vmap virtual address to PMD_SHIFT or a larger PTE mapping
size hinted by the architecture, so contiguous pages can be batch-mapped
when setting PMD or PTE entries.  We do not expect any significant
overhead for this.

Add __get_vm_area_node_aligned_caller() as a wrapper over
__get_vm_area_node() to simplify repeated calls with fixed arguments.

Link: https://lore.kernel.org/20260709073823.6643-7-jiangwen6@xiaomi.com
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
Tested-by: Leo Yan <leo.yan@arm.com>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Andrew Donnellan <ajd@linux.ibm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Wen Jiang <jiangwenxiaomi@gmail.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   35 ++++++++++++++++++++++++++++++++++-
 1 file changed, 34 insertions(+), 1 deletion(-)

--- a/mm/vmalloc.c~mm-vmalloc-align-vm_area-so-vmap-can-batch-mappings
+++ a/mm/vmalloc.c
@@ -3309,6 +3309,14 @@ struct vm_struct *get_vm_area_caller(uns
 				  NUMA_NO_NODE, GFP_KERNEL, caller);
 }
 
+static struct vm_struct *__get_vm_area_node_aligned_caller(unsigned long size,
+		unsigned long align, unsigned long flags, const void *caller)
+{
+	return __get_vm_area_node(size, align, PAGE_SHIFT, flags,
+				  VMALLOC_START, VMALLOC_END,
+				  NUMA_NO_NODE, GFP_KERNEL, caller);
+}
+
 /**
  * find_vm_area - find a continuous kernel virtual area
  * @addr:	  base address
@@ -3632,6 +3640,30 @@ out:
 	return err;
 }
 
+static struct vm_struct *vmap_get_aligned_vm_area(unsigned long size,
+		unsigned long flags, pgprot_t prot, const void *caller)
+{
+	struct vm_struct *vm_area;
+	unsigned int shift;
+
+	if (arch_vmap_pmd_supported(prot) && size >= PMD_SIZE) {
+		vm_area = __get_vm_area_node_aligned_caller(size, PMD_SIZE,
+				flags, caller);
+		if (vm_area)
+			return vm_area;
+	}
+
+	shift = arch_vmap_pte_supported_shift(size);
+	if (shift > PAGE_SHIFT) {
+		vm_area = __get_vm_area_node_aligned_caller(size, 1UL << shift,
+				flags, caller);
+		if (vm_area)
+			return vm_area;
+	}
+
+	return __get_vm_area_node_aligned_caller(size, PAGE_SIZE, flags, caller);
+}
+
 /**
  * vmap - map an array of pages into virtually contiguous space
  * @pages: array of page pointers
@@ -3670,7 +3702,8 @@ void *vmap(struct page **pages, unsigned
 		return NULL;
 
 	size = (unsigned long)count << PAGE_SHIFT;
-	area = get_vm_area_caller(size, flags, __builtin_return_address(0));
+	area = vmap_get_aligned_vm_area(size, flags, prot,
+				__builtin_return_address(0));
 	if (!area)
 		return NULL;
 
_

Patches currently in -mm which might be from baohua@kernel.org are

mm-avoid-unnecessary-lru-drain-for-wp_can_reuse_anon_folio.patch
mm-avoid-unnecessary-lru-drain-for-wp_can_reuse_anon_folio-fix.patch
mm-drop-stale-folio_ref_count==1-check-in-do_swap_page-reuse-logic.patch
mm-entirely-remove-lru_add_drain-in-do_swap_page.patch
mm-clarify-the-folio_free_swap-for-do_swap_page.patch
arm64-hugetlb-extend-batching-of-multiple-cont_pte-in-a-single-pte-setup.patch
arm64-vmalloc-allow-arch_vmap_pte_range_map_size-to-batch-multiple-cont_pte.patch
mm-vmalloc-extend-page-table-walk-to-support-larger-page_shift-sizes-and-eliminate-page-table-rewalk.patch
mm-vmalloc-map-contiguous-pages-in-batches-for-vmap-if-possible.patch
mm-vmalloc-align-vm_area-so-vmap-can-batch-mappings.patch

