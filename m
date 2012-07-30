From: akpm@linux-foundation.org
Subject: [nacked] memcg-oom-clarify-some-oom-dump-messages.patch removed from -mm tree
Date: Mon, 30 Jul 2012 11:07:07 -0700
Message-ID: <20120730180708.2E6DB20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:41578 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754363Ab2G3SHK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 30 Jul 2012 14:07:10 -0400
Received: by fat25 with SMTP id 25so238449fat.1
        for <mm-commits@vger.kernel.org>; Mon, 30 Jul 2012 11:07:09 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: handai.szj@taobao.com, gthelen@google.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg, oom: clarify some oom dump messages
has been removed from the -mm tree.  Its filename was
     memcg-oom-clarify-some-oom-dump-messages.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Sha Zhengju <handai.szj@taobao.com>
Subject: memcg, oom: clarify some oom dump messages

Revise some oom dump messages to avoid misleading admin.

[akpm@linux-foundation.org: checkpatch fixes]
Signed-off-by: Sha Zhengju <handai.szj@taobao.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Greg Thelen <gthelen@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 mm/oom_kill.c   |    5 +++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff -puN mm/memcontrol.c~memcg-oom-clarify-some-oom-dump-messages mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-oom-clarify-some-oom-dump-messages
+++ a/mm/memcontrol.c
@@ -1471,7 +1471,7 @@ void mem_cgroup_print_oom_info(struct me
 	}
 	rcu_read_unlock();
 
-	printk(KERN_INFO "Task in %s killed", memcg_name);
+	pr_info("Task in %s will be killed", memcg_name);
 
 	rcu_read_lock();
 	ret = cgroup_path(mem_cgrp, memcg_name, PATH_MAX);
diff -puN mm/oom_kill.c~memcg-oom-clarify-some-oom-dump-messages mm/oom_kill.c
--- a/mm/oom_kill.c~memcg-oom-clarify-some-oom-dump-messages
+++ a/mm/oom_kill.c
@@ -472,7 +472,7 @@ void oom_kill_process(struct task_struct
 		dump_header(p, gfp_mask, order, memcg, nodemask);
 
 	task_lock(p);
-	pr_err("%s: Kill process %d (%s) score %d or sacrifice child\n",
+	pr_err("%s: Will kill process %d (%s) score %d or sacrifice child\n",
 		message, task_pid_nr(p), p->comm, points);
 	task_unlock(p);
 
@@ -509,6 +509,7 @@ void oom_kill_process(struct task_struct
 	if (!p) {
 		rcu_read_unlock();
 		put_task_struct(victim);
+		pr_err("No process has been killed!\n");
 		return;
 	} else if (victim != p) {
 		get_task_struct(p);
@@ -540,7 +541,7 @@ void oom_kill_process(struct task_struct
 				continue;
 
 			task_lock(p);	/* Protect ->comm from prctl() */
-			pr_err("Kill process %d (%s) sharing same memory\n",
+			pr_err("Killed process %d (%s) sharing same memory\n",
 				task_pid_nr(p), p->comm);
 			task_unlock(p);
 			do_send_sig_info(SIGKILL, SEND_SIG_FORCED, p, true);
_

Patches currently in -mm which might be from handai.szj@taobao.com are

mm-oom-introduce-helper-function-to-process-threads-during-scan.patch
mm-memcg-introduce-own-oom-handler-to-iterate-only-over-its-own-threads.patch

