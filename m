From: akpm@linux-foundation.org
Subject: +
 printk-move-braille-console-support-into-separate-braille-files.patch added to -mm tree
Date: Wed, 17 Jul 2013 15:29:15 -0700
Message-ID: <51e71abb.XtCAYR2RcWCvyNTQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52464 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755995Ab3GQW3Q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 17 Jul 2013 18:29:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, samuel.thibault@ens-lyon.org, ming.lei@canonical.com, joe@perches.com

Subject: + printk-move-braille-console-support-into-separate-braille-files.patch added to -mm tree
To: joe@perches.com,ming.lei@canonical.com,samuel.thibault@ens-lyon.org
From: akpm@linux-foundation.org
Date: Wed, 17 Jul 2013 15:29:15 -0700


The patch titled
     Subject: printk: move braille console support into separate braille.[ch] files
has been added to the -mm tree.  Its filename is
     printk-move-braille-console-support-into-separate-braille-files.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/printk-move-braille-console-support-into-separate-braille-files.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/printk-move-braille-console-support-into-separate-braille-files.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: printk: move braille console support into separate braille.[ch] files

Create files with prototypes and static inlines for braille support.  Make
braille_console functions return 1 on success.

Corrected CONFIG_A11Y_BRAILLE_CONSOLE=n _braille_console_setup
return value to NULL.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Samuel Thibault <samuel.thibault@ens-lyon.org>
Cc: Ming Lei <ming.lei@canonical.com>
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
+	return NULL;
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
@@ -50,6 +50,7 @@
 #include <trace/events/printk.h>
 
 #include "console_cmdline.h"
+#include "braille.h"
 
 /* printk's without a loglevel use this.. */
 #define DEFAULT_MESSAGE_LOGLEVEL CONFIG_DEFAULT_MESSAGE_LOGLEVEL
@@ -1768,9 +1769,8 @@ static int __add_preferred_console(char
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
@@ -1783,20 +1783,8 @@ static int __init console_setup(char *st
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
@@ -2290,16 +2278,10 @@ void register_console(struct console *ne
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
@@ -2387,13 +2369,13 @@ EXPORT_SYMBOL(register_console);
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
maintainers-dynamic-debug-jasons-not-there.patch
printk-move-to-separate-directory-for-easier-modification.patch
printk-add-console_cmdlineh.patch
printk-move-braille-console-support-into-separate-braille-files.patch
printk-use-pointer-for-console_cmdline-indexing.patch
printk-rename-struct-log-to-struct-printk_log.patch
firmware-dmi_scan-drop-obsolete-comment.patch
firmware-dmi_scan-fix-most-checkpatch-errors-and-warnings.patch
firmware-dmi_scan-constify-strings.patch
firmware-dmi_scan-drop-oom-messages.patch

