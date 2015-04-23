From: akpm@linux-foundation.org
Subject: + ocfs2-reduce-object-size-of-mlog-uses.patch added to -mm tree
Date: Thu, 23 Apr 2015 14:55:44 -0700
Message-ID: <55396a60.v7W6UpK/AdfybRZ/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35976 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753187AbbDWVzp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 23 Apr 2015 17:55:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: reduce object size of mlog uses
has been added to the -mm tree.  Its filename is
     ocfs2-reduce-object-size-of-mlog-uses.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-reduce-object-size-of-mlog-uses.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-reduce-object-size-of-mlog-uses.patch

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
Subject: ocfs2: reduce object size of mlog uses

Using a function for __mlog_printk instead of a macro
reduces the object size of built-in.o by about 190KB, or
~18% overall (x86-64 defconfig with all ocfs2 options)

$ size fs/ocfs2/built-in.o*
   text    data     bss     dec     hex filename
 870954	 118471	 134408	1123833	 1125f9	fs/ocfs2/built-in.o,new
1064081  118071  134408 1316560  1416d0 fs/ocfs2/built-in.o.old

Miscellanea:

o Move the used-once __mlog_cpu_guess statement expression macro
  to the masklog.c file above the use in __mlog_printk function
o Simplify the mlog macro moving the and/or logic and level code
  into __mlog_printk

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/cluster/masklog.c |   46 +++++++++++++++++++++++++++++++++++
 fs/ocfs2/cluster/masklog.h |   42 +++++++++----------------------
 2 files changed, 58 insertions(+), 30 deletions(-)

diff -puN fs/ocfs2/cluster/masklog.c~ocfs2-reduce-object-size-of-mlog-uses fs/ocfs2/cluster/masklog.c
--- a/fs/ocfs2/cluster/masklog.c~ocfs2-reduce-object-size-of-mlog-uses
+++ a/fs/ocfs2/cluster/masklog.c
@@ -64,6 +64,52 @@ static ssize_t mlog_mask_store(u64 mask,
 	return count;
 }
 
+/*
+ * smp_processor_id() "helpfully" screams when called outside preemptible
+ * regions in current kernels.  sles doesn't have the variants that don't
+ * scream.  just do this instead of trying to guess which we're building
+ * against.. *sigh*.
+ */
+#define __mlog_cpu_guess						\
+({									\
+	unsigned long _cpu = get_cpu();					\
+	put_cpu();							\
+	_cpu;								\
+})
+
+void __mlog_printk(const u64 *mask, const char *func, int line,
+		   const char *fmt, ...)
+{
+	struct va_format vaf;
+	va_list args;
+	const char *level;
+	const char *prefix = "";
+
+	if (!__mlog_test_u64(*mask, mlog_and_bits) ||
+	    __mlog_test_u64(*mask, mlog_not_bits))
+		return;
+
+	if (*mask & ML_ERROR) {
+		level = KERN_ERR;
+		prefix = "ERROR: ";
+	} else if (*mask & ML_NOTICE) {
+		level = KERN_NOTICE;
+	} else {
+		level = KERN_INFO;
+	}
+
+	va_start(args, fmt);
+
+	vaf.fmt = fmt;
+	vaf.va = &args;
+
+	printk("%s(%s,%u,%lu):%s:%d %s%pV",
+	       level, current->comm, task_pid_nr(current), __mlog_cpu_guess,
+	       func, line, prefix, &vaf);
+
+	va_end(args);
+}
+
 struct mlog_attribute {
 	struct attribute attr;
 	u64 mask;
diff -puN fs/ocfs2/cluster/masklog.h~ocfs2-reduce-object-size-of-mlog-uses fs/ocfs2/cluster/masklog.h
--- a/fs/ocfs2/cluster/masklog.h~ocfs2-reduce-object-size-of-mlog-uses
+++ a/fs/ocfs2/cluster/masklog.h
@@ -162,38 +162,20 @@ extern struct mlog_bits mlog_and_bits, m
 
 #endif
 
-/*
- * smp_processor_id() "helpfully" screams when called outside preemptible
- * regions in current kernels.  sles doesn't have the variants that don't
- * scream.  just do this instead of trying to guess which we're building
- * against.. *sigh*.
- */
-#define __mlog_cpu_guess ({		\
-	unsigned long _cpu = get_cpu();	\
-	put_cpu();			\
-	_cpu;				\
-})
+__printf(4, 5)
+void __mlog_printk(const u64 *m, const char *func, int line,
+		   const char *fmt, ...);
 
-/* In the following two macros, the whitespace after the ',' just
- * before ##args is intentional. Otherwise, gcc 2.95 will eat the
- * previous token if args expands to nothing.
+/*
+ * Testing before the __mlog_printk call lets the compiler eliminate the
+ * call completely when (m & ML_ALLOWED_BITS) is 0.
  */
-#define __mlog_printk(level, fmt, args...)				\
-	printk(level "(%s,%u,%lu):%s:%d " fmt, current->comm,		\
-	       task_pid_nr(current), __mlog_cpu_guess,			\
-	       __PRETTY_FUNCTION__, __LINE__ , ##args)
-
-#define mlog(mask, fmt, args...) do {					\
-	u64 __m = MLOG_MASK_PREFIX | (mask);				\
-	if ((__m & ML_ALLOWED_BITS) &&					\
-	    __mlog_test_u64(__m, mlog_and_bits) &&			\
-	    !__mlog_test_u64(__m, mlog_not_bits)) {			\
-		if (__m & ML_ERROR)					\
-			__mlog_printk(KERN_ERR, "ERROR: "fmt , ##args);	\
-		else if (__m & ML_NOTICE)				\
-			__mlog_printk(KERN_NOTICE, fmt , ##args);	\
-		else __mlog_printk(KERN_INFO, fmt , ##args);		\
-	}								\
+#define mlog(mask, fmt, ...)						\
+do {									\
+	u64 _m = MLOG_MASK_PREFIX | (mask);				\
+	if (_m & ML_ALLOWED_BITS)					\
+		__mlog_printk(&_m, __func__, __LINE__, fmt,		\
+			      ##__VA_ARGS__);				\
 } while (0)
 
 #define mlog_errno(st) ({						\
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
compiler-gcch-neatening.patch
compiler-gcc-integrate-the-various-compiler-gcch-files.patch
kasan-show-gcc-version-requirements-in-kconfig-and-documentation.patch
ocfs2-reduce-object-size-of-mlog-uses.patch
ocfs2-remove-__mlog_cpu_guess.patch
ocfs2-neaten-do_error-ocfs2_error-and-ocfs2_abort.patch
mm-utilc-add-kstrimdup.patch
linux-next.patch

