From: akpm@linux-foundation.org
Subject: +
 mm-hwpoison-injectc-change-permission-of-corrupt-pfn-unpoison-pfn-to-0200.patch added to -mm tree
Date: Tue, 27 Aug 2013 14:13:52 -0700
Message-ID: <521d1690.3f+I82y/TIaDrQQo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41146 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752303Ab3H0VNx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 27 Aug 2013 17:13:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com, andi@firstfloor.org, liwanp@linux.vnet.ibm.com

Subject: + mm-hwpoison-injectc-change-permission-of-corrupt-pfn-unpoison-pfn-to-0200.patch added to -mm tree
To: liwanp@linux.vnet.ibm.com,andi@firstfloor.org,n-horiguchi@ah.jp.nec.com
From: akpm@linux-foundation.org
Date: Tue, 27 Aug 2013 14:13:52 -0700


The patch titled
     Subject: mm/hwpoison-inject.c: change permission of corrupt-pfn/unpoison-pfn to 0200
has been added to the -mm tree.  Its filename is
     mm-hwpoison-injectc-change-permission-of-corrupt-pfn-unpoison-pfn-to-0200.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hwpoison-injectc-change-permission-of-corrupt-pfn-unpoison-pfn-to-0200.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hwpoison-injectc-change-permission-of-corrupt-pfn-unpoison-pfn-to-0200.patch

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
Subject: mm/hwpoison-inject.c: change permission of corrupt-pfn/unpoison-pfn to 0200

Hwpoison injection doesn't implement read method for
corrupt-pfn/unpoison-pfn attributes:

# cat /sys/kernel/debug/hwpoison/corrupt-pfn
cat: /sys/kernel/debug/hwpoison/corrupt-pfn: Permission denied
# cat /sys/kernel/debug/hwpoison/unpoison-pfn
cat: /sys/kernel/debug/hwpoison/unpoison-pfn: Permission denied

This patch changes the permission of corrupt-pfn/unpoison-pfn to 0200.

Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hwpoison-inject.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/hwpoison-inject.c~mm-hwpoison-injectc-change-permission-of-corrupt-pfn-unpoison-pfn-to-0200 mm/hwpoison-inject.c
--- a/mm/hwpoison-inject.c~mm-hwpoison-injectc-change-permission-of-corrupt-pfn-unpoison-pfn-to-0200
+++ a/mm/hwpoison-inject.c
@@ -88,12 +88,12 @@ static int pfn_inject_init(void)
 	 * hardware status change, hence do not require hardware support.
 	 * They are mainly for testing hwpoison in software level.
 	 */
-	dentry = debugfs_create_file("corrupt-pfn", 0600, hwpoison_dir,
+	dentry = debugfs_create_file("corrupt-pfn", 0200, hwpoison_dir,
 					  NULL, &hwpoison_fops);
 	if (!dentry)
 		goto fail;
 
-	dentry = debugfs_create_file("unpoison-pfn", 0600, hwpoison_dir,
+	dentry = debugfs_create_file("unpoison-pfn", 0200, hwpoison_dir,
 				     NULL, &unpoison_fops);
 	if (!dentry)
 		goto fail;
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
linux-next.patch
mm-drop-actor-argument-of-do_generic_file_read.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch

