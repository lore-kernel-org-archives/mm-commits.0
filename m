From: akpm@linux-foundation.org
Subject: + printk-rename-default_message_loglevel.patch added to -mm tree
Date: Thu, 10 Jul 2014 14:41:37 -0700
Message-ID: <53bf0891.8YUX0esqDOeAMHh8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ie0-f201.google.com ([209.85.223.201]:41838 "EHLO
	mail-ie0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938AbaGJVlj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 10 Jul 2014 17:41:39 -0400
Received: by mail-ie0-f201.google.com with SMTP id lx4so44914iec.4
        for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2014 14:41:38 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: elder@linaro.org, ak@linux.intel.com, bp@suse.de, jack@suse.cz, john.stultz@linaro.org, pmladek@suse.cz, rostedt@goodmis.org, mm-commits@vger.kernel.org


The patch titled
     Subject: printk: rename DEFAULT_MESSAGE_LOGLEVEL
has been added to the -mm tree.  Its filename is
     printk-rename-default_message_loglevel.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/printk-rename-default_message_loglevel.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/printk-rename-default_message_loglevel.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alex Elder <elder@linaro.org>
Subject: printk: rename DEFAULT_MESSAGE_LOGLEVEL

a8fe19ebfbfd9 ("kernel/printk: use symbolic defines for console
loglevels") makes consistent use of symbolic values for printk() log
levels.

The naming scheme used is different from the one used for
DEFAULT_MESSAGE_LOGLEVEL though.  Change that symbol name to be
MESSAGE_LOGLEVEL_DEFAULT for consistency.  And because the value of that
symbol comes from a similarly-named config option, rename
CONFIG_DEFAULT_MESSAGE_LOGLEVEL as well.

Signed-off-by: Alex Elder <elder@linaro.org>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: Jan Kara <jack@suse.cz>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Petr Mladek <pmladek@suse.cz>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/printk.h |    2 +-
 kernel/printk/printk.c |    2 +-
 lib/Kconfig.debug      |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff -puN include/linux/printk.h~printk-rename-default_message_loglevel include/linux/printk.h
--- a/include/linux/printk.h~printk-rename-default_message_loglevel
+++ a/include/linux/printk.h
@@ -31,7 +31,7 @@ static inline const char *printk_skip_le
 }
 
 /* printk's without a loglevel use this.. */
-#define DEFAULT_MESSAGE_LOGLEVEL CONFIG_DEFAULT_MESSAGE_LOGLEVEL
+#define MESSAGE_LOGLEVEL_DEFAULT CONFIG_MESSAGE_LOGLEVEL_DEFAULT
 
 /* We show everything that is MORE important than this.. */
 #define CONSOLE_LOGLEVEL_SILENT  0 /* Mum's the word */
diff -puN kernel/printk/printk.c~printk-rename-default_message_loglevel kernel/printk/printk.c
--- a/kernel/printk/printk.c~printk-rename-default_message_loglevel
+++ a/kernel/printk/printk.c
@@ -56,7 +56,7 @@
 
 int console_printk[4] = {
 	CONSOLE_LOGLEVEL_DEFAULT,	/* console_loglevel */
-	DEFAULT_MESSAGE_LOGLEVEL,	/* default_message_loglevel */
+	MESSAGE_LOGLEVEL_DEFAULT,	/* default_message_loglevel */
 	CONSOLE_LOGLEVEL_MIN,		/* minimum_console_loglevel */
 	CONSOLE_LOGLEVEL_DEFAULT,	/* default_console_loglevel */
 };
diff -puN lib/Kconfig.debug~printk-rename-default_message_loglevel lib/Kconfig.debug
--- a/lib/Kconfig.debug~printk-rename-default_message_loglevel
+++ a/lib/Kconfig.debug
@@ -15,7 +15,7 @@ config PRINTK_TIME
 	  The behavior is also controlled by the kernel command line
 	  parameter printk.time=1. See Documentation/kernel-parameters.txt
 
-config DEFAULT_MESSAGE_LOGLEVEL
+config MESSAGE_LOGLEVEL_DEFAULT
 	int "Default message log level (1-7)"
 	range 1 7
 	default "4"
_

Patches currently in -mm which might be from elder@linaro.org are

printk-tweak-do_syslog-to-match-comments.patch
printk-rename-default_message_loglevel.patch
printk-fix-some-comments.patch
printk-use-a-clever-macro.patch
printk-miscellaneous-cleanups.patch
linux-next.patch

