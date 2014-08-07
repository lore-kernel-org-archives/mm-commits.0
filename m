From: akpm@linux-foundation.org
Subject: [merged] printk-miscellaneous-cleanups.patch removed from -mm
 tree
Date: Thu, 07 Aug 2014 13:07:25 -0700
Message-ID: <53e3dc7d.KLXtnfU4w2JCIxBu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ie0-f201.google.com ([209.85.223.201]:55503 "EHLO
	mail-ie0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755104AbaHGUH0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:07:26 -0400
Received: by mail-ie0-f201.google.com with SMTP id tr6so842800ieb.2
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:07:25 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: elder@linaro.org, ak@linux.intel.com, bp@suse.de, jack@suse.cz, john.stultz@linaro.org, pmladek@suse.cz, rostedt@goodmis.org, mm-commits@vger.kernel.org


The patch titled
     Subject: printk: miscellaneous cleanups
has been removed from the -mm tree.  Its filename was
     printk-miscellaneous-cleanups.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alex Elder <elder@linaro.org>
Subject: printk: miscellaneous cleanups

Some small cleanups to kernel/printk/printk.c.  None of them should cause
any change in behavior.

  - When CONFIG_PRINTK is defined, parenthesize the value of LOG_LINE_MAX.
  - When CONFIG_PRINTK is *not* defined, there is an extra LOG_LINE_MAX
    definition; delete it.
  - Pull an assignment out of a conditional expression in console_setup().
  - Use isdigit() in console_setup() rather than open coding it.
  - In update_console_cmdline(), drop a NUL-termination assignment;
    the strlcpy() call that precedes it guarantees it's not needed.
  - Simplify some logic in printk_timed_ratelimit().

Signed-off-by: Alex Elder <elder@linaro.org>
Reviewed-by: Petr Mladek <pmladek@suse.cz>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: Jan Kara <jack@suse.cz>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk/printk.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff -puN kernel/printk/printk.c~printk-miscellaneous-cleanups kernel/printk/printk.c
--- a/kernel/printk/printk.c~printk-miscellaneous-cleanups
+++ a/kernel/printk/printk.c
@@ -45,6 +45,7 @@
 #include <linux/poll.h>
 #include <linux/irq_work.h>
 #include <linux/utsname.h>
+#include <linux/ctype.h>
 
 #include <asm/uaccess.h>
 
@@ -257,7 +258,7 @@ static u64 clear_seq;
 static u32 clear_idx;
 
 #define PREFIX_MAX		32
-#define LOG_LINE_MAX		1024 - PREFIX_MAX
+#define LOG_LINE_MAX		(1024 - PREFIX_MAX)
 
 /* record buffer */
 #if defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS)
@@ -1835,7 +1836,7 @@ EXPORT_SYMBOL(printk);
 
 #define LOG_LINE_MAX		0
 #define PREFIX_MAX		0
-#define LOG_LINE_MAX 0
+
 static u64 syslog_seq;
 static u32 syslog_idx;
 static u64 console_seq;
@@ -1936,7 +1937,8 @@ static int __init console_setup(char *st
 		strncpy(buf, str, sizeof(buf) - 1);
 	}
 	buf[sizeof(buf) - 1] = 0;
-	if ((options = strchr(str, ',')) != NULL)
+	options = strchr(str, ',');
+	if (options)
 		*(options++) = 0;
 #ifdef __sparc__
 	if (!strcmp(str, "ttya"))
@@ -1945,7 +1947,7 @@ static int __init console_setup(char *st
 		strcpy(buf, "ttyS1");
 #endif
 	for (s = buf; *s; s++)
-		if ((*s >= '0' && *s <= '9') || *s == ',')
+		if (isdigit(*s) || *s == ',')
 			break;
 	idx = simple_strtoul(s, NULL, 10);
 	*s = 0;
@@ -1984,7 +1986,6 @@ int update_console_cmdline(char *name, i
 	     i++, c++)
 		if (strcmp(c->name, name) == 0 && c->index == idx) {
 			strlcpy(c->name, name_new, sizeof(c->name));
-			c->name[sizeof(c->name) - 1] = 0;
 			c->options = options;
 			c->index = idx_new;
 			return i;
@@ -2652,14 +2653,13 @@ EXPORT_SYMBOL(__printk_ratelimit);
 bool printk_timed_ratelimit(unsigned long *caller_jiffies,
 			unsigned int interval_msecs)
 {
-	if (*caller_jiffies == 0
-			|| !time_in_range(jiffies, *caller_jiffies,
-					*caller_jiffies
-					+ msecs_to_jiffies(interval_msecs))) {
-		*caller_jiffies = jiffies;
-		return true;
-	}
-	return false;
+	unsigned long elapsed = jiffies - *caller_jiffies;
+
+	if (*caller_jiffies && elapsed <= msecs_to_jiffies(interval_msecs))
+		return false;
+
+	*caller_jiffies = jiffies;
+	return true;
 }
 EXPORT_SYMBOL(printk_timed_ratelimit);
 
_

Patches currently in -mm which might be from elder@linaro.org are

origin.patch
linux-next.patch

