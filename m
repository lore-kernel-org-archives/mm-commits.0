From: akpm@linux-foundation.org
Subject: + xtensa-fix-compilation-somewhat.patch added to -mm tree
Date: Fri, 30 Jan 2009 13:17:47 -0800
Message-ID: <200901302117.n0ULHmPC018811@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35341 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753051AbZA3VRw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Jan 2009 16:17:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com, zankel@tensilica.com


The patch titled
     xtensa: fix compilation somewhat
has been added to the -mm tree.  Its filename is
     xtensa-fix-compilation-somewhat.patch

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
Subject: xtensa: fix compilation somewhat
From: Alexey Dobriyan <adobriyan@gmail.com>

* ->put_char changes
* HIGHMEM is bogus it seems, there is no kmap_atomic() et al
* some includes

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Chris Zankel <zankel@tensilica.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/xtensa/Kconfig                 |    3 ---
 arch/xtensa/kernel/setup.c          |    2 ++
 arch/xtensa/kernel/traps.c          |    1 +
 arch/xtensa/mm/fault.c              |    1 +
 arch/xtensa/platforms/iss/console.c |    6 ++----
 5 files changed, 6 insertions(+), 7 deletions(-)

diff -puN arch/xtensa/Kconfig~xtensa-fix-compilation-somewhat arch/xtensa/Kconfig
--- a/arch/xtensa/Kconfig~xtensa-fix-compilation-somewhat
+++ a/arch/xtensa/Kconfig
@@ -103,9 +103,6 @@ config MATH_EMULATION
 	help
 	Can we use information of configuration file?
 
-config HIGHMEM
-	bool "High memory support"
-
 endmenu
 
 menu "Platform options"
diff -puN arch/xtensa/kernel/setup.c~xtensa-fix-compilation-somewhat arch/xtensa/kernel/setup.c
--- a/arch/xtensa/kernel/setup.c~xtensa-fix-compilation-somewhat
+++ a/arch/xtensa/kernel/setup.c
@@ -44,6 +44,8 @@
 #include <asm/setup.h>
 #include <asm/param.h>
 
+#include <platform/hardware.h>
+
 #if defined(CONFIG_VGA_CONSOLE) || defined(CONFIG_DUMMY_CONSOLE)
 struct screen_info screen_info = { 0, 24, 0, 0, 0, 80, 0, 0, 0, 24, 1, 16};
 #endif
diff -puN arch/xtensa/kernel/traps.c~xtensa-fix-compilation-somewhat arch/xtensa/kernel/traps.c
--- a/arch/xtensa/kernel/traps.c~xtensa-fix-compilation-somewhat
+++ a/arch/xtensa/kernel/traps.c
@@ -30,6 +30,7 @@
 #include <linux/stringify.h>
 #include <linux/kallsyms.h>
 #include <linux/delay.h>
+#include <linux/hardirq.h>
 
 #include <asm/ptrace.h>
 #include <asm/timex.h>
diff -puN arch/xtensa/mm/fault.c~xtensa-fix-compilation-somewhat arch/xtensa/mm/fault.c
--- a/arch/xtensa/mm/fault.c~xtensa-fix-compilation-somewhat
+++ a/arch/xtensa/mm/fault.c
@@ -14,6 +14,7 @@
 
 #include <linux/mm.h>
 #include <linux/module.h>
+#include <linux/hardirq.h>
 #include <asm/mmu_context.h>
 #include <asm/cacheflush.h>
 #include <asm/hardirq.h>
diff -puN arch/xtensa/platforms/iss/console.c~xtensa-fix-compilation-somewhat arch/xtensa/platforms/iss/console.c
--- a/arch/xtensa/platforms/iss/console.c~xtensa-fix-compilation-somewhat
+++ a/arch/xtensa/platforms/iss/console.c
@@ -141,16 +141,14 @@ static void rs_poll(unsigned long priv)
 }
 
 
-static void rs_put_char(struct tty_struct *tty, unsigned char ch)
+static int rs_put_char(struct tty_struct *tty, unsigned char ch)
 {
 	char buf[2];
 
-	if (!tty)
-		return;
-
 	buf[0] = ch;
 	buf[1] = '\0';		/* Is this NULL necessary? */
 	__simc (SYS_write, 1, (unsigned long) buf, 1, 0, 0);
+	return 1;
 }
 
 static void rs_flush_chars(struct tty_struct *tty)
_

Patches currently in -mm which might be from adobriyan@gmail.com are

seq_file-move-traverse-so-it-can-be-used-from-seq_read.patch
seq_file-properly-cope-with-pread.patch
linux-next.patch
eeepc-should-depend-on-input.patch
tags-fix-config-symbols-generation.patch
sm501-fix-section-mismatches.patch
mpt-remove-unused-struct-mpt_proc_entry_t.patch
proc-tty-add-struct-tty_operations-proc_fops.patch
proc-tty-switch-cyclades-to-proc_fops.patch
proc-tty-switch-ip2-to-proc_fops.patch
proc-tty-switch-istallion-to-proc_fops.patch
proc-tty-switch-synclink_cs-to-proc_fops.patch
proc-tty-switch-stallion-to-proc_fops.patch
proc-tty-switch-synclink-to-proc_fops.patch
proc-tty-switch-synclink_gt-to-proc_fops.patch
proc-tty-switch-synclinkmp-to-proc_fops.patch
proc-tty-switch-sdio_uart-to-proc_fops.patch
proc-tty-switch-serial_core-to-proc_fops.patch
proc-tty-switch-usb-serial-to-proc_fops.patch
proc-tty-switch-ircomm-to-proc_fops.patch
proc-tty-switch-amiserial-to-proc_fops.patch
proc-tty-switch-ia64-simserial-to-proc_fops.patch
proc-tty-switch-xtensa-iss-console-to-proc_fops.patch
proc-tty-remove-struct-tty_operations-read_proc.patch
xtensa-fix-compilation-somewhat.patch
softirq-introduce-statistics-for-softirq.patch
proc-export-statistics-for-softirq-to-proc.patch
proc-export-statistics-for-softirq-to-proc-fix.patch
proc-update-document-for-proc-softirqs-and-proc-stat.patch

