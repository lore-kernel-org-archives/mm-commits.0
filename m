From: akpm@linux-foundation.org
Subject: + string-memchr_inv-speed-improvements.patch added to -mm tree
Date: Fri, 03 Feb 2012 12:41:22 -0800
Message-ID: <20120203204122.A7127A0159@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qy0-f202.google.com ([209.85.216.202]:62087 "EHLO
	mail-qy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756389Ab2BCUlY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2012 15:41:24 -0500
Received: by qcsp5 with SMTP id p5so458146qcs.1
        for <mm-commits@vger.kernel.org>; Fri, 03 Feb 2012 12:41:23 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, computersforpeace@gmail.com, eric.dumazet@gmail.com


The patch titled
     Subject: string: memchr_inv speed improvements
has been added to the -mm tree.  Its filename is
     string-memchr_inv-speed-improvements.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: string: memchr_inv speed improvements

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
Subject: Subject: string: memchr_inv speed improvements

Patches currently in -mm which might be from akinobu.mita@gmail.com are

xtensa-fix-memscan.patch
linux-next.patch
ocfs2-use-find_last_bit.patch
ocfs2-use-bitmap_weight.patch
drivers-scsi-hpsac-use-find_first_zero_bit.patch
bitops-rename-for_each_set_bit_cont-in-favor-of-analogous-listh-function.patch
bitops-remove-for_each_set_bit_cont.patch
bitops-introduce-for_each_clear_bit.patch
mtd-use-for_each_clear_bit.patch
s390-char-use-for_each_clear_bit.patch
uwb-use-for_each_clear_bit.patch
x86-use-for_each_clear_bit_from.patch
string-memchr_inv-speed-improvements.patch
sysctl-use-bitmap-library-functions.patch

