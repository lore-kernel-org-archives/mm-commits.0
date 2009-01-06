From: akpm@linux-foundation.org
Subject: - remove-linux-hardirqh-from-asm-generic-localh-add-include-linux-irqflagsh-to-acpi-processor_idlec.patch removed from -mm tree
Date: Tue, 06 Jan 2009 12:26:23 -0800
Message-ID: <200901062026.n06KQNo4021709@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60688 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751073AbZAFU0o (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Jan 2009 15:26:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, rmk+kernel@arm.linux.org.uk, rostedt@goodmis.org, mm-commits@vger.kernel.org


The patch titled
     Add #include <linux/irqflags.h> to acpi/processor_idle.c
has been removed from the -mm tree.  Its filename was
     remove-linux-hardirqh-from-asm-generic-localh-add-include-linux-irqflagsh-to-acpi-processor_idlec.patch

This patch was dropped because it was folded into remove-linux-hardirqh-from-asm-generic-localh.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Add #include <linux/irqflags.h> to acpi/processor_idle.c
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Applied after: remove-linux-hardirqh-from-asm-generic-localh.patch

=
Subject: [mmotm][PATCH] Add #include <linux/irqflags.h> to acpi/processor_idle.c

In past, processor_idle.c include irqflags.h indirectly via local.h.
But now, its inclusion was removed.

Then following build error happend.

	  CC [M]  drivers/acpi/processor_idle.o
	drivers/acpi/processor_idle.c: In function 'acpi_cstate_enter':
	drivers/acpi/processor_idle.c:275: error: implicit declaration of function 'stop_critical_timings'
	drivers/acpi/processor_idle.c:288: error: implicit declaration of function 'start_critical_timings'
	make[1]: *** [drivers/acpi/processor_idle.o] Error 1
	make: *** [drivers/acpi/processor_idle.o] Error 2

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/processor_idle.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/acpi/processor_idle.c~remove-linux-hardirqh-from-asm-generic-localh-add-include-linux-irqflagsh-to-acpi-processor_idlec drivers/acpi/processor_idle.c
--- a/drivers/acpi/processor_idle.c~remove-linux-hardirqh-from-asm-generic-localh-add-include-linux-irqflagsh-to-acpi-processor_idlec
+++ a/drivers/acpi/processor_idle.c
@@ -41,6 +41,7 @@
 #include <linux/pm_qos_params.h>
 #include <linux/clockchips.h>
 #include <linux/cpuidle.h>
+#include <linux/irqflags.h>
 
 /*
  * Include the apic definitions for x86 to have the APIC timer related defines
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
mm-report-the-pagesize-backing-a-vma-in-proc-pid-smaps.patch
mm-report-the-mmu-pagesize-in-proc-pid-smaps.patch
oom-fix-zone_scan_mutex-name.patch
mm-get-rid-of-pagevec_release_nonlru.patch
cleanup-get-rid-of-ifdef-config_migration.patch
mm-more-likely-reclaim-madv_sequential-mappings.patch
mm-make-page_lock_anon_vma-static.patch
memcg-reclaim-shouldnt-change-zone-recent_rotated-statistics.patch
mm-make-init_section_page_cgroup-static.patch
mm-make-maddr-__iomem.patch
mm-make-mem_cgroup_resize_limit-static.patch
mm-make-scan_all_zones_unevictable_pages-static.patch
mm-make-scan_zone_unevictable_pages-static.patch
mm-make-setup_per_zone_inactive_ratio-static.patch
mm-make-vread-and-vwrite-declaration.patch
vmscan-bail-out-of-direct-reclaim-after-swap_cluster_max-pages.patch
vmscan-improve-reclaim-throughput-to-bail-out-patch.patch
mm-kill-zone_is_near_oom.patch
mm-make-get_user_pages-interruptible.patch
introduce-get_mm_hiwater_xxx-fix-taskstats-hiwater_xxx-accounting.patch
mm-remove-config_out_of_line_pfn_to_page.patch
mm-kill-page_queue_congested.patch
mm-stop-kswapds-infinite-loop-at-high-order-allocation-take2.patch
remove-linux-hardirqh-from-asm-generic-localh.patch
remove-linux-hardirqh-from-asm-generic-localh-add-include-linux-irqflagsh-to-acpi-processor_idlec.patch
profile-dont-include-asm-ptraceh-twice.patch
getrusage-fill-ru_maxrss-value.patch
softirq-introduce-statistics-for-softirq.patch
proc-export-statistics-for-softirq-to-proc.patch
proc-update-document-for-proc-softirqs-and-proc-stat.patch
devices-cgroup-allow-mkfifo.patch
memcg-new-force_empty-to-free-pages-under-group-fix.patch
memcg-new-force_empty-to-free-pages-under-group-fix-fix.patch
memcg-revert-gfp-mask-fix.patch
memcg-check-group-leader-fix.patch
memcg-memoryswap-controller-fix-limit-check.patch
memcg-swapout-refcnt-fix.patch
memcg-hierarchy-avoid-unnecessary-reclaim.patch
inactive_anon_is_low-move-to-vmscan.patch
mm-introduce-zone_reclaim-struct.patch
mm-add-zone-nr_pages-helper-function.patch
mm-make-get_scan_ratio-safe-for-memcg.patch
memcg-add-null-check-to-page_cgroup_zoneinfo.patch
memcg-add-inactive_anon_is_low.patch
memcg-add-inactive_anon_is_low-vmscan-style-cleanup.patch
memcg-add-mem_cgroup_zone_nr_pages.patch
memcg-add-zone_reclaim_stat.patch
memcg-add-zone_reclaim_stat-reclaim-stat-trivial-fixes.patch
memcg-add-zone_reclaim_stat-reclaim-stat-trivial-fixes-fix.patch
memcg-remove-mem_cgroup_cal_reclaim.patch
memcg-show-reclaim-stat.patch
memcg-rename-scan-global-lru.patch
memcg-protect-prev_priority.patch
memcg-swappiness.patch
memcg-fix-calclation-of-active_ratio.patch
memcg-fix-calclation-of-active_ratio-build-error-fix.patch
memcg-show-real-limit-under-hierarchy-mode.patch
memcg-explain-details-and-test-document.patch
coredump_filter-permit-changing-of-the-default-filter.patch
ia64-implement-interrupt-enabling-rwlocks-fix.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch

