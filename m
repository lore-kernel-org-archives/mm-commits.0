From: akpm@linux-foundation.org
Subject: + sscanf-dont-ignore-field-widths-for-numeric-conversions.patch added to -mm tree
Date: Mon, 05 Nov 2012 12:19:25 -0800
Message-ID: <20121105201926.09FA6200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-la0-f74.google.com ([209.85.215.74]:33236 "EHLO
	mail-la0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753786Ab2KEUT3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Nov 2012 15:19:29 -0500
Received: by mail-la0-f74.google.com with SMTP id j13so401388lah.1
        for <mm-commits@vger.kernel.org>; Mon, 05 Nov 2012 12:19:27 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: JBeulich@suse.com, adobriyan@gmail.com, jbeulich@suse.com


The patch titled
     Subject: sscanf: don't ignore field widths for numeric conversions
has been added to the -mm tree.  Its filename is
     sscanf-dont-ignore-field-widths-for-numeric-conversions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -2013,7 +2013,11 @@ int vsscanf(const char *buf, const char 
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
 
@@ -2053,8 +2057,11 @@ int vsscanf(const char *buf, const char 
 
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
@@ -2154,58 +2161,61 @@ int vsscanf(const char *buf, const char 
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

linux-next.patch
sscanf-dont-ignore-field-widths-for-numeric-conversions.patch

