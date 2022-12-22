Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 067FBC4332F
	for <mm-commits@archiver.kernel.org>; Thu, 22 Dec 2022 21:39:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229691AbiLVVjA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 22 Dec 2022 16:39:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbiLVVi7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 22 Dec 2022 16:38:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1EA323316
        for <mm-commits@vger.kernel.org>; Thu, 22 Dec 2022 13:38:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 56718B81F66
        for <mm-commits@vger.kernel.org>; Thu, 22 Dec 2022 21:38:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11CDCC433EF;
        Thu, 22 Dec 2022 21:38:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1671745135;
        bh=6Lf1Z2GGUA6rYk0hDgEvEBsIW52fnIDcAYv79VzwrY4=;
        h=Date:To:From:Subject:From;
        b=uhXyViplSioiZhIGnPnqfVI4YrDKSF3nALLIJjCtnm9hgybD1/tFajOBgb6/NmXF2
         ohvCFN+dYpR1yaVW7vYaWGIy8epXRs7BrhjrHGKDmrQyHqCewX9bNhATIjHPJ1nuYD
         UOSDERh/moC6+P6Wf1BiSq9Ky9wESArO4YiCxn7k=
Date:   Thu, 22 Dec 2022 13:38:54 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        roman.gushchin@linux.dev, oleksiy.avramchenko@sony.com,
        npiggin@gmail.com, lstoakes@gmail.com, hch@lst.de,
        hch@infradead.org, bhe@redhat.com, urezki@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-avoid-calling-__find_vmap_area-twice-in-__vunmap.patch added to mm-unstable branch
Message-Id: <20221222213855.11CDCC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vmalloc: avoid calling __find_vmap_area() twice in __vunmap()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmalloc-avoid-calling-__find_vmap_area-twice-in-__vunmap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-avoid-calling-__find_vmap_area-twice-in-__vunmap.patch

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
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: mm: vmalloc: avoid calling __find_vmap_area() twice in __vunmap()
Date: Thu, 22 Dec 2022 20:00:20 +0100

Currently the __vunmap() path calls __find_vmap_area() twice.  Once on
entry to check that the area exists, then inside the remove_vm_area()
function which also performs a new search for the VA.

In order to improvie it from a performance point of view we split
remove_vm_area() into two new parts:
  - find_unlink_vmap_area() that does a search and unlink from tree;
  - __remove_vm_area() that removes without searching.

In this case there is no any functional change for remove_vm_area()
whereas vm_remove_mappings(), where a second search happens, switches to
the __remove_vm_area() variant where the already detached VA is passed as
a parameter, so there is no need to find it again.

Performance wise, i use test_vmalloc.sh with 32 threads doing alloc
free on a 64-CPUs-x86_64-box:

perf without this patch:
-   31.41%     0.50%  vmalloc_test/10  [kernel.vmlinux]    [k] __vunmap
   - 30.92% __vunmap
      - 17.67% _raw_spin_lock
           native_queued_spin_lock_slowpath
      - 12.33% remove_vm_area
         - 11.79% free_vmap_area_noflush
            - 11.18% _raw_spin_lock
                 native_queued_spin_lock_slowpath
        0.76% free_unref_page

perf with this patch:
-   11.35%     0.13%  vmalloc_test/14  [kernel.vmlinux]    [k] __vunmap
   - 11.23% __vunmap
      - 8.28% find_unlink_vmap_area
         - 7.95% _raw_spin_lock
              7.44% native_queued_spin_lock_slowpath
      - 1.93% free_vmap_area_noflush
         - 0.56% _raw_spin_lock
              0.53% native_queued_spin_lock_slowpath
        0.60% __vunmap_range_noflush

__vunmap() consumes around ~20% less CPU cycles on this test.

v2 -> v3:
- update commit message;
- rename the vm_remove_mappings() to the va_remove_mappings();
- move va-unlinking to the callers so the free_vmap_area_noflush()
  now expects a VA that has been disconnected;
- eliminate a local variable in the remove_vm_area().

Link: https://lkml.kernel.org/r/20221222190022.134380-1-urezki@gmail.com
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reported-by: Roman Gushchin <roman.gushchin@linux.dev>
Reviewed-by: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oleksiy Avramchenko <oleksiy.avramchenko@sony.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/vmalloc.c~mm-vmalloc-avoid-calling-__find_vmap_area-twice-in-__vunmap
+++ a/mm/vmalloc.c
@@ -1815,9 +1815,9 @@ static void drain_vmap_area_work(struct
 }
 
 /*
- * Free a vmap area, caller ensuring that the area has been unmapped
- * and flush_cache_vunmap had been called for the correct range
- * previously.
+ * Free a vmap area, caller ensuring that the area has been unmapped,
+ * unlinked and flush_cache_vunmap had been called for the correct
+ * range previously.
  */
 static void free_vmap_area_noflush(struct vmap_area *va)
 {
@@ -1825,9 +1825,8 @@ static void free_vmap_area_noflush(struc
 	unsigned long va_start = va->va_start;
 	unsigned long nr_lazy;
 
-	spin_lock(&vmap_area_lock);
-	unlink_va(va, &vmap_area_root);
-	spin_unlock(&vmap_area_lock);
+	if (WARN_ON_ONCE(!list_empty(&va->list)))
+		return;
 
 	nr_lazy = atomic_long_add_return((va->va_end - va->va_start) >>
 				PAGE_SHIFT, &vmap_lazy_nr);
@@ -1871,6 +1870,19 @@ struct vmap_area *find_vmap_area(unsigne
 	return va;
 }
 
+static struct vmap_area *find_unlink_vmap_area(unsigned long addr)
+{
+	struct vmap_area *va;
+
+	spin_lock(&vmap_area_lock);
+	va = __find_vmap_area(addr, &vmap_area_root);
+	if (va)
+		unlink_va(va, &vmap_area_root);
+	spin_unlock(&vmap_area_lock);
+
+	return va;
+}
+
 /*** Per cpu kva allocator ***/
 
 /*
@@ -2015,6 +2027,10 @@ static void free_vmap_block(struct vmap_
 	tmp = xa_erase(&vmap_blocks, addr_to_vb_idx(vb->va->va_start));
 	BUG_ON(tmp != vb);
 
+	spin_lock(&vmap_area_lock);
+	unlink_va(vb->va, &vmap_area_root);
+	spin_unlock(&vmap_area_lock);
+
 	free_vmap_area_noflush(vb->va);
 	kfree_rcu(vb, rcu_head);
 }
@@ -2591,6 +2607,20 @@ struct vm_struct *find_vm_area(const voi
 	return va->vm;
 }
 
+static struct vm_struct *__remove_vm_area(struct vmap_area *va)
+{
+	struct vm_struct *vm;
+
+	if (!va || !va->vm)
+		return NULL;
+
+	vm = va->vm;
+	kasan_free_module_shadow(vm);
+	free_unmap_vmap_area(va);
+
+	return vm;
+}
+
 /**
  * remove_vm_area - find and remove a continuous kernel virtual area
  * @addr:	    base address
@@ -2603,26 +2633,10 @@ struct vm_struct *find_vm_area(const voi
  */
 struct vm_struct *remove_vm_area(const void *addr)
 {
-	struct vmap_area *va;
-
 	might_sleep();
 
-	spin_lock(&vmap_area_lock);
-	va = __find_vmap_area((unsigned long)addr, &vmap_area_root);
-	if (va && va->vm) {
-		struct vm_struct *vm = va->vm;
-
-		va->vm = NULL;
-		spin_unlock(&vmap_area_lock);
-
-		kasan_free_module_shadow(vm);
-		free_unmap_vmap_area(va);
-
-		return vm;
-	}
-
-	spin_unlock(&vmap_area_lock);
-	return NULL;
+	return __remove_vm_area(
+		find_unlink_vmap_area((unsigned long) addr));
 }
 
 static inline void set_area_direct_map(const struct vm_struct *area,
@@ -2636,16 +2650,17 @@ static inline void set_area_direct_map(c
 			set_direct_map(area->pages[i]);
 }
 
-/* Handle removing and resetting vm mappings related to the vm_struct. */
-static void vm_remove_mappings(struct vm_struct *area, int deallocate_pages)
+/* Handle removing and resetting vm mappings related to the VA's vm_struct. */
+static void va_remove_mappings(struct vmap_area *va, int deallocate_pages)
 {
+	struct vm_struct *area = va->vm;
 	unsigned long start = ULONG_MAX, end = 0;
 	unsigned int page_order = vm_area_page_order(area);
 	int flush_reset = area->flags & VM_FLUSH_RESET_PERMS;
 	int flush_dmap = 0;
 	int i;
 
-	remove_vm_area(area->addr);
+	__remove_vm_area(va);
 
 	/* If this is not VM_FLUSH_RESET_PERMS memory, no need for the below. */
 	if (!flush_reset)
@@ -2690,6 +2705,7 @@ static void vm_remove_mappings(struct vm
 static void __vunmap(const void *addr, int deallocate_pages)
 {
 	struct vm_struct *area;
+	struct vmap_area *va;
 
 	if (!addr)
 		return;
@@ -2698,19 +2714,20 @@ static void __vunmap(const void *addr, i
 			addr))
 		return;
 
-	area = find_vm_area(addr);
-	if (unlikely(!area)) {
+	va = find_unlink_vmap_area((unsigned long)addr);
+	if (unlikely(!va)) {
 		WARN(1, KERN_ERR "Trying to vfree() nonexistent vm area (%p)\n",
 				addr);
 		return;
 	}
 
+	area = va->vm;
 	debug_check_no_locks_freed(area->addr, get_vm_area_size(area));
 	debug_check_no_obj_freed(area->addr, get_vm_area_size(area));
 
 	kasan_poison_vmalloc(area->addr, get_vm_area_size(area));
 
-	vm_remove_mappings(area, deallocate_pages);
+	va_remove_mappings(va, deallocate_pages);
 
 	if (deallocate_pages) {
 		int i;
_

Patches currently in -mm which might be from urezki@gmail.com are

mm-vmalloc-avoid-calling-__find_vmap_area-twice-in-__vunmap.patch
mm-vmalloc-switch-to-find_unlink_vmap_area-in-vm_unmap_ram.patch
mm-vmalloc-replace-bug_on-by-warn_on_once.patch

