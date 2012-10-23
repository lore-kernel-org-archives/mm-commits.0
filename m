From: akpm@linux-foundation.org
Subject: [to-be-updated] printk-use-pointer-for-console_cmdline-indexing.patch removed from -mm tree
Date: Tue, 23 Oct 2012 13:03:47 -0700
Message-ID: <20121023200347.9D0B3100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:42434 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933574Ab2JWUDt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 23 Oct 2012 16:03:49 -0400
Received: by mail-yh0-f74.google.com with SMTP id 10so532606yhl.1
        for <mm-commits@vger.kernel.org>; Tue, 23 Oct 2012 13:03:48 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, kay@vrfy.org, mm-commits@vger.kernel.org


The patch titled
     Subject: printk: use pointer for console_cmdline indexing
has been removed from the -mm tree.  Its filename was
     printk-use-pointer-for-console_cmdline-indexing.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: printk: use pointer for console_cmdline indexing

Make the code a bit more compact by always using a pointer
for the active console_cmdline.

Move overly indented code to correct indent level.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Kay Sievers <kay@vrfy.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk/printk.c |   49 ++++++++++++++++++++-------------------
 1 file changed, 26 insertions(+), 23 deletions(-)

diff -puN kernel/printk/printk.c~printk-use-pointer-for-console_cmdline-indexing kernel/printk/printk.c
--- a/kernel/printk/printk.c~printk-use-pointer-for-console_cmdline-indexing
+++ a/kernel/printk/printk.c
@@ -1718,18 +1718,19 @@ static int __add_preferred_console(char 
 	 *	See if this tty is not yet registered, and
 	 *	if we have a slot free.
 	 */
-	for (i = 0; i < MAX_CMDLINECONSOLES && console_cmdline[i].name[0]; i++)
-		if (strcmp(console_cmdline[i].name, name) == 0 &&
-			  console_cmdline[i].index == idx) {
-				if (!brl_options)
-					selected_console = i;
-				return 0;
+	for (i = 0, c = console_cmdline;
+	     i < MAX_CMDLINECONSOLES && c->name[0];
+	     i++, c++) {
+		if (strcmp(c->name, name) == 0 && c->index == idx) {
+			if (!brl_options)
+				selected_console = i;
+			return 0;
 		}
+	}
 	if (i == MAX_CMDLINECONSOLES)
 		return -E2BIG;
 	if (!brl_options)
 		selected_console = i;
-	c = &console_cmdline[i];
 	strlcpy(c->name, name, sizeof(c->name));
 	c->options = options;
 	braille_set_options(c, brl_options);
@@ -1802,15 +1803,15 @@ int update_console_cmdline(char *name, i
 	struct console_cmdline *c;
 	int i;
 
-	for (i = 0; i < MAX_CMDLINECONSOLES && console_cmdline[i].name[0]; i++)
-		if (strcmp(console_cmdline[i].name, name) == 0 &&
-			  console_cmdline[i].index == idx) {
-				c = &console_cmdline[i];
-				strlcpy(c->name, name_new, sizeof(c->name));
-				c->name[sizeof(c->name) - 1] = 0;
-				c->options = options;
-				c->index = idx_new;
-				return i;
+	for (i = 0, c = console_cmdline;
+	     i < MAX_CMDLINECONSOLES && c->name[0];
+	     i++, c++)
+		if (strcmp(c->name, name) == 0 && c->index == idx) {
+			strlcpy(c->name, name_new, sizeof(c->name));
+			c->name[sizeof(c->name) - 1] = 0;
+			c->options = options;
+			c->index = idx_new;
+			return i;
 		}
 	/* not found */
 	return -1;
@@ -2218,6 +2219,7 @@ void register_console(struct console *ne
 	int i;
 	unsigned long flags;
 	struct console *bcon = NULL;
+	struct console_cmdline *c;
 
 	/*
 	 * before we register a new CON_BOOT console, make sure we don't
@@ -2265,24 +2267,25 @@ void register_console(struct console *ne
 	 *	See if this console matches one we selected on
 	 *	the command line.
 	 */
-	for (i = 0; i < MAX_CMDLINECONSOLES && console_cmdline[i].name[0];
-			i++) {
-		if (strcmp(console_cmdline[i].name, newcon->name) != 0)
+	for (i = 0, c = console_cmdline;
+	     i < MAX_CMDLINECONSOLES && c->name[0];
+	     i++, c++) {
+		if (strcmp(c->name, newcon->name) != 0)
 			continue;
 		if (newcon->index >= 0 &&
-		    newcon->index != console_cmdline[i].index)
+		    newcon->index != c->index)
 			continue;
 		if (newcon->index < 0)
-			newcon->index = console_cmdline[i].index;
+			newcon->index = c->index;
 
-		if (_braille_register_console(newcon, &console_cmdline[i]))
+		if (_braille_register_console(newcon, c))
 			return;
 
 		if (newcon->setup &&
 		    newcon->setup(newcon, console_cmdline[i].options) != 0)
 			break;
 		newcon->flags |= CON_ENABLED;
-		newcon->index = console_cmdline[i].index;
+		newcon->index = c->index;
 		if (i == selected_console) {
 			newcon->flags |= CON_CONSDEV;
 			preferred_console = selected_console;
_

Patches currently in -mm which might be from joe@perches.com are

linux-next.patch
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

