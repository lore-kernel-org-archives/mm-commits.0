From: akpm@linux-foundation.org
Subject: + include-linux-printkh-add-pr_level_once-macros.patch added to -mm tree
Date: Tue, 07 Dec 2010 15:29:57 -0800
Message-ID: <201012072329.oB7NTvm7014440@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47857 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752395Ab0LGXaF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Dec 2010 18:30:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, mingo@elte.hu, mpm@selenic.com


The patch titled
     include/linux/printk.h: add pr_<level>_once macros
has been added to the -mm tree.  Its filename is
     include-linux-printkh-add-pr_level_once-macros.patch

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
Subject: include/linux/printk.h: add pr_<level>_once macros
From: Joe Perches <joe@perches.com>

- Move printk_once definitions and add an #ifdef CONFIG_PRINTK

- Add pr_<level>_once so printks can use pr_fmt

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/printk.h |   59 +++++++++++++++++++++++++++++----------
 1 file changed, 44 insertions(+), 15 deletions(-)

diff -puN include/linux/printk.h~include-linux-printkh-add-pr_level_once-macros include/linux/printk.h
--- a/include/linux/printk.h~include-linux-printkh-add-pr_level_once-macros
+++ a/include/linux/printk.h
@@ -111,18 +111,6 @@ extern bool printk_timed_ratelimit(unsig
 extern int printk_delay_msec;
 extern int dmesg_restrict;
 
-/*
- * Print a one-time message (analogous to WARN_ONCE() et al):
- */
-#define printk_once(x...) ({			\
-	static bool __print_once;		\
-						\
-	if (!__print_once) {			\
-		__print_once = true;		\
-		printk(x);			\
-	}					\
-})
-
 void log_buf_kexec_setup(void);
 #else
 static inline __attribute__ ((format (printf, 1, 0)))
@@ -145,9 +133,6 @@ static inline bool printk_timed_ratelimi
 	return false;
 }
 
-/* No effect, but we still get type checking even in the !PRINTK case: */
-#define printk_once(fmt, ...) no_printk(fmt, ##__VA_ARGS__)
-
 static inline void log_buf_kexec_setup(void)
 {
 }
@@ -214,6 +199,50 @@ extern void print_hex_dump_bytes(const c
 #endif
 
 /*
+ * Print a one-time message (analogous to WARN_ONCE() et al):
+ */
+
+#ifdef CONFIG_PRINTK
+#define printk_once(fmt, ...)			\
+({						\
+	static bool __print_once;		\
+						\
+	if (!__print_once) {			\
+		__print_once = true;		\
+		printk(fmt, ##__VA_ARGS__);	\
+	}					\
+})
+#else
+#define printk_once(fmt, ...)			\
+	no_printk(fmt, ##__VA_ARGS__)
+#endif
+
+#define pr_emerg_once(fmt, ...)					\
+	printk_once(KERN_EMERG pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_alert_once(fmt, ...)					\
+	printk_once(KERN_ALERT pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_crit_once(fmt, ...)					\
+	printk_once(KERN_CRIT pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_err_once(fmt, ...)					\
+	printk_once(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_warn_once(fmt, ...)					\
+	printk_once(KERN_WARNING pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_notice_once(fmt, ...)				\
+	printk_once(KERN_NOTICE pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_info_once(fmt, ...)					\
+	printk_once(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_cont_once(fmt, ...)					\
+	printk_once(KERN_CONT pr_fmt(fmt), ##__VA_ARGS__)
+/* If you are writing a driver, please use dev_dbg instead */
+#if defined(DEBUG)
+#define pr_debug_once(fmt, ...)					\
+	printk_once(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
+#else
+#define pr_debug_once(fmt, ...)					\
+	no_printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
+#endif
+
+/*
  * ratelimited messages with local ratelimit_state,
  * no local ratelimit_state used in the !PRINTK case
  */
_

Patches currently in -mm which might be from joe@perches.com are

linux-next.patch
mm-convert-sprintf_symbol-to-%ps.patch
include-linux-printkh-move-console-functions-and-variables-together.patch
include-linux-printkh-use-space-after-define.patch
include-linux-printkh-use-and-neaten-no_printk.patch
include-linux-printkh-add-pr_level_once-macros.patch
include-linux-printkh-lib-hexdumpc-neatening-and-add-config_printk-guard.patch
include-linux-printkh-organize-printk_ratelimited-macros.patch
include-linux-printkh-use-tab-not-spaces-for-indent.patch
scripts-get_maintainerpl-make-rolestats-the-default.patch
scripts-get_maintainerpl-use-git-fallback-more-often.patch
scripts-checkpatchpl-add-check-for-multiple-terminating-semicolons-and-casts-of-vmalloc.patch
fs-proc-basec-kernel-latencytopc-convert-sprintf_symbol-to-%ps.patch
fs-proc-basec-kernel-latencytopc-convert-sprintf_symbol-to-%ps-checkpatch-fixes.patch

