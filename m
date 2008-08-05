From: akpm@linux-foundation.org
Subject: + ftrace-printk-formatting-infrastructure-fix.patch added to -mm tree
Date: Mon, 04 Aug 2008 19:42:10 -0700
Message-ID: <200808050242.m752gAf9012851@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48711 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754099AbYHECnd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Aug 2008 22:43:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rostedt@goodmis.org, mingo@elte.hu, randy.dunlap@oracle.com, srostedt@redhat.com


The patch titled
     ftrace: ftrace_printk doc moved
has been added to the -mm tree.  Its filename is
     ftrace-printk-formatting-infrastructure-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ftrace: ftrace_printk doc moved
From: Steven Rostedt <rostedt@goodmis.org>

Based on Randy Dunlap's suggestion, the ftrace_printk kernel-doc belongs
with the ftrace_printk macro that should be used. Not with the
__ftrace_printk internal function.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ftrace.h |   18 +++++++++++++++++-
 kernel/trace/trace.c   |   16 ----------------
 2 files changed, 17 insertions(+), 17 deletions(-)

diff -puN include/linux/ftrace.h~ftrace-printk-formatting-infrastructure-fix include/linux/ftrace.h
--- a/include/linux/ftrace.h~ftrace-printk-formatting-infrastructure-fix
+++ a/include/linux/ftrace.h
@@ -136,7 +136,23 @@ static inline void tracer_disable(void)
 #ifdef CONFIG_TRACING
 extern void
 ftrace_special(unsigned long arg1, unsigned long arg2, unsigned long arg3);
-# define ftrace_printk(x...) __ftrace_printk(_THIS_IP_, x)
+/**
+ * ftrace_printk - printf formatting in the ftrace buffer
+ * @fmt: the printf format for printing
+ *
+ * Note: __ftrace_printk is an internal function for ftrace_printk and
+ *       the @ip is passed in via the ftrace_printk macro.
+ *
+ * This function allows a kernel developer to debug fast path sections
+ * that printk is not appropriate for. By scattering in various
+ * printk like tracing in the code, a developer can quickly see
+ * where problems are occurring.
+ *
+ * This is intended as a debugging tool for the developer only.
+ * Please refrain from leaving ftrace_printks scattered around in
+ * your code.
+ */
+# define ftrace_printk(fmt...) __ftrace_printk(_THIS_IP_, fmt)
 extern int
 __ftrace_printk(unsigned long ip, const char *fmt, ...)
 	__attribute__ ((format (printf, 2, 3)));
diff -puN kernel/trace/trace.c~ftrace-printk-formatting-infrastructure-fix kernel/trace/trace.c
--- a/kernel/trace/trace.c~ftrace-printk-formatting-infrastructure-fix
+++ a/kernel/trace/trace.c
@@ -3075,22 +3075,6 @@ static __init void tracer_init_debugfs(v
 	(sizeof(struct trace_field) - offsetof(struct trace_field, print.buf))
 #define TRACE_CONT_BUF_SIZE sizeof(struct trace_field)
 
-/**
- * ftrace_printk - printf formatting in the ftrace buffer
- * @fmt - the printf format for printing.
- *
- * Note: __ftrace_printk is an internal function for ftrace_printk and
- *       the @ip is passed in via the ftrace_printk macro.
- *
- * This function allows a kernel developer to debug fast path sections
- * that printk is not appropriate for. By scattering in various
- * printk like tracing in the code, a developer can quickly see
- * where problems are occurring.
- *
- * This is intended as a debugging tool for the developer only.
- * Please reframe from leaving ftrace_printks scattered around in
- * your code.
- */
 int __ftrace_printk(unsigned long ip, const char *fmt, ...)
 {
 	struct trace_array *tr = &global_trace;
_

Patches currently in -mm which might be from rostedt@goodmis.org are

origin.patch
ftrace-new-continue-entry-separate-out-from-trace_entry.patch
ftrace-printk-formatting-infrastructure.patch
ftrace-printk-formatting-infrastructure-fix.patch
ftrace-disable-function-tracing-bringing-up-new-cpu.patch

