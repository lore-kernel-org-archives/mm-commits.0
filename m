From: akpm@linux-foundation.org
Subject: [merged] lib-vsprintfc-another-small-hack.patch removed from -mm
 tree
Date: Thu, 16 Apr 2015 09:54:45 -0700
Message-ID: <552fe955.5Uub85jf+D/GkNvF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43119 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753988AbbDPQtR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Apr 2015 12:49:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, a.p.zijlstra@chello.nl, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/vsprintf.c: another small hack
has been removed from the -mm tree.  Its filename was
     lib-vsprintfc-another-small-hack.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: lib/vsprintf.c: another small hack

Making ZEROPAD == '0'-' ', we can eliminate a few more instructions.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/vsprintf.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN lib/vsprintf.c~lib-vsprintfc-another-small-hack lib/vsprintf.c
--- a/lib/vsprintf.c~lib-vsprintfc-another-small-hack
+++ a/lib/vsprintf.c
@@ -341,10 +341,10 @@ int num_to_str(char *buf, int size, unsi
 }
 
 #define SIGN	1		/* unsigned/signed, must be 1 */
-#define ZEROPAD	2		/* pad with zero */
+#define LEFT	2		/* left justified */
 #define PLUS	4		/* show plus */
 #define SPACE	8		/* space if plus */
-#define LEFT	16		/* left justified */
+#define ZEROPAD	16		/* pad with zero, must be 16 == '0' - ' ' */
 #define SMALL	32		/* use lowercase in hex (must be 32 == 0x20) */
 #define SPECIAL	64		/* prefix hex with "0x", octal with "0" */
 
@@ -467,7 +467,8 @@ char *number(char *buf, char *end, unsig
 	}
 	/* zero or space padding */
 	if (!(spec.flags & LEFT)) {
-		char c = (spec.flags & ZEROPAD) ? '0' : ' ';
+		char c = ' ' + (spec.flags & ZEROPAD);
+		BUILD_BUG_ON(' ' + ZEROPAD != '0');
 		while (--spec.field_width >= 0) {
 			if (buf < end)
 				*buf = c;
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

