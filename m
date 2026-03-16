Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5CF23CE495
	for <mm-commits@vger.kernel.org>; Mon, 16 Mar 2026 16:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773679622; cv=none; b=iCL+hTWqWK/RG5gIbbHOjJt65FPtIO3C4NUM4e2vxIHuzvzORrE8so+p254wgNW30R2HI1dcLmKZ8wKA7bynYC+Fo7aRM8J6b/zbQIMie78dXXM+OWKWZUxaSI8GgdYh2NpUrdJjFgWuRhJgCH4gTD1DvVm2ZNrZqh9zz2B9Twk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773679622; c=relaxed/simple;
	bh=9o4TPC7StM5yq2dZY94hf6HEjhlgd46KrgpXNQRguPU=;
	h=Date:To:From:Subject:Message-Id; b=BGEvEGdW9TsENr6nOoWPGac8lHFWZvydKUTJE9y8HzWdkcWQfinIRx6tXAFGpWWfsgZMhhwf64W17IuN5kT+2h1ovpBeYArvsB4hms1BXBWz6763niYUWxkQO2vgSb+NVVvIS+VT7WJ9/8NuTy0xqsbnG0P6nTbPszfB8QOBoHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IBI/V5Po; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IBI/V5Po"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F118C19421;
	Mon, 16 Mar 2026 16:47:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773679622;
	bh=9o4TPC7StM5yq2dZY94hf6HEjhlgd46KrgpXNQRguPU=;
	h=Date:To:From:Subject:From;
	b=IBI/V5Po2JfEVrahFxBErLP3HeI+UBHtiFPV7UzV5OBJ+PDpPcQDrf0Qlfe6g9Nv8
	 7BOBpeotnU+mhFNuaZULCQHY4CK1eCm3J3bMj106hr2WW7Wzda+YIVsoTB4OHKGMWk
	 nCt0JXMp+xKeP0Fpt3TH0/NkNKQyl3NZOzaln/AY=
Date: Mon, 16 Mar 2026 09:47:01 -0700
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,yuanchu@google.com,weixugc@google.com,tballasi@linux.microsoft.com,shakeel.butt@linux.dev,mhocko@kernel.org,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,lorenzo.stoakes@oracle.com,hannes@cmpxchg.org,david@kernel.org,axelrasmussen@google.com,rostedt@goodmis.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tracing-add-__event_in_irq-helpers.patch added to mm-unstable branch
Message-Id: <20260316164702.4F118C19421@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tracing: add __event_in_*irq() helpers
has been added to the -mm mm-unstable branch.  Its filename is
     tracing-add-__event_in_irq-helpers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tracing-add-__event_in_irq-helpers.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Steven Rostedt <rostedt@goodmis.org>
Subject: tracing: add __event_in_*irq() helpers
Date: Mon, 16 Mar 2026 09:09:06 -0700

Patch series "mm: vmscan: add PID and cgroup ID to vmscan tracepoints", v8.


This patch (of 3):

Some trace events want to expose in their output if they were triggered in
an interrupt or softirq context.  Instead of recording this in the event
structure itself, as this information is stored in the flags portion of
the event header, add helper macros that can be used in the print format:

  TP_printk("val=%d %s", __entry->val, __event_in_irq() ? "(in-irq)" : "")

This will output "(in-irq)" for the event in the trace data if the event
was triggered in hard or soft interrupt context.

Link: https://lkml.kernel.org/r/20260316160908.42727-1-tballasi@linux.microsoft.com
Link: https://lore.kernel.org/all/20251229132942.31a2b583@gandalf.local.home/
Link: https://lkml.kernel.org/r/20260316160908.42727-2-tballasi@linux.microsoft.com
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Thomas Ballasi <tballasi@linux.microsoft.com>
Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/stages/stage3_trace_output.h |    8 ++++++++
 include/trace/stages/stage7_class_define.h |   19 +++++++++++++++++++
 2 files changed, 27 insertions(+)

--- a/include/trace/stages/stage3_trace_output.h~tracing-add-__event_in_irq-helpers
+++ a/include/trace/stages/stage3_trace_output.h
@@ -150,3 +150,11 @@
 
 #undef __get_buf
 #define __get_buf(len)		trace_seq_acquire(p, (len))
+
+#undef __event_in_hardirq
+#undef __event_in_softirq
+#undef __event_in_irq
+
+#define __event_in_hardirq()	(__entry->ent.flags & TRACE_FLAG_HARDIRQ)
+#define __event_in_softirq()	(__entry->ent.flags & TRACE_FLAG_SOFTIRQ)
+#define __event_in_irq()	(__entry->ent.flags & (TRACE_FLAG_HARDIRQ | TRACE_FLAG_SOFTIRQ))
--- a/include/trace/stages/stage7_class_define.h~tracing-add-__event_in_irq-helpers
+++ a/include/trace/stages/stage7_class_define.h
@@ -26,6 +26,25 @@
 #undef __print_hex_dump
 #undef __get_buf
 
+#undef __event_in_hardirq
+#undef __event_in_softirq
+#undef __event_in_irq
+
+/*
+ * The TRACE_FLAG_* are enums. Instead of using TRACE_DEFINE_ENUM(),
+ * use their hardcoded values. These values are parsed by user space
+ * tooling elsewhere so they will never change.
+ *
+ * See "enum trace_flag_type" in linux/trace_events.h:
+ *   TRACE_FLAG_HARDIRQ
+ *   TRACE_FLAG_SOFTIRQ
+ */
+
+/* This is what is displayed in the format files */
+#define __event_in_hardirq()	(REC->common_flags & 0x8)
+#define __event_in_softirq()	(REC->common_flags & 0x10)
+#define __event_in_irq()	(REC->common_flags & 0x18)
+
 /*
  * The below is not executed in the kernel. It is only what is
  * displayed in the print format for userspace to parse.
_

Patches currently in -mm which might be from rostedt@goodmis.org are

tracing-add-__event_in_irq-helpers.patch

