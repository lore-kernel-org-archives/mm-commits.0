From: akpm@linux-foundation.org
Subject: [merged]
 printk-add-kconfig-option-to-set-default-console-loglevel.patch removed
 from -mm tree
Date: Wed, 14 Dec 2016 11:27:25 -0800
Message-ID: <58519d1d.NfN6dR7vBiehO1g+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45830 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756533AbcLNT2A (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Dec 2016 14:28:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: olof@lixom.net, mm-commits@vger.kernel.org


The patch titled
     Subject: printk: add Kconfig option to set default console loglevel
has been removed from the -mm tree.  Its filename was
     printk-add-kconfig-option-to-set-default-console-loglevel.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Olof Johansson <olof@lixom.net>
Subject: printk: add Kconfig option to set default console loglevel

Add a configuration option to set the default console loglevel.  This is,
as before, still possible to override at runtime through bootargs
(loglevel=<x>), sysrq and /proc/printk.

There are cases where adding additional arguments on the commandline is
impractical, and changing the default for the kernel when being built
makes more sense.  Provide such a method here, for those who choose to do
so.

Also, while touching this code, clarify the difference between
MESSAGE_LOGLEVEL_DEFAULT and CONSOLE_LOGLEVEL_DEFAULT.

Link: http://lkml.kernel.org/r/1479676829-30031-1-git-send-email-olof@lixom.net
Signed-off-by: Olof Johansson <olof@lixom.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/printk.h |    7 ++++++-
 lib/Kconfig.debug      |   19 +++++++++++++++++++
 2 files changed, 25 insertions(+), 1 deletion(-)

diff -puN include/linux/printk.h~printk-add-kconfig-option-to-set-default-console-loglevel include/linux/printk.h
--- a/include/linux/printk.h~printk-add-kconfig-option-to-set-default-console-loglevel
+++ a/include/linux/printk.h
@@ -50,10 +50,15 @@ static inline const char *printk_skip_he
 #define CONSOLE_LOGLEVEL_SILENT  0 /* Mum's the word */
 #define CONSOLE_LOGLEVEL_MIN	 1 /* Minimum loglevel we let people use */
 #define CONSOLE_LOGLEVEL_QUIET	 4 /* Shhh ..., when booted with "quiet" */
-#define CONSOLE_LOGLEVEL_DEFAULT 7 /* anything MORE serious than KERN_DEBUG */
 #define CONSOLE_LOGLEVEL_DEBUG	10 /* issue debug messages */
 #define CONSOLE_LOGLEVEL_MOTORMOUTH 15	/* You can't shut this one up */
 
+/*
+ * Default used to be hard-coded at 7, we're now allowing it to be set from
+ * kernel config.
+ */
+#define CONSOLE_LOGLEVEL_DEFAULT CONFIG_CONSOLE_LOGLEVEL_DEFAULT
+
 extern int console_printk[];
 
 #define console_loglevel (console_printk[0])
diff -puN lib/Kconfig.debug~printk-add-kconfig-option-to-set-default-console-loglevel lib/Kconfig.debug
--- a/lib/Kconfig.debug~printk-add-kconfig-option-to-set-default-console-loglevel
+++ a/lib/Kconfig.debug
@@ -15,6 +15,21 @@ config PRINTK_TIME
 	  The behavior is also controlled by the kernel command line
 	  parameter printk.time=1. See Documentation/kernel-parameters.txt
 
+config CONSOLE_LOGLEVEL_DEFAULT
+	int "Default console loglevel (1-15)"
+	range 1 15
+	default "7"
+	help
+	  Default loglevel to determine what will be printed on the console.
+
+	  Setting a default here is equivalent to passing in loglevel=<x> in
+	  the kernel bootargs. loglevel=<x> continues to override whatever
+	  value is specified here as well.
+
+	  Note: This does not affect the log level of un-prefixed prink()
+	  usage in the kernel. That is controlled by the MESSAGE_LOGLEVEL_DEFAULT
+	  option.
+
 config MESSAGE_LOGLEVEL_DEFAULT
 	int "Default message log level (1-7)"
 	range 1 7
@@ -26,6 +41,10 @@ config MESSAGE_LOGLEVEL_DEFAULT
 	  that are auditing their logs closely may want to set it to a lower
 	  priority.
 
+	  Note: This does not affect what message level gets printed on the console
+	  by default. To change that, use loglevel=<x> in the kernel bootargs,
+	  or pick a different CONSOLE_LOGLEVEL_DEFAULT configuration value.
+
 config BOOT_PRINTK_DELAY
 	bool "Delay each boot printk message by N milliseconds"
 	depends on DEBUG_KERNEL && PRINTK && GENERIC_CALIBRATE_DELAY
_

Patches currently in -mm which might be from olof@lixom.net are


