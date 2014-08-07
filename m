From: akpm@linux-foundation.org
Subject: [merged] printk-use-a-clever-macro.patch removed from -mm tree
Date: Thu, 07 Aug 2014 13:07:23 -0700
Message-ID: <53e3dc7b.uiEpB0VTGoeMU8vx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qg0-f73.google.com ([209.85.192.73]:64808 "EHLO
	mail-qg0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755104AbaHGUHY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:07:24 -0400
Received: by mail-qg0-f73.google.com with SMTP id q107so609465qgd.0
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:07:23 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: elder@linaro.org, ak@linux.intel.com, bp@suse.de, jack@suse.cz, john.stultz@linaro.org, pmladek@suse.cz, rostedt@goodmis.org, mm-commits@vger.kernel.org


The patch titled
     Subject: printk: use a clever macro
has been removed from the -mm tree.  Its filename was
     printk-use-a-clever-macro.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alex Elder <elder@linaro.org>
Subject: printk: use a clever macro

Use the IS_ENABLED() macro rather than #ifdef blocks to set certain
global values.

Signed-off-by: Alex Elder <elder@linaro.org>
Acked-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Petr Mladek <pmladek@suse.cz>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Jan Kara <jack@suse.cz>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk/printk.c |   12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff -puN kernel/printk/printk.c~printk-use-a-clever-macro kernel/printk/printk.c
--- a/kernel/printk/printk.c~printk-use-a-clever-macro
+++ a/kernel/printk/printk.c
@@ -454,11 +454,7 @@ static int log_store(int facility, int l
 	return msg->text_len;
 }
 
-#ifdef CONFIG_SECURITY_DMESG_RESTRICT
-int dmesg_restrict = 1;
-#else
-int dmesg_restrict;
-#endif
+int dmesg_restrict = IS_ENABLED(CONFIG_SECURITY_DMESG_RESTRICT);
 
 static int syslog_action_restricted(int type)
 {
@@ -988,11 +984,7 @@ static inline void boot_delay_msec(int l
 }
 #endif
 
-#if defined(CONFIG_PRINTK_TIME)
-static bool printk_time = 1;
-#else
-static bool printk_time;
-#endif
+static bool printk_time = IS_ENABLED(CONFIG_PRINTK_TIME);
 module_param_named(time, printk_time, bool, S_IRUGO | S_IWUSR);
 
 static size_t print_time(u64 ts, char *buf)
_

Patches currently in -mm which might be from elder@linaro.org are

origin.patch
linux-next.patch

