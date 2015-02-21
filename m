From: akpm@linux-foundation.org
Subject: + rtc-mc13xxx-fix-obfuscated-and-wrong-format-string.patch added
 to -mm tree
Date: Fri, 20 Feb 2015 23:10:15 -0800
Message-ID: <54e82f57.hbZz3Ej5l+1//P+e%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48876 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133AbbBUHK4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 21 Feb 2015 02:10:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, a.zummo@towertech.it, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-mc13xxx.c: fix obfuscated and wrong format string
has been added to the -mm tree.  Its filename is
     rtc-mc13xxx-fix-obfuscated-and-wrong-format-string.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-mc13xxx-fix-obfuscated-and-wrong-format-string.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rtc-mc13xxx-fix-obfuscated-and-wrong-format-string.patch

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

origin.patch
linux-bitmaph-improve-bitmap_lastfirst_word_mask.patch
rtc-mc13xxx-fix-obfuscated-and-wrong-format-string.patch
lib-lz4-pull-out-constant-tables.patch
linux-next.patch

