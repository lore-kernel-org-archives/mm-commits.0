From: akpm@linux-foundation.org
Subject: + m68k-add-ext2_find_firstnext_bit-for-ext4.patch added to -mm tree
Date: Sun, 08 Jun 2008 13:51:22 -0700
Message-ID: <200806082051.m58KpMBs019899@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60009 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754584AbYFHUvr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 8 Jun 2008 16:51:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aneesh.kumar@linux.vnet.ibm.com, geert@linux-m68k.org


The patch titled
     m68k: Add ext2_find_{first,next}_bit() for ext4
has been added to the -mm tree.  Its filename is
     m68k-add-ext2_find_firstnext_bit-for-ext4.patch

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
Subject: m68k: Add ext2_find_{first,next}_bit() for ext4
From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

Add ext2_find_{first,next}_bit(), which are needed for ext4.  They're
derived out of the ext2_find_next_zero_bit found in the same file. 
Compile tested with crosstools

[Reworked to preserve all symmetry with ext2_find_{first,next}_zero_bit()]

This fixes http://bugzilla.kernel.org/show_bug.cgi?id=10393

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-m68k/bitops.h |   46 ++++++++++++++++++++++++++++++++++--
 1 file changed, 44 insertions(+), 2 deletions(-)

diff -puN include/asm-m68k/bitops.h~m68k-add-ext2_find_firstnext_bit-for-ext4 include/asm-m68k/bitops.h
--- a/include/asm-m68k/bitops.h~m68k-add-ext2_find_firstnext_bit-for-ext4
+++ a/include/asm-m68k/bitops.h
@@ -410,8 +410,50 @@ static inline int ext2_find_next_zero_bi
 	res = ext2_find_first_zero_bit (p, size - 32 * (p - addr));
 	return (p - addr) * 32 + res;
 }
-#define ext2_find_next_bit(addr, size, off) \
-	generic_find_next_le_bit((unsigned long *)(addr), (size), (off))
+
+static inline int ext2_find_first_bit(const void *vaddr, unsigned size)
+{
+	const unsigned long *p = vaddr, *addr = vaddr;
+	int res;
+
+	if (!size)
+		return 0;
+
+	size = (size >> 5) + ((size & 31) > 0);
+	while (*p++ == 0UL)
+	{
+		if (--size == 0)
+			return (p - addr) << 5;
+	}
+
+	--p;
+	for (res = 0; res < 32; res++)
+		if (ext2_test_bit(res, p))
+			break;
+	return (p - addr) * 32 + res;
+}
+
+static inline int ext2_find_next_bit(const void *vaddr, unsigned size,
+				     unsigned offset)
+{
+	const unsigned long *addr = vaddr;
+	const unsigned long *p = addr + (offset >> 5);
+	int bit = offset & 31UL, res;
+
+	if (offset >= size)
+		return size;
+
+	if (bit) {
+		/* Look for one in first longword */
+		for (res = bit; res < 32; res++)
+			if (ext2_test_bit(res, p))
+				return (p - addr) * 32 + res;
+		p++;
+	}
+	/* No set bit yet, search remaining full bytes for a set bit */
+	res = ext2_find_first_bit(p, size - 32 * (p - addr));
+	return (p - addr) * 32 + res;
+}
 
 #endif /* __KERNEL__ */
 
_

Patches currently in -mm which might be from aneesh.kumar@linux.vnet.ibm.com are

m68k-add-ext2_find_firstnext_bit-for-ext4.patch
linux-next.patch
ext4-error-processing-and-coding-enhancement-for-mballoc.patch

