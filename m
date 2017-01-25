From: akpm@linux-foundation.org
Subject: + kasan-respect-proc-sys-kernel-traceoff_on_warning.patch added
 to -mm tree
Date: Wed, 25 Jan 2017 15:23:24 -0800
Message-ID: <5889336c.k8jJrOLqALjPhyU8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50718 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752169AbdAYXXk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 Jan 2017 18:23:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: peterz@infradead.org, aryabinin@virtuozzo.com, dvyukov@google.com, glider@google.com, rostedt@goodmis.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: respect /proc/sys/kernel/traceoff_on_warning
has been added to the -mm tree.  Its filename is
     kasan-respect-proc-sys-kernel-traceoff_on_warning.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kasan-respect-proc-sys-kernel-traceoff_on_warning.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kasan-respect-proc-sys-kernel-traceoff_on_warning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from peterz@infradead.org are

kasan-respect-proc-sys-kernel-traceoff_on_warning.patch

