Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1677762F1
	for <mm-commits@vger.kernel.org>; Fri, 22 Mar 2024 18:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711133935; cv=none; b=Znb6Iu9Py/EM7uQ3aZQ9Wn34AWn3EtxMt6iIJ9wfYXDmFXP2jzDuJRJkweqAYJf9D8CgbP5m7YdmbbaSpLKff6OiW1N0fLC9vKVqPR9FnsutZey7Lrf0yvfHNHCb5YMbL1Zlb7982E2g/KTmhojoQeo3nXzk922dUH051Ah/glw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711133935; c=relaxed/simple;
	bh=RvmsAR11dw746YWvXQuPe4mZf7NBYIG3RcH9yHkE/vw=;
	h=Date:To:From:Subject:Message-Id; b=sloP9n/yRlimvrMVPomZHoGXKWL40EzObOp/6ReP/MAhSBSKBFnt6DOpME3IURXZnMZPCqGRIuienw192DwthbSsEcAQWxu7EzQlbarOyhS8wX8MTobPOMyRZdmj8xC8+5f5eFi2pShSfZACYfuTfM4VyahV4IfncaoiC4S9i8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jpS5uT4d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jpS5uT4d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75807C433C7;
	Fri, 22 Mar 2024 18:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711133935;
	bh=RvmsAR11dw746YWvXQuPe4mZf7NBYIG3RcH9yHkE/vw=;
	h=Date:To:From:Subject:From;
	b=jpS5uT4d5u/sPQ1VJiWoFosfVX5y9YdESYDtp7alOL0XW96xgQ7ZjW2sUhRjikLKg
	 dQ/yCfG7j+U4vvsG8JOc4AUP+h7iCA84usL+diciEC1vmiVqVWFh4lTl5aAcNPei8X
	 f6t9C7x/U1Of3F6fRKqAbeROL+eAQn2a5A/Ls0kE=
Date: Fri, 22 Mar 2024 11:58:54 -0700
To: mm-commits@vger.kernel.org,urezki@gmail.com,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmallocc-optimize-to-reduce-arguments-of-alloc_vmap_area.patch added to mm-unstable branch
Message-Id: <20240322185855.75807C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmalloc.c: optimize to reduce arguments of alloc_vmap_area()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmallocc-optimize-to-reduce-arguments-of-alloc_vmap_area.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmallocc-optimize-to-reduce-arguments-of-alloc_vmap_area.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: mm/vmalloc.c: optimize to reduce arguments of alloc_vmap_area()
Date: Sat, 9 Mar 2024 12:44:54 +0800

If called by __get_vm_area_node(), by open coding the field assignments of
'struct vm_struct *vm', and move the vm->flags and vm->caller assignments
into __get_vm_area_node(), the passed in arguments 'flags' and 'caller'
can be removed.

This alleviates overloaded arguments passed in for alloc_vmap_area().

Link: https://lkml.kernel.org/r/20240309044454.648888-1-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

--- a/mm/vmalloc.c~mm-vmallocc-optimize-to-reduce-arguments-of-alloc_vmap_area
+++ a/mm/vmalloc.c
@@ -1931,8 +1931,7 @@ static struct vmap_area *alloc_vmap_area
 				unsigned long align,
 				unsigned long vstart, unsigned long vend,
 				int node, gfp_t gfp_mask,
-				unsigned long va_flags, struct vm_struct *vm,
-				unsigned long flags, const void *caller)
+				unsigned long va_flags, struct vm_struct *vm)
 {
 	struct vmap_node *vn;
 	struct vmap_area *va;
@@ -1995,8 +1994,11 @@ retry:
 	va->vm = NULL;
 	va->flags = (va_flags | vn_id);
 
-	if (vm)
-		setup_vmalloc_vm(vm, va, flags, caller);
+	if (vm) {
+		vm->addr = (void *)va->va_start;
+		vm->size = va->va_end - va->va_start;
+		va->vm = vm;
+	}
 
 	vn = addr_to_node(va->va_start);
 
@@ -2572,8 +2574,7 @@ static void *new_vmap_block(unsigned int
 	va = alloc_vmap_area(VMAP_BLOCK_SIZE, VMAP_BLOCK_SIZE,
 					VMALLOC_START, VMALLOC_END,
 					node, gfp_mask,
-					VMAP_RAM|VMAP_BLOCK, NULL,
-					0, NULL);
+					VMAP_RAM|VMAP_BLOCK, NULL);
 	if (IS_ERR(va)) {
 		kfree(vb);
 		return ERR_CAST(va);
@@ -2931,7 +2932,7 @@ void *vm_map_ram(struct page **pages, un
 		va = alloc_vmap_area(size, PAGE_SIZE,
 				VMALLOC_START, VMALLOC_END,
 				node, GFP_KERNEL, VMAP_RAM,
-				NULL, 0, NULL);
+				NULL);
 		if (IS_ERR(va))
 			return NULL;
 
@@ -3070,7 +3071,10 @@ static struct vm_struct *__get_vm_area_n
 	if (!(flags & VM_NO_GUARD))
 		size += PAGE_SIZE;
 
-	va = alloc_vmap_area(size, align, start, end, node, gfp_mask, 0, area, flags, caller);
+	area->flags = flags;
+	area->caller = caller;
+
+	va = alloc_vmap_area(size, align, start, end, node, gfp_mask, 0, area);
 	if (IS_ERR(va)) {
 		kfree(area);
 		return NULL;
_

Patches currently in -mm which might be from bhe@redhat.com are

mm-mm_initc-remove-the-useless-dma_reserve.patch
x86-remove-memblock_find_dma_reserve.patch
mm-mm_initc-add-new-function-calc_nr_kernel_pages.patch
mm-mm_initc-remove-meaningless-calculation-of-zone-managed_pages-in-free_area_init_core.patch
mm-mm_initc-remove-unneeded-calc_memmap_size.patch
mm-mm_initc-remove-arch_reserved_kernel_pages.patch
mm-vmallocc-optimize-to-reduce-arguments-of-alloc_vmap_area.patch

