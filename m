From: akpm@linux-foundation.org
Subject: +
 lib-bitmapc-bitmap_parselist-can-accept-string-with-whitespaces-on-head-or-tail.patch added to -mm tree
Date: Tue, 14 Jul 2015 15:30:32 -0700
Message-ID: <55a58d88.t2cpk2gYO6c1pEHN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43281 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241AbbGNWad (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Jul 2015 18:30:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xinhuix.pan@intel.com, cmetcalf@ezchip.com, linux@rasmusvillemoes.dk, sudeep.holla@arm.com, yury.norov@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/bitmap.c: bitmap_parselist can accept string with whitespaces on head or tail
has been added to the -mm tree.  Its filename is
     lib-bitmapc-bitmap_parselist-can-accept-string-with-whitespaces-on-head-or-tail.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-bitmapc-bitmap_parselist-can-accept-string-with-whitespaces-on-head-or-tail.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-bitmapc-bitmap_parselist-can-accept-string-with-whitespaces-on-head-or-tail.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Pan Xinhui <xinhuix.pan@intel.com>
Subject: lib/bitmap.c: bitmap_parselist can accept string with whitespaces on head or tail

In __bitmap_parselist we can accept whitespaces on head or tail during
every parsing procedure.  If input has valid ranges, there is no reason to
reject the user.

For example, bitmap_parselist(" 1-3, 5, ", &mask, nmaskbits).  After
separating the string, we get " 1-3", " 5", and " ".  It's possible and
reasonable to accept such string as long as the parsing result is correct.

Signed-off-by: Pan Xinhui <xinhuix.pan@intel.com>
Cc: Yury Norov <yury.norov@gmail.com>
Cc: Chris Metcalf <cmetcalf@ezchip.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/bitmap.c |   32 ++++++++++++++++++--------------
 1 file changed, 18 insertions(+), 14 deletions(-)

diff -puN lib/bitmap.c~lib-bitmapc-bitmap_parselist-can-accept-string-with-whitespaces-on-head-or-tail lib/bitmap.c
--- a/lib/bitmap.c~lib-bitmapc-bitmap_parselist-can-accept-string-with-whitespaces-on-head-or-tail
+++ a/lib/bitmap.c
@@ -506,7 +506,7 @@ static int __bitmap_parselist(const char
 		int nmaskbits)
 {
 	unsigned a, b;
-	int c, old_c, totaldigits;
+	int c, old_c, totaldigits, ndigits;
 	const char __user __force *ubuf = (const char __user __force *)buf;
 	int at_start, in_range;
 
@@ -516,6 +516,7 @@ static int __bitmap_parselist(const char
 		at_start = 1;
 		in_range = 0;
 		a = b = 0;
+		ndigits = totaldigits;
 
 		/* Get the next cpu# or a range of cpu#'s */
 		while (buflen) {
@@ -529,17 +530,20 @@ static int __bitmap_parselist(const char
 			if (isspace(c))
 				continue;
 
-			/*
-			 * If the last character was a space and the current
-			 * character isn't '\0', we've got embedded whitespace.
-			 * This is a no-no, so throw an error.
-			 */
-			if (totaldigits && c && isspace(old_c))
-				return -EINVAL;
-
 			/* A '\0' or a ',' signal the end of a cpu# or range */
 			if (c == '\0' || c == ',')
 				break;
+			/*
+			* whitespaces between digits are not allowed,
+			* but it's ok if whitespaces are on head or tail.
+			* when old_c is whilespace,
+			* if totaldigits == ndigits, whitespace is on head.
+			* if whitespace is on tail, it should not run here.
+			* as c was ',' or '\0',
+			* the last code line has broken the current loop.
+			*/
+			if ((totaldigits != ndigits) && isspace(old_c))
+				return -EINVAL;
 
 			if (c == '-') {
 				if (at_start || in_range)
@@ -559,6 +563,8 @@ static int __bitmap_parselist(const char
 			at_start = 0;
 			totaldigits++;
 		}
+		if (ndigits == totaldigits)
+			continue;
 		/* if no digit is after '-', it's wrong*/
 		if (at_start && in_range)
 			return -EINVAL;
@@ -566,11 +572,9 @@ static int __bitmap_parselist(const char
 			return -EINVAL;
 		if (b >= nmaskbits)
 			return -ERANGE;
-		if (!at_start) {
-			while (a <= b) {
-				set_bit(a, maskp);
-				a++;
-			}
+		while (a <= b) {
+			set_bit(a, maskp);
+			a++;
 		}
 	} while (buflen && c == ',');
 	return 0;
_

Patches currently in -mm which might be from xinhuix.pan@intel.com are

lib-bitmapc-correct-a-code-style-and-do-some-optimization.patch
lib-bitmapc-fix-a-special-string-handling-bug-in-__bitmap_parselist.patch
lib-bitmapc-bitmap_parselist-can-accept-string-with-whitespaces-on-head-or-tail.patch
linux-next.patch

