Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBD1036494E
	for <mm-commits@vger.kernel.org>; Tue, 24 Mar 2026 21:43:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774388600; cv=none; b=uK3SpLG0ccPcxQjlTu6lGb+H+7YroAYRUtgJiygZ+iPiOt73kKNhJxoFzoVhK/3kK55AaUKC9ixJzmfI+6U5swM/krJPmQjvXV7Ea6D76XcWG/L6jQxtKQMQNZ9UXgpHbpNaHzoI0cW9OMU9NnEECBEMDKmkyKwlWOiCqBcy+o0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774388600; c=relaxed/simple;
	bh=nptuP231siyt2ngCvC84u+hQdypKeplj6dhMkajPmXE=;
	h=Date:To:From:Subject:Message-Id; b=ZYHQAsrVvMV6kbCkd0Pr2SXXn0/gmywBrhVs42ooo1Q/7Nb35Q0WmZl8CKIsPe6XjaXxIGcikfeaC+uLBHuIsB0YrKG+CAgI10WcLviXVJ2XOBZv2vNSBPXOWPD8KGhIdGRc9lFR9wd/3f4RmFT5mOq0l4+ru4Bcy0Chy578kCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=K/Lyb58K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="K/Lyb58K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4BDEC19424;
	Tue, 24 Mar 2026 21:43:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774388600;
	bh=nptuP231siyt2ngCvC84u+hQdypKeplj6dhMkajPmXE=;
	h=Date:To:From:Subject:From;
	b=K/Lyb58KZoLdIpBJf9I8qGI0JHBMPPcmDq803XwYYHzDm4HhlzbRE94aMtLg1d+K9
	 LbVuRD2E9td6sW5qwCTNfurUsh6F5TdTvGIrejktg2O/mYFH7F7q/FYq4i2Xs/brjC
	 4GuoSiVnS9uHJqefivFSbr+p9CID6Ifys+XLtC+4=
Date: Tue, 24 Mar 2026 14:43:20 -0700
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,yuanchu@google.com,weixugc@google.com,tballasi@linux.microsoft.com,shakeel.butt@linux.dev,mhocko@kernel.org,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,lorenzo.stoakes@oracle.com,hannes@cmpxchg.org,david@kernel.org,axelrasmussen@google.com,rostedt@goodmis.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] tracing-add-__event_in_irq-helpers.patch removed from -mm tree
Message-Id: <20260324214320.A4BDEC19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: tracing: add __event_in_*irq() helpers
has been removed from the -mm tree.  Its filename was
     tracing-add-__event_in_irq-helpers.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


