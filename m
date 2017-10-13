From: akpm@linux-foundation.org
Subject: + sparc64-optimized-struct-page-zeroing.patch added to -mm tree
Date: Fri, 13 Oct 2017 14:19:07 -0700
Message-ID: <59e12dcb.159im5ZqGdmi0lY8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58972 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751509AbdJMVTJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 Oct 2017 17:19:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pasha.tatashin@oracle.com, ard.biesheuvel@linaro.org, aryabinin@virtuozzo.com, bob.picco@oracle.com, borntraeger@de.ibm.com, catalin.marinas@arm.com, daniel.m.jordan@oracle.com, davem@davemloft.net, dvyukov@google.com, glider@google.com, heiko.carstens@de.ibm.com, hpa@zytor.com, mark.rutland@arm.com, mgorman@techsingularity.net, mhocko@kernel.org, mhocko@suse.com, mingo@redhat.com, sam@ravnborg.org, steven.sistare@oracle.com, tglx@linutronix.de, will.deacon@arm.com, willy@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: sparc64: optimize struct page zeroing
has been added to the -mm tree.  Its filename is
     sparc64-optimized-struct-page-zeroing.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/sparc64-optimized-struct-page-zeroing.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/sparc64-optimized-struct-page-zeroing.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
@@ -230,6 +230,36 @@ extern unsigned long _PAGE_ALL_SZ_BITS;
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

Patches currently in -mm which might be from pasha.tatashin@oracle.com are

mm-deferred_init_memmap-improvements.patch
x86-mm-setting-fields-in-deferred-pages.patch
sparc64-mm-setting-fields-in-deferred-pages.patch
sparc64-simplify-vmemmap_populate.patch
mm-defining-memblock_virt_alloc_try_nid_raw.patch
mm-zero-reserved-and-unavailable-struct-pages.patch
x86-kasan-add-and-use-kasan_map_populate.patch
arm64-kasan-add-and-use-kasan_map_populate.patch
mm-stop-zeroing-memory-during-allocation-in-vmemmap.patch
sparc64-optimized-struct-page-zeroing.patch
sparc64-ng4-memset-32-bits-overflow.patch

