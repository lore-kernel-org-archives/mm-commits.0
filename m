From: akpm@linux-foundation.org
Subject: + include-linux-printkh-move-console-functions-and-variables-together.patch added to -mm tree
Date: Tue, 07 Dec 2010 15:29:50 -0800
Message-ID: <201012072329.oB7NTov3014424@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53512 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751815Ab0LGXaF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Dec 2010 18:30:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, mingo@elte.hu, mpm@selenic.com


The patch titled
     include/linux/printk.h: move console functions and variables together
has been added to the -mm tree.  Its filename is
     include-linux-printkh-move-console-functions-and-variables-together.patch

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
Subject: include/linux/printk.h: move console functions and variables together
From: Joe Perches <joe@perches.com>

There are many uses of printk_once(KERN_<level>, so add pr_<level>_once
macros to avoid printk_once(KERN_<level> pr_fmt(fmt).

Add an #ifdef CONFIG_PRINTK for print_hex_dump and static inline void
functions for the #else cases to reduce embedded code size.  Neaten and
organize the rest of the code.


This patch:

Move console functions and variables together.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/printk.h |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff -puN include/linux/printk.h~include-linux-printkh-move-console-functions-and-variables-together include/linux/printk.h
--- a/include/linux/printk.h~include-linux-printkh-move-console-functions-and-variables-together
+++ a/include/linux/printk.h
@@ -29,6 +29,17 @@ extern int console_printk[];
 #define minimum_console_loglevel (console_printk[2])
 #define default_console_loglevel (console_printk[3])
 
+static inline void console_silent(void)
+{
+	console_loglevel = 0;
+}
+
+static inline void console_verbose(void)
+{
+	if (console_loglevel)
+		console_loglevel = 15;
+}
+
 struct va_format {
 	const char *fmt;
 	va_list *va;
@@ -130,17 +141,6 @@ extern void printk_tick(void);
 extern void asmlinkage __attribute__((format(printf, 1, 2)))
 	early_printk(const char *fmt, ...);
 
-static inline void console_silent(void)
-{
-	console_loglevel = 0;
-}
-
-static inline void console_verbose(void)
-{
-	if (console_loglevel)
-		console_loglevel = 15;
-}
