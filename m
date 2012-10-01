From: akpm@linux-foundation.org
Subject: + kstrto-add-documentation.patch added to -mm tree
Date: Mon, 01 Oct 2012 15:15:28 -0700
Message-ID: <20121001221528.E2C165C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:45057 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752429Ab2JAWPb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Oct 2012 18:15:31 -0400
Received: by eaaq10 with SMTP id q10so348620eaa.1
        for <mm-commits@vger.kernel.org>; Mon, 01 Oct 2012 15:15:30 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: eldad@fogrefinery.com, adobriyan@gmail.com, bfields@fieldses.org, joe@perches.com, rdunlap@xenotime.net, rob@landley.net


The patch titled
     Subject: kstrto*: add documentation
has been added to the -mm tree.  Its filename is
     kstrto-add-documentation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Eldad Zack <eldad@fogrefinery.com>
Subject: kstrto*: add documentation

As Bruce Fields pointed out, kstrto* is currently lacking kerneldoc
comments.  This patch adds kerneldoc comments to common variants of
kstrto*: kstrto(u)l, kstrto(u)ll and kstrto(u)int.

Signed-off-by: Eldad Zack <eldad@fogrefinery.com>
Cc: J. Bruce Fields <bfields@fieldses.org>
Cc: Joe Perches <joe@perches.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Rob Landley <rob@landley.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/DocBook/kernel-api.tmpl |    3 +
 include/linux/kernel.h                |   33 ++++++++++++
 lib/kstrtox.c                         |   64 ++++++++++++++++++++++++
 3 files changed, 100 insertions(+)

diff -puN Documentation/DocBook/kernel-api.tmpl~kstrto-add-documentation Documentation/DocBook/kernel-api.tmpl
--- a/Documentation/DocBook/kernel-api.tmpl~kstrto-add-documentation
+++ a/Documentation/DocBook/kernel-api.tmpl
@@ -58,6 +58,9 @@
 
      <sect1><title>String Conversions</title>
 !Elib/vsprintf.c
+!Finclude/linux/kernel.h kstrtol
+!Finclude/linux/kernel.h kstrtoul
+!Elib/kstrtox.c
      </sect1>
      <sect1><title>String Manipulation</title>
 <!-- All functions are exported at now
diff -puN include/linux/kernel.h~kstrto-add-documentation include/linux/kernel.h
--- a/include/linux/kernel.h~kstrto-add-documentation
+++ a/include/linux/kernel.h
@@ -228,6 +228,23 @@ int __must_check _kstrtol(const char *s,
 
 int __must_check kstrtoull(const char *s, unsigned int base, unsigned long long *res);
 int __must_check kstrtoll(const char *s, unsigned int base, long long *res);
+
+/**
+ * kstrtoul - convert a string to an unsigned long
+ * @s: The start of the string. The string must be null-terminated, and may also
+ *  include a single newline before its terminating null. The first character
+ *  may also be a plus sign, but not a minus sign.
+ * @base: The number base to use. The maximum supported base is 16. If base is
+ *  given as 0, then the base of the string is automatically detected with the
+ *  conventional semantics - If it begins with 0x the number will be parsed as a
+ *  hexadecimal (case insensitive), if it otherwise begins with 0, it will be
+ *  parsed as an octal number. Otherwise it will be parsed as a decimal.
+ * @res: Where to write the result of the conversion on success.
+ *
+ * Returns 0 on success, -ERANGE on overflow and -EINVAL on parsing error.
+ * Used as a replacement for the obsolete simple_strtoull. Return code must
+ * be checked.
+*/
 static inline int __must_check kstrtoul(const char *s, unsigned int base, unsigned long *res)
 {
 	/*
@@ -241,6 +258,22 @@ static inline int __must_check kstrtoul(
 		return _kstrtoul(s, base, res);
 }
 
+/**
+ * kstrtol - convert a string to a long
+ * @s: The start of the string. The string must be null-terminated, and may also
+ *  include a single newline before its terminating null. The first character
+ *  may also be a plus sign or a minus sign.
+ * @base: The number base to use. The maximum supported base is 16. If base is
+ *  given as 0, then the base of the string is automatically detected with the
+ *  conventional semantics - If it begins with 0x the number will be parsed as a
+ *  hexadecimal (case insensitive), if it otherwise begins with 0, it will be
+ *  parsed as an octal number. Otherwise it will be parsed as a decimal.
+ * @res: Where to write the result of the conversion on success.
+ *
+ * Returns 0 on success, -ERANGE on overflow and -EINVAL on parsing error.
+ * Used as a replacement for the obsolete simple_strtoull. Return code must
+ * be checked.
+ */
 static inline int __must_check kstrtol(const char *s, unsigned int base, long *res)
 {
 	/*
diff -puN lib/kstrtox.c~kstrto-add-documentation lib/kstrtox.c
--- a/lib/kstrtox.c~kstrto-add-documentation
+++ a/lib/kstrtox.c
@@ -104,6 +104,22 @@ static int _kstrtoull(const char *s, uns
 	return 0;
 }
 
+/**
+ * kstrtoull - convert a string to an unsigned long long
+ * @s: The start of the string. The string must be null-terminated, and may also
+ *  include a single newline before its terminating null. The first character
+ *  may also be a plus sign, but not a minus sign.
+ * @base: The number base to use. The maximum supported base is 16. If base is
+ *  given as 0, then the base of the string is automatically detected with the
+ *  conventional semantics - If it begins with 0x the number will be parsed as a
+ *  hexadecimal (case insensitive), if it otherwise begins with 0, it will be
+ *  parsed as an octal number. Otherwise it will be parsed as a decimal.
+ * @res: Where to write the result of the conversion on success.
+ *
+ * Returns 0 on success, -ERANGE on overflow and -EINVAL on parsing error.
+ * Used as a replacement for the obsolete simple_strtoull. Return code must
+ * be checked.
+ */
 int kstrtoull(const char *s, unsigned int base, unsigned long long *res)
 {
 	if (s[0] == '+')
@@ -112,6 +128,22 @@ int kstrtoull(const char *s, unsigned in
 }
 EXPORT_SYMBOL(kstrtoull);
 
+/**
+ * kstrtoll - convert a string to a long long
+ * @s: The start of the string. The string must be null-terminated, and may also
+ *  include a single newline before its terminating null. The first character
+ *  may also be a plus sign or a minus sign.
+ * @base: The number base to use. The maximum supported base is 16. If base is
+ *  given as 0, then the base of the string is automatically detected with the
+ *  conventional semantics - If it begins with 0x the number will be parsed as a
+ *  hexadecimal (case insensitive), if it otherwise begins with 0, it will be
+ *  parsed as an octal number. Otherwise it will be parsed as a decimal.
+ * @res: Where to write the result of the conversion on success.
+ *
+ * Returns 0 on success, -ERANGE on overflow and -EINVAL on parsing error.
+ * Used as a replacement for the obsolete simple_strtoull. Return code must
+ * be checked.
+ */
 int kstrtoll(const char *s, unsigned int base, long long *res)
 {
 	unsigned long long tmp;
@@ -168,6 +200,22 @@ int _kstrtol(const char *s, unsigned int
 }
 EXPORT_SYMBOL(_kstrtol);
 
+/**
+ * kstrtouint - convert a string to an unsigned int
+ * @s: The start of the string. The string must be null-terminated, and may also
+ *  include a single newline before its terminating null. The first character
+ *  may also be a plus sign, but not a minus sign.
+ * @base: The number base to use. The maximum supported base is 16. If base is
+ *  given as 0, then the base of the string is automatically detected with the
+ *  conventional semantics - If it begins with 0x the number will be parsed as a
+ *  hexadecimal (case insensitive), if it otherwise begins with 0, it will be
+ *  parsed as an octal number. Otherwise it will be parsed as a decimal.
+ * @res: Where to write the result of the conversion on success.
+ *
+ * Returns 0 on success, -ERANGE on overflow and -EINVAL on parsing error.
+ * Used as a replacement for the obsolete simple_strtoull. Return code must
+ * be checked.
+ */
 int kstrtouint(const char *s, unsigned int base, unsigned int *res)
 {
 	unsigned long long tmp;
@@ -183,6 +231,22 @@ int kstrtouint(const char *s, unsigned i
 }
 EXPORT_SYMBOL(kstrtouint);
 
+/**
+ * kstrtoint - convert a string to an int
+ * @s: The start of the string. The string must be null-terminated, and may also
+ *  include a single newline before its terminating null. The first character
+ *  may also be a plus sign or a minus sign.
+ * @base: The number base to use. The maximum supported base is 16. If base is
+ *  given as 0, then the base of the string is automatically detected with the
+ *  conventional semantics - If it begins with 0x the number will be parsed as a
+ *  hexadecimal (case insensitive), if it otherwise begins with 0, it will be
+ *  parsed as an octal number. Otherwise it will be parsed as a decimal.
+ * @res: Where to write the result of the conversion on success.
+ *
+ * Returns 0 on success, -ERANGE on overflow and -EINVAL on parsing error.
+ * Used as a replacement for the obsolete simple_strtoull. Return code must
+ * be checked.
+ */
 int kstrtoint(const char *s, unsigned int base, int *res)
 {
 	long long tmp;
_

Patches currently in -mm which might be from eldad@fogrefinery.com are

kstrto-add-documentation.patch
simple_strto-annotate-function-as-obsolete.patch

