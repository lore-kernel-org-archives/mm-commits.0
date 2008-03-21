From: akpm@linux-foundation.org
Subject: - fix-misuse-of-wakeup-flag-accessors-in-serial-core.patch removed from -mm tree
Date: Fri, 21 Mar 2008 13:30:41 -0700
Message-ID: <200803212030.m2LKUfCb009004@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59606 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760598AbYCUUat (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Mar 2008 16:30:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: stern@rowland.harvard.edu, greg@kroah.com, rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     Fix misuse of wakeup flag accessors in serial core
has been removed from the -mm tree.  Its filename was
     fix-misuse-of-wakeup-flag-accessors-in-serial-core.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Fix misuse of wakeup flag accessors in serial core
From: Alan Stern <stern@rowland.harvard.edu>

This patch (as1059) fixes a mistake in the way the serial core initializes a
device's wakeup settings.  It should use the accessor routine instead of
relying on a macro producing an lvalue.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/serial_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/serial/serial_core.c~fix-misuse-of-wakeup-flag-accessors-in-serial-core drivers/serial/serial_core.c
--- a/drivers/serial/serial_core.c~fix-misuse-of-wakeup-flag-accessors-in-serial-core
+++ a/drivers/serial/serial_core.c
@@ -2422,7 +2422,7 @@ int uart_add_one_port(struct uart_driver
 	 */
 	tty_dev = tty_register_device(drv->tty_driver, port->line, port->dev);
 	if (likely(!IS_ERR(tty_dev))) {
-		device_can_wakeup(tty_dev) = 1;
+		device_init_wakeup(tty_dev, 1);
 		device_set_wakeup_enable(tty_dev, 0);
 	} else
 		printk(KERN_ERR "Cannot register tty device on line %d\n",
_

Patches currently in -mm which might be from stern@rowland.harvard.edu are


