From: akpm@linux-foundation.org
Subject: - serial-fix-8250-early-console-setup.patch removed from -mm tree
Date: Mon, 06 Aug 2007 00:52:50 -0700
Message-ID: <200708060752.l767qolA016266@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54726 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756638AbXHFHxe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Aug 2007 03:53:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: daniel.ritz-ml@swissonline.ch, daniel.ritz@gmx.ch, yinghai.lu@sun.com, mm-commits@vger.kernel.org


The patch titled
     serial: fix 8250 early console setup
has been removed from the -mm tree.  Its filename was
     serial-fix-8250-early-console-setup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: serial: fix 8250 early console setup
From: Daniel Ritz <daniel.ritz-ml@swissonline.ch>

The early setup function serial8250_console_early_setup() can be called
from non __init code (eg.  hotpluggable serial ports like serial_cs) so
remove the __init from the call chain to avoid crashes.

Signed-off-by: Daniel Ritz <daniel.ritz@gmx.ch>
Cc: Yinghai Lu <yinghai.lu@sun.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/8250.c       |    2 +-
 drivers/serial/8250_early.c |    2 +-
 kernel/printk.c             |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/serial/8250.c~serial-fix-8250-early-console-setup drivers/serial/8250.c
--- a/drivers/serial/8250.c~serial-fix-8250-early-console-setup
+++ a/drivers/serial/8250.c
@@ -2514,7 +2514,7 @@ static int __init serial8250_console_set
 	return uart_set_options(port, co, baud, parity, bits, flow);
 }
 
-static int __init serial8250_console_early_setup(void)
+static int serial8250_console_early_setup(void)
 {
 	return serial8250_find_port_for_earlycon();
 }
diff -puN drivers/serial/8250_early.c~serial-fix-8250-early-console-setup drivers/serial/8250_early.c
--- a/drivers/serial/8250_early.c~serial-fix-8250-early-console-setup
+++ a/drivers/serial/8250_early.c
@@ -227,7 +227,7 @@ int __init setup_early_serial8250_consol
 	return 0;
 }
 
-int __init serial8250_find_port_for_earlycon(void)
+int serial8250_find_port_for_earlycon(void)
 {
 	struct early_serial8250_device *device = &early_device;
 	struct uart_port *port = &device->port;
diff -puN kernel/printk.c~serial-fix-8250-early-console-setup kernel/printk.c
--- a/kernel/printk.c~serial-fix-8250-early-console-setup
+++ a/kernel/printk.c
@@ -732,7 +732,7 @@ int __init add_preferred_console(char *n
 	return 0;
 }
 
-int __init update_console_cmdline(char *name, int idx, char *name_new, int idx_new, char *options)
+int update_console_cmdline(char *name, int idx, char *name_new, int idx_new, char *options)
 {
 	struct console_cmdline *c;
 	int i;
_

Patches currently in -mm which might be from daniel.ritz-ml@swissonline.ch are

drivers-char-pcmcia-cm40x0_csc-fix-release-function-call.patch
