From: akpm@osdl.org
Subject: + modpost-add-more-symbols-to-whitelist-pattern2.patch added to -mm tree
Date: Wed, 27 Dec 2006 13:12:25 -0800
Message-ID: <200612272112.kBRLCPFe020326@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:35171 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754791AbWL0VMy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Dec 2006 16:12:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vgoyal@in.ibm.com, ak@suse.de, ebiederm@xmission.com


The patch titled
     modpost add more symbols to whitelist pattern2
has been added to the -mm tree.  Its filename is
     modpost-add-more-symbols-to-whitelist-pattern2.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

i386-cpu-hotplug-smpboot-misc-modpost-warning-fixes.patch
convert-some-functions-to-__init-to-avoid-modpost-warnings.patch
i386-move-startup_32-in-texthead-section.patch
break-init-in-two-parts-to-avoid-modpost-warnings.patch
i386-fix-memory-hotplug-related-modpost-generated-warning.patch
i386-restore-config_physical_start-option.patch
i386-make-apic-probe-function-non-init.patch
modpost-add-more-symbols-to-whitelist-pattern2.patch
modpost-whitelist-reference-to-more-symbols-pattern-3.patch
clockevents-i386-drivers.patch

