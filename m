From: akpm@linux-foundation.org
Subject: [merged] m68k-remove-inline-asm-from-minix_find_first_zero_bit.patch removed from -mm tree
Date: Fri, 25 Mar 2011 00:24:19 -0700
Message-ID: <201103250724.p2P7ODJ1025838@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45861 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933032Ab1CYHYR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Mar 2011 03:24:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, geert@linux-m68k.org, schwab@linux-m68k.org, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     m68k: remove inline asm from minix_find_first_zero_bit
has been removed from the -mm tree.  Its filename was
     m68k-remove-inline-asm-from-minix_find_first_zero_bit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: m68k: remove inline asm from minix_find_first_zero_bit
From: Akinobu Mita <akinobu.mita@gmail.com>

As a preparation for moving minix bit operations from asm/bitops.h to
architecture independent code in minix filesystem, this removes inline asm
from minix_find_first_zero_bit() for m68k.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: Andreas Schwab <schwab@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68k/include/asm/bitops_mm.h |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff -puN arch/m68k/include/asm/bitops_mm.h~m68k-remove-inline-asm-from-minix_find_first_zero_bit arch/m68k/include/asm/bitops_mm.h
--- a/arch/m68k/include/asm/bitops_mm.h~m68k-remove-inline-asm-from-minix_find_first_zero_bit
+++ a/arch/m68k/include/asm/bitops_mm.h
@@ -330,23 +330,19 @@ static inline int __fls(int x)
 static inline int minix_find_first_zero_bit(const void *vaddr, unsigned size)
 {
 	const unsigned short *p = vaddr, *addr = vaddr;
-	int res;
 	unsigned short num;
 
 	if (!size)
 		return 0;
 
 	size = (size >> 4) + ((size & 15) > 0);
-	while (*p++ == 0xffff)
-	{
+	while (*p++ == 0xffff) {
 		if (--size == 0)
 			return (p - addr) << 4;
 	}
 
-	num = ~*--p;
-	__asm__ __volatile__ ("bfffo %1{#16,#16},%0"
-			      : "=d" (res) : "d" (num & -num));
-	return ((p - addr) << 4) + (res ^ 31);
+	num = *--p;
+	return ((p - addr) << 4) + ffz(num);
 }
 
 #define minix_test_and_set_bit(nr, addr)	__test_and_set_bit((nr) ^ 16, (unsigned long *)(addr))
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch

