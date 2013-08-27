From: akpm@linux-foundation.org
Subject: +
 mm-hwpoisonc-fix-held-reference-count-after-unpoisoning-empty-zero-page.patch added to -mm tree
Date: Tue, 27 Aug 2013 14:13:05 -0700
Message-ID: <521d1661.QkDMYNVIuKUvrJV7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41144 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752323Ab3H0VNG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 27 Aug 2013 17:13:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com, andi@firstfloor.org, liwanp@linux.vnet.ibm.com

Subject: + mm-hwpoisonc-fix-held-reference-count-after-unpoisoning-empty-zero-page.patch added to -mm tree
To: liwanp@linux.vnet.ibm.com,andi@firstfloor.org,n-horiguchi@ah.jp.nec.com
From: akpm@linux-foundation.org
Date: Tue, 27 Aug 2013 14:13:05 -0700


The patch titled
     Subject: mm/hwpoison.c: fix held reference count after unpoisoning empty zero page
has been added to the -mm tree.  Its filename is
     mm-hwpoisonc-fix-held-reference-count-after-unpoisoning-empty-zero-page.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hwpoisonc-fix-held-reference-count-after-unpoisoning-empty-zero-page.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hwpoisonc-fix-held-reference-count-after-unpoisoning-empty-zero-page.patch

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
Subject: mm/hwpoison.c: fix held reference count after unpoisoning empty zero page

madvise hwpoison inject will poison the read-only empty zero page if there
is no write access before poison.  Empty zero page reference count will be
increased for hwpoison, subsequent poison zero page will return directly
since page has already been set PG_hwpoison, however, page reference count
is still increased by get_user_pages_fast.  The unpoison process will
unpoison the empty zero page and decrease the reference count successfully
for the fist time, however, subsequent unpoison empty zero page will
return directly since page has already been unpoisoned and without
decrease the page reference count of empty zero page.

This patch fixes it by make madvise_hwpoison() put a page and return
immediately (without calling memory_failure() or soft_offline_page()) when
the page is already hwpoisoned.

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

Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Suggested-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN mm/madvise.c~mm-hwpoisonc-fix-held-reference-count-after-unpoisoning-empty-zero-page mm/madvise.c
--- a/mm/madvise.c~mm-hwpoisonc-fix-held-reference-count-after-unpoisoning-empty-zero-page
+++ a/mm/madvise.c
@@ -352,6 +352,10 @@ static int madvise_hwpoison(int bhv, uns
 		int ret = get_user_pages_fast(start, 1, 0, &p);
 		if (ret != 1)
 			return ret;
+		if (PageHWPoison(p)) {
+			put_page(p);
+			continue;
+		}
 		if (bhv == MADV_SOFT_OFFLINE) {
 			pr_info("Soft offlining page %#lx at %#lx\n",
 				page_to_pfn(p), start);
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
mm-hwpoisonc-fix-held-reference-count-after-unpoisoning-empty-zero-page.patch
linux-next.patch
mm-drop-actor-argument-of-do_generic_file_read.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch

