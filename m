From: akpm@linux-foundation.org
Subject: [merged] string-memchr_inv-speed-improvements.patch removed from -mm tree
Date: Mon, 26 Mar 2012 12:30:02 -0700
Message-ID: <20120326193002.AD421A0560@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:49450 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753527Ab2CZTaF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Mar 2012 15:30:05 -0400
Received: by wibhj13 with SMTP id hj13so233232wib.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Mar 2012 12:30:03 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, computersforpeace@gmail.com, eric.dumazet@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: string: memchr_inv() speed improvements
has been removed from the -mm tree.  Its filename was
     string-memchr_inv-speed-improvements.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: string: memchr_inv() speed improvements

- Generate a 64-bit pattern more efficiently

memchr_inv needs to generate a 64-bit pattern filled with a target
character.  The operation can be done by more efficient way.

- Don't call the slow check_bytes() if the memory area is 64-bit aligned

memchr_inv compares contiguous 64-bit words with the 64-bit pattern as
much as possible.  The outside of the region is checked by check_bytes()
that scans for each byte.  Unfortunately, the first 64-bit word is
unexpectedly scanned by check_bytes() even if the memory area is aligned
to a 64-bit boundary.

Both changes were originally suggested by Eric Dumazet.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Suggested-by: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Brian Norris <computersforpeace@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/string.c |   20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff -puN lib/string.c~string-memchr_inv-speed-improvements lib/string.c
--- a/lib/string.c~string-memchr_inv-speed-improvements
+++ a/lib/string.c
@@ -785,12 +785,24 @@ void *memchr_inv(const void *start, int 
 	if (bytes <= 16)
 		return check_bytes8(start, value, bytes);
 
-	value64 = value | value << 8 | value << 16 | value << 24;
-	value64 = (value64 & 0xffffffff) | value64 << 32;
-	prefix = 8 - ((unsigned long)start) % 8;
+	value64 = value;
+#if defined(ARCH_HAS_FAST_MULTIPLIER) && BITS_PER_LONG == 64
+	value64 *= 0x0101010101010101;
+#elif defined(ARCH_HAS_FAST_MULTIPLIER)
+	value64 *= 0x01010101;
+	value64 |= value64 << 32;
+#else
+	value64 |= value64 << 8;
+	value64 |= value64 << 16;
+	value64 |= value64 << 32;
+#endif
 
+	prefix = (unsigned long)start % 8;
 	if (prefix) {
-		u8 *r = check_bytes8(start, value, prefix);
+		u8 *r;
+
+		prefix = 8 - prefix;
+		r = check_bytes8(start, value, prefix);
 		if (r)
 			return r;
 		start += prefix;
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
linux-next.patch
ocfs2-use-find_last_bit.patch
ocfs2-use-bitmap_weight.patch
sysctl-use-bitmap-library-functions.patch

