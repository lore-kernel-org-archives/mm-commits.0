From: akpm@linux-foundation.org
Subject: +
 drivers-staging-lustre-lustre-ptlrpc-sec_bulkc-rename-ptrs_per_page.patch
 added to -mm tree
Date: Wed, 11 Sep 2013 13:37:55 -0700
Message-ID: <5230d4a3.2EzOPQGt1ECRJyol%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48655 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755650Ab3IKUh4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Sep 2013 16:37:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tao.peng@emc.com, gregkh@linuxfoundation.org, andreas.dilger@intel.com, akpm@linux-foundation.org

Subject: + drivers-staging-lustre-lustre-ptlrpc-sec_bulkc-rename-ptrs_per_page.patch added to -mm tree
To: akpm@linux-foundation.org,andreas.dilger@intel.com,gregkh@linuxfoundation.org,tao.peng@emc.com
From: akpm@linux-foundation.org
Date: Wed, 11 Sep 2013 13:37:55 -0700


The patch titled
     Subject: drivers/staging/lustre/lustre/ptlrpc/sec_bulk.c: rename PTRS_PER_PAGE
has been added to the -mm tree.  Its filename is
     drivers-staging-lustre-lustre-ptlrpc-sec_bulkc-rename-ptrs_per_page.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-staging-lustre-lustre-ptlrpc-sec_bulkc-rename-ptrs_per_page.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-staging-lustre-lustre-ptlrpc-sec_bulkc-rename-ptrs_per_page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: drivers/staging/lustre/lustre/ptlrpc/sec_bulk.c: rename PTRS_PER_PAGE

It duplicates the definition in arch/alpha/include/asm/pgtable.h and emits
warnings.

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Andreas Dilger <andreas.dilger@intel.com>
Cc: Peng Tao <tao.peng@emc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/lustre/lustre/ptlrpc/sec_bulk.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/staging/lustre/lustre/ptlrpc/sec_bulk.c~drivers-staging-lustre-lustre-ptlrpc-sec_bulkc-rename-ptrs_per_page drivers/staging/lustre/lustre/ptlrpc/sec_bulk.c
--- a/drivers/staging/lustre/lustre/ptlrpc/sec_bulk.c~drivers-staging-lustre-lustre-ptlrpc-sec_bulkc-rename-ptrs_per_page
+++ a/drivers/staging/lustre/lustre/ptlrpc/sec_bulk.c
@@ -59,8 +59,8 @@
  ****************************************/
 
 
-#define PTRS_PER_PAGE   (PAGE_CACHE_SIZE / sizeof(void *))
-#define PAGES_PER_POOL  (PTRS_PER_PAGE)
+#define POINTERS_PER_PAGE	(PAGE_CACHE_SIZE / sizeof(void *))
+#define PAGES_PER_POOL		(POINTERS_PER_PAGE)
 
 #define IDLE_IDX_MAX	    (100)
 #define IDLE_IDX_WEIGHT	 (3)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
revert-include-linux-smph-on_each_cpu-switch-back-to-a-macro.patch
block-support-embedded-device-command-line-partition.patch
swap-warn-when-a-swap-area-overflows-the-maximum-size-fix.patch
mm-swapfilec-convert-to-pr_foo.patch
mm-vmstats-track-tlb-flush-stats-on-up-too-fix.patch
swap-make-swap-discard-async-checkpatch-fixes.patch
swap-make-cluster-allocation-per-cpu-checkpatch-fixes.patch
mm-page_alloc-restructure-free-page-stealing-code-and-fix-a-bug-fix.patch
mm-hugetlb-decrement-reserve-count-if-vm_noreserve-alloc-page-cache-fix.patch
mm-mempolicy-return-null-if-node-is-numa_no_node-in-get_task_policy.patch
vmstat-create-separate-function-to-fold-per-cpu-diffs-into-local-counters-fix.patch
genalloc-fix-overflow-of-ending-address-of-memory-chunk-fix.patch
mm-use-zone_end_pfn-instead-of-zone_start_pfnspanned_pages-fix.patch
mm-hotplug-verify-hotplug-memory-range-fix.patch
mm-fix-aio-performance-regression-for-database-caused-by-thp-fix.patch
mm-track-vma-changes-with-vm_softdirty-bit-fix.patch
mm-munlock-bypass-per-cpu-pvec-for-putback_lru_page-fix.patch
mm-vmscan-fix-do_try_to_free_pages-livelock-fix.patch
mm-vmscan-fix-do_try_to_free_pages-livelock-fix-2.patch
mm-page-writebackc-add-strictlimit-feature-fix.patch
mm-madvisec-madvise_hwpoison-remove-local-ret.patch
lib-crc32-update-the-comments-of-crc32_bele_generic-checkpatch-fixes.patch
move-exit_task_namespaces-outside-of-exit_notify-fix.patch
partitions-efi-use-lba-aware-partition-records-checkpatch-fixes.patch
partitions-efi-check-pmbr-records-starting-lba-checkpatch-fixes.patch
partitions-efi-detect-hybrid-mbrs-checkpatch-fixes.patch
partitions-efi-some-style-cleanups-checkpatch-fixes.patch
block-partitions-efic-consistently-use-pr_foo.patch
initmpfs-move-bdi-setup-from-init_rootfs-to-init_ramfs-fix.patch
initmpfs-use-initramfs-if-rootfstype=-or-root=-specified-checkpatch-fixes.patch
ipc-drop-ipcctl_pre_down-fix.patch
ipcshm-make-shmctl_nolock-lockless-checkpatch-fixes.patch
drivers-staging-lustre-lustre-ptlrpc-sec_bulkc-rename-ptrs_per_page.patch

