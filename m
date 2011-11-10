From: akpm@linux-foundation.org
Subject: + crc32-optimize-inner-loop.patch added to -mm tree
Date: Wed, 09 Nov 2011 16:16:11 -0800
Message-ID: <201111100016.pAA0GBXe002150@wpaz17.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:42170 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754977Ab1KJAQS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Nov 2011 19:16:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Joakim.Tjernlund@transmode.se, eric.dumazet@gmail.com, fzago@systemfabricworks.com, rpearson@systemfabricworks.com


The patch titled
     Subject: crc32: optimize inner loop
has been added to the -mm tree.  Its filename is
     crc32-optimize-inner-loop.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Joakim Tjernlund <Joakim.Tjernlund@transmode.se>
Subject: crc32: optimize inner loop

Taking a pointer reference to each row in the crc table matrix, one can
reduce the inner loop with a few insn's

Signed-off-by: Joakim Tjernlund <Joakim.Tjernlund@transmode.se>
Cc: Bob Pearson <rpearson@systemfabricworks.com>
Cc: Frank Zago <fzago@systemfabricworks.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/crc32.c |   21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff -puN lib/crc32.c~crc32-optimize-inner-loop lib/crc32.c
--- a/lib/crc32.c~crc32-optimize-inner-loop
+++ a/lib/crc32.c
@@ -51,20 +51,21 @@ static inline u32
 crc32_body(u32 crc, unsigned char const *buf, size_t len, const u32 (*tab)[256])
 {
 # ifdef __LITTLE_ENDIAN
-#  define DO_CRC(x) crc = tab[0][(crc ^ (x)) & 255] ^ (crc >> 8)
-#  define DO_CRC4 crc = tab[3][(crc) & 255] ^ \
-		tab[2][(crc >> 8) & 255] ^ \
-		tab[1][(crc >> 16) & 255] ^ \
-		tab[0][(crc >> 24) & 255]
+#  define DO_CRC(x) crc = t0[(crc ^ (x)) & 255] ^ (crc >> 8)
+#  define DO_CRC4 crc = t3[(crc) & 255] ^ \
+		t2[(crc >> 8) & 255] ^ \
+		t1[(crc >> 16) & 255] ^ \
+		t0[(crc >> 24) & 255]
 # else
-#  define DO_CRC(x) crc = tab[0][((crc >> 24) ^ (x)) & 255] ^ (crc << 8)
-#  define DO_CRC4 crc = tab[0][(crc) & 255] ^ \
-		tab[1][(crc >> 8) & 255] ^ \
-		tab[2][(crc >> 16) & 255] ^ \
-		tab[3][(crc >> 24) & 255]
+#  define DO_CRC(x) crc = t0[((crc >> 24) ^ (x)) & 255] ^ (crc << 8)
+#  define DO_CRC4 crc = t0[(crc) & 255] ^ \
+		t1[(crc >> 8) & 255] ^  \
+		t2[(crc >> 16) & 255] ^	\
+		t3[(crc >> 24) & 255]
 # endif
 	const u32 *b;
 	size_t    rem_len;
+	const u32 *t0=tab[0], *t1=tab[1], *t2=tab[2], *t3=tab[3];
 
 	/* Align it */
 	if (unlikely((long)buf & 3 && len)) {
_
Subject: Subject: crc32: optimize inner loop

Patches currently in -mm which might be from Joakim.Tjernlund@transmode.se are

crc32-optimize-inner-loop.patch

