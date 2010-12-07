From: akpm@linux-foundation.org
Subject: + include-linux-printkh-use-and-neaten-no_printk.patch added to -mm tree
Date: Tue, 07 Dec 2010 15:29:55 -0800
Message-ID: <201012072329.oB7NTtCp014437@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49615 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753577Ab0LGXaJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Dec 2010 18:30:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, mingo@elte.hu, mpm@selenic.com


The patch titled
     include/linux/printk.h: use and neaten no_printk
has been added to the -mm tree.  Its filename is
     include-linux-printkh-use-and-neaten-no_printk.patch

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
Subject: include/linux/printk.h: use and neaten no_printk
From: Joe Perches <joe@perches.com>

- Move no_printk above first CONFIG_PRINTK block so it can be used by
  printk_once.

- Convert statement expression if (0) printk macros to no_printk.

- Convert printk_once(x...) to more normally used (fmt, ...) fmt,
  ##__VA_ARGS__.

- Standardize __attribute__ use.

- Expand single line inline functions.

- Remove space before pointer.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/printk.h |   75 ++++++++++++++++++++++-----------------
 1 file changed, 43 insertions(+), 32 deletions(-)

diff -puN include/linux/printk.h~include-linux-printkh-use-and-neaten-no_printk include/linux/printk.h
--- a/include/linux/printk.h~include-linux-printkh-use-and-neaten-no_printk
+++ a/include/linux/printk.h
@@ -76,11 +76,27 @@ struct va_format {
  */
 #define HW_ERR		"[Hardware Error]: "
 
+/*
+ * Dummy printk for disabled debugging statements to use whilst maintaining
+ * gcc's format and side-effect checking.
+ */
+static inline __attribute__ ((format (printf, 1, 2)))
+int no_printk(const char *fmt, ...)
+{
+	return 0;
+}
+
+extern asmlinkage __attribute__ ((format (printf, 1, 2)))
+void early_printk(const char *fmt, ...);
+
+extern int printk_needs_cpu(int cpu);
+extern void printk_tick(void);
+
 #ifdef CONFIG_PRINTK
-asmlinkage int vprintk(const char *fmt, va_list args)
-	__attribute__ ((format (printf, 1, 0)));
-asmlinkage int printk(const char * fmt, ...)
-	__attribute__ ((format (printf, 1, 2))) __cold;
+asmlinkage __attribute__ ((format (printf, 1, 0)))
+int vprintk(const char *fmt, va_list args);
+asmlinkage __attribute__ ((format (printf, 1, 2))) __cold
+int printk(const char *fmt, ...);
 
 /*
  * Please don't use printk_ratelimit(), because it shares ratelimiting state
@@ -109,38 +125,34 @@ extern int dmesg_restrict;
 
 void log_buf_kexec_setup(void);
 #else
-static inline int vprintk(const char *s, va_list args)
-	__attribute__ ((format (printf, 1, 0)));
-static inline int vprintk(const char *s, va_list args) { return 0; }
-static inline int printk(const char *s, ...)
-	__attribute__ ((format (printf, 1, 2)));
-static inline int __cold printk(const char *s, ...) { return 0; }
-static inline int printk_ratelimit(void) { return 0; }
-static inline bool printk_timed_ratelimit(unsigned long *caller_jiffies, \
-					  unsigned int interval_msec)	\
-		{ return false; }
+static inline __attribute__ ((format (printf, 1, 0)))
+int vprintk(const char *s, va_list args)
+{
+	return 0;
+}
+static inline __attribute__ ((format (printf, 1, 2))) __cold
+int printk(const char *s, ...)
+{
+	return 0;
+}
+static inline int printk_ratelimit(void)
+{
+	return 0;
+}
+static inline bool printk_timed_ratelimit(unsigned long *caller_jiffies,
+					  unsigned int interval_msec)
+{
+	return false;
+}
 
 /* No effect, but we still get type checking even in the !PRINTK case: */
-#define printk_once(x...) printk(x)
+#define printk_once(fmt, ...) no_printk(fmt, ##__VA_ARGS__)
 
 static inline void log_buf_kexec_setup(void)
 {
 }
 #endif
 
-/*
- * Dummy printk for disabled debugging statements to use whilst maintaining
- * gcc's format and side-effect checking.
- */
-static inline __attribute__ ((format (printf, 1, 2)))
-int no_printk(const char *s, ...) { return 0; }
-
-extern int printk_needs_cpu(int cpu);
-extern void printk_tick(void);
-
-extern void asmlinkage __attribute__((format(printf, 1, 2)))
-	early_printk(const char *fmt, ...);
-
 extern void dump_stack(void) __cold;
 
 enum {
@@ -185,7 +197,7 @@ extern void print_hex_dump_bytes(const c
 	printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
 #else
 #define pr_devel(fmt, ...) \
-	({ if (0) printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__); 0; })
+	no_printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
 #endif
 
 /* If you are writing a driver, please use dev_dbg instead */
@@ -198,7 +210,7 @@ extern void print_hex_dump_bytes(const c
 	dynamic_pr_debug(fmt, ##__VA_ARGS__)
 #else
 #define pr_debug(fmt, ...) \
-	({ if (0) printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__); 0; })
+	no_printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
 #endif
 
 /*
@@ -241,8 +253,7 @@ extern void print_hex_dump_bytes(const c
 	printk_ratelimited(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
 #else
 #define pr_debug_ratelimited(fmt, ...) \
-	({ if (0) printk_ratelimited(KERN_DEBUG pr_fmt(fmt), \
-				     ##__VA_ARGS__); 0; })
+	no_printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
 #endif
 
 #endif
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

