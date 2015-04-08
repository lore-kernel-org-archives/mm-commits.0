From: akpm@linux-foundation.org
Subject: [alternative-merged]
 rtc-mc13xxx-fix-obfuscated-and-wrong-format-string.patch removed from -mm
 tree
Date: Wed, 08 Apr 2015 14:31:46 -0700
Message-ID: <55259e42.RNS3/66cIf+GY8Dh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59724 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754753AbbDHVbr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 Apr 2015 17:31:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, a.zummo@towertech.it, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-mc13xxx.c: fix obfuscated and wrong format string
has been removed from the -mm tree.  Its filename was
     rtc-mc13xxx-fix-obfuscated-and-wrong-format-string.patch

This patch was dropped because an alternative patch was merged

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: drivers/rtc/rtc-mc13xxx.c: fix obfuscated and wrong format string

According to C99, %2.s means 'print two spaces' (a precision of .  without
following digits or * means 0).  The kernel's printf implementation,
however, treats that case as if no precision was given, but relying on
that quirk is rather silly.  Also, since no - (aka left-justify) flag is
given, the field with of 2 would then cause the alarm->enabled case to
come out as "o n".  Deobfuscate it.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-mc13xxx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-mc13xxx.c~rtc-mc13xxx-fix-obfuscated-and-wrong-format-string drivers/rtc/rtc-mc13xxx.c
--- a/drivers/rtc/rtc-mc13xxx.c~rtc-mc13xxx-fix-obfuscated-and-wrong-format-string
+++ a/drivers/rtc/rtc-mc13xxx.c
@@ -219,7 +219,7 @@ static int mc13xxx_rtc_set_alarm(struct
 	if (unlikely(ret))
 		goto out;
 
-	dev_dbg(dev, "%s: o%2.s %lu\n", __func__, alarm->enabled ? "n" : "ff",
+	dev_dbg(dev, "%s: %s %lu\n", __func__, alarm->enabled ? "on" : "off",
 			s1970);
 
 	ret = mc13xxx_rtc_irq_enable_unlocked(dev, alarm->enabled,
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

mm-mmapc-use-while-instead-of-ifgoto.patch
mm-mmapc-use-while-instead-of-ifgoto-fix.patch
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
lib-bitmap_-remove-code-duplication.patch
binfmt_misc-simplify-entry_status.patch
binfmt_misc-simplify-entry_status-fix.patch
linux-next.patch

