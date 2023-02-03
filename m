Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B785C636D7
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:44:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232479AbjBCGoH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:44:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232491AbjBCGmf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:42:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFD768BDDB
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:38:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BDFF4B8297E
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:38:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C29FC433EF;
        Fri,  3 Feb 2023 06:38:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406317;
        bh=Ry2QKlaSw09x+UausuPdQK+6Qp0+8X1od48E1yZMciQ=;
        h=Date:To:From:Subject:From;
        b=MTOh4RMP9u96DMDoRKIK5vdXRi2uRsss9HLtEs2Hb61H+cZQfw/73HOhD4xmhqopW
         XtVXL9G9UdslVfkzhVXWIzQHw1yEuzbXHng90SHqJU7FMCHj4MWTI9KlFpsgHh3zIH
         4Mz1YanSkdtlJcg1/9AciQuX6ztYjlQdudYu+l3U=
Date:   Thu, 02 Feb 2023 22:38:36 -0800
To:     mm-commits@vger.kernel.org, vincenzo.frascino@arm.com,
        urezki@gmail.com, ryabinin.a.a@gmail.com, glider@google.com,
        dvyukov@google.com, david@redhat.com, andreyknvl@gmail.com,
        hch@lst.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-use-remove_vm_area-in-__vunmap.patch removed from -mm tree
Message-Id: <20230203063837.5C29FC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: use remove_vm_area in __vunmap
has been removed from the -mm tree.  Its filename was
     mm-use-remove_vm_area-in-__vunmap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: mm: use remove_vm_area in __vunmap
Date: Sat, 21 Jan 2023 08:10:48 +0100

Use the common helper to find and remove a vmap_area instead of open
coding it.

Link: https://lkml.kernel.org/r/20230121071051.1143058-8-hch@lst.de
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


--- a/mm/vmalloc.c~mm-use-remove_vm_area-in-__vunmap
+++ a/mm/vmalloc.c
@@ -2556,20 +2556,6 @@ struct vm_struct *find_vm_area(const voi
 	return va->vm;
 }
 
-static struct vm_struct *__remove_vm_area(struct vmap_area *va)
-{
-	struct vm_struct *vm;
-
-	if (!va || !va->vm)
-		return NULL;
-
-	vm = va->vm;
-	kasan_free_module_shadow(vm);
-	free_unmap_vmap_area(va);
-
-	return vm;
-}
-
 /**
  * remove_vm_area - find and remove a continuous kernel virtual area
  * @addr:	    base address
@@ -2582,10 +2568,18 @@ static struct vm_struct *__remove_vm_are
  */
 struct vm_struct *remove_vm_area(const void *addr)
 {
+	struct vmap_area *va;
+	struct vm_struct *vm;
+
 	might_sleep();
 
-	return __remove_vm_area(
-		find_unlink_vmap_area((unsigned long) addr));
+	va = find_unlink_vmap_area((unsigned long)addr);
+	if (!va || !va->vm)
+		return NULL;
+	vm = va->vm;
+	kasan_free_module_shadow(vm);
+	free_unmap_vmap_area(va);
+	return vm;
 }
 
 static inline void set_area_direct_map(const struct vm_struct *area,
@@ -2651,7 +2645,6 @@ static void vm_remove_mappings(struct vm
 static void __vunmap(const void *addr, int deallocate_pages)
 {
 	struct vm_struct *area;
-	struct vmap_area *va;
 
 	if (!addr)
 		return;
@@ -2660,20 +2653,18 @@ static void __vunmap(const void *addr, i
 			addr))
 		return;
 
-	va = find_unlink_vmap_area((unsigned long)addr);
-	if (unlikely(!va)) {
+	area = remove_vm_area(addr);
+	if (unlikely(!area)) {
 		WARN(1, KERN_ERR "Trying to vfree() nonexistent vm area (%p)\n",
 				addr);
 		return;
 	}
 
-	area = va->vm;
 	debug_check_no_locks_freed(area->addr, get_vm_area_size(area));
 	debug_check_no_obj_freed(area->addr, get_vm_area_size(area));
 
 	kasan_poison_vmalloc(area->addr, get_vm_area_size(area));
 
-	__remove_vm_area(va);
 	vm_remove_mappings(area, deallocate_pages);
 
 	if (deallocate_pages) {
_

Patches currently in -mm which might be from hch@lst.de are


