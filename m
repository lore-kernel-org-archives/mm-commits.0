From: akpm@linux-foundation.org
Subject: - asm-generic-bitops-fls64h-fix-something.patch removed from -mm tree
Date: Thu, 24 Jul 2008 17:11:04 -0700
Message-ID: <200807250011.m6P0B4vl013375@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48801 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752121AbYGYALu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 20:11:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nickolay@protei.ru, mm-commits@vger.kernel.org


The patch titled
     asm-generic/bitops/fls64.h: fix something
has been removed from the -mm tree.  Its filename was
     asm-generic-bitops-fls64h-fix-something.patch

This patch was dropped because it is obsolete

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

