Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51FD8382F0A
	for <mm-commits@vger.kernel.org>; Wed, 15 Jul 2026 18:33:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784140405; cv=none; b=M+oupYAqSzF16fL49sWby05uSX87XNQa4cbT/ug/cSu1cWMKnPGwTYjPdpxKL82vri//oOyQxl9Wsjde7Q8N++3dCKkdIq43nFObTeJ3SQG9jGJ2gEJPFOS+ouu2tRqAgZDvlcsI1MwAChfEX7QiZczWM+EQgJYF+hzbdKyUZcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784140405; c=relaxed/simple;
	bh=AhTE5HtqfGS3RP0bCtZIqLPGLkCVY9AXGH4c6eoHuhk=;
	h=Date:To:From:Subject:Message-Id; b=afPlHQ/gU6zhm/+GcKQQ8A37DDnrx+mMaWLNn9PeNCnmyD1QBvVroylk3ApsL/rcLRGVjeq9lVQ2tEQLYxu2+JLIlsZ5BnDkLD5KwyehXa39lptpD3+CYqifvxWECkb8LFl7lWJw2lIuSLf3jCqc64QM42sBqMan53jIt8kyCKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=J796GYaG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="J796GYaG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E59BE1F00A3F;
	Wed, 15 Jul 2026 18:32:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784140380;
	bh=B1xPQ3oW1GxTzHt4xK6gx/TI/l5BKP/81GcTETyE3xc=;
	h=Date:To:From:Subject;
	b=J796GYaGnFxfdb7L5ade9FbkpF/P+y94bM5Y3/w9kdVBmDRbvPgj2RfJxegloCSht
	 /ogho583Ye5wsxMKtj1Dmiu9wAaQWlzqIejMCKKQms2aLUwBlkUoT4A0SKXVDCKcXc
	 xlGy5ppMwaIKy4grTG7Lu5pHh5sCj2e686x9P4Sc=
Date: Wed, 15 Jul 2026 11:32:59 -0700
To: mm-commits@vger.kernel.org,baohua@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-vmalloc-align-vm_area-so-vmap-can-batch-mappings.patch removed from -mm tree
Message-Id: <20260715183259.E59BE1F00A3F@smtp.kernel.org>
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
Reviewed-by: Dev Jain <dev.jain@arm.com>
Cc: Andrew Donnellan <ajd@linux.ibm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@kernel.org>
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
@@ -3332,6 +3332,14 @@ struct vm_struct *get_vm_area_caller(uns
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
@@ -3655,6 +3663,30 @@ out:
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
@@ -3693,7 +3725,8 @@ void *vmap(struct page **pages, unsigned
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

