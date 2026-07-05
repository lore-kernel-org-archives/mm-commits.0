Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37689354AEB
	for <mm-commits@vger.kernel.org>; Sun,  5 Jul 2026 20:36:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783283794; cv=none; b=Zcc1fxANPQDsyiNAGoCco6jTsrMpblRpZlLLlp/MY3O/+/zwqACDj0IxX+rd+ag9dQfKRtEL+IpFFXKxa3XjYyC1yu+tAwyfU6tMXj1ufUFlw5xJeoo1+d7WYeL1RQTQuXc6oOrUhVzmMD0CRdR/j9wiHHGVWgLcBnIYPdFFvz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783283794; c=relaxed/simple;
	bh=g9vwTcjog/zmfrckbLUaNTFCVFv/weCEEpyUUc1iRl0=;
	h=Date:To:From:Subject:Message-Id; b=rBRR2giSwCX2mPTKNyvoOqBSXO026i088VKgBqdIEjBYwRst5El9tFZ+jdNiyjkwQ4B/+sww5wHOCUHxnmPdyT4ITGESRTTngm27wMR9N4d+//7sdybqzRPrQQwXwIgDN5JBLfhNeo3in6p9NgOk5BeMTfr3TJmrQpbImfFiQuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DmRooMFY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DmRooMFY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EE171F000E9;
	Sun,  5 Jul 2026 20:36:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783283793;
	bh=NRarP+LVGyB1+F24ja26f23ofQA4SroMwKgdmImd3bM=;
	h=Date:To:From:Subject;
	b=DmRooMFYMNBLD6nQDT2azP8TxZMR2zPqZv1nLz9xuIr0YY9fXpzidvwHndOmZ+QB4
	 88VHBVVisQ9ozwj5iu3SYbWSwX8N7YlckBkfLhnhHxdTl/nSSuzokmZC+Wz04hy/0B
	 iz4SUZZoe4EArEgmdxxkN1EFyDNF3sSI7v4h8wZs=
Date: Sun, 05 Jul 2026 13:36:32 -0700
To: mm-commits@vger.kernel.org,baohua@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-vmalloc-align-vm_area-so-vmap-can-batch-mappings.patch removed from -mm tree
Message-Id: <20260705203633.0EE171F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmalloc: align vm_area so vmap() can batch mappings
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-align-vm_area-so-vmap-can-batch-mappings.patch

This patch was dropped because an updated version will be issued

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
Tested-by: Leo Yan <leo.yan@arm.com>
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
@@ -3634,6 +3634,41 @@ out:
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
@@ -3672,7 +3707,7 @@ void *vmap(struct page **pages, unsigned
 		return NULL;
 
 	size = (unsigned long)count << PAGE_SHIFT;
-	area = get_vm_area_caller(size, flags, __builtin_return_address(0));
+	area = vmap_get_aligned_vm_area(size, flags, __builtin_return_address(0));
 	if (!area)
 		return NULL;
 
_

Patches currently in -mm which might be from baohua@kernel.org are


