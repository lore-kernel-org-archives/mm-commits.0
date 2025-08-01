Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 311021EF38F
	for <mm-commits@vger.kernel.org>; Fri,  1 Aug 2025 22:08:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754086100; cv=none; b=oVwZIikxwCOlilflOwd+ErGGoC+mdKTTONvAdENFEGdGn5s7zj5arFs4yVz5BIJRc5XDHdhNBC+VP3ccu9vt6BvmovwdW2rgKfpD1Fri778oErCCxfTVeVEuOIeapO3sC0A/iH23xS0XzL8PyUnDY7sUzcAC5yXI+/+2AF5tLqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754086100; c=relaxed/simple;
	bh=IRbhaKmr0LF3UJtFKBJ0RNOwj1k5JpyEdPp2U5fKg3c=;
	h=Date:To:From:Subject:Message-Id; b=Mn9ZZMvSDmFK17us6N0zRRG69gMLY9xiK1XT3DG/fof6F0hUKXJcUq1MRX1+MMPGm2i4wbVIY5Dbq/F5l+A43vkdq1NLE4rWqxW086TQ65xfsjrn583cGmAKe3gASUui9RaMgH4SEKyKBUUav4YGLCdQd7KrYgG8EgZHGxyWF/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AjC42VV3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AjC42VV3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BC22C4CEF4;
	Fri,  1 Aug 2025 22:08:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754086099;
	bh=IRbhaKmr0LF3UJtFKBJ0RNOwj1k5JpyEdPp2U5fKg3c=;
	h=Date:To:From:Subject:From;
	b=AjC42VV3UBz/blkcIftt83p6R3C+GMZzfKjbUQHqOZGykmziUz8vq5OlYkAN9SwpL
	 Skyl/BWd3ADxkol1bkESv+eEV6Gwwhl2QPz3XICy4hbmxG/mTnosGbdiu68cmvcmwg
	 +2E10w8VnNntD1TasFxm4KzP9O3u/yl08T9xxR4c=
Date: Fri, 01 Aug 2025 15:08:19 -0700
To: mm-commits@vger.kernel.org,senozhatsky@chromium.org,lance.yang@linux.dev,mhiramat@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + hung_task-dump-blocker-task-if-it-is-not-hung.patch added to mm-nonmm-unstable branch
Message-Id: <20250801220819.8BC22C4CEF4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: hung_task: dump blocker task if it is not hung
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     hung_task-dump-blocker-task-if-it-is-not-hung.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hung_task-dump-blocker-task-if-it-is-not-hung.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Subject: hung_task: dump blocker task if it is not hung
Date: Thu, 31 Jul 2025 07:11:54 +0900

Dump the lock blocker task if it is not hung because if the blocker task
is also hung, it should be dumped by the detector.  This will de-duplicate
the same stackdumps if the blocker task is also blocked by another task
(and hung).

Link: https://lkml.kernel.org/r/175391351423.688839.11917911323784986774.stgit@devnote2
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Suggested-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Tested-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Acked-by: Lance Yang <lance.yang@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/hung_task.c |   78 ++++++++++++++++++++++---------------------
 1 file changed, 41 insertions(+), 37 deletions(-)

--- a/kernel/hung_task.c~hung_task-dump-blocker-task-if-it-is-not-hung
+++ a/kernel/hung_task.c
@@ -95,9 +95,41 @@ static struct notifier_block panic_block
 	.notifier_call = hung_task_panic,
 };
 
+static bool task_is_hung(struct task_struct *t, unsigned long timeout)
+{
+	unsigned long switch_count = t->nvcsw + t->nivcsw;
+	unsigned int state = READ_ONCE(t->__state);
+
+	/*
+	 * skip the TASK_KILLABLE tasks -- these can be killed
+	 * skip the TASK_IDLE tasks -- those are genuinely idle
+	 * skip the TASK_FROZEN task -- it reasonably stops scheduling by freezer
+	 */
+	if (!(state & TASK_UNINTERRUPTIBLE) ||
+	    (state & (TASK_WAKEKILL | TASK_NOLOAD | TASK_FROZEN)))
+		return false;
+
+	/*
+	 * When a freshly created task is scheduled once, changes its state to
+	 * TASK_UNINTERRUPTIBLE without having ever been switched out once, it
+	 * musn't be checked.
+	 */
+	if (unlikely(!switch_count))
+		return false;
+
+	if (switch_count != t->last_switch_count) {
+		t->last_switch_count = switch_count;
+		t->last_switch_time = jiffies;
+		return false;
+	}
+	if (time_is_after_jiffies(t->last_switch_time + timeout * HZ))
+		return false;
+
+	return true;
+}
 
 #ifdef CONFIG_DETECT_HUNG_TASK_BLOCKER
-static void debug_show_blocker(struct task_struct *task)
+static void debug_show_blocker(struct task_struct *task, unsigned long timeout)
 {
 	struct task_struct *g, *t;
 	unsigned long owner, blocker, blocker_type;
@@ -174,41 +206,21 @@ static void debug_show_blocker(struct ta
 			       t->pid, rwsem_blocked_by);
 			break;
 		}
-		sched_show_task(t);
+		/* Avoid duplicated task dump, skip if the task is also hung. */
+		if (!task_is_hung(t, timeout))
+			sched_show_task(t);
 		return;
 	}
 }
 #else
-static inline void debug_show_blocker(struct task_struct *task)
+static inline void debug_show_blocker(struct task_struct *task, unsigned long timeout)
 {
 }
 #endif
 
 static void check_hung_task(struct task_struct *t, unsigned long timeout)
 {
-	unsigned long switch_count = t->nvcsw + t->nivcsw;
-
-	/*
-	 * Ensure the task is not frozen.
-	 * Also, skip vfork and any other user process that freezer should skip.
-	 */
-	if (unlikely(READ_ONCE(t->__state) & TASK_FROZEN))
-		return;
-
-	/*
-	 * When a freshly created task is scheduled once, changes its state to
-	 * TASK_UNINTERRUPTIBLE without having ever been switched out once, it
-	 * musn't be checked.
-	 */
-	if (unlikely(!switch_count))
-		return;
-
-	if (switch_count != t->last_switch_count) {
-		t->last_switch_count = switch_count;
-		t->last_switch_time = jiffies;
-		return;
-	}
-	if (time_is_after_jiffies(t->last_switch_time + timeout * HZ))
+	if (!task_is_hung(t, timeout))
 		return;
 
 	/*
@@ -243,7 +255,7 @@ static void check_hung_task(struct task_
 		pr_err("\"echo 0 > /proc/sys/kernel/hung_task_timeout_secs\""
 			" disables this message.\n");
 		sched_show_task(t);
-		debug_show_blocker(t);
+		debug_show_blocker(t, timeout);
 		hung_task_show_lock = true;
 
 		if (sysctl_hung_task_all_cpu_backtrace)
@@ -299,7 +311,6 @@ static void check_hung_uninterruptible_t
 	hung_task_show_lock = false;
 	rcu_read_lock();
 	for_each_process_thread(g, t) {
-		unsigned int state;
 
 		if (!max_count--)
 			goto unlock;
@@ -308,15 +319,8 @@ static void check_hung_uninterruptible_t
 				goto unlock;
 			last_break = jiffies;
 		}
-		/*
-		 * skip the TASK_KILLABLE tasks -- these can be killed
-		 * skip the TASK_IDLE tasks -- those are genuinely idle
-		 */
-		state = READ_ONCE(t->__state);
-		if ((state & TASK_UNINTERRUPTIBLE) &&
-		    !(state & TASK_WAKEKILL) &&
-		    !(state & TASK_NOLOAD))
-			check_hung_task(t, timeout);
+
+		check_hung_task(t, timeout);
 	}
  unlock:
 	rcu_read_unlock();
_

Patches currently in -mm which might be from mhiramat@kernel.org are

hung_task-dump-blocker-task-if-it-is-not-hung.patch

