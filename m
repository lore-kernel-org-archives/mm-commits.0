From: akpm@linux-foundation.org
Subject: - make-sure-uart-is-powered-up-when-dumping-mctrl-status.patch removed from -mm tree
Date: Thu, 15 Feb 2007 00:47:30 -0800
Message-ID: <200702150847.l1F8lU7u024986@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39946 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965370AbXBOIrz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 03:47:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gdavis@mvista.com, alan@lxorguk.ukuu.org.uk, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     serial: make sure UART is powered up when dumping MCTRL status
has been removed from the -mm tree.  Its filename was
     make-sure-uart-is-powered-up-when-dumping-mctrl-status.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: serial: make sure UART is powered up when dumping MCTRL status
From: "George G. Davis" <gdavis@mvista.com>

Since serial devices are powered down when not in use and some of those
devices cannot be accessed when powered down, we need to enable power
around calls to get_mcrtl() when dumping port state via uart_line_info(). 
This resolves hangs observed on some machines while reading serial device
registers when a port is powered off.

Signed-off-by: George G. Davis <gdavis@mvista.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/serial_core.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff -puN drivers/serial/serial_core.c~make-sure-uart-is-powered-up-when-dumping-mctrl-status drivers/serial/serial_core.c
--- a/drivers/serial/serial_core.c~make-sure-uart-is-powered-up-when-dumping-mctrl-status
+++ a/drivers/serial/serial_core.c
@@ -1660,6 +1660,7 @@ static const char *uart_type(struct uart
 static int uart_line_info(char *buf, struct uart_driver *drv, int i)
 {
 	struct uart_state *state = drv->state + i;
+	int pm_state;
 	struct uart_port *port = state->port;
 	char stat_buf[32];
 	unsigned int status;
@@ -1682,9 +1683,16 @@ static int uart_line_info(char *buf, str
 
 	if(capable(CAP_SYS_ADMIN))
 	{
+		mutex_lock(&state->mutex);
+		pm_state = state->pm_state;
+		if (pm_state)
+			uart_change_pm(state, 0);
 		spin_lock_irq(&port->lock);
 		status = port->ops->get_mctrl(port);
 		spin_unlock_irq(&port->lock);
+		if (pm_state)
+			uart_change_pm(state, pm_state);
+		mutex_unlock(&state->mutex);
 
 		ret += sprintf(buf + ret, " tx:%d rx:%d",
 				port->icount.tx, port->icount.rx);
@@ -2100,6 +2108,9 @@ uart_configure_port(struct uart_driver *
 
 		uart_report_port(drv, port);
 
+		/* Power up port for set_mctrl() */
+		uart_change_pm(state, 0);
+
 		/*
 		 * Ensure that the modem control lines are de-activated.
 		 * We probably don't need a spinlock around this, but
_

Patches currently in -mm which might be from gdavis@mvista.com are

origin.patch
