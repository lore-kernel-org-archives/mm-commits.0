From: akpm@linux-foundation.org
Subject: [alternative-merged] usb-serial-regression-fix-to-move-sysrq-from-hot-path.patch removed from -mm tree
Date: Mon, 13 Jul 2009 11:54:38 -0700
Message-ID: <200907131854.n6DIscHb031860@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39955 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751732AbZGMSym (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 13 Jul 2009 14:54:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jason.wessel@windriver.com, alan@linux.intel.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     usb-serial: regression fix to move sysrq from hot path
has been removed from the -mm tree.  Its filename was
     usb-serial-regression-fix-to-move-sysrq-from-hot-path.patch

This patch was dropped because an alternative patch was merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: usb-serial: regression fix to move sysrq from hot path
From: Jason Wessel <jason.wessel@windriver.com>

A performance regression was introduced by commit
98fcb5f78165b8a3d93870ad7afd4d9ebbb8b43a ("USB: serial:
usb_debug,usb_generic_serial: implement sysrq and serial break").

The sysrq handling should only get executed if the attached usb serial
device is acting as a serial system console.  A serial system console has
a very low input throughput vs a 3g usb modem which pushes bytes through
the same interface at a high rate.

Entire strings of output can be processed via the tty input when the
device is not a console.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
Acked-by: Alan Cox <alan@linux.intel.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/serial/generic.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff -puN drivers/usb/serial/generic.c~usb-serial-regression-fix-to-move-sysrq-from-hot-path drivers/usb/serial/generic.c
--- a/drivers/usb/serial/generic.c~usb-serial-regression-fix-to-move-sysrq-from-hot-path
+++ a/drivers/usb/serial/generic.c
@@ -425,11 +425,19 @@ static void flush_and_resubmit_read_urb(
 		goto done;
 
 	/* Push data to tty */
-	for (i = 0; i < urb->actual_length; i++, ch++) {
-		if (!usb_serial_handle_sysrq_char(port, *ch))
-			tty_insert_flip_char(tty, *ch, TTY_NORMAL);
+	if (port->console) {
+		for (i = 0; i < urb->actual_length; i++, ch++) {
+			if (!usb_serial_handle_sysrq_char(port, *ch))
+				tty_insert_flip_char(tty, *ch, TTY_NORMAL);
+		}
+		tty_flip_buffer_push(tty);
+	} else if (urb->actual_length) {
+		i = tty_buffer_request_room(tty, urb->actual_length);
+		if (i) {
+			tty_insert_flip_string(tty, urb->transfer_buffer, i);
+			tty_flip_buffer_push(tty);
+		}
 	}
-	tty_flip_buffer_push(tty);
 	tty_kref_put(tty);
 done:
 	usb_serial_generic_resubmit_read_urb(port, GFP_ATOMIC);
_

Patches currently in -mm which might be from jason.wessel@windriver.com are

linux-next.patch
usb-serial-regression-fix-to-move-sysrq-from-hot-path.patch
frv-duplicate-output_buffer-of-e03.patch

