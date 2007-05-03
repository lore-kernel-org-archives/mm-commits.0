From: akpm@linux-foundation.org
Subject: + cpusets-allow-empty-cpusmems_allowed-to-be-set-for.patch added to -mm tree
Date: Wed, 02 May 2007 23:10:21 -0700
Message-ID: <200705030610.l436AL8v006063@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:42649 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754496AbXECGKb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 May 2007 02:10:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, clameter@engr.sgi.com, menage@google.com, pj@sgi.com


The patch titled
     cpusets: allow empty {cpus,mems}_allowed to be set for unpopulated cpuset
has been added to the -mm tree.  Its filename is
     cpusets-allow-empty-cpusmems_allowed-to-be-set-for.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: cpusets: allow empty {cpus,mems}_allowed to be set for unpopulated cpuset
From: David Rientjes <rientjes@google.com>

You currently cannot remove all cpus or mems from cpus_allowed or
mems_allowed of a cpuset.  We now allow both if there are no attached
tasks.

Cc: Paul Jackson <pj@sgi.com>
Cc: Christoph Lameter <clameter@engr.sgi.com>
Signed-off-by: Paul Menage <menage@google.com>
Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpuset.c |   38 ++++++++++++++++++++++++++++++--------
 1 file changed, 30 insertions(+), 8 deletions(-)

diff -puN kernel/cpuset.c~cpusets-allow-empty-cpusmems_allowed-to-be-set-for kernel/cpuset.c
--- a/kernel/cpuset.c~cpusets-allow-empty-cpusmems_allowed-to-be-set-for
+++ a/kernel/cpuset.c
@@ -766,11 +766,22 @@ static int update_cpumask(struct cpuset 
 		return -EACCES;
 
 	trialcs = *cs;
-	retval = cpulist_parse(buf, trialcs.cpus_allowed);
-	if (retval < 0)
-		return retval;
+
+	/*
+	 * We allow a cpuset's cpus_allowed to be empty; if it has attached
+	 * tasks, we'll catch it later when we validate the change and return
+	 * -ENOSPC.
+	 */
+	if (!*buf) {
+		cpus_clear(trialcs.cpus_allowed);
+	} else {
+		retval = cpulist_parse(buf, trialcs.cpus_allowed);
+		if (retval < 0)
+			return retval;
+	}
 	cpus_and(trialcs.cpus_allowed, trialcs.cpus_allowed, cpu_online_map);
-	if (cpus_empty(trialcs.cpus_allowed))
+	/* cpus_allowed cannot be empty for a cpuset with attached tasks. */
+	if (atomic_read(&cs->count) && cpus_empty(trialcs.cpus_allowed))
 		return -ENOSPC;
 	retval = validate_change(cs, &trialcs);
 	if (retval < 0)
@@ -860,16 +871,27 @@ static int update_nodemask(struct cpuset
 		return -EACCES;
 
 	trialcs = *cs;
-	retval = nodelist_parse(buf, trialcs.mems_allowed);
-	if (retval < 0)
-		goto done;
+
+	/*
+	 * We allow a cpuset's mems_allowed to be empty; if it has attached
+	 * tasks, we'll catch it later when we validate the change and return
+	 * -ENOSPC.
+	 */
+	if (!*buf) {
+		nodes_clear(trialcs.mems_allowed);
+	} else {
+		retval = nodelist_parse(buf, trialcs.mems_allowed);
+		if (retval < 0)
+			goto done;
+	}
 	nodes_and(trialcs.mems_allowed, trialcs.mems_allowed, node_online_map);
 	oldmem = cs->mems_allowed;
 	if (nodes_equal(oldmem, trialcs.mems_allowed)) {
 		retval = 0;		/* Too easy - nothing to do */
 		goto done;
 	}
-	if (nodes_empty(trialcs.mems_allowed)) {
+	/* mems_allowed cannot be empty for a cpuset with attached tasks. */
+	if (atomic_read(&cs->count) && nodes_empty(trialcs.mems_allowed)) {
 		retval = -ENOSPC;
 		goto done;
 	}
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
i386-add-ptep_test_and_clear_dirtyyoung.patch
i386-use-pte_update_defer-in-ptep_test_and_clear_dirtyyoung.patch
smaps-extract-pmd-walker-from-smaps-code.patch
smaps-add-pages-referenced-count-to-smaps.patch
smaps-add-clear_refs-file-to-clear-reference.patch
cpusets-allow-tif_memdie-threads-to-allocate-anywhere.patch
mm-fix-handling-of-panic_on_oom-when-cpusets-are-in-use.patch
oom-fix-constraint-deadlock.patch
git-cpufreq.patch
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
cpusets-allow-empty-cpusmems_allowed-to-be-set-for.patch
