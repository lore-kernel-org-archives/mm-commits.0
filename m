From: akpm@linux-foundation.org
Subject: + mm-vmallocc-remove-alloc_map-from-vmap_block.patch added to -mm tree
Date: Tue, 11 Jun 2013 13:05:02 -0700
Message-ID: <51b782ee.5GM7JFfz32Xu52Yn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42101 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756801Ab3FKUFD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Jun 2013 16:05:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mel@csn.ul.ie, hannes@cmpxchg.org, zhangyanfei@cn.fujitsu.com

Subject: + mm-vmallocc-remove-alloc_map-from-vmap_block.patch added to -mm tree
To: zhangyanfei@cn.fujitsu.com,hannes@cmpxchg.org,mel@csn.ul.ie
From: akpm@linux-foundation.org
Date: Tue, 11 Jun 2013 13:05:02 -0700


The patch titled
     Subject: mm/vmalloc.c: remove alloc_map from vmap_block
has been added to the -mm tree.  Its filename is
     mm-vmallocc-remove-alloc_map-from-vmap_block.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: mm/vmalloc.c: remove alloc_map from vmap_block

As we have removed the dead code in the vb_alloc, it seems there is no
place to use the alloc_map.  So there is no reason to maintain the
alloc_map in vmap_block.

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN mm/vmalloc.c~mm-vmallocc-remove-alloc_map-from-vmap_block mm/vmalloc.c
--- a/mm/vmalloc.c~mm-vmallocc-remove-alloc_map-from-vmap_block
+++ a/mm/vmalloc.c
@@ -754,7 +754,6 @@ struct vmap_block {
 	struct vmap_area *va;
 	struct vmap_block_queue *vbq;
 	unsigned long free, dirty;
-	DECLARE_BITMAP(alloc_map, VMAP_BBMAP_BITS);
 	DECLARE_BITMAP(dirty_map, VMAP_BBMAP_BITS);
 	struct list_head free_list;
 	struct rcu_head rcu_head;
@@ -820,7 +819,6 @@ static struct vmap_block *new_vmap_block
 	vb->va = va;
 	vb->free = VMAP_BBMAP_BITS;
 	vb->dirty = 0;
-	bitmap_zero(vb->alloc_map, VMAP_BBMAP_BITS);
 	bitmap_zero(vb->dirty_map, VMAP_BBMAP_BITS);
 	INIT_LIST_HEAD(&vb->free_list);
 
@@ -873,7 +871,6 @@ static void purge_fragmented_blocks(int
 		if (vb->free + vb->dirty == VMAP_BBMAP_BITS && vb->dirty != VMAP_BBMAP_BITS) {
 			vb->free = 0; /* prevent further allocs after releasing lock */
 			vb->dirty = VMAP_BBMAP_BITS; /* prevent purging it again */
-			bitmap_fill(vb->alloc_map, VMAP_BBMAP_BITS);
 			bitmap_fill(vb->dirty_map, VMAP_BBMAP_BITS);
 			spin_lock(&vbq->lock);
 			list_del_rcu(&vb->free_list);
_

Patches currently in -mm which might be from zhangyanfei@cn.fujitsu.com are

linux-next.patch
vmcore-clean-up-read_vmcore.patch
vmcore-allocate-buffer-for-elf-headers-on-page-size-alignment.patch
vmcore-allocate-buffer-for-elf-headers-on-page-size-alignment-fix.patch
vmcore-treat-memory-chunks-referenced-by-pt_load-program-header-entries-in-page-size-boundary-in-vmcore_list.patch
vmalloc-make-find_vm_area-check-in-range.patch
vmalloc-introduce-remap_vmalloc_range_partial.patch
vmalloc-introduce-remap_vmalloc_range_partial-fix.patch
vmcore-allocate-elf-note-segment-in-the-2nd-kernel-vmalloc-memory.patch
vmcore-allocate-elf-note-segment-in-the-2nd-kernel-vmalloc-memory-fix.patch
vmcore-allow-user-process-to-remap-elf-note-segment-buffer.patch
vmcore-allow-user-process-to-remap-elf-note-segment-buffer-fix.patch
vmcore-calculate-vmcore-file-size-from-buffer-size-and-total-size-of-vmcore-objects.patch
vmcore-support-mmap-on-proc-vmcore.patch
vmcore-support-mmap-on-proc-vmcore-fix.patch
vmcore-support-mmap-on-proc-vmcore-fix-2.patch
mm-ia64-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-vmalloc-only-call-setup_vmalloc_vm-only-in-__get_vm_area_node.patch
mm-vmalloc-call-setup_vmalloc_vm-instead-of-insert_vmalloc_vm.patch
mm-vmalloc-remove-insert_vmalloc_vm.patch
mm-vmalloc-use-clamp-to-simplify-code.patch
mm-remove-duplicated-call-of-get_pfn_range_for_nid.patch
mm-vmallocc-unbreak-__vunmap.patch
mm-vmallocc-remove-dead-code-in-vb_alloc.patch
mm-vmallocc-remove-unused-purge_fragmented_blocks_thiscpu.patch
mm-vmallocc-remove-alloc_map-from-vmap_block.patch
dev-oldmem-remove-the-interface.patch
dev-oldmem-remove-the-interface-fix.patch
documentation-kdump-kdumptxt-remove-dev-oldmem-description.patch
mips-remove-savemaxmem-parameter-setup.patch
powerpc-remove-savemaxmem-parameter-setup.patch
ia64-remove-setting-for-saved_max_pfn.patch
s390-remove-setting-for-saved_max_pfn.patch

