From: akpm@linux-foundation.org
Subject: [to-be-updated] printk-move-braille-console-support-into-separate-braille-files.patch removed from -mm tree
Date: Tue, 23 Oct 2012 13:03:43 -0700
Message-ID: <20121023200344.0D86020004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ea0-f202.google.com ([209.85.215.202]:56760 "EHLO
	mail-ea0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933452Ab2JWUDq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 23 Oct 2012 16:03:46 -0400
Received: by mail-ea0-f202.google.com with SMTP id q10so255231eaa.1
        for <mm-commits@vger.kernel.org>; Tue, 23 Oct 2012 13:03:45 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, kay@vrfy.org, samuel.thibault@ens-lyon.org, mm-commits@vger.kernel.org


The patch titled
     Subject: printk: move braille console support into separate braille.[ch] files
has been removed from the -mm tree.  Its filename was
     printk-move-braille-console-support-into-separate-braille-files.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: printk: move braille console support into separate braille.[ch] files

Create files with prototypes and static inlines for braille
support.  Make braille_console functions return 1 on success.

Cc: Samuel Thibault <samuel.thibault@ens-lyon.org>
Signed-off-by: Joe Perches <joe@perches.com>
Cc: Kay Sievers <kay@vrfy.org>
Acked-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/accessibility/braille/braille_console.c |    9 ++
 kernel/printk/Makefile                          |    1 
 kernel/printk/braille.c                         |   48 ++++++++++++++
 kernel/printk/braille.h                         |   48 ++++++++++++++
 kernel/printk/printk.c                          |   44 +++---------
 5 files changed, 117 insertions(+), 33 deletions(-)

diff -puN drivers/accessibility/braille/braille_console.c~printk-move-braille-console-support-into-separate-braille-files drivers/accessibility/braille/braille_console.c
--- a/drivers/accessibility/braille/braille_console.c~printk-move-braille-console-support-into-separate-braille-files
+++ a/drivers/accessibility/braille/braille_console.c
@@ -359,6 +359,9 @@ int braille_register_console(struct cons
 		char *console_options, char *braille_options)
 {
 	int ret;
+
+	if (!(console->flags & CON_BRL))
+		return 0;
 	if (!console_options)
 		/* Only support VisioBraille for now */
 		console_options = "57600o8";
@@ -374,15 +377,17 @@ int braille_register_console(struct cons
 	braille_co = console;
 	register_keyboard_notifier(&keyboard_notifier_block);
 	register_vt_notifier(&vt_notifier_block);
-	return 0;
+	return 1;
 }
 
 int braille_unregister_console(struct console *console)
 {
 	if (braille_co != console)
 		return -EINVAL;
+	if (!(console->flags & CON_BRL))
+		return 0;
 	unregister_keyboard_notifier(&keyboard_notifier_block);
 	unregister_vt_notifier(&vt_notifier_block);
 	braille_co = NULL;
-	return 0;
+	return 1;
 }
diff -puN kernel/printk/Makefile~printk-move-braille-console-support-into-separate-braille-files kernel/printk/Makefile
--- a/kernel/printk/Makefile~printk-move-braille-console-support-into-separate-braille-files
+++ a/kernel/printk/Makefile
@@ -1 +1,2 @@
 obj-y	= printk.o
+obj-$(CONFIG_A11Y_BRAILLE_CONSOLE)	+= braille.o
diff -puN /dev/null kernel/printk/braille.c
--- /dev/null
+++ a/kernel/printk/braille.c
@@ -0,0 +1,48 @@
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/kernel.h>
+#include <linux/console.h>
+#include <linux/string.h>
+
+#include "console_cmdline.h"
+#include "braille.h"
+
+char *_braille_console_setup(char **str, char **brl_options)
+{
+	if (!memcmp(*str, "brl,", 4)) {
+		*brl_options = "";
+		*str += 4;
+	} else if (!memcmp(str, "brl=", 4)) {
+		*brl_options = *str + 4;
+		*str = strchr(*brl_options, ',');
+		if (!*str)
+			pr_err("need port name after brl=\n");
+		else
+			*((*str)++) = 0;
+	}
+
+	return *str;
+}
+
+int
+_braille_register_console(struct console *console, struct console_cmdline *c)
+{
+	int rtn = 0;
+
+	if (c->brl_options) {
+		console->flags |= CON_BRL;
+		rtn = braille_register_console(console, c->index, c->options,
+					       c->brl_options);
+	}
+
+	return rtn;
+}
+
+int
+_braille_unregister_console(struct console *console)
+{
+	if (console->flags & CON_BRL)
+		return braille_unregister_console(console);
+
+	return 0;
+}
diff -puN /dev/null kernel/printk/braille.h
--- /dev/null
+++ a/kernel/printk/braille.h
@@ -0,0 +1,48 @@
+#ifndef _PRINTK_BRAILLE_H
+#define _PRINTK_BRAILLE_H
+
+#ifdef CONFIG_A11Y_BRAILLE_CONSOLE
+
+static inline void
+braille_set_options(struct console_cmdline *c, char *brl_options)
+{
+	c->brl_options = brl_options;
+}
+
+char *
+_braille_console_setup(char **str, char **brl_options);
+
+int
+_braille_register_console(struct console *console, struct console_cmdline *c);
+
+int
+_braille_unregister_console(struct console *console);
+
+#else
+
+static inline void
+braille_set_options(struct console_cmdline *c, char *brl_options)
+{
+}
+
+static inline char *
+_braille_console_setup(char **str, char **brl_options)
+{
+	return *str;
+}
+
+static inline int
+_braille_register_console(struct console *console, struct console_cmdline *c)
+{
+	return 0;
+}
+
+static inline int
+_braille_unregister_console(struct console *console)
+{
+	return 0;
+}
+
+#endif
+
+#endif
diff -puN kernel/printk/printk.c~printk-move-braille-console-support-into-separate-braille-files kernel/printk/printk.c
--- a/kernel/printk/printk.c~printk-move-braille-console-support-into-separate-braille-files
+++ a/kernel/printk/printk.c
@@ -47,6 +47,7 @@
 #include <trace/events/printk.h>
 
 #include "console_cmdline.h"
+#include "braille.h"
 
 /*
  * Architectures can override it:
@@ -1731,9 +1732,8 @@ static int __add_preferred_console(char 
 	c = &console_cmdline[i];
 	strlcpy(c->name, name, sizeof(c->name));
 	c->options = options;
-#ifdef CONFIG_A11Y_BRAILLE_CONSOLE
-	c->brl_options = brl_options;
-#endif
+	braille_set_options(c, brl_options);
+
 	c->index = idx;
 	return 0;
 }
@@ -1746,20 +1746,8 @@ static int __init console_setup(char *st
 	char *s, *options, *brl_options = NULL;
 	int idx;
 
-#ifdef CONFIG_A11Y_BRAILLE_CONSOLE
-	if (!memcmp(str, "brl,", 4)) {
-		brl_options = "";
-		str += 4;
-	} else if (!memcmp(str, "brl=", 4)) {
-		brl_options = str + 4;
-		str = strchr(brl_options, ',');
-		if (!str) {
-			printk(KERN_ERR "need port name after brl=\n");
-			return 1;
-		}
-		*(str++) = 0;
-	}
-#endif
+	if (_braille_console_setup(&str, &brl_options))
+		return 1;
 
 	/*
 	 * Decode str into name, index, options.
@@ -2286,16 +2274,10 @@ void register_console(struct console *ne
 			continue;
 		if (newcon->index < 0)
 			newcon->index = console_cmdline[i].index;
-#ifdef CONFIG_A11Y_BRAILLE_CONSOLE
-		if (console_cmdline[i].brl_options) {
-			newcon->flags |= CON_BRL;
-			braille_register_console(newcon,
-					console_cmdline[i].index,
-					console_cmdline[i].options,
-					console_cmdline[i].brl_options);
+
+		if (_braille_register_console(newcon, &console_cmdline[i]))
 			return;
-		}
-#endif
+
 		if (newcon->setup &&
 		    newcon->setup(newcon, console_cmdline[i].options) != 0)
 			break;
@@ -2383,13 +2365,13 @@ EXPORT_SYMBOL(register_console);
 int unregister_console(struct console *console)
 {
         struct console *a, *b;
-	int res = 1;
+	int res;
 
-#ifdef CONFIG_A11Y_BRAILLE_CONSOLE
-	if (console->flags & CON_BRL)
-		return braille_unregister_console(console);
-#endif
+	res = _braille_unregister_console(console);
+	if (res)
+		return res;
 
+	res = 1;
 	console_lock();
 	if (console_drivers == console) {
 		console_drivers=console->next;
_

Patches currently in -mm which might be from joe@perches.com are

linux-next.patch
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

