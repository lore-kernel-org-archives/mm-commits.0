From: akpm@linux-foundation.org
Subject: - cpusets-set-tasks-cpu_allowed-to-cpu_possible_map-when-attaching-it-into-top-cpuset.patch removed from -mm tree
Date: Thu, 08 Jan 2009 14:50:05 -0800
Message-ID: <200901082250.n08Mo51P029326@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50978 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763153AbZAHWuq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jan 2009 17:50:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: miaox@cn.fujitsu.com, menage@google.com, mm-commits@vger.kernel.org


The patch titled
     cpusets: set task's cpu_allowed to cpu_possible_map when attaching it into top cpuset
has been removed from the -mm tree.  Its filename was
     cpusets-set-tasks-cpu_allowed-to-cpu_possible_map-when-attaching-it-into-top-cpuset.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpusets: set task's cpu_allowed to cpu_possible_map when attaching it into top cpuset
From: Miao Xie <miaox@cn.fujitsu.com>

I found a bug on my dual-cpu box.  I created a sub cpuset in top cpuset
and assign 1 to its cpus.  And then we attach some tasks into this sub
cpuset.  After this, we offline CPU1.  Now, the tasks in this new cpuset
are moved into top cpuset automatically because there is no cpu in sub
cpuset.  Then we online CPU1, we find all the tasks which doesn't belong
to top cpuset originally just run on CPU0.

We fix this bug by setting task's cpu_allowed to cpu_possible_map when
attaching it into top cpuset.  This method needn't modify the current
behavior of cpusets on CPU hotplug, and all of tasks in top cpuset use
cpu_possible_map to initialize their cpu_allowed.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpuset.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff -puN kernel/cpuset.c~cpusets-set-tasks-cpu_allowed-to-cpu_possible_map-when-attaching-it-into-top-cpuset kernel/cpuset.c
--- a/kernel/cpuset.c~cpusets-set-tasks-cpu_allowed-to-cpu_possible_map-when-attaching-it-into-top-cpuset
+++ a/kernel/cpuset.c
@@ -1338,10 +1338,14 @@ static void cpuset_attach(struct cgroup_
 	struct cpuset *oldcs = cgroup_cs(oldcont);
 	int err;
 
-	mutex_lock(&callback_mutex);
-	guarantee_online_cpus(cs, &cpus);
+	if (cs == &top_cpuset) {
+		cpus = cpu_possible_map;
+	} else {
+		mutex_lock(&callback_mutex);
+		guarantee_online_cpus(cs, &cpus);
+		mutex_unlock(&callback_mutex);
+	}
 	err = set_cpus_allowed_ptr(tsk, &cpus);
-	mutex_unlock(&callback_mutex);
 	if (err)
 		return;
 
_

Patches currently in -mm which might be from miaox@cn.fujitsu.com are

origin.patch
linux-next.patch

