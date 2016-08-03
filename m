From: akpm@linux-foundation.org
Subject: [merged] printk-create-pr_level-functions.patch removed from -mm
 tree
Date: Wed, 03 Aug 2016 11:12:01 -0700
Message-ID: <57a233f1.rJMx8syAGI5kbN1e%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33352 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754059AbcHCSN2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Aug 2016 14:13:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: printk: create pr_<level> functions
has been removed from the -mm tree.  Its filename was
     printk-create-pr_level-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: printk: create pr_<level> functions

Using functions instead of macros can reduce overall code size by
eliminating unnecessary "KERN_SOH<digit>" prefixes from format strings.

defconfig x86-64:

$ size vmlinux*
   text    data     bss      dec     hex  filename
10193570 4331464 1105920 15630954  ee826a vmlinux.new
10192623 4335560 1105920 15634103  ee8eb7 vmlinux.old

As the return value are unimportant and unused in the kernel tree,
these new functions return void.

Miscellanea:

o change pr_<level> macros to call new __pr_<level> functions
o change vprintk_nmi and vprintk_default to add LOGLEVEL_<level> argument

[akpm@linux-foundation.org: fix LOGLEVEL_INFO, per Joe]
Link: http://lkml.kernel.org/r/e16cc34479dfefcae37c98b481e6646f0f69efc3.1466718827.git.joe@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/printk.h   |   48 +++++++++++++++++++++++++------------
 kernel/printk/internal.h |   16 +++++++-----
 kernel/printk/nmi.c      |   13 ++++++++--
 kernel/printk/printk.c   |   27 ++++++++++++++++++--
 4 files changed, 78 insertions(+), 26 deletions(-)

diff -puN include/linux/printk.h~printk-create-pr_level-functions include/linux/printk.h
--- a/include/linux/printk.h~printk-create-pr_level-functions
+++ a/include/linux/printk.h
@@ -257,21 +257,39 @@ extern asmlinkage void dump_stack(void)
  * and other debug macros are compiled out unless either DEBUG is defined
  * or CONFIG_DYNAMIC_DEBUG is set.
  */
-#define pr_emerg(fmt, ...) \
-	printk(KERN_EMERG pr_fmt(fmt), ##__VA_ARGS__)
-#define pr_alert(fmt, ...) \
-	printk(KERN_ALERT pr_fmt(fmt), ##__VA_ARGS__)
-#define pr_crit(fmt, ...) \
-	printk(KERN_CRIT pr_fmt(fmt), ##__VA_ARGS__)
-#define pr_err(fmt, ...) \
-	printk(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
-#define pr_warning(fmt, ...) \
-	printk(KERN_WARNING pr_fmt(fmt), ##__VA_ARGS__)
-#define pr_warn pr_warning
-#define pr_notice(fmt, ...) \
-	printk(KERN_NOTICE pr_fmt(fmt), ##__VA_ARGS__)
-#define pr_info(fmt, ...) \
-	printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
+
+#ifdef CONFIG_PRINTK
+
+asmlinkage __printf(1, 2) __cold void __pr_emerg(const char *fmt, ...);
+asmlinkage __printf(1, 2) __cold void __pr_alert(const char *fmt, ...);
+asmlinkage __printf(1, 2) __cold void __pr_crit(const char *fmt, ...);
+asmlinkage __printf(1, 2) __cold void __pr_err(const char *fmt, ...);
+asmlinkage __printf(1, 2) __cold void __pr_warn(const char *fmt, ...);
+asmlinkage __printf(1, 2) __cold void __pr_notice(const char *fmt, ...);
+asmlinkage __printf(1, 2) __cold void __pr_info(const char *fmt, ...);
+
+#define pr_emerg(fmt, ...)	__pr_emerg(pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_alert(fmt, ...)	__pr_alert(pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_crit(fmt, ...)	__pr_crit(pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_err(fmt, ...)	__pr_err(pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_warn(fmt, ...)	__pr_warn(pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_notice(fmt, ...)	__pr_notice(pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_info(fmt, ...)	__pr_info(pr_fmt(fmt), ##__VA_ARGS__)
+
+#else
+
+#define pr_emerg(fmt, ...)	printk(KERN_EMERG pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_alert(fmt, ...)	printk(KERN_ALERT pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_crit(fmt, ...)	printk(KERN_CRIT pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_err(fmt, ...)	printk(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_warn(fmt, ...)	printk(KERN_WARNING pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_notice(fmt, ...)	printk(KERN_NOTICE pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_info(fmt, ...)	printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
+
+#endif
+
+#define pr_warning pr_warn
+
 /*
  * Like KERN_CONT, pr_cont() should only be used when continuing
  * a line with no newline ('\n') enclosed. Otherwise it defaults
diff -puN kernel/printk/internal.h~printk-create-pr_level-functions kernel/printk/internal.h
--- a/kernel/printk/internal.h~printk-create-pr_level-functions
+++ a/kernel/printk/internal.h
@@ -16,9 +16,11 @@
  */
 #include <linux/percpu.h>
 
-typedef __printf(1, 0) int (*printk_func_t)(const char *fmt, va_list args);
+typedef __printf(2, 0) int (*printk_func_t)(int level, const char *fmt,
+					    va_list args);
 
-int __printf(1, 0) vprintk_default(const char *fmt, va_list args);
+__printf(2, 0)
+int vprintk_default(int level, const char *fmt, va_list args);
 
 #ifdef CONFIG_PRINTK_NMI
 
@@ -31,9 +33,10 @@ extern raw_spinlock_t logbuf_lock;
  * via per-CPU variable.
  */
 DECLARE_PER_CPU(printk_func_t, printk_func);
-static inline __printf(1, 0) int vprintk_func(const char *fmt, va_list args)
+__printf(2, 0)
+static inline int vprintk_func(int level, const char *fmt, va_list args)
 {
-	return this_cpu_read(printk_func)(fmt, args);
+	return this_cpu_read(printk_func)(level, fmt, args);
 }
 
 extern atomic_t nmi_message_lost;
@@ -44,9 +47,10 @@ static inline int get_nmi_message_lost(v
 
 #else /* CONFIG_PRINTK_NMI */
 
-static inline __printf(1, 0) int vprintk_func(const char *fmt, va_list args)
+__printf(2, 0)
+static inline int vprintk_func(int level, const char *fmt, va_list args)
 {
-	return vprintk_default(fmt, args);
+	return vprintk_default(level, fmt, args);
 }
 
 static inline int get_nmi_message_lost(void)
diff -puN kernel/printk/nmi.c~printk-create-pr_level-functions kernel/printk/nmi.c
--- a/kernel/printk/nmi.c~printk-create-pr_level-functions
+++ a/kernel/printk/nmi.c
@@ -58,7 +58,7 @@ static DEFINE_PER_CPU(struct nmi_seq_buf
  * one writer running. But the buffer might get flushed from another
  * CPU, so we need to be careful.
  */
-static int vprintk_nmi(const char *fmt, va_list args)
+static int vprintk_nmi(int level, const char *fmt, va_list args)
 {
 	struct nmi_seq_buf *s = this_cpu_ptr(&nmi_print_seq);
 	int add = 0;
@@ -79,7 +79,16 @@ again:
 	if (!len)
 		smp_rmb();
 
-	add = vsnprintf(s->buffer + len, sizeof(s->buffer) - len, fmt, args);
+	if (level != LOGLEVEL_DEFAULT) {
+		add = snprintf(s->buffer + len, sizeof(s->buffer) - len,
+				KERN_SOH "%c", '0' + level);
+		add += vsnprintf(s->buffer + len + add,
+				 sizeof(s->buffer) - len - add,
+				 fmt, args);
+	} else {
+		add = vsnprintf(s->buffer + len, sizeof(s->buffer) - len,
+				fmt, args);
+	}
 
 	/*
 	 * Do it once again if the buffer has been flushed in the meantime.
diff -puN kernel/printk/printk.c~printk-create-pr_level-functions kernel/printk/printk.c
--- a/kernel/printk/printk.c~printk-create-pr_level-functions
+++ a/kernel/printk/printk.c
@@ -1801,7 +1801,28 @@ asmlinkage int printk_emit(int facility,
 }
 EXPORT_SYMBOL(printk_emit);
 
-int vprintk_default(const char *fmt, va_list args)
+#ifdef CONFIG_PRINTK
+#define define_pr_level(func, loglevel)				\
+asmlinkage __visible void func(const char *fmt, ...)		\
+{								\
+	va_list args;						\
+								\
+	va_start(args, fmt);					\
+	vprintk_default(loglevel, fmt, args);			\
+	va_end(args);						\
+}								\
+EXPORT_SYMBOL(func)
+
+define_pr_level(__pr_emerg, LOGLEVEL_EMERG);
+define_pr_level(__pr_alert, LOGLEVEL_ALERT);
+define_pr_level(__pr_crit, LOGLEVEL_CRIT);
+define_pr_level(__pr_err, LOGLEVEL_ERR);
+define_pr_level(__pr_warn, LOGLEVEL_WARNING);
+define_pr_level(__pr_notice, LOGLEVEL_NOTICE);
+define_pr_level(__pr_info, LOGLEVEL_INFO);
+#endif
+
+int vprintk_default(int level, const char *fmt, va_list args)
 {
 	int r;
 
@@ -1811,7 +1832,7 @@ int vprintk_default(const char *fmt, va_
 		return r;
 	}
 #endif
-	r = vprintk_emit(0, LOGLEVEL_DEFAULT, NULL, 0, fmt, args);
+	r = vprintk_emit(0, level, NULL, 0, fmt, args);
 
 	return r;
 }
@@ -1844,7 +1865,7 @@ asmlinkage __visible int printk(const ch
 	int r;
 
 	va_start(args, fmt);
-	r = vprintk_func(fmt, args);
+	r = vprintk_func(LOGLEVEL_DEFAULT, fmt, args);
 	va_end(args);
 
 	return r;
_

Patches currently in -mm which might be from joe@perches.com are


