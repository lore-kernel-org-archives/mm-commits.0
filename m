Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96263C05027
	for <mm-commits@archiver.kernel.org>; Fri, 10 Feb 2023 00:56:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229933AbjBJA4k (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Feb 2023 19:56:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230508AbjBJAzO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Feb 2023 19:55:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58F2574312
        for <mm-commits@vger.kernel.org>; Thu,  9 Feb 2023 16:54:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E8E5761C3D
        for <mm-commits@vger.kernel.org>; Fri, 10 Feb 2023 00:54:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CD3BC433EF;
        Fri, 10 Feb 2023 00:54:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675990458;
        bh=9x7FZnPIzjoq+RQ7G+QdoJ36rW/UBLy2IyNfrsQ8PTk=;
        h=Date:To:From:Subject:From;
        b=n8k85zQo4Xio8LVQ03Q4OVf2oMcUZ2z+Ynq/jLtyONazKAC0cCH65osR8cnyqMsEP
         WPu0uFV0POhoT09MbuNiYQdiXG/uFXEu+LEqmLYKE2v3AgiQOZStVt/jwgVfnjACh6
         iqd7S+vZjRhSMCGt7w3qVxhKmy4odKhbf4p+XSec=
Date:   Thu, 09 Feb 2023 16:54:17 -0800
To:     mm-commits@vger.kernel.org, urezki@gmail.com,
        stephen.s.brennan@oracle.com, lstoakes@gmail.com,
        error27@gmail.com, bhe@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmallocc-add-flags-to-mark-vm_map_ram-area.patch removed from -mm tree
Message-Id: <20230210005418.4CD3BC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/vmalloc.c: add flags to mark vm_map_ram area
has been removed from the -mm tree.  Its filename was
     mm-vmallocc-add-flags-to-mark-vm_map_ram-area.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: mm/vmalloc.c: add flags to mark vm_map_ram area
Date: Mon, 6 Feb 2023 16:40:15 +0800

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

Link: https://lkml.kernel.org/r/20230206084020.174506-3-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Reviewed-by: Lorenzo Stoakes <lstoakes@gmail.com>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Dan Carpenter <error27@gmail.com>
Cc: Stephen Brennan <stephen.s.brennan@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmalloc.h |    1 +
 mm/vmalloc.c            |   16 ++++++++++++----
 2 files changed, 13 insertions(+), 4 deletions(-)

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
@@ -1578,7 +1578,8 @@ preload_this_cpu_lock(spinlock_t *lock,
 static struct vmap_area *alloc_vmap_area(unsigned long size,
 				unsigned long align,
 				unsigned long vstart, unsigned long vend,
-				int node, gfp_t gfp_mask)
+				int node, gfp_t gfp_mask,
+				unsigned long va_flags)
 {
 	struct vmap_area *va;
 	unsigned long freed;
@@ -1623,6 +1624,7 @@ retry:
 	va->va_start = addr;
 	va->va_end = addr + size;
 	va->vm = NULL;
+	va->flags = va_flags;
 
 	spin_lock(&vmap_area_lock);
 	insert_vmap_area(va, &vmap_area_root, &vmap_area_list);
@@ -1901,6 +1903,10 @@ static struct vmap_area *find_unlink_vma
 
 #define VMAP_BLOCK_SIZE		(VMAP_BBMAP_BITS * PAGE_SIZE)
 
+#define VMAP_RAM		0x1 /* indicates vm_map_ram area*/
+#define VMAP_BLOCK		0x2 /* mark out the vmap_block sub-type*/
+#define VMAP_FLAGS_MASK		0x3
+
 struct vmap_block_queue {
 	spinlock_t lock;
 	struct list_head free;
@@ -1976,7 +1982,8 @@ static void *new_vmap_block(unsigned int
 
 	va = alloc_vmap_area(VMAP_BLOCK_SIZE, VMAP_BLOCK_SIZE,
 					VMALLOC_START, VMALLOC_END,
-					node, gfp_mask);
+					node, gfp_mask,
+					VMAP_RAM|VMAP_BLOCK);
 	if (IS_ERR(va)) {
 		kfree(vb);
 		return ERR_CAST(va);
@@ -2285,7 +2292,8 @@ void *vm_map_ram(struct page **pages, un
 	} else {
 		struct vmap_area *va;
 		va = alloc_vmap_area(size, PAGE_SIZE,
-				VMALLOC_START, VMALLOC_END, node, GFP_KERNEL);
+				VMALLOC_START, VMALLOC_END,
+				node, GFP_KERNEL, VMAP_RAM);
 		if (IS_ERR(va))
 			return NULL;
 
@@ -2483,7 +2491,7 @@ static struct vm_struct *__get_vm_area_n
 	if (!(flags & VM_NO_GUARD))
 		size += PAGE_SIZE;
 
-	va = alloc_vmap_area(size, align, start, end, node, gfp_mask);
+	va = alloc_vmap_area(size, align, start, end, node, gfp_mask, 0);
 	if (IS_ERR(va)) {
 		kfree(area);
 		return NULL;
_

Patches currently in -mm which might be from bhe@redhat.com are


