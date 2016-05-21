From: akpm@linux-foundation.org
Subject: [patch 083/162] printk/nmi: increase the size of NMI buffer and
 make it configurable
Date: Fri, 20 May 2016 17:00:39 -0700
Message-ID: <573fa527.eIVEpFLaxkgj1dVX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52738 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478AbcEUAAl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 20:00:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, pmladek@suse.com, benh@kernel.crashing.org, daniel.thompson@linaro.org, davem@davemloft.net, jack@suse.cz, jkosina@suse.com, mingo@redhat.com, peterz@infradead.org, ralf@linux-mips.org, rmk+kernel@arm.linux.org.uk, rostedt@goodmis.org, schwidefsky@de.ibm.com, tglx@linutronix.de

From: Petr Mladek <pmladek@suse.com>
Subject: printk/nmi: increase the size of NMI buffer and make it configurable

Testing has shown that the backtrace sometimes does not fit into the 4kB
temporary buffer that is used in NMI context.  The warnings are gone when
I double the temporary buffer size.

This patch doubles the buffer size and makes it configurable.

Note that this problem existed even in the x86-specific implementation
that was added by the commit a9edc8809328 ("x86/nmi: Perform a safe NMI
stack trace on all CPUs").  Nobody noticed it because it did not print any
warnings.

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

 init/Kconfig        |   22 ++++++++++++++++++++++
 kernel/printk/nmi.c |    3 ++-
 2 files changed, 24 insertions(+), 1 deletion(-)

diff -puN init/Kconfig~printk-nmi-increase-the-size-of-nmi-buffer-and-make-it-configurable init/Kconfig
--- a/init/Kconfig~printk-nmi-increase-the-size-of-nmi-buffer-and-make-it-configurable
+++ a/init/Kconfig
@@ -862,6 +862,28 @@ config LOG_CPU_MAX_BUF_SHIFT
 		     13 =>   8 KB for each CPU
 		     12 =>   4 KB for each CPU
 
+config NMI_LOG_BUF_SHIFT
+	int "Temporary per-CPU NMI log buffer size (12 => 4KB, 13 => 8KB)"
+	range 10 21
+	default 13
+	depends on PRINTK_NMI
+	help
+	  Select the size of a per-CPU buffer where NMI messages are temporary
+	  stored. They are copied to the main log buffer in a safe context
+	  to avoid a deadlock. The value defines the size as a power of 2.
+
+	  NMI messages are rare and limited. The largest one is when
+	  a backtrace is printed. It usually fits into 4KB. Select
+	  8KB if you want to be on the safe side.
+
+	  Examples:
+		     17 => 128 KB for each CPU
+		     16 =>  64 KB for each CPU
+		     15 =>  32 KB for each CPU
+		     14 =>  16 KB for each CPU
+		     13 =>   8 KB for each CPU
+		     12 =>   4 KB for each CPU
+
 #
 # Architectures with an unreliable sched_clock() should select this:
 #
diff -puN kernel/printk/nmi.c~printk-nmi-increase-the-size-of-nmi-buffer-and-make-it-configurable kernel/printk/nmi.c
--- a/kernel/printk/nmi.c~printk-nmi-increase-the-size-of-nmi-buffer-and-make-it-configurable
+++ a/kernel/printk/nmi.c
@@ -41,7 +41,8 @@ DEFINE_PER_CPU(printk_func_t, printk_fun
 static int printk_nmi_irq_ready;
 atomic_t nmi_message_lost;
 
-#define NMI_LOG_BUF_LEN (4096 - sizeof(atomic_t) - sizeof(struct irq_work))
+#define NMI_LOG_BUF_LEN ((1 << CONFIG_NMI_LOG_BUF_SHIFT) -		\
+			 sizeof(atomic_t) - sizeof(struct irq_work))
 
 struct nmi_seq_buf {
 	atomic_t		len;	/* length of written data */
_
