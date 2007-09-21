From: akpm@linux-foundation.org
Subject: + oom-move-prototypes-to-appropriate-header-file.patch added to -mm tree
Date: Fri, 21 Sep 2007 02:10:55 -0700
Message-ID: <200709210910.l8L9AttS028186@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54857 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752545AbXIUJLF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Sep 2007 05:11:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, andrea@suse.de, clameter@sgi.com


The patch titled
     oom: move prototypes to appropriate header file
has been added to the -mm tree.  Its filename is
     oom-move-prototypes-to-appropriate-header-file.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: oom: move prototypes to appropriate header file
From: David Rientjes <rientjes@google.com>

Move the OOM killer's extern function prototypes to include/linux/oom.h and
include it where necessary.

Cc: Andrea Arcangeli <andrea@suse.de>
Acked-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/sysrq.c |    1 +
 include/linux/oom.h  |   11 ++++++++++-
 include/linux/swap.h |    5 -----
 mm/page_alloc.c      |    1 +
 4 files changed, 12 insertions(+), 6 deletions(-)

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

maps2-uninline-some-functions-in-the-page-walker.patch
maps2-eliminate-the-pmd_walker-struct-in-the-page-walker.patch
maps2-remove-vma-from-args-in-the-page-walker.patch
maps2-propagate-errors-from-callback-in-page-walker.patch
maps2-add-callbacks-for-each-level-to-page-walker.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-simplify-interdependence-of-proc-pid-maps-and-smaps.patch
maps2-move-clear_refs-code-to-task_mmuc.patch
maps2-regroup-task_mmu-by-interface.patch
maps2-make-proc-pid-smaps-optional-under-config_embedded.patch
maps2-make-proc-pid-clear_refs-option-under-config_embedded.patch
maps2-add-proc-pid-pagemap-interface.patch
maps2-add-proc-kpagemap-interface.patch
oom-move-prototypes-to-appropriate-header-file.patch
oom-move-constraints-to-enum.patch
oom-change-all_unreclaimable-zone-member-to-flags.patch
oom-change-all_unreclaimable-zone-member-to-flags-fix.patch
oom-add-per-zone-locking.patch
oom-serialize-out-of-memory-calls.patch
oom-add-oom_kill_allocating_task-sysctl.patch
oom-suppress-extraneous-stack-and-memory-dump.patch
oom-compare-cpuset-mems_allowed-instead-of-exclusive.patch
oom-do-not-take-callback_mutex.patch
add-a-missing-00-index-file-for-documentation-vm-fix.patch
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
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7-fix-2.patch
memory-controller-make-page_referenced-container-aware-v7.patch
memory-controller-make-charging-gfp-mask-aware.patch
