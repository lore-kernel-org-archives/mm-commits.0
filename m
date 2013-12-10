From: akpm@linux-foundation.org
Subject: + sched-add-tracepoints-related-to-numa-task-migration-fix.patch
 added to -mm tree
Date: Tue, 10 Dec 2013 14:23:58 -0800
Message-ID: <52a7947e.PHXBEvG2w7CPmkZY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40798 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028Ab3LJWX7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Dec 2013 17:23:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, mgorman@suse.de, athorlton@sgi.com, akpm@linux-foundation.org

Subject: + sched-add-tracepoints-related-to-numa-task-migration-fix.patch added to -mm tree
To: akpm@linux-foundation.org,athorlton@sgi.com,mgorman@suse.de,riel@redhat.com
From: akpm@linux-foundation.org
Date: Tue, 10 Dec 2013 14:23:58 -0800


The patch titled
     Subject: sched-add-tracepoints-related-to-numa-task-migration-fix
has been added to the -mm tree.  Its filename is
     sched-add-tracepoints-related-to-numa-task-migration-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/sched-add-tracepoints-related-to-numa-task-migration-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/sched-add-tracepoints-related-to-numa-task-migration-fix.patch

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
Subject: sched-add-tracepoints-related-to-numa-task-migration-fix

remove semicolon-after-if, repair coding-style

Cc: Alex Thorlton <athorlton@sgi.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched/fair.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN kernel/sched/fair.c~sched-add-tracepoints-related-to-numa-task-migration-fix kernel/sched/fair.c
--- a/kernel/sched/fair.c~sched-add-tracepoints-related-to-numa-task-migration-fix
+++ a/kernel/sched/fair.c
@@ -1272,12 +1272,14 @@ static int task_numa_migrate(struct task
 	p->numa_scan_period = task_scan_min(p);
 
 	if (env.best_task == NULL) {
-		if ((ret = migrate_task_to(p, env.best_cpu)) != 0)
+		ret = migrate_task_to(p, env.best_cpu);
+		if (ret != 0)
 			trace_sched_stick_numa(p, env.src_cpu, env.best_cpu);
 		return ret;
 	}
 
-	if ((ret = migrate_swap(p, env.best_task)) != 0);
+	ret = migrate_swap(p, env.best_task);
+	if (ret != 0)
 		trace_sched_stick_numa(p, env.src_cpu, task_cpu(env.best_task));
 	put_task_struct(env.best_task);
 	return ret;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
procfs-also-fix-proc_reg_get_unmapped_area-for-mmu-case-fix.patch
dma-debug-enhance-dma_debug_device_change-to-check-for-mapping-errors-fix.patch
input-route-kbd-leds-through-the-generic-leds-layer-fix.patch
drivers-block-ccissc-cciss_init_one-use-proper-errnos.patch
block-blk-mq-cpuc-use-hotcpu_notifier.patch
mtd-cmdlinepart-use-cmdline-partition-parser-lib-fix-fix.patch
posix_acl-uninlining.patch
mm.patch
mm-hugetlbc-simplify-pageheadhuge-and-pagehuge.patch
mm-swapc-reorganize-put_compound_page.patch
mm-get-rid-of-unnecessary-pageblock-scanning-in-setup_zone_migrate_reserve-fix.patch
mm-memory-failure-fix-the-typo-in-me_pagecache_dirty-fix.patch
mm-add-overcommit_kbytes-sysctl-variable-checkpatch-fixes.patch
mm-add-overcommit_kbytes-sysctl-variable-fix.patch
memblock-mem_hotplug-introduce-memblock_hotplug-flag-to-mark-hotpluggable-regions-checkpatch-fixes.patch
acpi-numa-mem_hotplug-mark-hotpluggable-memory-in-memblock-checkpatch-fixes.patch
memblock-mem_hotplug-make-memblock-skip-hotpluggable-regions-if-needed-checkpatch-fixes.patch
mm-memblock-add-memblock-memory-allocation-apis-fix.patch
sched-add-tracepoints-related-to-numa-task-migration-fix.patch
lib-parserc-put-export_symbols-in-the-conventional-place.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch
fs-ext3-use-rbtree-postorder-iteration-helper-instead-of-opencoding-fix.patch
ipc-semc-avoid-overflow-of-semop-undo-semadj-value-fix.patch
linux-next.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

