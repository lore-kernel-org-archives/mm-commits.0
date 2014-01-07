From: akpm@linux-foundation.org
Subject: + numa-add-a-sysctl-for-numa_balancing-fix.patch added to -mm
 tree
Date: Tue, 07 Jan 2014 13:58:27 -0800
Message-ID: <52cc7883.5GR5szHpmpCat3tc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59560 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754093AbaAGV62 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Jan 2014 16:58:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mingo@elte.hu, mgorman@suse.de, ak@linux.intel.com, akpm@linux-foundation.org

Subject: + numa-add-a-sysctl-for-numa_balancing-fix.patch added to -mm tree
To: akpm@linux-foundation.org,ak@linux.intel.com,mgorman@suse.de,mingo@elte.hu
From: akpm@linux-foundation.org
Date: Tue, 07 Jan 2014 13:58:27 -0800


The patch titled
     Subject: numa-add-a-sysctl-for-numa_balancing-fix
has been added to the -mm tree.  Its filename is
     numa-add-a-sysctl-for-numa_balancing-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/numa-add-a-sysctl-for-numa_balancing-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/numa-add-a-sysctl-for-numa_balancing-fix.patch

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
Subject: numa-add-a-sysctl-for-numa_balancing-fix

s/sched_numa_balancing/sysctl_numa_balancing/

Cc: Andi Kleen <ak@linux.intel.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched/sysctl.h |    2 +-
 kernel/sched/core.c          |    2 +-
 kernel/sysctl.c              |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff -puN include/linux/sched/sysctl.h~numa-add-a-sysctl-for-numa_balancing-fix include/linux/sched/sysctl.h
--- a/include/linux/sched/sysctl.h~numa-add-a-sysctl-for-numa_balancing-fix
+++ a/include/linux/sched/sysctl.h
@@ -100,7 +100,7 @@ extern int sched_rt_handler(struct ctl_t
 		void __user *buffer, size_t *lenp,
 		loff_t *ppos);
 
-extern int sched_numa_balancing(struct ctl_table *table, int write,
+extern int sysctl_numa_balancing(struct ctl_table *table, int write,
 				 void __user *buffer, size_t *lenp,
 				 loff_t *ppos);
 
diff -puN kernel/sched/core.c~numa-add-a-sysctl-for-numa_balancing-fix kernel/sched/core.c
--- a/kernel/sched/core.c~numa-add-a-sysctl-for-numa_balancing-fix
+++ a/kernel/sched/core.c
@@ -1766,7 +1766,7 @@ void set_numabalancing_state(bool enable
 #endif /* CONFIG_SCHED_DEBUG */
 
 #ifdef CONFIG_PROC_SYSCTL
-int sched_numa_balancing(struct ctl_table *table, int write,
+int sysctl_numa_balancing(struct ctl_table *table, int write,
 			 void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	struct ctl_table t;
diff -puN kernel/sysctl.c~numa-add-a-sysctl-for-numa_balancing-fix kernel/sysctl.c
--- a/kernel/sysctl.c~numa-add-a-sysctl-for-numa_balancing-fix
+++ a/kernel/sysctl.c
@@ -401,7 +401,7 @@ static struct ctl_table kern_table[] = {
 		.data		= NULL, /* filled in by handler */
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
-		.proc_handler	= sched_numa_balancing,
+		.proc_handler	= sysctl_numa_balancing,
 		.extra1		= &zero,
 		.extra2		= &one,
 	},
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
dma-debug-enhance-dma_debug_device_change-to-check-for-mapping-errors-fix.patch
input-route-kbd-leds-through-the-generic-leds-layer-fix.patch
drivers-block-ccissc-cciss_init_one-use-proper-errnos.patch
block-blk-mq-cpuc-use-hotcpu_notifier.patch
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
numa-add-a-sysctl-for-numa_balancing-fix.patch
lib-parserc-put-export_symbols-in-the-conventional-place.patch
printk-flush-conflicting-continuation-line-fix.patch
drivers-rtc-rtc-cmosc-propagate-hpet_register_irq_handler-failure.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch
fs-ext3-use-rbtree-postorder-iteration-helper-instead-of-opencoding-fix.patch
ipc-semc-avoid-overflow-of-semop-undo-semadj-value-fix.patch
linux-next.patch
linux-next-git-rejects.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

