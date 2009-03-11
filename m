From: akpm@linux-foundation.org
Subject: [merged] xtensa-fix-compilation-somewhat.patch removed from -mm tree
Date: Wed, 11 Mar 2009 11:09:28 -0700
Message-ID: <200903111809.n2BI9S9u019939@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44429 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752478AbZCKSLj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Mar 2009 14:11:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, zankel@tensilica.com, mm-commits@vger.kernel.org


The patch titled
     xtensa: fix compilation somewhat
has been removed from the -mm tree.  Its filename was
     xtensa-fix-compilation-somewhat.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: xtensa: fix compilation somewhat
From: Alexey Dobriyan <adobriyan@gmail.com>

* ->put_char changes
* HIGHMEM is bogus it seems, there is no kmap_atomic() et al
* some includes

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Acked-by: Chris Zankel <zankel@tensilica.com>
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
@@ -140,16 +140,14 @@ static void rs_poll(unsigned long priv)
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

origin.patch
proc-fix-kflags-to-uflags-copying-in-proc-kpageflags.patch
linux-next.patch
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
memdup_user-introduce.patch
memdup_user-introduce-fix.patch
mm-fix-proc_dointvec_userhz_jiffies-breakage.patch
mm-fix-proc_dointvec_userhz_jiffies-breakage-checkpatch-fixes.patch
softirq-introduce-statistics-for-softirq.patch
proc-export-statistics-for-softirq-to-proc.patch
proc-export-statistics-for-softirq-to-proc-fix.patch
proc-update-document-for-proc-softirqs-and-proc-stat.patch
proc_sysctl-use-config_proc_sysctl-around-ipc-and-utsname-proc_handlers.patch
namespaces-move-proc_net_get_sb-to-a-generic-fs-superc-helper.patch
namespaces-move-proc_net_get_sb-to-a-generic-fs-superc-helper-fix.patch
namespaces-mqueue-ns-move-mqueue_mnt-into-struct-ipc_namespace.patch
namespaces-ipc-namespaces-implement-support-for-posix-msqueues.patch
namespaces-ipc-namespaces-implement-support-for-posix-msqueues-initialize-init_ipc_nscount-to-1.patch
namespaces-mqueue-namespace-adapt-sysctl.patch
namespaces-mqueue-namespace-adapt-sysctl-update.patch
namespaces-mqueue-namespace-adapt-sysctl-update-fix.patch

