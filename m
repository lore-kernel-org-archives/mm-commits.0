From: akpm@linux-foundation.org
Subject: [merged] printk-tracing-rework-console-tracing.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:50:51 -0700
Message-ID: <20130430185051.7AB615A4082@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:60111 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932669Ab3D3Suw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:50:52 -0400
Received: by mail-vc0-f201.google.com with SMTP id gf12so86374vcb.2
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:50:52 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jovi.zhangwei@huawei.com, fweisbec@gmail.com, kay@vrfy.org, rostedt@goodmis.org, mm-commits@vger.kernel.org


The patch titled
     Subject: printk/tracing: rework console tracing
has been removed from the -mm tree.  Its filename was
     printk-tracing-rework-console-tracing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -1265,7 +1265,7 @@ static void call_console_drivers(int lev
 {
 	struct console *con;
 
-	trace_console(text, 0, len, len);
+	trace_console(text, len);
 
 	if (level >= console_loglevel && !ignore_loglevel)
 		return;
_

Patches currently in -mm which might be from jovi.zhangwei@huawei.com are

origin.patch
relay-remove-unused-function-argument-actor.patch
relay-move-fix_size-macro-into-relayc.patch
relay-use-macro-page_align-instead-of-fix_size.patch
relay-fix-timer-madness.patch
kernel-relayc-move-remove_buf_file-inside-relay_close_buf.patch
init-kconfig-re-order-config_expert-options-to-fix-menuconfig-display.patch
kgdb-sysrq-fix-inconstistent-help-message-of-sysrq-key.patch
power-sysrq-fix-inconstistent-help-message-of-sysrq-key.patch
arm-etm-sysrq-fix-inconstistent-help-message-of-sysrq-key.patch
powerpc-xmon-sysrq-fix-inconstistent-help-message-of-sysrq-key.patch
spare-sysrq-fix-inconstistent-help-message-of-sysrq-key.patch
ethernet-emac-sysrq-fix-inconstistent-help-message-of-sysrq-key.patch
documentation-sysrq-fix-inconstistent-help-message-of-sysrq-key.patch

