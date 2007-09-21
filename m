From: akpm@linux-foundation.org
Subject: + oom-move-constraints-to-enum.patch added to -mm tree
Date: Fri, 21 Sep 2007 02:10:57 -0700
Message-ID: <200709210910.l8L9Avh2028189@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38124 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752667AbXIUJLJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Sep 2007 05:11:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, andrea@suse.de, clameter@sgi.com


The patch titled
     oom: move constraints to enum
has been added to the -mm tree.  Its filename is
     oom-move-constraints-to-enum.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: oom: move constraints to enum
From: David Rientjes <rientjes@google.com>

The OOM killer's CONSTRAINT definitions are really more appropriate in an
enum, so define them in include/linux/oom.h.

Cc: Andrea Arcangeli <andrea@suse.de>
Acked-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/oom.h |    9 +++++++++
 mm/oom_kill.c       |   12 +++---------
 2 files changed, 12 insertions(+), 9 deletions(-)

diff -puN include/linux/oom.h~oom-move-constraints-to-enum include/linux/oom.h
--- a/include/linux/oom.h~oom-move-constraints-to-enum
+++ a/include/linux/oom.h
@@ -11,6 +11,15 @@
 
 #ifdef __KERNEL__
 
+/*
+ * Types of limitations to the nodes from which allocations may occur
+ */
+enum oom_constraint {
+	CONSTRAINT_NONE,
+	CONSTRAINT_CPUSET,
+	CONSTRAINT_MEMORY_POLICY,
+};
+
 extern void out_of_memory(struct zonelist *zonelist, gfp_t gfp_mask, int order);
 extern int register_oom_notifier(struct notifier_block *nb);
 extern int unregister_oom_notifier(struct notifier_block *nb);
diff -puN mm/oom_kill.c~oom-move-constraints-to-enum mm/oom_kill.c
--- a/mm/oom_kill.c~oom-move-constraints-to-enum
+++ a/mm/oom_kill.c
@@ -164,16 +164,10 @@ unsigned long badness(struct task_struct
 }
 
 /*
- * Types of limitations to the nodes from which allocations may occur
- */
-#define CONSTRAINT_NONE 1
-#define CONSTRAINT_MEMORY_POLICY 2
-#define CONSTRAINT_CPUSET 3
-
-/*
  * Determine the type of allocation constraint.
  */
-static inline int constrained_alloc(struct zonelist *zonelist, gfp_t gfp_mask)
+static inline enum oom_constraint constrained_alloc(struct zonelist *zonelist,
+						    gfp_t gfp_mask)
 {
 #ifdef CONFIG_NUMA
 	struct zone **z;
@@ -393,7 +387,7 @@ void out_of_memory(struct zonelist *zone
 	struct task_struct *p;
 	unsigned long points = 0;
 	unsigned long freed = 0;
-	int constraint;
+	enum oom_constraint constraint;
 
 	blocking_notifier_call_chain(&oom_notify_list, 0, &freed);
 	if (freed > 0)
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
