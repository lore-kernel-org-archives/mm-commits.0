From: akpm@linux-foundation.org
Subject: [merged] printk-boot_delay-should-only-affect-output.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:03:26 -0800
Message-ID: <20121218200326.9AD6E82004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:59613 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754676Ab2LRUD1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:03:27 -0500
Received: by mail-vc0-f202.google.com with SMTP id m8so125167vcd.1
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:03:27 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: acooks@gmail.com, joe@perches.com, rdunlap@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: printk: boot_delay should only affect output
has been removed from the -mm tree.  Its filename was
     printk-boot_delay-should-only-affect-output.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Cooks <acooks@gmail.com>
Subject: printk: boot_delay should only affect output

The boot_delay parameter affects all printk(), even if the log level
prevents visible output from the call.  It results in delays greater than
the user intended without purpose.

This patch changes the behaviour of boot_delay to only delay output.

Signed-off-by: Andrew Cooks <acooks@gmail.com>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk.c |   40 +++++++++++++++++++++-------------------
 1 file changed, 21 insertions(+), 19 deletions(-)

diff -puN kernel/printk.c~printk-boot_delay-should-only-affect-output kernel/printk.c
--- a/kernel/printk.c~printk-boot_delay-should-only-affect-output
+++ a/kernel/printk.c
@@ -747,6 +747,21 @@ void __init setup_log_buf(int early)
 		free, (free * 100) / __LOG_BUF_LEN);
 }
 
+static bool __read_mostly ignore_loglevel;
+
+static int __init ignore_loglevel_setup(char *str)
+{
+	ignore_loglevel = 1;
+	printk(KERN_INFO "debug: ignoring loglevel setting.\n");
+
+	return 0;
+}
+
+early_param("ignore_loglevel", ignore_loglevel_setup);
+module_param(ignore_loglevel, bool, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(ignore_loglevel, "ignore loglevel setting, to"
+	"print all kernel messages to the console.");
+
 #ifdef CONFIG_BOOT_PRINTK_DELAY
 
 static int boot_delay; /* msecs delay after each printk during bootup */
@@ -770,13 +785,15 @@ static int __init boot_delay_setup(char 
 }
 __setup("boot_delay=", boot_delay_setup);
 
-static void boot_delay_msec(void)
+static void boot_delay_msec(int level)
 {
 	unsigned long long k;
 	unsigned long timeout;
 
-	if (boot_delay == 0 || system_state != SYSTEM_BOOTING)
+	if ((boot_delay == 0 || system_state != SYSTEM_BOOTING)
+		|| (level >= console_loglevel && !ignore_loglevel)) {
 		return;
+	}
 
 	k = (unsigned long long)loops_per_msec * boot_delay;
 
@@ -795,7 +812,7 @@ static void boot_delay_msec(void)
 	}
 }
 #else
-static inline void boot_delay_msec(void)
+static inline void boot_delay_msec(int level)
 {
 }
 #endif
@@ -1238,21 +1255,6 @@ SYSCALL_DEFINE3(syslog, int, type, char 
 	return do_syslog(type, buf, len, SYSLOG_FROM_CALL);
 }
 
-static bool __read_mostly ignore_loglevel;
-
-static int __init ignore_loglevel_setup(char *str)
-{
-	ignore_loglevel = 1;
-	printk(KERN_INFO "debug: ignoring loglevel setting.\n");
-
-	return 0;
-}
-
-early_param("ignore_loglevel", ignore_loglevel_setup);
-module_param(ignore_loglevel, bool, S_IRUGO | S_IWUSR);
-MODULE_PARM_DESC(ignore_loglevel, "ignore loglevel setting, to"
-	"print all kernel messages to the console.");
