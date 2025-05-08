Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E9D221ABC8;
	Thu,  8 May 2025 06:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746686462; cv=none; b=XnjYNhvMGfZNfuRXZ5PG0Iksrex4t2e5V73S1hlBk2J1FivRE8uaAvYrvt4fHmOk+fiWgX3Mx1I/vVgDapT2PLNbm8iWoYsxzz8CpmwqDgviYjfoDWFA76Tz4FO2vxdYCmYdwv5NGl7KqDPjS2s5xyW4aGZ+4XYZAtNJciL8GMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746686462; c=relaxed/simple;
	bh=vupgym1FUa+m4B0pgm6AKdXMmOKL9LVkXKv+WmFb86I=;
	h=Date:To:From:Subject:Message-Id; b=NokHr8eRSL8c9zzRBDE5iZdH9b7Ets9EBHqX/9WQxRTxlkYYA2PqdxQhcqw5/ZYc1AayyxbF3DNqiOHOoDMlCXu3xkxpJwp3JX0r/1AgqX/KMXzwWw2zJteNx9i5wqK3xUSeSoVAgGosM/bqRsp2fxCIrLDPsFfIdKW9/qTycm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NWTTfgzA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NWTTfgzA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 825FBC4CEEB;
	Thu,  8 May 2025 06:41:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746686461;
	bh=vupgym1FUa+m4B0pgm6AKdXMmOKL9LVkXKv+WmFb86I=;
	h=Date:To:From:Subject:From;
	b=NWTTfgzAA9LEyPSnmHpQq5BiJxNV7RNZuMQp72kGQJCdlGcAjdG8qhsU8va9+KsNF
	 FGzjOiSDJjktYSybu29NXCjTjsBBS/9pMWn7td/NPfU7AXOLPWkIIbC8DrxJvOTgX9
	 xRZLAl/A/NiHpy1paXyKUNEaPWuCZ1EzRCy+M4go=
Date: Wed, 07 May 2025 23:41:00 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,urezki@gmail.com,stable@vger.kernel.org,mhocko@suse.com,erhard_f@mailbox.org,dakr@kernel.org,kees@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-vmalloc-support-more-granular-vrealloc-sizing.patch removed from -mm tree
Message-Id: <20250508064101.825FBC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: vmalloc: support more granular vrealloc() sizing
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-support-more-granular-vrealloc-sizing.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kees Cook <kees@kernel.org>
Subject: mm: vmalloc: support more granular vrealloc() sizing
Date: Fri, 25 Apr 2025 17:11:07 -0700

Introduce struct vm_struct::requested_size so that the requested
(re)allocation size is retained separately from the allocated area size. 
This means that KASAN will correctly poison the correct spans of requested
bytes.  This also means we can support growing the usable portion of an
allocation that can already be supported by the existing area's existing
allocation.

Link: https://lkml.kernel.org/r/20250426001105.it.679-kees@kernel.org
Fixes: 3ddc2fefe6f3 ("mm: vmalloc: implement vrealloc()")
Signed-off-by: Kees Cook <kees@kernel.org>
Reported-by: Erhard Furtner <erhard_f@mailbox.org>
Closes: https://lore.kernel.org/all/20250408192503.6149a816@outsider.home/
Reviewed-by: Danilo Krummrich <dakr@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmalloc.h |    1 +
 mm/vmalloc.c            |   31 ++++++++++++++++++++++++-------
 2 files changed, 25 insertions(+), 7 deletions(-)

--- a/include/linux/vmalloc.h~mm-vmalloc-support-more-granular-vrealloc-sizing
+++ a/include/linux/vmalloc.h
@@ -61,6 +61,7 @@ struct vm_struct {
 	unsigned int		nr_pages;
 	phys_addr_t		phys_addr;
 	const void		*caller;
+	unsigned long		requested_size;
 };
 
 struct vmap_area {
--- a/mm/vmalloc.c~mm-vmalloc-support-more-granular-vrealloc-sizing
+++ a/mm/vmalloc.c
@@ -1940,7 +1940,7 @@ static inline void setup_vmalloc_vm(stru
 {
 	vm->flags = flags;
 	vm->addr = (void *)va->va_start;
-	vm->size = va_size(va);
+	vm->size = vm->requested_size = va_size(va);
 	vm->caller = caller;
 	va->vm = vm;
 }
@@ -3133,6 +3133,7 @@ struct vm_struct *__get_vm_area_node(uns
 
 	area->flags = flags;
 	area->caller = caller;
+	area->requested_size = requested_size;
 
 	va = alloc_vmap_area(size, align, start, end, node, gfp_mask, 0, area);
 	if (IS_ERR(va)) {
@@ -4063,6 +4064,8 @@ EXPORT_SYMBOL(vzalloc_node_noprof);
  */
 void *vrealloc_noprof(const void *p, size_t size, gfp_t flags)
 {
+	struct vm_struct *vm = NULL;
+	size_t alloced_size = 0;
 	size_t old_size = 0;
 	void *n;
 
@@ -4072,15 +4075,17 @@ void *vrealloc_noprof(const void *p, siz
 	}
 
 	if (p) {
-		struct vm_struct *vm;
-
 		vm = find_vm_area(p);
 		if (unlikely(!vm)) {
 			WARN(1, "Trying to vrealloc() nonexistent vm area (%p)\n", p);
 			return NULL;
 		}
 
-		old_size = get_vm_area_size(vm);
+		alloced_size = get_vm_area_size(vm);
+		old_size = vm->requested_size;
+		if (WARN(alloced_size < old_size,
+			 "vrealloc() has mismatched area vs requested sizes (%p)\n", p))
+			return NULL;
 	}
 
 	/*
@@ -4088,14 +4093,26 @@ void *vrealloc_noprof(const void *p, siz
 	 * would be a good heuristic for when to shrink the vm_area?
 	 */
 	if (size <= old_size) {
-		/* Zero out spare memory. */
-		if (want_init_on_alloc(flags))
+		/* Zero out "freed" memory. */
+		if (want_init_on_free())
 			memset((void *)p + size, 0, old_size - size);
+		vm->requested_size = size;
 		kasan_poison_vmalloc(p + size, old_size - size);
-		kasan_unpoison_vmalloc(p, size, KASAN_VMALLOC_PROT_NORMAL);
 		return (void *)p;
 	}
 
+	/*
+	 * We already have the bytes available in the allocation; use them.
+	 */
+	if (size <= alloced_size) {
+		kasan_unpoison_vmalloc(p + old_size, size - old_size,
+				       KASAN_VMALLOC_PROT_NORMAL);
+		/* Zero out "alloced" memory. */
+		if (want_init_on_alloc(flags))
+			memset((void *)p + old_size, 0, size - old_size);
+		vm->requested_size = size;
+	}
+
 	/* TODO: Grow the vm_area, i.e. allocate and map additional pages. */
 	n = __vmalloc_noprof(size, flags);
 	if (!n)
_

Patches currently in -mm which might be from kees@kernel.org are


