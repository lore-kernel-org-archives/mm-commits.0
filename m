From: akpm@linux-foundation.org
Subject: [to-be-updated] max3100-to_max3100_port-small-style-fixes.patch removed from -mm tree
Date: Tue, 27 Apr 2010 14:39:12 -0700
Message-ID: <201004272139.o3RLdCbr021653@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33052 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752604Ab0D0Vpk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Apr 2010 17:45:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chripell@fsfe.org, alan@lxorguk.ukuu.org.uk, feng.tang@intel.com, greg@kroah.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     max3100: to_max3100_port(), small style fixes
has been removed from the -mm tree.  Its filename was
     max3100-to_max3100_port-small-style-fixes.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: max3100: to_max3100_port(), small style fixes
From: Christian Pellegrin <chripell@fsfe.org>

static inline to_max3100_port() added clarity.  Whitespace fixes.

[akpm@linux-foundation.org: unbust whitespace]
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
@@ -132,7 +132,7 @@ struct max3100_port {
 	/* poll time (in ms) for ctrl lines */
 	int poll_time;
 	/* and its timer */
-	struct timer_list	timer;
+	struct timer_list timer;
 
 	int console_flags;
 	/* is this port a console? */
@@ -154,6 +154,11 @@ struct max3100_port {
 static struct max3100_port *max3100s[MAX_MAX3100]; /* the chips */
 static DEFINE_MUTEX(max3100s_lock);		   /* race on probe */
 
+static inline struct max3100_port *to_max3100_port(struct uart_port *port)
+{
+	return container_of(port, struct max3100_port, port);
+}
+
 static int max3100_do_parity(struct max3100_port *s, u16 c)
 {
 	int parity;
@@ -345,9 +350,7 @@ static irqreturn_t max3100_ist(int irq, 
 
 static void max3100_enable_ms(struct uart_port *port)
 {
-	struct max3100_port *s = container_of(port,
-					      struct max3100_port,
-					      port);
+	struct max3100_port *s = to_max3100_port(port);
 
 	if (s->poll_time > 0)
 		mod_timer(&s->timer, jiffies);
@@ -356,9 +359,7 @@ static void max3100_enable_ms(struct uar
 
 static void max3100_start_tx(struct uart_port *port)
 {
-	struct max3100_port *s = container_of(port,
-					      struct max3100_port,
-					      port);
+	struct max3100_port *s = to_max3100_port(port);
 
 	dev_dbg(&s->spi->dev, "%s\n", __func__);
 
@@ -367,9 +368,7 @@ static void max3100_start_tx(struct uart
 
 static void max3100_stop_rx(struct uart_port *port)
 {
-	struct max3100_port *s = container_of(port,
-					      struct max3100_port,
-					      port);
+	struct max3100_port *s = to_max3100_port(port);
 
 	dev_dbg(&s->spi->dev, "%s\n", __func__);
 
@@ -383,9 +382,7 @@ static void max3100_stop_rx(struct uart_
 
 static unsigned int max3100_tx_empty(struct uart_port *port)
 {
-	struct max3100_port *s = container_of(port,
-					      struct max3100_port,
-					      port);
+	struct max3100_port *s = to_max3100_port(port);
 
 	dev_dbg(&s->spi->dev, "%s\n", __func__);
 
@@ -396,9 +393,7 @@ static unsigned int max3100_tx_empty(str
 
 static unsigned int max3100_get_mctrl(struct uart_port *port)
 {
-	struct max3100_port *s = container_of(port,
-					      struct max3100_port,
-					      port);
+	struct max3100_port *s = to_max3100_port(port);
 
 	dev_dbg(&s->spi->dev, "%s\n", __func__);
 
@@ -410,9 +405,7 @@ static unsigned int max3100_get_mctrl(st
 
 static void max3100_set_mctrl(struct uart_port *port, unsigned int mctrl)
 {
-	struct max3100_port *s = container_of(port,
-					      struct max3100_port,
-					      port);
+	struct max3100_port *s = to_max3100_port(port);
 	int rts;
 
 	dev_dbg(&s->spi->dev, "%s\n", __func__);
@@ -432,9 +425,7 @@ static void
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
@@ -558,9 +549,7 @@ max3100_set_termios(struct uart_port *po
 
 static void max3100_shutdown(struct uart_port *port)
 {
-	struct max3100_port *s = container_of(port,
-					      struct max3100_port,
-					      port);
+	struct max3100_port *s = to_max3100_port(port);
 
 	dev_dbg(&s->spi->dev, "%s\n", __func__);
 
@@ -587,9 +576,7 @@ static void max3100_shutdown(struct uart
 
 static int max3100_startup(struct uart_port *port)
 {
-	struct max3100_port *s = container_of(port,
-					      struct max3100_port,
-					      port);
+	struct max3100_port *s = to_max3100_port(port);
 
 	dev_dbg(&s->spi->dev, "%s\n", __func__);
 
@@ -601,7 +588,7 @@ static int max3100_startup(struct uart_p
 	s->rts = 0;
 
 	if (request_threaded_irq(s->irq, NULL, max3100_ist,
-			IRQF_TRIGGER_FALLING, "max3100", s) < 0) {
+				 IRQF_TRIGGER_FALLING, "max3100", s) < 0) {
 		dev_err(&s->spi->dev, "cannot allocate irq %d\n", s->irq);
 		s->irq = 0;
 		return -EBUSY;
@@ -627,9 +614,7 @@ static int max3100_startup(struct uart_p
 
 static const char *max3100_type(struct uart_port *port)
 {
-	struct max3100_port *s = container_of(port,
-					      struct max3100_port,
-					      port);
+	struct max3100_port *s = to_max3100_port(port);
 
 	dev_dbg(&s->spi->dev, "%s\n", __func__);
 
@@ -638,18 +623,14 @@ static const char *max3100_type(struct u
 
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
 
@@ -660,9 +641,7 @@ static void max3100_config_port(struct u
 static int max3100_verify_port(struct uart_port *port,
 			       struct serial_struct *ser)
 {
-	struct max3100_port *s = container_of(port,
-					      struct max3100_port,
-					      port);
+	struct max3100_port *s = to_max3100_port(port);
 	int ret = -EINVAL;
 
 	dev_dbg(&s->spi->dev, "%s\n", __func__);
@@ -674,18 +653,14 @@ static int max3100_verify_port(struct ua
 
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
@@ -693,9 +668,7 @@ static int max3100_request_port(struct u
 
 static void max3100_break_ctl(struct uart_port *port, int break_state)
 {
-	struct max3100_port *s = container_of(port,
-					      struct max3100_port,
-					      port);
+	struct max3100_port *s = to_max3100_port(port);
 
 	dev_dbg(&s->spi->dev, "%s\n", __func__);
 }
@@ -1011,9 +984,9 @@ static int max3100_suspend(struct spi_de
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

linux-next.patch
max3100-to_max3100_port-small-style-fixes.patch
max3100-add-console-support-for-max3100-fixes-for-the-max31x0-console.patch

