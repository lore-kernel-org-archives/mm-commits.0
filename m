From: akpm@linux-foundation.org
Subject: + dump_stack-serialize-the-output-from-dump_stack.patch added to -mm tree
Date: Thu, 09 May 2013 13:59:51 -0700
Message-ID: <20130509205952.7B3EC5A4282@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f73.google.com ([209.85.128.73]:64947 "EHLO
	mail-qe0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752759Ab3EIU7z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 May 2013 16:59:55 -0400
Received: by mail-qe0-f73.google.com with SMTP id a11so334910qen.2
        for <mm-commits@vger.kernel.org>; Thu, 09 May 2013 13:59:54 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: athorlton@sgi.com, davem@davemloft.net, holt@sgi.com, jesper.nilsson@axis.com, rja@sgi.com, rkuo@codeaurora.org, vgupta@synopsys.com


The patch titled
     Subject: dump_stack: serialize the output from dump_stack()
has been added to the -mm tree.  Its filename is
     dump_stack-serialize-the-output-from-dump_stack.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alex Thorlton <athorlton@sgi.com>
Subject: dump_stack: serialize the output from dump_stack()

tAdd adds functionality to serialize the output from dump_stack() to avoid
mangling of the output when dump_stack is called simultaneously from
multiple cpus.

Signed-off-by: Alex Thorlton <athorlton@sgi.com>
Reported-by: Russ Anderson <rja@sgi.com>
Reviewed-by: Robin Holt <holt@sgi.com>
Cc: Vineet Gupta <vgupta@synopsys.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Richard Kuo <rkuo@codeaurora.org>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/dump_stack.c |   49 ++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 48 insertions(+), 1 deletion(-)

diff -puN lib/dump_stack.c~dump_stack-serialize-the-output-from-dump_stack lib/dump_stack.c
--- a/lib/dump_stack.c~dump_stack-serialize-the-output-from-dump_stack
+++ a/lib/dump_stack.c
@@ -6,15 +6,62 @@
 #include <linux/kernel.h>
 #include <linux/export.h>
 #include <linux/sched.h>
+#include <asm/processor.h>
+#include <asm/atomic.h>
+
+#ifdef CONFIG_SMP
+#include <linux/smp.h>
+#endif
 
 /**
  * dump_stack - dump the current task information and its stack trace
  *
  * Architectures can override this implementation by implementing its own.
  */
+#ifdef CONFIG_SMP
+static atomic_t dump_lock = ATOMIC_INIT(-1);
+
 void dump_stack(void)
 {
+	int was_locked;
+	int old;
+	int cpu;
+
+        /*
+         * Permit this cpu to perform nested stack dumps while serialising
+         * against other CPUs
+         */
+	preempt_disable();
+
+retry:
+	cpu = smp_processor_id();
+	old = atomic_cmpxchg(&dump_lock, -1, cpu);
+	if (old == -1) {
+		was_locked = 0;
+	} else if (old == cpu) {
+		was_locked = 1;
+	} else {
+		cpu_relax();
+		goto retry;
+	}
+
+	__dump_stack();
+
+	if (!was_locked)
+		atomic_set(&dump_lock, -1);
+
+	preempt_enable();
+}
+#else
+void dump_stack(void)
+{
+	__dump_stack();
+}
+#endif
+EXPORT_SYMBOL(dump_stack);
+
+static void __dump_stack(void)
+{
 	dump_stack_print_info(KERN_DEFAULT);
 	show_stack(NULL, NULL);
 }
-EXPORT_SYMBOL(dump_stack);
_

Patches currently in -mm which might be from athorlton@sgi.com are

origin.patch
dump_stack-serialize-the-output-from-dump_stack.patch
dump_stack-serialize-the-output-from-dump_stack-fix.patch
panic-add-cpu-pid-to-warn_slowpath_common-in-warning-printks.patch

