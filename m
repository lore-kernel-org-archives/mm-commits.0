Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11C72382F26
	for <mm-commits@vger.kernel.org>; Sat,  8 Aug 2026 16:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786208297; cv=none; b=W3FJhPbYBStqKInhUxhtOWjPy+uJvZP1F1Be36yDf+KQ2ydIYeG8Ydd8bU7+C78K9x0M+SOaKe26ZIAnkl/LFM82MfMYG4J9z9PnJef1h74uklAsG83d3xmI9Iwz6nkxlhO1bZpfBF8wykzIJAIPBktx9fDFX3JySjnDkq57VOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786208297; c=relaxed/simple;
	bh=qXMXoAKT3nV4KSi1lY+vnJJNUE8Hmvtgh51+Ew5YVnk=;
	h=Date:To:From:Subject:Message-Id; b=SFgZdwldZ7wCu5YnwN8COrKJUyL/TkTpeGhhAGtBz6RxHXqJJ6/IVP0o0Z+pXhQRISUAJWXElcX3U3UrgiN9fXPubFXntuQOxDWCPl5BOr7B+3QQsiFR06S4jZ6d2b4y0BM4idD6yiBy9atR6yIyowHBD9f5t3zAMUeaKIDLbX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wo6wv50X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wo6wv50X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2B771F00A3A;
	Sat,  8 Aug 2026 16:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786208295;
	bh=LB/0L+ID7+TBV4+++u0ZKAjwzV/oNJZ2KOsBy3EcIbE=;
	h=Date:To:From:Subject;
	b=wo6wv50X8hoVcBoZGcF9zXgBc4GBEHtbnBFTJDK45hRDY9HoAG7RjzZ5XJWpOYAau
	 QTvDyTxL9Ow+QjDozncCRxc3w1gTIEd9LiNNwu6+7eIfB/KKxTH04ea7S9AgFaO0nj
	 1RoBQnFlqVlxjNPe2TQS4TWfxyPIm/N9MLscJyCg=
Date: Sat, 08 Aug 2026 09:58:15 -0700
To: mm-commits@vger.kernel.org,xueyuan.chen21@gmail.com,will@kernel.org,urezki@gmail.com,ryan.roberts@arm.com,rppt@kernel.org,leo.yan@arm.com,jiangwenxiaomi@gmail.com,jiangwen6@xiaomi.com,dev.jain@arm.com,david@kernel.org,catalin.marinas@arm.com,anshuman.khandual@arm.com,ajd@linux.ibm.com,baohua@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-vmalloc-align-vm_area-so-vmap-can-batch-mappings.patch removed from -mm tree
Message-Id: <20260808165815.A2B771F00A3A@smtp.kernel.org>
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
Date: Wed, 15 Jul 2026 20:08:13 +0800

Try to align the vmap virtual address to PMD_SHIFT or a larger PTE mapping
size hinted by the architecture, so contiguous pages can be batch-mapped
when setting PMD or PTE entries.  We do not expect any significant
overhead for this.

Add __get_vm_area_node_aligned_caller() as a wrapper over
__get_vm_area_node() to simplify repeated calls with fixed arguments.

Link: https://lore.kernel.org/20260715120813.3609949-8-jiangwen6@xiaomi.com
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
@@ -3336,6 +3336,14 @@ struct vm_struct *get_vm_area_caller(uns
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
@@ -3662,6 +3670,30 @@ out:
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
@@ -3700,7 +3732,8 @@ void *vmap(struct page **pages, unsigned
 		return NULL;
 
 	size = (unsigned long)count << PAGE_SHIFT;
-	area = get_vm_area_caller(size, flags, __builtin_return_address(0));
+	area = vmap_get_aligned_vm_area(size, flags, prot,
+				__builtin_return_address(0));
 	if (!area)
 		return NULL;
 
_

Patches currently in -mm which might be from baohua@kernel.org are


