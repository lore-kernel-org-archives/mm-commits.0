From: akpm@linux-foundation.org
Subject: + oom-suppress-extraneous-stack-and-memory-dump.patch added to -mm tree
Date: Fri, 21 Sep 2007 02:11:09 -0700
Message-ID: <200709210911.l8L9B9pr028213@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43175 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752712AbXIUJLR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Sep 2007 05:11:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, andrea@suse.de, clameter@sgi.com


The patch titled
     oom: suppress extraneous stack and memory dump
has been added to the -mm tree.  Its filename is
     oom-suppress-extraneous-stack-and-memory-dump.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: oom: suppress extraneous stack and memory dump
From: David Rientjes <rientjes@google.com>

Suppresses the extraneous stack and memory dump when a parallel OOM killing
has been found.  There's no need to fill the ring buffer with this information
if its already been printed and the condition that triggered the previous OOM
killer has not yet been alleviated.

Cc: Andrea Arcangeli <andrea@suse.de>
Acked-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |   27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

diff -puN mm/oom_kill.c~oom-suppress-extraneous-stack-and-memory-dump mm/oom_kill.c
--- a/mm/oom_kill.c~oom-suppress-extraneous-stack-and-memory-dump
+++ a/mm/oom_kill.c
@@ -333,12 +333,20 @@ static int oom_kill_task(struct task_str
 	return 0;
 }
 
-static int oom_kill_process(struct task_struct *p, unsigned long points,
-		const char *message)
+static int oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
+			    unsigned long points, const char *message)
 {
 	struct task_struct *c;
 	struct list_head *tsk;
 
+	if (printk_ratelimit()) {
+		printk(KERN_WARNING "%s invoked oom-killer: "
+			"gfp_mask=0x%x, order=%d, oomkilladj=%d\n",
+			current->comm, gfp_mask, order, current->oomkilladj);
+		dump_stack();
+		show_mem();
+	}
+
 	/*
 	 * If the task is already exiting, don't alarm the sysadmin or kill
 	 * its children or threads, just set TIF_MEMDIE so it can die quickly
@@ -447,14 +455,6 @@ void out_of_memory(struct zonelist *zone
 		/* Got some memory back in the last second. */
 		return;
 
-	if (printk_ratelimit()) {
-		printk(KERN_WARNING "%s invoked oom-killer: "
-			"gfp_mask=0x%x, order=%d, oomkilladj=%d\n",
-			current->comm, gfp_mask, order, current->oomkilladj);
-		dump_stack();
-		show_mem();
-	}
-
 	if (sysctl_panic_on_oom == 2)
 		panic("out of memory. Compulsory panic_on_oom is selected.\n");
 
@@ -468,7 +468,7 @@ void out_of_memory(struct zonelist *zone
 
 	switch (constraint) {
 	case CONSTRAINT_MEMORY_POLICY:
-		oom_kill_process(current, points,
+		oom_kill_process(current, gfp_mask, order, points,
 				"No available memory (MPOL_BIND)");
 		break;
 
@@ -478,7 +478,7 @@ void out_of_memory(struct zonelist *zone
 		/* Fall-through */
 	case CONSTRAINT_CPUSET:
 		if (sysctl_oom_kill_allocating_task) {
-			oom_kill_process(current, points,
+			oom_kill_process(current, gfp_mask, order, points,
 					"Out of memory (oom_kill_allocating_task)");
 			break;
 		}
@@ -499,7 +499,8 @@ retry:
 			panic("Out of memory and no killable processes...\n");
 		}
 
-		if (oom_kill_process(p, points, "Out of memory"))
+		if (oom_kill_process(p, points, gfp_mask, order,
+				     "Out of memory"))
 			goto retry;
 
 		break;
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
