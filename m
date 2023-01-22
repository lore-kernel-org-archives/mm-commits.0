Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CD64C54EED
	for <mm-commits@archiver.kernel.org>; Sun, 22 Jan 2023 01:21:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229780AbjAVBVd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 21 Jan 2023 20:21:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229775AbjAVBVd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 21 Jan 2023 20:21:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8EAF244B1
        for <mm-commits@vger.kernel.org>; Sat, 21 Jan 2023 17:21:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 57F04B80880
        for <mm-commits@vger.kernel.org>; Sun, 22 Jan 2023 01:21:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFA65C433D2;
        Sun, 22 Jan 2023 01:21:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674350488;
        bh=IEtqHyooeMeWNby306kQDkQwUd+fxWvHFWODWFQIjUU=;
        h=Date:To:From:Subject:From;
        b=GB8ejD/XnlyVwsTp8w3FUsklwpKk0ZGhVlCXOXhtKyMFZQYS5CH2JWs2WEdK/x3i8
         JKB5WOxSNBemPMnRpI6US+Tm/Tg+nzbDx1flE1FCfB/N45m18Cv/RqFuBMiZ31gkJc
         //zc2RB1CDddauaRoPcBfThboqw0sFFYa1ec5QAM=
Date:   Sat, 21 Jan 2023 17:21:27 -0800
To:     mm-commits@vger.kernel.org, vincenzo.frascino@arm.com,
        urezki@gmail.com, ryabinin.a.a@gmail.com, glider@google.com,
        dvyukov@google.com, andreyknvl@gmail.com, hch@lst.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-move-debug-checks-from-__vunmap-to-remove_vm_area.patch added to mm-unstable branch
Message-Id: <20230122012127.EFA65C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: move debug checks from __vunmap to remove_vm_area
has been added to the -mm mm-unstable branch.  Its filename is
     mm-move-debug-checks-from-__vunmap-to-remove_vm_area.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-move-debug-checks-from-__vunmap-to-remove_vm_area.patch

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
Subject: mm: move debug checks from __vunmap to remove_vm_area
Date: Sat, 21 Jan 2023 08:10:49 +0100

All these checks apply to the free_vm_area interface as well, so move them
to the common routine.

Link: https://lkml.kernel.org/r/20230121071051.1143058-9-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/vmalloc.c~mm-move-debug-checks-from-__vunmap-to-remove_vm_area
+++ a/mm/vmalloc.c
@@ -2588,11 +2588,20 @@ struct vm_struct *remove_vm_area(const v
 
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
@@ -2664,10 +2673,6 @@ static void __vunmap(const void *addr, i
 	if (!addr)
 		return;
 
-	if (WARN(!PAGE_ALIGNED(addr), "Trying to vfree() bad address (%p)\n",
-			addr))
-		return;
-
 	area = remove_vm_area(addr);
 	if (unlikely(!area)) {
 		WARN(1, KERN_ERR "Trying to vfree() nonexistent vm area (%p)\n",
@@ -2675,11 +2680,6 @@ static void __vunmap(const void *addr, i
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

