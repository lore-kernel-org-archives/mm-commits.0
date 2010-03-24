From: akpm@linux-foundation.org
Subject: + max3100-move-to-threaded-interrupt.patch added to -mm tree
Date: Wed, 24 Mar 2010 11:39:16 -0700
Message-ID: <201003241839.o2OIdHc4018654@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38887 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932073Ab0CXSjw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Mar 2010 14:39:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: chripell@fsfe.org, alan@lxorguk.ukuu.org.uk, feng.tang@intel.com, greg@kroah.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     max3100: move to threaded interrupt
has been added to the -mm tree.  Its filename is
     max3100-move-to-threaded-interrupt.patch

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
Subject: max3100: move to threaded interrupt
From: Christian Pellegrin <chripell@fsfe.org>

The driver is reworked to use threaded interrupts instead of workqueus. 
This is a major boost in performance because the former are scheduled as
SCHED_FIFO processes.  As a side effect suspend/resume code is greatly
simplified.

Signed-off-by: Christian Pellegrin <chripell@fsfe.org>
Cc: Greg KH <greg@kroah.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Feng Tang <feng.tang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/max3100.c |  102 +++++++++++--------------------------
 1 file changed, 32 insertions(+), 70 deletions(-)

diff -puN drivers/serial/max3100.c~max3100-move-to-threaded-interrupt drivers/serial/max3100.c
--- a/drivers/serial/max3100.c~max3100-move-to-threaded-interrupt
+++ a/drivers/serial/max3100.c
@@ -45,7 +45,9 @@
 #include <linux/serial_core.h>
 #include <linux/serial.h>
 #include <linux/spi/spi.h>
-#include <linux/freezer.h>
+#include <linux/kthread.h>
+#include <linux/interrupt.h>
+#include <linux/bitops.h>
 
 #include <linux/serial_max3100.h>
 
@@ -113,18 +115,15 @@ struct max3100_port {
 
 	int irq;		/* irq assigned to the max3100 */
 
+	/* the workqueue is needed because we cannot schedule
+	   a threaded interrupt during PM
+	 */
+	struct work_struct resume_work;
+
 	int minor;		/* minor number */
 	int crystal;		/* 1 if 3.6864Mhz crystal 0 for 1.8432 */
 	int loopback;		/* 1 if we are in loopback mode */
 
-	/* for handling irqs: need workqueue since we do spi_sync */
-	struct workqueue_struct *workqueue;
-	struct work_struct work;
-	/* set to 1 to make the workhandler exit as soon as possible */
-	int  force_end_work;
-	/* need to know we are suspending to avoid deadlock on workqueue */
-	int suspending;
-
 	/* hook for suspending MAX3100 via dedicated pin */
 	void (*max3100_hw_suspend) (int suspend);
 
@@ -171,13 +170,12 @@ static void max3100_calc_parity(struct m
 		*c |= max3100_do_parity(s, *c) << 8;
 }
 
-static void max3100_work(struct work_struct *w);
-
-static void max3100_dowork(struct max3100_port *s)
+static void max3100_resume_work(struct work_struct *w)
 {
-	if (!s->force_end_work && !work_pending(&s->work) &&
-	    !freezing(current) && !s->suspending)
-		queue_work(s->workqueue, &s->work);
+	struct max3100_port *s = container_of(w, struct max3100_port,
+					      resume_work);
+
+	raise_threaded_irq(s->irq);
 }
 
 static void max3100_timeout(unsigned long data)
@@ -185,7 +183,7 @@ static void max3100_timeout(unsigned lon
 	struct max3100_port *s = (struct max3100_port *)data;
 
 	if (s->port.state) {
-		max3100_dowork(s);
+		raise_threaded_irq(s->irq);
 		mod_timer(&s->timer, jiffies + s->poll_time);
 	}
 }
@@ -255,9 +253,9 @@ static int max3100_handlerx(struct max31
 	return ret;
 }
 
-static void max3100_work(struct work_struct *w)
+static irqreturn_t max3100_ist(int irq, void *dev_id)
 {
-	struct max3100_port *s = container_of(w, struct max3100_port, work);
+	struct max3100_port *s = dev_id;
 	int rxchars;
 	u16 tx, rx;
 	int conf, cconf, rts, crts;
@@ -314,23 +312,14 @@ static void max3100_work(struct work_str
 		if (uart_circ_chars_pending(xmit) < WAKEUP_CHARS)
 			uart_write_wakeup(&s->port);
 
-	} while (!s->force_end_work &&
-		 !freezing(current) &&
+	} while (!kthread_should_stop() &&
 		 ((rx & MAX3100_R) ||
 		  (!uart_circ_empty(xmit) &&
 		   !uart_tx_stopped(&s->port))));
 
 	if (rxchars > 0 && s->port.state->port.tty != NULL)
 		tty_flip_buffer_push(s->port.state->port.tty);
-}
-
-static irqreturn_t max3100_irq(int irqno, void *dev_id)
-{
-	struct max3100_port *s = dev_id;
-
-	dev_dbg(&s->spi->dev, "%s\n", __func__);
 
-	max3100_dowork(s);
 	return IRQ_HANDLED;
 }
 
@@ -353,7 +342,7 @@ static void max3100_start_tx(struct uart
 
 	dev_dbg(&s->spi->dev, "%s\n", __func__);
 
-	max3100_dowork(s);
+	raise_threaded_irq(s->irq);
 }
 
 static void max3100_stop_rx(struct uart_port *port)
@@ -369,7 +358,7 @@ static void max3100_stop_rx(struct uart_
 	s->conf &= ~MAX3100_RM;
 	s->conf_commit = 1;
 	spin_unlock(&s->conf_lock);
-	max3100_dowork(s);
+	raise_threaded_irq(s->irq);
 }
 
 static unsigned int max3100_tx_empty(struct uart_port *port)
@@ -381,7 +370,7 @@ static unsigned int max3100_tx_empty(str
 	dev_dbg(&s->spi->dev, "%s\n", __func__);
 
 	/* may not be truly up-to-date */
-	max3100_dowork(s);
+	raise_threaded_irq(s->irq);
 	return s->tx_empty;
 }
 
@@ -394,7 +383,7 @@ static unsigned int max3100_get_mctrl(st
 	dev_dbg(&s->spi->dev, "%s\n", __func__);
 
 	/* may not be truly up-to-date */
-	max3100_dowork(s);
+	raise_threaded_irq(s->irq);
 	/* always assert DCD and DSR since these lines are not wired */
 	return (s->cts ? TIOCM_CTS : 0) | TIOCM_DSR | TIOCM_CAR;
 }
@@ -414,7 +403,7 @@ static void max3100_set_mctrl(struct uar
 	if (s->rts != rts) {
 		s->rts = rts;
 		s->rts_commit = 1;
-		max3100_dowork(s);
+		raise_threaded_irq(s->irq);
 	}
 	spin_unlock(&s->conf_lock);
 }
@@ -528,7 +517,7 @@ max3100_set_termios(struct uart_port *po
 			MAX3100_STATUS_PE | MAX3100_STATUS_FE |
 			MAX3100_STATUS_OE;
 
-	/* we are sending char from a workqueue so enable */
+	/* we are sending char from a threded irq so enable */
 	s->port.state->port.tty->low_latency = 1;
 
 	if (s->poll_time > 0)
@@ -541,7 +530,7 @@ max3100_set_termios(struct uart_port *po
 	s->conf_commit = 1;
 	s->parity = parity;
 	spin_unlock(&s->conf_lock);
-	max3100_dowork(s);
+	raise_threaded_irq(s->irq);
 
 	if (UART_ENABLE_MS(&s->port, termios->c_cflag))
 		max3100_enable_ms(&s->port);
@@ -555,19 +544,11 @@ static void max3100_shutdown(struct uart
 
 	dev_dbg(&s->spi->dev, "%s\n", __func__);
 
-	if (s->suspending)
-		return;
-
-	s->force_end_work = 1;
-
 	if (s->poll_time > 0)
 		del_timer_sync(&s->timer);
 
-	if (s->workqueue) {
-		flush_workqueue(s->workqueue);
-		destroy_workqueue(s->workqueue);
-		s->workqueue = NULL;
-	}
+	flush_work(&s->resume_work);
+
 	if (s->irq)
 		free_irq(s->irq, s);
 
@@ -587,7 +568,6 @@ static int max3100_startup(struct uart_p
 	struct max3100_port *s = container_of(port,
 					      struct max3100_port,
 					      port);
-	char b[12];
 
 	dev_dbg(&s->spi->dev, "%s\n", __func__);
 
@@ -595,27 +575,15 @@ static int max3100_startup(struct uart_p
 	s->baud = s->crystal ? 230400 : 115200;
 	s->rx_enabled = 1;
 
-	if (s->suspending)
-		return 0;
-
-	s->force_end_work = 0;
 	s->parity = 0;
 	s->rts = 0;
 
-	sprintf(b, "max3100-%d", s->minor);
-	s->workqueue = create_freezeable_workqueue(b);
-	if (!s->workqueue) {
-		dev_warn(&s->spi->dev, "cannot create workqueue\n");
-		return -EBUSY;
-	}
-	INIT_WORK(&s->work, max3100_work);
+	INIT_WORK(&s->resume_work, max3100_resume_work);
 
-	if (request_irq(s->irq, max3100_irq,
+	if (request_threaded_irq(s->irq, NULL, max3100_ist,
 			IRQF_TRIGGER_FALLING, "max3100", s) < 0) {
-		dev_warn(&s->spi->dev, "cannot allocate irq %d\n", s->irq);
+		dev_err(&s->spi->dev, "cannot allocate irq %d\n", s->irq);
 		s->irq = 0;
-		destroy_workqueue(s->workqueue);
-		s->workqueue = NULL;
 		return -EBUSY;
 	}
 
@@ -628,7 +596,7 @@ static int max3100_startup(struct uart_p
 	if (s->max3100_hw_suspend)
 		s->max3100_hw_suspend(0);
 	s->conf_commit = 1;
-	max3100_dowork(s);
+	raise_threaded_irq(s->irq);
 	/* wait for clock to settle */
 	msleep(50);
 
@@ -857,9 +825,6 @@ static int max3100_suspend(struct spi_de
 
 	disable_irq(s->irq);
 
-	s->suspending = 1;
-	uart_suspend_port(&max3100_uart_driver, &s->port);
-
 	if (s->max3100_hw_suspend)
 		s->max3100_hw_suspend(1);
 	else {
@@ -880,14 +845,11 @@ static int max3100_resume(struct spi_dev
 
 	if (s->max3100_hw_suspend)
 		s->max3100_hw_suspend(0);
-	uart_resume_port(&max3100_uart_driver, &s->port);
-	s->suspending = 0;
 
 	enable_irq(s->irq);
