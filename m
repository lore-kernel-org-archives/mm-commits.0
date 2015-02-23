From: akpm@linux-foundation.org
Subject: + lib-vsprintfc-reduce-stack-use-in-number.patch added to -mm
 tree
Date: Mon, 23 Feb 2015 14:53:16 -0800
Message-ID: <54ebaf5c.uMlSw+0AQdkSPP64%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47251 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753213AbbBWWxR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Feb 2015 17:53:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, a.p.zijlstra@chello.nl, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/vsprintf.c: reduce stack use in number()
has been added to the -mm tree.  Its filename is
     lib-vsprintfc-reduce-stack-use-in-number.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-vsprintfc-reduce-stack-use-in-number.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-vsprintfc-reduce-stack-use-in-number.patch

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

lib-vsprintfc-eliminate-some-branches.patch
lib-vsprintfc-reduce-stack-use-in-number.patch
lib-vsprintfc-eliminate-duplicate-hex-string-array.patch
lib-vsprintfc-another-small-hack.patch
linux-bitmaph-improve-bitmap_lastfirst_word_mask.patch
rtc-mc13xxx-fix-obfuscated-and-wrong-format-string.patch
lib-lz4-pull-out-constant-tables.patch
linux-next.patch

