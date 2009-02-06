From: akpm@linux-foundation.org
Subject: + memcg-show-memcg-information-during-oom-fix-fix.patch added to -mm tree
Date: Fri, 06 Feb 2009 13:24:50 -0800
Message-ID: <200902062124.n16LOo5u026707@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35357 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753633AbZBFVZj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Feb 2009 16:25:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, menage@google.com, nishimura@mxp.nes.nec.co.jp, rientjes@google.com


The patch titled
     memcg-show-memcg-information-during-oom-fix-fix
has been added to the -mm tree.  Its filename is
     memcg-show-memcg-information-during-oom-fix-fix.patch

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
Subject: memcg-show-memcg-information-during-oom-fix-fix
From: Balbir Singh <balbir@linux.vnet.ibm.com>

Fix issues reported with the OOM printing patches.

1. It reduces the static buffers from 2 to 1
2. It fixes comments that incorrectly indicate that the buffer is on stack

This patch fails checkpatch.pl, due to split of the printk message.
I could not find an easy way to fix it.

Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: David Rientjes <rientjes@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff -puN mm/memcontrol.c~memcg-show-memcg-information-during-oom-fix-fix mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-show-memcg-information-during-oom-fix-fix
+++ a/mm/memcontrol.c
@@ -736,22 +736,23 @@ void mem_cgroup_print_oom_info(struct me
 	struct cgroup *task_cgrp;
 	struct cgroup *mem_cgrp;
 	/*
-	 * Need a buffer on stack, can't rely on allocations. The code relies
+	 * Need a buffer in BSS, can't rely on allocations. The code relies
 	 * on the assumption that OOM is serialized for memory controller.
 	 * If this assumption is broken, revisit this code.
 	 */
-	static char task_memcg_name[PATH_MAX];
 	static char memcg_name[PATH_MAX];
 	int ret;
 
 	if (!memcg)
 		return;
 
-	mem_cgrp = memcg->css.cgroup;
-	task_cgrp = mem_cgroup_from_task(p)->css.cgroup;
 
 	rcu_read_lock();
-	ret = cgroup_path(task_cgrp, task_memcg_name, PATH_MAX);
+
+	mem_cgrp = memcg->css.cgroup;
+	task_cgrp = task_cgroup(p, mem_cgroup_subsys_id);
+
+	ret = cgroup_path(task_cgrp, memcg_name, PATH_MAX);
 	if (ret < 0) {
 		/*
 		 * Unfortunately, we are unable to convert to a useful name
@@ -760,16 +761,22 @@ void mem_cgroup_print_oom_info(struct me
 		rcu_read_unlock();
 		goto done;
 	}
+	rcu_read_unlock();
+
+	printk(KERN_INFO "Task in %s killed", memcg_name);
+
+	rcu_read_lock();
 	ret = cgroup_path(mem_cgrp, memcg_name, PATH_MAX);
 	if (ret < 0) {
 		rcu_read_unlock();
 		goto done;
 	}
