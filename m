From: akpm@linux-foundation.org
Subject: [patch 082/162] printk/nmi: warn when some message has been lost
 in NMI context
Date: Fri, 20 May 2016 17:00:36 -0700
Message-ID: <573fa524.ThfKsQTRK/yoNkXW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52723 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478AbcEUAAi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 20:00:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, pmladek@suse.com, benh@kernel.crashing.org, daniel.thompson@linaro.org, davem@davemloft.net, jack@suse.cz, jkosina@suse.com, mingo@redhat.com, peterz@infradead.org, ralf@linux-mips.org, rmk+kernel@arm.linux.org.uk, rostedt@goodmis.org, schwidefsky@de.ibm.com, tglx@linutronix.de

From: Petr Mladek <pmladek@suse.com>
Subject: printk/nmi: warn when some message has been lost in NMI context

We could not resize the temporary buffer in NMI context.  Let's warn if a
message is lost.

This is rather theoretical.  printk() should not be used in NMI.  The only
sensible use is when we want to print backtrace from all CPUs.  The
current buffer should be enough for this purpose.

[akpm@linux-foundation.org: whitespace fixlet]
Signed-off-by: Petr Mladek <pmladek@suse.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Jiri Kosina <jkosina@suse.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: David Miller <davem@davemloft.net>
Cc: Daniel Thompson <daniel.thompson@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk/internal.h |   11 +++++++++++
 kernel/printk/nmi.c      |    5 ++++-
 kernel/printk/printk.c   |   10 ++++++++++
 3 files changed, 25 insertions(+), 1 deletion(-)

diff -puN kernel/printk/internal.h~printk-nmi-warn-when-some-message-has-been-lost-in-nmi-context kernel/printk/internal.h
--- a/kernel/printk/internal.h~printk-nmi-warn-when-some-message-has-been-lost-in-nmi-context
+++ a/kernel/printk/internal.h
@@ -34,6 +34,12 @@ static inline __printf(1, 0) int vprintk
 	return this_cpu_read(printk_func)(fmt, args);
 }
 
+extern atomic_t nmi_message_lost;
+static inline int get_nmi_message_lost(void)
+{
+	return atomic_xchg(&nmi_message_lost, 0);
+}
+
 #else /* CONFIG_PRINTK_NMI */
 
 static inline __printf(1, 0) int vprintk_func(const char *fmt, va_list args)
@@ -41,4 +47,9 @@ static inline __printf(1, 0) int vprintk
 	return vprintk_default(fmt, args);
 }
 
+static inline int get_nmi_message_lost(void)
+{
+	return 0;
+}
+
 #endif /* CONFIG_PRINTK_NMI */
diff -puN kernel/printk/nmi.c~printk-nmi-warn-when-some-message-has-been-lost-in-nmi-context kernel/printk/nmi.c
--- a/kernel/printk/nmi.c~printk-nmi-warn-when-some-message-has-been-lost-in-nmi-context
+++ a/kernel/printk/nmi.c
@@ -39,6 +39,7 @@
  */
 DEFINE_PER_CPU(printk_func_t, printk_func) = vprintk_default;
 static int printk_nmi_irq_ready;
+atomic_t nmi_message_lost;
 
 #define NMI_LOG_BUF_LEN (4096 - sizeof(atomic_t) - sizeof(struct irq_work))
 
@@ -64,8 +65,10 @@ static int vprintk_nmi(const char *fmt,
 again:
 	len = atomic_read(&s->len);
 
-	if (len >= sizeof(s->buffer))
+	if (len >= sizeof(s->buffer)) {
+		atomic_inc(&nmi_message_lost);
 		return 0;
+	}
 
 	/*
 	 * Make sure that all old data have been read before the buffer was
diff -puN kernel/printk/printk.c~printk-nmi-warn-when-some-message-has-been-lost-in-nmi-context kernel/printk/printk.c
--- a/kernel/printk/printk.c~printk-nmi-warn-when-some-message-has-been-lost-in-nmi-context
+++ a/kernel/printk/printk.c
@@ -1617,6 +1617,7 @@ asmlinkage int vprintk_emit(int facility
 	unsigned long flags;
 	int this_cpu;
 	int printed_len = 0;
+	int nmi_message_lost;
 	bool in_sched = false;
 	/* cpu currently holding logbuf_lock in this function */
 	static unsigned int logbuf_cpu = UINT_MAX;
@@ -1667,6 +1668,15 @@ asmlinkage int vprintk_emit(int facility
 					 strlen(recursion_msg));
 	}
 
+	nmi_message_lost = get_nmi_message_lost();
+	if (unlikely(nmi_message_lost)) {
+		text_len = scnprintf(textbuf, sizeof(textbuf),
+				     "BAD LUCK: lost %d message(s) from NMI context!",
+				     nmi_message_lost);
+		printed_len += log_store(0, 2, LOG_PREFIX|LOG_NEWLINE, 0,
+					 NULL, 0, textbuf, text_len);
+	}
+
 	/*
 	 * The printf needs to come first; we need the syslog
 	 * prefix which might be passed-in as a parameter.
_
