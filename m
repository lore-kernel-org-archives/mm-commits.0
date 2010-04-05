From: akpm@linux-foundation.org
Subject: + asm-generic-remove-isa_dma_threshold-in-scatterlisth.patch added to -mm tree
Date: Mon, 05 Apr 2010 13:50:36 -0700
Message-ID: <201004052050.o35KobVp008367@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57279 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756420Ab0DEUvD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Apr 2010 16:51:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp, arnd@arndb.de, benh@kernel.crashing.org, ink@jurassic.park.msu.ru, linux@arm.linux.org.uk, mattst88@gmail.com, paulus@samba.org, rth@twiddle.net


The patch titled
     asm-generic: remove ISA_DMA_THRESHOLD in scatterlist.h
has been added to the -mm tree.  Its filename is
     asm-generic-remove-isa_dma_threshold-in-scatterlisth.patch

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
Subject: asm-generic: remove ISA_DMA_THRESHOLD in scatterlist.h
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

This is the first half of the attempt to use asm-generic/scatterlist.h
on every architecture.

There are only two ways to define scatterlist structure. So it's easy
to convert every architecture to use asm-generic/scatterlist.h.


This patch:

The trick for ISA_DMA_THRESHOLD in asm-generic/scatterlist.h doesn't work
for powerpc.  This lets architectures defin ISA_DMA_THRESHOLD.

Hopefully, we can remove ISA_DMA_THRESHOLD in the future; we can do better
to decide if the bouncing is necessary or not.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/microblaze/include/asm/scatterlist.h |    2 ++
 arch/s390/include/asm/scatterlist.h       |    2 ++
 arch/score/include/asm/scatterlist.h      |    2 ++
 arch/sparc/include/asm/scatterlist.h      |    2 ++
 include/asm-generic/scatterlist.h         |    4 ----
 5 files changed, 8 insertions(+), 4 deletions(-)

diff -puN arch/microblaze/include/asm/scatterlist.h~asm-generic-remove-isa_dma_threshold-in-scatterlisth arch/microblaze/include/asm/scatterlist.h
--- a/arch/microblaze/include/asm/scatterlist.h~asm-generic-remove-isa_dma_threshold-in-scatterlisth
+++ a/arch/microblaze/include/asm/scatterlist.h
@@ -1 +1,3 @@
+#define ISA_DMA_THRESHOLD	(~0UL)
+
 #include <asm-generic/scatterlist.h>
diff -puN arch/s390/include/asm/scatterlist.h~asm-generic-remove-isa_dma_threshold-in-scatterlisth arch/s390/include/asm/scatterlist.h
--- a/arch/s390/include/asm/scatterlist.h~asm-generic-remove-isa_dma_threshold-in-scatterlisth
+++ a/arch/s390/include/asm/scatterlist.h
@@ -1 +1,3 @@
+#define ISA_DMA_THRESHOLD	(~0UL)
+
 #include <asm-generic/scatterlist.h>
diff -puN arch/score/include/asm/scatterlist.h~asm-generic-remove-isa_dma_threshold-in-scatterlisth arch/score/include/asm/scatterlist.h
--- a/arch/score/include/asm/scatterlist.h~asm-generic-remove-isa_dma_threshold-in-scatterlisth
+++ a/arch/score/include/asm/scatterlist.h
@@ -1,6 +1,8 @@
 #ifndef _ASM_SCORE_SCATTERLIST_H
 #define _ASM_SCORE_SCATTERLIST_H
 
+#define ISA_DMA_THRESHOLD	(~0UL)
+
 #include <asm-generic/scatterlist.h>
 
 #endif /* _ASM_SCORE_SCATTERLIST_H */
diff -puN arch/sparc/include/asm/scatterlist.h~asm-generic-remove-isa_dma_threshold-in-scatterlisth arch/sparc/include/asm/scatterlist.h
--- a/arch/sparc/include/asm/scatterlist.h~asm-generic-remove-isa_dma_threshold-in-scatterlisth
+++ a/arch/sparc/include/asm/scatterlist.h
@@ -3,6 +3,8 @@
 
 #define sg_dma_len(sg)     	((sg)->dma_length)
 
+#define ISA_DMA_THRESHOLD	(~0UL)
+
 #include <asm-generic/scatterlist.h>
 
 #endif /* !(_SPARC_SCATTERLIST_H) */
diff -puN include/asm-generic/scatterlist.h~asm-generic-remove-isa_dma_threshold-in-scatterlisth include/asm-generic/scatterlist.h
--- a/include/asm-generic/scatterlist.h~asm-generic-remove-isa_dma_threshold-in-scatterlisth
+++ a/include/asm-generic/scatterlist.h
@@ -34,10 +34,6 @@ struct scatterlist {
 #endif /* 64 bit */
 #endif /* sg_dma_len */
 
-#ifndef ISA_DMA_THRESHOLD
-#define ISA_DMA_THRESHOLD	(~0UL)
-#endif
