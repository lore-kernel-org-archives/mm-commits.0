From: akpm@linux-foundation.org
Subject: +
 mm-fix-aio-performance-regression-for-database-caused-by-thp-fix.patch
 added to -mm tree
Date: Thu, 15 Aug 2013 14:16:26 -0700
Message-ID: <520d452a.UOQxy2+ZhYA7y/oc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42681 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752017Ab3HOVQ1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 15 Aug 2013 17:16:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, khalid.aziz@oracle.com, akpm@linux-foundation.org

Subject: + mm-fix-aio-performance-regression-for-database-caused-by-thp-fix.patch added to -mm tree
To: akpm@linux-foundation.org,khalid.aziz@oracle.com
From: akpm@linux-foundation.org
Date: Thu, 15 Aug 2013 14:16:26 -0700


The patch titled
     Subject: mm-fix-aio-performance-regression-for-database-caused-by-thp-fix
has been added to the -mm tree.  Its filename is
     mm-fix-aio-performance-regression-for-database-caused-by-thp-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fix-aio-performance-regression-for-database-caused-by-thp-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-aio-performance-regression-for-database-caused-by-thp-fix.patch

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
Subject: mm-fix-aio-performance-regression-for-database-caused-by-thp-fix

tweak comments

Cc: Khalid Aziz <khalid.aziz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN mm/swap.c~mm-fix-aio-performance-regression-for-database-caused-by-thp-fix mm/swap.c
--- a/mm/swap.c~mm-fix-aio-performance-regression-for-database-caused-by-thp-fix
+++ a/mm/swap.c
@@ -83,9 +83,9 @@ static void __put_compound_page(struct p
 static void put_compound_page(struct page *page)
 {
 	/*
-	 * hugetlbfs pages can not be split from under us. If this
-	 * is a hugetlbfs page, check refcount on head page and release
-	 * the page if refcount is zero.
+	 * hugetlbfs pages cannot be split from under us.  If this is a
+	 * hugetlbfs page, check refcount on head page and release the page if
+	 * the refcount becomes zero.
 	 */
 	if (PageHuge(page)) {
 		page = compound_head(page);
@@ -202,8 +202,8 @@ bool __get_page_tail(struct page *page)
 	struct page *page_head;
 
 	/*
-	 * If this is a hugetlbfs page, it can not be split under
-	 * us. Simply increment refcount for head page
+	 * If this is a hugetlbfs page it cannot be split under us.  Simply
+	 * increment refcount for the head page.
 	 */
 	if (PageHuge(page)) {
 		page_head = compound_head(page);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
revert-include-linux-smph-on_each_cpu-switch-back-to-a-macro.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
block-support-embedded-device-command-line-partition.patch
mm.patch
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
lib-crc32-update-the-comments-of-crc32_bele_generic-checkpatch-fixes.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
fat-additions-to-support-fat_fallocate-fix.patch
move-exit_task_namespaces-outside-of-exit_notify-fix.patch
initmpfs-move-bdi-setup-from-init_rootfs-to-init_ramfs-fix.patch
initmpfs-use-initramfs-if-rootfstype=-or-root=-specified-checkpatch-fixes.patch
ipc-drop-ipcctl_pre_down-fix.patch
ipcshm-make-shmctl_nolock-lockless-checkpatch-fixes.patch
linux-next.patch
revert-selinux-do-not-handle-seclabel-as-a-special-flag.patch
memcg-trivial-cleanups.patch
shrinker-convert-superblock-shrinkers-to-new-api-fix.patch
xfs-convert-buftarg-lru-to-generic-code-fix.patch
xfs-convert-dquot-cache-lru-to-list_lru-fix.patch
fs-convert-fs-shrinkers-to-new-scan-count-api-fix.patch
fs-convert-fs-shrinkers-to-new-scan-count-api-fix-fix-2.patch
drivers-convert-shrinkers-to-new-count-scan-api-fix.patch
drivers-convert-shrinkers-to-new-count-scan-api-fix-2.patch
shrinker-convert-remaining-shrinkers-to-count-scan-api-fix.patch
hugepage-convert-huge-zero-page-shrinker-to-new-shrinker-api-fix.patch
shrinker-kill-old-shrink-api-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

