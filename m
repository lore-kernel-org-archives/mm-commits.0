From: akpm@linux-foundation.org
Subject: + lib-add-kstrto_from_user.patch added to -mm tree
Date: Tue, 12 Apr 2011 13:49:47 -0700
Message-ID: <201104122049.p3CKnmFQ001970@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33388 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932066Ab1DLUtv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Apr 2011 16:49:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com


The patch titled
     lib: add kstrto*_from_user()
has been added to the -mm tree.  Its filename is
     lib-add-kstrto_from_user.patch

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
Subject: lib: add kstrto*_from_user()
From: Alexey Dobriyan <adobriyan@gmail.com>

There is quite a lot of code which does copy_from_user() + strict_strto*()
or simple_strto*() combo in slightly different ways.

Before doing conversions all over tree, let's get final API correct.

Enter kstrtoull_from_user() and friends.

Typical code which uses them looks very simple:

	TYPE val;
	int rv;

	rv = kstrtoTYPE_from_user(buf, count, 0, &val);
	if (rv < 0)
		return rv;
	[use val]
	return count;

There is a tiny semantic difference from the plain kstrto*() API -- the
latter allows any amount of leading zeroes, while the former copies data
into buffer on stack and thus allows leading zeroes as long as it fits
into buffer.

This shouldn't be a problem for typical usecase "echo 42 > /proc/x".

The point is to make reading one integer from userspace _very_ simple and
very bug free.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |   31 +++++++++++++++++++++++++++++++
 lib/kstrtox.c          |   26 ++++++++++++++++++++++++++
 2 files changed, 57 insertions(+)

diff -puN include/linux/kernel.h~lib-add-kstrto_from_user include/linux/kernel.h
--- a/include/linux/kernel.h~lib-add-kstrto_from_user
+++ a/include/linux/kernel.h
@@ -248,6 +248,37 @@ int __must_check kstrtos16(const char *s
 int __must_check kstrtou8(const char *s, unsigned int base, u8 *res);
 int __must_check kstrtos8(const char *s, unsigned int base, s8 *res);
 
+int __must_check kstrtoull_from_user(const char __user *s, size_t count, unsigned int base, unsigned long long *res);
+int __must_check kstrtoll_from_user(const char __user *s, size_t count, unsigned int base, long long *res);
+int __must_check kstrtoul_from_user(const char __user *s, size_t count, unsigned int base, unsigned long *res);
+int __must_check kstrtol_from_user(const char __user *s, size_t count, unsigned int base, long *res);
+int __must_check kstrtouint_from_user(const char __user *s, size_t count, unsigned int base, unsigned int *res);
+int __must_check kstrtoint_from_user(const char __user *s, size_t count, unsigned int base, int *res);
+int __must_check kstrtou16_from_user(const char __user *s, size_t count, unsigned int base, u16 *res);
+int __must_check kstrtos16_from_user(const char __user *s, size_t count, unsigned int base, s16 *res);
+int __must_check kstrtou8_from_user(const char __user *s, size_t count, unsigned int base, u8 *res);
+int __must_check kstrtos8_from_user(const char __user *s, size_t count, unsigned int base, s8 *res);
+
+static inline int __must_check kstrtou64_from_user(const char __user *s, size_t count, unsigned int base, u64 *res)
+{
+	return kstrtoull_from_user(s, count, base, res);
+}
+
+static inline int __must_check kstrtos64_from_user(const char __user *s, size_t count, unsigned int base, s64 *res)
+{
+	return kstrtoll_from_user(s, count, base, res);
+}
+
+static inline int __must_check kstrtou32_from_user(const char __user *s, size_t count, unsigned int base, u32 *res)
+{
+	return kstrtouint_from_user(s, count, base, res);
+}
+
+static inline int __must_check kstrtos32_from_user(const char __user *s, size_t count, unsigned int base, s32 *res)
+{
+	return kstrtoint_from_user(s, count, base, res);
+}
+
 extern unsigned long simple_strtoul(const char *,char **,unsigned int);
 extern long simple_strtol(const char *,char **,unsigned int);
 extern unsigned long long simple_strtoull(const char *,char **,unsigned int);
diff -puN lib/kstrtox.c~lib-add-kstrto_from_user lib/kstrtox.c
--- a/lib/kstrtox.c~lib-add-kstrto_from_user
+++ a/lib/kstrtox.c
@@ -17,6 +17,7 @@
 #include <linux/math64.h>
 #include <linux/module.h>
 #include <linux/types.h>
+#include <asm/uaccess.h>
 
 static inline char _tolower(const char c)
 {
@@ -222,3 +223,28 @@ int kstrtos8(const char *s, unsigned int
 	return 0;
 }
 EXPORT_SYMBOL(kstrtos8);
+
+#define kstrto_from_user(f, g, type)					\
+int f(const char __user *s, size_t count, unsigned int base, type *res)	\
+{									\
+	/* sign, base 2 representation, newline, terminator */		\
+	char buf[1 + sizeof(type) * 8 + 1 + 1];				\
+									\
+	count = min(count, sizeof(buf) - 1);				\
+	if (copy_from_user(buf, s, count))				\
+		return -EFAULT;						\
+	buf[count] = '\0';						\
+	return g(buf, base, res);					\
+}									\
+EXPORT_SYMBOL(f)
+
+kstrto_from_user(kstrtoull_from_user,	kstrtoull,	unsigned long long);
+kstrto_from_user(kstrtoll_from_user,	kstrtoll,	long long);
+kstrto_from_user(kstrtoul_from_user,	kstrtoul,	unsigned long);
+kstrto_from_user(kstrtol_from_user,	kstrtol,	long);
+kstrto_from_user(kstrtouint_from_user,	kstrtouint,	unsigned int);
+kstrto_from_user(kstrtoint_from_user,	kstrtoint,	int);
+kstrto_from_user(kstrtou16_from_user,	kstrtou16,	u16);
+kstrto_from_user(kstrtos16_from_user,	kstrtos16,	s16);
+kstrto_from_user(kstrtou8_from_user,	kstrtou8,	u8);
+kstrto_from_user(kstrtos8_from_user,	kstrtos8,	s8);
_

Patches currently in -mm which might be from adobriyan@gmail.com are

linux-next.patch
kstrtox-fix-compile-warnings-in-test.patch
kstrtox-simpler-code-in-_kstrtoull.patch
lib-add-kstrto_from_user.patch
kstrtox-convert-fs-proc.patch
proc-constify-status-array.patch
proc-stat-use-defined-macro-kmalloc_max_size.patch
sysctl-add-proc_dointvec_bool-handler.patch

