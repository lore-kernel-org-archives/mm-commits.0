Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A42CC46467
	for <mm-commits@archiver.kernel.org>; Sat, 14 Jan 2023 05:07:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229504AbjANFHC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 14 Jan 2023 00:07:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbjANFHB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 14 Jan 2023 00:07:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26A8530F7
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2023 21:07:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8DCFE60AE6
        for <mm-commits@vger.kernel.org>; Sat, 14 Jan 2023 05:06:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBE78C433D2;
        Sat, 14 Jan 2023 05:06:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673672819;
        bh=K9rEJTJOQa6qZxFEy34mCSJxKS3krQFav2R1y3eebnU=;
        h=Date:To:From:Subject:From;
        b=zNBcfeJrsQGWAEeOMDafZ1caPfLRduc17OMaCZq5MGwYmS3GVTIvT76GxGql3r0fY
         cdy7jYTG+KOOE+YXZh5Egu45BKwlNTy7kLwqJGN7FNVmKWzo6wsWiHz6v2tkJIiO+d
         whE+auVcOklboE7EP8p7NLgG5iaDvqt/tVKSjF5E=
Date:   Fri, 13 Jan 2023 21:06:58 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org, urezki@gmail.com,
        stephen.s.brennan@oracle.com, lstoakes@gmail.com,
        hch@infradead.org, bhe@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmallocc-add-flags-to-mark-vm_map_ram-area.patch added to mm-unstable branch
Message-Id: <20230114050658.DBE78C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc.c: add flags to mark vm_map_ram area
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmallocc-add-flags-to-mark-vm_map_ram-area.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmallocc-add-flags-to-mark-vm_map_ram-area.patch

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
From: Baoquan He <bhe@redhat.com>
Subject: mm/vmalloc.c: add flags to mark vm_map_ram area
Date: Fri, 13 Jan 2023 11:19:16 +0800

Through vmalloc API, a virtual kernel area is reserved for physical
address mapping.  And vmap_area is used to track them, while vm_struct is
allocated to associate with the vmap_area to store more information and
passed out.

However, area reserved via vm_map_ram() is an exception.  It doesn't have
vm_struct to associate with vmap_area.  And we can't recognize the
vmap_area with '->vm == NULL' as a vm_map_ram() area because the normal
freeing path will set va->vm = NULL before unmapping, please see function
remove_vm_area().

Meanwhile, there are two kinds of handling for vm_map_ram area.  One is
the whole vmap_area being reserved and mapped at one time through
vm_map_area() interface; the other is the whole vmap_area with
VMAP_BLOCK_SIZE size being reserved, while mapped into split regions with
smaller size via vb_alloc().

To mark the area reserved through vm_map_ram(), add flags field into
struct vmap_area.  Bit 0 indicates this is vm_map_ram area created through
vm_map_ram() interface, while bit 1 marks out the type of vm_map_ram area
which makes use of vmap_block to manage split regions via vb_alloc/free().

This is a preparation for later use.

Link: https://lkml.kernel.org/r/20230113031921.64716-3-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Stephen Brennan <stephen.s.brennan@oracle.com>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/include/linux/vmalloc.h~mm-vmallocc-add-flags-to-mark-vm_map_ram-area
+++ a/include/linux/vmalloc.h
@@ -76,6 +76,7 @@ struct vmap_area {
 		unsigned long subtree_max_size; /* in "free" tree */
 		struct vm_struct *vm;           /* in "busy" tree */
 	};
+	unsigned long flags; /* mark type of vm_map_ram area */
 };
 
 /* archs that select HAVE_ARCH_HUGE_VMAP should override one or more of these */
--- a/mm/vmalloc.c~mm-vmallocc-add-flags-to-mark-vm_map_ram-area
+++ a/mm/vmalloc.c
@@ -1589,7 +1589,8 @@ preload_this_cpu_lock(spinlock_t *lock,
 static struct vmap_area *alloc_vmap_area(unsigned long size,
 				unsigned long align,
 				unsigned long vstart, unsigned long vend,
-				int node, gfp_t gfp_mask)
+				int node, gfp_t gfp_mask,
+				unsigned long va_flags)
 {
 	struct vmap_area *va;
 	unsigned long freed;
@@ -1635,6 +1636,7 @@ retry:
 	va->va_start = addr;
 	va->va_end = addr + size;
 	va->vm = NULL;
+	va->flags = va_flags;
 
 	spin_lock(&vmap_area_lock);
 	insert_vmap_area(va, &vmap_area_root, &vmap_area_list);
@@ -1913,6 +1915,10 @@ static struct vmap_area *find_unlink_vma
 
 #define VMAP_BLOCK_SIZE		(VMAP_BBMAP_BITS * PAGE_SIZE)
 
+#define VMAP_RAM		0x1 /* indicates vm_map_ram area*/
+#define VMAP_BLOCK		0x2 /* mark out the vmap_block sub-type*/
+#define VMAP_FLAGS_MASK		0x3
+
 struct vmap_block_queue {
 	spinlock_t lock;
 	struct list_head free;
@@ -1988,7 +1994,8 @@ static void *new_vmap_block(unsigned int
 
 	va = alloc_vmap_area(VMAP_BLOCK_SIZE, VMAP_BLOCK_SIZE,
 					VMALLOC_START, VMALLOC_END,
-					node, gfp_mask);
+					node, gfp_mask,
+					VMAP_RAM|VMAP_BLOCK);
 	if (IS_ERR(va)) {
 		kfree(vb);
 		return ERR_CAST(va);
@@ -2297,7 +2304,8 @@ void *vm_map_ram(struct page **pages, un
 	} else {
 		struct vmap_area *va;
 		va = alloc_vmap_area(size, PAGE_SIZE,
-				VMALLOC_START, VMALLOC_END, node, GFP_KERNEL);
+				VMALLOC_START, VMALLOC_END,
+				node, GFP_KERNEL, VMAP_RAM);
 		if (IS_ERR(va))
 			return NULL;
 
@@ -2537,7 +2545,7 @@ static struct vm_struct *__get_vm_area_n
 	if (!(flags & VM_NO_GUARD))
 		size += PAGE_SIZE;
 
-	va = alloc_vmap_area(size, align, start, end, node, gfp_mask);
+	va = alloc_vmap_area(size, align, start, end, node, gfp_mask, 0);
 	if (IS_ERR(va)) {
 		kfree(area);
 		return NULL;
_

Patches currently in -mm which might be from bhe@redhat.com are

mm-vmallocc-add-used_map-into-vmap_block-to-track-space-of-vmap_block.patch
mm-vmallocc-add-flags-to-mark-vm_map_ram-area.patch
mm-vmallocc-allow-vread-to-read-out-vm_map_ram-areas.patch
mm-vmalloc-explicitly-identify-vm_map_ram-area-when-shown-in-proc-vmcoreinfo.patch
mm-vmalloc-skip-the-uninitilized-vmalloc-areas.patch
powerpc-mm-add-vm_ioremap-flag-to-the-vmalloc-area.patch
sh-mm-set-vm_ioremap-flag-to-the-vmalloc-area.patch

