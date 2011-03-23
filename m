From: akpm@linux-foundation.org
Subject: [merged] printk-allow-setting-default_message_level-via-kconfig.patch removed from -mm tree
Date: Wed, 23 Mar 2011 13:39:31 -0700
Message-ID: <201103232043.p2NKh7wH028834@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33793 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933349Ab1CWUzl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 16:55:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: msb@chromium.org, joe@perches.com, mingo@elte.hu, olofj@chromium.org, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     printk: allow setting DEFAULT_MESSAGE_LEVEL via Kconfig
has been removed from the -mm tree.  Its filename was
     printk-allow-setting-default_message_level-via-kconfig.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk.c   |    2 +-
 lib/Kconfig.debug |   11 +++++++++++
 2 files changed, 12 insertions(+), 1 deletion(-)

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
@@ -9,6 +9,17 @@ config PRINTK_TIME
 	  operations.  This is useful for identifying long delays
 	  in kernel startup.
 
+config DEFAULT_MESSAGE_LOGLEVEL
+	int "Default message log level (1-7)"
+	range 1 7
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

origin.patch
taskstats-use-appropriate-printk-priority-level.patch

