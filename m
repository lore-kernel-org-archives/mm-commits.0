From: akpm@linux-foundation.org
Subject: + mm-remove-duplicated-call-of-get_pfn_range_for_nid-v2.patch
 added to -mm tree
Date: Mon, 17 Jun 2013 16:22:56 -0700
Message-ID: <51bf9a50.liLxQhwYVh9aJ0GL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42218 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753078Ab3FQXW5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 17 Jun 2013 19:22:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mhocko@suse.cz, fengguang.wu@intel.com, zhangyanfei@cn.fujitsu.com

Subject: + mm-remove-duplicated-call-of-get_pfn_range_for_nid-v2.patch added to -mm tree
To: zhangyanfei@cn.fujitsu.com,fengguang.wu@intel.com,mhocko@suse.cz
From: akpm@linux-foundation.org
Date: Mon, 17 Jun 2013 16:22:56 -0700


The patch titled
     Subject: mm-remove-duplicated-call-of-get_pfn_range_for_nid-v2
has been added to the -mm tree.  Its filename is
     mm-remove-duplicated-call-of-get_pfn_range_for_nid-v2.patch

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
Subject: mm-remove-duplicated-call-of-get_pfn_range_for_nid-v2

It fixes the uninitialized warnings in Arches with no
CONFIG_HAVE_MEMBLOCK_NODE_MAP.

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-remove-duplicated-call-of-get_pfn_range_for_nid-v2 mm/page_alloc.c
--- a/mm/page_alloc.c~mm-remove-duplicated-call-of-get_pfn_range_for_nid-v2
+++ a/mm/page_alloc.c
@@ -4793,7 +4793,7 @@ void __paginginit free_area_init_node(in
 		unsigned long node_start_pfn, unsigned long *zholes_size)
 {
 	pg_data_t *pgdat = NODE_DATA(nid);
-	unsigned long start_pfn, end_pfn;
+	unsigned long start_pfn = 0, end_pfn = 0;
 
 	/* pg_data_t should be reset to zero when it's allocated */
 	WARN_ON(pgdat->nr_zones || pgdat->classzone_idx);
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
dev-oldmem-remove-the-interface.patch
dev-oldmem-remove-the-interface-fix.patch
documentation-kdump-kdumptxt-remove-dev-oldmem-description.patch
mips-remove-savemaxmem-parameter-setup.patch
powerpc-remove-savemaxmem-parameter-setup.patch
ia64-remove-setting-for-saved_max_pfn.patch
s390-remove-setting-for-saved_max_pfn.patch

