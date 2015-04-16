From: akpm@linux-foundation.org
Subject: [merged] lib-vsprintfc-eliminate-duplicate-hex-string-array.patch removed from -mm tree
Date: Thu, 16 Apr 2015 09:54:43 -0700
Message-ID: <552fe953.PVAkLO1QNMO4rFOu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43115 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752176AbbDPQtO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Apr 2015 12:49:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, a.p.zijlstra@chello.nl, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/vsprintf.c: eliminate duplicate hex string array
has been removed from the -mm tree.  Its filename was
     lib-vsprintfc-eliminate-duplicate-hex-string-array.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

