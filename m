Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB5BAC636D7
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:44:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232646AbjBCGoP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:44:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232498AbjBCGmm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:42:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 801318C1C8
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:38:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 00440B82982
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:38:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92F19C433D2;
        Fri,  3 Feb 2023 06:38:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406318;
        bh=1KjyHtv+IVIDlOEN8JKtAAW3M6Boykq03ZIX+Cl65LU=;
        h=Date:To:From:Subject:From;
        b=oUSWWhXtvUoUU6bWyy392BxxqkuXogh/bApBrASteJ98ybWUTRAbksseiEpZTRkwj
         Kz+D4PaPliuKs3BPu3ktvL3U32zBoG6vNdtrsL8SGCVYCR4RsTRyx2bntvEWzDCfsx
         wndnN3e6i545f30I8t5ihKyIl2iwkPwmS5VswWSI=
Date:   Thu, 02 Feb 2023 22:38:38 -0800
To:     mm-commits@vger.kernel.org, vincenzo.frascino@arm.com,
        urezki@gmail.com, ryabinin.a.a@gmail.com, glider@google.com,
        dvyukov@google.com, david@redhat.com, andreyknvl@gmail.com,
        hch@lst.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-move-debug-checks-from-__vunmap-to-remove_vm_area.patch removed from -mm tree
Message-Id: <20230203063838.92F19C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: move debug checks from __vunmap to remove_vm_area
has been removed from the -mm tree.  Its filename was
     mm-move-debug-checks-from-__vunmap-to-remove_vm_area.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: mm: move debug checks from __vunmap to remove_vm_area
Date: Sat, 21 Jan 2023 08:10:49 +0100

All these checks apply to the free_vm_area interface as well, so move them
to the common routine.

Link: https://lkml.kernel.org/r/20230121071051.1143058-9-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/vmalloc.c~mm-move-debug-checks-from-__vunmap-to-remove_vm_area
+++ a/mm/vmalloc.c
@@ -2573,11 +2573,20 @@ struct vm_struct *remove_vm_area(const v
 
 	might_sleep();
 
+	if (WARN(!PAGE_ALIGNED(addr), "Trying to vfree() bad address (%p)\n",
+			addr))
+		return NULL;
+
 	va = find_unlink_vmap_area((unsigned long)addr);
 	if (!va || !va->vm)
 		return NULL;
 	vm = va->vm;
+
+	debug_check_no_locks_freed(vm->addr, get_vm_area_size(vm));
+	debug_check_no_obj_freed(vm->addr, get_vm_area_size(vm));
 	kasan_free_module_shadow(vm);
+	kasan_poison_vmalloc(vm->addr, get_vm_area_size(vm));
+
 	free_unmap_vmap_area(va);
 	return vm;
 }
@@ -2649,10 +2658,6 @@ static void __vunmap(const void *addr, i
 	if (!addr)
 		return;
 
-	if (WARN(!PAGE_ALIGNED(addr), "Trying to vfree() bad address (%p)\n",
-			addr))
-		return;
-
 	area = remove_vm_area(addr);
 	if (unlikely(!area)) {
 		WARN(1, KERN_ERR "Trying to vfree() nonexistent vm area (%p)\n",
@@ -2660,11 +2665,6 @@ static void __vunmap(const void *addr, i
 		return;
 	}
 
-	debug_check_no_locks_freed(area->addr, get_vm_area_size(area));
-	debug_check_no_obj_freed(area->addr, get_vm_area_size(area));
-
-	kasan_poison_vmalloc(area->addr, get_vm_area_size(area));
-
 	vm_remove_mappings(area, deallocate_pages);
 
 	if (deallocate_pages) {
_

Patches currently in -mm which might be from hch@lst.de are


