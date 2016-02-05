From: akpm@linux-foundation.org
Subject: + lib-move-strtobool-to-kstrtobool.patch added to -mm tree
Date: Fri, 05 Feb 2016 15:05:05 -0800
Message-ID: <56b52aa1.2pV7Hhrpuew5C3ui%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36128 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038AbcBEXFG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Feb 2016 18:05:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, akarwar@marvell.com, andy.shevchenko@gmail.com, daniel@iogearbox.net, heiko.carstens@de.ibm.com, joe@perches.com, kvalo@codeaurora.org, linux@rasmusvillemoes.dk, mpe@ellerman.id.au, nishants@marvell.com, schwidefsky@de.ibm.com, sfrench@samba.org, mm-commits@vger.kernel.org


The patch titled
     Subject: lib: move strtobool() to kstrtobool()
has been added to the -mm tree.  Its filename is
     lib-move-strtobool-to-kstrtobool.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-move-strtobool-to-kstrtobool.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-move-strtobool-to-kstrtobool.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: lib: move strtobool() to kstrtobool()

Create the kstrtobool_from_user() helper and move strtobool() logic into
the new kstrtobool() (matching all the other kstrto* functions).  Provides
an inline wrapper for existing strtobool() callers.

Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Joe Perches <joe@perches.com>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Amitkumar Karwar <akarwar@marvell.com>
Cc: Nishant Sarmukadam <nishants@marvell.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: Steve French <sfrench@samba.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |    2 +
 include/linux/string.h |    6 +++-
 lib/kstrtox.c          |   50 +++++++++++++++++++++++++++++++++++++++
 lib/string.c           |   29 ----------------------
 4 files changed, 57 insertions(+), 30 deletions(-)

diff -puN include/linux/kernel.h~lib-move-strtobool-to-kstrtobool include/linux/kernel.h
--- a/include/linux/kernel.h~lib-move-strtobool-to-kstrtobool
+++ a/include/linux/kernel.h
@@ -357,6 +357,7 @@ int __must_check kstrtou16(const char *s
 int __must_check kstrtos16(const char *s, unsigned int base, s16 *res);
 int __must_check kstrtou8(const char *s, unsigned int base, u8 *res);
 int __must_check kstrtos8(const char *s, unsigned int base, s8 *res);
+int __must_check kstrtobool(const char *s, bool *res);
 
 int __must_check kstrtoull_from_user(const char __user *s, size_t count, unsigned int base, unsigned long long *res);
 int __must_check kstrtoll_from_user(const char __user *s, size_t count, unsigned int base, long long *res);
@@ -368,6 +369,7 @@ int __must_check kstrtou16_from_user(con
 int __must_check kstrtos16_from_user(const char __user *s, size_t count, unsigned int base, s16 *res);
 int __must_check kstrtou8_from_user(const char __user *s, size_t count, unsigned int base, u8 *res);
 int __must_check kstrtos8_from_user(const char __user *s, size_t count, unsigned int base, s8 *res);
+int __must_check kstrtobool_from_user(const char __user *s, size_t count, bool *res);
 
 static inline int __must_check kstrtou64_from_user(const char __user *s, size_t count, unsigned int base, u64 *res)
 {
diff -puN include/linux/string.h~lib-move-strtobool-to-kstrtobool include/linux/string.h
--- a/include/linux/string.h~lib-move-strtobool-to-kstrtobool
+++ a/include/linux/string.h
@@ -128,7 +128,11 @@ extern char **argv_split(gfp_t gfp, cons
 extern void argv_free(char **argv);
 
 extern bool sysfs_streq(const char *s1, const char *s2);
-extern int strtobool(const char *s, bool *res);
+extern int kstrtobool(const char *s, bool *res);
+static inline int strtobool(const char *s, bool *res)
+{
+	return kstrtobool(s, res);
+}
 
 int match_string(const char * const *array, size_t n, const char *string);
 
diff -puN lib/kstrtox.c~lib-move-strtobool-to-kstrtobool lib/kstrtox.c
--- a/lib/kstrtox.c~lib-move-strtobool-to-kstrtobool
+++ a/lib/kstrtox.c
@@ -321,6 +321,56 @@ int kstrtos8(const char *s, unsigned int
 }
 EXPORT_SYMBOL(kstrtos8);
 
+/**
+ * kstrtobool - convert common user inputs into boolean values
+ * @s: input string
+ * @res: result
+ *
+ * This routine returns 0 iff the first character is one of 'Yy1Nn0'.
+ * Otherwise it will return -EINVAL.  Value pointed to by res is
+ * updated upon finding a match.
+ */
+int kstrtobool(const char *s, bool *res)
+{
+	if (!s)
+		return -EINVAL;
+
+	switch (s[0]) {
+	case 'y':
+	case 'Y':
+	case '1':
+		*res = true;
+		return 0;
+	case 'n':
+	case 'N':
+	case '0':
+		*res = false;
+		return 0;
+	default:
+		break;
+	}
+
+	return -EINVAL;
+}
+EXPORT_SYMBOL(kstrtobool);
+
+/*
+ * Since "base" would be a nonsense argument, this open-codes the
+ * _from_user helper instead of using the helper macro below.
+ */
+int kstrtobool_from_user(const char __user *s, size_t count, bool *res)
+{
+	/* Longest string needed to differentiate, newline, terminator */
+	char buf[4];
+
+	count = min(count, sizeof(buf) - 1);
+	if (copy_from_user(buf, s, count))
+		return -EFAULT;
+	buf[count] = '\0';
+	return kstrtobool(buf, res);
+}
+EXPORT_SYMBOL(kstrtobool_from_user);
+
 #define kstrto_from_user(f, g, type)					\
 int f(const char __user *s, size_t count, unsigned int base, type *res)	\
 {									\
diff -puN lib/string.c~lib-move-strtobool-to-kstrtobool lib/string.c
--- a/lib/string.c~lib-move-strtobool-to-kstrtobool
+++ a/lib/string.c
@@ -656,35 +656,6 @@ int match_string(const char * const *arr
 }
 EXPORT_SYMBOL(match_string);
 
-/**
- * strtobool - convert common user inputs into boolean values
- * @s: input string
- * @res: result
- *
- * This routine returns 0 iff the first character is one of 'Yy1Nn0'.
- * Otherwise it will return -EINVAL.  Value pointed to by res is
- * updated upon finding a match.
- */
-int strtobool(const char *s, bool *res)
-{
-	switch (s[0]) {
-	case 'y':
-	case 'Y':
-	case '1':
-		*res = true;
-		break;
-	case 'n':
-	case 'N':
-	case '0':
-		*res = false;
-		break;
-	default:
-		return -EINVAL;
-	}
-	return 0;
-}
-EXPORT_SYMBOL(strtobool);
