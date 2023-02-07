Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C87D9C05027
	for <mm-commits@archiver.kernel.org>; Tue,  7 Feb 2023 01:18:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230191AbjBGBSL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 6 Feb 2023 20:18:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230197AbjBGBSJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 6 Feb 2023 20:18:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 465F335266
        for <mm-commits@vger.kernel.org>; Mon,  6 Feb 2023 17:18:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CC630610A0
        for <mm-commits@vger.kernel.org>; Tue,  7 Feb 2023 01:18:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D214C433EF;
        Tue,  7 Feb 2023 01:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675732687;
        bh=CNf6n5HsRtTnmYTmhX6gkjaufsXEZmsfYbAQHdnVEa0=;
        h=Date:To:From:Subject:From;
        b=ebr/hQCDca6y2qGXjseHWIZY648FCMH8aGw+7O7PurqjbFaT12aBZaQwModVVJ09K
         FGG1QpYxdEJ3wag1e4WOx4leMmpc0+oB7N6aWeWJWlU/tfasfoLW0GM2KiTRqXPu18
         VGsqfx1JUYQP+xG4eb5Af+IaMxHjmIt34uwy8fSQ=
Date:   Mon, 06 Feb 2023 17:18:06 -0800
To:     mm-commits@vger.kernel.org, urezki@gmail.com,
        stephen.s.brennan@oracle.com, lstoakes@gmail.com,
        error27@gmail.com, bhe@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmallocc-add-used_map-into-vmap_block-to-track-space-of-vmap_block.patch added to mm-unstable branch
Message-Id: <20230207011807.2D214C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc.c: add used_map into vmap_block to track space of vmap_block
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmallocc-add-used_map-into-vmap_block-to-track-space-of-vmap_block.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmallocc-add-used_map-into-vmap_block-to-track-space-of-vmap_block.patch

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
Subject: mm/vmalloc.c: add used_map into vmap_block to track space of vmap_block
Date: Mon, 6 Feb 2023 16:40:14 +0800

Patch series "mm/vmalloc.c: allow vread() to read out vm_map_ram areas", v5.

Problem:
***

Stephen reported vread() will skip vm_map_ram areas when reading out
/proc/kcore with drgn utility.  Please see below link to get more details.
 

  /proc/kcore reads 0's for vmap_block
  https://lore.kernel.org/all/87ilk6gos2.fsf@oracle.com/T/#u

Root cause:
***

The normal vmalloc API uses struct vmap_area to manage the virtual kernel
area allocated, and associate a vm_struct to store more information and
pass out.  However, area reserved through vm_map_ram() interface doesn't
allocate vm_struct to associate with.  So the current code in vread() will
skip the vm_map_ram area through 'if (!va->vm)' conditional checking.

Solution:
***

To mark the area reserved through vm_map_ram() interface, add field
'flags' into struct vmap_area.  Bit 0 indicates this is vm_map_ram area
created through vm_map_ram() interface, bit 1 marks out the type of
vm_map_ram area which makes use of vmap_block to manage split regions via
vb_alloc/free().

And also add bitmap field 'used_map' into struct vmap_block to mark those
further subdivided regions being used to differentiate with dirty and free
regions in vmap_block.

With the help of above vmap_area->flags and vmap_block->used_map, we can
recognize and handle vm_map_ram areas successfully.  All these are done in
patch 1~3.

Meanwhile, do some improvement on areas related to vm_map_ram areas in
patch 4, 5.  And also change area flag from VM_ALLOC to VM_IOREMAP in
patch 6, 7 because this will show them as 'ioremap' in /proc/vmallocinfo,
and exclude them from /proc/kcore.


This patch (of 7):

In one vmap_block area, there could be three types of regions: region
being used which is allocated through vb_alloc(), dirty region which is
freed via vb_free() and free region.  Among them, only used region has
available data.  While there's no way to track those used regions
currently.

Here, add bitmap field used_map into vmap_block, and set/clear it during
allocation or freeing regions of vmap_block area.

This is a preparation for later use.

Link: https://lkml.kernel.org/r/20230206084020.174506-1-bhe@redhat.com
Link: https://lkml.kernel.org/r/20230206084020.174506-2-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Reviewed-by: Lorenzo Stoakes <lstoakes@gmail.com>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Dan Carpenter <error27@gmail.com>
Cc: Stephen Brennan <stephen.s.brennan@oracle.com>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/vmalloc.c~mm-vmallocc-add-used_map-into-vmap_block-to-track-space-of-vmap_block
+++ a/mm/vmalloc.c
@@ -1910,6 +1910,7 @@ struct vmap_block {
 	spinlock_t lock;
 	struct vmap_area *va;
 	unsigned long free, dirty;
+	DECLARE_BITMAP(used_map, VMAP_BBMAP_BITS);
 	unsigned long dirty_min, dirty_max; /*< dirty range */
 	struct list_head free_list;
 	struct rcu_head rcu_head;
@@ -1986,10 +1987,12 @@ static void *new_vmap_block(unsigned int
 	vb->va = va;
 	/* At least something should be left free */
 	BUG_ON(VMAP_BBMAP_BITS <= (1UL << order));
+	bitmap_zero(vb->used_map, VMAP_BBMAP_BITS);
 	vb->free = VMAP_BBMAP_BITS - (1UL << order);
 	vb->dirty = 0;
 	vb->dirty_min = VMAP_BBMAP_BITS;
 	vb->dirty_max = 0;
+	bitmap_set(vb->used_map, 0, (1UL << order));
 	INIT_LIST_HEAD(&vb->free_list);
 
 	vb_idx = addr_to_vb_idx(va->va_start);
@@ -2099,6 +2102,7 @@ static void *vb_alloc(unsigned long size
 		pages_off = VMAP_BBMAP_BITS - vb->free;
 		vaddr = vmap_block_vaddr(vb->va->va_start, pages_off);
 		vb->free -= 1UL << order;
+		bitmap_set(vb->used_map, pages_off, (1UL << order));
 		if (vb->free == 0) {
 			spin_lock(&vbq->lock);
 			list_del_rcu(&vb->free_list);
@@ -2132,6 +2136,9 @@ static void vb_free(unsigned long addr,
 	order = get_order(size);
 	offset = (addr & (VMAP_BLOCK_SIZE - 1)) >> PAGE_SHIFT;
 	vb = xa_load(&vmap_blocks, addr_to_vb_idx(addr));
+	spin_lock(&vb->lock);
+	bitmap_clear(vb->used_map, offset, (1UL << order));
+	spin_unlock(&vb->lock);
 
 	vunmap_range_noflush(addr, addr + size);
 
_

Patches currently in -mm which might be from bhe@redhat.com are

mm-vmallocc-add-used_map-into-vmap_block-to-track-space-of-vmap_block.patch
mm-vmallocc-add-flags-to-mark-vm_map_ram-area.patch
mm-vmallocc-allow-vread-to-read-out-vm_map_ram-areas.patch
mm-vmalloc-explicitly-identify-vm_map_ram-area-when-shown-in-proc-vmcoreinfo.patch
mm-vmalloc-skip-the-uninitilized-vmalloc-areas.patch
powerpc-mm-add-vm_ioremap-flag-to-the-vmalloc-area.patch
sh-mm-set-vm_ioremap-flag-to-the-vmalloc-area.patch

