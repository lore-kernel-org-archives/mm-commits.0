From: akpm@linux-foundation.org
Subject: [patch 090/131] sparc64: optimize struct page zeroing
Date: Wed, 15 Nov 2017 17:36:48 -0800
Message-ID: <20171116013648.iWq8H3_DM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40106 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933058AbdKPBgv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Nov 2017 20:36:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ard.biesheuvel@linaro.org, aryabinin@virtuozzo.com, bob.picco@oracle.com, borntraeger@de.ibm.com, catalin.marinas@arm.com, daniel.m.jordan@oracle.com, davem@davemloft.net, dvyukov@google.com, glider@google.com, heiko.carstens@de.ibm.com, hpa@zytor.com, mark.rutland@arm.com, mgorman@techsingularity.net, mhocko@kernel.org, mhocko@suse.com, mingo@redhat.com, mm-commits@vger.kernel.org, pasha.tatashin@oracle.com, sam@ravnborg.org, steven.sistare@oracle.com, tglx@linutronix.de, torvalds@linux-foundation.org, will.deacon@arm.com, willy@infradead.org

From: Pavel Tatashin <pasha.tatashin@oracle.com>
Subject: sparc64: optimize struct page zeroing

Add an optimized mm_zero_struct_page(), so struct page's are zeroed
without calling memset().  We do eight to ten regular stores based on the
size of struct page.  Compiler optimizes out the conditions of switch()
statement.

SPARC-M6 with 15T of memory, single thread performance:

                               BASE            FIX  OPTIMIZED_FIX
        bootmem_init   28.440467985s   2.305674818s   2.305161615s
free_area_init_nodes  202.845901673s 225.343084508s 172.556506560s
                      --------------------------------------------
Total                 231.286369658s 227.648759326s 174.861668175s

BASE:  current linux
FIX:   This patch series without "optimized struct page zeroing"
OPTIMIZED_FIX: This patch series including the current patch.

bootmem_init() is where memory for struct pages is zeroed during
allocation.  Note, about two seconds in this function is a fixed time: it
does not increase as memory is increased.

Link: http://lkml.kernel.org/r/20171013173214.27300-11-pasha.tatashin@oracle.com
Signed-off-by: Pavel Tatashin <pasha.tatashin@oracle.com>
Reviewed-by: Steven Sistare <steven.sistare@oracle.com>
Reviewed-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Reviewed-by: Bob Picco <bob.picco@oracle.com>
Acked-by: David S. Miller <davem@davemloft.net>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/include/asm/pgtable_64.h |   30 ++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff -puN arch/sparc/include/asm/pgtable_64.h~sparc64-optimized-struct-page-zeroing arch/sparc/include/asm/pgtable_64.h
--- a/arch/sparc/include/asm/pgtable_64.h~sparc64-optimized-struct-page-zeroing
+++ a/arch/sparc/include/asm/pgtable_64.h
@@ -231,6 +231,36 @@ extern unsigned long _PAGE_ALL_SZ_BITS;
 extern struct page *mem_map_zero;
 #define ZERO_PAGE(vaddr)	(mem_map_zero)
 
+/* This macro must be updated when the size of struct page grows above 80
+ * or reduces below 64.
+ * The idea that compiler optimizes out switch() statement, and only
+ * leaves clrx instructions
+ */
+#define	mm_zero_struct_page(pp) do {					\
+	unsigned long *_pp = (void *)(pp);				\
+									\
+	 /* Check that struct page is either 64, 72, or 80 bytes */	\
+	BUILD_BUG_ON(sizeof(struct page) & 7);				\
+	BUILD_BUG_ON(sizeof(struct page) < 64);				\
+	BUILD_BUG_ON(sizeof(struct page) > 80);				\
+									\
+	switch (sizeof(struct page)) {					\
+	case 80:							\
+		_pp[9] = 0;	/* fallthrough */			\
+	case 72:							\
+		_pp[8] = 0;	/* fallthrough */			\
+	default:							\
+		_pp[7] = 0;						\
+		_pp[6] = 0;						\
+		_pp[5] = 0;						\
+		_pp[4] = 0;						\
+		_pp[3] = 0;						\
+		_pp[2] = 0;						\
+		_pp[1] = 0;						\
+		_pp[0] = 0;						\
+	}								\
+} while (0)
+
 /* PFNs are real physical page numbers.  However, mem_map only begins to record
  * per-page information starting at pfn_base.  This is to handle systems where
  * the first physical page in the machine is at some huge physical address,
_
