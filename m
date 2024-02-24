Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93E9A19A
	for <mm-commits@vger.kernel.org>; Sat, 24 Feb 2024 00:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708733864; cv=none; b=r/cELoqH1NfD6oYAuN5XtRe7ifN+OjSUp+AuUxPGhCpHQwm0Pbac6wHWz4m2JH9OgMDdHbymGrtG7Wqx+0XBxNj/k9SYE8prEOqFzXK8s8r4QXxsrmAm0PDNkW8r5T2IxJGGisrMvFJP3fw0GgJiia6GSsB0jljU1V/0yHYf4vU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708733864; c=relaxed/simple;
	bh=AWIHbW09OKeDCm4TIfYA3hJR6eQ6V32jPkN0qW9AXQI=;
	h=Date:To:From:Subject:Message-Id; b=o7EATrpxeRF1GU9Ao2BTBV1Tgca0BmZDL1gGPRAbu++QeWDMdNZoAL1VBNMp3vhC9A9QIQhrfhkZVy0cwkJRyJs4wYKzm7Arz+GssrIhfpwepvER9Wgdd+JnvtwrljRoiqDHU4CfzVW/GJManD+lo9ha0uxu5zAWRd7ox4htXlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LcKWTWB0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LcKWTWB0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB006C433F1;
	Sat, 24 Feb 2024 00:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708733864;
	bh=AWIHbW09OKeDCm4TIfYA3hJR6eQ6V32jPkN0qW9AXQI=;
	h=Date:To:From:Subject:From;
	b=LcKWTWB0TWuGMXGt8Xo/g714q4Kc75XJbxv3ESYCxPZKKB38Fe/IZWMsCiSsP16R/
	 b0wx6y4prSHju6R+n3LEjtSL3HMbeSww2M/x4IEdax/4sehACJ1h45OXxG4ClGAaBK
	 W27BGfQyvQYHLSYwmaW4LQozNlXWpqDMjAvdCyL4=
Date: Fri, 23 Feb 2024 16:17:43 -0800
To: mm-commits@vger.kernel.org,surenb@google.com,rostedt@goodmis.org,mhocko@suse.com,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,carlosgalo@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-update-mark_victim-tracepoints-fields.patch added to mm-unstable branch
Message-Id: <20240224001743.EB006C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: update mark_victim tracepoints fields
has been added to the -mm mm-unstable branch.  Its filename is
     mm-update-mark_victim-tracepoints-fields.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-update-mark_victim-tracepoints-fields.patch

This patch will later appear in the mm-unstable branch at
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

mm-update-mark_victim-tracepoints-fields.patch

