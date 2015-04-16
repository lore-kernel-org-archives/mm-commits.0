From: akpm@linux-foundation.org
Subject: [folded-merged]
 lib-vsprintfc-even-faster-decimal-conversion-fix.patch removed from -mm
 tree
Date: Thu, 16 Apr 2015 12:00:18 -0700
Message-ID: <553006c2.3VnJoxzuUPtLFLaj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45442 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751207AbbDPTAT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Apr 2015 15:00:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/vsprintf.c: silence sparse warnings about decpair[] initialization
has been removed from the -mm tree.  Its filename was
     lib-vsprintfc-even-faster-decimal-conversion-fix.patch

This patch was dropped because it was folded into lib-vsprintfc-even-faster-decimal-conversion.patch

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: lib/vsprintf.c: silence sparse warnings about decpair[] initialization

sparse is unhappy about the initialization of decpair[] and spews out
a ton of "incorrect type in initializer (different base types)". Shut
it up so useful warnings wouldn't drown in the noise.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/vsprintf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/vsprintf.c~lib-vsprintfc-even-faster-decimal-conversion-fix lib/vsprintf.c
--- a/lib/vsprintf.c~lib-vsprintfc-even-faster-decimal-conversion-fix
+++ a/lib/vsprintf.c
@@ -149,7 +149,7 @@ int skip_atoi(const char **s)
  */
 
 static const u16 decpair[100] = {
-#define _(x) cpu_to_le16(((x % 10) | ((x / 10) << 8)) + 0x3030)
+#define _(x) (__force u16) cpu_to_le16(((x % 10) | ((x / 10) << 8)) + 0x3030)
 	_( 0), _( 1), _( 2), _( 3), _( 4), _( 5), _( 6), _( 7), _( 8), _( 9),
 	_(10), _(11), _(12), _(13), _(14), _(15), _(16), _(17), _(18), _(19),
 	_(20), _(21), _(22), _(23), _(24), _(25), _(26), _(27), _(28), _(29),
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

origin.patch
lib-find__bit-reimplementation.patch
lib-move-find_last_bit-to-lib-find_next_bitc.patch
lib-rename-lib-find_next_bitc-to-lib-find_bitc.patch
lib-vsprintfc-even-faster-decimal-conversion.patch
lib-vsprintfc-improve-put_dec_trunc8-slightly.patch
lib-bitmap_-remove-code-duplication.patch
binfmt_misc-simplify-entry_status.patch
binfmt_misc-simplify-entry_status-fix.patch

