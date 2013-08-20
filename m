From: akpm@linux-foundation.org
Subject: +
 mm-vmalloc-use-wrapper-function-get_vm_area_size-to-caculate-size-of-vm-area.patch added to -mm tree
Date: Tue, 20 Aug 2013 16:08:26 -0700
Message-ID: <5213f6ea.gqsrkZu5V4+NMkgd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38705 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558Ab3HTXI1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 20 Aug 2013 19:08:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, rientjes@google.com, riel@redhat.com, kosaki.motohiro@jp.fujitsu.com, jkosina@suse.cz, isimatu.yasuaki@jp.fujitsu.com, iamjoonsoo.kim@lge.com, hannes@cmpxchg.org, fengguang.wu@intel.com, dave.hansen@linux.intel.com, liwanp@linux.vnet.ibm.com

Subject: + mm-vmalloc-use-wrapper-function-get_vm_area_size-to-caculate-size-of-vm-area.patch added to -mm tree
To: liwanp@linux.vnet.ibm.com,dave.hansen@linux.intel.com,fengguang.wu@intel.com,hannes@cmpxchg.org,iamjoonsoo.kim@lge.com,isimatu.yasuaki@jp.fujitsu.com,jkosina@suse.cz,kosaki.motohiro@jp.fujitsu.com,riel@redhat.com,rientjes@google.com,tj@kernel.org
From: akpm@linux-foundation.org
Date: Tue, 20 Aug 2013 16:08:26 -0700


The patch titled
     Subject: mm/vmalloc: use wrapper function get_vm_area_size to caculate size of vm area
has been added to the -mm tree.  Its filename is
     mm-vmalloc-use-wrapper-function-get_vm_area_size-to-caculate-size-of-vm-area.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmalloc-use-wrapper-function-get_vm_area_size-to-caculate-size-of-vm-area.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmalloc-use-wrapper-function-get_vm_area_size-to-caculate-size-of-vm-area.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: mm/vmalloc: use wrapper function get_vm_area_size to caculate size of vm area

Use wrapper function get_vm_area_size to calculate size of vm area.

Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN mm/vmalloc.c~mm-vmalloc-use-wrapper-function-get_vm_area_size-to-caculate-size-of-vm-area mm/vmalloc.c
--- a/mm/vmalloc.c~mm-vmalloc-use-wrapper-function-get_vm_area_size-to-caculate-size-of-vm-area
+++ a/mm/vmalloc.c
@@ -1258,7 +1258,7 @@ void unmap_kernel_range(unsigned long ad
 int map_vm_area(struct vm_struct *area, pgprot_t prot, struct page ***pages)
 {
 	unsigned long addr = (unsigned long)area->addr;
-	unsigned long end = addr + area->size - PAGE_SIZE;
+	unsigned long end = addr + get_vm_area_size(area);
 	int err;
 
 	err = vmap_page_range(addr, end, prot, *pages);
@@ -1553,7 +1553,7 @@ static void *__vmalloc_area_node(struct
 	unsigned int nr_pages, array_size, i;
 	gfp_t nested_gfp = (gfp_mask & GFP_RECLAIM_MASK) | __GFP_ZERO;
 
-	nr_pages = (area->size - PAGE_SIZE) >> PAGE_SHIFT;
+	nr_pages = get_vm_area_size(area) >> PAGE_SHIFT;
 	array_size = (nr_pages * sizeof(struct page *));
 
 	area->nr_pages = nr_pages;
@@ -1985,7 +1985,7 @@ long vread(char *buf, char *addr, unsign
 
 		vm = va->vm;
 		vaddr = (char *) vm->addr;
-		if (addr >= vaddr + vm->size - PAGE_SIZE)
+		if (addr >= vaddr + get_vm_area_size(vm))
 			continue;
 		while (addr < vaddr) {
 			if (count == 0)
@@ -1995,7 +1995,7 @@ long vread(char *buf, char *addr, unsign
 			addr++;
 			count--;
 		}
-		n = vaddr + vm->size - PAGE_SIZE - addr;
+		n = vaddr + get_vm_area_size(vm) - addr;
 		if (n > count)
 			n = count;
 		if (!(vm->flags & VM_IOREMAP))
@@ -2067,7 +2067,7 @@ long vwrite(char *buf, char *addr, unsig
 
 		vm = va->vm;
 		vaddr = (char *) vm->addr;
-		if (addr >= vaddr + vm->size - PAGE_SIZE)
+		if (addr >= vaddr + get_vm_area_size(vm))
 			continue;
 		while (addr < vaddr) {
 			if (count == 0)
@@ -2076,7 +2076,7 @@ long vwrite(char *buf, char *addr, unsig
 			addr++;
 			count--;
 		}
-		n = vaddr + vm->size - PAGE_SIZE - addr;
+		n = vaddr + get_vm_area_size(vm) - addr;
 		if (n > count)
 			n = count;
 		if (!(vm->flags & VM_IOREMAP)) {
_

Patches currently in -mm which might be from liwanp@linux.vnet.ibm.com are

mm-zswapc-get-swapper-address_space-by-using-macro.patch
mm-drop-actor-argument-of-do_generic_file_read.patch
mm-drop-actor-argument-of-do_shmem_file_read.patch
mm-fix-potential-null-pointer-dereference.patch
mm-hugetlb-move-up-the-code-which-check-availability-of-free-huge-page.patch
mm-hugetlb-trivial-commenting-fix.patch
mm-hugetlb-clean-up-alloc_huge_page.patch
mm-hugetlb-fix-and-clean-up-node-iteration-code-to-alloc-or-free.patch
mm-hugetlb-remove-redundant-list_empty-check-in-gather_surplus_pages.patch
mm-hugetlb-do-not-use-a-page-in-page-cache-for-cow-optimization.patch
mm-hugetlb-add-vm_noreserve-check-in-vma_has_reserves.patch
mm-hugetlb-remove-decrement_hugepage_resv_vma.patch
mm-hugetlb-decrement-reserve-count-if-vm_noreserve-alloc-page-cache.patch
mm-vmalloc-remove-useless-variable-in-vmap_block.patch
mm-vmalloc-use-well-defined-find_last_bit-func.patch
mm-hotplug-verify-hotplug-memory-range.patch
mm-hotplug-verify-hotplug-memory-range-fix.patch
mm-hotplug-remove-stop_machine-from-try_offline_node.patch
mm-hugetlb-protect-reserved-pages-when-soft-offlining-a-hugepage.patch
mm-hugetlb-change-variable-name-reservations-to-resv.patch
mm-hugetlb-fix-subpool-accounting-handling.patch
mm-hugetlb-remove-useless-check-about-mapping-type.patch
mm-hugetlb-grab-a-page_table_lock-after-page_cache_release.patch
mm-hugetlb-return-a-reserved-page-to-a-reserved-pool-if-failed.patch
mm-migrate-make-core-migration-code-aware-of-hugepage.patch
mm-soft-offline-use-migrate_pages-instead-of-migrate_huge_page.patch
migrate-add-hugepage-migration-code-to-migrate_pages.patch
mm-migrate-add-hugepage-migration-code-to-move_pages.patch
mm-mbind-add-hugepage-migration-code-to-mbind.patch
mm-migrate-remove-vm_hugetlb-from-vma-flag-check-in-vma_migratable.patch
mm-memory-hotplug-enable-memory-hotplug-to-handle-hugepage.patch
mm-migrate-check-movability-of-hugepage-in-unmap_and_move_huge_page.patch
mm-prepare-to-remove-proc-sys-vm-hugepages_treat_as_movable.patch
mm-prepare-to-remove-proc-sys-vm-hugepages_treat_as_movable-v2.patch
mm-mempolicy-rename-check_range-to-queue_pages_range.patch
mm-sparse-introduce-alloc_usemap_and_memmap.patch
mm-writeback-make-writeback_inodes_wb-static.patch
mm-vmalloc-use-wrapper-function-get_vm_area_size-to-caculate-size-of-vm-area.patch
linux-next.patch

