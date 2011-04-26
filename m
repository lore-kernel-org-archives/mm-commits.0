From: akpm@linux-foundation.org
Subject: + m68knommu-fix-build-error-due-to-the-lack-of-find_next_bit_le.patch added to -mm tree
Date: Tue, 26 Apr 2011 14:29:18 -0700
Message-ID: <201104262129.p3QLTJ5W020636@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46529 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932957Ab1DZV6x (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Apr 2011 17:58:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, arnd@arndb.de, gerg@uclinux.org, heiko.carstens@de.ibm.com, linux@arm.linux.org.uk, schwidefsky@de.ibm.com


The patch titled
     m68knommu: fix build error due to the lack of find_next_bit_le()
has been added to the -mm tree.  Its filename is
     m68knommu-fix-build-error-due-to-the-lack-of-find_next_bit_le.patch

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
arch-add-define-for-each-of-optimized-find-bitops.patch
bitops-add-ifndef-for-each-of-find-bitops.patch
arch-remove-config_generic_find_next_bitbit_lelast_bit.patch
arm-use-asm-generic-bitops-leh.patch
s390-use-asm-generic-bitops-leh.patch
m68knommu-fix-build-error-due-to-the-lack-of-find_next_bit_le.patch

