From: akpm@linux-foundation.org
Subject: + crc32-use-__byte_order-macro-for-endian-detection.patch added to -mm tree
Date: Thu, 22 Apr 2010 14:10:23 -0700
Message-ID: <201004222110.o3MLANYd011250@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50841 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756358Ab0DVVKe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 22 Apr 2010 17:10:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Joakim.Tjernlund@transmode.se


The patch titled
     crc32: use __BYTE_ORDER macro for endian detection.
has been added to the -mm tree.  Its filename is
     crc32-use-__byte_order-macro-for-endian-detection.patch

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
Subject: crc32: use __BYTE_ORDER macro for endian detection.
From: Joakim Tjernlund <Joakim.Tjernlund@transmode.se>

Since crc32.c contains a nifty test program that can be executed in user
space, make sure endian detection works reliably in user space too.

Signed-off-by: Joakim Tjernlund <Joakim.Tjernlund@transmode.se>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/crc32.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/crc32.c~crc32-use-__byte_order-macro-for-endian-detection lib/crc32.c
--- a/lib/crc32.c~crc32-use-__byte_order-macro-for-endian-detection
+++ a/lib/crc32.c
@@ -50,7 +50,7 @@ MODULE_LICENSE("GPL");
 static inline u32
 crc32_body(u32 crc, unsigned char const *buf, size_t len, const u32 (*tab)[256])
 {
-# ifdef __LITTLE_ENDIAN
+# if __BYTE_ORDER == __LITTLE_ENDIAN
 #  define DO_CRC(x) crc = tab[0][(crc ^ (x)) & 255] ^ (crc >> 8)
 #  define DO_CRC4 crc = tab[3][(crc) & 255] ^ \
 		tab[2][(crc >> 8) & 255] ^ \
_

Patches currently in -mm which might be from Joakim.Tjernlund@transmode.se are

linux-next.patch
endian-define-__byte_order.patch
crc32-major-optimization.patch
crc32-major-optimization-checkpatch-fixes.patch
crc32-use-__byte_order-macro-for-endian-detection.patch

