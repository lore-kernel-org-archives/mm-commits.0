From: akpm@linux-foundation.org
Subject: [alternative-merged]
 trace-move-trace_seq_overflowed-out-of-line.patch removed from -mm tree
Date: Thu, 16 Mar 2017 12:40:34 -0700
Message-ID: <58caea32.Rfsh5IJ4h35uhaus%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36128 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752156AbdCPTkg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Mar 2017 15:40:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ak@linux.intel.com, rostedt@goodmis.org, mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/trace_seq.h: wove trace_seq_overflowed() out of line
has been removed from the -mm tree.  Its filename was
     trace-move-trace_seq_overflowed-out-of-line.patch

This patch was dropped because an alternative patch was merged

------------------------------------------------------
From: Andi Kleen <ak@linux.intel.com>
Subject: include/linux/trace_seq.h: wove trace_seq_overflowed() out of line

Inlining trace_seq_overflowed takes ~17k in text size in my kernel.  The
function doesn't seem to be time critical, so we can just out of line it.

Function                                           Total          Avg   Num
trace_seq_has_overflowed                           17134 (0.00%)  33    514

This saves around 6k here

   text    data     bss     dec     hex filename
9102881 5367568 11116544        25586993        1866d31 vmlinux-orig
9096494 5367568 11116544        25580606        186543e vmlinux-trace-seq

Link: http://lkml.kernel.org/r/20170315021431.13107-2-andi@firstfloor.org
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/trace_seq.h |   12 +-----------
 kernel/trace/trace_seq.c  |   15 +++++++++++++++
 2 files changed, 16 insertions(+), 11 deletions(-)

diff -puN include/linux/trace_seq.h~trace-move-trace_seq_overflowed-out-of-line include/linux/trace_seq.h
--- a/include/linux/trace_seq.h~trace-move-trace_seq_overflowed-out-of-line
+++ a/include/linux/trace_seq.h
@@ -56,17 +56,7 @@ trace_seq_buffer_ptr(struct trace_seq *s
 	return s->buffer + seq_buf_used(&s->seq);
 }
 
-/**
- * trace_seq_has_overflowed - return true if the trace_seq took too much
- * @s: trace sequence descriptor
- *
- * Returns true if too much data was added to the trace_seq and it is
- * now full and will not take anymore.
- */
-static inline bool trace_seq_has_overflowed(struct trace_seq *s)
-{
-	return s->full || seq_buf_has_overflowed(&s->seq);
-}
+bool trace_seq_has_overflowed(struct trace_seq *s);
 
 /*
  * Currently only defined when tracing is enabled.
diff -puN kernel/trace/trace_seq.c~trace-move-trace_seq_overflowed-out-of-line kernel/trace/trace_seq.c
--- a/kernel/trace/trace_seq.c~trace-move-trace_seq_overflowed-out-of-line
+++ a/kernel/trace/trace_seq.c
@@ -375,3 +375,18 @@ int trace_seq_to_user(struct trace_seq *
 	return seq_buf_to_user(&s->seq, ubuf, cnt);
 }
 EXPORT_SYMBOL_GPL(trace_seq_to_user);
+
+
+
+/**
+ * trace_seq_has_overflowed - return true if the trace_seq took too much
+ * @s: trace sequence descriptor
+ *
+ * Returns true if too much data was added to the trace_seq and it is
+ * now full and will not take anymore.
+ */
+bool trace_seq_has_overflowed(struct trace_seq *s)
+{
+	return s->full || seq_buf_has_overflowed(&s->seq);
+}
+EXPORT_SYMBOL_GPL(trace_seq_has_overflowed);
_

Patches currently in -mm which might be from ak@linux.intel.com are

x86-atomic-move-__atomic_add_unless-out-of-line.patch
sched-out-of-line-__update_load_avg.patch
kref-remove-warn_on-for-null-release-functions.patch
out-of-line-dma_alloc-free_attrs.patch
megasas-remove-expensive-inline-from-megasas_return_cmd.patch
remove-expensive-warn_on-in-pagefault_disabled_dec.patch

