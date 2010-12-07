From: akpm@linux-foundation.org
Subject: + include-linux-printkh-organize-printk_ratelimited-macros.patch added to -mm tree
Date: Tue, 07 Dec 2010 15:30:01 -0800
Message-ID: <201012072330.oB7NU1mG014455@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41822 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753674Ab0LGXaJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Dec 2010 18:30:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, mingo@elte.hu, mpm@selenic.com


The patch titled
     include/linux/printk.h: organize printk_ratelimited macros
has been added to the -mm tree.  Its filename is
     include-linux-printkh-organize-printk_ratelimited-macros.patch

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
Subject: include/linux/printk.h: organize printk_ratelimited macros
From: Joe Perches <joe@perches.com>

- Use no_printk for !CONFIG_PRINTK printk_ratelimited.

- Whitespace cleanup.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/printk.h |   25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff -puN include/linux/printk.h~include-linux-printkh-organize-printk_ratelimited-macros include/linux/printk.h
--- a/include/linux/printk.h~include-linux-printkh-organize-printk_ratelimited-macros
+++ a/include/linux/printk.h
@@ -233,7 +233,8 @@ extern void dump_stack(void) __cold;
  * no local ratelimit_state used in the !PRINTK case
  */
 #ifdef CONFIG_PRINTK
-#define printk_ratelimited(fmt, ...)  ({				\
+#define printk_ratelimited(fmt, ...)					\
+({									\
 	static DEFINE_RATELIMIT_STATE(_rs,				\
 				      DEFAULT_RATELIMIT_INTERVAL,	\
 				      DEFAULT_RATELIMIT_BURST);		\
@@ -242,36 +243,34 @@ extern void dump_stack(void) __cold;
 		printk(fmt, ##__VA_ARGS__);				\
 })
 #else
-/* No effect, but we still get type checking even in the !PRINTK case: */
-#define printk_ratelimited printk
+#define printk_ratelimited(fmt, ...)					\
+	no_printk(fmt, ##__VA_ARGS__)
 #endif
 
-#define pr_emerg_ratelimited(fmt, ...) \
+#define pr_emerg_ratelimited(fmt, ...)					\
 	printk_ratelimited(KERN_EMERG pr_fmt(fmt), ##__VA_ARGS__)
-#define pr_alert_ratelimited(fmt, ...) \
+#define pr_alert_ratelimited(fmt, ...)					\
 	printk_ratelimited(KERN_ALERT pr_fmt(fmt), ##__VA_ARGS__)
-#define pr_crit_ratelimited(fmt, ...) \
+#define pr_crit_ratelimited(fmt, ...)					\
 	printk_ratelimited(KERN_CRIT pr_fmt(fmt), ##__VA_ARGS__)
-#define pr_err_ratelimited(fmt, ...) \
+#define pr_err_ratelimited(fmt, ...)					\
 	printk_ratelimited(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
-#define pr_warning_ratelimited(fmt, ...) \
+#define pr_warn_ratelimited(fmt, ...)					\
 	printk_ratelimited(KERN_WARNING pr_fmt(fmt), ##__VA_ARGS__)
-#define pr_warn_ratelimited pr_warning_ratelimited
-#define pr_notice_ratelimited(fmt, ...) \
+#define pr_notice_ratelimited(fmt, ...)					\
 	printk_ratelimited(KERN_NOTICE pr_fmt(fmt), ##__VA_ARGS__)
-#define pr_info_ratelimited(fmt, ...) \
+#define pr_info_ratelimited(fmt, ...)					\
 	printk_ratelimited(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
 /* no pr_cont_ratelimited, don't do that... */
 /* If you are writing a driver, please use dev_dbg instead */
 #if defined(DEBUG)
-#define pr_debug_ratelimited(fmt, ...) \
+#define pr_debug_ratelimited(fmt, ...)					\
 	printk_ratelimited(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
 #else
 #define pr_debug_ratelimited(fmt, ...) \
 	no_printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
 #endif
 
