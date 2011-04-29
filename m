From: akpm@linux-foundation.org
Subject: [to-be-updated] m68knommu-fix-build-error-due-to-the-lack-of-find_next_bit_le.patch removed from -mm tree
Date: Fri, 29 Apr 2011 12:59:00 -0700
Message-ID: <201104291959.p3TJx0nM012440@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41191 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932307Ab1D2T7j (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 29 Apr 2011 15:59:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, arnd@arndb.de, gerg@uclinux.org, heiko.carstens@de.ibm.com, linux@arm.linux.org.uk, schwidefsky@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     m68knommu: fix build error due to the lack of find_next_bit_le()
has been removed from the -mm tree.  Its filename was
     m68knommu-fix-build-error-due-to-the-lack-of-find_next_bit_le.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: m68knommu: fix build error due to the lack of find_next_bit_le()
From: Akinobu Mita <akinobu.mita@gmail.com>

m68knommu can't build ext4 and udf due to the lack of find_next_bit_le(). 
By the previous style change, m68knommu got generic find_next_bit_le(). 
The extern declaration is only needed to fix the build error.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Greg Ungerer <gerg@uclinux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68k/include/asm/bitops_no.h |    3 +++
 1 file changed, 3 insertions(+)

diff -puN arch/m68k/include/asm/bitops_no.h~m68knommu-fix-build-error-due-to-the-lack-of-find_next_bit_le arch/m68k/include/asm/bitops_no.h
--- a/arch/m68k/include/asm/bitops_no.h~m68knommu-fix-build-error-due-to-the-lack-of-find_next_bit_le
+++ a/arch/m68k/include/asm/bitops_no.h
@@ -321,6 +321,9 @@ found_middle:
 }
 #define find_next_zero_bit_le find_next_zero_bit_le
 
+extern unsigned long find_next_bit_le(const void *addr,
+		unsigned long size, unsigned long offset);
+
 #endif /* __KERNEL__ */
 
 #include <asm-generic/bitops/fls.h>
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

linux-next.patch

