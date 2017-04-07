From: akpm@linux-foundation.org
Subject: [merged] tracing-move-trace_handle_return-out-of-line.patch
 removed from -mm tree
Date: Fri, 07 Apr 2017 12:34:29 -0700
Message-ID: <58e7e9c5.com6m/0cdyXcs7OW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50280 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753573AbdDGTef (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Apr 2017 15:34:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rostedt@goodmis.org, andi@firstfloor.org, mm-commits@vger.kernel.org


The patch titled
     Subject: tracing: move trace_handle_return() out of line
has been removed from the -mm tree.  Its filename was
     tracing-move-trace_handle_return-out-of-line.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Steven Rostedt <rostedt@goodmis.org>
Subject: tracing: move trace_handle_return() out of line

Currently trace_handle_return() looks like this:

 static inline enum print_line_t trace_handle_return(struct trace_seq *s)
 {
        return trace_seq_has_overflowed(s) ?
                TRACE_TYPE_PARTIAL_LINE : TRACE_TYPE_HANDLED;
 }

Where trace_seq_overflowed(s) is:

 static inline bool trace_seq_has_overflowed(struct trace_seq *s)
 {
	return s->full || seq_buf_has_overflowed(&s->seq);
 }

And seq_buf_has_overflowed(&s->seq) is:

 static inline bool
 seq_buf_has_overflowed(struct seq_buf *s)
 {
	return s->len > s->size;
 }

Making trace_handle_return() into:

 return (s->full || (s->seq->len > s->seq->size)) ?
           TRACE_TYPE_PARTIAL_LINE :
           TRACE_TYPE_HANDLED;

One would think this is not an issue to keep as an inline.  But because
this is used in the TRACE_EVENT() macro, it is extended for every
tracepoint in the system.  Taking a look at a single tracepoint
x86_irq_vector (was the first one I randomly chosen).  As
trace_handle_return is used in the TRACE_EVENT() macro of
trace_raw_output_##call() we disassemble trace_raw_output_x86_irq_vector
and do a diff.  I removed identical lines that were different just due to
different addresses.

The original has 22 bytes of text more than the out of line version.  As
this is for every TRACE_EVENT() defined in the system, this can become
quite large.

   text	   data	    bss	    dec	    hex	filename
8690305	5450490	1298432	15439227	 eb957b	vmlinux-orig
8681725	5450490	1298432	15430647	 eb73f7	vmlinux-handle

This change has a total of 8580 bytes in savings.

 $ objdump -dr /tmp/vmlinux-orig | grep '^[0-9a-f]* <trace_raw_output' | wc -l
324

That's 324 tracepoints. But this does not include modules (which contain
many more tracepoints). For an allyesconfig build:

 $ objdump -dr vmlinux-allyes-orig | grep '^[0-9a-f]* <trace_raw_output' | wc -l
1401

That's 1401 tracepoints giving us:

   text    data     bss     dec     hex filename
137827709       140221067       53264384        331313160       13bf7008 vmlinux-allyes-handle
137920629       140221067       53264384        331406080       13c0db00 vmlinux-allyes-orig

92920 bytes in savings!!!

Link: http://lkml.kernel.org/r/20170315021431.13107-2-andi@firstfloor.org
Link: http://lkml.kernel.org/r/20170316113459.2366588b@gandalf.local.home

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Reported-by: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/trace_events.h |   11 +----------
 kernel/trace/trace.c         |   12 ++++++++++++
 2 files changed, 13 insertions(+), 10 deletions(-)

diff -puN include/linux/trace_events.h~tracing-move-trace_handle_return-out-of-line include/linux/trace_events.h
--- a/include/linux/trace_events.h~tracing-move-trace_handle_return-out-of-line
+++ a/include/linux/trace_events.h
@@ -138,16 +138,7 @@ enum print_line_t {
 	TRACE_TYPE_NO_CONSUME	= 3	/* Handled but ask to not consume */
 };
 
-/*
- * Several functions return TRACE_TYPE_PARTIAL_LINE if the trace_seq
- * overflowed, and TRACE_TYPE_HANDLED otherwise. This helper function
- * simplifies those functions and keeps them in sync.
- */
-static inline enum print_line_t trace_handle_return(struct trace_seq *s)
-{
-	return trace_seq_has_overflowed(s) ?
-		TRACE_TYPE_PARTIAL_LINE : TRACE_TYPE_HANDLED;
-}
+enum print_line_t trace_handle_return(struct trace_seq *s);
 
 void tracing_generic_entry_update(struct trace_entry *entry,
 				  unsigned long flags,
diff -puN kernel/trace/trace.c~tracing-move-trace_handle_return-out-of-line kernel/trace/trace.c
--- a/kernel/trace/trace.c~tracing-move-trace_handle_return-out-of-line
+++ a/kernel/trace/trace.c
@@ -1927,6 +1927,18 @@ void tracing_record_cmdline(struct task_
 		__this_cpu_write(trace_cmdline_save, false);
 }
 
+/*
+ * Several functions return TRACE_TYPE_PARTIAL_LINE if the trace_seq
+ * overflowed, and TRACE_TYPE_HANDLED otherwise. This helper function
+ * simplifies those functions and keeps them in sync.
+ */
+enum print_line_t trace_handle_return(struct trace_seq *s)
+{
+	return trace_seq_has_overflowed(s) ?
+		TRACE_TYPE_PARTIAL_LINE : TRACE_TYPE_HANDLED;
+}
+EXPORT_SYMBOL_GPL(trace_handle_return);
+
 void
 tracing_generic_entry_update(struct trace_entry *entry, unsigned long flags,
 			     int pc)
_

Patches currently in -mm which might be from rostedt@goodmis.org are


