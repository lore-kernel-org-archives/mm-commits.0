From: akpm@linux-foundation.org
Subject: + add-new-string-functions-strict_strto-and-convert-kernel-params-to-use-them.patch added to -mm tree
Date: Thu, 31 Jan 2008 23:41:11 -0800
Message-ID: <200802010740.m117eq33001729@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45272 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933160AbYBAHlF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Feb 2008 02:41:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yi.y.yang@intel.com, greg@kroah.com, rdunlap@xenotime.net


The patch titled
     Add new string functions strict_strto* and convert kernel params to use them
has been added to the -mm tree.  Its filename is
     add-new-string-functions-strict_strto-and-convert-kernel-params-to-use-them.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Add new string functions strict_strto* and convert kernel params to use them
From: Yi Yang <yi.y.yang@intel.com>

Currently, for every sysfs node, the callers will be responsible for
implementing store operation, so many many callers are doing duplicate
things to validate input, they have the same mistakes because they are
calling simple_strtol/ul/ll/uul, especially for module params, they are
just numeric, but you can echo such values as 0x1234xxx, 07777888 and
1234aaa, for these cases, module params store operation just ignores
succesive invalid char and converts prefix part to a numeric although input
is acctually invalid.

This patch tries to fix the aforementioned issues and implements
strict_strtox serial functions, kernel/params.c uses them to strictly
validate input, so module params will reject such values as 0x1234xxxx and
returns an error:

write error: Invalid argument

Any modules which export numeric sysfs node can use strict_strtox instead of
simple_strtox to reject any invalid input.

Here are some test results:

Before applying this patch:

[root@yangyi-dev /]# cat /sys/module/e1000/parameters/copybreak
4096
[root@yangyi-dev /]# echo 0x1000 > /sys/module/e1000/parameters/copybreak
[root@yangyi-dev /]# cat /sys/module/e1000/parameters/copybreak
4096
[root@yangyi-dev /]# echo 0x1000g > /sys/module/e1000/parameters/copybreak
[root@yangyi-dev /]# cat /sys/module/e1000/parameters/copybreak
4096
[root@yangyi-dev /]# echo 0x1000gggggggg > /sys/module/e1000/parameters/copybreak
[root@yangyi-dev /]# cat /sys/module/e1000/parameters/copybreak
4096
[root@yangyi-dev /]# echo 010000 > /sys/module/e1000/parameters/copybreak
[root@yangyi-dev /]# cat /sys/module/e1000/parameters/copybreak
4096
[root@yangyi-dev /]# echo 0100008 > /sys/module/e1000/parameters/copybreak
[root@yangyi-dev /]# cat /sys/module/e1000/parameters/copybreak
4096
[root@yangyi-dev /]# echo 010000aaaaa > /sys/module/e1000/parameters/copybreak
[root@yangyi-dev /]# cat /sys/module/e1000/parameters/copybreak
4096
[root@yangyi-dev /]#

After applying this patch:

[root@yangyi-dev /]# cat /sys/module/e1000/parameters/copybreak
4096
[root@yangyi-dev /]# echo 0x1000 > /sys/module/e1000/parameters/copybreak
[root@yangyi-dev /]# cat /sys/module/e1000/parameters/copybreak
4096
[root@yangyi-dev /]# echo 0x1000g > /sys/module/e1000/parameters/copybreak
-bash: echo: write error: Invalid argument
[root@yangyi-dev /]# cat /sys/module/e1000/parameters/copybreak
4096
[root@yangyi-dev /]# echo 0x1000gggggggg > /sys/module/e1000/parameters/copybreak
-bash: echo: write error: Invalid argument
[root@yangyi-dev /]# echo 010000 > /sys/module/e1000/parameters/copybreak
[root@yangyi-dev /]# echo 0100008 > /sys/module/e1000/parameters/copybreak
-bash: echo: write error: Invalid argument
[root@yangyi-dev /]# echo 010000aaaaa > /sys/module/e1000/parameters/copybreak
-bash: echo: write error: Invalid argument
[root@yangyi-dev /]# cat /sys/module/e1000/parameters/copybreak
4096
[root@yangyi-dev /]# echo -n 4096 > /sys/module/e1000/parameters/copybreak
[root@yangyi-dev /]# cat /sys/module/e1000/parameters/copybreak
4096
[root@yangyi-dev /]#

Signed-off-by: Yi Yang <yi.y.yang@intel.com>
Cc: Greg KH <greg@kroah.com>
Cc: "Randy.Dunlap" <rdunlap@xenotime.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |    4 +++
 kernel/params.c        |   20 ++++++++--------
 lib/vsprintf.c         |   46 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 60 insertions(+), 10 deletions(-)

diff -puN include/linux/kernel.h~add-new-string-functions-strict_strto-and-convert-kernel-params-to-use-them include/linux/kernel.h
--- a/include/linux/kernel.h~add-new-string-functions-strict_strto-and-convert-kernel-params-to-use-them
+++ a/include/linux/kernel.h
@@ -141,6 +141,10 @@ extern unsigned long simple_strtoul(cons
 extern long simple_strtol(const char *,char **,unsigned int);
 extern unsigned long long simple_strtoull(const char *,char **,unsigned int);
 extern long long simple_strtoll(const char *,char **,unsigned int);
+extern int strict_strtoul(const char *, unsigned int, unsigned long *);
+extern int strict_strtol(const char *, unsigned int, long *);
+extern int strict_strtoull(const char *, unsigned int, unsigned long long *);
+extern int strict_strtoll(const char *, unsigned int, long long *);
 extern int sprintf(char * buf, const char * fmt, ...)
 	__attribute__ ((format (printf, 2, 3)));
 extern int vsprintf(char *buf, const char *, va_list)
diff -puN kernel/params.c~add-new-string-functions-strict_strto-and-convert-kernel-params-to-use-them kernel/params.c
--- a/kernel/params.c~add-new-string-functions-strict_strto-and-convert-kernel-params-to-use-them
+++ a/kernel/params.c
@@ -180,12 +180,12 @@ int parse_args(const char *name,
 #define STANDARD_PARAM_DEF(name, type, format, tmptype, strtolfn)      	\
 	int param_set_##name(const char *val, struct kernel_param *kp)	\
 	{								\
-		char *endp;						\
 		tmptype l;						\
+		int ret;						\
 									\
 		if (!val) return -EINVAL;				\
-		l = strtolfn(val, &endp, 0);				\
-		if (endp == val || ((type)l != l))			\
+		ret = strtolfn(val, 0, &l);				\
+		if (ret == -EINVAL || ((type)l != l))			\
 			return -EINVAL;					\
 		*((type *)kp->arg) = l;					\
 		return 0;						\
@@ -195,13 +195,13 @@ int parse_args(const char *name,
 		return sprintf(buffer, format, *((type *)kp->arg));	\
 	}
 
-STANDARD_PARAM_DEF(byte, unsigned char, "%c", unsigned long, simple_strtoul);
-STANDARD_PARAM_DEF(short, short, "%hi", long, simple_strtol);
-STANDARD_PARAM_DEF(ushort, unsigned short, "%hu", unsigned long, simple_strtoul);
-STANDARD_PARAM_DEF(int, int, "%i", long, simple_strtol);
-STANDARD_PARAM_DEF(uint, unsigned int, "%u", unsigned long, simple_strtoul);
-STANDARD_PARAM_DEF(long, long, "%li", long, simple_strtol);
-STANDARD_PARAM_DEF(ulong, unsigned long, "%lu", unsigned long, simple_strtoul);
+STANDARD_PARAM_DEF(byte, unsigned char, "%c", unsigned long, strict_strtoul);
+STANDARD_PARAM_DEF(short, short, "%hi", long, strict_strtol);
+STANDARD_PARAM_DEF(ushort, unsigned short, "%hu", unsigned long, strict_strtoul);
+STANDARD_PARAM_DEF(int, int, "%i", long, strict_strtol);
+STANDARD_PARAM_DEF(uint, unsigned int, "%u", unsigned long, strict_strtoul);
+STANDARD_PARAM_DEF(long, long, "%li", long, strict_strtol);
+STANDARD_PARAM_DEF(ulong, unsigned long, "%lu", unsigned long, strict_strtoul);
 
 int param_set_charp(const char *val, struct kernel_param *kp)
 {
diff -puN lib/vsprintf.c~add-new-string-functions-strict_strto-and-convert-kernel-params-to-use-them lib/vsprintf.c
--- a/lib/vsprintf.c~add-new-string-functions-strict_strto-and-convert-kernel-params-to-use-them
+++ a/lib/vsprintf.c
@@ -129,6 +129,52 @@ long long simple_strtoll(const char *cp,
 	return simple_strtoull(cp,endp,base);
 }
 
+#define define_strict_strtoux(type, valtype)				\
+int strict_strtou##type(const char *cp, unsigned int base, valtype *res)\
+{									\
+	char *tail;							\
+	valtype val;							\
+	size_t len;							\
+									\
+	*res = 0;							\
+	len = strlen(cp);						\
+	if (len == 0)							\
+		return -EINVAL;						\
+									\
+	val = simple_strtoul(cp, &tail, base);				\
+	if ((*tail == '\0') ||						\
+		(len == (size_t)(tail - cp) + 1) && (*tail == '\n')) {	\
+		*res = val;						\
+		return 0;						\
+	}								\
+									\
+	return -EINVAL;							\
+}									\
+
+#define define_strict_strtox(type, valtype)				\
+int strict_strto##type(const char *cp, unsigned int base, valtype *res)	\
+{									\
+	int ret;							\
+	if (*cp == '-') {						\
+		ret = strict_strtou##type(cp+1, base, res);		\
+		if (ret != 0)						\
+			*res = -(*res);					\
+	} else								\
+		ret = strict_strtou##type(cp+1, base, res);		\
+									\
+	return ret;							\
+}									\
+
+define_strict_strtoux(l, unsigned long)
+define_strict_strtox(l, long)
+define_strict_strtoux(ll, unsigned long long)
+define_strict_strtox(ll, long long)
+
+EXPORT_SYMBOL(strict_strtoul);
+EXPORT_SYMBOL(strict_strtol);
+EXPORT_SYMBOL(strict_strtoll);
+EXPORT_SYMBOL(strict_strtoull);
+
 static int skip_atoi(const char **s)
 {
 	int i=0;
_

Patches currently in -mm which might be from yi.y.yang@intel.com are

git-acpi.patch
git-x86.patch
add-new-string-functions-strict_strto-and-convert-kernel-params-to-use-them.patch
