From: akpm@linux-foundation.org
Subject: [merged] lib-vsprintfc-eliminate-some-branches.patch removed from -mm tree
Date: Thu, 16 Apr 2015 09:54:39 -0700
Message-ID: <552fe94f.b8TonwRTsX29HVKi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43106 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753972AbbDPQtL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Apr 2015 12:49:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, a.p.zijlstra@chello.nl, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/vsprintf.c: eliminate some branches
has been removed from the -mm tree.  Its filename was
     lib-vsprintfc-eliminate-some-branches.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: lib/vsprintf.c: eliminate some branches

Since FORMAT_TYPE_INT is simply 1 more than FORMAT_TYPE_UINT, and
similarly for BYTE/UBYTE, SHORT/USHORT, LONG/ULONG, we can eliminate a few
instructions by making SIGN have the value 1 instead of 2, and then use
arithmetic instead of branches for computing the right spec->type.  It's a
little hacky, but certainly in the same spirit as SMALL needing to have
the value 0x20.  For example for the spec->qualifier == 'l' case, gcc now
generates

     75e:       0f b6 53 01             movzbl 0x1(%rbx),%edx
     762:       83 e2 01                and    $0x1,%edx
     765:       83 c2 09                add    $0x9,%edx
     768:       88 13                   mov    %dl,(%rbx)

instead of

     763:       0f b6 53 01             movzbl 0x1(%rbx),%edx
     767:       83 e2 02                and    $0x2,%edx
     76a:       80 fa 01                cmp    $0x1,%dl
     76d:       19 d2                   sbb    %edx,%edx
     76f:       83 c2 0a                add    $0xa,%edx
     772:       88 13                   mov    %dl,(%rbx)

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/vsprintf.c |   30 +++++++++++-------------------
 1 file changed, 11 insertions(+), 19 deletions(-)

diff -puN lib/vsprintf.c~lib-vsprintfc-eliminate-some-branches lib/vsprintf.c
--- a/lib/vsprintf.c~lib-vsprintfc-eliminate-some-branches
+++ a/lib/vsprintf.c
@@ -340,8 +340,8 @@ int num_to_str(char *buf, int size, unsi
 	return len;
 }
 
-#define ZEROPAD	1		/* pad with zero */
-#define SIGN	2		/* unsigned/signed long */
+#define SIGN	1		/* unsigned/signed, must be 1 */
+#define ZEROPAD	2		/* pad with zero */
 #define PLUS	4		/* show plus */
 #define SPACE	8		/* space if plus */
 #define LEFT	16		/* left justified */
@@ -447,7 +447,7 @@ char *number(char *buf, char *end, unsig
 		spec.precision = i;
 	/* leading space padding */
 	spec.field_width -= spec.precision;
-	if (!(spec.flags & (ZEROPAD+LEFT))) {
+	if (!(spec.flags & (ZEROPAD | LEFT))) {
 		while (--spec.field_width >= 0) {
 			if (buf < end)
 				*buf = ' ';
@@ -1738,29 +1738,21 @@ qualifier:
 	if (spec->qualifier == 'L')
 		spec->type = FORMAT_TYPE_LONG_LONG;
 	else if (spec->qualifier == 'l') {
-		if (spec->flags & SIGN)
-			spec->type = FORMAT_TYPE_LONG;
-		else
-			spec->type = FORMAT_TYPE_ULONG;
+		BUILD_BUG_ON(FORMAT_TYPE_ULONG + SIGN != FORMAT_TYPE_LONG);
+		spec->type = FORMAT_TYPE_ULONG + (spec->flags & SIGN);
 	} else if (_tolower(spec->qualifier) == 'z') {
 		spec->type = FORMAT_TYPE_SIZE_T;
 	} else if (spec->qualifier == 't') {
 		spec->type = FORMAT_TYPE_PTRDIFF;
 	} else if (spec->qualifier == 'H') {
-		if (spec->flags & SIGN)
-			spec->type = FORMAT_TYPE_BYTE;
-		else
-			spec->type = FORMAT_TYPE_UBYTE;
+		BUILD_BUG_ON(FORMAT_TYPE_UBYTE + SIGN != FORMAT_TYPE_BYTE);
+		spec->type = FORMAT_TYPE_UBYTE + (spec->flags & SIGN);
 	} else if (spec->qualifier == 'h') {
-		if (spec->flags & SIGN)
-			spec->type = FORMAT_TYPE_SHORT;
-		else
-			spec->type = FORMAT_TYPE_USHORT;
+		BUILD_BUG_ON(FORMAT_TYPE_USHORT + SIGN != FORMAT_TYPE_SHORT);
+		spec->type = FORMAT_TYPE_USHORT + (spec->flags & SIGN);
 	} else {
-		if (spec->flags & SIGN)
-			spec->type = FORMAT_TYPE_INT;
-		else
-			spec->type = FORMAT_TYPE_UINT;
+		BUILD_BUG_ON(FORMAT_TYPE_UINT + SIGN != FORMAT_TYPE_INT);
+		spec->type = FORMAT_TYPE_UINT + (spec->flags & SIGN);
 	}
 
 	return ++fmt - start;
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

origin.patch
lib-find__bit-reimplementation.patch
lib-find__bit-reimplementation-fix.patch
lib-move-find_last_bit-to-lib-find_next_bitc.patch
lib-rename-lib-find_next_bitc-to-lib-find_bitc.patch
lib-vsprintfc-even-faster-decimal-conversion.patch
lib-vsprintfc-even-faster-decimal-conversion-fix.patch
lib-vsprintfc-improve-put_dec_trunc8-slightly.patch
lib-bitmap_-remove-code-duplication.patch
binfmt_misc-simplify-entry_status.patch
binfmt_misc-simplify-entry_status-fix.patch
linux-next.patch

