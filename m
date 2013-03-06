From: akpm@linux-foundation.org
Subject: + printk-tracing-rework-console-tracing.patch added to -mm tree
Date: Wed, 06 Mar 2013 14:53:50 -0800
Message-ID: <20130306225350.AF5C65A403C@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:59779 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756387Ab3CFWxv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Mar 2013 17:53:51 -0500
Received: by mail-ye0-f202.google.com with SMTP id q5so928705yen.3
        for <mm-commits@vger.kernel.org>; Wed, 06 Mar 2013 14:53:51 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jovi.zhangwei@huawei.com, fweisbec@gmail.com, kay@vrfy.org, rostedt@goodmis.org


The patch titled
     Subject: printk/tracing: rework console tracing
has been added to the -mm tree.  Its filename is
     printk-tracing-rework-console-tracing.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Subject: printk/tracing: rework console tracing

commit 7ff9554bb ("printk: convert byte-buffer to variable-length record
buffer") removed start and end parameters in call_console_drivers, but
those parameters still exists in include/trace/events/printk.h.

Without start and end parameters handling, printk tracing became more
simple as: trace_console(text, len);

Signed-off-by: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Kay Sievers <kay@vrfy.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/printk.h |   25 ++++++-------------------
 kernel/printk.c               |    2 +-
 2 files changed, 7 insertions(+), 20 deletions(-)

diff -puN include/trace/events/printk.h~printk-tracing-rework-console-tracing include/trace/events/printk.h
--- a/include/trace/events/printk.h~printk-tracing-rework-console-tracing
+++ a/include/trace/events/printk.h
@@ -6,31 +6,18 @@
 
 #include <linux/tracepoint.h>
 
-TRACE_EVENT_CONDITION(console,
-	TP_PROTO(const char *log_buf, unsigned start, unsigned end,
-		 unsigned log_buf_len),
+TRACE_EVENT(console,
+	TP_PROTO(const char *text, size_t len),
 
-	TP_ARGS(log_buf, start, end, log_buf_len),
-
-	TP_CONDITION(start != end),
+	TP_ARGS(text, len),
 
 	TP_STRUCT__entry(
-		__dynamic_array(char, msg, end - start + 1)
+		__dynamic_array(char, msg, len + 1)
 	),
 
 	TP_fast_assign(
-		if ((start & (log_buf_len - 1)) > (end & (log_buf_len - 1))) {
-			memcpy(__get_dynamic_array(msg),
-			       log_buf + (start & (log_buf_len - 1)),
-			       log_buf_len - (start & (log_buf_len - 1)));
-			memcpy((char *)__get_dynamic_array(msg) +
-			       log_buf_len - (start & (log_buf_len - 1)),
-			       log_buf, end & (log_buf_len - 1));
-		} else
-			memcpy(__get_dynamic_array(msg),
-			       log_buf + (start & (log_buf_len - 1)),
-			       end - start);
-		((char *)__get_dynamic_array(msg))[end - start] = 0;
+		memcpy(__get_dynamic_array(msg), text, len);
+		((char *)__get_dynamic_array(msg))[len] = 0;
 	),
 
 	TP_printk("%s", __get_str(msg))
diff -puN kernel/printk.c~printk-tracing-rework-console-tracing kernel/printk.c
--- a/kernel/printk.c~printk-tracing-rework-console-tracing
+++ a/kernel/printk.c
@@ -1285,7 +1285,7 @@ static void call_console_drivers(int lev
 {
 	struct console *con;
 
-	trace_console(text, 0, len, len);
+	trace_console(text, len);
 
 	if (level >= console_loglevel && !ignore_loglevel)
 		return;
_

Patches currently in -mm which might be from jovi.zhangwei@huawei.com are

printk-tracing-rework-console-tracing.patch

