From: akpm@linux-foundation.org
Subject: - cgroups-remove-rcu_read_lock-in-cgroupstats_build.patch removed from -mm tree
Date: Thu, 08 Jan 2009 14:47:40 -0800
Message-ID: <200901082247.n08MledH027097@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49602 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763526AbZAHWvU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jan 2009 17:51:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: laijs@cn.fujitsu.com, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, menage@google.com, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     cgroups: remove rcu_read_lock() in cgroupstats_build()
has been removed from the -mm tree.  Its filename was
     cgroups-remove-rcu_read_lock-in-cgroupstats_build.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroups: remove rcu_read_lock() in cgroupstats_build()
From: Lai Jiangshan <laijs@cn.fujitsu.com>

cgroup_iter_* do not need rcu_read_lock().

In cgroup_enable_task_cg_lists(), do_each_thread() and while_each_thread()
are protected by RCU, it's OK, for write_lock(&css_set_lock) implies
rcu_read_lock() in non-RT kernel.

If we need explicit rcu_read_lock(), we should add rcu_read_lock() in
cgroup_enable_task_cg_lists(), not cgroup_iter_*.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Acked-by: Paul Menage <menage@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Balbir Singh <balbir@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN kernel/cgroup.c~cgroups-remove-rcu_read_lock-in-cgroupstats_build kernel/cgroup.c
--- a/kernel/cgroup.c~cgroups-remove-rcu_read_lock-in-cgroupstats_build
+++ a/kernel/cgroup.c
@@ -2055,7 +2055,6 @@ int cgroupstats_build(struct cgroupstats
 
 	ret = 0;
 	cgrp = dentry->d_fsdata;
-	rcu_read_lock();
 
 	cgroup_iter_start(cgrp, &it);
 	while ((tsk = cgroup_iter_next(cgrp, &it))) {
@@ -2080,7 +2079,6 @@ int cgroupstats_build(struct cgroupstats
 	}
 	cgroup_iter_end(cgrp, &it);
 
-	rcu_read_unlock();
 err:
 	return ret;
 }
_

Patches currently in -mm which might be from laijs@cn.fujitsu.com are

origin.patch
linux-next.patch

