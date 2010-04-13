From: akpm@linux-foundation.org
Subject: + max3100-add-console-support-for-max3100-fixes-for-the-max31x0-console.patch added to -mm tree
Date: Mon, 12 Apr 2010 22:51:40 -0400
Message-ID: <201004130553.o3D5rJGa016103@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44830 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750772Ab0DMFyC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Apr 2010 01:54:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: chripell@fsfe.org, alan@lxorguk.ukuu.org.uk, feng.tang@intel.com, greg@kroah.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     max3100: fixes for the MAX31x0 console
has been added to the -mm tree.  Its filename is
     max3100-add-console-support-for-max3100-fixes-for-the-max31x0-console.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: max3100: fixes for the MAX31x0 console
From: Christian Pellegrin <chripell@fsfe.org>

Fix problems reported about the MAX31x0 console.  RTS is asserted only if
flow control is explicitly enabled on kernel command line.  Chars inputed
during console output are not lost.

Signed-off-by: Christian Pellegrin <chripell@fsfe.org>
Cc: Greg KH <greg@kroah.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Feng Tang <feng.tang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/max3100.c |   48 +++++++++++++++++++++++++++++++++----
 1 file changed, 43 insertions(+), 5 deletions(-)

diff -puN drivers/serial/max3100.c~max3100-add-console-support-for-max3100-fixes-for-the-max31x0-console drivers/serial/max3100.c
--- a/drivers/serial/max3100.c~max3100-add-console-support-for-max3100-fixes-for-the-max31x0-console
+++ a/drivers/serial/max3100.c
@@ -148,6 +148,8 @@ struct max3100_port {
 	struct work_struct console_work;
 	/* char tx timeout */
 	int console_tout;
+	/* lock on receiving chars */
+	struct mutex rx_lock;
 #endif
 };
 
@@ -193,6 +195,19 @@ static void max3100_calc_parity(struct m
 		*c |= max3100_do_parity(s, *c) << 8;
 }
 
+static void max3100_flip(struct max3100_port *s)
+{
+	if (s->port.state->port.tty != NULL) {
+#ifdef CONFIG_SERIAL_MAX3100_CONSOLE
+		mutex_lock(&s->rx_lock);
+#endif
+		tty_flip_buffer_push(s->port.state->port.tty);
+#ifdef CONFIG_SERIAL_MAX3100_CONSOLE
+		mutex_unlock(&s->rx_lock);
+#endif
+	}
+}
+
 static void max3100_resume_work(struct work_struct *w)
 {
 	struct max3100_port *s = container_of(w, struct max3100_port,
@@ -243,6 +258,10 @@ static int max3100_handlerx(struct max31
 	unsigned int ch, flg, status = 0;
 	int ret = 0, cts;
 
+#ifdef CONFIG_SERIAL_MAX3100_CONSOLE
+	mutex_lock(&s->rx_lock);
+#endif
+
 	if (rx & MAX3100_R && s->rx_enabled) {
 		dev_dbg(&s->spi->dev, "%s\n", __func__);
 		ch = rx & (s->parity & MAX3100_7BIT ? 0x7f : 0xff);
@@ -275,6 +294,10 @@ static int max3100_handlerx(struct max31
 		uart_handle_cts_change(&s->port, cts ? TIOCM_CTS : 0);
 	}
 
+#ifdef CONFIG_SERIAL_MAX3100_CONSOLE
+	mutex_unlock(&s->rx_lock);
+#endif
+
 	return ret;
 }
 
@@ -330,8 +353,8 @@ static irqreturn_t max3100_ist(int irq, 
 			}
 		}
 
-		if (rxchars > 16 && s->port.state->port.tty != NULL) {
-			tty_flip_buffer_push(s->port.state->port.tty);
+		if (rxchars > 16) {
+			max3100_flip(s);
 			rxchars = 0;
 		}
 		if (uart_circ_chars_pending(xmit) < WAKEUP_CHARS)
@@ -342,8 +365,8 @@ static irqreturn_t max3100_ist(int irq, 
 		  (!uart_circ_empty(xmit) &&
 		   !uart_tx_stopped(&s->port))));
 
-	if (rxchars > 0 && s->port.state->port.tty != NULL)
-		tty_flip_buffer_push(s->port.state->port.tty);
+	if (rxchars > 0)
+		max3100_flip(s);
 
 	return IRQ_HANDLED;
 }
@@ -700,6 +723,7 @@ static void max3100_console_work(struct 
 					      console_work);
 	unsigned long start;
 	u16 tx, rx;
+	int rxchars = 0;
 
 	while (s->console_head != s->console_tail &&
 	       (s->console_flags & MAX3100_SUSPENDING) == 0) {
@@ -711,10 +735,19 @@ static void max3100_console_work(struct 
 			 !time_after(jiffies, start + s->console_tout));
 		tx = s->console_buf[s->console_tail];
 		max3100_calc_parity(s, &tx);
-		tx |= MAX3100_WD | MAX3100_RTS;
+		tx |= MAX3100_WD | (s->rts ? MAX3100_RTS : 0);
 		max3100_sr(s, tx, &rx);
+		if (s->port.state->port.tty != NULL) {
+			rxchars += max3100_handlerx(s, rx);
+			if (rxchars > 16) {
+				max3100_flip(s);
+				rxchars = 0;
+			}
+		}
 		s->console_tail = (s->console_tail + 1) % CONSOLE_BUF_SIZE;
 	}
+	if (rxchars)
+		max3100_flip(s);
 }
 
 static void max3100_console_putchar(struct uart_port *port, int ch)
@@ -810,6 +843,10 @@ static int max3100_console_setup(struct 
 	if (parity == 'o')
 		s->parity |= MAX3100_PARITY_ODD;
 	s->console_tout = 1 + (20 * HZ) / baud; /* jiffies to send 20 bits */
+	if (flow != 'n')
+		s->rts = 1;
+	else
+		s->rts = 0;
 
 	tx |= MAX3100_WC;
 	max3100_sr(s, tx, &rx);
@@ -913,6 +950,7 @@ static int __devinit max3100_probe(struc
 			 i, retval);
 
 #ifdef CONFIG_SERIAL_MAX3100_CONSOLE
+	mutex_init(&max3100s[i]->rx_lock);
 	if (pdata->console && !max3100_console_registered) {
 		register_console(&max3100_console);
 		max3100_console_registered = 1;
_

Patches currently in -mm which might be from chripell@fsfe.org are

linux-next.patch
kernel-irq-managec-add-raise_threaded_irq.patch
kernel-irq-managec-add-raise_threaded_irq-fix.patch
max3100-move-to-threaded-interrupt.patch
max3100-add-console-support-for-max3100.patch
max3100-to_max3100_port-small-style-fixes.patch
max3100-to_max3100_port-small-style-fixes-fix.patch
max3100-add-console-support-for-max3100-fixes-for-the-max31x0-console.patch

