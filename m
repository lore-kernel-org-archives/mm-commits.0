From: akpm@linux-foundation.org
Subject: + ftrace-make-output-nicely-spaced-for-up-to-999-cpus.patch added to -mm tree
Date: Wed, 30 Jul 2008 21:01:52 -0700
Message-ID: <200807310401.m6V41qTB002885@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57347 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752052AbYGaECS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 31 Jul 2008 00:02:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: michael@ellerman.id.au, srostedt@redhat.com


The patch titled
     ftrace: make output nicely spaced for up to 999 cpus
has been added to the -mm tree.  Its filename is
     ftrace-make-output-nicely-spaced-for-up-to-999-cpus.patch

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
Subject: ftrace: make output nicely spaced for up to 999 cpus
From: Michael Ellerman <michael@ellerman.id.au>

Currently some of the ftrace output goes skewiff if you have more
than 9 cpus, and some if you have more than 99.

Twiddle with the headers and format strings to make up to 999 cpus
display without causing spacing problems.

Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
Acked-by: Steven Rostedt <srostedt@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/trace/trace.c |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff -puN kernel/trace/trace.c~ftrace-make-output-nicely-spaced-for-up-to-999-cpus kernel/trace/trace.c
--- a/kernel/trace/trace.c~ftrace-make-output-nicely-spaced-for-up-to-999-cpus
+++ a/kernel/trace/trace.c
@@ -1330,21 +1330,21 @@ seq_print_ip_sym(struct trace_seq *s, un
 
 static void print_lat_help_header(struct seq_file *m)
 {
-	seq_puts(m, "#                _------=> CPU#            \n");
-	seq_puts(m, "#               / _-----=> irqs-off        \n");
-	seq_puts(m, "#              | / _----=> need-resched    \n");
-	seq_puts(m, "#              || / _---=> hardirq/softirq \n");
-	seq_puts(m, "#              ||| / _--=> preempt-depth   \n");
-	seq_puts(m, "#              |||| /                      \n");
-	seq_puts(m, "#              |||||     delay             \n");
-	seq_puts(m, "#  cmd     pid ||||| time  |   caller      \n");
-	seq_puts(m, "#     \\   /    |||||   \\   |   /           \n");
+	seq_puts(m, "#                  _------=> CPU#            \n");
+	seq_puts(m, "#                 / _-----=> irqs-off        \n");
+	seq_puts(m, "#                | / _----=> need-resched    \n");
+	seq_puts(m, "#                || / _---=> hardirq/softirq \n");
+	seq_puts(m, "#                ||| / _--=> preempt-depth   \n");
+	seq_puts(m, "#                |||| /                      \n");
+	seq_puts(m, "#                |||||     delay             \n");
+	seq_puts(m, "#  cmd     pid   ||||| time  |   caller      \n");
+	seq_puts(m, "#     \\   /      |||||   \\   |   /           \n");
 }
 
 static void print_func_help_header(struct seq_file *m)
 {
-	seq_puts(m, "#           TASK-PID   CPU#    TIMESTAMP  FUNCTION\n");
-	seq_puts(m, "#              | |      |          |         |\n");
+	seq_puts(m, "#           TASK-PID    CPU#    TIMESTAMP  FUNCTION\n");
+	seq_puts(m, "#              | |       |          |         |\n");
 }
 
 
@@ -1428,7 +1428,7 @@ lat_print_generic(struct trace_seq *s, s
 	comm = trace_find_cmdline(entry->pid);
 
 	trace_seq_printf(s, "%8.8s-%-5d ", comm, entry->pid);
-	trace_seq_printf(s, "%d", cpu);
+	trace_seq_printf(s, "%3d", cpu);
 	trace_seq_printf(s, "%c%c",
 			(entry->flags & TRACE_FLAG_IRQS_OFF) ? 'd' : '.',
 			((entry->flags & TRACE_FLAG_NEED_RESCHED) ? 'N' : '.'));
@@ -1493,7 +1493,7 @@ print_lat_fmt(struct trace_iterator *ite
 
 	if (verbose) {
 		comm = trace_find_cmdline(entry->pid);
-		trace_seq_printf(s, "%16s %5d %d %d %08x %08x [%08lx]"
+		trace_seq_printf(s, "%16s %5d %3d %d %08x %08x [%08lx]"
 				 " %ld.%03ldms (+%ld.%03ldms): ",
 				 comm,
 				 entry->pid, cpu, entry->flags,
@@ -1576,7 +1576,7 @@ static int print_trace_fmt(struct trace_
 	ret = trace_seq_printf(s, "%16s-%-5d ", comm, entry->pid);
 	if (!ret)
 		return 0;
-	ret = trace_seq_printf(s, "[%02d] ", iter->cpu);
+	ret = trace_seq_printf(s, "[%03d] ", iter->cpu);
 	if (!ret)
 		return 0;
 	ret = trace_seq_printf(s, "%5lu.%06lu: ", secs, usec_rem);
_

Patches currently in -mm which might be from michael@ellerman.id.au are

ftrace-make-output-nicely-spaced-for-up-to-999-cpus.patch

