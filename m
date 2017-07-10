From: akpm@linux-foundation.org
Subject: [patch 038/115] mm/oom_kill.c: add tracepoints for oom
 reaper-related events
Date: Mon, 10 Jul 2017 15:49:05 -0700
Message-ID: <20170710224905.SWi4bApa2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42706 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932077AbdGJWtL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Jul 2017 18:49:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, guro@fb.com, hannes@cmpxchg.org, mhocko@suse.com, mm-commits@vger.kernel.org, penguin-kernel@I-love.SAKURA.ne.jp, torvalds@linux-foundation.org, vdavydov.dev@gmail.com

From: Roman Gushchin <guro@fb.com>
Subject: mm/oom_kill.c: add tracepoints for oom reaper-related events

During the debugging of the problem described in
https://lkml.org/lkml/2017/5/17/542 and fixed by Tetsuo Handa in
https://lkml.org/lkml/2017/5/19/383 , I've found that the existing debug
output is not really useful to understand issues related to the oom
reaper.

So, I assume, that adding some tracepoints might help with debugging of
similar issues.

Trace the following events:
1) a process is marked as an oom victim,
2) a process is added to the oom reaper list,
3) the oom reaper starts reaping process's mm,
4) the oom reaper finished reaping,
5) the oom reaper skips reaping.

How it works in practice?  Below is an example which show how the problem
mentioned above can be found: one process is added twice to the oom_reaper
list:

$ cd /sys/kernel/debug/tracing
$ echo "oom:mark_victim" > set_event
$ echo "oom:wake_reaper" >> set_event
$ echo "oom:skip_task_reaping" >> set_event
$ echo "oom:start_task_reaping" >> set_event
$ echo "oom:finish_task_reaping" >> set_event
$ cat trace_pipe
        allocate-502   [001] ....    91.836405: mark_victim: pid=502
        allocate-502   [001] .N..    91.837356: wake_reaper: pid=502
        allocate-502   [000] .N..    91.871149: wake_reaper: pid=502
      oom_reaper-23    [000] ....    91.871177: start_task_reaping: pid=502
      oom_reaper-23    [000] .N..    91.879511: finish_task_reaping: pid=502
      oom_reaper-23    [000] ....    91.879580: skip_task_reaping: pid=502

Link: http://lkml.kernel.org/r/20170530185231.GA13412@castle
Signed-off-by: Roman Gushchin <guro@fb.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/oom.h |   80 +++++++++++++++++++++++++++++++++++
 mm/oom_kill.c              |    7 +++
 2 files changed, 87 insertions(+)

diff -puN include/trace/events/oom.h~mmoom-add-tracepoints-for-oom-reaper-related-events include/trace/events/oom.h
--- a/include/trace/events/oom.h~mmoom-add-tracepoints-for-oom-reaper-related-events
+++ a/include/trace/events/oom.h
@@ -70,6 +70,86 @@ TRACE_EVENT(reclaim_retry_zone,
 			__entry->wmark_check)
 );
 
+TRACE_EVENT(mark_victim,
+	TP_PROTO(int pid),
+
+	TP_ARGS(pid),
+
+	TP_STRUCT__entry(
+		__field(int, pid)
+	),
+
+	TP_fast_assign(
+		__entry->pid = pid;
+	),
+
+	TP_printk("pid=%d", __entry->pid)
+);
+
+TRACE_EVENT(wake_reaper,
+	TP_PROTO(int pid),
+
+	TP_ARGS(pid),
+
+	TP_STRUCT__entry(
+		__field(int, pid)
+	),
+
+	TP_fast_assign(
+		__entry->pid = pid;
+	),
+
+	TP_printk("pid=%d", __entry->pid)
+);
+
+TRACE_EVENT(start_task_reaping,
+	TP_PROTO(int pid),
+
+	TP_ARGS(pid),
+
+	TP_STRUCT__entry(
+		__field(int, pid)
+	),
+
+	TP_fast_assign(
+		__entry->pid = pid;
+	),
+
+	TP_printk("pid=%d", __entry->pid)
+);
+
+TRACE_EVENT(finish_task_reaping,
+	TP_PROTO(int pid),
+
+	TP_ARGS(pid),
+
+	TP_STRUCT__entry(
+		__field(int, pid)
+	),
+
+	TP_fast_assign(
+		__entry->pid = pid;
+	),
+
+	TP_printk("pid=%d", __entry->pid)
+);
+
+TRACE_EVENT(skip_task_reaping,
+	TP_PROTO(int pid),
+
+	TP_ARGS(pid),
+
+	TP_STRUCT__entry(
+		__field(int, pid)
+	),
+
+	TP_fast_assign(
+		__entry->pid = pid;
+	),
+
+	TP_printk("pid=%d", __entry->pid)
+);
+
 #ifdef CONFIG_COMPACTION
 TRACE_EVENT(compact_retry,
 
diff -puN mm/oom_kill.c~mmoom-add-tracepoints-for-oom-reaper-related-events mm/oom_kill.c
--- a/mm/oom_kill.c~mmoom-add-tracepoints-for-oom-reaper-related-events
+++ a/mm/oom_kill.c
@@ -490,6 +490,7 @@ static bool __oom_reap_task_mm(struct ta
 
 	if (!down_read_trylock(&mm->mmap_sem)) {
 		ret = false;
+		trace_skip_task_reaping(tsk->pid);
 		goto unlock_oom;
 	}
 
@@ -500,9 +501,12 @@ static bool __oom_reap_task_mm(struct ta
 	 */
 	if (!mmget_not_zero(mm)) {
 		up_read(&mm->mmap_sem);
+		trace_skip_task_reaping(tsk->pid);
 		goto unlock_oom;
 	}
 
+	trace_start_task_reaping(tsk->pid);
+
 	/*
 	 * Tell all users of get_user/copy_from_user etc... that the content
 	 * is no longer stable. No barriers really needed because unmapping
@@ -544,6 +548,7 @@ static bool __oom_reap_task_mm(struct ta
 	 * put the oom_reaper out of the way.
 	 */
 	mmput_async(mm);
+	trace_finish_task_reaping(tsk->pid);
 unlock_oom:
 	mutex_unlock(&oom_lock);
 	return ret;
@@ -615,6 +620,7 @@ static void wake_oom_reaper(struct task_
 	tsk->oom_reaper_list = oom_reaper_list;
 	oom_reaper_list = tsk;
 	spin_unlock(&oom_reaper_lock);
+	trace_wake_reaper(tsk->pid);
 	wake_up(&oom_reaper_wait);
 }
 
@@ -666,6 +672,7 @@ static void mark_oom_victim(struct task_
 	 */
 	__thaw_task(tsk);
 	atomic_inc(&oom_victims);
+	trace_mark_victim(tsk->pid);
 }
 
 /**
_
