From: akpm@linux-foundation.org
Subject: - avoid-divides-in-bits_to_longs.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:38:44 -0700
Message-ID: <200804300538.m3U5ciPY028774@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33780 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752504AbYD3Fi4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:38:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dada1@cosmosbay.com, mm-commits@vger.kernel.org


The patch titled
     Avoid divides in BITS_TO_LONGS
has been removed from the -mm tree.  Its filename was
     avoid-divides-in-bits_to_longs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Avoid divides in BITS_TO_LONGS
From: Eric Dumazet <dada1@cosmosbay.com>

BITS_PER_LONG is a signed value (32 or 64)

DIV_ROUND_UP(nr, BITS_PER_LONG) performs signed arithmetic if "nr" is signed too.


Converting BITS_TO_LONGS(nr) to DIV_ROUND_UP(nr, BITS_PER_BYTE *
sizeof(long)) makes sure compiler can perform a right shift, even if "nr"
is a signed value, instead of an expensive integer divide.

Applying this patch saves 141 bytes on x86 when CONFIG_CC_OPTIMIZE_FOR_SIZE=y
and speedup bitmap operations.

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bitops.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/bitops.h~avoid-divides-in-bits_to_longs include/linux/bitops.h
--- a/include/linux/bitops.h~avoid-divides-in-bits_to_longs
+++ a/include/linux/bitops.h
@@ -6,8 +6,8 @@
 #define BIT(nr)			(1UL << (nr))
 #define BIT_MASK(nr)		(1UL << ((nr) % BITS_PER_LONG))
 #define BIT_WORD(nr)		((nr) / BITS_PER_LONG)
-#define BITS_TO_LONGS(nr)	DIV_ROUND_UP(nr, BITS_PER_LONG)
 #define BITS_PER_BYTE		8
+#define BITS_TO_LONGS(nr)	DIV_ROUND_UP(nr, BITS_PER_BYTE * sizeof(long))
 #endif
 
 /*
_

Patches currently in -mm which might be from dada1@cosmosbay.com are

origin.patch

