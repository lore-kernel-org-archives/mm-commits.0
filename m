Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 988C5C27C76
	for <mm-commits@archiver.kernel.org>; Sun, 22 Jan 2023 01:21:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229773AbjAVBVc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 21 Jan 2023 20:21:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229769AbjAVBVc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 21 Jan 2023 20:21:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABC75244AF
        for <mm-commits@vger.kernel.org>; Sat, 21 Jan 2023 17:21:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 46DC960B42
        for <mm-commits@vger.kernel.org>; Sun, 22 Jan 2023 01:21:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E714C433EF;
        Sun, 22 Jan 2023 01:21:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674350489;
        bh=KURw3Hf0WI8Q2c/xhpB6DG2APs+/AlAvOFAFSTEwjgg=;
        h=Date:To:From:Subject:From;
        b=PmnMVEtsBIyWPGA0MKO7zECiG81s7drxoGYOF7V8bjQZzOfsHwiNZKvBr3JdJuByX
         uO3AMSltuEtSjZHjHOr2vn12SitpzVZa6HgjF5TDgBiJJgYtMKm+B4npba7NEUhX8x
         5MRio4FGlzOehLb6zYx92ScaP452IDoQ4hwsl+JI=
Date:   Sat, 21 Jan 2023 17:21:29 -0800
To:     mm-commits@vger.kernel.org, vincenzo.frascino@arm.com,
        urezki@gmail.com, ryabinin.a.a@gmail.com, glider@google.com,
        dvyukov@google.com, andreyknvl@gmail.com, hch@lst.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-split-__vunmap.patch added to mm-unstable branch
Message-Id: <20230122012129.9E714C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: split __vunmap
has been added to the -mm mm-unstable branch.  Its filename is
     mm-split-__vunmap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-split-__vunmap.patch

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
From: Christoph Hellwig <hch@lst.de>
Subject: mm: split __vunmap
Date: Sat, 21 Jan 2023 08:10:50 +0100

vunmap only needs to find and free the vmap_area and vm_strut, so open
code that there and merge the rest of the code into vfree.

Link: https://lkml.kernel.org/r/20230121071051.1143058-10-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
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
@@ -2666,45 +2666,6 @@ static void vm_remove_mappings(struct vm
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
@@ -2757,6 +2718,9 @@ void vfree_atomic(const void *addr)
  */
 void vfree(const void *addr)
 {
+	struct vm_struct *vm;
+	int i;
+
 	if (unlikely(in_interrupt())) {
 		vfree_atomic(addr);
 		return;
@@ -2766,8 +2730,32 @@ void vfree(const void *addr)
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
 
@@ -2782,10 +2770,20 @@ EXPORT_SYMBOL(vfree);
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

revert-remoteproc-qcom_q6v5_mss-map-unmap-metadata-region-before-after-use.patch
mm-reject-vmap-with-vm_flush_reset_perms.patch
mm-remove-__vfree.patch
mm-remove-__vfree_deferred.patch
mm-move-vmalloc_init-and-free_work-down-in-vmallocc.patch
mm-call-vfree-instead-of-__vunmap-from-delayed_vfree_work.patch
mm-move-__remove_vm_area-out-of-va_remove_mappings.patch
mm-use-remove_vm_area-in-__vunmap.patch
mm-move-debug-checks-from-__vunmap-to-remove_vm_area.patch
mm-split-__vunmap.patch
mm-refactor-va_remove_mappings.patch

