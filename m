Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F370CC61DA4
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:44:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232638AbjBCGoB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:44:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232468AbjBCGmd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:42:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C20D29414
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:38:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CAC9561DA8
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:38:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25BABC4339B;
        Fri,  3 Feb 2023 06:38:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406316;
        bh=FPDTUr5096eCEb2D9JmdWhkKGFYg1eyykscYXI0LSlk=;
        h=Date:To:From:Subject:From;
        b=XasMHeVcsy/R1XSkuhVQ7Wt7irjClb4GdPGXl9vskzfVkWwrV5gvefjd0R4heh3M/
         WQMEEXEKJPfEtcpVdqHZ+YCHFROukjUbdOmI9XIQJWgoD6HcaAK5fneqk9wPJidLm8
         YNCZryRP6fSfL2RhcFgqh81D6TcTXuQCbX6D04hI=
Date:   Thu, 02 Feb 2023 22:38:35 -0800
To:     mm-commits@vger.kernel.org, vincenzo.frascino@arm.com,
        urezki@gmail.com, ryabinin.a.a@gmail.com, glider@google.com,
        dvyukov@google.com, david@redhat.com, andreyknvl@gmail.com,
        hch@lst.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-move-__remove_vm_area-out-of-va_remove_mappings.patch removed from -mm tree
Message-Id: <20230203063836.25BABC4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: move __remove_vm_area out of va_remove_mappings
has been removed from the -mm tree.  Its filename was
     mm-move-__remove_vm_area-out-of-va_remove_mappings.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/vmalloc.c~mm-move-__remove_vm_area-out-of-va_remove_mappings
+++ a/mm/vmalloc.c
@@ -2599,18 +2599,15 @@ static inline void set_area_direct_map(c
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
@@ -2676,7 +2673,8 @@ static void __vunmap(const void *addr, i
 
 	kasan_poison_vmalloc(area->addr, get_vm_area_size(area));
 
-	va_remove_mappings(va, deallocate_pages);
+	__remove_vm_area(va);
+	vm_remove_mappings(area, deallocate_pages);
 
 	if (deallocate_pages) {
 		int i;
_

Patches currently in -mm which might be from hch@lst.de are


