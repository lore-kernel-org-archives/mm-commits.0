From: akpm@linux-foundation.org
Subject: [merged] include-linux-printkh-use-and-neaten-no_printk.patch removed from -mm tree
Date: Thu, 13 Jan 2011 12:04:26 -0800
Message-ID: <201101132007.p0DK77oT029806@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54296 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933703Ab1AMUOn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 15:14:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mingo@elte.hu, mpm@selenic.com, mm-commits@vger.kernel.org


The patch titled
     include/linux/printk.h: use and neaten no_printk
has been removed from the -mm tree.  Its filename was
     include-linux-printkh-use-and-neaten-no_printk.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -110,38 +126,34 @@ extern int kptr_restrict;
 
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
@@ -186,7 +198,7 @@ extern void print_hex_dump_bytes(const c
 	printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
 #else
 #define pr_devel(fmt, ...) \
-	({ if (0) printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__); 0; })
+	no_printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
 #endif
 
 /* If you are writing a driver, please use dev_dbg instead */
@@ -199,7 +211,7 @@ extern void print_hex_dump_bytes(const c
 	dynamic_pr_debug(fmt, ##__VA_ARGS__)
 #else
 #define pr_debug(fmt, ...) \
-	({ if (0) printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__); 0; })
+	no_printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
 #endif
 
 /*
@@ -242,8 +254,7 @@ extern void print_hex_dump_bytes(const c
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

origin.patch
linux-next.patch
mm-convert-sprintf_symbol-to-%ps.patch

