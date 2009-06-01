From: akpm@linux-foundation.org
Subject: + usb_serial-only-allow-sysrq-on-a-console-port.patch added to -mm tree
Date: Mon, 01 Jun 2009 16:27:27 -0700
Message-ID: <200906012327.n51NRRwF013106@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56657 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752936AbZFAX14 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Jun 2009 19:27:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jason.wessel@windriver.com, greg@kroah.com


The patch titled
     usb_serial: only allow sysrq on a console port
has been added to the -mm tree.  Its filename is
     usb_serial-only-allow-sysrq-on-a-console-port.patch

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
pl2303-usb_serial-implement-sysrq-handling-on-break.patch
usb_serial-only-allow-sysrq-on-a-console-port.patch
frv-duplicate-output_buffer-of-e03.patch
kgdb-kgdboc-console-poll-hooks-for-serial_txx9-uart.patch

