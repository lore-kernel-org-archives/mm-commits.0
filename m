From: akpm@osdl.org
Subject: - modpost-add-more-symbols-to-whitelist-pattern2.patch removed from -mm tree
Date: Wed, 10 Jan 2007 15:03:38 -0800
Message-ID: <200701102303.l0AN3cqT010840@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:33425 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965264AbXAJXDt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Jan 2007 18:03:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vgoyal@in.ibm.com, ak@suse.de, ebiederm@xmission.com, mm-commits@vger.kernel.org


The patch titled
     modpost add more symbols to whitelist pattern2
has been removed from the -mm tree.  Its filename was
     modpost-add-more-symbols-to-whitelist-pattern2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: modpost add more symbols to whitelist pattern2
From: Vivek Goyal <vgoyal@in.ibm.com>

o MODPOST generates warning for i386 if compiled with CONFIG_RELOCATABLE=y
  and serial console support is enabled.

o Serial console setup function, serial8250_console_setup(), is a non __init
  function and it calls functions which are of type __init().
  (uart_parse_options() and uart_set_options()). Assuming, setup will
  be called during init time, changing serial8250_console_setup() to __init.

o Adding one more pattern to modpost whitelist. Console drivers might
  have *_console structures containing references to setup functions which
  can be of __init type. Don't generate warnings for those.

WARNING: vmlinux - Section mismatch: reference to .init.text: from .data between 'serial8250_console' (at offset 0xc05a33d8) and 'serial8250_reg'

Signed-off-by: Vivek Goyal <vgoyal@in.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/serial/8250.c |    2 +-
 scripts/mod/modpost.c |    1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/serial/8250.c~modpost-add-more-symbols-to-whitelist-pattern2 drivers/serial/8250.c
--- a/drivers/serial/8250.c~modpost-add-more-symbols-to-whitelist-pattern2
+++ a/drivers/serial/8250.c
@@ -2394,7 +2394,7 @@ serial8250_console_write(struct console 
 	local_irq_restore(flags);
 }
 
-static int serial8250_console_setup(struct console *co, char *options)
+static int __init serial8250_console_setup(struct console *co, char *options)
 {
 	struct uart_port *port;
 	int baud = 9600;
diff -puN scripts/mod/modpost.c~modpost-add-more-symbols-to-whitelist-pattern2 scripts/mod/modpost.c
--- a/scripts/mod/modpost.c~modpost-add-more-symbols-to-whitelist-pattern2
+++ a/scripts/mod/modpost.c
@@ -595,6 +595,7 @@ static int secref_whitelist(const char *
 		"_ops",
 		"_probe",
 		"_probe_one",
+		"_console",
 		NULL
 	};
 
_

Patches currently in -mm which might be from vgoyal@in.ibm.com are

change-cpu_up-and-co-from-__devinit-to-__cpuinit.patch
kdump-documentation-update-for-2620.patch
pci-quirks-modpost-warning-fix.patch
i386-sched_clock-using-init-data-tsc_disable-fix.patch
make-noirqdebug_setup-function-non-init-to-fix-modpost-warning.patch
scsi-megaraid_mmmbox-init-fix-for-kdump.patch
clockevents-i386-drivers.patch
