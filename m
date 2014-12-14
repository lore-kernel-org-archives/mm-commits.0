From: akpm@linux-foundation.org
Subject: [merged]
 oom-kill-the-insufficient-and-no-longer-needed-pt_trace_exit-check.patch
 removed from -mm tree
Date: Sat, 13 Dec 2014 20:08:19 -0800
Message-ID: <548d0d33.EOVJXrgg6tRBkmmz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47704 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753102AbaLNEIL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 13 Dec 2014 23:08:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, mhocko@suse.cz, rientjes@google.com, rjw@rjwysocki.net, tj@kernel.org, xiyou.wangcong@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: oom: kill the insufficient and no longer needed PT_TRACE_EXIT check
has been removed from the -mm tree.  Its filename was
     oom-kill-the-insufficient-and-no-longer-needed-pt_trace_exit-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: oom: kill the insufficient and no longer needed PT_TRACE_EXIT check

After the previous patch we can remove the PT_TRACE_EXIT check in
oom_scan_process_thread(), it was added to handle the case when the
coredumping was "frozen" by ptrace, but it doesn't really work.  If
nothing else, we would need to check all threads which could share the
same ->mm to make it more or less correct.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Cong Wang <xiyou.wangcong@gmail.com>
Cc: David Rientjes <rientjes@google.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff -puN mm/oom_kill.c~oom-kill-the-insufficient-and-no-longer-needed-pt_trace_exit-check mm/oom_kill.c
--- a/mm/oom_kill.c~oom-kill-the-insufficient-and-no-longer-needed-pt_trace_exit-check
+++ a/mm/oom_kill.c
@@ -281,14 +281,9 @@ enum oom_scan_t oom_scan_process_thread(
 	if (oom_task_origin(task))
 		return OOM_SCAN_SELECT;
 
-	if (task_will_free_mem(task) && !force_kill) {
-		/*
-		 * If this task is not being ptraced on exit, then wait for it
-		 * to finish before killing some other task unnecessarily.
-		 */
-		if (!(task->group_leader->ptrace & PT_TRACE_EXIT))
-			return OOM_SCAN_ABORT;
-	}
+	if (task_will_free_mem(task) && !force_kill)
+		return OOM_SCAN_ABORT;
+
 	return OOM_SCAN_OK;
 }
 
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
remove-unnecessary-is_valid_nodemask.patch
linux-next.patch
all-arches-signal-move-restart_block-to-struct-task_struct.patch

