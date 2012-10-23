From: akpm@linux-foundation.org
Subject: [to-be-updated] printk-add-console_cmdlineh.patch removed from -mm tree
Date: Tue, 23 Oct 2012 13:03:40 -0700
Message-ID: <20121023200340.916A4100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:41664 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933477Ab2JWUDm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 23 Oct 2012 16:03:42 -0400
Received: by mail-gg0-f202.google.com with SMTP id i4so529720ggm.1
        for <mm-commits@vger.kernel.org>; Tue, 23 Oct 2012 13:03:41 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, kay@vrfy.org, mm-commits@vger.kernel.org


The patch titled
     Subject: printk: add console_cmdline.h
has been removed from the -mm tree.  Its filename was
     printk-add-console_cmdlineh.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: printk: add console_cmdline.h

Add an include file for the console_cmdline struct
so that the braille console driver can be separated.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Kay Sievers <kay@vrfy.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk/console_cmdline.h |   14 ++++++++++++++
 kernel/printk/printk.c          |   13 ++++---------
 2 files changed, 18 insertions(+), 9 deletions(-)

diff -puN /dev/null kernel/printk/console_cmdline.h
--- /dev/null
+++ a/kernel/printk/console_cmdline.h
@@ -0,0 +1,14 @@
+#ifndef _CONSOLE_CMDLINE_H
+#define _CONSOLE_CMDLINE_H
+
+struct console_cmdline
+{
+	char	name[8];			/* Name of the driver	    */
+	int	index;				/* Minor dev. to use	    */
+	char	*options;			/* Options for the driver   */
+#ifdef CONFIG_A11Y_BRAILLE_CONSOLE
+	char	*brl_options;			/* Options for braille driver */
+#endif
+};
+
+#endif
diff -puN kernel/printk/printk.c~printk-add-console_cmdlineh kernel/printk/printk.c
--- a/kernel/printk/printk.c~printk-add-console_cmdlineh
+++ a/kernel/printk/printk.c
@@ -46,6 +46,8 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/printk.h>
 
+#include "console_cmdline.h"
+
 /*
  * Architectures can override it:
  */
@@ -100,22 +102,15 @@ static int console_locked, console_suspe
  */
 static struct console *exclusive_console;
 
+
 /*
  *	Array of consoles built from command line options (console=)
  */
-struct console_cmdline
-{
-	char	name[8];			/* Name of the driver	    */
-	int	index;				/* Minor dev. to use	    */
-	char	*options;			/* Options for the driver   */
-#ifdef CONFIG_A11Y_BRAILLE_CONSOLE
-	char	*brl_options;			/* Options for braille driver */
-#endif
-};
 
 #define MAX_CMDLINECONSOLES 8
 
 static struct console_cmdline console_cmdline[MAX_CMDLINECONSOLES];
+
 static int selected_console = -1;
 static int preferred_console = -1;
 int console_set_on_cmdline;
_

Patches currently in -mm which might be from joe@perches.com are

linux-next.patch
printk-move-braille-console-support-into-separate-braille-files.patch
printk-use-pointer-for-console_cmdline-indexing.patch
printk-rename-struct-log-to-struct-printk_log.patch
printk-rename-log_buf-and-__log_buf_len.patch
printk-rename-log_first-and-log_next-variables.patch
printk-rename-log_foo-variables-and-functions.patch
printk-rename-enum-log_flags-to-printk_log_flags.patch
printk-rename-log_wait-to-printk_log_wait.patch
printk-rename-logbuf_lock-to-printk_logbuf_lock.patch
printk-rename-clear_seq-and-clear_idx-variables.patch
printk-remove-static-from-printk_-variables.patch
printk-rename-log_align-to-printk_log_align.patch
printk-add-and-use-printk_logh.patch
printk-add-printk_logc.patch
printk-make-wait_queue_head_t-printk_log_wait-extern.patch
printk-rename-and-move-2-defines-to-printk_logh.patch
printk-move-devkmsg-bits-to-separate-file.patch
printk-prefix-print_time-and-msg_print_text-with-printk_.patch
printk-move-functions-printk_print_time-and-printk_msg_print_text.patch
printk-add-printk_syslogc-and-h.patch
printk-add-printk_syslogc-and-h-fix.patch
printk-move-kmsg_dump-functions-to-separate-file.patch
maintainers-networking-drivers-matches-too-much.patch
checkpatch-improve-network-block-comment-style-checking.patch
kstrto-add-documentation.patch
simple_strto-annotate-function-as-obsolete.patch

