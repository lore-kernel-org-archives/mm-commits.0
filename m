Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 119247E0F1
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 03:59:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714103972; cv=none; b=LyvohgVUOVdn8MwGnoR/74z50wba8YTcrUXcU6ftkVOiul/XjXokCaqglYB3vo5It8FMIUZjjYimXhQeFhWcwmkqswmM3l3ShnyGA06YnSMyZJgAGZcjir/QoS7nz6++qgX4SfPSfg5X0PScNf3mJQdTkF6G8dgveMkFUqQ4Hig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714103972; c=relaxed/simple;
	bh=8ps5lpPOZgD+Y9/ZmjwRR5/Y4gTRMWGQgpL2RQ9lwOg=;
	h=Date:To:From:Subject:Message-Id; b=YWmZ3Krpr01jsarLdgQb5/pV5+eZ1KP/71dBY18DtWC1/ympekFbB5zt7r1LJsebGnVctoueZVSYU4QG7MgibrAiccvuc+lJ+MSbCn3b/I360SAeDO85gbGooqgg5EA8mntxJtwBVdbrtBvHhKtN9tCugFjz1KHzR8rMzGgqGSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Jp8Zzy7f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Jp8Zzy7f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC775C113CD;
	Fri, 26 Apr 2024 03:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714103971;
	bh=8ps5lpPOZgD+Y9/ZmjwRR5/Y4gTRMWGQgpL2RQ9lwOg=;
	h=Date:To:From:Subject:From;
	b=Jp8Zzy7fQkdb4Iki0O99eM2Hxfjy5GRuNoY3vQNixPbSiyUXAhfbiJ1oQALS0J2rY
	 20Rh7pcQPizWFpVxMuPhDjy4ZZw3T1aBvog+zNZjqSIBD00h6kymFnjxh8ZJNT/akA
	 hqSMQ5szNsoLxXkiUHLd6gEedXB6a3W192tFwj8c=
Date: Thu, 25 Apr 2024 20:59:31 -0700
To: mm-commits@vger.kernel.org,wangyang.guo@intel.com,urezki@gmail.com,tim.c.chen@linux.intel.com,tim.c.chen@intel.com,lstoakes@gmail.com,hch@infradead.org,colin.king@intel.com,bhe@redhat.com,rulin.huang@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmalloc-eliminated-the-lock-contention-from-twice-to-once.patch removed from -mm tree
Message-Id: <20240426035931.DC775C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmalloc: eliminated the lock contention from twice to once
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-eliminated-the-lock-contention-from-twice-to-once.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: rulinhuang <rulin.huang@intel.com>
Subject: mm/vmalloc: eliminated the lock contention from twice to once
Date: Wed, 6 Mar 2024 21:14:40 -0500

When allocating a new memory area where the mapping address range is
known, it is observed that the vmap_node->busy.lock is acquired twice.

The first acquisition occurs in the alloc_vmap_area() function when
inserting the vm area into the vm mapping red-black tree.  The second
acquisition occurs in the setup_vmalloc_vm() function when updating the
properties of the vm, such as flags and address, etc.

Combine these two operations together in alloc_vmap_area(), which improves
scalability when the vmap_node->busy.lock is contended.  By doing so, the
need to acquire the lock twice can also be eliminated to once.

With the above change, tested on intel sapphire rapids platform(224 vcpu),
a 4% performance improvement is gained on
stress-ng/pthread(https://github.com/ColinIanKing/stress-ng), which is the
stress test of thread creations.

Link: https://lkml.kernel.org/r/20240307021440.64967-1-rulin.huang@intel.com
Co-developed-by: "Chen, Tim C" <tim.c.chen@intel.com>
Signed-off-by: "Chen, Tim C" <tim.c.chen@intel.com>
Co-developed-by: "King, Colin" <colin.king@intel.com>
Signed-off-by: "King, Colin" <colin.king@intel.com>
Signed-off-by: rulinhuang <rulin.huang@intel.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Wangyang Guo <wangyang.guo@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   50 +++++++++++++++++++++----------------------------
 1 file changed, 22 insertions(+), 28 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-eliminated-the-lock-contention-from-twice-to-once
+++ a/mm/vmalloc.c
@@ -1926,15 +1926,26 @@ node_alloc(unsigned long size, unsigned
 	return va;
 }
 
+static inline void setup_vmalloc_vm(struct vm_struct *vm,
+	struct vmap_area *va, unsigned long flags, const void *caller)
+{
+	vm->flags = flags;
+	vm->addr = (void *)va->va_start;
+	vm->size = va->va_end - va->va_start;
+	vm->caller = caller;
+	va->vm = vm;
+}
+
 /*
  * Allocate a region of KVA of the specified size and alignment, within the
- * vstart and vend.
+ * vstart and vend. If vm is passed in, the two will also be bound.
  */
 static struct vmap_area *alloc_vmap_area(unsigned long size,
 				unsigned long align,
 				unsigned long vstart, unsigned long vend,
 				int node, gfp_t gfp_mask,
-				unsigned long va_flags)
+				unsigned long va_flags, struct vm_struct *vm,
+				unsigned long flags, const void *caller)
 {
 	struct vmap_node *vn;
 	struct vmap_area *va;
@@ -1997,6 +2008,9 @@ retry:
 	va->vm = NULL;
 	va->flags = (va_flags | vn_id);
 
+	if (vm)
+		setup_vmalloc_vm(vm, va, flags, caller);
+
 	vn = addr_to_node(va->va_start);
 
 	spin_lock(&vn->busy.lock);
@@ -2574,7 +2588,8 @@ static void *new_vmap_block(unsigned int
 	va = alloc_vmap_area(VMAP_BLOCK_SIZE, VMAP_BLOCK_SIZE,
 					VMALLOC_START, VMALLOC_END,
 					node, gfp_mask,
-					VMAP_RAM|VMAP_BLOCK);
+					VMAP_RAM|VMAP_BLOCK, NULL,
+					0, NULL);
 	if (IS_ERR(va)) {
 		kfree(vb);
 		return ERR_CAST(va);
@@ -2931,7 +2946,8 @@ void *vm_map_ram(struct page **pages, un
 		struct vmap_area *va;
 		va = alloc_vmap_area(size, PAGE_SIZE,
 				VMALLOC_START, VMALLOC_END,
-				node, GFP_KERNEL, VMAP_RAM);
+				node, GFP_KERNEL, VMAP_RAM,
+				NULL, 0, NULL);
 		if (IS_ERR(va))
 			return NULL;
 
@@ -3034,26 +3050,6 @@ void __init vm_area_register_early(struc
 	kasan_populate_early_vm_area_shadow(vm->addr, vm->size);
 }
 
-static inline void setup_vmalloc_vm_locked(struct vm_struct *vm,
-	struct vmap_area *va, unsigned long flags, const void *caller)
-{
-	vm->flags = flags;
-	vm->addr = (void *)va->va_start;
-	vm->size = va->va_end - va->va_start;
-	vm->caller = caller;
-	va->vm = vm;
-}
-
-static void setup_vmalloc_vm(struct vm_struct *vm, struct vmap_area *va,
-			      unsigned long flags, const void *caller)
-{
-	struct vmap_node *vn = addr_to_node(va->va_start);
-
-	spin_lock(&vn->busy.lock);
-	setup_vmalloc_vm_locked(vm, va, flags, caller);
-	spin_unlock(&vn->busy.lock);
-}
-
 static void clear_vm_uninitialized_flag(struct vm_struct *vm)
 {
 	/*
@@ -3090,14 +3086,12 @@ static struct vm_struct *__get_vm_area_n
 	if (!(flags & VM_NO_GUARD))
 		size += PAGE_SIZE;
 
-	va = alloc_vmap_area(size, align, start, end, node, gfp_mask, 0);
+	va = alloc_vmap_area(size, align, start, end, node, gfp_mask, 0, area, flags, caller);
 	if (IS_ERR(va)) {
 		kfree(area);
 		return NULL;
 	}
 
-	setup_vmalloc_vm(area, va, flags, caller);
-
 	/*
 	 * Mark pages for non-VM_ALLOC mappings as accessible. Do it now as a
 	 * best-effort approach, as they can be mapped outside of vmalloc code.
@@ -4672,7 +4666,7 @@ retry:
 
 		spin_lock(&vn->busy.lock);
 		insert_vmap_area(vas[area], &vn->busy.root, &vn->busy.head);
-		setup_vmalloc_vm_locked(vms[area], vas[area], VM_ALLOC,
+		setup_vmalloc_vm(vms[area], vas[area], VM_ALLOC,
 				 pcpu_get_vm_areas);
 		spin_unlock(&vn->busy.lock);
 	}
_

Patches currently in -mm which might be from rulin.huang@intel.com are


