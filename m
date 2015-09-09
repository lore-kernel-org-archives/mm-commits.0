From: akpm@linux-foundation.org
Subject: [merged] mm-oom-remove-unnecessary-variable.patch removed from
 -mm tree
Date: Wed, 09 Sep 2015 12:45:34 -0700
Message-ID: <55f08c5e.+feLoLRMtwnifzYf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39010 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753392AbbIITpf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2015 15:45:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, mhocko@suse.com, sergey.senozhatsky.work@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, oom: remove unnecessary variable
has been removed from the -mm tree.  Its filename was
     mm-oom-remove-unnecessary-variable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, oom: remove unnecessary variable

The "killed" variable in out_of_memory() can be removed since the call to
oom_kill_process() where we should block to allow the process time to
exit is obvious.

Signed-off-by: David Rientjes <rientjes@google.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |   21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

diff -puN mm/oom_kill.c~mm-oom-remove-unnecessary-variable mm/oom_kill.c
--- a/mm/oom_kill.c~mm-oom-remove-unnecessary-variable
+++ a/mm/oom_kill.c
@@ -645,7 +645,6 @@ bool out_of_memory(struct oom_control *o
 	unsigned long freed = 0;
 	unsigned int uninitialized_var(points);
 	enum oom_constraint constraint = CONSTRAINT_NONE;
-	int killed = 0;
 
 	if (oom_killer_disabled)
 		return false;
@@ -653,7 +652,7 @@ bool out_of_memory(struct oom_control *o
 	blocking_notifier_call_chain(&oom_notify_list, 0, &freed);
 	if (freed > 0)
 		/* Got some memory back in the last second. */
-		goto out;
+		return true;
 
 	/*
 	 * If current has a pending SIGKILL or is exiting, then automatically
@@ -666,7 +665,7 @@ bool out_of_memory(struct oom_control *o
 	if (current->mm &&
 	    (fatal_signal_pending(current) || task_will_free_mem(current))) {
 		mark_oom_victim(current);
-		goto out;
+		return true;
 	}
 
 	/*
@@ -684,7 +683,7 @@ bool out_of_memory(struct oom_control *o
 		get_task_struct(current);
 		oom_kill_process(oc, current, 0, totalpages, NULL,
 				 "Out of memory (oom_kill_allocating_task)");
-		goto out;
+		return true;
 	}
 
 	p = select_bad_process(oc, &points, totalpages);
@@ -696,16 +695,12 @@ bool out_of_memory(struct oom_control *o
 	if (p && p != (void *)-1UL) {
 		oom_kill_process(oc, p, points, totalpages, NULL,
 				 "Out of memory");
-		killed = 1;
-	}
-out:
-	/*
-	 * Give the killed threads a good chance of exiting before trying to
-	 * allocate memory again.
-	 */
-	if (killed)
+		/*
+		 * Give the killed process a good chance to exit before trying
+		 * to allocate memory again.
+		 */
 		schedule_timeout_killable(1);
