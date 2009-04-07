From: akpm@linux-foundation.org
Subject: + printk-add-support-for-the-of-hh-length-modifier.patch added to -mm tree
Date: Tue, 07 Apr 2009 14:31:06 -0700
Message-ID: <200904072131.n37LV6rt006766@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39175 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755718AbZDGVdr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Apr 2009 17:33:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zhaolei@cn.fujitsu.com, fweisbec@gmail.com, laijs@cn.fujitsu.com


The patch titled
     printk: add support for the of hh length modifier
has been added to the -mm tree.  Its filename is
     printk-add-support-for-the-of-hh-length-modifier.patch

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
Subject: printk: add support for the of hh length modifier
From: Zhaolei <zhaolei@cn.fujitsu.com>

hh is used as length modifier for signed char or unsigned char.  It is
supported by glibc and is supported by ISO C99, so we add kernel support
now.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
Reviewed-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/vsprintf.c |   37 ++++++++++++++++++++++++++++++++-----
 1 file changed, 32 insertions(+), 5 deletions(-)

diff -puN lib/vsprintf.c~printk-add-support-for-the-of-hh-length-modifier lib/vsprintf.c
--- a/lib/vsprintf.c~printk-add-support-for-the-of-hh-length-modifier
+++ a/lib/vsprintf.c
@@ -408,6 +408,8 @@ enum format_type {
 	FORMAT_TYPE_LONG_LONG,
 	FORMAT_TYPE_ULONG,
 	FORMAT_TYPE_LONG,
+	FORMAT_TYPE_UBYTE,
+	FORMAT_TYPE_BYTE,
 	FORMAT_TYPE_USHORT,
 	FORMAT_TYPE_SHORT,
 	FORMAT_TYPE_UINT,
@@ -853,11 +855,15 @@ qualifier:
 	spec->qualifier = -1;
 	if (*fmt == 'h' || *fmt == 'l' || *fmt == 'L' ||
 	    *fmt == 'Z' || *fmt == 'z' || *fmt == 't') {
-		spec->qualifier = *fmt;
-		++fmt;
-		if (spec->qualifier == 'l' && *fmt == 'l') {
-			spec->qualifier = 'L';
-			++fmt;
+		spec->qualifier = *fmt++;
+		if (unlikely(spec->qualifier == *fmt)) {
+			if (spec->qualifier == 'l') {
+				spec->qualifier = 'L';
+				++fmt;
+			} else if (spec->qualifier == 'h') {
+				spec->qualifier = 'H';
+				++fmt;
+			}
 		}
 	}
 
@@ -919,6 +925,11 @@ qualifier:
 		spec->type = FORMAT_TYPE_SIZE_T;
 	} else if (spec->qualifier == 't') {
 		spec->type = FORMAT_TYPE_PTRDIFF;
+	} else if (spec->qualifier == 'H') {
+		if (spec->flags & SIGN)
+			spec->type = FORMAT_TYPE_BYTE;
+		else
+			spec->type = FORMAT_TYPE_UBYTE;
 	} else if (spec->qualifier == 'h') {
 		if (spec->flags & SIGN)
 			spec->type = FORMAT_TYPE_SHORT;
@@ -1094,6 +1105,12 @@ int vsnprintf(char *buf, size_t size, co
 			case FORMAT_TYPE_PTRDIFF:
 				num = va_arg(args, ptrdiff_t);
 				break;
+			case FORMAT_TYPE_UBYTE:
+				num = (unsigned char) va_arg(args, int);
+				break;
+			case FORMAT_TYPE_BYTE:
+				num = (signed char) va_arg(args, int);
+				break;
 			case FORMAT_TYPE_USHORT:
 				num = (unsigned short) va_arg(args, int);
 				break;
@@ -1372,6 +1389,10 @@ do {									\
 			case FORMAT_TYPE_PTRDIFF:
 				save_arg(ptrdiff_t);
 				break;
+			case FORMAT_TYPE_UBYTE:
+			case FORMAT_TYPE_BYTE:
+				save_arg(char);
+				break;
 			case FORMAT_TYPE_USHORT:
 			case FORMAT_TYPE_SHORT:
 				save_arg(short);
@@ -1554,6 +1575,12 @@ int bstr_printf(char *buf, size_t size, 
 			case FORMAT_TYPE_PTRDIFF:
 				num = get_arg(ptrdiff_t);
 				break;
+			case FORMAT_TYPE_UBYTE:
+				num = get_arg(unsigned char);
+				break;
+			case FORMAT_TYPE_BYTE:
+				num = get_arg(signed char);
+				break;
 			case FORMAT_TYPE_USHORT:
 				num = get_arg(unsigned short);
 				break;
_

Patches currently in -mm which might be from zhaolei@cn.fujitsu.com are

origin.patch
printk-add-support-for-the-of-hh-length-modifier.patch
printk-fix-wrong-format-string-iter.patch

