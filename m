From: akpm@linux-foundation.org
Subject: + cgroups-remove-rcu_read_lock-in-cgroupstats_build.patch added to -mm tree
Date: Mon, 24 Nov 2008 13:59:45 -0800
Message-ID: <200811242159.mAOLxj33010540@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46641 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752285AbYKXWAd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Nov 2008 17:00:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: laijs@cn.fujitsu.com, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, menage@google.com, xemul@openvz.org


The patch titled
     cgroups: remove rcu_read_lock() in cgroupstats_build()
has been added to the -mm tree.  Its filename is
     cgroups-remove-rcu_read_lock-in-cgroupstats_build.patch

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

linux-next.patch
kprobes-bugfix-try_module_get-even-if-calling_mod-is-null.patch
cgroups-add-lock-for-child-cgroups-in-cgroup_post_fork.patch
cgroups-fix-cgroup_iter_next-bug.patch
cgroups-dont-put-struct-cgroupfs_root-protected-by-rcu.patch
cgroups-use-task_lock-for-access-tsk-cgroups-safe-in-cgroup_clone.patch
cgroups-call-find_css_set-safely-in-cgroup_attach_task.patch
cgroups-remove-rcu_read_lock-in-cgroupstats_build.patch
devcgroup-use-list_for_each_entry_rcu.patch
memcontrol-rcu_read_lock-to-protect-mm_match_cgroup.patch
cpuset-rcu_read_lock-to-protect-task_cs.patch

