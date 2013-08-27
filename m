From: akpm@linux-foundation.org
Subject: +
 mm-memory-failurec-fix-bug-triggered-by-unpoisoning-empty-zero-page.patch
 added to -mm tree
Date: Tue, 27 Aug 2013 14:14:47 -0700
Message-ID: <521d16c7.pTwBEj29AymCiQZw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41230 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742Ab3H0VOs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 27 Aug 2013 17:14:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com, andi@firstfloor.org, liwanp@linux.vnet.ibm.com

Subject: + mm-memory-failurec-fix-bug-triggered-by-unpoisoning-empty-zero-page.patch added to -mm tree
To: liwanp@linux.vnet.ibm.com,andi@firstfloor.org,n-horiguchi@ah.jp.nec.com
From: akpm@linux-foundation.org
Date: Tue, 27 Aug 2013 14:14:47 -0700


The patch titled
     Subject: mm/memory-failure.c: fix bug triggered by unpoisoning empty zero page
has been added to the -mm tree.  Its filename is
     mm-memory-failurec-fix-bug-triggered-by-unpoisoning-empty-zero-page.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memory-failurec-fix-bug-triggered-by-unpoisoning-empty-zero-page.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memory-failurec-fix-bug-triggered-by-unpoisoning-empty-zero-page.patch

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
Subject: mm/memory-failure.c: fix bug triggered by unpoisoning empty zero page

[   57.579580] Injecting memory failure for page 0x19d0 at 0xb77d2000
[   57.579824] MCE 0x19d0: non LRU page recovery: Ignored
[   91.290453] MCE: Software-unpoisoned page 0x19d0
[   91.290456] BUG: Bad page state in process bash  pfn:019d0
[   91.290466] page:f3461a00 count:0 mapcount:0 mapping:  (null) index:0x0
[   91.290467] page flags: 0x40000404(referenced|reserved)
[   91.290469] Modules linked in: nfsd auth_rpcgss i915 nfs_acl nfs lockd video drm_kms_helper drm bnep rfcomm sunrpc bluetooth psmouse parport_pc ppdev lp serio_raw fscache parport gpio_ich lpc_ich mac_hid i2c_algo_bit tpm_tis wmi usb_storage hid_generic usbhid hid e1000e firewire_ohci firewire_core ahci ptp libahci pps_core crc_itu_t
[   91.290486] CPU: 3 PID: 2123 Comm: bash Not tainted 3.11.0-rc6+ #12
[   91.290487] Hardware name: LENOVO 7034DD7/        , BIOS 9HKT47AUS 01//2012
[   91.290488]  00000000 00000000 e9625ea0 c15ec49b f3461a00 e9625eb8 c15ea119 c17cbf18
[   91.290491]  ef084314 000019d0 f3461a00 e9625ed8 c110dc8a f3461a00 00000001 00000000
[   91.290494]  f3461a00 40000404 00000000 e9625ef8 c110dcc1 f3461a00 f3461a00 000019d0
[   91.290497] Call Trace:
[   91.290501]  [<c15ec49b>] dump_stack+0x41/0x52
[   91.290504]  [<c15ea119>] bad_page+0xcf/0xeb
[   91.290515]  [<c110dc8a>] free_pages_prepare+0x12a/0x140
[   91.290517]  [<c110dcc1>] free_hot_cold_page+0x21/0x110
[   91.290519]  [<c11123c1>] __put_single_page+0x21/0x30
[   91.290521]  [<c1112815>] put_page+0x25/0x40
[   91.290524]  [<c11544e7>] unpoison_memory+0x107/0x200
[   91.290526]  [<c104a537>] ? ns_capable+0x27/0x60
[   91.290528]  [<c1155720>] hwpoison_unpoison+0x20/0x30
[   91.290530]  [<c1178266>] simple_attr_write+0xb6/0xd0
[   91.290532]  [<c11781b0>] ? generic_fh_to_dentry+0x50/0x50
[   91.290535]  [<c1158c60>] vfs_write+0xa0/0x1b0
[   91.290537]  [<c11781b0>] ? generic_fh_to_dentry+0x50/0x50
[   91.290539]  [<c11590df>] SyS_write+0x4f/0x90
[   91.290549]  [<c15f9a81>] sysenter_do_call+0x12/0x22
[   91.290550] Disabling lock debugging due to kernel taint

Testcase:

#define _GNU_SOURCE
#include <stdlib.h>
#include <stdio.h>
#include <sys/mman.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/types.h>
#include <errno.h>

#define PAGES_TO_TEST 1
#define PAGE_SIZE	4096

int main(void)
{
	char *mem;

	mem = mmap(NULL, PAGES_TO_TEST * PAGE_SIZE,
			PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, 0, 0);

	if (madvise(mem, PAGES_TO_TEST * PAGE_SIZE, MADV_HWPOISON) == -1)
		return -1;

	munmap(mem, PAGES_TO_TEST * PAGE_SIZE);

	return 0;
}

There is one page reference count for default empty zero page,
madvise_hwpoison add another one by get_user_pages_fast.  memory_hwpoison
reduce one page reference count since it's a non LRU page. 
unpoison_memory release the last page reference count and free empty zero
page to buddy system which is not correct since empty zero page has
PG_reserved flag.  This patch fix it by don't reduce the page reference
count under 1 against empty zero page.

Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memory-failure.c~mm-memory-failurec-fix-bug-triggered-by-unpoisoning-empty-zero-page mm/memory-failure.c
--- a/mm/memory-failure.c~mm-memory-failurec-fix-bug-triggered-by-unpoisoning-empty-zero-page
+++ a/mm/memory-failure.c
@@ -1385,7 +1385,7 @@ int unpoison_memory(unsigned long pfn)
 	unlock_page(page);
 
 	put_page(page);
-	if (freeit)
+	if (freeit && !(pfn == my_zero_pfn(0) && page_count(p) == 1))
 		put_page(page);
 
 	return 0;
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
mm-hwpoison-injectc-change-permission-of-corrupt-pfn-unpoison-pfn-to-0200.patch
mm-memory-failurec-fix-bug-triggered-by-unpoisoning-empty-zero-page.patch
linux-next.patch
mm-drop-actor-argument-of-do_generic_file_read.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch

