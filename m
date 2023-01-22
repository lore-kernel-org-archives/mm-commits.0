Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9D3EC27C76
	for <mm-commits@archiver.kernel.org>; Sun, 22 Jan 2023 01:21:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229766AbjAVBVZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 21 Jan 2023 20:21:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229749AbjAVBVX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 21 Jan 2023 20:21:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0505A24484
        for <mm-commits@vger.kernel.org>; Sat, 21 Jan 2023 17:21:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ABE6EB8093B
        for <mm-commits@vger.kernel.org>; Sun, 22 Jan 2023 01:21:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47057C433D2;
        Sun, 22 Jan 2023 01:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674350479;
        bh=bUfR/Mq0felMdOCo31A/x3FEAjGEXgdkOXFT5nXuAEA=;
        h=Date:To:From:Subject:From;
        b=gr9JzRoVuJDln1RlF2x2R+XA+jH8M9yTD0L77N27G6zpPizVpqfJNtioLBJpS3jco
         4QQN6G/gZHBYb+Od6z5q4eUm0x6lFtAjtHp0xo/pqonMTsW4++ZAqNDLUphOBwpOXi
         CGoRYNQ1r/Ad7RoOjoyKxFBdAxPakYXh1OHK8bJM=
Date:   Sat, 21 Jan 2023 17:21:18 -0800
To:     mm-commits@vger.kernel.org, vincenzo.frascino@arm.com,
        urezki@gmail.com, ryabinin.a.a@gmail.com, glider@google.com,
        dvyukov@google.com, andreyknvl@gmail.com, hch@lst.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-__vfree_deferred.patch added to mm-unstable branch
Message-Id: <20230122012119.47057C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove __vfree_deferred
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-__vfree_deferred.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-__vfree_deferred.patch

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
Subject: mm: remove __vfree_deferred
Date: Sat, 21 Jan 2023 08:10:44 +0100

Fold __vfree_deferred into vfree_atomic, and call vfree_atomic early on
from vfree if called from interrupt context so that the extra low-level
helper can be avoided.

Link: https://lkml.kernel.org/r/20230121071051.1143058-4-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/vmalloc.c~mm-remove-__vfree_deferred
+++ a/mm/vmalloc.c
@@ -2769,20 +2769,6 @@ static void __vunmap(const void *addr, i
 	kfree(area);
 }
 
-static inline void __vfree_deferred(const void *addr)
-{
-	/*
-	 * Use raw_cpu_ptr() because this can be called from preemptible
-	 * context. Preemption is absolutely fine here, because the llist_add()
-	 * implementation is lockless, so it works even if we are adding to
-	 * another cpu's list. schedule_work() should be fine with this too.
-	 */
-	struct vfree_deferred *p = raw_cpu_ptr(&vfree_deferred);
-
-	if (llist_add((struct llist_node *)addr, &p->list))
-		schedule_work(&p->wq);
-}
-
 /**
  * vfree_atomic - release memory allocated by vmalloc()
  * @addr:	  memory base address
@@ -2792,13 +2778,19 @@ static inline void __vfree_deferred(cons
  */
 void vfree_atomic(const void *addr)
 {
-	BUG_ON(in_nmi());
+	struct vfree_deferred *p = raw_cpu_ptr(&vfree_deferred);
 
+	BUG_ON(in_nmi());
 	kmemleak_free(addr);
 
-	if (!addr)
-		return;
-	__vfree_deferred(addr);
+	/*
+	 * Use raw_cpu_ptr() because this can be called from preemptible
+	 * context. Preemption is absolutely fine here, because the llist_add()
+	 * implementation is lockless, so it works even if we are adding to
+	 * another cpu's list. schedule_work() should be fine with this too.
+	 */
+	if (addr && llist_add((struct llist_node *)addr, &p->list))
+		schedule_work(&p->wq);
 }
 
 /**
@@ -2820,17 +2812,16 @@ void vfree_atomic(const void *addr)
  */
 void vfree(const void *addr)
 {
-	BUG_ON(in_nmi());
+	if (unlikely(in_interrupt())) {
+		vfree_atomic(addr);
+		return;
+	}
 
+	BUG_ON(in_nmi());
 	kmemleak_free(addr);
+	might_sleep();
 
-	might_sleep_if(!in_interrupt());
-
-	if (!addr)
-		return;
-	if (unlikely(in_interrupt()))
-		__vfree_deferred(addr);
-	else
+	if (addr)
 		__vunmap(addr, 1);
 }
 EXPORT_SYMBOL(vfree);
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

