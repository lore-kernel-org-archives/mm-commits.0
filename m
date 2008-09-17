From: akpm@linux-foundation.org
Subject: + lib-remove-defining-macros-for-strict_strto.patch added to -mm tree
Date: Wed, 17 Sep 2008 16:06:14 -0700
Message-ID: <200809172306.m8HN6FdZ002907@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59303 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755903AbYIQXGR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Sep 2008 19:06:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com, yi.y.yang@intel.com


The patch titled
     lib: remove defining macros for strict_strto??
has been added to the -mm tree.  Its filename is
     lib-remove-defining-macros-for-strict_strto.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lib: remove defining macros for strict_strto??
From: Harvey Harrison <harvey.harrison@gmail.com>

Open-code them rather than using defining macros.  Add casts to the signed
cases as they call into the unsigned versions.

Avoids the sparse warnings:
lib/vsprintf.c:249:1: warning: incorrect type in argument 3 (different signedness)
lib/vsprintf.c:249:1:    expected unsigned long *res
lib/vsprintf.c:249:1:    got long *res
lib/vsprintf.c:249:1: warning: incorrect type in argument 3 (different signedness)
lib/vsprintf.c:249:1:    expected unsigned long *res
lib/vsprintf.c:249:1:    got long *res
lib/vsprintf.c:251:1: warning: incorrect type in argument 3 (different signedness)
lib/vsprintf.c:251:1:    expected unsigned long long *res
lib/vsprintf.c:251:1:    got long long *res
lib/vsprintf.c:251:1: warning: incorrect type in argument 3 (different signedness)
lib/vsprintf.c:251:1:    expected unsigned long long *res
lib/vsprintf.c:251:1:    got long long *res

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Yi Yang <yi.y.yang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/vsprintf.c |  117 +++++++++++++++++++++++++++--------------------
 1 file changed, 68 insertions(+), 49 deletions(-)

diff -puN lib/vsprintf.c~lib-remove-defining-macros-for-strict_strto lib/vsprintf.c
--- a/lib/vsprintf.c~lib-remove-defining-macros-for-strict_strto
+++ a/lib/vsprintf.c
@@ -135,7 +135,6 @@ long long simple_strtoll(const char *cp,
 	return simple_strtoull(cp, endp, base);
 }
 
-
 /**
  * strict_strtoul - convert a string to an unsigned long strictly
  * @cp: The string to be converted
@@ -158,7 +157,27 @@ long long simple_strtoll(const char *cp,
  * simple_strtoul just ignores the successive invalid characters and
  * return the converted value of prefix part of the string.
  */
-int strict_strtoul(const char *cp, unsigned int base, unsigned long *res);
+int strict_strtoul(const char *cp, unsigned int base, unsigned long *res)
+{
+	char *tail;
+	unsigned long val;
+	size_t len;
+
+	*res = 0;
+	len = strlen(cp);
+	if (len == 0)
+		return -EINVAL;
+
+	val = simple_strtoul(cp, &tail, base);
+	if ((*tail == '\0') ||
+		((len == (size_t)(tail - cp) + 1) && (*tail == '\n'))) {
+		*res = val;
+		return 0;
+	}
+
+	return -EINVAL;
+}
+EXPORT_SYMBOL(strict_strtoul);
 
 /**
  * strict_strtol - convert a string to a long strictly
@@ -172,7 +191,20 @@ int strict_strtoul(const char *cp, unsig
  * It returns 0 if conversion is successful and *res is set to the converted
  * value, otherwise it returns -EINVAL and *res is set to 0.
  */
-int strict_strtol(const char *cp, unsigned int base, long *res);
+int strict_strtol(const char *cp, unsigned int base, long *res)
+{
+	int ret;
+	if (*cp == '-') {
+		ret = strict_strtoul(cp + 1, base, (unsigned long *)res);
+		if (!ret)
+			*res = -(*res);
+	} else {
+		ret = strict_strtoul(cp, base, (unsigned long *)res);
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL(strict_strtol);
 
 /**
  * strict_strtoull - convert a string to an unsigned long long strictly
@@ -196,7 +228,27 @@ int strict_strtol(const char *cp, unsign
  * simple_strtoull just ignores the successive invalid characters and
  * return the converted value of prefix part of the string.
  */
-int strict_strtoull(const char *cp, unsigned int base, unsigned long long *res);
+int strict_strtoull(const char *cp, unsigned int base, unsigned long long *res)
+{
+	char *tail;
+	unsigned long long val;
+	size_t len;
+
+	*res = 0;
+	len = strlen(cp);
+	if (len == 0)
+		return -EINVAL;
+
+	val = simple_strtoull(cp, &tail, base);
+	if ((*tail == '\0') ||
+		((len == (size_t)(tail - cp) + 1) && (*tail == '\n'))) {
+		*res = val;
+		return 0;
+	}
+
+	return -EINVAL;
+}
+EXPORT_SYMBOL(strict_strtoull);
 
 /**
  * strict_strtoll - convert a string to a long long strictly
@@ -210,53 +262,20 @@ int strict_strtoull(const char *cp, unsi
  * It returns 0 if conversion is successful and *res is set to the converted
  * value, otherwise it returns -EINVAL and *res is set to 0.
  */
-int strict_strtoll(const char *cp, unsigned int base, long long *res);
-
-#define define_strict_strtoux(type, valtype)				\
-int strict_strtou##type(const char *cp, unsigned int base, valtype *res)\
-{									\
-	char *tail;							\
-	valtype val;							\
-	size_t len;							\
-									\
-	*res = 0;							\
-	len = strlen(cp);						\
-	if (len == 0)							\
-		return -EINVAL;						\
-									\
-	val = simple_strtou##type(cp, &tail, base);			\
-	if ((*tail == '\0') ||						\
-		((len == (size_t)(tail - cp) + 1) && (*tail == '\n'))) {\
-		*res = val;						\
-		return 0;						\
-	}								\
-									\
-	return -EINVAL;							\
-}									\
-
-#define define_strict_strtox(type, valtype)				\
-int strict_strto##type(const char *cp, unsigned int base, valtype *res)	\
-{									\
-	int ret;							\
-	if (*cp == '-') {						\
-		ret = strict_strtou##type(cp+1, base, res);		\
-		if (!ret)						\
-			*res = -(*res);					\
-	} else								\
-		ret = strict_strtou##type(cp, base, res);		\
-									\
-	return ret;							\
-}									\
-
-define_strict_strtoux(l, unsigned long)
-define_strict_strtox(l, long)
-define_strict_strtoux(ll, unsigned long long)
-define_strict_strtox(ll, long long)
+int strict_strtoll(const char *cp, unsigned int base, long long *res)
+{
+	int ret;
+	if (*cp == '-') {
+		ret = strict_strtoull(cp + 1, base, (unsigned long long *)res);
+		if (!ret)
+			*res = -(*res);
+	} else {
+		ret = strict_strtoull(cp, base, (unsigned long long *)res);
+	}
 
-EXPORT_SYMBOL(strict_strtoul);
-EXPORT_SYMBOL(strict_strtol);
+	return ret;
+}
 EXPORT_SYMBOL(strict_strtoll);
-EXPORT_SYMBOL(strict_strtoull);
 
 static int skip_atoi(const char **s)
 {
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

linux-next.patch
acpi-toshiba_acpic-fix-sparse-signedness-mismatch-warnings.patch
x86-fix-shadowed-variable-warning.patch
cifs-remove-global_extern-macro.patch
net-compile-fix-depcac.patch
input-ads7846c-sparse-lock-annotation.patch
misdn-endian-annotations-for-struct-zt.patch
misdn-annotate-iomem-pointer-and-add-statics.patch
drivers-net-replace-__function__-with-__func__.patch
bq27x00_battery-use-unaligned-access-helper.patch
rcu-fix-sparse-shadowed-variable-warning.patch
scsi-replace-__inline-with-inline.patch
scsi-aic79xx_core-fix-shadowed-variables-add-statics.patch
scsi-aic79xx-aic79xx_pcic-fix-shadowed-variables.patch
scsi-gdthc-use-unaligned-access-helpers.patch
scsi-use-the-common-hex_asc-array-rather-than-a-private-one.patch
fbcon-fix-monochrome-color-value-calculation.patch
mm-hugetlbc-make-functions-static-use-null-rather-than-0.patch
olpc-olpc_batteryc-sparse-endian-annotations.patch
include-replace-__function__-with-__func__.patch
misc-replace-__function__-with-__func__.patch
befs-annotate-fs32-on-tests-for-superblock-endianness.patch
char-moxac-sparse-annotation.patch
byteorder-add-new-headers-for-make-headers-install.patch
byteorder-use-generic-c-version-for-value-byteswapping.patch
lib-pull-base-guessing-logic-to-helper-function.patch
lib-trivial-whitespace-tidy.patch
lib-remove-defining-macros-for-strict_strto.patch

