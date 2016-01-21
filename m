From: akpm@linux-foundation.org
Subject: [merged] frv-io-accept-const-void-pointers-for-readbwl.patch
 removed from -mm tree
Date: Thu, 21 Jan 2016 14:58:43 -0800
Message-ID: <56a162a3.lQxRqT5SoU2z4axM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33797 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752242AbcAUW6o (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jan 2016 17:58:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sboyd@codeaurora.org, bjorn.andersson@sonymobile.com, dhowells@redhat.com, hauke@hauke-m.de, paul@pwsan.com, zajec5@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: arch/frv/include/asm/io.h: accept const void pointers for read{b,w,l}()
has been removed from the -mm tree.  Its filename was
     frv-io-accept-const-void-pointers-for-readbwl.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Stephen Boyd <sboyd@codeaurora.org>
Subject: arch/frv/include/asm/io.h: accept const void pointers for read{b,w,l}()

The SMD driver is reading and writing chunks of data to iomem, and there's
an __iowrite32_copy() function for the writing part, but no
__ioread32_copy() function for the reading part.  This series adds
__ioread32_copy() and uses it in two places.


This patch (of 4):

The frv port uses compiler builtins, __builtin_read*(), for the I/O read
routines.  Unfortunately, these don't accept const void pointers although
the generic ASM implementations do, so generic code passing const pointers
to these APIs cause compilers to emit warnings.  Add wrapper functions
that cast away the const to avoid the warnings.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Cc: David Howells <dhowells@redhat.com>
Cc: <zajec5@gmail.com>
Cc: Bjorn Andersson <bjorn.andersson@sonymobile.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>
Cc: Paul Walmsley <paul@pwsan.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/frv/include/asm/io.h |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff -puN arch/frv/include/asm/io.h~frv-io-accept-const-void-pointers-for-readbwl arch/frv/include/asm/io.h
--- a/arch/frv/include/asm/io.h~frv-io-accept-const-void-pointers-for-readbwl
+++ a/arch/frv/include/asm/io.h
@@ -43,9 +43,20 @@ static inline unsigned long _swapl(unsig
 //#define __iormb() asm volatile("membar")
 //#define __iowmb() asm volatile("membar")
 
-#define __raw_readb __builtin_read8
-#define __raw_readw __builtin_read16
-#define __raw_readl __builtin_read32
+static inline u8 __raw_readb(const volatile void __iomem *addr)
+{
+	return __builtin_read8((volatile void __iomem *)addr);
+}
+
+static inline u16 __raw_readw(const volatile void __iomem *addr)
+{
+	return __builtin_read16((volatile void __iomem *)addr);
+}
+
+static inline u32 __raw_readl(const volatile void __iomem *addr)
+{
+	return __builtin_read32((volatile void __iomem *)addr);
+}
 
 #define __raw_writeb(datum, addr) __builtin_write8(addr, datum)
 #define __raw_writew(datum, addr) __builtin_write16(addr, datum)
_

Patches currently in -mm which might be from sboyd@codeaurora.org are


