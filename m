From: akpm@linux-foundation.org
Subject: - oom-move-prototypes-to-appropriate-header-file.patch removed from -mm tree
Date: Wed, 17 Oct 2007 23:51:35 -0700
Message-ID: <200710180651.l9I6pZKT030202@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34472 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761515AbXJRHrO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:47:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, andrea@suse.de, clameter@sgi.com, clg@fr.ibm.com, mm-commits@vger.kernel.org


The patch titled
     oom: move prototypes to appropriate header file
has been removed from the -mm tree.  Its filename was
     oom-move-prototypes-to-appropriate-header-file.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: oom: move prototypes to appropriate header file
From: David Rientjes <rientjes@google.com>

Move the OOM killer's extern function prototypes to include/linux/oom.h and
include it where necessary.

[clg@fr.ibm.com: build fix]
Cc: Andrea Arcangeli <andrea@suse.de>
Acked-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Cedric Le Goater <clg@fr.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/mm/cmm.c   |    1 +
 drivers/char/sysrq.c |    1 +
 include/linux/oom.h  |   11 ++++++++++-
 include/linux/swap.h |    5 -----
 mm/page_alloc.c      |    1 +
 5 files changed, 13 insertions(+), 6 deletions(-)

diff -puN arch/s390/mm/cmm.c~oom-move-prototypes-to-appropriate-header-file arch/s390/mm/cmm.c
--- a/arch/s390/mm/cmm.c~oom-move-prototypes-to-appropriate-header-file
+++ a/arch/s390/mm/cmm.c
@@ -17,6 +17,7 @@
 #include <linux/ctype.h>
 #include <linux/swap.h>
 #include <linux/kthread.h>
+#include <linux/oom.h>
 
 #include <asm/pgalloc.h>
 #include <asm/uaccess.h>
diff -puN drivers/char/sysrq.c~oom-move-prototypes-to-appropriate-header-file drivers/char/sysrq.c
--- a/drivers/char/sysrq.c~oom-move-prototypes-to-appropriate-header-file
+++ a/drivers/char/sysrq.c
@@ -36,6 +36,7 @@
 #include <linux/kexec.h>
 #include <linux/irq.h>
 #include <linux/hrtimer.h>
+#include <linux/oom.h>
 
 #include <asm/ptrace.h>
 #include <asm/irq_regs.h>
diff -puN include/linux/oom.h~oom-move-prototypes-to-appropriate-header-file include/linux/oom.h
--- a/include/linux/oom.h~oom-move-prototypes-to-appropriate-header-file
+++ a/include/linux/oom.h
@@ -1,10 +1,19 @@
 #ifndef __INCLUDE_LINUX_OOM_H
 #define __INCLUDE_LINUX_OOM_H
 
+#include <linux/sched.h>
+
 /* /proc/<pid>/oom_adj set to -17 protects from the oom-killer */
 #define OOM_DISABLE (-17)
 /* inclusive */
 #define OOM_ADJUST_MIN (-16)
 #define OOM_ADJUST_MAX 15
 
-#endif
+#ifdef __KERNEL__
+
+extern void out_of_memory(struct zonelist *zonelist, gfp_t gfp_mask, int order);
+extern int register_oom_notifier(struct notifier_block *nb);
+extern int unregister_oom_notifier(struct notifier_block *nb);
+
+#endif /* __KERNEL__*/
+#endif /* _INCLUDE_LINUX_OOM_H */
diff -puN include/linux/swap.h~oom-move-prototypes-to-appropriate-header-file include/linux/swap.h
--- a/include/linux/swap.h~oom-move-prototypes-to-appropriate-header-file
+++ a/include/linux/swap.h
@@ -158,11 +158,6 @@ struct swap_list_t {
 /* Swap 50% full? Release swapcache more aggressively.. */
 #define vm_swap_full() (nr_swap_pages*2 < total_swap_pages)
 
-/* linux/mm/oom_kill.c */
-extern void out_of_memory(struct zonelist *zonelist, gfp_t gfp_mask, int order);
-extern int register_oom_notifier(struct notifier_block *nb);
-extern int unregister_oom_notifier(struct notifier_block *nb);
-
 /* linux/mm/memory.c */
 extern void swapin_readahead(swp_entry_t, unsigned long, struct vm_area_struct *);
 
diff -puN mm/page_alloc.c~oom-move-prototypes-to-appropriate-header-file mm/page_alloc.c
--- a/mm/page_alloc.c~oom-move-prototypes-to-appropriate-header-file
+++ a/mm/page_alloc.c
@@ -27,6 +27,7 @@
 #include <linux/pagevec.h>
 #include <linux/blkdev.h>
 #include <linux/slab.h>
+#include <linux/oom.h>
 #include <linux/notifier.h>
 #include <linux/topology.h>
 #include <linux/sysctl.h>
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
fix-cpusets-update_cpumask.patch
fix-cpusets-update_cpumask-checkpatch-fixes.patch
memory-controller-add-documentation.patch
memory-controller-resource-counters-v7.patch
memory-controller-resource-counters-v7-fix.patch
memory-controller-containers-setup-v7.patch
memory-controller-accounting-setup-v7.patch
memory-controller-memory-accounting-v7.patch
memory-controller-task-migration-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7-fix.patch
memory-controller-improve-user-interface.patch
memory-controller-oom-handling-v7.patch
memory-controller-oom-handling-v7-vs-oom-killer-stuff.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7-fix-2.patch
memory-controller-make-page_referenced-container-aware-v7.patch
memory-controller-make-charging-gfp-mask-aware.patch
memcontrol-move-mm_cgroup-to-header-file.patch
memcontrol-move-oom-task-exclusion-to-tasklist.patch
memcontrol-move-oom-task-exclusion-to-tasklist-fix.patch
oom-add-sysctl-to-enable-task-memory-dump.patch
bugfix-for-memory-cgroup-controller-charge-refcnt-race-fix.patch
bugfix-for-memory-cgroup-controller-fix-error-handling-path-in-mem_charge_cgroup.patch
bugfix-for-memory-controller-add-helper-function-for-assigning-cgroup-to-page.patch
bugfix-for-memory-cgroup-controller-avoid-pagelru-page-in-mem_cgroup_isolate_pages.patch
bugfix-for-memory-cgroup-controller-migration-under-memory-controller-fix.patch
