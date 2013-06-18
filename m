From: akpm@linux-foundation.org
Subject: + mm-remove-unused-__put_page.patch added to -mm tree
Date: Tue, 18 Jun 2013 13:47:23 -0700
Message-ID: <51c0c75b.T82UnhsxOctCpl+B%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51638 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932200Ab3FRUrY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Jun 2013 16:47:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zhangyanfei@cn.fujitsu.com

Subject: + mm-remove-unused-__put_page.patch added to -mm tree
To: zhangyanfei@cn.fujitsu.com
From: akpm@linux-foundation.org
Date: Tue, 18 Jun 2013 13:47:23 -0700


The patch titled
     Subject: mm: remove unused __put_page()
has been added to the -mm tree.  Its filename is
     mm-remove-unused-__put_page.patch

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
Subject: mm: remove unused __put_page()

This function is nowhere used, and it has a confusing name with put_page
in mm/swap.c.  So better to remove it.

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    5 -----
 1 file changed, 5 deletions(-)

diff -puN mm/internal.h~mm-remove-unused-__put_page mm/internal.h
--- a/mm/internal.h~mm-remove-unused-__put_page
+++ a/mm/internal.h
@@ -32,11 +32,6 @@ static inline void set_page_refcounted(s
 	set_page_count(page, 1);
 }
 
-static inline void __put_page(struct page *page)
-{
-	atomic_dec(&page->_count);
-}
-
 static inline void __get_page_tail_foll(struct page *page,
 					bool get_page_head)
 {
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
mm-remove-duplicated-call-of-get_pfn_range_for_nid-v2.patch
mm-remove-duplicated-call-of-get_pfn_range_for_nid-v2-fix.patch
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
mm-remove-unused-__put_page.patch
mm-sparse-put-clear_hwpoisoned_pages-within-config_memory_hotremove.patch
dev-oldmem-remove-the-interface.patch
dev-oldmem-remove-the-interface-fix.patch
documentation-kdump-kdumptxt-remove-dev-oldmem-description.patch
mips-remove-savemaxmem-parameter-setup.patch
powerpc-remove-savemaxmem-parameter-setup.patch
ia64-remove-setting-for-saved_max_pfn.patch
s390-remove-setting-for-saved_max_pfn.patch

