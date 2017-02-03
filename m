From: akpm@linux-foundation.org
Subject: [patch 2/8] kasan: respect /proc/sys/kernel/traceoff_on_warning
Date: Fri, 03 Feb 2017 13:13:12 -0800
Message-ID: <5894f268.upAFcTsslY2UNmqp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50256 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752477AbdBCVNN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2017 16:13:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, peterz@infradead.org, aryabinin@virtuozzo.com, dvyukov@google.com, glider@google.com, rostedt@goodmis.org

From: Peter Zijlstra <peterz@infradead.org>
Subject: kasan: respect /proc/sys/kernel/traceoff_on_warning

After much waiting I finally reproduced a KASAN issue, only to find my
trace-buffer empty of useful information because it got spooled out :/

Make kasan_report honour the /proc/sys/kernel/traceoff_on_warning
interface.

Link: http://lkml.kernel.org/r/20170125164106.3514-1-aryabinin@virtuozzo.com
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Acked-by: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/report.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN mm/kasan/report.c~kasan-respect-proc-sys-kernel-traceoff_on_warning mm/kasan/report.c
--- a/mm/kasan/report.c~kasan-respect-proc-sys-kernel-traceoff_on_warning
+++ a/mm/kasan/report.c
@@ -13,6 +13,7 @@
  *
  */
 
+#include <linux/ftrace.h>
 #include <linux/kernel.h>
 #include <linux/mm.h>
 #include <linux/printk.h>
@@ -300,6 +301,8 @@ void kasan_report(unsigned long addr, si
 	if (likely(!kasan_report_enabled()))
 		return;
 
+	disable_trace_on_warning();
+
 	info.access_addr = (void *)addr;
 	info.access_size = size;
 	info.is_write = is_write;
_
