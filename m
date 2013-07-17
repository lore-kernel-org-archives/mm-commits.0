From: akpm@linux-foundation.org
Subject: + printk-use-pointer-for-console_cmdline-indexing.patch added to
 -mm tree
Date: Wed, 17 Jul 2013 15:29:17 -0700
Message-ID: <51e71abd.fWu7ki29Klq2z/HK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52468 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756256Ab3GQW3S (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 17 Jul 2013 18:29:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, samuel.thibault@ens-lyon.org, ming.lei@canonical.com, joe@perches.com

Subject: + printk-use-pointer-for-console_cmdline-indexing.patch added to -mm tree
To: joe@perches.com,ming.lei@canonical.com,samuel.thibault@ens-lyon.org
From: akpm@linux-foundation.org
Date: Wed, 17 Jul 2013 15:29:17 -0700


The patch titled
     Subject: printk: use pointer for console_cmdline indexing
has been added to the -mm tree.  Its filename is
     printk-use-pointer-for-console_cmdline-indexing.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/printk-use-pointer-for-console_cmdline-indexing.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/printk-use-pointer-for-console_cmdline-indexing.patch

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
Subject: printk: use pointer for console_cmdline indexing

Make the code a bit more compact by always using a pointer for the active
console_cmdline.

Move overly indented code to correct indent level.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Samuel Thibault <samuel.thibault@ens-lyon.org>
Cc: Ming Lei <ming.lei@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk/printk.c |   49 ++++++++++++++++++++-------------------
 1 file changed, 26 insertions(+), 23 deletions(-)

diff -puN kernel/printk/printk.c~printk-use-pointer-for-console_cmdline-indexing kernel/printk/printk.c
--- a/kernel/printk/printk.c~printk-use-pointer-for-console_cmdline-indexing
+++ a/kernel/printk/printk.c
@@ -1755,18 +1755,19 @@ static int __add_preferred_console(char
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
@@ -1839,15 +1840,15 @@ int update_console_cmdline(char *name, i
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
@@ -2222,6 +2223,7 @@ void register_console(struct console *ne
 	int i;
 	unsigned long flags;
 	struct console *bcon = NULL;
+	struct console_cmdline *c;
 
 	/*
 	 * before we register a new CON_BOOT console, make sure we don't
@@ -2269,24 +2271,25 @@ void register_console(struct console *ne
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

