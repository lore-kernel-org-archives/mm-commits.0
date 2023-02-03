Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A81F9C61DA4
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:44:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232119AbjBCGoY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:44:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232560AbjBCGmn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:42:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B302F8DAC7
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:38:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 700FBB82981
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:38:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17F4AC433EF;
        Fri,  3 Feb 2023 06:38:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406321;
        bh=3xHygIGf8LnBY0DnhgGSLLqLX6gczL0a/OjV1v2hyJ0=;
        h=Date:To:From:Subject:From;
        b=kSXW2QMwzx2hjkd38EtxS/ozI3eWJppCssb3M2jM4WJ3gE/Wck9YakljrlDGE+F/Q
         94vT4je64sg0F2iMmw0Ns3u+NBV/Liyur09YMaGEG2OKEZvPL+rT2qP4BQDfX1DabA
         CWnHRQHMNDqmPZ1MrImhjm7bQPjyNjleYJTZk890=
Date:   Thu, 02 Feb 2023 22:38:40 -0800
To:     mm-commits@vger.kernel.org, vincenzo.frascino@arm.com,
        urezki@gmail.com, ryabinin.a.a@gmail.com, glider@google.com,
        dvyukov@google.com, david@redhat.com, andreyknvl@gmail.com,
        hch@lst.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-refactor-va_remove_mappings.patch removed from -mm tree
Message-Id: <20230203063841.17F4AC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: refactor va_remove_mappings
has been removed from the -mm tree.  Its filename was
     mm-refactor-va_remove_mappings.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: mm: refactor va_remove_mappings
Date: Sat, 21 Jan 2023 08:10:51 +0100

Move the VM_FLUSH_RESET_PERMS to the caller and rename the function to
better describe what it is doing.

Link: https://lkml.kernel.org/r/20230121071051.1143058-11-hch@lst.de
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


--- a/mm/vmalloc.c~mm-refactor-va_remove_mappings
+++ a/mm/vmalloc.c
@@ -2602,35 +2602,23 @@ static inline void set_area_direct_map(c
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
 
@@ -2725,7 +2713,8 @@ void vfree(const void *addr)
 		return;
 	}
 
-	vm_remove_mappings(vm, true);
+	if (unlikely(vm->flags & VM_FLUSH_RESET_PERMS))
+		vm_reset_perms(vm);
 	for (i = 0; i < vm->nr_pages; i++) {
 		struct page *page = vm->pages[i];
 
_

Patches currently in -mm which might be from hch@lst.de are


