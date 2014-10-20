From: akpm@linux-foundation.org
Subject: + oom-pm-oom-killed-task-cannot-escape-pm-suspend-v2.patch added
 to -mm tree
Date: Mon, 20 Oct 2014 13:37:07 -0700
Message-ID: <54457273.1TZ5Ggca92JU4Oge%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56573 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752792AbaJTUhH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Oct 2014 16:37:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.cz, oleg@redhat.com, rientjes@google.com, rjw@rjwysocki.net, tj@kernel.org, xiyou.wangcong@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: oom-pm-oom-killed-task-cannot-escape-pm-suspend-v2
has been added to the -mm tree.  Its filename is
     oom-pm-oom-killed-task-cannot-escape-pm-suspend-v2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/oom-pm-oom-killed-task-cannot-escape-pm-suspend-v2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/oom-pm-oom-killed-task-cannot-escape-pm-suspend-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: oom-pm-oom-killed-task-cannot-escape-pm-suspend-v2

Cc: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: Tejun Heo <tj@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/oom.h    |    1 +
 kernel/power/process.c |   16 ++++++++--------
 mm/oom_kill.c          |    7 +++++--
 mm/page_alloc.c        |    8 ++++++++
 4 files changed, 22 insertions(+), 10 deletions(-)

diff -puN include/linux/oom.h~oom-pm-oom-killed-task-cannot-escape-pm-suspend-v2 include/linux/oom.h
--- a/include/linux/oom.h~oom-pm-oom-killed-task-cannot-escape-pm-suspend-v2
+++ a/include/linux/oom.h
@@ -52,6 +52,7 @@ extern unsigned long oom_badness(struct
 		unsigned long totalpages);
 
 extern int oom_kills_count(void);
+extern void note_oom_kill(void);
 extern void oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
 			     unsigned int points, unsigned long totalpages,
 			     struct mem_cgroup *memcg, nodemask_t *nodemask,
diff -puN kernel/power/process.c~oom-pm-oom-killed-task-cannot-escape-pm-suspend-v2 kernel/power/process.c
--- a/kernel/power/process.c~oom-pm-oom-killed-task-cannot-escape-pm-suspend-v2
+++ a/kernel/power/process.c
@@ -140,27 +140,27 @@ int freeze_processes(void)
 		oom_killer_disable();
 
 		/*
-		 * There was a OOM kill while we were freezing tasks
-		 * and the killed task might be still on the way out
-		 * so we have to double check for race.
+		 * There might have been an OOM kill while we were
+		 * freezing tasks and the killed task might be still
+		 * on the way out so we have to double check for race.
 		 */
 		if (oom_kills_count() != oom_kills_saved) {
 			struct task_struct *g, *p;
 
 			read_lock(&tasklist_lock);
-			do_each_thread(g, p) {
+			for_each_process_thread(g, p) {
 				if (p == current || freezer_should_skip(p) ||
 				    frozen(p))
 					continue;
 				error = -EBUSY;
-				break;
-			} while_each_thread(g, p);
+				goto out_loop;
+			}
+out_loop:
 			read_unlock(&tasklist_lock);
 
 			if (error) {
 				__usermodehelper_set_disable_depth(UMH_ENABLED);
-				oom_killer_enable();
-				printk("OOM in progress. ");
+				printk("OOM in progress.");
 				goto done;
 			}
 		}
diff -puN mm/oom_kill.c~oom-pm-oom-killed-task-cannot-escape-pm-suspend-v2 mm/oom_kill.c
--- a/mm/oom_kill.c~oom-pm-oom-killed-task-cannot-escape-pm-suspend-v2
+++ a/mm/oom_kill.c
@@ -414,6 +414,11 @@ int oom_kills_count(void)
 	return atomic_read(&oom_kills);
 }
 
+void note_oom_kill(void)
+{
+	atomic_inc(&oom_kills);
+}
+
 #define K(x) ((x) << (PAGE_SHIFT-10))
 /*
  * Must be called while holding a reference to p, which will be released upon
@@ -516,13 +521,11 @@ void oom_kill_process(struct task_struct
 			pr_err("Kill process %d (%s) sharing same memory\n",
 				task_pid_nr(p), p->comm);
 			task_unlock(p);
-			atomic_inc(&oom_kills);
 			do_send_sig_info(SIGKILL, SEND_SIG_FORCED, p, true);
 		}
 	rcu_read_unlock();
 
 	set_tsk_thread_flag(victim, TIF_MEMDIE);
-	atomic_inc(&oom_kills);
 	do_send_sig_info(SIGKILL, SEND_SIG_FORCED, victim, true);
 	put_task_struct(victim);
 }
diff -puN mm/page_alloc.c~oom-pm-oom-killed-task-cannot-escape-pm-suspend-v2 mm/page_alloc.c
--- a/mm/page_alloc.c~oom-pm-oom-killed-task-cannot-escape-pm-suspend-v2
+++ a/mm/page_alloc.c
@@ -2286,6 +2286,14 @@ __alloc_pages_may_oom(gfp_t gfp_mask, un
 	}
 
 	/*
+	 * PM-freezer should be notified that there might be an OOM killer on its
+	 * way to kill and wake somebody up. This is too early and we might end
+	 * up not killing anything but false positives are acceptable.
+	 * See freeze_processes.
+	 */
+	note_oom_kill();
+
+	/*
 	 * Go through the zonelist yet one more time, keep very high watermark
 	 * here, this is only to catch a parallel oom killing, we must fail if
 	 * we're still under heavy pressure.
_

Patches currently in -mm which might be from mhocko@suse.cz are

cgroup-kmemleak-add-kmemleak_free-for-cgroup-deallocations.patch
mm-memcontrol-lockless-page-counters.patch
mm-hugetlb_cgroup-convert-to-lockless-page-counters.patch
kernel-res_counter-remove-the-unused-api.patch
kernel-res_counter-remove-the-unused-api-fix.patch
kernel-res_counter-remove-the-unused-api-fix-2.patch
mm-memcontrol-convert-reclaim-iterator-to-simple-css-refcounting.patch
mm-memcontrol-convert-reclaim-iterator-to-simple-css-refcounting-fix.patch
mm-memcontrol-take-a-css-reference-for-each-charged-page.patch
mm-memcontrol-remove-obsolete-kmemcg-pinning-tricks.patch
mm-memcontrol-continue-cache-reclaim-from-offlined-groups.patch
mm-memcontrol-remove-synchroneous-stock-draining-code.patch
freezer-check-oom-kill-while-being-frozen.patch
freezer-remove-obsolete-comments-in-__thaw_task.patch
oom-pm-oom-killed-task-cannot-escape-pm-suspend.patch
oom-pm-oom-killed-task-cannot-escape-pm-suspend-v2.patch

