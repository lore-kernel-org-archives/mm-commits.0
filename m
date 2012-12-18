From: akpm@linux-foundation.org
Subject: [merged] sscanf-dont-ignore-field-widths-for-numeric-conversions.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:06:18 -0800
Message-ID: <20121218200618.ADA7482004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:54743 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754994Ab2LRUGU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:06:20 -0500
Received: by mail-vc0-f201.google.com with SMTP id p1so125522vcq.4
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:06:19 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: JBeulich@suse.com, adobriyan@gmail.com, jbeulich@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: sscanf: don't ignore field widths for numeric conversions
has been removed from the -mm tree.  Its filename was
     sscanf-dont-ignore-field-widths-for-numeric-conversions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Jan Beulich" <JBeulich@suse.com>
Subject: sscanf: don't ignore field widths for numeric conversions

This is another step towards better standard conformance.  Rather than
adding a local buffer to store the specified portion of the string (with
the need to enforce an arbitrary maximum supported width to limit the
buffer size), do a maximum width conversion and then drop as much of it as
is necessary to meet the caller's request.

Also fail on negative field widths.

Uses the deprecated simple_strto*() functions because kstrtoXX() fail on
non-zero terminated strings.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/vsprintf.c |   96 +++++++++++++++++++++++++----------------------
 1 file changed, 53 insertions(+), 43 deletions(-)

diff -puN lib/vsprintf.c~sscanf-dont-ignore-field-widths-for-numeric-conversions lib/vsprintf.c
--- a/lib/vsprintf.c~sscanf-dont-ignore-field-widths-for-numeric-conversions
+++ a/lib/vsprintf.c
@@ -23,12 +23,12 @@
 #include <linux/ctype.h>
 #include <linux/kernel.h>
 #include <linux/kallsyms.h>
+#include <linux/math64.h>
 #include <linux/uaccess.h>
 #include <linux/ioport.h>
 #include <net/addrconf.h>
 
 #include <asm/page.h>		/* for PAGE_SIZE */
-#include <asm/div64.h>
 #include <asm/sections.h>	/* for dereference_function_descriptor() */
 
 #include "kstrtox.h"
@@ -2016,7 +2016,11 @@ int vsscanf(const char *buf, const char 
 	char digit;
 	int num = 0;
 	u8 qualifier;
-	u8 base;
+	unsigned int base;
+	union {
+		long long s;
+		unsigned long long u;
+	} val;
 	s16 field_width;
 	bool is_sign;
 
@@ -2056,8 +2060,11 @@ int vsscanf(const char *buf, const char 
 
 		/* get field width */
 		field_width = -1;
-		if (isdigit(*fmt))
+		if (isdigit(*fmt)) {
 			field_width = skip_atoi(&fmt);
+			if (field_width <= 0)
+				break;
+		}
 
 		/* get conversion qualifier */
 		qualifier = -1;
@@ -2157,58 +2164,61 @@ int vsscanf(const char *buf, const char 
 		    || (base == 0 && !isdigit(digit)))
 			break;
 
+		if (is_sign)
+			val.s = qualifier != 'L' ?
+				simple_strtol(str, &next, base) :
+				simple_strtoll(str, &next, base);
+		else
+			val.u = qualifier != 'L' ?
+				simple_strtoul(str, &next, base) :
+				simple_strtoull(str, &next, base);
+
+		if (field_width > 0 && next - str > field_width) {
+			if (base == 0)
+				_parse_integer_fixup_radix(str, &base);
+			while (next - str > field_width) {
+				if (is_sign)
+					val.s = div_s64(val.s, base);
+				else
+					val.u = div_u64(val.u, base);
+				--next;
+			}
+		}
+
 		switch (qualifier) {
 		case 'H':	/* that's 'hh' in format */
-			if (is_sign) {
-				signed char *s = (signed char *)va_arg(args, signed char *);
-				*s = (signed char)simple_strtol(str, &next, base);
-			} else {
-				unsigned char *s = (unsigned char *)va_arg(args, unsigned char *);
-				*s = (unsigned char)simple_strtoul(str, &next, base);
-			}
+			if (is_sign)
+				*va_arg(args, signed char *) = val.s;
+			else
+				*va_arg(args, unsigned char *) = val.u;
 			break;
 		case 'h':
-			if (is_sign) {
-				short *s = (short *)va_arg(args, short *);
-				*s = (short)simple_strtol(str, &next, base);
-			} else {
-				unsigned short *s = (unsigned short *)va_arg(args, unsigned short *);
-				*s = (unsigned short)simple_strtoul(str, &next, base);
-			}
+			if (is_sign)
+				*va_arg(args, short *) = val.s;
+			else
+				*va_arg(args, unsigned short *) = val.u;
 			break;
 		case 'l':
-			if (is_sign) {
-				long *l = (long *)va_arg(args, long *);
-				*l = simple_strtol(str, &next, base);
-			} else {
-				unsigned long *l = (unsigned long *)va_arg(args, unsigned long *);
-				*l = simple_strtoul(str, &next, base);
-			}
+			if (is_sign)
+				*va_arg(args, long *) = val.s;
+			else
+				*va_arg(args, unsigned long *) = val.u;
 			break;
 		case 'L':
-			if (is_sign) {
-				long long *l = (long long *)va_arg(args, long long *);
-				*l = simple_strtoll(str, &next, base);
-			} else {
-				unsigned long long *l = (unsigned long long *)va_arg(args, unsigned long long *);
-				*l = simple_strtoull(str, &next, base);
-			}
+			if (is_sign)
+				*va_arg(args, long long *) = val.s;
+			else
+				*va_arg(args, unsigned long long *) = val.u;
 			break;
 		case 'Z':
 		case 'z':
-		{
-			size_t *s = (size_t *)va_arg(args, size_t *);
-			*s = (size_t)simple_strtoul(str, &next, base);
-		}
-		break;
+			*va_arg(args, size_t *) = val.u;
+			break;
 		default:
-			if (is_sign) {
-				int *i = (int *)va_arg(args, int *);
-				*i = (int)simple_strtol(str, &next, base);
-			} else {
-				unsigned int *i = (unsigned int *)va_arg(args, unsigned int*);
-				*i = (unsigned int)simple_strtoul(str, &next, base);
-			}
+			if (is_sign)
+				*va_arg(args, int *) = val.s;
+			else
+				*va_arg(args, unsigned int *) = val.u;
 			break;
 		}
 		num++;
_

Patches currently in -mm which might be from JBeulich@suse.com are

origin.patch
linux-next.patch

