From: akpm@linux-foundation.org
Subject: + lib-vsprintfc-eliminate-duplicate-hex-string-array.patch added
 to -mm tree
Date: Mon, 23 Feb 2015 14:53:18 -0800
Message-ID: <54ebaf5e.khNx8oReNEzdXHbW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47255 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753084AbbBWWxT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Feb 2015 17:53:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, a.p.zijlstra@chello.nl, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/vsprintf.c: eliminate duplicate hex string array
has been added to the -mm tree.  Its filename is
     lib-vsprintfc-eliminate-duplicate-hex-string-array.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-vsprintfc-eliminate-duplicate-hex-string-array.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-vsprintfc-eliminate-duplicate-hex-string-array.patch

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
Subject: lib/vsprintf.c: eliminate duplicate hex string array

gcc doesn't merge or overlap const char[] objects with identical contents
(probably language lawyers would also insist that these things have
different addresses), but there's no reason to have the string
"0123456789ABCDEF" occur in multiple places.  hex_asc_upper is declared in
kernel.h and defined in lib/hexdump.c, which is unconditionally compiled
in.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/vsprintf.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff -puN lib/vsprintf.c~lib-vsprintfc-eliminate-duplicate-hex-string-array lib/vsprintf.c
--- a/lib/vsprintf.c~lib-vsprintfc-eliminate-duplicate-hex-string-array
+++ a/lib/vsprintf.c
@@ -383,9 +383,6 @@ static noinline_for_stack
 char *number(char *buf, char *end, unsigned long long num,
 	     struct printf_spec spec)
 {
-	/* we are called with base 8, 10 or 16, only, thus don't need "G..."  */
-	static const char digits[16] = "0123456789ABCDEF"; /* "GHIJKLMNOPQRSTUVWXYZ"; */
-
 	char tmp[3 * sizeof(num)];
 	char sign;
 	char locase;
@@ -422,7 +419,7 @@ char *number(char *buf, char *end, unsig
 	/* generate full string in tmp[], in reverse order */
 	i = 0;
 	if (num < spec.base)
-		tmp[i++] = digits[num] | locase;
+		tmp[i++] = hex_asc_upper[num] | locase;
 	else if (spec.base != 10) { /* 8 or 16 */
 		int mask = spec.base - 1;
 		int shift = 3;
@@ -430,7 +427,7 @@ char *number(char *buf, char *end, unsig
 		if (spec.base == 16)
 			shift = 4;
 		do {
-			tmp[i++] = (digits[((unsigned char)num) & mask] | locase);
+			tmp[i++] = (hex_asc_upper[((unsigned char)num) & mask] | locase);
 			num >>= shift;
 		} while (num);
 	} else { /* base 10 */
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

