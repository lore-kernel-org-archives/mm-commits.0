From: akpm@linux-foundation.org
Subject: + printk-boot_delay-should-only-affect-output.patch added to -mm tree
Date: Tue, 13 Nov 2012 15:29:17 -0800
Message-ID: <20121113232918.0EC8B5C0060@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:54344 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755939Ab2KMX3U (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 13 Nov 2012 18:29:20 -0500
Received: by mail-ee0-f74.google.com with SMTP id t10so213436eei.1
        for <mm-commits@vger.kernel.org>; Tue, 13 Nov 2012 15:29:19 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: acooks@gmail.com, joe@perches.com, rdunlap@infradead.org


The patch titled
     Subject: printk: boot_delay should only affect output
has been added to the -mm tree.  Its filename is
     printk-boot_delay-should-only-affect-output.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
