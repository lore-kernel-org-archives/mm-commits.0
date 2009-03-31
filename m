From: akpm@linux-foundation.org
Subject: + xtensa-cache-inquiry-and-unaligned-cache-handling-functions.patch added to -mm tree
Date: Mon, 30 Mar 2009 17:00:49 -0700
Message-ID: <200903310000.n2V00nCJ031560@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32925 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761836AbZCaAFC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Mar 2009 20:05:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: os@emlix.com, chris@zankel.net, dg@emlix.com, jw@emlix.com


The patch titled
     xtensa: cache inquiry and unaligned cache handling functions
has been added to the -mm tree.  Its filename is
     xtensa-cache-inquiry-and-unaligned-cache-handling-functions.patch

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
Subject: xtensa: cache inquiry and unaligned cache handling functions
From: Oskar Schirmer <os@emlix.com>

The existing xtensa cache handling functions work on page-aligned
memory regions.

These functions are needed for the s6000 dma engine which can work on
a byte-granularity.

Signed-off-by: Oskar Schirmer <os@emlix.com>
Cc: Johannes Weiner <jw@emlix.com>
Cc: Daniel Glockner <dg@emlix.com>
Cc: Christian Zankel <chris@zankel.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/xtensa/include/asm/cacheflush.h |   95 +++++++++++++++++++++++++
 1 file changed, 95 insertions(+)

diff -puN arch/xtensa/include/asm/cacheflush.h~xtensa-cache-inquiry-and-unaligned-cache-handling-functions arch/xtensa/include/asm/cacheflush.h
--- a/arch/xtensa/include/asm/cacheflush.h~xtensa-cache-inquiry-and-unaligned-cache-handling-functions
+++ a/arch/xtensa/include/asm/cacheflush.h
@@ -155,5 +155,100 @@ extern void copy_from_user_page(struct v
 
 #endif
 
+#define XTENSA_CACHEBLK_LOG2	29
+#define XTENSA_CACHEBLK_SIZE	(1 << XTENSA_CACHEBLK_LOG2)
+#define XTENSA_CACHEBLK_MASK	(7 << XTENSA_CACHEBLK_LOG2)
+
+#if XCHAL_HAVE_CACHEATTR
+static inline u32 xtensa_get_cacheattr(void)
+{
+	u32 r;
+	asm volatile("	rsr %0, CACHEATTR" : "=a"(r));
+	return r;
+}
+
+static inline u32 xtensa_get_dtlb1(u32 addr)
+{
+	u32 r = addr & XTENSA_CACHEBLK_MASK;
+	return r | ((xtensa_get_cacheattr() >> (r >> (XTENSA_CACHEBLK_LOG2-2)))
+			& 0xF);
+}
+#else
+static inline u32 xtensa_get_dtlb1(u32 addr)
+{
+	u32 r;
+	asm volatile("	rdtlb1 %0, %1" : "=a"(r) : "a"(addr));
+	asm volatile("	dsync");
+	return r;
+}
+
+static inline u32 xtensa_get_cacheattr(void)
+{
+	u32 r = 0;
+	u32 a = 0;
+	do {
+		a -= XTENSA_CACHEBLK_SIZE;
+		r = (r << 4) | (xtensa_get_dtlb1(a) & 0xF);
+	} while (a);
+	return r;
+}
+#endif
+
+static inline int xtensa_need_flush_dma_source(u32 addr)
+{
+	return (xtensa_get_dtlb1(addr) & ((1 << XCHAL_CA_BITS) - 1)) >= 4;
+}
+
+static inline int xtensa_need_invalidate_dma_destination(u32 addr)
+{
+	return (xtensa_get_dtlb1(addr) & ((1 << XCHAL_CA_BITS) - 1)) != 2;
+}
+
+static inline void flush_dcache_unaligned(u32 addr, u32 size)
+{
+	u32 cnt;
+	if (size) {
+		cnt = (size + ((XCHAL_DCACHE_LINESIZE - 1) & addr)
+			+ XCHAL_DCACHE_LINESIZE - 1) / XCHAL_DCACHE_LINESIZE;
+		while (cnt--) {
+			asm volatile("	dhwb %0, 0" : : "a"(addr));
+			addr += XCHAL_DCACHE_LINESIZE;
+		}
+		asm volatile("	dsync");
+	}
+}
+
+static inline void invalidate_dcache_unaligned(u32 addr, u32 size)
+{
+	int cnt;
+	if (size) {
+		asm volatile("	dhwbi %0, 0 ;" : : "a"(addr));
+		cnt = (size + ((XCHAL_DCACHE_LINESIZE - 1) & addr)
+			- XCHAL_DCACHE_LINESIZE - 1) / XCHAL_DCACHE_LINESIZE;
+		while (cnt-- > 0) {
+			asm volatile("	dhi %0, %1" : : "a"(addr),
+						"n"(XCHAL_DCACHE_LINESIZE));
+			addr += XCHAL_DCACHE_LINESIZE;
+		}
+		asm volatile("	dhwbi %0, %1" : : "a"(addr),
+						"n"(XCHAL_DCACHE_LINESIZE));
+		asm volatile("	dsync");
+	}
+}
+
+static inline void flush_invalidate_dcache_unaligned(u32 addr, u32 size)
+{
+	u32 cnt;
+	if (size) {
+		cnt = (size + ((XCHAL_DCACHE_LINESIZE - 1) & addr)
+			+ XCHAL_DCACHE_LINESIZE - 1) / XCHAL_DCACHE_LINESIZE;
+		while (cnt--) {
+			asm volatile("	dhwbi %0, 0" : : "a"(addr));
+			addr += XCHAL_DCACHE_LINESIZE;
+		}
+		asm volatile("	dsync");
+	}
+}
+
 #endif /* __KERNEL__ */
 #endif /* _XTENSA_CACHEFLUSH_H */
_

Patches currently in -mm which might be from os@emlix.com are

xtensa-enforce-slab-alignment-to-maximum-register-width.patch
xtensa-add-flat-support.patch
xtensa-add-flat-support-checkpatch-fixes.patch
xtensa-nommu-support.patch
xtensa-variant-specific-code.patch
xtensa-variant-irq-set-callbacks.patch
xtensa-s6000-variant-core-definitions.patch
xtensa-s6000-variant.patch
xtensa-s6000-gpio-driver.patch
xtensa-let-platform-override-kerneloffset.patch
xtensa-platform-stretch-s6105-eval-board.patch
xtensa-cache-inquiry-and-unaligned-cache-handling-functions.patch
xtensa-s6000-dma-engine-support.patch
xtensa-allow-platform-and-variant-to-initialize-own-irq-chips.patch
xtensa-support-s6000-gpio-irqs-and-alternate-function-selection.patch
s6gmac-xtensa-s6000-on-chip-ethernet-driver.patch
xtensa-s6105-specific-configuration-for-s6gmac.patch
xtensa-enable-s6gmac-in-s6105_defconfig.patch
flat-fix-data-sections-alignment.patch
flat-fix-data-sections-alignment-update.patch

