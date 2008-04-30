From: akpm@linux-foundation.org
Subject: - basic-braille-screen-reader-support-doc.patch removed from -mm tree
Date: Tue, 29 Apr 2008 23:24:21 -0700
Message-ID: <200804300624.m3U6OL84031669@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43805 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758269AbYD3GZ1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 02:25:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: samuel.thibault@ens-lyon.org, dtor@mail.ru, jikos@jikos.cz, rdunlap@xenotime.net, mm-commits@vger.kernel.org


The patch titled
     Braille screen reader documentation
has been removed from the -mm tree.  Its filename was
     basic-braille-screen-reader-support-doc.patch

This patch was dropped because it was folded into basic-braille-screen-reader-support.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Braille screen reader documentation
From: Samuel Thibault <samuel.thibault@ens-lyon.org>

Document the console=brl option and the usage of the braille screen reader.

Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
Cc: Jiri Kosina <jikos@jikos.cz>
Cc: Dmitry Torokhov <dtor@mail.ru>
Cc: "Randy.Dunlap" <rdunlap@xenotime.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/braille-console.txt   |   34 ++++++++++++++++++++++++++
 Documentation/kernel-parameters.txt |    5 +++
 2 files changed, 39 insertions(+)

diff -puN /dev/null Documentation/braille-console.txt
--- /dev/null
+++ a/Documentation/braille-console.txt
@@ -0,0 +1,34 @@
+                       Linux Braille Console
+
+To get early boot messages on a braille device (before userspace screen
+readers can start), you first need to compile the support for the usual serial
+console (see serial-console.txt), and for braille device (in Device Drivers -
+Accessibility).
+
+Then you need to specify a console=brl, option on the kernel command line, the
+format is:
+
+	console=brl,serial_options...
+
+where serial_options... are the same as described in serial-console.txt
+
+So for instance you can use console=brl,ttyS0 if the braille device is connected
+to the first serial port, and console=brl,ttyS0,115200 to override the baud rate
+to 115200, etc.
+
+By default, the braille device will just show the last kernel message (console
+mode).  To review previous messages, press the Insert key to switch to the VT
+review mode.  In review mode, the arrow keys permit to browse in the VT content,
+page up/down keys go at the top/bottom of the screen, and the home key goes back
+to the cursor, hence providing very basic screen reviewing facility.
+
+Sound feedback can be obtained by adding the braille_console.sound=1 kernel
+parameter.
+
+For simplicity, only one braille console can be enabled, other uses of
+console=brl,... will be discarded.  Also note that it does not interfere with
+the console selection mecanism described in serial-console.txt
+
+For now, only the VisioBraille device is supported.
+
+Samuel Thibault <samuel.thibault@ens-lyon.org>
diff -puN Documentation/kernel-parameters.txt~basic-braille-screen-reader-support-doc Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~basic-braille-screen-reader-support-doc
+++ a/Documentation/kernel-parameters.txt
@@ -496,6 +496,11 @@ and is between 256 and 4096 characters. 
 			switching to the matching ttyS device later.  The
 			options are the same as for ttyS, above.
 
+                If the device connected to the port is not a TTY but a braille
+                device, prepend "brl," before the device type, for instance
+			console=brl,ttyS0
+		For now, only VisioBraille is supported.
+
 	earlycon=	[KNL] Output early console device and options.
 		uart[8250],io,<addr>[,options]
 		uart[8250],mmio,<addr>[,options]
_

Patches currently in -mm which might be from samuel.thibault@ens-lyon.org are

origin.patch
consoles-switch-to-int-put_char-method.patch
basic-braille-screen-reader-support.patch
basic-braille-screen-reader-support-doc.patch
basic-braille-screen-reader-support-makefile-fix.patch

