From: akpm@linux-foundation.org
Subject: + frv-io-accept-const-void-pointers-for-readbwl.patch added to
 -mm tree
Date: Thu, 19 Nov 2015 12:12:12 -0800
Message-ID: <564e2d1c.4StdRXZ1AM4GWNPm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48690 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161183AbbKSUMN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 Nov 2015 15:12:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sboyd@codeaurora.org, bjorn.andersson@sonymobile.com, dhowells@redhat.com, hauke@hauke-m.de, paul@pwsan.com, zajec5@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: arch/frv/include/asm/io.h: accept const void pointers for read{b,w,l}()
has been added to the -mm tree.  Its filename is
     frv-io-accept-const-void-pointers-for-readbwl.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/frv-io-accept-const-void-pointers-for-readbwl.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/frv-io-accept-const-void-pointers-for-readbwl.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

frv-io-accept-const-void-pointers-for-readbwl.patch
lib-iomap_copy-add-__ioread32_copy.patch
soc-qcom-smd-use-__ioread32_copy-instead-of-open-coding-it.patch
firmware-bcm47xx_nvram-use-__ioread32_copy-instead-of-open-coding.patch

