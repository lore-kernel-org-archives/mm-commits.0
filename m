From: akpm@linux-foundation.org
Subject: [merged] crc32-optimize-inner-loop.patch removed from -mm tree
Date: Wed, 11 Jan 2012 13:31:47 -0800
Message-ID: <20120111213147.9E7671E004D@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:50460 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753124Ab2AKVbs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2012 16:31:48 -0500
Received: by yenm1 with SMTP id m1so7880yen.1
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2012 13:31:48 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Joakim.Tjernlund@transmode.se, eric.dumazet@gmail.com, fzago@systemfabricworks.com, rpearson@systemfabricworks.com, mm-commits@vger.kernel.org


The patch titled
     Subject: crc32: optimize inner loop
has been removed from the -mm tree.  Its filename was
     crc32-optimize-inner-loop.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

Patches currently in -mm which might be from Joakim.Tjernlund@transmode.se are

origin.patch

