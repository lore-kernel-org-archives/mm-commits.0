From: akpm@linux-foundation.org
Subject: - cpusets-allow-empty-cpusmems_allowed-to-be-set-for.patch removed from -mm tree
Date: Tue, 08 May 2007 19:52:25 -0700
Message-ID: <200705090252.l492qPjP009568@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:55375 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S969177AbXEICwe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:52:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, clameter@engr.sgi.com, menage@google.com, pj@sgi.com, mm-commits@vger.kernel.org


The patch titled
     cpusets: allow empty {cpus,mems}_allowed to be set for unpopulated cpuset
has been removed from the -mm tree.  Its filename was
     cpusets-allow-empty-cpusmems_allowed-to-be-set-for.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: cpusets: allow empty {cpus,mems}_allowed to be set for unpopulated cpuset
From: David Rientjes <rientjes@google.com>

You currently cannot remove all cpus or mems from cpus_allowed or
mems_allowed of a cpuset.  We now allow both if there are no attached
tasks.

Acked-by: Paul Jackson <pj@sgi.com>
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
@@ -821,11 +821,22 @@ static int update_cpumask(struct cpuset 
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
+	if (!buf[0] || (buf[0] == '\n' && !buf[1])) {
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
@@ -918,16 +929,27 @@ static int update_nodemask(struct cpuset
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
+	if (!buf[0] || (buf[0] == '\n' && !buf[1])) {
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
smaps-only-define-clear_refs-for-config_mmu.patch
git-alsa.patch
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
compiler-introduce-__used-and-__maybe_unused.patch
i386-pci-type-may-be-unused.patch
sh-dma-use-__maybe_unused.patch
scsi-fix-ambiguous-gdthtable-definition.patch
frv-gdb-use-__maybe_unused.patch
i386-voyager-use-__maybe_unused.patch
mips-excite-use-__maybe_unused.patch
mips-tlbex-use-__maybe_unused.patch
powerpc-ps3-use-__maybe_unused.patch
i386-mmzone-use-__maybe_unused.patch
