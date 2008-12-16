From: akpm@linux-foundation.org
Subject: + irq-enclose-irq_desc_lock_class-in-config_sparse_irq.patch added to -mm tree
Date: Tue, 16 Dec 2008 00:35:05 -0800
Message-ID: <200812160835.mBG8Z5Jt011313@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48350 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750855AbYLPIfU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Dec 2008 03:35:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, mingo@elte.hu, yhlu.kernel@gmail.com


The patch titled
     irq: enclose irq_desc_lock_class in CONFIG_SPARSE_IRQ
has been added to the -mm tree.  Its filename is
     irq-enclose-irq_desc_lock_class-in-config_sparse_irq.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: irq: enclose irq_desc_lock_class in CONFIG_SPARSE_IRQ
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

commit 08678b0841267c1d00d771fe01548d86043d065e introduced
irq_desc_lock_class variable.
But it is used only if CONFIG_SPARSE_IRQ=Y.
otherwise, following warnings happend.

	  CC      kernel/irq/handle.o
	kernel/irq/handle.c:26: warning: 'irq_desc_lock_class' defined but not used

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/irq/handle.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff -puN kernel/irq/handle.c~irq-enclose-irq_desc_lock_class-in-config_sparse_irq kernel/irq/handle.c
--- a/kernel/irq/handle.c~irq-enclose-irq_desc_lock_class-in-config_sparse_irq
+++ a/kernel/irq/handle.c
@@ -13,6 +13,7 @@
 #include <linux/irq.h>
 #include <linux/module.h>
 #include <linux/random.h>
+#include <linux/lockdep.h>
 #include <linux/interrupt.h>
 #include <linux/kernel_stat.h>
 #include <linux/rculist.h>
@@ -20,11 +21,6 @@
 
 #include "internals.h"
 
-/*
- * lockdep: we want to handle all irq_desc locks as a single lock-class:
- */
-static struct lock_class_key irq_desc_lock_class;
-
 /**
  * handle_bad_irq - handle spurious and unhandled irqs
  * @irq:       the interrupt number
@@ -61,6 +57,12 @@ void __init __attribute__((weak)) arch_e
 }
 
 #ifdef CONFIG_SPARSE_IRQ
+
+/*
+ * lockdep: we want to handle all irq_desc locks as a single lock-class:
+ */
+static struct lock_class_key irq_desc_lock_class;
+
 static struct irq_desc irq_desc_init = {
 	.irq	    = -1,
 	.status	    = IRQ_DISABLED,
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

mm-dont-touch-uninitialized-variable-in-do_pages_stat_array.patch
linux-next.patch
proc-enclose-desc-variable-of-show_stat-in-config_sparse_irq.patch
irq-enclose-irq_desc_lock_class-in-config_sparse_irq.patch
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
remove-linux-hardirqh-from-asm-generic-localh-add-include-linux-irqflagsh-to-acpi-processor_idlec.patch
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

