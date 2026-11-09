Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794207857;
	b=uCECLCWY2eZLhHgt57gDj0DLfJDqdQuiNQfzptB8XmT3+o8nRPQP3+9FsU0+BbglHCYn
	 qoJpXgcWVmm9bloXXsoBCJDqsZYCiLj5HoIH1GhSgjHJiHVOk81sEwAqwireUlxgj3SUh
	 4uJuQ6sKfUDQWXDiFlmpbWwftxlHXGaZKfSikSIrXZVq19wGLaO+HJbCNrMPQjdX/rro4
	 pS6mY3zNQJ2XuG1M+RAo6285aJyPABx6B8hOD1n+E9iK4ZSO00+HztF/WFsOAgcw93jwf
	 iJOn9IA8kFCw5Ye/x3o437WRcZ06I8MSFsTBIzHnMS66xMsfqbqiNVt4B0ZuC1A6TTQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794207857;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=nSFWaAlE8SKb5FosouPDIMVFxAmsLnJPGScxTMwTNMM=;
	b=z9gNn89w/WO5Nmp3+o/wuQ5LsR1wKfxDYo4zgwLPXst8LI3ue2+SNI76xLS3voXWP/KI
	 tMvOjKZJcdBCx0q2+37i6j10DZwF0Wru7L5+9bFoqm1y/MNBmUGRSFvmrP0BbvSI4tRSF
	 OEG9rf3NuzJJKn1qD/8Jt0rr0bvDd/K0/mNz9yhZ82Un7d/VuQM7Rz00vGMyOncv60ptV
	 R1lwNhabTKL2J+6RiWGOSsTNv1MumdHj5c1Tw0MM3J72QGjanWJ/Vl+cc4RvnRXydnejr
	 KcJ45ztJPmNnKwlVTw5NzqvZC8cOnYtNnFUqPpaI9S411kkbbClDcjhX258+hqXaSnw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=yADR6j6S;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16573606A31C
	for <mm-commits@vger.kernel.org>; Mon,  9 Nov 2026 07:04:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=yADR6j6S
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7F4C1F0089F;
	Mon,  9 Nov 2026 07:04:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794207856;
	bh=nSFWaAlE8SKb5FosouPDIMVFxAmsLnJPGScxTMwTNMM=;
	h=Date:To:From:Subject;
	b=yADR6j6SdN/OtkCSVdIqqY4tzJh2rJ9vYLVrlHoB0H6GLm4OWEYBx4QKPgFrccBPE
	 ZBeg+c0DvNZWsfpKHQ9vLzYJMbZmk/xkFKOVQs38MBoSzi8NcCqgF+gBObCXt5yfGL
	 H5QwfnqsButkr3WwQrki3SMbHcHrpFjq+47V5/hY=
Date: Sun, 08 Nov 2026 23:04:16 -0800
To: mm-commits@vger.kernel.org,xueyuan.chen21@gmail.com,will@kernel.org,
	urezki@gmail.com,ryan.roberts@arm.com,rppt@kernel.org,npiggin@gmail.com,
	mpe@ellerman.id.au,maddy@linux.ibm.com,leo.yan@arm.com,
	jiangwenxiaomi@gmail.com,jiangwen6@xiaomi.com,dev.jain@arm.com,
	david@kernel.org,chleroy@kernel.org,catalin.marinas@arm.com,
	anshuman.khandual@arm.com,andrew+kernel@donnellan.id.au,baohua@kernel.org,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-align-vm_area-so-vmap-can-batch-mappings.patch added to mm-new branch
Message-Id: <20261109070416.D7F4C1F0089F@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


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
Date: Sat, 07 Nov 2026 21:49:53 +0800

Try to align the vmap virtual address to PMD_SHIFT or a
larger PTE mapping size hinted by the architecture, so
contiguous pages can be batch-mapped when setting PMD or
PTE entries. We do not expect any significant overhead for
this.

Add __get_vm_area_node_aligned_caller() as a wrapper over
__get_vm_area_node() to simplify repeated calls with fixed
arguments.

Link: https://lore.kernel.org/20261107134953.748622-11-jiangwenxiaomi@gmail.com
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
Tested-by: Leo Yan <leo.yan@arm.com>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Christophe Leroy <chleroy@kernel.org>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Andrew Donnellan <andrew+kernel@donnellan.id.au>
Cc: Wen Jiang <jiangwenxiaomi@gmail.com>
---

 mm/vmalloc.c |   36 ++++++++++++++++++++++++++++++++++--
 1 file changed, 34 insertions(+), 2 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-align-vm_area-so-vmap-can-batch-mappings
+++ a/mm/vmalloc.c
@@ -3378,6 +3378,14 @@ struct vm_struct *get_vm_area_caller(uns
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
@@ -3709,6 +3717,30 @@ out:
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
@@ -3747,8 +3779,8 @@ void *vmap(struct page **pages, unsigned
 		return NULL;
 
 	size = (unsigned long)count << PAGE_SHIFT;
-	area = get_vm_area_caller(size, flags | VM_UNINITIALIZED,
-				  __builtin_return_address(0));
+	area = vmap_get_aligned_vm_area(size, flags | VM_UNINITIALIZED, prot,
+					__builtin_return_address(0));
 	if (!area)
 		return NULL;
 
_

Patches currently in -mm which might be from baohua@kernel.org are

arm64-vmalloc-allow-arch_vmap_pte_range_map_size-to-batch-multiple-cont_pte.patch
mm-vmalloc-extend-page-table-walk-to-support-larger-page_shift-sizes-and-eliminate-page-table-rewalk.patch
mm-vmalloc-map-contiguous-pages-in-batches-for-vmap-if-possible.patch
mm-vmalloc-align-vm_area-so-vmap-can-batch-mappings.patch

