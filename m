From: akpm@linux-foundation.org
Subject: + avoid-divides-in-bits_to_longs.patch added to -mm tree
Date: Tue, 12 Feb 2008 16:06:46 -0800
Message-ID: <200802130006.m1D06kEE030126@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41154 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751879AbYBMAIa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Feb 2008 19:08:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dada1@cosmosbay.com


The patch titled
     Avoid divides in BITS_TO_LONGS
has been added to the -mm tree.  Its filename is
     avoid-divides-in-bits_to_longs.patch

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
avoid-divides-in-bits_to_longs.patch
