From: akpm@linux-foundation.org
Subject: + serial-fix-enable_irq_wake-disable_irq_wake-imbalance-in-serial_corec.patch added to -mm tree
Date: Wed, 21 May 2008 14:53:48 -0700
Message-ID: <200805212153.m4LLrmr9002657@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41160 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932229AbYEUVx5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 May 2008 17:53:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: arjan@linux.intel.com, alan@lxorguk.ukuu.org.uk


The patch titled
     serial: fix enable_irq_wake/disable_irq_wake imbalance in serial_core.c
has been added to the -mm tree.  Its filename is
     serial-fix-enable_irq_wake-disable_irq_wake-imbalance-in-serial_corec.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: serial: fix enable_irq_wake/disable_irq_wake imbalance in serial_core.c
From: Arjan van de Ven <arjan@linux.intel.com>

enable_irq_wake() and disable_irq_wake() need to be balanced.  However,
serial_core.c calls these for different conditions during the suspend and
resume functions...

This is causing a regular WARN_ON() as found at
http://www.kerneloops.org/search.php?search=set_irq_wake

This patch makes the conditions for triggering the _wake enable/disable
sequence identical.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/serial_core.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN drivers/serial/serial_core.c~serial-fix-enable_irq_wake-disable_irq_wake-imbalance-in-serial_corec drivers/serial/serial_core.c
--- a/drivers/serial/serial_core.c~serial-fix-enable_irq_wake-disable_irq_wake-imbalance-in-serial_corec
+++ a/drivers/serial/serial_core.c
@@ -2054,6 +2054,8 @@ int uart_suspend_port(struct uart_driver
 int uart_resume_port(struct uart_driver *drv, struct uart_port *port)
 {
 	struct uart_state *state = drv->state + port->line;
+	struct device *tty_dev;
+	struct uart_match match = {port, drv};
 
 	mutex_lock(&state->mutex);
 
@@ -2063,7 +2065,8 @@ int uart_resume_port(struct uart_driver 
 		return 0;
 	}
 
-	if (!port->suspended) {
+	tty_dev = device_find_child(port->dev, &match, serial_match_port);
+	if (!port->suspended && device_may_wakeup(tty_dev)) {
 		disable_irq_wake(port->irq);
 		mutex_unlock(&state->mutex);
 		return 0;
_

Patches currently in -mm which might be from arjan@linux.intel.com are

origin.patch
linux-next.patch
serial-fix-enable_irq_wake-disable_irq_wake-imbalance-in-serial_corec.patch
rename-warn-to-warning-to-clear-the-namespace.patch
rename-warn-to-warning-to-clear-the-namespace-fix.patch
add-a-warn-macro-this-is-warn_on-printk-arguments.patch
add-a-warn-macro-this-is-warn_on-printk-arguments-fix.patch
add-a-warn-macro-this-is-warn_on-printk-arguments-fix-2.patch
example-use-of-warn.patch

