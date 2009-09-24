From: akpm@linux-foundation.org
Subject: [merged] do_wait-wakeup-optimization-fix-child_wait_callback-eligible_child-usage.patch removed from -mm tree
Date: Thu, 24 Sep 2009 12:35:11 -0700
Message-ID: <200909241935.n8OJZBGU032431@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39993 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752591AbZIXTfa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Sep 2009 15:35:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, kamezawa.hiroyu@jp.fujitsu.com, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     do_wait-wakeup-optimization: fix child_wait_callback()->eligible_child() usage
has been removed from the -mm tree.  Its filename was
     do_wait-wakeup-optimization-fix-child_wait_callback-eligible_child-usage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: do_wait-wakeup-optimization: fix child_wait_callback()->eligible_child() usage
From: Oleg Nesterov <oleg@redhat.com>

child_wait_callback()->eligible_child() is not right, we can miss the
wakeup if the task was detached before __wake_up_parent() and the caller
of do_wait() didn't use __WALL.

Move ->wo_pid checks from eligible_child() to the new helper,
eligible_pid(), and change child_wait_callback() to use it instead of
eligible_child().

Note: actually I think it would be better to fix the __WCLONE check in
eligible_child(), it doesn't look exactly right.  But it is not clear what
is the supposed behaviour, and any change is user-visible.

Reported-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Tested-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff -puN kernel/exit.c~do_wait-wakeup-optimization-fix-child_wait_callback-eligible_child-usage kernel/exit.c
--- a/kernel/exit.c~do_wait-wakeup-optimization-fix-child_wait_callback-eligible_child-usage
+++ a/kernel/exit.c
@@ -1111,13 +1111,16 @@ static struct pid *task_pid_type(struct 
 	return pid;
 }
 
-static int eligible_child(struct wait_opts *wo, struct task_struct *p)
+static inline int eligible_pid(struct wait_opts *wo, struct task_struct *p)
 {
-	if (wo->wo_type < PIDTYPE_MAX) {
-		if (task_pid_type(p, wo->wo_type) != wo->wo_pid)
-			return 0;
-	}
+	return	wo->wo_type == PIDTYPE_MAX ||
+		task_pid_type(p, wo->wo_type) == wo->wo_pid;
+}
 
+static int eligible_child(struct wait_opts *wo, struct task_struct *p)
+{
+	if (!eligible_pid(wo, p))
+		return 0;
 	/* Wait for all children (clone and not) if __WALL is set;
 	 * otherwise, wait for clone children *only* if __WCLONE is
 	 * set; otherwise, wait for non-clone children *only*.  (Note:
@@ -1578,7 +1581,7 @@ static int child_wait_callback(wait_queu
 						child_wait);
 	struct task_struct *p = key;
 
-	if (!eligible_child(wo, p))
+	if (!eligible_pid(wo, p))
 		return 0;
 
 	if ((wo->wo_flags & __WNOTHREAD) && wait->private != p->parent)
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
linux-next.patch
do_wait-optimization-do-not-place-sub-threads-on-task_struct-children-list.patch
utrace-core.patch

