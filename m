From: akpm@linux-foundation.org
Subject: [merged] m68knommu-fix-build-error-due-to-the-lack-of-find_next_bit_le.patch removed from -mm tree
Date: Fri, 27 May 2011 12:59:23 -0700
Message-ID: <201105271957.p4RJvSOl017678@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49521 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932148Ab1E0T6X (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 May 2011 15:58:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, gerg@uclinux.org, mm-commits@vger.kernel.org


The patch titled
     m68knommu: fix build error due to the lack of find_next_bit_le()
has been removed from the -mm tree.  Its filename was
     m68knommu-fix-build-error-due-to-the-lack-of-find_next_bit_le.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: m68knommu: fix build error due to the lack of find_next_bit_le()
From: Akinobu Mita <akinobu.mita@gmail.com>

m68knommu can't build ext4, udf, and ocfs2 due to the lack of
find_next_bit_le().

This implements find_next_bit_le() on m68knommu by duplicating the generic
find_next_bit_le() in lib/find_next_bit.c.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Acked-by: Greg Ungerer <gerg@uclinux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68k/include/asm/bitops_no.h |   44 ++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff -puN arch/m68k/include/asm/bitops_no.h~m68knommu-fix-build-error-due-to-the-lack-of-find_next_bit_le arch/m68k/include/asm/bitops_no.h
--- a/arch/m68k/include/asm/bitops_no.h~m68knommu-fix-build-error-due-to-the-lack-of-find_next_bit_le
+++ a/arch/m68k/include/asm/bitops_no.h
@@ -320,6 +320,50 @@ found_middle:
 	return result + ffz(__swab32(tmp));
 }
 
+static inline unsigned long find_next_bit_le(const void *addr, unsigned
+		long size, unsigned long offset)
+{
+	const unsigned long *p = addr;
+	unsigned long result = offset & ~(BITS_PER_LONG - 1);
+	unsigned long tmp;
+
+	if (offset >= size)
+		return size;
+	p += offset / BITS_PER_LONG;
+	size -= result;
+	offset &= (BITS_PER_LONG - 1UL);
+	if (offset) {
+		tmp = __swab32(*(p++));
+		tmp &= (~0UL << offset);
+		if (size < BITS_PER_LONG)
+			goto found_first;
+		if (tmp)
+			goto found_middle;
+		size -= BITS_PER_LONG;
+		result += BITS_PER_LONG;
+	}
+
+	while (size & ~(BITS_PER_LONG - 1)) {
+		tmp = *(p++);
+		if (tmp)
+			goto found_middle_swap;
+		result += BITS_PER_LONG;
+		size -= BITS_PER_LONG;
+	}
+	if (!size)
+		return result;
+	tmp = __swab32(*p);
+found_first:
+	tmp &= (~0UL >> (BITS_PER_LONG - size));
+	if (tmp == 0UL)		/* Are any bits set? */
+		return result + size; /* Nope. */
+found_middle:
+	return result + __ffs(tmp);
+
+found_middle_swap:
+	return result + __ffs(__swab32(tmp));
+}
+
 #endif /* __KERNEL__ */
 
 #include <asm-generic/bitops/fls.h>
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch

