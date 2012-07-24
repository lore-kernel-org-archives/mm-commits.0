From: akpm@linux-foundation.org
Subject: + memcg-oom-clarify-some-oom-dump-messages.patch added to -mm tree
Date: Tue, 24 Jul 2012 13:33:08 -0700
Message-ID: <20120724203309.B04155C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:47096 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755882Ab2GXUdM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Jul 2012 16:33:12 -0400
Received: by lagr15 with SMTP id r15so75688lag.1
        for <mm-commits@vger.kernel.org>; Tue, 24 Jul 2012 13:33:11 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: handai.szj@taobao.com, gthelen@google.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, rientjes@google.com


The patch titled
     Subject: memcg, oom: clarify some oom dump messages
has been added to the -mm tree.  Its filename is
     memcg-oom-clarify-some-oom-dump-messages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sha Zhengju <handai.szj@taobao.com>
Subject: memcg, oom: clarify some oom dump messages

Revise some oom dump messages to avoid misleading admin.

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
@@ -1472,7 +1472,7 @@ void mem_cgroup_print_oom_info(struct me
 	}
 	rcu_read_unlock();
 
-	printk(KERN_INFO "Task in %s killed", memcg_name);
+	printk(KERN_INFO "Task in %s will be killed", memcg_name);
 
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
Subject: Subject: memcg, oom: clarify some oom dump messages

Patches currently in -mm which might be from handai.szj@taobao.com are

mm-oom-introduce-helper-function-to-process-threads-during-scan.patch
mm-memcg-introduce-own-oom-handler-to-iterate-only-over-its-own-threads.patch
memcg-oom-provide-more-info-while-memcg-oom-happening.patch
memcg-oom-clarify-some-oom-dump-messages.patch

