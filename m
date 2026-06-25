Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2FAE3043CF
	for <mm-commits@vger.kernel.org>; Thu, 25 Jun 2026 02:57:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782356258; cv=none; b=Cd79nndfJ1DX2b4EaDU4TMM/GHhaICH48/5Zb2nmnkOi3WJH200DpFTL7+UBJY1ODKsfrV3G7+B/+alrVVkAU/kjuFVRyiAhhbYuOrjwfFFhw/0qUxaomGL5kK0+sYkb9Xfn7UlHAFAeXN1igsJcF19piuUWYbfSY9oXernFS7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782356258; c=relaxed/simple;
	bh=B8ShA3NqhGjnbOfVS5zkyJ0AN7NpdieoGHmacHYVtvo=;
	h=Date:To:From:Subject:Message-Id; b=DgGaVWnTZx5irrp+6gvDkwG2qQhKPvMaPdEn9Jx0ghtljg47NXB3yqmKJoyaFposiqX8rIBJRRO+LmrMfArc1VT/DGQ7l0mbGbNm/sgTamkDuil+By4/jxJBUXJ6rhOAXYnAWYZo8IIquKXDEJ23hsnBkw4bSLK8Q5U5B5j6vhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZYfS/mFS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZYfS/mFS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE6361F000E9;
	Thu, 25 Jun 2026 02:57:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782356256;
	bh=sxKqmXsg4VXsJtw4LxNbTts9gqrrzxrs9yX0axMkrFY=;
	h=Date:To:From:Subject;
	b=ZYfS/mFS/5pVnO70o5cUsKgeu7xJU7upPhcaPzGOKxs/aPC13KNbEKUKAGFhWRRBN
	 HZa+oLGByZiv1PuCM/okIf45ExUOmPTFce6CFGD9eBE4gic1Bd3f1hbX5CwqHTj2Bq
	 dxrg9ynqHt5Y5snsX83WvV69NPS3Q3h7Ak6v0aB4=
Date: Wed, 24 Jun 2026 19:57:36 -0700
To: mm-commits@vger.kernel.org,xueyuan.chen21@gmail.com,will@kernel.org,urezki@gmail.com,ryan.roberts@arm.com,rppt@kernel.org,jiangwenxiaomi@gmail.com,jiangwen6@xiaomi.com,dev.jain@arm.com,david@kernel.org,catalin.marinas@arm.com,anshuman.khandual@arm.com,ajd@linux.ibm.com,baohua@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-align-vm_area-so-vmap-can-batch-mappings.patch added to mm-new branch
Message-Id: <20260625025736.AE6361F000E9@smtp.kernel.org>
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
Date: Thu, 18 Jun 2026 16:47:26 +0800

Try to align the vmap virtual address to PMD_SHIFT or a larger PTE mapping
size hinted by the architecture, so contiguous pages can be batch-mapped
when setting PMD or PTE entries.

Add __get_vm_area_node_aligned_caller() as a wrapper over
__get_vm_area_node() to simplify repeated calls with fixed arguments.

Link: https://lore.kernel.org/20260618084726.1070022-7-jiangwen6@xiaomi.com
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
Cc: Andrew Donnellan <ajd@linux.ibm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Uladzislau Rezki <urezki@gmail.com>
Cc: Wen Jiang <jiangwenxiaomi@gmail.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   37 ++++++++++++++++++++++++++++++++++++-
 1 file changed, 36 insertions(+), 1 deletion(-)

--- a/mm/vmalloc.c~mm-vmalloc-align-vm_area-so-vmap-can-batch-mappings
+++ a/mm/vmalloc.c
@@ -3633,6 +3633,41 @@ out:
 	return err;
 }
 
+static struct vm_struct *__get_vm_area_node_aligned_caller(unsigned long size,
+		unsigned long align, unsigned long flags, const void *caller)
+{
+	return __get_vm_area_node(size, align, PAGE_SHIFT, flags,
+			VMALLOC_START, VMALLOC_END,
+			NUMA_NO_NODE, GFP_KERNEL, caller);
+}
+
+static struct vm_struct *vmap_get_aligned_vm_area(unsigned long size,
+		unsigned long flags, const void *caller)
+{
+	struct vm_struct *vm_area;
+	unsigned int shift;
+
+	/* Try PMD alignment for large sizes */
+	if (size >= PMD_SIZE) {
+		vm_area = __get_vm_area_node_aligned_caller(size, PMD_SIZE,
+				flags, caller);
+		if (vm_area)
+			return vm_area;
+	}
+
+	/* Try CONT_PTE alignment */
+	shift = arch_vmap_pte_supported_shift(size);
+	if (shift > PAGE_SHIFT) {
+		vm_area = __get_vm_area_node_aligned_caller(size, 1UL << shift,
+				flags, caller);
+		if (vm_area)
+			return vm_area;
+	}
+
+	/* Fall back to page alignment */
+	return __get_vm_area_node_aligned_caller(size, PAGE_SIZE, flags, caller);
+}
+
 /**
  * vmap - map an array of pages into virtually contiguous space
  * @pages: array of page pointers
@@ -3671,7 +3706,7 @@ void *vmap(struct page **pages, unsigned
 		return NULL;
 
 	size = (unsigned long)count << PAGE_SHIFT;
-	area = get_vm_area_caller(size, flags, __builtin_return_address(0));
+	area = vmap_get_aligned_vm_area(size, flags, __builtin_return_address(0));
 	if (!area)
 		return NULL;
 
_

Patches currently in -mm which might be from baohua@kernel.org are

arm64-hugetlb-extend-batching-of-multiple-cont_pte-in-a-single-pte-setup.patch
arm64-vmalloc-allow-arch_vmap_pte_range_map_size-to-batch-multiple-cont_pte.patch
mm-vmalloc-extend-page-table-walk-to-support-larger-page_shift-sizes-and-eliminate-page-table-rewalk.patch
mm-vmalloc-map-contiguous-pages-in-batches-for-vmap-if-possible.patch
mm-vmalloc-align-vm_area-so-vmap-can-batch-mappings.patch

