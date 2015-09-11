From: akpm@linux-foundation.org
Subject: [merged]
 lib-string_helpers-clarify-esc-arg-in-string_escape_mem.patch removed from
 -mm tree
Date: Fri, 11 Sep 2015 11:12:01 -0700
Message-ID: <55f31971.NZPWzixL1Vd8PvBC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53766 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426AbbIKSMC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 11 Sep 2015 14:12:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, James.Bottomley@HansenPartnership.com, andriy.shevchenko@linux.intel.com, linux@rasmusvillemoes.dk, minipli@googlemail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/string_helpers: clarify esc arg in string_escape_mem
has been removed from the -mm tree.  Its filename was
     lib-string_helpers-clarify-esc-arg-in-string_escape_mem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: lib/string_helpers: clarify esc arg in string_escape_mem

The esc argument is used to reduce which characters will be escaped.  For
example, using " " with ESCAPE_SPACE will not produce any escaped spaces.

Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Mathias Krause <minipli@googlemail.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/string_helpers.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN lib/string_helpers.c~lib-string_helpers-clarify-esc-arg-in-string_escape_mem lib/string_helpers.c
--- a/lib/string_helpers.c~lib-string_helpers-clarify-esc-arg-in-string_escape_mem
+++ a/lib/string_helpers.c
@@ -410,7 +410,7 @@ static bool escape_hex(unsigned char c,
  * @dst:	destination buffer (escaped)
  * @osz:	destination buffer size
  * @flags:	combination of the flags (bitwise OR):
- *	%ESCAPE_SPACE:
+ *	%ESCAPE_SPACE: (special white space, not space itself)
  *		'\f' - form feed
  *		'\n' - new line
  *		'\r' - carriage return
@@ -432,8 +432,10 @@ static bool escape_hex(unsigned char c,
  *		all previous together
  *	%ESCAPE_HEX:
  *		'\xHH' - byte with hexadecimal value HH (2 digits)
- * @esc:	NULL-terminated string of characters any of which, if found in
- *		the source, has to be escaped
+ * @esc:	NULL-terminated string containing characters used to limit
+ *		the selected escape class. If characters are included in @esc
+ *		that would not normally be escaped by the classes selected
+ *		in @flags, they will be copied to @dst unescaped.
  *
  * Description:
  * The process of escaping byte buffer includes several parts. They are applied
@@ -441,7 +443,7 @@ static bool escape_hex(unsigned char c,
  *	1. The character is matched to the printable class, if asked, and in
  *	   case of match it passes through to the output.
  *	2. The character is not matched to the one from @esc string and thus
- *	   must go as is to the output.
+ *	   must go as-is to the output.
  *	3. The character is checked if it falls into the class given by @flags.
  *	   %ESCAPE_OCTAL and %ESCAPE_HEX are going last since they cover any
  *	   character. Note that they actually can't go together, otherwise
_

Patches currently in -mm which might be from keescook@chromium.org are


