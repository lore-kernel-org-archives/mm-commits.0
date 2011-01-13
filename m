From: akpm@linux-foundation.org
Subject: [merged] include-linux-printkh-add-pr_level_once-macros.patch removed from -mm tree
Date: Thu, 13 Jan 2011 12:04:35 -0800
Message-ID: <201101132007.p0DK7GEY029811@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37331 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933639Ab1AMUHx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 15:07:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mingo@elte.hu, mpm@selenic.com, mm-commits@vger.kernel.org


The patch titled
     include/linux/printk.h: add pr_<level>_once macros
has been removed from the -mm tree.  Its filename was
     include-linux-printkh-add-pr_level_once-macros.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -112,18 +112,6 @@ extern int printk_delay_msec;
 extern int dmesg_restrict;
 extern int kptr_restrict;
 
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
@@ -146,9 +134,6 @@ static inline bool printk_timed_ratelimi
 	return false;
 }
 
-/* No effect, but we still get type checking even in the !PRINTK case: */
-#define printk_once(fmt, ...) no_printk(fmt, ##__VA_ARGS__)
-
 static inline void log_buf_kexec_setup(void)
 {
 }
@@ -215,6 +200,50 @@ extern void print_hex_dump_bytes(const c
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

origin.patch
linux-next.patch
mm-convert-sprintf_symbol-to-%ps.patch

