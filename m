From: akpm@linux-foundation.org
Subject: + printk-add-console_cmdlineh.patch added to -mm tree
Date: Wed, 17 Jul 2013 15:29:14 -0700
Message-ID: <51e71aba.yh6EfcDGK1griIBQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52460 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755796Ab3GQW3P (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 17 Jul 2013 18:29:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, samuel.thibault@ens-lyon.org, ming.lei@canonical.com, joe@perches.com

Subject: + printk-add-console_cmdlineh.patch added to -mm tree
To: joe@perches.com,ming.lei@canonical.com,samuel.thibault@ens-lyon.org
From: akpm@linux-foundation.org
Date: Wed, 17 Jul 2013 15:29:14 -0700


The patch titled
     Subject: printk: add console_cmdline.h
has been added to the -mm tree.  Its filename is
     printk-add-console_cmdlineh.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/printk-add-console_cmdlineh.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/printk-add-console_cmdlineh.patch

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
Subject: printk: add console_cmdline.h

Add an include file for the console_cmdline struct so that the braille
console driver can be separated.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Samuel Thibault <samuel.thibault@ens-lyon.org>
Cc: Ming Lei <ming.lei@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk/console_cmdline.h |   14 ++++++++++++++
 kernel/printk/printk.c          |   12 +++---------
 2 files changed, 17 insertions(+), 9 deletions(-)

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
@@ -49,6 +49,8 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/printk.h>
 
+#include "console_cmdline.h"
+
 /* printk's without a loglevel use this.. */
 #define DEFAULT_MESSAGE_LOGLEVEL CONFIG_DEFAULT_MESSAGE_LOGLEVEL
 
@@ -103,19 +105,11 @@ static struct console *exclusive_console
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

