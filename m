Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D56477604D
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 03:59:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714103981; cv=none; b=J+g8ED82a9nhTEtmmxUJSuEVORhWndus1mkbEzXlFtqDJNuG3vrjVUWUXDTrEAQPlzsMd+W9w6W0gnAqE2x6iZRLoLxlQOi73ia+rbJk3Mpf/6fB/L41TebiJlaeCA8ep5G4dJnfAZVVf1XwIivxw3CeSJ6diuPWHc6gyicmk5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714103981; c=relaxed/simple;
	bh=xfXVBesWPg2ucihtloESuQV0hENCOFq1lvs5Y06c8NU=;
	h=Date:To:From:Subject:Message-Id; b=Jc861+1naI+fZa0dM4P0wH1QlDoO5xrjQ6W2UhTix841AuTMIyLatEIuFWxHPXAp6iI19KfmXgAZIMcrV0bJo7e/CxzchK1sugihoKJiJM/V0mJOWPIhs8OjpWJJFgxgcrIE/ZZGzE+oE+q54CQ/Top4KpomPRc4VSUHeiNNPw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yDuVQFtR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yDuVQFtR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC894C113CD;
	Fri, 26 Apr 2024 03:59:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714103981;
	bh=xfXVBesWPg2ucihtloESuQV0hENCOFq1lvs5Y06c8NU=;
	h=Date:To:From:Subject:From;
	b=yDuVQFtRIUHIT7BiqnLrv3Lzo6f/bBncG9NpUVG4z6EHgZvveb0pTKLIGkS/Yd6PJ
	 EzUw/P5gF9mZXpCVGG6qHfXeh6EuKPLTOp/qYOjMWz0xeSz5UidQFKlKw8ru6eB/F9
	 hnYgfiKZnka+2Xf9F7eZSRmqfuPkVchc7kBBU7YQ=
Date: Thu, 25 Apr 2024 20:59:41 -0700
To: mm-commits@vger.kernel.org,urezki@gmail.com,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmallocc-optimize-to-reduce-arguments-of-alloc_vmap_area.patch removed from -mm tree
Message-Id: <20240426035941.AC894C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmalloc.c: optimize to reduce arguments of alloc_vmap_area()
has been removed from the -mm tree.  Its filename was
     mm-vmallocc-optimize-to-reduce-arguments-of-alloc_vmap_area.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -1944,8 +1944,7 @@ static struct vmap_area *alloc_vmap_area
 				unsigned long align,
 				unsigned long vstart, unsigned long vend,
 				int node, gfp_t gfp_mask,
-				unsigned long va_flags, struct vm_struct *vm,
-				unsigned long flags, const void *caller)
+				unsigned long va_flags, struct vm_struct *vm)
 {
 	struct vmap_node *vn;
 	struct vmap_area *va;
@@ -2008,8 +2007,11 @@ retry:
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
 
@@ -2588,8 +2590,7 @@ static void *new_vmap_block(unsigned int
 	va = alloc_vmap_area(VMAP_BLOCK_SIZE, VMAP_BLOCK_SIZE,
 					VMALLOC_START, VMALLOC_END,
 					node, gfp_mask,
-					VMAP_RAM|VMAP_BLOCK, NULL,
-					0, NULL);
+					VMAP_RAM|VMAP_BLOCK, NULL);
 	if (IS_ERR(va)) {
 		kfree(vb);
 		return ERR_CAST(va);
@@ -2947,7 +2948,7 @@ void *vm_map_ram(struct page **pages, un
 		va = alloc_vmap_area(size, PAGE_SIZE,
 				VMALLOC_START, VMALLOC_END,
 				node, GFP_KERNEL, VMAP_RAM,
-				NULL, 0, NULL);
+				NULL);
 		if (IS_ERR(va))
 			return NULL;
 
@@ -3086,7 +3087,10 @@ static struct vm_struct *__get_vm_area_n
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

documentation-kdump-clean-up-the-outdated-description.patch
kexec-fix-the-unexpected-kexec_dprintk-macro.patch
crash-add-prefix-for-crash-dumping-messages.patch

