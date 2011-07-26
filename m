From: akpm@linux-foundation.org
Subject: [merged] lib-make-_tolower-public.patch removed from -mm tree
Date: Tue, 26 Jul 2011 00:55:57 -0700
Message-ID: <201107260755.p6Q7t07M003405@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41252 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752840Ab1GZHzu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jul 2011 03:55:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     lib: make _tolower() public
has been removed from the -mm tree.  Its filename was
     lib-make-_tolower-public.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lib: make _tolower() public
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

This function is required by *printf and kstrto* functions that are
located in the different modules.  This patch makes _tolower() public. 
However, it's good idea to not use the helper outside of mentioned
functions.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ctype.h |    9 +++++++++
 lib/kstrtox.c         |    5 -----
 lib/vsprintf.c        |   23 ++++++++++-------------
 3 files changed, 19 insertions(+), 18 deletions(-)

diff -puN include/linux/ctype.h~lib-make-_tolower-public include/linux/ctype.h
--- a/include/linux/ctype.h~lib-make-_tolower-public
+++ a/include/linux/ctype.h
@@ -52,4 +52,13 @@ static inline unsigned char __toupper(un
 #define tolower(c) __tolower(c)
 #define toupper(c) __toupper(c)
 
+/*
+ * Fast implementation of tolower() for internal usage. Do not use in your
+ * code.
+ */
+static inline char _tolower(const char c)
+{
+	return c | 0x20;
+}
+
 #endif
diff -puN lib/kstrtox.c~lib-make-_tolower-public lib/kstrtox.c
--- a/lib/kstrtox.c~lib-make-_tolower-public
+++ a/lib/kstrtox.c
@@ -19,11 +19,6 @@
 #include <linux/types.h>
 #include <asm/uaccess.h>
 
-static inline char _tolower(const char c)
-{
-	return c | 0x20;
-}
-
 static int _kstrtoull(const char *s, unsigned int base, unsigned long long *res)
 {
 	unsigned long long acc;
diff -puN lib/vsprintf.c~lib-make-_tolower-public lib/vsprintf.c
--- a/lib/vsprintf.c~lib-make-_tolower-public
+++ a/lib/vsprintf.c
@@ -31,13 +31,10 @@
 #include <asm/div64.h>
 #include <asm/sections.h>	/* for dereference_function_descriptor() */
 
-/* Works only for digits and letters, but small and fast */
-#define TOLOWER(x) ((x) | 0x20)
-
 static unsigned int simple_guess_base(const char *cp)
 {
 	if (cp[0] == '0') {
-		if (TOLOWER(cp[1]) == 'x' && isxdigit(cp[2]))
+		if (_tolower(cp[1]) == 'x' && isxdigit(cp[2]))
 			return 16;
 		else
 			return 8;
@@ -59,13 +56,13 @@ unsigned long long simple_strtoull(const
 	if (!base)
 		base = simple_guess_base(cp);
 
-	if (base == 16 && cp[0] == '0' && TOLOWER(cp[1]) == 'x')
+	if (base == 16 && cp[0] == '0' && _tolower(cp[1]) == 'x')
 		cp += 2;
 
 	while (isxdigit(*cp)) {
 		unsigned int value;
 
-		value = isdigit(*cp) ? *cp - '0' : TOLOWER(*cp) - 'a' + 10;
+		value = isdigit(*cp) ? *cp - '0' : _tolower(*cp) - 'a' + 10;
 		if (value >= base)
 			break;
 		result = result * base + value;
@@ -1036,8 +1033,8 @@ precision:
 qualifier:
 	/* get the conversion qualifier */
 	spec->qualifier = -1;
-	if (*fmt == 'h' || TOLOWER(*fmt) == 'l' ||
-	    TOLOWER(*fmt) == 'z' || *fmt == 't') {
+	if (*fmt == 'h' || _tolower(*fmt) == 'l' ||
+	    _tolower(*fmt) == 'z' || *fmt == 't') {
 		spec->qualifier = *fmt++;
 		if (unlikely(spec->qualifier == *fmt)) {
 			if (spec->qualifier == 'l') {
@@ -1104,7 +1101,7 @@ qualifier:
 			spec->type = FORMAT_TYPE_LONG;
 		else
 			spec->type = FORMAT_TYPE_ULONG;
-	} else if (TOLOWER(spec->qualifier) == 'z') {
+	} else if (_tolower(spec->qualifier) == 'z') {
 		spec->type = FORMAT_TYPE_SIZE_T;
 	} else if (spec->qualifier == 't') {
 		spec->type = FORMAT_TYPE_PTRDIFF;
@@ -1263,7 +1260,7 @@ int vsnprintf(char *buf, size_t size, co
 			if (qualifier == 'l') {
 				long *ip = va_arg(args, long *);
 				*ip = (str - buf);
-			} else if (TOLOWER(qualifier) == 'z') {
+			} else if (_tolower(qualifier) == 'z') {
 				size_t *ip = va_arg(args, size_t *);
 				*ip = (str - buf);
 			} else {
@@ -1550,7 +1547,7 @@ do {									\
 			void *skip_arg;
 			if (qualifier == 'l')
 				skip_arg = va_arg(args, long *);
-			else if (TOLOWER(qualifier) == 'z')
+			else if (_tolower(qualifier) == 'z')
 				skip_arg = va_arg(args, size_t *);
 			else
 				skip_arg = va_arg(args, int *);
@@ -1856,8 +1853,8 @@ int vsscanf(const char *buf, const char 
 
 		/* get conversion qualifier */
 		qualifier = -1;
-		if (*fmt == 'h' || TOLOWER(*fmt) == 'l' ||
-		    TOLOWER(*fmt) == 'z') {
+		if (*fmt == 'h' || _tolower(*fmt) == 'l' ||
+		    _tolower(*fmt) == 'z') {
 			qualifier = *fmt++;
 			if (unlikely(qualifier == *fmt)) {
 				if (qualifier == 'h') {
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

origin.patch
selinuxfs-remove-custome-hex_to_bin.patch

