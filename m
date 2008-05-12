From: akpm@linux-foundation.org
Subject: + asm-generic-bitops-fls64h-fix-something.patch added to -mm tree
Date: Mon, 12 May 2008 14:45:59 -0700
Message-ID: <200805122145.m4CLjxpC010799@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45086 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751680AbYELVqf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 May 2008 17:46:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nickolay@protei.ru


The patch titled
     asm-generic/bitops/fls64.h: fix something
has been added to the -mm tree.  Its filename is
     asm-generic-bitops-fls64h-fix-something.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: asm-generic/bitops/fls64.h: fix something
From: Nickolay Vinogradov <nickolay@protei.ru>

bugfix in fls64 on a big endian systems(against 2.6.25).

(akpm: needs better changelog)

Signed-off-by: Nickolay Vinogradov <nickolay@protei.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/bitops/fls64.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/asm-generic/bitops/fls64.h~asm-generic-bitops-fls64h-fix-something include/asm-generic/bitops/fls64.h
--- a/include/asm-generic/bitops/fls64.h~asm-generic-bitops-fls64h-fix-something
+++ a/include/asm-generic/bitops/fls64.h
@@ -20,7 +20,7 @@ static inline int fls64(__u64 x)
 	__u32 h = x >> 32;
 	if (h)
 		return fls(h) + 32;
-	return fls(x);
+	return fls((__u32)x);
 }
 #elif BITS_PER_LONG == 64
 static inline int fls64(__u64 x)
_

Patches currently in -mm which might be from nickolay@protei.ru are

asm-generic-bitops-fls64h-fix-something.patch

