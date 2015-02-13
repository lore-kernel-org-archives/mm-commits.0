From: akpm@linux-foundation.org
Subject: [merged] lib-vsprintfc-consume-p-in-format_decode.patch removed
 from -mm tree
Date: Fri, 13 Feb 2015 12:22:02 -0800
Message-ID: <54de5cea.crslawmQD7DNKheG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49083 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752805AbbBMUWD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Feb 2015 15:22:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, jkosina@suse.cz, rdunlap@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/vsprintf.c: consume 'p' in format_decode
has been removed from the -mm tree.  Its filename was
     lib-vsprintfc-consume-p-in-format_decode.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: lib/vsprintf.c: consume 'p' in format_decode

It seems a little simpler to consume the p from a %p specifier in
format_decode, just as it is done for the surrounding %c, %s and %% cases.

While there, delete a redundant and misplaced comment.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/vsprintf.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN lib/vsprintf.c~lib-vsprintfc-consume-p-in-format_decode lib/vsprintf.c
--- a/lib/vsprintf.c~lib-vsprintfc-consume-p-in-format_decode
+++ a/lib/vsprintf.c
@@ -1604,8 +1604,7 @@ qualifier:
 
 	case 'p':
 		spec->type = FORMAT_TYPE_PTR;
-		return fmt - start;
-		/* skip alnum */
+		return ++fmt - start;
 
 	case '%':
 		spec->type = FORMAT_TYPE_PERCENT_CHAR;
@@ -1794,7 +1793,7 @@ int vsnprintf(char *buf, size_t size, co
 			break;
 
 		case FORMAT_TYPE_PTR:
-			str = pointer(fmt+1, str, end, va_arg(args, void *),
+			str = pointer(fmt, str, end, va_arg(args, void *),
 				      spec);
 			while (isalnum(*fmt))
 				fmt++;
@@ -2232,7 +2231,7 @@ int bstr_printf(char *buf, size_t size,
 		}
 
 		case FORMAT_TYPE_PTR:
-			str = pointer(fmt+1, str, end, get_arg(void *), spec);
+			str = pointer(fmt, str, end, get_arg(void *), spec);
 			while (isalnum(*fmt))
 				fmt++;
 			break;
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

origin.patch
lib-bitmapc-change-prototype-of-bitmap_copy_le.patch
lib-bitmapc-elide-bitmap_copy_le-on-little-endian.patch
lib-bitmap-change-bitmap_shift_right-to-take-unsigned-parameters.patch
lib-bitmap-eliminate-branch-in-__bitmap_shift_right.patch
lib-bitmap-remove-redundant-code-from-__bitmap_shift_right.patch
lib-bitmap-yet-another-simplification-in-__bitmap_shift_right.patch
lib-bitmap-change-bitmap_shift_left-to-take-unsigned-parameters.patch
lib-bitmap-eliminate-branch-in-__bitmap_shift_left.patch
lib-bitmap-remove-redundant-code-from-__bitmap_shift_left.patch
lib-stringc-improve-strrchr.patch
checkpatch-emit-an-error-when-using-predefined-timestamp-macros.patch
linux-next.patch

