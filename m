From: akpm@linux-foundation.org
Subject: + cpuset-fix-possible-races-in-cpu-memory-hotplug.patch added to -mm tree
Date: Tue, 03 Feb 2009 14:31:41 -0800
Message-ID: <200902032231.n13MVfnx011656@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55850 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751302AbZBCWbt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Feb 2009 17:31:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lizf@cn.fujitsu.com, menage@google.com


The patch titled
     cpuset: fix possible races in cpu/memory hotplug
has been added to the -mm tree.  Its filename is
     cpuset-fix-possible-races-in-cpu-memory-hotplug.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpuset: fix possible races in cpu/memory hotplug
From: Li Zefan <lizf@cn.fujitsu.com>

Change to cpuset->cpus_allowed and cpuset->mems_allowed should be protected
by callback_mutex, otherwise the reader may read wrong cpus/mems. This is
cpuset's lock rule.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpuset.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff -puN kernel/cpuset.c~cpuset-fix-possible-races-in-cpu-memory-hotplug kernel/cpuset.c
--- a/kernel/cpuset.c~cpuset-fix-possible-races-in-cpu-memory-hotplug
+++ a/kernel/cpuset.c
@@ -1995,7 +1995,9 @@ static int cpuset_track_online_cpus(stru
 	}
 
 	cgroup_lock();
+	mutex_lock(&callback_mutex);
 	cpumask_copy(top_cpuset.cpus_allowed, cpu_online_mask);
+	mutex_unlock(&callback_mutex);
 	scan_for_empty_cpusets(&top_cpuset);
 	ndoms = generate_sched_domains(&doms, &attr);
 	cgroup_unlock();
@@ -2018,11 +2020,12 @@ static int cpuset_track_online_nodes(str
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
relax-ns_can_attach-checks-to-allow-attaching-to-grandchild-cgroups.patch
cgroup-css-id-support.patch
cgroup-fix-frequent-ebusy-at-rmdir.patch
memcg-use-css-id.patch
memcg-hierarchical-stat.patch
memcg-fix-shrinking-memory-to-return-ebusy-by-fixing-retry-algorithm.patch
memcg-fix-oom-killer-under-memcg.patch
cpuset-fix-possible-races-in-cpu-memory-hotplug.patch

