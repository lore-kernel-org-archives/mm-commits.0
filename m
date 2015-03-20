From: akpm@linux-foundation.org
Subject: + lib-vsprintfc-improve-put_dec_trunc8-slightly.patch added to
 -mm tree
Date: Fri, 20 Mar 2015 14:28:52 -0700
Message-ID: <550c9114.SoCdMOZOdynqXlmV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53578 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728AbbCTV2w (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 Mar 2015 17:28:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, a.p.zijlstra@chello.nl, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/vsprintf.c: improve put_dec_trunc8 slightly
has been added to the -mm tree.  Its filename is
     lib-vsprintfc-improve-put_dec_trunc8-slightly.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-vsprintfc-improve-put_dec_trunc8-slightly.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-vsprintfc-improve-put_dec_trunc8-slightly.patch

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
Subject: lib/vsprintf.c: improve put_dec_trunc8 slightly

I hadn't had enough coffee when I wrote this. Currently, the final
increment of buf depends on the value loaded from the table, and
causes gcc to emit a cmov immediately before the return. It is smarter
to let it depend on r, since the increment can then be computed in
parallel with the final load/store pair. It also shaves 16 bytes of
.text.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Tejun Heo <tj@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/vsprintf.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff -puN lib/vsprintf.c~lib-vsprintfc-improve-put_dec_trunc8-slightly lib/vsprintf.c
--- a/lib/vsprintf.c~lib-vsprintfc-improve-put_dec_trunc8-slightly
+++ a/lib/vsprintf.c
@@ -165,9 +165,9 @@ static const u16 decpair[100] = {
 
 /*
  * This will print a single '0' even if r == 0, since we would
- * immediately jump to out_r where two 0s would be written and one of
- * them then discarded. This is needed by ip4_string below. All other
- * callers pass a non-zero value of r.
+ * immediately jump to out_r where two 0s would be written but only
+ * one of them accounted for in buf. This is needed by ip4_string
+ * below. All other callers pass a non-zero value of r.
 */
 static noinline_for_stack
 char *put_dec_trunc8(char *buf, unsigned r)
@@ -206,9 +206,7 @@ out_q:
 out_r:
 	/* 1 <= r < 100 */
 	*((u16 *)buf) = decpair[r];
-	buf += 2;
-	if (buf[-1] == '0')
-		buf--;
+	buf += r < 10 ? 1 : 2;
 	return buf;
 }
 
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

include-linux-remove-empty-conditionals.patch
lib-vsprintfc-eliminate-some-branches.patch
lib-vsprintfc-reduce-stack-use-in-number.patch
lib-vsprintfc-eliminate-duplicate-hex-string-array.patch
lib-vsprintfc-another-small-hack.patch
lib-vsprintfc-fix-potential-null-deref-in-hex_string.patch
lib-string_helpersc-refactor-string_escape_mem.patch
lib-string_helpersc-change-semantics-of-string_escape_mem.patch
lib-string_helpersc-change-semantics-of-string_escape_mem-fix.patch
lib-string_helpersc-change-semantics-of-string_escape_mem-fix-fix.patch
linux-bitmaph-improve-bitmap_lastfirst_word_mask.patch
lib-find__bit-reimplementation.patch
lib-find__bit-reimplementation-fix.patch
lib-move-find_last_bit-to-lib-find_next_bitc.patch
lib-rename-lib-find_next_bitc-to-lib-find_bitc.patch
lib-vsprintfc-even-faster-decimal-conversion.patch
lib-vsprintfc-even-faster-decimal-conversion-fix.patch
lib-vsprintfc-improve-put_dec_trunc8-slightly.patch
binfmt_misc-simplify-entry_status.patch
binfmt_misc-simplify-entry_status-fix.patch
rtc-mc13xxx-fix-obfuscated-and-wrong-format-string.patch
lib-lz4-pull-out-constant-tables.patch
linux-next.patch

