From: akpm@linux-foundation.org
Subject: + cpuset-sched_load_balance-flag-sched-domain-confusion-fix.patch added to -mm tree
Date: Thu, 18 Oct 2007 14:39:25 -0700
Message-ID: <200710182139.l9ILdPdS032399@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38097 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759197AbXJRVjj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 17:39:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pj@sgi.com, mingo@elte.hu


The patch titled
     cpuset sched_load_balance sched domain confusion fix
has been added to the -mm tree.  Its filename is
     cpuset-sched_load_balance-flag-sched-domain-confusion-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: cpuset sched_load_balance sched domain confusion fix
From: Paul Jackson <pj@sgi.com>

Fix a bug in the cpuset code that recalculates dynamic sched domains.

For sufficiently complex cpuset configurations, the recalc code
could get confused, due to overwriting some state then using the
overwritten values as if they still held the previous value.  This
could result in kernel oops and other random chaos, overwriting
memory.

The fix stashes the two values of interest, apn and bpn, in separate
local variables, to keep them separate from what will be overwritten.

Besides the fix, also:
 1) this confusion is easy to detect -- in the event that there are
    or ever come to be any more such bugs, notice when out of bounds
    and 'continue' past it, resulting in overly simplified sched
    domain setups, rather than oops or memory trashing, and
 2) in that case, print something out with a few clues, the first
    ten times this happens on a boot, so that someone might notice
    someday and chase the problem down.

Signed-off-by: Paul Jackson <pj@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpuset.c |   21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff -puN kernel/cpuset.c~cpuset-sched_load_balance-flag-sched-domain-confusion-fix kernel/cpuset.c
--- a/kernel/cpuset.c~cpuset-sched_load_balance-flag-sched-domain-confusion-fix
+++ a/kernel/cpuset.c
@@ -622,16 +622,18 @@ restart:
 	/* Find the best partition (set of sched domains) */
 	for (i = 0; i < csn; i++) {
 		struct cpuset *a = csa[i];
+		int apn = a->pn;
 
 		for (j = 0; j < csn; j++) {
 			struct cpuset *b = csa[j];
+			int bpn = b->pn;
 
-			if (a->pn != b->pn && cpusets_overlap(a, b)) {
+			if (apn != bpn && cpusets_overlap(a, b)) {
 				for (k = 0; k < csn; k++) {
 					struct cpuset *c = csa[k];
 
-					if (c->pn == b->pn)
-						c->pn = a->pn;
+					if (c->pn == bpn)
+						c->pn = apn;
 				}
 				ndoms--;	/* one less element */
 				goto restart;
@@ -651,6 +653,19 @@ restart:
 		if (apn >= 0) {
 			cpumask_t *dp = doms + nslot;
 
+			if (nslot == ndoms) {
+				static int warnings = 10;
+				if (warnings) {
+					printk(KERN_WARNING
+					 "rebuild_sched_domains confused:"
+					  " nslot %d, ndoms %d, csn %d, i %d,"
+					  " apn %d\n",
+					  nslot, ndoms, csn, i, apn);
+					warnings--;
+				}
+				continue;
+			}
+
 			cpus_clear(*dp);
 			for (j = i; j < csn; j++) {
 				struct cpuset *b = csa[j];
_

Patches currently in -mm which might be from pj@sgi.com are

origin.patch
whitespace-fixes-cpuset.patch
git-scsi-misc.patch
cpuset-zero-malloc-revert-the-old-cpuset-fix.patch
task-containersv11-basic-task-container-framework.patch
task-containersv11-add-tasks-file-interface.patch
task-containersv11-add-fork-exit-hooks.patch
task-containersv11-add-container_clone-interface.patch
task-containersv11-add-procfs-interface.patch
task-containersv11-shared-container-subsystem-group-arrays.patch
task-containersv11-shared-container-subsystem-group-arrays-simplify-proc-cgroups.patch
task-containersv11-shared-container-subsystem-group-arrays-simplify-proc-cgroups-fix.patch
task-containersv11-automatic-userspace-notification-of-idle-containers.patch
task-containersv11-automatic-userspace-notification-of-idle-containers-fix.patch
task-containersv11-make-cpusets-a-client-of-containers.patch
task-containersv11-example-cpu-accounting-subsystem.patch
task-containersv11-simple-task-container-debug-info-subsystem.patch
task-containers-enable-containers-by-default-in-some-configs.patch
cpuset-sched_load_balance-flag.patch
cpuset-sched_load_balance-flag-fix.patch
cpuset-sched_load_balance-kmalloc-fix.patch
cpuset-sched_load_balance-flag-sched-domain-confusion-fix.patch
cpusets-decrustify-cpuset-mask-update-code.patch
cpusets-decrustify-cpuset-mask-update-code-checkpatch-fixes.patch
fix-cpusets-update_cpumask.patch
fix-cpusets-update_cpumask-checkpatch-fixes.patch
control-groups-replace-cont-with-cgrp-and-other-misc.patch
hotplug-cpu-migrate-a-task-within-its-cpuset.patch
hotplug-cpu-migrate-a-task-within-its-cpuset-fix.patch
hotplug-cpu-migrate-a-task-within-its-cpuset-whitespace-fix.patch
hotplug-cpu-migrate-a-task-within-its-cpuset-doc.patch
