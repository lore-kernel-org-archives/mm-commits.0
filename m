From: akpm@linux-foundation.org
Subject: [to-be-updated]
 mm-hwpoison-fix-memory-failure-still-holding-reference-count-after-unpoisoning-empty-zero-page.patch removed from -mm tree
Date: Tue, 27 Aug 2013 14:11:46 -0700
Message-ID: <521d1612.wYeukXd5BLUB7ck2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41138 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753881Ab3H0VLr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 27 Aug 2013 17:11:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tony.luck@intel.com, n-horiguchi@ah.jp.nec.com, andi@firstfloor.org, liwanp@linux.vnet.ibm.com

Subject: [to-be-updated] mm-hwpoison-fix-memory-failure-still-holding-reference-count-after-unpoisoning-empty-zero-page.patch removed from -mm tree
To: liwanp@linux.vnet.ibm.com,andi@firstfloor.org,n-horiguchi@ah.jp.nec.com,tony.luck@intel.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 27 Aug 2013 14:11:46 -0700


The patch titled
     Subject: mm/hwpoison: fix memory failure still holding reference count after unpoisoning empty zero page
has been removed from the -mm tree.  Its filename was
     mm-hwpoison-fix-memory-failure-still-holding-reference-count-after-unpoisoning-empty-zero-page.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: mm/hwpoison: fix memory failure still holding reference count after unpoisoning empty zero page

madvise hwpoison inject will poison the read-only empty zero page if there
is no write access before poison.  Empty zero page reference count will be
increased for hwpoison, subsequent poison zero page will return directly
since page has already been set PG_hwpoison, however, page reference count
is still increased by get_user_pages_fast.  The unpoison process will
unpoison the empty zero page and decrease the reference count successfully
for the fist time, however, subsequent unpoison empty zero page will
return directly since page has already been unpoisoned and without
decrease the page reference count of empty zero page.

This patch fixes it by decreasing page reference count for empty zero page
which has already been unpoisoned and page count > 1.

Testcase:

#define _GNU_SOURCE
#include <stdlib.h>
#include <stdio.h>
#include <sys/mman.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/types.h>
#include <errno.h>

#define PAGES_TO_TEST 3
#define PAGE_SIZE	4096

int main(void)
{
	char *mem;
	int i;

	mem = mmap(NULL, PAGES_TO_TEST * PAGE_SIZE,
			PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, 0, 0);

	if (madvise(mem, PAGES_TO_TEST * PAGE_SIZE, MADV_HWPOISON) == -1)
		return -1;

	munmap(mem, PAGES_TO_TEST * PAGE_SIZE);

	return 0;
}

Add printk to dump page reference count:

[   93.075959] Injecting memory failure for page 0x19d0 at 0xb77d8000
[   93.076207] MCE 0x19d0: non LRU page recovery: Ignored
[   93.076209] pfn 0x19d0, page count = 1 after memory failure
[   93.076220] Injecting memory failure for page 0x19d0 at 0xb77d9000
[   93.076221] MCE 0x19d0: already hardware poisoned
[   93.076222] pfn 0x19d0, page count = 2 after memory failure
[   93.076224] Injecting memory failure for page 0x19d0 at 0xb77da000
[   93.076224] MCE 0x19d0: already hardware poisoned
[   93.076225] pfn 0x19d0, page count = 3 after memory failure

Before patch:

[  139.197474] MCE: Software-unpoisoned page 0x19d0
[  139.197479] pfn 0x19d0, page count = 2 after unpoison memory
[  150.478130] MCE: Page was already unpoisoned 0x19d0
[  150.478135] pfn 0x19d0, page count = 2 after unpoison memory
[  151.548288] MCE: Page was already unpoisoned 0x19d0
[  151.548292] pfn 0x19d0, page count = 2 after unpoison memory

After patch:

[  116.022122] MCE: Software-unpoisoned page 0x19d0
[  116.022127] pfn 0x19d0, page count = 2 after unpoison memory
[  117.256163] MCE: Page was already unpoisoned 0x19d0
[  117.256167] pfn 0x19d0, page count = 1 after unpoison memory
[  117.917772] MCE: Page was already unpoisoned 0x19d0
[  117.917777] pfn 0x19d0, page count = 1 after unpoison memory

Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/memory-failure.c~mm-hwpoison-fix-memory-failure-still-holding-reference-count-after-unpoisoning-empty-zero-page mm/memory-failure.c
--- a/mm/memory-failure.c~mm-hwpoison-fix-memory-failure-still-holding-reference-count-after-unpoisoning-empty-zero-page
+++ a/mm/memory-failure.c
@@ -1335,6 +1335,8 @@ int unpoison_memory(unsigned long pfn)
 	page = compound_head(p);
 
 	if (!PageHWPoison(p)) {
+		if (pfn == my_zero_pfn(0) && page_count(p) > 1)
+			put_page(p);
 		pr_info("MCE: Page was already unpoisoned %#lx\n", pfn);
 		return 0;
 	}
_

Patches currently in -mm which might be from liwanp@linux.vnet.ibm.com are

mm-zswapc-get-swapper-address_space-by-using-macro.patch
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
hwpoison-always-unset-migrate_isolate-before-returning-from-soft_offline_page.patch
mm-hwpoison-fix-loss-of-pg_dirty-for-errors-on-mlocked-pages.patch
mm-hwpoison-dont-need-to-hold-compound-lock-for-hugetlbfs-page.patch
mm-hwpoison-fix-race-against-poison-thp.patch
mm-hwpoison-replace-atomic_long_sub-with-atomic_long_dec.patch
mm-hwpoison-dont-set-migration-type-twice-to-avoid-holding-heavily-contend-zone-lock.patch
mm-hwpoison-drop-forward-reference-declarations-__soft_offline_page.patch
mm-hwpoison-add-to-madvise_hwpoison.patch
linux-next.patch
mm-drop-actor-argument-of-do_generic_file_read.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch

