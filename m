From: akpm@linux-foundation.org
Subject: + printk-allow-setting-default_message_level-via-kconfig.patch added to -mm tree
Date: Wed, 26 Jan 2011 14:50:25 -0800
Message-ID: <201101262250.p0QMoPad009332@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41258 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754092Ab1AZWvF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Jan 2011 17:51:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: msb@chromium.org, joe@perches.com, mingo@elte.hu, olofj@chromium.org


The patch titled
     printk: allow setting DEFAULT_MESSAGE_LEVEL via Kconfig
has been added to the -mm tree.  Its filename is
     printk-allow-setting-default_message_level-via-kconfig.patch

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
Subject: printk: allow setting DEFAULT_MESSAGE_LEVEL via Kconfig
From: Mandeep Singh Baines <msb@chromium.org>

We've been burned by regressions/bugs which we later realized could have
been triaged quicker if only we'd paid closer attention to dmesg.  To make
it easier to audit dmesg, we'd like to make DEFAULT_MESSAGE_LEVEL
Kconfig-settable.  That way we can set it to KERN_NOTICE and audit any
messages <= KERN_WARNING.

Signed-off-by: Mandeep Singh Baines <msb@chromium.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Joe Perches <joe@perches.com>
Cc: Olof Johansson <olofj@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk.c   |    2 +-
 lib/Kconfig.debug |   12 ++++++++++++
 2 files changed, 13 insertions(+), 1 deletion(-)

diff -puN kernel/printk.c~printk-allow-setting-default_message_level-via-kconfig kernel/printk.c
--- a/kernel/printk.c~printk-allow-setting-default_message_level-via-kconfig
+++ a/kernel/printk.c
@@ -53,7 +53,7 @@ void asmlinkage __attribute__((weak)) ea
 #define __LOG_BUF_LEN	(1 << CONFIG_LOG_BUF_SHIFT)
 
 /* printk's without a loglevel use this.. */
-#define DEFAULT_MESSAGE_LOGLEVEL 4 /* KERN_WARNING */
+#define DEFAULT_MESSAGE_LOGLEVEL CONFIG_DEFAULT_MESSAGE_LOGLEVEL
 
 /* We show everything that is MORE important than this.. */
 #define MINIMUM_CONSOLE_LOGLEVEL 1 /* Minimum loglevel we let people use */
diff -puN lib/Kconfig.debug~printk-allow-setting-default_message_level-via-kconfig lib/Kconfig.debug
--- a/lib/Kconfig.debug~printk-allow-setting-default_message_level-via-kconfig
+++ a/lib/Kconfig.debug
@@ -9,6 +9,18 @@ config PRINTK_TIME
 	  operations.  This is useful for identifying long delays
 	  in kernel startup.
 
+config DEFAULT_MESSAGE_LOGLEVEL
+	int "Default message log level (1-7)"
+	range 1 7
+	depends on PRINTK
+	default "4"
+	help
+	  Default log level for printk statements with no specified priority.
+
+	  This was hard-coded to KERN_WARNING since at least 2.6.10 but folks
+	  that are auditing their logs closely may want to set it to a lower
+	  priority.
+
 config ENABLE_WARN_DEPRECATED
 	bool "Enable __deprecated logic"
 	default y
_

Patches currently in -mm which might be from msb@chromium.org are

printk-allow-setting-default_message_level-via-kconfig.patch

