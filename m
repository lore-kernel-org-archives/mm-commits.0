Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D638DC38142
	for <mm-commits@archiver.kernel.org>; Sun, 22 Jan 2023 01:21:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbjAVBVo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 21 Jan 2023 20:21:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229788AbjAVBVm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 21 Jan 2023 20:21:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E04B244A8
        for <mm-commits@vger.kernel.org>; Sat, 21 Jan 2023 17:21:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C1407B8093C
        for <mm-commits@vger.kernel.org>; Sun, 22 Jan 2023 01:21:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B74BC433D2;
        Sun, 22 Jan 2023 01:21:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674350491;
        bh=rDjYDDLw0Ylhqe3xfqRn7h8uj6MxA5A5gS8+ngLJTO0=;
        h=Date:To:From:Subject:From;
        b=Y9Agx6a0P7zZqoRqDcoHReTDlYcysVXBqlFdm8zGpjhv0jM0CO6RDK88VWItJ+vFr
         mMgiWMzFYNqb6GCK++Suwkmk0JrOZ9bUrmR+5EDOlwEcGAUrDDCvG1KsGZWRekWT3u
         H3BNRyNB5GIHfRQ/m5NqYY+PRT/0y+HFvw7GgmVo=
Date:   Sat, 21 Jan 2023 17:21:30 -0800
To:     mm-commits@vger.kernel.org, vincenzo.frascino@arm.com,
        urezki@gmail.com, ryabinin.a.a@gmail.com, glider@google.com,
        dvyukov@google.com, andreyknvl@gmail.com, hch@lst.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-refactor-va_remove_mappings.patch added to mm-unstable branch
Message-Id: <20230122012131.5B74BC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: refactor va_remove_mappings
has been added to the -mm mm-unstable branch.  Its filename is
     mm-refactor-va_remove_mappings.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-refactor-va_remove_mappings.patch

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
Subject: mm: refactor va_remove_mappings
Date: Sat, 21 Jan 2023 08:10:51 +0100

Move the VM_FLUSH_RESET_PERMS to the caller and rename the function to
better describe what it is doing.

Link: https://lkml.kernel.org/r/20230121071051.1143058-11-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/vmalloc.c~mm-refactor-va_remove_mappings
+++ a/mm/vmalloc.c
@@ -2617,35 +2617,23 @@ static inline void set_area_direct_map(c
 			set_direct_map(area->pages[i]);
 }
 
-/* Handle removing and resetting vm mappings related to the vm_struct. */
-static void vm_remove_mappings(struct vm_struct *area, int deallocate_pages)
+/*
+ * Flush the vm mapping and reset the direct map.
+ */
+static void vm_reset_perms(struct vm_struct *area)
 {
 	unsigned long start = ULONG_MAX, end = 0;
 	unsigned int page_order = vm_area_page_order(area);
-	int flush_reset = area->flags & VM_FLUSH_RESET_PERMS;
 	int flush_dmap = 0;
 	int i;
 
-	/* If this is not VM_FLUSH_RESET_PERMS memory, no need for the below. */
-	if (!flush_reset)
-		return;
-
 	/*
-	 * If not deallocating pages, just do the flush of the VM area and
-	 * return.
-	 */
-	if (!deallocate_pages) {
-		vm_unmap_aliases();
-		return;
-	}
-
-	/*
-	 * If execution gets here, flush the vm mapping and reset the direct
-	 * map. Find the start and end range of the direct mappings to make sure
+	 * Find the start and end range of the direct mappings to make sure that
 	 * the vm_unmap_aliases() flush includes the direct map.
 	 */
 	for (i = 0; i < area->nr_pages; i += 1U << page_order) {
 		unsigned long addr = (unsigned long)page_address(area->pages[i]);
+
 		if (addr) {
 			unsigned long page_size;
 
@@ -2740,7 +2728,8 @@ void vfree(const void *addr)
 		return;
 	}
 
-	vm_remove_mappings(vm, true);
+	if (unlikely(vm->flags & VM_FLUSH_RESET_PERMS))
+		vm_reset_perms(vm);
 	for (i = 0; i < vm->nr_pages; i++) {
 		struct page *page = vm->pages[i];
 
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

