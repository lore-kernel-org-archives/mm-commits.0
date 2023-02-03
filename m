Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72956C61DA4
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:44:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232491AbjBCGoO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:44:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232496AbjBCGml (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:42:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CDC58BDDD
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:38:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 82B2661D99
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:38:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D48BCC433EF;
        Fri,  3 Feb 2023 06:38:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406319;
        bh=kkiLc+iBz5lc6x1jluMT3TZgUBlHXhlPDI8r1GD8d9g=;
        h=Date:To:From:Subject:From;
        b=bide9TTIZQ26mn8nFv0itzozbr9bp8vGTJNLQj383hTL8YHinbrVonYX0N2YFCwO7
         rM2uRgxMIVta2Xp3lF0HydRHe0t181CWLEfLdcs/sjnhJY9RdCvE6a5CNQhnHzyQRF
         /oOnq0tqLzPzcpCQ4aTn9WzaN++yiDsyX5VHQTPk=
Date:   Thu, 02 Feb 2023 22:38:39 -0800
To:     mm-commits@vger.kernel.org, vincenzo.frascino@arm.com,
        urezki@gmail.com, ryabinin.a.a@gmail.com, glider@google.com,
        dvyukov@google.com, david@redhat.com, andreyknvl@gmail.com,
        hch@lst.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-split-__vunmap.patch removed from -mm tree
Message-Id: <20230203063839.D48BCC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: split __vunmap
has been removed from the -mm tree.  Its filename was
     mm-split-__vunmap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: mm: split __vunmap
Date: Sat, 21 Jan 2023 08:10:50 +0100

vunmap only needs to find and free the vmap_area and vm_strut, so open
code that there and merge the rest of the code into vfree.

Link: https://lkml.kernel.org/r/20230121071051.1143058-10-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/vmalloc.c~mm-split-__vunmap
+++ a/mm/vmalloc.c
@@ -2651,45 +2651,6 @@ static void vm_remove_mappings(struct vm
 	set_area_direct_map(area, set_direct_map_default_noflush);
 }
 
-static void __vunmap(const void *addr, int deallocate_pages)
-{
-	struct vm_struct *area;
-
-	if (!addr)
-		return;
-
-	area = remove_vm_area(addr);
-	if (unlikely(!area)) {
-		WARN(1, KERN_ERR "Trying to vfree() nonexistent vm area (%p)\n",
-				addr);
-		return;
-	}
-
-	vm_remove_mappings(area, deallocate_pages);
-
-	if (deallocate_pages) {
-		int i;
-
-		for (i = 0; i < area->nr_pages; i++) {
-			struct page *page = area->pages[i];
-
-			BUG_ON(!page);
-			mod_memcg_page_state(page, MEMCG_VMALLOC, -1);
-			/*
-			 * High-order allocs for huge vmallocs are split, so
-			 * can be freed as an array of order-0 allocations
-			 */
-			__free_pages(page, 0);
-			cond_resched();
-		}
-		atomic_long_sub(area->nr_pages, &nr_vmalloc_pages);
-
-		kvfree(area->pages);
-	}
-
-	kfree(area);
-}
-
 static void delayed_vfree_work(struct work_struct *w)
 {
 	struct vfree_deferred *p = container_of(w, struct vfree_deferred, wq);
@@ -2742,6 +2703,9 @@ void vfree_atomic(const void *addr)
  */
 void vfree(const void *addr)
 {
+	struct vm_struct *vm;
+	int i;
+
 	if (unlikely(in_interrupt())) {
 		vfree_atomic(addr);
 		return;
@@ -2751,8 +2715,32 @@ void vfree(const void *addr)
 	kmemleak_free(addr);
 	might_sleep();
 
-	if (addr)
-		__vunmap(addr, 1);
+	if (!addr)
+		return;
+
+	vm = remove_vm_area(addr);
+	if (unlikely(!vm)) {
+		WARN(1, KERN_ERR "Trying to vfree() nonexistent vm area (%p)\n",
+				addr);
+		return;
+	}
+
+	vm_remove_mappings(vm, true);
+	for (i = 0; i < vm->nr_pages; i++) {
+		struct page *page = vm->pages[i];
+
+		BUG_ON(!page);
+		mod_memcg_page_state(page, MEMCG_VMALLOC, -1);
+		/*
+		 * High-order allocs for huge vmallocs are split, so
+		 * can be freed as an array of order-0 allocations
+		 */
+		__free_pages(page, 0);
+		cond_resched();
+	}
+	atomic_long_sub(vm->nr_pages, &nr_vmalloc_pages);
+	kvfree(vm->pages);
+	kfree(vm);
 }
 EXPORT_SYMBOL(vfree);
 
@@ -2767,10 +2755,20 @@ EXPORT_SYMBOL(vfree);
  */
 void vunmap(const void *addr)
 {
+	struct vm_struct *vm;
+
 	BUG_ON(in_interrupt());
 	might_sleep();
-	if (addr)
-		__vunmap(addr, 0);
+
+	if (!addr)
+		return;
+	vm = remove_vm_area(addr);
+	if (unlikely(!vm)) {
+		WARN(1, KERN_ERR "Trying to vunmap() nonexistent vm area (%p)\n",
+				addr);
+		return;
+	}
+	kfree(vm);
 }
 EXPORT_SYMBOL(vunmap);
 
_

Patches currently in -mm which might be from hch@lst.de are


