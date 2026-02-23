Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6849233EB06
	for <mm-commits@vger.kernel.org>; Mon, 23 Feb 2026 18:33:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771871585; cv=none; b=Gedu/5PsmDSSen2YVfukKyRQxWuXiFg+OzzqcNqCUPDc/s/kuMPDHJlt2CWpejXpvp1RrrkCnKXGq/JWA7tehVUr1nbhcnhYqlg5TflNa3yJzcbZP2RUbQ/4es9TspKkanuNZjaUlqyPps8wxK/enLOuHpJ5B1/ReLABQYxTaa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771871585; c=relaxed/simple;
	bh=7ossWQh1eiWMyf4xOsrJk/X7ZE8iLP3G+Cpx8y6jX7M=;
	h=Date:To:From:Subject:Message-Id; b=NOdX+wQEkbGaFKvZrW+BPJWjD2bboAED4ZvRzjkpBQ4ZuMLics7RwtLKmHc5VMjZc0eYhJgaCwTfVpv0QO7BgogfQBsMPC018JIblLka9lKOv8d28EMXrxcicG4f0FSaJeupck9ulpIFiZEw60rZHLpJigWFnNfFoNme82vExPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ATtXyDR3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ATtXyDR3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E906EC116C6;
	Mon, 23 Feb 2026 18:33:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1771871585;
	bh=7ossWQh1eiWMyf4xOsrJk/X7ZE8iLP3G+Cpx8y6jX7M=;
	h=Date:To:From:Subject:From;
	b=ATtXyDR3y9051T6CW88Lx39jXPauBgR4lY5pAi4CMieDByuZZGnNhjZtMYz8P3XKH
	 YCwnpsc/ngUrTQwfoePNy1XAmAiiW7KaBf9y5tWYUcgvsFM8X6JYo9Q3cGiIUyPWe2
	 tg7zp6CUlE9wL/6eKU8BWBhLP61JjHBD+Iiw4/uA=
Date: Mon, 23 Feb 2026 10:33:04 -0800
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,yuanchu@google.com,weixugc@google.com,tballasi@linux.microsoft.com,shakeel.butt@linux.dev,mhocko@kernel.org,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,lorenzo.stoakes@oracle.com,hannes@cmpxchg.org,david@kernel.org,axelrasmussen@google.com,rostedt@goodmis.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tracing-add-__event_in_irq-helpers.patch added to mm-new branch
Message-Id: <20260223183304.E906EC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tracing: add __event_in_*irq() helpers
has been added to the -mm mm-new branch.  Its filename is
     tracing-add-__event_in_irq-helpers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tracing-add-__event_in_irq-helpers.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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
Date: Mon, 23 Feb 2026 09:15:42 -0800

Patch series "mm: vmscan: add PID and cgroup ID to vmscan tracepoints",
v7.


This patch (of 3):

Some trace events want to expose in their output if they were triggered in
an interrupt or softirq context.  Instead of recording this in the event
structure itself, as this information is stored in the flags portion of
the event header, add helper macros that can be used in the print format:

  TP_printk("val=%d %s", __entry->val, __event_in_irq() ? "(in-irq)" : "")

This will output "(in-irq)" for the event in the trace data if the event
was triggered in hard or soft interrupt context.

Link: https://lkml.kernel.org/r/20260223171544.4750-1-tballasi@linux.microsoft.com
Link: https://lore.kernel.org/all/20251229132942.31a2b583@gandalf.local.home/
Link: https://lkml.kernel.org/r/20260223171544.4750-2-tballasi@linux.microsoft.com
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Thomas Ballasi <tballasi@linux.microsoft.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
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

