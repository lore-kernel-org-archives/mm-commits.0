Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA753101F2
	for <mm-commits@vger.kernel.org>; Tue,  5 Mar 2024 01:02:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709600532; cv=none; b=QryGU42uHLkSf3u89Pzf8hFVXY0QiVVgSXrLGFo7w6oDTANTJ8B1THJGs2YDtDKxbxtucAt1FP+dQF2RmABCsq2bsGW8tJF6ZKPz2FZb6eqVvD65kCqb9879VZWgFepw6E7Yc9RLxi+pBaQHHy1vjC3E2vuscl6eoaVhGftdLFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709600532; c=relaxed/simple;
	bh=g4xEAxIQQmU8gAgPnoblBCSHncuKiMRg0YNl+1wwWHs=;
	h=Date:To:From:Subject:Message-Id; b=rESB9eqseXjD+0pPT2vAz2DkCxTvca0M6Gd5p1Ah5MZoy1wSJ+JIk4srlJTMN5JnVQwcyh2lg2vy8rpCEefJfFoOXg9oUdN5gCf41nf7aJBjXRHmUtitciG7WOiZJUHfvc7bm2JKcc8EJOYv/iatIf++tdCyIkcXo7bK5mhlChY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BCEPQk22; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BCEPQk22"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C736C433C7;
	Tue,  5 Mar 2024 01:02:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709600532;
	bh=g4xEAxIQQmU8gAgPnoblBCSHncuKiMRg0YNl+1wwWHs=;
	h=Date:To:From:Subject:From;
	b=BCEPQk22HQFKOwuE314H6RdGJc24b5eZqc0YilHMnFl+EkvinQlvyty0/k+yqt/vb
	 QwINNaLzTdMxs8n1y2fj424YJ8lB5mxC7tRc8XN/+Jt9PR6uLk73aquiIJd8pkh6KW
	 9QAq57gXul46zP3GUCeVThVj3V2+bgrKiB75kY9E=
Date: Mon, 04 Mar 2024 17:02:12 -0800
To: mm-commits@vger.kernel.org,surenb@google.com,rostedt@goodmis.org,mhocko@suse.com,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,carlosgalo@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-update-mark_victim-tracepoints-fields.patch removed from -mm tree
Message-Id: <20240305010212.7C736C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: update mark_victim tracepoints fields
has been removed from the -mm tree.  Its filename was
     mm-update-mark_victim-tracepoints-fields.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Carlos Galo <carlosgalo@google.com>
Subject: mm: update mark_victim tracepoints fields
Date: Fri, 23 Feb 2024 17:32:49 +0000

The current implementation of the mark_victim tracepoint provides only the
process ID (pid) of the victim process.  This limitation poses challenges
for userspace tools requiring real-time OOM analysis and intervention. 
Although this information is available from the kernel logs, it’s not
the appropriate format to provide OOM notifications.  In Android, BPF
programs are used with the mark_victim trace events to notify userspace of
an OOM kill.  For consistency, update the trace event to include the same
information about the OOMed victim as the kernel logs.

- UID
   In Android each installed application has a unique UID. Including
   the `uid` assists in correlating OOM events with specific apps.

- Process Name (comm)
   Enables identification of the affected process.

- OOM Score
  Will allow userspace to get additional insight of the relative kill
  priority of the OOM victim. In Android, the oom_score_adj is used to
  categorize app state (foreground, background, etc.), which aids in
  analyzing user-perceptible impacts of OOM events [1].

- Total VM, RSS Stats, and pgtables
  Amount of memory used by the victim that will, potentially, be freed up
  by killing it.

[1] https://cs.android.com/android/platform/superproject/main/+/246dc8fc95b6d93afcba5c6d6c133307abb3ac2e:frameworks/base/services/core/java/com/android/server/am/ProcessList.java;l=188-283
Signed-off-by: Carlos Galo <carlosgalo@google.com>
Reviewed-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/oom.h |   36 +++++++++++++++++++++++++++++++----
 mm/oom_kill.c              |    6 ++++-
 2 files changed, 37 insertions(+), 5 deletions(-)

--- a/include/trace/events/oom.h~mm-update-mark_victim-tracepoints-fields
+++ a/include/trace/events/oom.h
@@ -7,6 +7,8 @@
 #include <linux/tracepoint.h>
 #include <trace/events/mmflags.h>
 
+#define PG_COUNT_TO_KB(x) ((x) << (PAGE_SHIFT - 10))
+
 TRACE_EVENT(oom_score_adj_update,
 
 	TP_PROTO(struct task_struct *task),
@@ -72,19 +74,45 @@ TRACE_EVENT(reclaim_retry_zone,
 );
 
 TRACE_EVENT(mark_victim,
-	TP_PROTO(int pid),
+	TP_PROTO(struct task_struct *task, uid_t uid),
 
-	TP_ARGS(pid),
+	TP_ARGS(task, uid),
 
 	TP_STRUCT__entry(
 		__field(int, pid)
+		__string(comm, task->comm)
+		__field(unsigned long, total_vm)
+		__field(unsigned long, anon_rss)
+		__field(unsigned long, file_rss)
+		__field(unsigned long, shmem_rss)
+		__field(uid_t, uid)
+		__field(unsigned long, pgtables)
+		__field(short, oom_score_adj)
 	),
 
 	TP_fast_assign(
-		__entry->pid = pid;
+		__entry->pid = task->pid;
+		__assign_str(comm, task->comm);
+		__entry->total_vm = PG_COUNT_TO_KB(task->mm->total_vm);
+		__entry->anon_rss = PG_COUNT_TO_KB(get_mm_counter(task->mm, MM_ANONPAGES));
+		__entry->file_rss = PG_COUNT_TO_KB(get_mm_counter(task->mm, MM_FILEPAGES));
+		__entry->shmem_rss = PG_COUNT_TO_KB(get_mm_counter(task->mm, MM_SHMEMPAGES));
+		__entry->uid = uid;
+		__entry->pgtables = mm_pgtables_bytes(task->mm) >> 10;
+		__entry->oom_score_adj = task->signal->oom_score_adj;
 	),
 
-	TP_printk("pid=%d", __entry->pid)
+	TP_printk("pid=%d comm=%s total-vm=%lukB anon-rss=%lukB file-rss:%lukB shmem-rss:%lukB uid=%u pgtables=%lukB oom_score_adj=%hd",
+		__entry->pid,
+		__get_str(comm),
+		__entry->total_vm,
+		__entry->anon_rss,
+		__entry->file_rss,
+		__entry->shmem_rss,
+		__entry->uid,
+		__entry->pgtables,
+		__entry->oom_score_adj
+	)
 );
 
 TRACE_EVENT(wake_reaper,
--- a/mm/oom_kill.c~mm-update-mark_victim-tracepoints-fields
+++ a/mm/oom_kill.c
@@ -44,6 +44,7 @@
 #include <linux/kthread.h>
 #include <linux/init.h>
 #include <linux/mmu_notifier.h>
+#include <linux/cred.h>
 
 #include <asm/tlb.h>
 #include "internal.h"
@@ -754,6 +755,7 @@ static inline void queue_oom_reaper(stru
  */
 static void mark_oom_victim(struct task_struct *tsk)
 {
+	const struct cred *cred;
 	struct mm_struct *mm = tsk->mm;
 
 	WARN_ON(oom_killer_disabled);
@@ -773,7 +775,9 @@ static void mark_oom_victim(struct task_
 	 */
 	__thaw_task(tsk);
 	atomic_inc(&oom_victims);
-	trace_mark_victim(tsk->pid);
+	cred = get_task_cred(tsk);
+	trace_mark_victim(tsk, cred->uid.val);
+	put_cred(cred);
 }
 
 /**
_

Patches currently in -mm which might be from carlosgalo@google.com are


