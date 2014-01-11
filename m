From: akpm@linux-foundation.org
Subject: +
 mm-swap-fix-race-on-swap_info-reuse-between-swapoff-and-swapon-fix.patch
 added to -mm tree
Date: Fri, 10 Jan 2014 16:39:52 -0800
Message-ID: <52d092d8.gd638UcECRh4Efu/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33935 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983AbaAKAjx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 10 Jan 2014 19:39:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, weijie.yang@samsung.com, hughd@google.com, akpm@linux-foundation.org

Subject: + mm-swap-fix-race-on-swap_info-reuse-between-swapoff-and-swapon-fix.patch added to -mm tree
To: akpm@linux-foundation.org,hughd@google.com,weijie.yang@samsung.com
From: akpm@linux-foundation.org
Date: Fri, 10 Jan 2014 16:39:52 -0800


The patch titled
     Subject: mm-swap-fix-race-on-swap_info-reuse-between-swapoff-and-swapon-fix
has been added to the -mm tree.  Its filename is
     mm-swap-fix-race-on-swap_info-reuse-between-swapoff-and-swapon-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-swap-fix-race-on-swap_info-reuse-between-swapoff-and-swapon-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-swap-fix-race-on-swap_info-reuse-between-swapoff-and-swapon-fix.patch

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
Subject: mm-swap-fix-race-on-swap_info-reuse-between-swapoff-and-swapon-fix

tidy up code comment

Cc: Hugh Dickins <hughd@google.com>
Cc: Weijie Yang <weijie.yang@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN mm/swapfile.c~mm-swap-fix-race-on-swap_info-reuse-between-swapoff-and-swapon-fix mm/swapfile.c
--- a/mm/swapfile.c~mm-swap-fix-race-on-swap_info-reuse-between-swapoff-and-swapon-fix
+++ a/mm/swapfile.c
@@ -1949,10 +1949,10 @@ SYSCALL_DEFINE1(swapoff, const char __us
 	filp_close(swap_file, NULL);
 
 	/*
-	* clear SWP_USED flag after all resources freed
-	* so that swapon can reuse this swap_info in alloc_swap_info() safely
-	* it is ok to not hold p->lock after we cleared its SWP_WRITEOK
-	*/
+	 * Clear the SWP_USED flag after all resources are freed so that swapon
+	 * can reuse this swap_info in alloc_swap_info() safely.  It is ok to
+	 * not hold p->lock after we cleared its SWP_WRITEOK.
+	 */
 	spin_lock(&swap_lock);
 	p->flags = 0;
 	spin_unlock(&swap_lock);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
input-route-kbd-leds-through-the-generic-leds-layer-fix.patch
drivers-block-ccissc-cciss_init_one-use-proper-errnos.patch
posix_acl-uninlining.patch
mm.patch
mm-hugetlbfs-move-the-put-get_page-slab-and-hugetlbfs-optimization-in-a-faster-path-fix-2.patch
mm-hugetlbc-simplify-pageheadhuge-and-pagehuge.patch
mm-swapc-reorganize-put_compound_page.patch
mm-get-rid-of-unnecessary-pageblock-scanning-in-setup_zone_migrate_reserve-fix.patch
mm-memory-failure-fix-the-typo-in-me_pagecache_dirty-fix.patch
mm-show_mem-remove-show_mem_filter_page_count-fix.patch
mm-add-overcommit_kbytes-sysctl-variable-checkpatch-fixes.patch
mm-add-overcommit_kbytes-sysctl-variable-fix.patch
mm-add-overcommit_kbytes-sysctl-variable-fix-2.patch
memblock-mem_hotplug-introduce-memblock_hotplug-flag-to-mark-hotpluggable-regions-checkpatch-fixes.patch
acpi-numa-mem_hotplug-mark-hotpluggable-memory-in-memblock-checkpatch-fixes.patch
memblock-mem_hotplug-make-memblock-skip-hotpluggable-regions-if-needed-checkpatch-fixes.patch
mm-memblock-add-memblock-memory-allocation-apis-fix.patch
sched-add-tracepoints-related-to-numa-task-migration-fix.patch
mm-page_alloc-warn-for-non-blockable-__gfp_nofail-allocation-failure.patch
mm-print-more-details-for-bad_page-fix.patch
mm-munlock-fix-potential-race-with-thp-page-split-fix.patch
mm-dump-page-when-hitting-a-vm_bug_on-using-vm_bug_on_page-fix-fix.patch
memcg-slab-kmem_cache_create_memcg-fix-memleak-on-fail-path-fix.patch
numa-add-a-sysctl-for-numa_balancing-fix.patch
mm-swap-fix-race-on-swap_info-reuse-between-swapoff-and-swapon-fix.patch
lib-parserc-put-export_symbols-in-the-conventional-place.patch
printk-flush-conflicting-continuation-line-fix.patch
lib-percpu_counterc-disable-local-irq-when-updating-percpu-couter.patch
drivers-rtc-rtc-cmosc-propagate-hpet_register_irq_handler-failure.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch
fs-ext3-use-rbtree-postorder-iteration-helper-instead-of-opencoding-fix.patch
ipc-semc-avoid-overflow-of-semop-undo-semadj-value-fix.patch
linux-next.patch
net-ipv6-ip6_vtic-fix-build.patch
block-blk-mq-cpuc-use-hotcpu_notifier.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

