From: akpm@linux-foundation.org
Subject: + mm-remove-unlikely-from-the-current_order-test.patch added to
 -mm tree
Date: Mon, 17 Jun 2013 15:42:52 -0700
Message-ID: <51bf90ec.AnJAtF53aOL60A0e%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41824 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863Ab3FQWmx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 17 Jun 2013 18:42:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, zhangyanfei@cn.fujitsu.com

Subject: + mm-remove-unlikely-from-the-current_order-test.patch added to -mm tree
To: zhangyanfei@cn.fujitsu.com,rientjes@google.com
From: akpm@linux-foundation.org
Date: Mon, 17 Jun 2013 15:42:52 -0700


The patch titled
     Subject: mm/page_alloc.c: remove unlikely() from the current_order test
has been added to the -mm tree.  Its filename is
     mm-remove-unlikely-from-the-current_order-test.patch

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
Subject: mm/page_alloc.c: remove unlikely() from the current_order test

In __rmqueue_fallback(), current_order loops down from MAX_ORDER - 1 to
the order passed.  MAX_ORDER is typically 11 and pageblock_order is
typically 9 on x86.  Integer division truncates, so pageblock_order / 2 is
4.  For the first eight iterations, it's guaranteed that current_order >=
pageblock_order / 2 if it even gets that far!

So just remove the unlikely(), it's completely bogus.

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Suggested-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-remove-unlikely-from-the-current_order-test mm/page_alloc.c
--- a/mm/page_alloc.c~mm-remove-unlikely-from-the-current_order-test
+++ a/mm/page_alloc.c
@@ -1053,7 +1053,7 @@ __rmqueue_fallback(struct zone *zone, in
 			 * MIGRATE_CMA areas.
 			 */
 			if (!is_migrate_cma(migratetype) &&
-			    (unlikely(current_order >= pageblock_order / 2) ||
+			    (current_order >= pageblock_order / 2 ||
 			     start_migratetype == MIGRATE_RECLAIMABLE ||
 			     page_group_by_mobility_disabled)) {
 				int pages;
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
mm-vmallocc-emit-the-failure-message-before-return.patch
mm-vmallocc-rename-vm_unlist-to-vm_uninitialized.patch
mm-vmallocc-check-vm_uninitialized-flag-in-s_show-instead-of-show_numa_info.patch
include-linux-gfph-fix-the-comment-for-gfp_zone_table.patch
mm-remove-zone_type-argument-of-build_zonelists_node.patch
mm-remove-unused-functions-is_normal_idx-normal-dma32-dma.patch
mm-remove-unlikely-from-the-current_order-test.patch
dev-oldmem-remove-the-interface.patch
dev-oldmem-remove-the-interface-fix.patch
documentation-kdump-kdumptxt-remove-dev-oldmem-description.patch
mips-remove-savemaxmem-parameter-setup.patch
powerpc-remove-savemaxmem-parameter-setup.patch
ia64-remove-setting-for-saved_max_pfn.patch
s390-remove-setting-for-saved_max_pfn.patch

