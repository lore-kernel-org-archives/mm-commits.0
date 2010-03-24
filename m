From: akpm@linux-foundation.org
Subject: + max3100-to_max3100_port-small-style-fixes.patch added to -mm tree
Date: Wed, 24 Mar 2010 11:39:21 -0700
Message-ID: <201003241839.o2OIdLqR018675@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44878 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755960Ab0CXSkD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Mar 2010 14:40:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: chripell@fsfe.org, alan@lxorguk.ukuu.org.uk, feng.tang@intel.com, greg@kroah.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     max3100: to_max3100_port(), small style fixes
has been added to the -mm tree.  Its filename is
     max3100-to_max3100_port-small-style-fixes.patch

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
Subject: max3100: to_max3100_port(), small style fixes
From: Christian Pellegrin <chripell@fsfe.org>

static inline to_max3100_port() added clarity.  Whitespace fixes.

Signed-off-by: Christian Pellegrin <chripell@fsfe.org>
Cc: Greg KH <greg@kroah.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Feng Tang <feng.tang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/max3100.c |   77 ++++++++++++-------------------------
 1 file changed, 25 insertions(+), 52 deletions(-)

diff -puN drivers/serial/max3100.c~max3100-to_max3100_port-small-style-fixes drivers/serial/max3100.c
--- a/drivers/serial/max3100.c~max3100-to_max3100_port-small-style-fixes
+++ a/drivers/serial/max3100.c
@@ -131,7 +131,7 @@ struct max3100_port {
 	/* poll time (in ms) for ctrl lines */
 	int poll_time;
 	/* and its timer */
-	struct timer_list	timer;
+	struct timer_list timer;
 
 	int console_flags;
 	/* is this port a console? */
@@ -153,6 +153,11 @@ struct max3100_port {
 static struct max3100_port *max3100s[MAX_MAX3100]; /* the chips */
 static DEFINE_MUTEX(max3100s_lock);		   /* race on probe */
 
+static inline struct max3100_port *to_max3100_port(struct uart_port *port)
+{
+  return container_of(port, struct max3100_port, port);
+}
+
 static int max3100_do_parity(struct max3100_port *s, u16 c)
 {
 	int parity;
@@ -344,9 +349,7 @@ static irqreturn_t max3100_ist(int irq, 
 
 static void max3100_enable_ms(struct uart_port *port)
 {
-	struct max3100_port *s = container_of(port,
-					      struct max3100_port,
-					      port);
+	struct max3100_port *s = to_max3100_port(port);
 
 	if (s->poll_time > 0)
 		mod_timer(&s->timer, jiffies);
@@ -355,9 +358,7 @@ static void max3100_enable_ms(struct uar
 
 static void max3100_start_tx(struct uart_port *port)
 {
-	struct max3100_port *s = container_of(port,
-					      struct max3100_port,
-					      port);
+	struct max3100_port *s = to_max3100_port(port);
 
 	dev_dbg(&s->spi->dev, "%s\n", __func__);
 
@@ -366,9 +367,7 @@ static void max3100_start_tx(struct uart
 
 static void max3100_stop_rx(struct uart_port *port)
 {
-	struct max3100_port *s = container_of(port,
-					      struct max3100_port,
-					      port);
+	struct max3100_port *s = to_max3100_port(port);
 
 	dev_dbg(&s->spi->dev, "%s\n", __func__);
 
@@ -382,9 +381,7 @@ static void max3100_stop_rx(struct uart_
 
 static unsigned int max3100_tx_empty(struct uart_port *port)
 {
-	struct max3100_port *s = container_of(port,
-					      struct max3100_port,
-					      port);
+	struct max3100_port *s = to_max3100_port(port);
 
 	dev_dbg(&s->spi->dev, "%s\n", __func__);
 
@@ -395,9 +392,7 @@ static unsigned int max3100_tx_empty(str
 
 static unsigned int max3100_get_mctrl(struct uart_port *port)
 {
-	struct max3100_port *s = container_of(port,
-					      struct max3100_port,
-					      port);
+	struct max3100_port *s = to_max3100_port(port);
 
 	dev_dbg(&s->spi->dev, "%s\n", __func__);
 
@@ -409,9 +404,7 @@ static unsigned int max3100_get_mctrl(st
 
 static void max3100_set_mctrl(struct uart_port *port, unsigned int mctrl)
 {
-	struct max3100_port *s = container_of(port,
-					      struct max3100_port,
-					      port);
+	struct max3100_port *s = to_max3100_port(port);
 	int rts;
 
 	dev_dbg(&s->spi->dev, "%s\n", __func__);
@@ -431,9 +424,7 @@ static void
 max3100_set_termios(struct uart_port *port, struct ktermios *termios,
 		    struct ktermios *old)
 {
-	struct max3100_port *s = container_of(port,
-					      struct max3100_port,
-					      port);
+	struct max3100_port *s = to_max3100_port(port);
 	int baud = 0;
 	unsigned cflag;
 	u32 param_new, param_mask, parity = 0;
@@ -557,9 +548,7 @@ max3100_set_termios(struct uart_port *po
 
 static void max3100_shutdown(struct uart_port *port)
 {
-	struct max3100_port *s = container_of(port,
-					      struct max3100_port,
-					      port);
+	struct max3100_port *s = to_max3100_port(port);
 
 	dev_dbg(&s->spi->dev, "%s\n", __func__);
 
@@ -586,9 +575,7 @@ static void max3100_shutdown(struct uart
 
 static int max3100_startup(struct uart_port *port)
 {
-	struct max3100_port *s = container_of(port,
-					      struct max3100_port,
-					      port);
+	struct max3100_port *s = to_max3100_port(port);
 
 	dev_dbg(&s->spi->dev, "%s\n", __func__);
 
@@ -600,7 +587,7 @@ static int max3100_startup(struct uart_p
 	s->rts = 0;
 
 	if (request_threaded_irq(s->irq, NULL, max3100_ist,
-			IRQF_TRIGGER_FALLING, "max3100", s) < 0) {
+				 IRQF_TRIGGER_FALLING, "max3100", s) < 0) {
 		dev_err(&s->spi->dev, "cannot allocate irq %d\n", s->irq);
 		s->irq = 0;
 		return -EBUSY;
@@ -626,9 +613,7 @@ static int max3100_startup(struct uart_p
 
 static const char *max3100_type(struct uart_port *port)
 {
-	struct max3100_port *s = container_of(port,
-					      struct max3100_port,
-					      port);
+	struct max3100_port *s = to_max3100_port(port);
 
 	dev_dbg(&s->spi->dev, "%s\n", __func__);
 
@@ -637,18 +622,14 @@ static const char *max3100_type(struct u
 
 static void max3100_release_port(struct uart_port *port)
 {
-	struct max3100_port *s = container_of(port,
-					      struct max3100_port,
-					      port);
+	struct max3100_port *s = to_max3100_port(port);
 
 	dev_dbg(&s->spi->dev, "%s\n", __func__);
 }
 
 static void max3100_config_port(struct uart_port *port, int flags)
 {
-	struct max3100_port *s = container_of(port,
-					      struct max3100_port,
-					      port);
+	struct max3100_port *s = to_max3100_port(port);
 
 	dev_dbg(&s->spi->dev, "%s\n", __func__);
 
@@ -659,9 +640,7 @@ static void max3100_config_port(struct u
 static int max3100_verify_port(struct uart_port *port,
 			       struct serial_struct *ser)
 {
-	struct max3100_port *s = container_of(port,
-					      struct max3100_port,
-					      port);
+	struct max3100_port *s = to_max3100_port(port);
 	int ret = -EINVAL;
 
 	dev_dbg(&s->spi->dev, "%s\n", __func__);
@@ -673,18 +652,14 @@ static int max3100_verify_port(struct ua
 
 static void max3100_stop_tx(struct uart_port *port)
 {
-	struct max3100_port *s = container_of(port,
-					      struct max3100_port,
-					      port);
+	struct max3100_port *s = to_max3100_port(port);
 
 	dev_dbg(&s->spi->dev, "%s\n", __func__);
 }
 
 static int max3100_request_port(struct uart_port *port)
 {
-	struct max3100_port *s = container_of(port,
-					      struct max3100_port,
-					      port);
+	struct max3100_port *s = to_max3100_port(port);
 
 	dev_dbg(&s->spi->dev, "%s\n", __func__);
 	return 0;
@@ -692,9 +667,7 @@ static int max3100_request_port(struct u
 
 static void max3100_break_ctl(struct uart_port *port, int break_state)
 {
-	struct max3100_port *s = container_of(port,
-					      struct max3100_port,
-					      port);
+	struct max3100_port *s = to_max3100_port(port);
 
 	dev_dbg(&s->spi->dev, "%s\n", __func__);
 }
@@ -1010,9 +983,9 @@ static int max3100_suspend(struct spi_de
 	s->console_flags |= MAX3100_SUSPENDING;
 	disable_irq(s->irq);
 
-	if (s->max3100_hw_suspend)
+	if (s->max3100_hw_suspend) {
 		s->max3100_hw_suspend(1);
-	else {
+	} else {
 		/* no HW suspend, so do SW one */
 		u16 tx, rx;
 
_

Patches currently in -mm which might be from chripell@fsfe.org are

kernel-irq-managec-add-raise_threaded_irq.patch
kernel-irq-managec-add-raise_threaded_irq-fix.patch
max3100-move-to-threaded-interrupt.patch
max3100-add-console-support-for-max3100.patch
max3100-to_max3100_port-small-style-fixes.patch
max3100-to_max3100_port-small-style-fixes-fix.patch

