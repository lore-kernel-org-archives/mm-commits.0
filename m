From: akpm@linux-foundation.org
Subject: [merged]
 stacktrace-introduce-snprint_stack_trace-for-buffer-output.patch removed
 from -mm tree
Date: Sat, 13 Dec 2014 20:07:52 -0800
Message-ID: <548d0d18.+15UUROTU20jBoyA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47649 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753072AbaLNEHp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 13 Dec 2014 23:07:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, dave@sr71.net, hannes@cmpxchg.org, jungsoo.son@lge.com, mgorman@suse.de, mina86@mina86.com, minchan@kernel.org, mingo@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: stacktrace: introduce snprint_stack_trace for buffer output
has been removed from the -mm tree.  Its filename was
     stacktrace-introduce-snprint_stack_trace-for-buffer-output.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: stacktrace: introduce snprint_stack_trace for buffer output

Current stacktrace only have the function for console output.  page_owner
that will be introduced in following patch needs to print the output of
stacktrace into the buffer for our own output format so so new function,
snprint_stack_trace(), is needed.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Dave Hansen <dave@sr71.net>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Jungsoo Son <jungsoo.son@lge.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/stacktrace.h |    5 +++++
 kernel/stacktrace.c        |   32 ++++++++++++++++++++++++++++++++
 2 files changed, 37 insertions(+)

diff -puN include/linux/stacktrace.h~stacktrace-introduce-snprint_stack_trace-for-buffer-output include/linux/stacktrace.h
--- a/include/linux/stacktrace.h~stacktrace-introduce-snprint_stack_trace-for-buffer-output
+++ a/include/linux/stacktrace.h
@@ -1,6 +1,8 @@
 #ifndef __LINUX_STACKTRACE_H
 #define __LINUX_STACKTRACE_H
 
+#include <linux/types.h>
+
 struct task_struct;
 struct pt_regs;
 
@@ -20,6 +22,8 @@ extern void save_stack_trace_tsk(struct
 				struct stack_trace *trace);
 
 extern void print_stack_trace(struct stack_trace *trace, int spaces);
+extern int snprint_stack_trace(char *buf, size_t size,
+			struct stack_trace *trace, int spaces);
 
 #ifdef CONFIG_USER_STACKTRACE_SUPPORT
 extern void save_stack_trace_user(struct stack_trace *trace);
@@ -32,6 +36,7 @@ extern void save_stack_trace_user(struct
 # define save_stack_trace_tsk(tsk, trace)		do { } while (0)
 # define save_stack_trace_user(trace)			do { } while (0)
 # define print_stack_trace(trace, spaces)		do { } while (0)
+# define snprint_stack_trace(buf, size, trace, spaces)	do { } while (0)
 #endif
 
 #endif
diff -puN kernel/stacktrace.c~stacktrace-introduce-snprint_stack_trace-for-buffer-output kernel/stacktrace.c
--- a/kernel/stacktrace.c~stacktrace-introduce-snprint_stack_trace-for-buffer-output
+++ a/kernel/stacktrace.c
@@ -25,6 +25,38 @@ void print_stack_trace(struct stack_trac
 }
 EXPORT_SYMBOL_GPL(print_stack_trace);
 
+int snprint_stack_trace(char *buf, size_t size,
+			struct stack_trace *trace, int spaces)
+{
+	int i;
+	unsigned long ip;
+	int generated;
+	int total = 0;
+
+	if (WARN_ON(!trace->entries))
+		return 0;
+
+	for (i = 0; i < trace->nr_entries; i++) {
+		ip = trace->entries[i];
+		generated = snprintf(buf, size, "%*c[<%p>] %pS\n",
+				1 + spaces, ' ', (void *) ip, (void *) ip);
+
+		total += generated;
+
+		/* Assume that generated isn't a negative number */
+		if (generated >= size) {
+			buf += size;
+			size = 0;
+		} else {
+			buf += generated;
+			size -= generated;
+		}
+	}
+
+	return total;
+}
+EXPORT_SYMBOL_GPL(snprint_stack_trace);
+
 /*
  * Architectures that do not implement save_stack_trace_tsk or
  * save_stack_trace_regs get this weak alias and a once-per-bootup warning
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

origin.patch
mm-cma-split-cma-reserved-in-dmesg-log.patch
fs-proc-include-cma-info-in-proc-meminfo.patch

