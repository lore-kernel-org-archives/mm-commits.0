Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95E0E5820D
	for <mm-commits@vger.kernel.org>; Thu, 11 Jan 2024 22:04:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DW9Q3aHb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D7DFC433F1;
	Thu, 11 Jan 2024 22:04:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1705010658;
	bh=jdrP3nk70gcwwhMdapEF54kZMN7/hG4fryrHKgkF2J0=;
	h=Date:To:From:Subject:From;
	b=DW9Q3aHbS7bTpVPKZmxfCvMEa8rSCQlLPHDNNNG6YG3OD90Smnw7ZKWsz7SNyjCt8
	 CtlLmmXqtJiAFIJ+ewWHwbX6JBfhxrCIk0yHfhLq5KY9abJzdwWRPykT/Fu1/Gtsp+
	 3DacZPC0rrBfwTk7D3TWLHrfq3/vmRz+j4LDdvRo=
Date: Thu, 11 Jan 2024 14:04:17 -0800
To: mm-commits@vger.kernel.org,surenb@google.com,rostedt@goodmis.org,carlosgalo@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-update-mark_victim-tracepoints-fields.patch added to mm-unstable branch
Message-Id: <20240111220418.1D7DFC433F1@smtp.kernel.org>
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
Date: Thu, 11 Jan 2024 21:05:30 +0000

The current implementation of the mark_victim tracepoint provides only the
process ID (pid) of the victim process.  This limitation poses challenges
for userspace tools that need additional information about the OOM victim.
The association between pid and the additional data may be lost after the
kill, making it difficult for userspace to correlate the OOM event with
the specific process.

In order to mitigate this limitation, add the following fields:

- UID
   In Android each installed application has a unique UID. Including
   the `uid` assists in correlating OOM events with specific apps.

- Process Name (comm)
   Enables identification of the affected process.

- OOM Score
   Allows userspace to get additional insights of the relative kill
   priority of the OOM victim.

Link: https://lkml.kernel.org/r/20240111210539.636607-1-carlosgalo@google.com
Signed-off-by: Carlos Galo <carlosgalo@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/oom.h |   19 +++++++++++++++----
 mm/oom_kill.c              |    6 +++++-
 2 files changed, 20 insertions(+), 5 deletions(-)

--- a/include/trace/events/oom.h~mm-update-mark_victim-tracepoints-fields
+++ a/include/trace/events/oom.h
@@ -72,19 +72,30 @@ TRACE_EVENT(reclaim_retry_zone,
 );
 
 TRACE_EVENT(mark_victim,
-	TP_PROTO(int pid),
+	TP_PROTO(struct task_struct *task, uid_t uid),
 
-	TP_ARGS(pid),
+	TP_ARGS(task, uid),
 
 	TP_STRUCT__entry(
 		__field(int, pid)
+		__field(uid_t, uid)
+		__string(comm, task->comm)
+		__field(short, oom_score_adj)
 	),
 
 	TP_fast_assign(
-		__entry->pid = pid;
+		__entry->pid = task->pid;
+		__entry->uid = uid;
+		__assign_str(comm, task->comm);
+		__entry->oom_score_adj = task->signal->oom_score_adj;
 	),
 
-	TP_printk("pid=%d", __entry->pid)
+	TP_printk("pid=%d uid=%u comm=%s oom_score_adj=%hd",
+		__entry->pid,
+		__entry->uid,
+		__get_str(comm),
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

