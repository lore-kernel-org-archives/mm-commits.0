From: akpm@linux-foundation.org
Subject: + scanf-fix-type-range-overflow.patch added to -mm tree
Date: Thu, 09 Jul 2015 12:26:13 -0700
Message-ID: <559ecad5.mXpUf0kSNoSyfqhj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48752 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752905AbbGIT0O (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Jul 2015 15:26:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: scanf: fix type range overflow
has been added to the -mm tree.  Its filename is
     scanf-fix-type-range-overflow.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/scanf-fix-type-range-overflow.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/scanf-fix-type-range-overflow.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -2650,44 +2650,67 @@ int vsscanf(const char *buf, const char
 
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
