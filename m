From: akpm@linux-foundation.org
Subject: - m68k-add-ext2_find_firstnext_bit-for-ext4.patch removed from -mm tree
Date: Sun, 15 Jun 2008 23:03:07 -0700
Message-ID: <200806160603.m5G637mb010575@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49730 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751468AbYFPGEA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jun 2008 02:04:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.vnet.ibm.com, geert@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     m68k: Add ext2_find_{first,next}_bit() for ext4
has been removed from the -mm tree.  Its filename was
     m68k-add-ext2_find_firstnext_bit-for-ext4.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: m68k: Add ext2_find_{first,next}_bit() for ext4
From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

Add ext2_find_{first,next}_bit(), which are needed for ext4.  They're
derived out of the ext2_find_next_zero_bit found in the same file. 
Compile tested with crosstools

[Reworked to preserve all symmetry with ext2_find_{first,next}_zero_bit()]

This fixes http://bugzilla.kernel.org/show_bug.cgi?id=10393

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-m68k/bitops.h |   45 ++++++++++++++++++++++++++++++++++--
 1 file changed, 43 insertions(+), 2 deletions(-)

diff -puN include/asm-m68k/bitops.h~m68k-add-ext2_find_firstnext_bit-for-ext4 include/asm-m68k/bitops.h
--- a/include/asm-m68k/bitops.h~m68k-add-ext2_find_firstnext_bit-for-ext4
+++ a/include/asm-m68k/bitops.h
@@ -410,8 +410,49 @@ static inline int ext2_find_next_zero_bi
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
+	while (*p++ == 0UL) {
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

origin.patch
linux-next.patch
ext4-error-processing-and-coding-enhancement-for-mballoc.patch

