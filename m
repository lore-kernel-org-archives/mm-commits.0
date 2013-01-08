From: akpm@linux-foundation.org
Subject: + jiffies-conversions-use-compile-time-constants-when-possible.patch added to -mm tree
Date: Mon, 07 Jan 2013 16:37:29 -0800
Message-ID: <20130108003729.9F069820271@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f201.google.com ([209.85.161.201]:49526 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754628Ab3AHAha (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Jan 2013 19:37:30 -0500
Received: by mail-gg0-f201.google.com with SMTP id o6so2159741ggm.0
        for <mm-commits@vger.kernel.org>; Mon, 07 Jan 2013 16:37:30 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, koverstreet@google.com, tglx@linutronix.de


The patch titled
     Subject: jiffies conversions: Use compile time constants when possible
has been added to the -mm tree.  Its filename is
     jiffies-conversions-use-compile-time-constants-when-possible.patch

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
Subject: jiffies conversions: Use compile time constants when possible

Do the multiplications and divisions at compile time instead of runtime
when the converted value is a constant.

Make the calculation functions static __always_inline to jiffies.h.

Add #defines with __builtin_constant_p to test and use the static inline
or the runtime functions as appropriate.

Prefix the old exported symbols/functions with __

(akpm: shaves 100 bytes from my allnoconfig vmlinux .text)

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Kent Overstreet <koverstreet@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/jiffies.h |  136 ++++++++++++++++++++++++++++++++++++--
 kernel/time.c           |  106 +++--------------------------
 2 files changed, 144 insertions(+), 98 deletions(-)

diff -puN include/linux/jiffies.h~jiffies-conversions-use-compile-time-constants-when-possible include/linux/jiffies.h
--- a/include/linux/jiffies.h~jiffies-conversions-use-compile-time-constants-when-possible
+++ a/include/linux/jiffies.h
@@ -289,10 +289,138 @@ extern unsigned long preset_lpj;
 /*
  * Convert various time units to each other:
  */
-extern unsigned int jiffies_to_msecs(const unsigned long j);
-extern unsigned int jiffies_to_usecs(const unsigned long j);
-extern unsigned long msecs_to_jiffies(const unsigned int m);
-extern unsigned long usecs_to_jiffies(const unsigned int u);
+
+/*
+ * Avoid unnecessary multiplications/divisions in the
+ * two most common HZ cases:
+ */
+static __always_inline unsigned int
+__inline_jiffies_to_msecs(const unsigned long j)
+{
+#if HZ <= MSEC_PER_SEC && !(MSEC_PER_SEC % HZ)
+	return (MSEC_PER_SEC / HZ) * j;
+#elif HZ > MSEC_PER_SEC && !(HZ % MSEC_PER_SEC)
+	return (j + (HZ / MSEC_PER_SEC) - 1)/(HZ / MSEC_PER_SEC);
+#else
+# if BITS_PER_LONG == 32
+	return (HZ_TO_MSEC_MUL32 * j) >> HZ_TO_MSEC_SHR32;
+# else
+	return (j * HZ_TO_MSEC_NUM) / HZ_TO_MSEC_DEN;
+# endif
+#endif
+}
+extern unsigned int __jiffies_to_msecs(const unsigned long j);
+
+#define jiffies_to_msecs(x)			\
+	(__builtin_constant_p(x) ?		\
+	 __inline_jiffies_to_msecs(x) :		\
+	 __jiffies_to_msecs(x))
+
+static __always_inline unsigned int
+__inline_jiffies_to_usecs(const unsigned long j)
+{
+#if HZ <= USEC_PER_SEC && !(USEC_PER_SEC % HZ)
+	return (USEC_PER_SEC / HZ) * j;
+#elif HZ > USEC_PER_SEC && !(HZ % USEC_PER_SEC)
+	return (j + (HZ / USEC_PER_SEC) - 1)/(HZ / USEC_PER_SEC);
+#else
+# if BITS_PER_LONG == 32
+	return (HZ_TO_USEC_MUL32 * j) >> HZ_TO_USEC_SHR32;
+# else
+	return (j * HZ_TO_USEC_NUM) / HZ_TO_USEC_DEN;
+# endif
+#endif
+}
+extern unsigned int __jiffies_to_usecs(const unsigned long j);
+
+#define jiffies_to_usecs(x)			\
+	(__builtin_constant_p(x) ?		\
+	 __inline_jiffies_to_usecs(x) :		\
+	 __jiffies_to_usecs(x))
+
+/*
+ * When we convert to jiffies then we interpret incoming values
+ * the following way:
+ *
+ * - negative values mean 'infinite timeout' (MAX_JIFFY_OFFSET)
+ *
+ * - 'too large' values [that would result in larger than
+ *   MAX_JIFFY_OFFSET values] mean 'infinite timeout' too.
+ *
+ * - all other values are converted to jiffies by either multiplying
+ *   the input value by a factor or dividing it with a factor
+ *
+ * We must also be careful about 32-bit overflows.
+ */
+static __always_inline unsigned long
+__inline_msecs_to_jiffies(const unsigned int m)
+{
+	/*
+	 * Negative value, means infinite timeout:
+	 */
+	if ((int)m < 0)
+		return MAX_JIFFY_OFFSET;
+
+#if HZ <= MSEC_PER_SEC && !(MSEC_PER_SEC % HZ)
+	/*
+	 * HZ is equal to or smaller than 1000, and 1000 is a nice
+	 * round multiple of HZ, divide with the factor between them,
+	 * but round upwards:
+	 */
+	return (m + (MSEC_PER_SEC / HZ) - 1) / (MSEC_PER_SEC / HZ);
+#elif HZ > MSEC_PER_SEC && !(HZ % MSEC_PER_SEC)
+	/*
+	 * HZ is larger than 1000, and HZ is a nice round multiple of
+	 * 1000 - simply multiply with the factor between them.
+	 *
+	 * But first make sure the multiplication result cannot
+	 * overflow:
+	 */
+	if (m > jiffies_to_msecs(MAX_JIFFY_OFFSET))
+		return MAX_JIFFY_OFFSET;
+
+	return m * (HZ / MSEC_PER_SEC);
+#else
+	/*
+	 * Generic case - multiply, round and divide. But first
+	 * check that if we are doing a net multiplication, that
+	 * we wouldn't overflow:
+	 */
+	if (HZ > MSEC_PER_SEC && m > jiffies_to_msecs(MAX_JIFFY_OFFSET))
+		return MAX_JIFFY_OFFSET;
+
+	return (MSEC_TO_HZ_MUL32 * m + MSEC_TO_HZ_ADJ32)
+		>> MSEC_TO_HZ_SHR32;
+#endif
+}
+extern unsigned long __msecs_to_jiffies(const unsigned int m);
+
+#define msecs_to_jiffies(x)			\
+	(__builtin_constant_p(x) ?		\
+	 __inline_msecs_to_jiffies(x) :		\
+	 __msecs_to_jiffies(x))
+
+static __always_inline unsigned long
+__inline_usecs_to_jiffies(const unsigned int u)
+{
+	if (u > jiffies_to_usecs(MAX_JIFFY_OFFSET))
+		return MAX_JIFFY_OFFSET;
+#if HZ <= USEC_PER_SEC && !(USEC_PER_SEC % HZ)
+	return (u + (USEC_PER_SEC / HZ) - 1) / (USEC_PER_SEC / HZ);
+#elif HZ > USEC_PER_SEC && !(HZ % USEC_PER_SEC)
+	return u * (HZ / USEC_PER_SEC);
+#else
+	return (USEC_TO_HZ_MUL32 * u + USEC_TO_HZ_ADJ32)
+		>> USEC_TO_HZ_SHR32;
+#endif
+}
+extern unsigned long __usecs_to_jiffies(const unsigned int u);
+
+#define usecs_to_jiffies(x)			\
+	(__builtin_constant_p(x) ?		\
+	 __inline_usecs_to_jiffies(x) :		\
+	 __usecs_to_jiffies(x))
+
 extern unsigned long timespec_to_jiffies(const struct timespec *value);
 extern void jiffies_to_timespec(const unsigned long jiffies,
 				struct timespec *value);
diff -puN kernel/time.c~jiffies-conversions-use-compile-time-constants-when-possible kernel/time.c
--- a/kernel/time.c~jiffies-conversions-use-compile-time-constants-when-possible
+++ a/kernel/time.c
@@ -228,41 +228,18 @@ EXPORT_SYMBOL(current_fs_time);
 
 /*
  * Convert jiffies to milliseconds and back.
- *
- * Avoid unnecessary multiplications/divisions in the
- * two most common HZ cases:
  */
-inline unsigned int jiffies_to_msecs(const unsigned long j)
+unsigned int __jiffies_to_msecs(const unsigned long j)
 {
-#if HZ <= MSEC_PER_SEC && !(MSEC_PER_SEC % HZ)
-	return (MSEC_PER_SEC / HZ) * j;
-#elif HZ > MSEC_PER_SEC && !(HZ % MSEC_PER_SEC)
-	return (j + (HZ / MSEC_PER_SEC) - 1)/(HZ / MSEC_PER_SEC);
-#else
-# if BITS_PER_LONG == 32
-	return (HZ_TO_MSEC_MUL32 * j) >> HZ_TO_MSEC_SHR32;
-# else
-	return (j * HZ_TO_MSEC_NUM) / HZ_TO_MSEC_DEN;
-# endif
-#endif
+	return __inline_jiffies_to_msecs(j);
 }
-EXPORT_SYMBOL(jiffies_to_msecs);
+EXPORT_SYMBOL(__jiffies_to_msecs);
 
-inline unsigned int jiffies_to_usecs(const unsigned long j)
+unsigned int __jiffies_to_usecs(const unsigned long j)
 {
-#if HZ <= USEC_PER_SEC && !(USEC_PER_SEC % HZ)
-	return (USEC_PER_SEC / HZ) * j;
-#elif HZ > USEC_PER_SEC && !(HZ % USEC_PER_SEC)
-	return (j + (HZ / USEC_PER_SEC) - 1)/(HZ / USEC_PER_SEC);
-#else
-# if BITS_PER_LONG == 32
-	return (HZ_TO_USEC_MUL32 * j) >> HZ_TO_USEC_SHR32;
-# else
-	return (j * HZ_TO_USEC_NUM) / HZ_TO_USEC_DEN;
-# endif
-#endif
+	return __inline_jiffies_to_usecs(j);
 }
-EXPORT_SYMBOL(jiffies_to_usecs);
+EXPORT_SYMBOL(__jiffies_to_usecs);
 
 /**
  * timespec_trunc - Truncate timespec to a granularity
@@ -411,76 +388,17 @@ struct timeval ns_to_timeval(const s64 n
 }
 EXPORT_SYMBOL(ns_to_timeval);
 
-/*
- * When we convert to jiffies then we interpret incoming values
- * the following way:
- *
- * - negative values mean 'infinite timeout' (MAX_JIFFY_OFFSET)
- *
- * - 'too large' values [that would result in larger than
- *   MAX_JIFFY_OFFSET values] mean 'infinite timeout' too.
- *
- * - all other values are converted to jiffies by either multiplying
- *   the input value by a factor or dividing it with a factor
- *
- * We must also be careful about 32-bit overflows.
- */
-unsigned long msecs_to_jiffies(const unsigned int m)
+unsigned long __msecs_to_jiffies(const unsigned int m)
 {
-	/*
-	 * Negative value, means infinite timeout:
-	 */
-	if ((int)m < 0)
-		return MAX_JIFFY_OFFSET;
-
-#if HZ <= MSEC_PER_SEC && !(MSEC_PER_SEC % HZ)
-	/*
-	 * HZ is equal to or smaller than 1000, and 1000 is a nice
-	 * round multiple of HZ, divide with the factor between them,
-	 * but round upwards:
-	 */
-	return (m + (MSEC_PER_SEC / HZ) - 1) / (MSEC_PER_SEC / HZ);
-#elif HZ > MSEC_PER_SEC && !(HZ % MSEC_PER_SEC)
-	/*
-	 * HZ is larger than 1000, and HZ is a nice round multiple of
-	 * 1000 - simply multiply with the factor between them.
-	 *
-	 * But first make sure the multiplication result cannot
-	 * overflow:
-	 */
-	if (m > jiffies_to_msecs(MAX_JIFFY_OFFSET))
-		return MAX_JIFFY_OFFSET;
-
-	return m * (HZ / MSEC_PER_SEC);
-#else
-	/*
-	 * Generic case - multiply, round and divide. But first
-	 * check that if we are doing a net multiplication, that
-	 * we wouldn't overflow:
-	 */
-	if (HZ > MSEC_PER_SEC && m > jiffies_to_msecs(MAX_JIFFY_OFFSET))
-		return MAX_JIFFY_OFFSET;
-
-	return (MSEC_TO_HZ_MUL32 * m + MSEC_TO_HZ_ADJ32)
-		>> MSEC_TO_HZ_SHR32;
-#endif
+	return __inline_msecs_to_jiffies(m);
 }
-EXPORT_SYMBOL(msecs_to_jiffies);
+EXPORT_SYMBOL(__msecs_to_jiffies);
 
-unsigned long usecs_to_jiffies(const unsigned int u)
+unsigned long __usecs_to_jiffies(const unsigned int u)
 {
-	if (u > jiffies_to_usecs(MAX_JIFFY_OFFSET))
-		return MAX_JIFFY_OFFSET;
-#if HZ <= USEC_PER_SEC && !(USEC_PER_SEC % HZ)
-	return (u + (USEC_PER_SEC / HZ) - 1) / (USEC_PER_SEC / HZ);
-#elif HZ > USEC_PER_SEC && !(HZ % USEC_PER_SEC)
-	return u * (HZ / USEC_PER_SEC);
-#else
-	return (USEC_TO_HZ_MUL32 * u + USEC_TO_HZ_ADJ32)
-		>> USEC_TO_HZ_SHR32;
-#endif
+	return __inline_usecs_to_jiffies(u);
 }
-EXPORT_SYMBOL(usecs_to_jiffies);
+EXPORT_SYMBOL(__usecs_to_jiffies);
 
 /*
  * The TICK_NSEC - 1 rounds up the value to the next resolution.  Note
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
compiler-gcc4h-reorder-macros-based-upon-gcc-ver.patch
compiler-gcch-add-gcc-recommended-gcc_version-macro.patch
compiler-gcc34h-use-gcc_version-macro.patch
compiler-gcc4h-bugh-remove-duplicate-macros.patch
bugh-fix-build_bug_on-macro-in-__checker__.patch
bugh-prevent-double-evaulation-of-in-build_bug_on.patch
bugh-make-build_bug_on-generate-compile-time-error.patch
compilerh-bugh-prevent-double-error-messages-with-build_bug_on.patch
bugh-compilerh-introduce-compiletime_assert-build_bug_on_msg.patch
jiffies-conversions-use-compile-time-constants-when-possible.patch
get_maintainerpl-find-maintainers-for-removed-files.patch
checkpatch-prefer-dev_level-to-dev_printkkern_level.patch
checkpatch-warn-on-unnecessary-__devfoo-section-markings.patch

