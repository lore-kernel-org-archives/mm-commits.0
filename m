From: akpm@linux-foundation.org
Subject: [merged] xtensa-enforce-slab-alignment-to-maximum-register-width.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:39:26 -0700
Message-ID: <200904061939.n36JdQ2i013909@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40012 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753946AbZDFTnh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 15:43:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: os@emlix.com, chris@zankel.net, jw@emlix.com, penberg@cs.helsinki.fi, mm-commits@vger.kernel.org


The patch titled
     xtensa: enforce slab alignment to maximum register width
has been removed from the -mm tree.  Its filename was
     xtensa-enforce-slab-alignment-to-maximum-register-width.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: xtensa: enforce slab alignment to maximum register width
From: Oskar Schirmer <os@emlix.com>

XCHAL_DATA_WIDTH is the maximum register width, slab caches should be
aligned to this.

Theoretical fix as all variants have had an XCHAL_DATA_WIDTH of 4
(wordsize) for now.  But the S6000 variant will raise this to 16.

Signed-off-by: Oskar Schirmer <os@emlix.com>
Signed-off-by: Johannes Weiner <jw@emlix.com>
Cc: Chris Zankel <chris@zankel.net>
Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/xtensa/include/asm/processor.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN arch/xtensa/include/asm/processor.h~xtensa-enforce-slab-alignment-to-maximum-register-width arch/xtensa/include/asm/processor.h
--- a/arch/xtensa/include/asm/processor.h~xtensa-enforce-slab-alignment-to-maximum-register-width
+++ a/arch/xtensa/include/asm/processor.h
@@ -25,6 +25,8 @@
 # error Linux requires the Xtensa Windowed Registers Option.
 #endif
 
+#define ARCH_SLAB_MINALIGN	XCHAL_DATA_WIDTH
+
 /*
  * User space process size: 1 GB.
  * Windowed call ABI requires caller and callee to be located within the same
_

Patches currently in -mm which might be from os@emlix.com are

origin.patch
xtensa-add-flat-support-checkpatch-fixes.patch
xtensa-variant-specific-code.patch
xtensa-cache-inquiry-and-unaligned-cache-handling-functions.patch
xtensa-s6000-dma-engine-support.patch
xtensa-allow-platform-and-variant-to-initialize-own-irq-chips.patch
xtensa-support-s6000-gpio-irqs-and-alternate-function-selection.patch
s6gmac-xtensa-s6000-on-chip-ethernet-driver.patch
xtensa-s6105-specific-configuration-for-s6gmac.patch
xtensa-enable-s6gmac-in-s6105_defconfig.patch
flat-fix-data-sections-alignment.patch

