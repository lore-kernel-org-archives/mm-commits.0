From: akpm@linux-foundation.org
Subject: - oom-prevent-including-schedh-in-header-file.patch removed from -mm tree
Date: Wed, 17 Oct 2007 23:51:59 -0700
Message-ID: <200710180651.l9I6pxmV030229@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56649 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761514AbXJRHqx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:46:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, adobriyan@gmail.com, andrea@suse.de, clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     oom: prevent including sched.h in header file
has been removed from the -mm tree.  Its filename was
     oom-prevent-including-schedh-in-header-file.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: oom: prevent including sched.h in header file
From: David Rientjes <rientjes@google.com>

It's not necessary to include all of linux/sched.h in linux/oom.h.  Instead,
simply include prototypes for the relevant structs and include linux/types.h
for gfp_t.

Cc: Andrea Arcangeli <andrea@suse.de>
Cc: Christoph Lameter <clameter@sgi.com>
Acked-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/oom.h |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN include/linux/oom.h~oom-prevent-including-schedh-in-header-file include/linux/oom.h
--- a/include/linux/oom.h~oom-prevent-including-schedh-in-header-file
+++ a/include/linux/oom.h
@@ -1,8 +1,6 @@
 #ifndef __INCLUDE_LINUX_OOM_H
 #define __INCLUDE_LINUX_OOM_H
 
-#include <linux/sched.h>
-
 /* /proc/<pid>/oom_adj set to -17 protects from the oom-killer */
 #define OOM_DISABLE (-17)
 /* inclusive */
@@ -11,6 +9,11 @@
 
 #ifdef __KERNEL__
 
+#include <linux/types.h>
+
+struct zonelist;
+struct notifier_block;
+
 /*
  * Types of limitations to the nodes from which allocations may occur
  */
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
