From: akpm@linux-foundation.org
Subject: + lib-vsprintf-optimised-put_dec-function-fix-fix.patch added to -mm tree
Date: Sat, 05 Mar 2011 12:05:47 -0800
Message-ID: <201103052006.p25K67ve029170@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52426 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752695Ab1CEUGX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 5 Mar 2011 15:06:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mina86@mina86.com, hughd@google.com, vda.linux@googlemail.com


The patch titled
     lib: vsprintf: 32-bit put_dec() fixes
has been added to the -mm tree.  Its filename is
     lib-vsprintf-optimised-put_dec-function-fix-fix.patch

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
Subject: lib: vsprintf: 32-bit put_dec() fixes
From: Michal Nazarewicz <mina86@mina86.com>

This commit fixes the 32-bit put_dec() function.

I have submitted by mistake an older version of the put_dec()
patch with a bug in it (which had been spotted by Denys and
fixed in subsequent version), which resulted in Hugh having to
find the bug once again (after experiencing boot failure).

This commit fixes the bug once and for all and introduces some
additional optimisations and comments (which were present in
the fixed version of put_dec() patch).

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
Cc: Denys Vlasenko <vda.linux@googlemail.com>
Reported-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/vsprintf.c |   49 +++++++++++++++++++++++------------------------
 1 file changed, 24 insertions(+), 25 deletions(-)

diff -puN lib/vsprintf.c~lib-vsprintf-optimised-put_dec-function-fix-fix lib/vsprintf.c
--- a/lib/vsprintf.c~lib-vsprintf-optimised-put_dec-function-fix-fix
+++ a/lib/vsprintf.c
@@ -298,7 +298,7 @@ static noinline_for_stack char *put_dec_
 	 * without any branches.
 	 */
 
-	r      = (q * (uint64_t)0xcccd) >> 19;
+	r = (q * (uint64_t)0xcccd) >> 19;
 	*buf++ = (q - 10 * r) + '0';
 
 	/*
@@ -367,7 +367,14 @@ static noinline_for_stack char *put_dec_
 	return buf;
 }
 
-/* No inlining helps gcc to use registers better */
+/*
+ * This function formats all integers correctly, however on 32-bit
+ * processors function below is used (not this one) which handles only
+ * non-zero integers.  So be advised never to call this function with
+ * num == 0.
+ *
+ * No inlining helps gcc to use registers better
+ */
 static noinline_for_stack
 char *put_dec(char *buf, unsigned long long num)
 {
@@ -434,36 +441,36 @@ char *put_dec_8bit(char *buf, unsigned q
  * permission from the author).  This performs no 64-bit division and
  * hence should be faster on 32-bit machines then the version of the
  * function above.
+ *
+ * This function formats correctly all NON-ZERO integers.  Passing
+ * zero makes daemons come out of your closet.  This is OK, since
+ * number(), which calls this function, has a special case for zero
+ * anyways.
  */
 static noinline_for_stack
 char *put_dec(char *buf, unsigned long long n)
 {
 	uint32_t d3, d2, d1, q;
 
-	if (n < 10) {
-		*buf++ = '0' + (unsigned)n;
-		return buf;
-	}
-
 	d1 = (n >> 16) & 0xFFFF;
 	d2 = (n >> 32) & 0xFFFF;
 	d3 = (n >> 48) & 0xFFFF;
 
-	q  = 656 * d3 + 7296 * d2 + 5536 * d1 + (n & 0xFFFF);
+	q = 656 * d3 + 7296 * d2 + 5536 * d1 + (n & 0xFFFF);
 
-	q  = q / 10000;
 	buf = put_dec_full4(buf, q % 10000);
+	q = q / 10000;
 
 	d1 = q + 7671 * d3 + 9496 * d2 + 6 * d1;
-	q  = d1 / 10000;
+	q = d1 / 10000;
 	buf = put_dec_full4(buf, d1 % 10000);
 
 	d2 = q + 4749 * d3 + 42 * d2;
-	q  = d2 / 10000;
+	q = d2 / 10000;
 	buf = put_dec_full4(buf, d2 % 10000);
 
 	d3 = q + 281 * d3;
-	q  = d3 / 10000;
+	q = d3 / 10000;
 	buf = put_dec_full4(buf, d3 % 10000);
 
 	buf = put_dec_full4(buf, q);
@@ -548,22 +555,14 @@ char *number(char *buf, char *end, unsig
 			spec.field_width--;
 		}
 	}
-	if (need_pfx) {
-		spec.field_width--;
-		if (spec.base == 16)
-			spec.field_width--;
-	}
+	if (need_pfx)
+		spec.field_width -= spec.base / 8;
 
 	/* generate full string in tmp[], in reverse order */
 	i = 0;
-	if (num == 0)
-		tmp[i++] = '0';
-	/* Generic code, for any base:
-	else do {
-		tmp[i++] = (digits[do_div(num,base)] | locase);
-	} while (num != 0);
-	*/
-	else if (spec.base != 10) { /* 8 or 16 */
+	if (num < 8) {
+		tmp[i++] = '0' + (char)num;
+	} else if (spec.base != 10) { /* 8 or 16 */
 		int mask = spec.base - 1;
 		int shift = 3;
 
_

Patches currently in -mm which might be from mina86@mina86.com are

linux-next.patch
lib-vsprintf-optimised-put_dec-function.patch
lib-vsprintf-optimised-put_dec-function-fix.patch
lib-vsprintf-optimised-put_dec-function-fix-fix.patch
lib-vsprintf-added-a-put_dec-test-and-benchmark-tool.patch

