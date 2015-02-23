From: akpm@linux-foundation.org
Subject: + lib-vsprintfc-eliminate-some-branches.patch added to -mm tree
Date: Mon, 23 Feb 2015 14:53:14 -0800
Message-ID: <54ebaf5a.3nwW/TxATlKVzZ+z%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47246 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753213AbbBWWxP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Feb 2015 17:53:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, a.p.zijlstra@chello.nl, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/vsprintf.c: eliminate some branches
has been added to the -mm tree.  Its filename is
     lib-vsprintfc-eliminate-some-branches.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-vsprintfc-eliminate-some-branches.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-vsprintfc-eliminate-some-branches.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

lib-vsprintfc-eliminate-some-branches.patch
lib-vsprintfc-reduce-stack-use-in-number.patch
lib-vsprintfc-eliminate-duplicate-hex-string-array.patch
lib-vsprintfc-another-small-hack.patch
linux-bitmaph-improve-bitmap_lastfirst_word_mask.patch
rtc-mc13xxx-fix-obfuscated-and-wrong-format-string.patch
lib-lz4-pull-out-constant-tables.patch
linux-next.patch

