From: akpm@linux-foundation.org
Subject: + matroxfb-fix-incorrect-use-of-memcpy_toio.patch added to -mm tree
Date: Wed, 11 Aug 2010 14:21:44 -0700
Message-ID: <201008112121.o7BLLiwc015260@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48721 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751392Ab0HKVWb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Aug 2010 17:22:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: linux@rainbow-software.org, brgerst@gmail.com, hpa@zytor.com, khali@linux-fr.org, stable@kernel.org, vandrove@vc.cvut.cz


The patch titled
     matroxfb: fix incorrect use of memcpy_toio()
has been added to the -mm tree.  Its filename is
     matroxfb-fix-incorrect-use-of-memcpy_toio.patch

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
Subject: matroxfb: fix incorrect use of memcpy_toio()
From: Ondrej Zary <linux@rainbow-software.org>

Screen is completely corrupted since 2.6.34.  Bisection revealed that it's
caused by commit 6175ddf06b61720 ("x86: Clean up mem*io functions.").

H.  Peter Anvin explained that memcpy_toio() does not copy data in 32bit
chunks anymore on x86.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
Cc: Brian Gerst <brgerst@gmail.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Petr Vandrovec <vandrove@vc.cvut.cz>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: <stable@kernel.org>		[2.6.34.x, 2.6.35.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/matrox/matroxfb_base.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/video/matrox/matroxfb_base.h~matroxfb-fix-incorrect-use-of-memcpy_toio drivers/video/matrox/matroxfb_base.h
--- a/drivers/video/matrox/matroxfb_base.h~matroxfb-fix-incorrect-use-of-memcpy_toio
+++ a/drivers/video/matrox/matroxfb_base.h
@@ -151,13 +151,13 @@ static inline void mga_writel(vaddr_t va
 static inline void mga_memcpy_toio(vaddr_t va, const void* src, int len) {
 #if defined(__alpha__) || defined(__i386__) || defined(__x86_64__)
 	/*
-	 * memcpy_toio works for us if:
+	 * iowrite32_rep works for us if:
 	 *  (1) Copies data as 32bit quantities, not byte after byte,
 	 *  (2) Performs LE ordered stores, and
 	 *  (3) It copes with unaligned source (destination is guaranteed to be page
 	 *      aligned and length is guaranteed to be multiple of 4).
 	 */
-	memcpy_toio(va.vaddr, src, len);
+	iowrite32_rep(va.vaddr, src, len >> 2);
 #else
         u_int32_t __iomem* addr = va.vaddr;
 
_

Patches currently in -mm which might be from linux@rainbow-software.org are

origin.patch
matroxfb-fix-incorrect-use-of-memcpy_toio.patch

