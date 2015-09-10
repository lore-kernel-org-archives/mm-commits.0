From: akpm@linux-foundation.org
Subject: [nacked] scanf-fix-type-range-overflow.patch removed from -mm
 tree
Date: Thu, 10 Sep 2015 13:40:42 -0700
Message-ID: <55f1eaca.MWn4s3Qn4drQ7Beh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35482 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007AbbIJUkn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 10 Sep 2015 16:40:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: scanf: fix type range overflow
has been removed from the -mm tree.  Its filename was
     scanf-fix-type-range-overflow.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: scanf: fix type range overflow

Fun fact:

	uint8_t val;
	sscanf("256", "%hhu", &val);

will return 1 and make val=0 (clearly bogus).

Userspace sscanf() reports 1 parsed value, returns incorrect value
but sets errno to ERANGE only for "%u" conversion and higher.
%hhu and %hu are left in the cold.

Having no way to report errno=ERANGE in kernel, don't report
successful parsing.

Patch allows to remove checks and switch to proper types
in several (most?) cases:

	grep -e 'scanf.*%[0-9]\+[dioux]' -n -r .

Such checks can be incorrect too -- checking for 3 digits with %3u
for parsing uint8_t is not enough.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/vsprintf.c |   45 ++++++++++++++++++++++++++++++++++-----------
 1 file changed, 34 insertions(+), 11 deletions(-)

diff -puN lib/vsprintf.c~scanf-fix-type-range-overflow lib/vsprintf.c
--- a/lib/vsprintf.c~scanf-fix-type-range-overflow
+++ a/lib/vsprintf.c
@@ -2633,44 +2633,67 @@ int vsscanf(const char *buf, const char
 
 		switch (qualifier) {
 		case 'H':	/* that's 'hh' in format */
-			if (is_sign)
+			if (is_sign) {
+				if (val.s != (signed char)val.s)
+					goto out;
 				*va_arg(args, signed char *) = val.s;
-			else
+			} else {
+				if (val.u != (unsigned char)val.u)
+					goto out;
 				*va_arg(args, unsigned char *) = val.u;
+			}
 			break;
 		case 'h':
-			if (is_sign)
+			if (is_sign) {
+				if (val.s != (short)val.s)
+					goto out;
 				*va_arg(args, short *) = val.s;
-			else
+			} else {
+				if (val.u != (unsigned short)val.u)
+					goto out;
 				*va_arg(args, unsigned short *) = val.u;
+			}
 			break;
 		case 'l':
-			if (is_sign)
+			if (is_sign) {
+				if (val.s != (long)val.s)
+					goto out;
 				*va_arg(args, long *) = val.s;
-			else
+			} else {
+				if (val.u != (unsigned long)val.u)
+					goto out;
 				*va_arg(args, unsigned long *) = val.u;
+			}
 			break;
 		case 'L':
-			if (is_sign)
+			if (is_sign) {
 				*va_arg(args, long long *) = val.s;
-			else
+			} else {
 				*va_arg(args, unsigned long long *) = val.u;
+			}
 			break;
 		case 'Z':
 		case 'z':
+			if (val.u != (size_t)val.u)
+				goto out;
 			*va_arg(args, size_t *) = val.u;
 			break;
 		default:
-			if (is_sign)
+			if (is_sign) {
+				if (val.s != (int)val.s)
+					goto out;
 				*va_arg(args, int *) = val.s;
-			else
+			} else {
+				if (val.u != (unsigned int)val.u)
+					goto out;
 				*va_arg(args, unsigned int *) = val.u;
+			}
 			break;
 		}
 		num++;
 		str += len;
 	}
