From: akpm@linux-foundation.org
Subject: [merged] lib-vsprintfc-reduce-stack-use-in-number.patch removed
 from -mm tree
Date: Thu, 16 Apr 2015 09:54:41 -0700
Message-ID: <552fe951.GHmrGo9PjN6KKDwG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43111 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753718AbbDPQtM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Apr 2015 12:49:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, a.p.zijlstra@chello.nl, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/vsprintf.c: reduce stack use in number()
has been removed from the -mm tree.  Its filename was
     lib-vsprintfc-reduce-stack-use-in-number.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: lib/vsprintf.c: reduce stack use in number()

At least since the initial git commit, when base was passed as a separate
parameter, number() has only been called with bases 8, 10 and 16.  I'm
guessing that 66 was to accommodate 64 0/1, a sign and a '\0', but the
buffer is only used for the actual digits.  Octal digits carry 3 bits of
information, so 24 is enough.  Spell that 3*sizeof(num) so one less place
needs to be changed should long long ever be 128 bits.  Also remove the
commented-out code that would handle an arbitrary base.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/vsprintf.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff -puN lib/vsprintf.c~lib-vsprintfc-reduce-stack-use-in-number lib/vsprintf.c
--- a/lib/vsprintf.c~lib-vsprintfc-reduce-stack-use-in-number
+++ a/lib/vsprintf.c
@@ -386,7 +386,7 @@ char *number(char *buf, char *end, unsig
 	/* we are called with base 8, 10 or 16, only, thus don't need "G..."  */
 	static const char digits[16] = "0123456789ABCDEF"; /* "GHIJKLMNOPQRSTUVWXYZ"; */
 
-	char tmp[66];
+	char tmp[3 * sizeof(num)];
 	char sign;
 	char locase;
 	int need_pfx = ((spec.flags & SPECIAL) && spec.base != 10);
@@ -423,11 +423,6 @@ char *number(char *buf, char *end, unsig
 	i = 0;
 	if (num < spec.base)
 		tmp[i++] = digits[num] | locase;
-	/* Generic code, for any base:
-	else do {
-		tmp[i++] = (digits[do_div(num,base)] | locase);
-	} while (num != 0);
-	*/
 	else if (spec.base != 10) { /* 8 or 16 */
 		int mask = spec.base - 1;
 		int shift = 3;
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

