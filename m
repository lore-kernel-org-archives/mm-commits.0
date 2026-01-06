Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D775523D294
	for <mm-commits@vger.kernel.org>; Tue,  6 Jan 2026 03:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767670723; cv=none; b=p4E4AuELhDrHYSmJ6VI91MXgcT2p/LUf+R+We5xD0IJd9fWocGolcLGRkYdPnelzgZURsuuMB/B5HJUdb7CvFD936T9JYCkHk4eXhwF1iL9kFos1cZ6njgzx3hUHa37IQqZAfoBIZEU3ZgFiET7dYm0CG7hBdrcRhv8/PDD4Eow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767670723; c=relaxed/simple;
	bh=GBRDuG0yNGBV0YHiJhdvxtX8w8HNaVehXbb2bGdiCbo=;
	h=Date:To:From:Subject:Message-Id; b=MgYWz3hLf55ma+mI2jOELHhyoJCT1LibxVtHmVqgmx3BTy2PVXC78lSMQFVz9vFg/IIIegB85lKJ+TTpp8whANqi3VMC46nzgJ7+P9Tzs0GOU66mh1vjc4CQEEs1sE6xu3smF/mlC74igiUL82KC48jRtHIwOgfs8iFYnWErBu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1B2e44bu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1B2e44bu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 559EBC116D0;
	Tue,  6 Jan 2026 03:38:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767670722;
	bh=GBRDuG0yNGBV0YHiJhdvxtX8w8HNaVehXbb2bGdiCbo=;
	h=Date:To:From:Subject:From;
	b=1B2e44bu77Py5uHAZEMB1+az9sXty5mtpiH+79AoLWHE0V9f4kIzF29lnZwVk/3LX
	 SwmTr5UqS7Bm9W8eZV/b010lKITSoFAd05m2bwlvevqEBs472YjWPBkNVk4/YVuaRS
	 YLjTu2MIQM8J1nPVbKuhL/zAwP7wwncnMUBvpycM=
Date: Mon, 05 Jan 2026 19:38:41 -0800
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,yuanchu@google.com,weixugc@google.com,tballasi@linux.microsoft.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,lorenzo.stoakes@oracle.com,hannes@cmpxchg.org,david@kernel.org,david@fromorbit.com,axelrasmussen@google.com,rostedt@goodmis.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tracing-add-__event_in_irq-helpers.patch added to mm-new branch
Message-Id: <20260106033842.559EBC116D0@smtp.kernel.org>
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
Date: Mon, 29 Dec 2025 16:35:15 -0500

Some trace events want to expose in their output if they were triggered in
an interrupt or softirq context.  Instead of recording this in the event
structure itself, as this information is stored in the flags portion of
the event header, add helper macros that can be used in the print format:

  TP_printk("val=%d %s", __entry->val, __entry_in_irq() ? "(in-irq)" : "")

This will output "(in-irq)" for the event in the trace data if the event
was triggered in hard or soft interrupt context.

Link: https://lore.kernel.org/all/20251229132942.31a2b583@gandalf.local.home/
Link: https://lkml.kernel.org/r/20251229163515.3d1b0bba@gandalf.local.home
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Thomas Ballasi <tballasi@linux.microsoft.com>
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

