From: akpm@linux-foundation.org
Subject: [to-be-updated] freezer-check-oom-kill-while-being-frozen.patch
 removed from -mm tree
Date: Mon, 20 Oct 2014 13:58:54 -0700
Message-ID: <5445778e.BgcYZrOzl04wAWtE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56735 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753018AbaJTU6z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Oct 2014 16:58:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xiyou.wangcong@gmail.com, mhocko@suse.cz, oleg@redhat.com, rientjes@google.com, rjw@rjwysocki.net, stable@vger.kernel.org, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: freezer: check OOM kill while being frozen
has been removed from the -mm tree.  Its filename was
     freezer-check-oom-kill-while-being-frozen.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Cong Wang <xiyou.wangcong@gmail.com>
Subject: freezer: check OOM kill while being frozen

Since f660daac474c6f ("oom: thaw threads if oom killed thread is frozen
before deferring") OOM killer relies on being able to thaw a frozen task
to handle OOM situation but a3201227f803 (freezer: make freezing() test
freeze conditions in effect instead of TIF_FREEZE) has reorganized the
code and stopped clearing freeze flag in __thaw_task.  This means that the
target task only wakes up and goes into the fridge again because the
freezing condition hasn't changed for it.  This reintroduces the bug fixed
by f660daac474c6f.

Fix the issue by checking for TIF_MEMDIE thread flag and get away from the
fridge if it is set.  oom_scan_process_thread doesn't have to check for
the frozen task anymore because do_send_sig_info will wake up the thread
and TIF_MEMDIE is already set by that time.

Fixes: a3201227f803 (freezer: make freezing() test freeze conditions in effect instead of TIF_FREEZE)
[mhocko@suse.cz: rewrote the changelog]
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: Michal Hocko <mhocko@suse.cz>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: David Rientjes <rientjes@google.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Tejun Heo <tj@kernel.org>
Cc: <stable@vger.kernel.org>	[3.3+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/freezer.c |   20 +++++++++++++++++---
 mm/oom_kill.c    |    2 --
 2 files changed, 17 insertions(+), 5 deletions(-)

diff -puN kernel/freezer.c~freezer-check-oom-kill-while-being-frozen kernel/freezer.c
--- a/kernel/freezer.c~freezer-check-oom-kill-while-being-frozen
+++ a/kernel/freezer.c
@@ -45,13 +45,28 @@ bool freezing_slow_path(struct task_stru
 	if (pm_nosig_freezing || cgroup_freezing(p))
 		return true;
 
-	if (pm_freezing && !(p->flags & PF_KTHREAD))
+	if (!(p->flags & PF_KTHREAD))
 		return true;
 
 	return false;
 }
 EXPORT_SYMBOL(freezing_slow_path);
 
+static bool should_thaw_current(bool check_kthr_stop)
+{
+	if (!freezing(current))
+		return true;
+
+	if (check_kthr_stop && kthread_should_stop())
+		return true;
+
+	/* It might not be safe to check TIF_MEMDIE for pm freeze. */
+	if (cgroup_freezing(current) && test_thread_flag(TIF_MEMDIE))
+		return true;
+
+	return false;
+}
+
 /* Refrigerator is place where frozen processes are stored :-). */
 bool __refrigerator(bool check_kthr_stop)
 {
@@ -67,8 +82,7 @@ bool __refrigerator(bool check_kthr_stop
 
 		spin_lock_irq(&freezer_lock);
 		current->flags |= PF_FROZEN;
-		if (!freezing(current) ||
-		    (check_kthr_stop && kthread_should_stop()))
+		if (should_thaw_current(check_kthr_stop))
 			current->flags &= ~PF_FROZEN;
 		spin_unlock_irq(&freezer_lock);
 
diff -puN mm/oom_kill.c~freezer-check-oom-kill-while-being-frozen mm/oom_kill.c
--- a/mm/oom_kill.c~freezer-check-oom-kill-while-being-frozen
+++ a/mm/oom_kill.c
@@ -266,8 +266,6 @@ enum oom_scan_t oom_scan_process_thread(
 	 * Don't allow any other task to have access to the reserves.
 	 */
 	if (test_tsk_thread_flag(task, TIF_MEMDIE)) {
-		if (unlikely(frozen(task)))
-			__thaw_task(task);
 		if (!force_kill)
 			return OOM_SCAN_ABORT;
 	}
_

Patches currently in -mm which might be from xiyou.wangcong@gmail.com are

freezer-remove-obsolete-comments-in-__thaw_task.patch
oom-pm-oom-killed-task-cannot-escape-pm-suspend.patch
oom-pm-oom-killed-task-cannot-escape-pm-suspend-v2.patch
linux-next.patch

