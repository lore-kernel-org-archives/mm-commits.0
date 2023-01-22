Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 110A2C38142
	for <mm-commits@archiver.kernel.org>; Sun, 22 Jan 2023 01:21:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229768AbjAVBVc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 21 Jan 2023 20:21:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229782AbjAVBVb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 21 Jan 2023 20:21:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51A2E244A7
        for <mm-commits@vger.kernel.org>; Sat, 21 Jan 2023 17:21:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E11ABB8093A
        for <mm-commits@vger.kernel.org>; Sun, 22 Jan 2023 01:21:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F76CC433EF;
        Sun, 22 Jan 2023 01:21:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674350484;
        bh=NTKf4HuoQSBY9U0OZBnbkAsQ8MmzzJq2vtUYNRW6mb0=;
        h=Date:To:From:Subject:From;
        b=0/zv0NL4FzuE6qoHgVGTj7gw9FGwLWjAX7J8/V+TvEG+41ouU2Ih0u49Q+1T3LN9A
         m4MNe22TquvukG3ZZ/BF70Z29WtQjLQQqj4yQTgAs89wlUaCSIgN7Gjdi4sxfCw0ul
         93REB9Sv0huyur1c5UobYI5Gmwfcd4ZE8Jd286eA=
Date:   Sat, 21 Jan 2023 17:21:23 -0800
To:     mm-commits@vger.kernel.org, vincenzo.frascino@arm.com,
        urezki@gmail.com, ryabinin.a.a@gmail.com, glider@google.com,
        dvyukov@google.com, andreyknvl@gmail.com, hch@lst.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-move-__remove_vm_area-out-of-va_remove_mappings.patch added to mm-unstable branch
Message-Id: <20230122012124.8F76CC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: move __remove_vm_area out of va_remove_mappings
has been added to the -mm mm-unstable branch.  Its filename is
     mm-move-__remove_vm_area-out-of-va_remove_mappings.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-move-__remove_vm_area-out-of-va_remove_mappings.patch

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
Subject: mm: move __remove_vm_area out of va_remove_mappings
Date: Sat, 21 Jan 2023 08:10:47 +0100

__remove_vm_area is the only part of va_remove_mappings that requires a
vmap_area.  Move the call out to the caller and only pass the vm_struct to
va_remove_mappings.

Link: https://lkml.kernel.org/r/20230121071051.1143058-7-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/vmalloc.c~mm-move-__remove_vm_area-out-of-va_remove_mappings
+++ a/mm/vmalloc.c
@@ -2614,18 +2614,15 @@ static inline void set_area_direct_map(c
 			set_direct_map(area->pages[i]);
 }
 
-/* Handle removing and resetting vm mappings related to the VA's vm_struct. */
-static void va_remove_mappings(struct vmap_area *va, int deallocate_pages)
+/* Handle removing and resetting vm mappings related to the vm_struct. */
+static void vm_remove_mappings(struct vm_struct *area, int deallocate_pages)
 {
-	struct vm_struct *area = va->vm;
 	unsigned long start = ULONG_MAX, end = 0;
 	unsigned int page_order = vm_area_page_order(area);
 	int flush_reset = area->flags & VM_FLUSH_RESET_PERMS;
 	int flush_dmap = 0;
 	int i;
 
-	__remove_vm_area(va);
-
 	/* If this is not VM_FLUSH_RESET_PERMS memory, no need for the below. */
 	if (!flush_reset)
 		return;
@@ -2691,7 +2688,8 @@ static void __vunmap(const void *addr, i
 
 	kasan_poison_vmalloc(area->addr, get_vm_area_size(area));
 
-	va_remove_mappings(va, deallocate_pages);
+	__remove_vm_area(va);
+	vm_remove_mappings(area, deallocate_pages);
 
 	if (deallocate_pages) {
 		int i;
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

