Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E1B9C54EAA
	for <mm-commits@archiver.kernel.org>; Sun, 22 Jan 2023 01:21:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229776AbjAVBVd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 21 Jan 2023 20:21:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229788AbjAVBVc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 21 Jan 2023 20:21:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6048244AE
        for <mm-commits@vger.kernel.org>; Sat, 21 Jan 2023 17:21:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 90C1AB8093C
        for <mm-commits@vger.kernel.org>; Sun, 22 Jan 2023 01:21:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F693C433D2;
        Sun, 22 Jan 2023 01:21:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674350486;
        bh=SAuuT/Xoi+S3joUeJsa33hZPh522XS9U01Qq0HsR6NE=;
        h=Date:To:From:Subject:From;
        b=CS0zQO/WhDPQzZH1ThKEWuK8Gcd7NYfFVkTVW15mA1AL856Z94vaMkf5HyzATg+Sv
         8S9KmQVTOeN3ojNWIVoul++XyWc+5kMIkn3TcHcSZz/+0jf47emfccYHO9zLJkv+AJ
         G8ewEeWqfd1I3aA4EJKMhGsiCHAafDogQuRD1xyw=
Date:   Sat, 21 Jan 2023 17:21:25 -0800
To:     mm-commits@vger.kernel.org, vincenzo.frascino@arm.com,
        urezki@gmail.com, ryabinin.a.a@gmail.com, glider@google.com,
        dvyukov@google.com, andreyknvl@gmail.com, hch@lst.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-use-remove_vm_area-in-__vunmap.patch added to mm-unstable branch
Message-Id: <20230122012126.3F693C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: use remove_vm_area in __vunmap
has been added to the -mm mm-unstable branch.  Its filename is
     mm-use-remove_vm_area-in-__vunmap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-use-remove_vm_area-in-__vunmap.patch

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
Subject: mm: use remove_vm_area in __vunmap
Date: Sat, 21 Jan 2023 08:10:48 +0100

Use the common helper to find and remove a vmap_area instead of open
coding it.

Link: https://lkml.kernel.org/r/20230121071051.1143058-8-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/vmalloc.c~mm-use-remove_vm_area-in-__vunmap
+++ a/mm/vmalloc.c
@@ -2571,20 +2571,6 @@ struct vm_struct *find_vm_area(const voi
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
@@ -2597,10 +2583,18 @@ static struct vm_struct *__remove_vm_are
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
@@ -2666,7 +2660,6 @@ static void vm_remove_mappings(struct vm
 static void __vunmap(const void *addr, int deallocate_pages)
 {
 	struct vm_struct *area;
-	struct vmap_area *va;
 
 	if (!addr)
 		return;
@@ -2675,20 +2668,18 @@ static void __vunmap(const void *addr, i
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

