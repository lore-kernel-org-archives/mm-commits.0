Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B46E19FA93
	for <mm-commits@vger.kernel.org>; Thu, 20 Nov 2025 21:52:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763675548; cv=none; b=ZOeND5HD12/3nJpmYzECXRCc5Q1Wz2mrpv/muqMhAyve3zSqomHodSVxWyIs4UUIy2nVVRZwEcFAopEJjIGKjE9Kx3WR6MI/g4melzYdIazL/QTAkhoTDXHfvLPrsaJHE/5WF8XEL0t/nNbzhqjDRAn3chSW1xaUKG9ydiox2/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763675548; c=relaxed/simple;
	bh=HJkFawL+UiHSCq9guTYIdbobC+tYqoHU2ufhymiXhxw=;
	h=Date:To:From:Subject:Message-Id; b=U/zqUZGmG1Exmu3KalW9TADUMeOnT7SOm9vRox1QvrpH3ZJRlLY4b8VGrvcC3X4RV0N7Dv+Q7M3mlKSJou75jC/9+ohQGJxu1VpxIPsGYPmbhH7jLrn63zsbOso+zp3FvkU2iECqBxl6k34krVXAawGAEa4xclDLoZcoxTDq7Ss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kmzl1q+7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kmzl1q+7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10852C4CEF1;
	Thu, 20 Nov 2025 21:52:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763675548;
	bh=HJkFawL+UiHSCq9guTYIdbobC+tYqoHU2ufhymiXhxw=;
	h=Date:To:From:Subject:From;
	b=kmzl1q+7BzVq82llfntjz3HKs3PPLhcady7L/at6vzrMA7QqDcjqcsWPt21qJVVy1
	 L1tE0+YnJCCuSS+O0I3kY45LCry3GaSgNkSTprHtDeRiC6ktYH3zvHA1XMOi3VYtwT
	 Q2dcqrMmg8n+8dHlg6O4rOro0ipBn6HjzmywA5c0=
Date: Thu, 20 Nov 2025 13:52:27 -0800
To: mm-commits@vger.kernel.org,rostedt@goodmis.org,pmladek@suse.com,paulmck@kernel.org,ioworker0@gmail.com,corbet@lwn.net,feng.tang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] hung_task-add-hung_task_sys_info-sysctl-to-dump-sys-info-on-task-hung-fix.patch removed from -mm tree
Message-Id: <20251120215228.10852C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: hung_task-add-hung_task_sys_info-sysctl-to-dump-sys-info-on-task-hung-fix
has been removed from the -mm tree.  Its filename was
     hung_task-add-hung_task_sys_info-sysctl-to-dump-sys-info-on-task-hung-fix.patch

This patch was dropped because it was folded into hung_task-add-hung_task_sys_info-sysctl-to-dump-sys-info-on-task-hung.patch

------------------------------------------------------
From: Feng Tang <feng.tang@linux.alibaba.com>
Subject: hung_task-add-hung_task_sys_info-sysctl-to-dump-sys-info-on-task-hung-fix
Date: Wed, 5 Nov 2025 19:30:36 +0800

maintain consistecy established behavior, per Lance and Petr

Link: https://lkml.kernel.org/r/aRncJo1mA5Zk77Hr@U-2FWC9VHC-2323.local
Suggested-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Feng Tang <feng.tang@linux.alibaba.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: "Paul E . McKenney" <paulmck@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/hung_task.c |   24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

--- a/kernel/hung_task.c~hung_task-add-hung_task_sys_info-sysctl-to-dump-sys-info-on-task-hung-fix
+++ a/kernel/hung_task.c
@@ -223,8 +223,11 @@ static inline void debug_show_blocker(st
 }
 #endif
 
-static void check_hung_task(struct task_struct *t, unsigned long timeout)
+static void check_hung_task(struct task_struct *t, unsigned long timeout,
+		unsigned long prev_detect_count)
 {
+	unsigned long total_hung_task;
+
 	if (!task_is_hung(t, timeout))
 		return;
 
@@ -234,13 +237,19 @@ static void check_hung_task(struct task_
 	 */
 	sysctl_hung_task_detect_count++;
 
+	total_hung_task = sysctl_hung_task_detect_count - prev_detect_count;
 	trace_sched_process_hang(t);
 
+	if (sysctl_hung_task_panic && total_hung_task >= sysctl_hung_task_panic) {
+		console_verbose();
+		hung_task_call_panic = true;
+	}
+
 	/*
 	 * Ok, the task did not get scheduled for more than 2 minutes,
 	 * complain:
 	 */
-	if (sysctl_hung_task_warnings) {
+	if (sysctl_hung_task_warnings || hung_task_call_panic) {
 		if (sysctl_hung_task_warnings > 0)
 			sysctl_hung_task_warnings--;
 		pr_err("INFO: task %s:%d blocked for more than %ld seconds.\n",
@@ -295,7 +304,6 @@ static void check_hung_uninterruptible_t
 {
 	int max_count = sysctl_hung_task_check_count;
 	unsigned long last_break = jiffies;
-	unsigned long total_hung_task;
 	struct task_struct *g, *t;
 	unsigned long prev_detect_count = sysctl_hung_task_detect_count;
 	int need_warning = sysctl_hung_task_warnings;
@@ -320,20 +328,14 @@ static void check_hung_uninterruptible_t
 			last_break = jiffies;
 		}
 
-		check_hung_task(t, timeout);
+		check_hung_task(t, timeout, prev_detect_count);
 	}
  unlock:
 	rcu_read_unlock();
 
-	total_hung_task = sysctl_hung_task_detect_count - prev_detect_count;
-	if (!total_hung_task)
+	if (!(sysctl_hung_task_detect_count - prev_detect_count))
 		return;
 
-	if (sysctl_hung_task_panic && total_hung_task >= sysctl_hung_task_panic) {
-		console_verbose();
-		hung_task_call_panic = true;
-	}
-
 	if (need_warning || hung_task_call_panic) {
 		si_mask |= SYS_INFO_LOCKS;
 
_

Patches currently in -mm which might be from feng.tang@linux.alibaba.com are

docs-panic-correct-some-sys_ifo-names-in-sysctl-doc.patch
hung_task-add-hung_task_sys_info-sysctl-to-dump-sys-info-on-task-hung.patch
watchdog-add-sys_info-sysctls-to-dump-sys-info-on-system-lockup.patch
sys_info-add-a-default-kernel-sys_info-mask.patch

