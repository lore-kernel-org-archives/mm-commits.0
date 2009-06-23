From: akpm@linux-foundation.org
Subject: [merged] xtensa-cache-inquiry-and-unaligned-cache-handling-functions.patch removed from -mm tree
Date: Tue, 23 Jun 2009 11:05:31 -0700
Message-ID: <200906231805.n5NI5VtY009609@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35181 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751523AbZFWSFt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Jun 2009 14:05:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: os@emlix.com, chris@zankel.net, dg@emlix.com, jw@emlix.com, mm-commits@vger.kernel.org


The patch titled
     xtensa: cache inquiry and unaligned cache handling functions
has been removed from the -mm tree.  Its filename was
     xtensa-cache-inquiry-and-unaligned-cache-handling-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
xtensa-variant-specific-code.patch

