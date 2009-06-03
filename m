From: akpm@linux-foundation.org
Subject: [merged] usb_serial-only-allow-sysrq-on-a-console-port.patch removed from -mm tree
Date: Wed, 03 Jun 2009 13:02:42 -0700
Message-ID: <200906032002.n53K2gQq002014@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48877 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754370AbZFCUDJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Jun 2009 16:03:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jason.wessel@windriver.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     usb_serial: only allow sysrq on a console port
has been removed from the -mm tree.  Its filename was
     usb_serial-only-allow-sysrq-on-a-console-port.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: usb_serial: only allow sysrq on a console port
From: Jason Wessel <jason.wessel@windriver.com>

The only time a sysrq should get processed is if the attached device is a
console.  This is intended to protect sysrq execution on a host connected
with a terminal program.

Here is the problem scenario:

host A <-- rs232 link --> host B

Host A is using mincom and a usb pl2303 device to connect to host b which
is a linux system with a usb pl2303 device acting as the serial console. 
When host B is rebooted the pl2303 emits random junk characters on reset. 
These character sequences contain serial break signals most of the time
and when translated to a sysrq have caused host A to get random processes
killed, reboots or power down.

It is true that in this setup with this patch host B might still have the
same problem as host A if you reboot host A.  In most cases host A is a
development host which seldom gets rebooted, and you could turn off sysrq
temporarily on host B if you need to reboot host A.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/serial/generic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/usb/serial/generic.c~usb_serial-only-allow-sysrq-on-a-console-port drivers/usb/serial/generic.c
--- a/drivers/usb/serial/generic.c~usb_serial-only-allow-sysrq-on-a-console-port
+++ a/drivers/usb/serial/generic.c
@@ -528,7 +528,7 @@ void usb_serial_generic_unthrottle(struc
 
 int usb_serial_handle_sysrq_char(struct usb_serial_port *port, unsigned int ch)
 {
-	if (port->sysrq) {
+	if (port->sysrq && port->console) {
 		if (ch && time_before(jiffies, port->sysrq)) {
 			handle_sysrq(ch, tty_port_tty_get(&port->port));
 			port->sysrq = 0;
_

Patches currently in -mm which might be from jason.wessel@windriver.com are

linux-next.patch
frv-duplicate-output_buffer-of-e03.patch
kgdb-kgdboc-console-poll-hooks-for-serial_txx9-uart.patch

