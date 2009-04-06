From: akpm@linux-foundation.org
Subject: [merged] cpuset-fix-possible-races-in-cpu-memory-hotplug.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:34:56 -0700
Message-ID: <200904061934.n36JYuxl011831@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33215 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757281AbZDFTim (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 15:38:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lizf@cn.fujitsu.com, a.p.zijlstra@chello.nl, menage@google.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     cpuset: fix possible races in cpu/memory hotplug
has been removed from the -mm tree.  Its filename was
     cpuset-fix-possible-races-in-cpu-memory-hotplug.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpuset: fix possible races in cpu/memory hotplug
From: Li Zefan <lizf@cn.fujitsu.com>

Change to cpuset->cpus_allowed and cpuset->mems_allowed should be protected
by callback_mutex, otherwise the reader may read wrong cpus/mems. This is
cpuset's lock rule.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpuset.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff -puN kernel/cpuset.c~cpuset-fix-possible-races-in-cpu-memory-hotplug kernel/cpuset.c
--- a/kernel/cpuset.c~cpuset-fix-possible-races-in-cpu-memory-hotplug
+++ a/kernel/cpuset.c
@@ -2070,7 +2070,9 @@ static int cpuset_track_online_cpus(stru
 	}
 
 	cgroup_lock();
+	mutex_lock(&callback_mutex);
 	cpumask_copy(top_cpuset.cpus_allowed, cpu_online_mask);
+	mutex_unlock(&callback_mutex);
 	scan_for_empty_cpusets(&top_cpuset);
 	ndoms = generate_sched_domains(&doms, &attr);
 	cgroup_unlock();
@@ -2093,11 +2095,12 @@ static int cpuset_track_online_nodes(str
 	cgroup_lock();
 	switch (action) {
 	case MEM_ONLINE:
-		top_cpuset.mems_allowed = node_states[N_HIGH_MEMORY];
-		break;
 	case MEM_OFFLINE:
+		mutex_lock(&callback_mutex);
 		top_cpuset.mems_allowed = node_states[N_HIGH_MEMORY];
-		scan_for_empty_cpusets(&top_cpuset);
+		mutex_unlock(&callback_mutex);
+		if (action == MEM_OFFLINE)
+			scan_for_empty_cpusets(&top_cpuset);
 		break;
 	default:
 		break;
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

origin.patch
linux-next.patch
cls_cgroup-remove-unneeded-cgroup_lock.patch

