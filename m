From: akpm@linux-foundation.org
Subject: [merged] oom-remove-references-to-old-badness-function.patch removed from -mm tree
Date: Tue, 26 Jul 2011 00:52:58 -0700
Message-ID: <201107260752.p6Q7q1Wd003009@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38045 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752692Ab1GZHwh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jul 2011 03:52:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, kosaki.motohiro@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     oom: remove references to old badness() function
has been removed from the -mm tree.  Its filename was
     oom-remove-references-to-old-badness-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: oom: remove references to old badness() function
From: David Rientjes <rientjes@google.com>

The badness() function in the oom killer was renamed to oom_badness() in
a63d83f427fb ("oom: badness heuristic rewrite") since it is a globally
exported function for clarity.

The prototype for the old function still existed in linux/oom.h, so remove
it.  There are no existing users.

Also fixes documentation and comment references to badness() and adjusts
them accordingly.

Signed-off-by: David Rientjes <rientjes@google.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/obsolete/proc-pid-oom_adj |    2 +-
 Documentation/feature-removal-schedule.txt  |    2 +-
 include/linux/oom.h                         |    4 ----
 mm/oom_kill.c                               |    2 +-
 4 files changed, 3 insertions(+), 7 deletions(-)

diff -puN Documentation/ABI/obsolete/proc-pid-oom_adj~oom-remove-references-to-old-badness-function Documentation/ABI/obsolete/proc-pid-oom_adj
--- a/Documentation/ABI/obsolete/proc-pid-oom_adj~oom-remove-references-to-old-badness-function
+++ a/Documentation/ABI/obsolete/proc-pid-oom_adj
@@ -14,7 +14,7 @@ Why:	/proc/<pid>/oom_adj allows userspac
 
 	A much more powerful interface, /proc/<pid>/oom_score_adj, was
 	introduced with the oom killer rewrite that allows users to increase or
-	decrease the badness() score linearly.  This interface will replace
+	decrease the badness score linearly.  This interface will replace
 	/proc/<pid>/oom_adj.
 
 	A warning will be emitted to the kernel log if an application uses this
diff -puN Documentation/feature-removal-schedule.txt~oom-remove-references-to-old-badness-function Documentation/feature-removal-schedule.txt
--- a/Documentation/feature-removal-schedule.txt~oom-remove-references-to-old-badness-function
+++ a/Documentation/feature-removal-schedule.txt
@@ -184,7 +184,7 @@ Why:	/proc/<pid>/oom_adj allows userspac
 
 	A much more powerful interface, /proc/<pid>/oom_score_adj, was
 	introduced with the oom killer rewrite that allows users to increase or
-	decrease the badness() score linearly.  This interface will replace
+	decrease the badness score linearly.  This interface will replace
 	/proc/<pid>/oom_adj.
 
 	A warning will be emitted to the kernel log if an application uses this
diff -puN include/linux/oom.h~oom-remove-references-to-old-badness-function include/linux/oom.h
--- a/include/linux/oom.h~oom-remove-references-to-old-badness-function
+++ a/include/linux/oom.h
@@ -64,10 +64,6 @@ static inline void oom_killer_enable(voi
 	oom_killer_disabled = false;
 }
 
-/* The badness from the OOM killer */
-extern unsigned long badness(struct task_struct *p, struct mem_cgroup *mem,
-		      const nodemask_t *nodemask, unsigned long uptime);
-
 extern struct task_struct *find_lock_task_mm(struct task_struct *p);
 
 /* sysctls */
diff -puN mm/oom_kill.c~oom-remove-references-to-old-badness-function mm/oom_kill.c
--- a/mm/oom_kill.c~oom-remove-references-to-old-badness-function
+++ a/mm/oom_kill.c
@@ -487,7 +487,7 @@ static int oom_kill_process(struct task_
 
 	/*
 	 * If any of p's children has a different mm and is eligible for kill,
-	 * the one with the highest badness() score is sacrificed for its
+	 * the one with the highest oom_badness() score is sacrificed for its
 	 * parent.  This attempts to lose the minimal amount of work done while
 	 * still freeing memory.
 	 */
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
linux-next.patch
acpi-remove-nid_inval.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-fix-2.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily-fix.patch
proc-pid-fdinfo-add-cloexec-information.patch
proc-pid-fdinfo-add-cloexec-information-fix.patch

