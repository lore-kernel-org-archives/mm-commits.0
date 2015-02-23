From: akpm@linux-foundation.org
Subject: + lib-vsprintfc-another-small-hack.patch added to -mm tree
Date: Mon, 23 Feb 2015 14:53:20 -0800
Message-ID: <54ebaf60.Bl005RbbqSrVmLZy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47257 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753084AbbBWWxV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Feb 2015 17:53:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, a.p.zijlstra@chello.nl, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/vsprintf.c: another small hack
has been added to the -mm tree.  Its filename is
     lib-vsprintfc-another-small-hack.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-vsprintfc-another-small-hack.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-vsprintfc-another-small-hack.patch

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

lib-vsprintfc-eliminate-some-branches.patch
lib-vsprintfc-reduce-stack-use-in-number.patch
lib-vsprintfc-eliminate-duplicate-hex-string-array.patch
lib-vsprintfc-another-small-hack.patch
linux-bitmaph-improve-bitmap_lastfirst_word_mask.patch
rtc-mc13xxx-fix-obfuscated-and-wrong-format-string.patch
lib-lz4-pull-out-constant-tables.patch
linux-next.patch

