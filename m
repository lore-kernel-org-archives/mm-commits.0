From: akpm@linux-foundation.org
Subject: + fix-misuse-of-wakeup-flag-accessors-in-serial-core.patch added to -mm tree
Date: Wed, 19 Mar 2008 15:21:58 -0700
Message-ID: <200803192221.m2JMLwvi007089@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54393 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753587AbYCSWWW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 Mar 2008 18:22:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: stern@rowland.harvard.edu, greg@kroah.com, rjw@sisk.pl


The patch titled
     Fix misuse of wakeup flag accessors in serial core
has been added to the -mm tree.  Its filename is
     fix-misuse-of-wakeup-flag-accessors-in-serial-core.patch

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

revert-gregkh-driver-pm-make-wakeup-flags-available-whenever-config_pm-is-set.patch
fix-misuse-of-wakeup-flag-accessors-in-serial-core.patch
pm-make-wakeup-flags-available-whenever-config_pm-is-set-ver-2.patch
pm-convert-wakeup-flag-accessors-to-inline-functions.patch
isd200-fix-memory-leak-in-isd200_get_inquiry_data.patch

