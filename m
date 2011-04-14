From: akpm@linux-foundation.org
Subject: + oom-replace-pf_oom_origin-with-toggling-oom_score_adj-update.patch added to -mm tree
Date: Thu, 14 Apr 2011 13:27:43 -0700
Message-ID: <201104142027.p3EKRh0n004520@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45653 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751152Ab1DNU2X (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Apr 2011 16:28:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, hughd@google.com, ieidus@redhat.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com


The patch titled
     oom-replace-pf_oom_origin-with-toggling-oom_score_adj-update
has been added to the -mm tree.  Its filename is
     oom-replace-pf_oom_origin-with-toggling-oom_score_adj-update.patch

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
Subject: oom-replace-pf_oom_origin-with-toggling-oom_score_adj-update
From: David Rientjes <rientjes@google.com>

 v3: add comment for test_set_oom_score_adj()
     disable irqs when taking siglock, thanks to Matt Fleming

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Izik Eidus <ieidus@redhat.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff -puN mm/oom_kill.c~oom-replace-pf_oom_origin-with-toggling-oom_score_adj-update mm/oom_kill.c
--- a/mm/oom_kill.c~oom-replace-pf_oom_origin-with-toggling-oom_score_adj-update
+++ a/mm/oom_kill.c
@@ -38,12 +38,20 @@ int sysctl_oom_kill_allocating_task;
 int sysctl_oom_dump_tasks = 1;
 static DEFINE_SPINLOCK(zone_scan_lock);
 
+/**
+ * test_set_oom_score_adj() - set current's oom_score_adj and return old value
+ * @new_val: new oom_score_adj value
+ *
+ * Sets the oom_score_adj value for current to @new_val with proper
+ * synchronization and returns the old value.  Usually used to temporarily
+ * set a value, save the old value in the caller, and then reinstate it later.
+ */
 int test_set_oom_score_adj(int new_val)
 {
 	struct sighand_struct *sighand = current->sighand;
 	int old_val;
 
-	spin_lock(&sighand->siglock);
+	spin_lock_irq(&sighand->siglock);
 	old_val = current->signal->oom_score_adj;
 	if (new_val != old_val) {
 		if (new_val == OOM_SCORE_ADJ_MIN)
@@ -52,7 +60,7 @@ int test_set_oom_score_adj(int new_val)
 			atomic_dec(&current->mm->oom_disable_count);
 		current->signal->oom_score_adj = new_val;
 	}
-	spin_unlock(&sighand->siglock);
+	spin_unlock_irq(&sighand->siglock);
 
 	return old_val;
 }
_

Patches currently in -mm which might be from rientjes@google.com are

mm-optimize-pfn-calculation-in-online_page.patch
linux-next.patch
vmscan-all_unreclaimable-use-zone-all_unreclaimable-as-a-name.patch
oom-kill-remove-boost_dying_task_prio.patch
mm-thp-use-conventional-format-for-boolean-attributes.patch
arch-mm-filter-disallowed-nodes-from-arch-specific-show_mem-functions.patch
mm-per-node-vmstat-show-proper-vmstats.patch
mm-increase-reclaim_distance-to-30.patch
oom-replace-pf_oom_origin-with-toggling-oom_score_adj.patch
oom-replace-pf_oom_origin-with-toggling-oom_score_adj-update.patch
jbd-remove-dependency-on-__gfp_nofail.patch
cgroups-read-write-lock-clone_thread-forking-per-threadgroup.patch
cgroups-add-per-thread-subsystem-callbacks.patch
cgroups-make-procs-file-writable.patch
cgroups-use-flex_array-in-attach_proc.patch

