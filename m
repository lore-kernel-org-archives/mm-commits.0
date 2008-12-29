From: akpm@linux-foundation.org
Subject: - irq-remove-unnecessary-ifdef.patch removed from -mm tree
Date: Mon, 29 Dec 2008 11:19:27 -0800
Message-ID: <200812291919.mBTJJR0J031692@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51070 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751870AbYL2TUE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Dec 2008 14:20:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, mingo@elte.hu, yhlu.kernel@gmail.com, mm-commits@vger.kernel.org


The patch titled
     irq: remove unnecessary ifdef
has been removed from the -mm tree.  Its filename was
     irq-remove-unnecessary-ifdef.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: irq: remove unnecessary ifdef
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

commit 08678b0841267c1d00d771fe01548d86043d065e introduced
irq_desc_lock_class variable.

But it is used only if CONFIG_SPARSE_IRQ=Y or CONFIG_TRACE_IRQFLAGS=Y. 
otherwise, following warnings happend.

	CC      kernel/irq/handle.o
	kernel/irq/handle.c:26: warning: 'irq_desc_lock_class' defined but not used

Actually, current early_init_irq_lock_class has a bit strange and messy
ifdef.  In addition, it is not valueable.

1 this function protected by !CONFIG_SPARSE_IRQ.  but it is not
  necessary.  if CONFIG_SPARSE_IRQ=Y, desc of all irq number are
  initialized by NULL at first.  then this function calling is safe.

2 this function protected by CONFIG_TRACE_IRQFLAGS too.  but it is
  not necessary too.  because lockdep_set_class() doesn't have bad side
  effect even if CONFIG_TRACE_IRQFLAGS=n,

This patch bloat kernel size a bit on CONFIG_TRACE_IRQFLAGS=n and
CONFIG_SPARSE_IRQ=Y.  that's ok.  early_init_irq_lock_class() is not
fastpatch at all.

To avoid ifdef mess is more important than a few byte diet.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/lockdep.h |    2 +-
 kernel/irq/handle.c     |    5 -----
 2 files changed, 1 insertion(+), 6 deletions(-)

diff -puN include/linux/lockdep.h~irq-remove-unnecessary-ifdef include/linux/lockdep.h
--- a/include/linux/lockdep.h~irq-remove-unnecessary-ifdef
+++ a/include/linux/lockdep.h
@@ -390,7 +390,7 @@ do {								\
 
 #endif /* CONFIG_LOCK_STAT */
 
-#if defined(CONFIG_TRACE_IRQFLAGS) && defined(CONFIG_GENERIC_HARDIRQS)
+#ifdef CONFIG_GENERIC_HARDIRQS
 extern void early_init_irq_lock_class(void);
 #else
 static inline void early_init_irq_lock_class(void)
diff -puN kernel/irq/handle.c~irq-remove-unnecessary-ifdef kernel/irq/handle.c
--- a/kernel/irq/handle.c~irq-remove-unnecessary-ifdef
+++ a/kernel/irq/handle.c
@@ -417,11 +417,8 @@ out:
 }
 #endif
 
-
-#ifdef CONFIG_TRACE_IRQFLAGS
 void early_init_irq_lock_class(void)
 {
-#ifndef CONFIG_SPARSE_IRQ
 	struct irq_desc *desc;
 	int i;
 
@@ -431,9 +428,7 @@ void early_init_irq_lock_class(void)
 
 		lockdep_set_class(&desc->lock, &irq_desc_lock_class);
 	}
-#endif
 }
-#endif
 
 #ifdef CONFIG_SPARSE_IRQ
 unsigned int kstat_irqs_cpu(unsigned int irq, int cpu)
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
fs-symlink-write_begin-allocation-context-fix.patch
fs-symlink-write_begin-allocation-context-fix-ubifs-fix.patch
fs-symlink-write_begin-allocation-context-fix-fuse-fix.patch
linux-next.patch
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
mm-make-get_user_pages-interruptible-mmotm-ignore-sigkill-in-get_user_pages-during-munlock.patch
introduce-get_mm_hiwater_xxx-fix-taskstats-hiwater_xxx-accounting.patch
mm-remove-config_out_of_line_pfn_to_page.patch
mm-kill-page_queue_congested.patch
remove-linux-hardirqh-from-asm-generic-localh-add-include-linux-irqflagsh-to-acpi-processor_idlec.patch
sys_execve-and-sys_uselib-do-not-call-into-fsnotify.patch
profile-dont-include-asm-ptraceh-twice.patch
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
ia64-implement-interrupt-enabling-rwlocks-fix.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch

