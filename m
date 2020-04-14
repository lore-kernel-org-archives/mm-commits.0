From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-make-early_pfn_to_nid-and-related-defintions-close-to-each-other.patch
 added to -mm tree
Date: Mon, 13 Apr 2020 17:25:37 -0700
Message-ID: <20200414002537.oabwKHaO2%akpm@linux-foundation.org>
References: <20200412004155.1a8f4e081b4e03ef5903abb5@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:58074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727878AbgDNAZk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 13 Apr 2020 20:25:40 -0400
In-Reply-To: <20200412004155.1a8f4e081b4e03ef5903abb5@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bcain@codeaurora.org, bhe@redhat.com, catalin.marinas@arm.com, corbet@lwn.net, dalias@libc.org, davem@davemloft.net, deller@gmx.de, geert@linux-m68k.org, gerg@linux-m68k.org, green.hu@gmail.com, guoren@kernel.org, gxt@pku.edu.cn, heiko.carstens@de.ibm.com, Hoan@os.amperecomputing.com, James.Bottomley@HansenPartnership.com, jcmvbkbc@gmail.com, ley.foon.tan@intel.com, linux@armlinux.org.uk, mattst88@gmail.com, mhocko@kernel.org, mm-commits@vger.kernel.org, monstr@monstr.eu, mpe@ellerman.id.au, msalter@redhat.com, nickhu@andestech.com, paul.walmsley@sifive.com, richard@nod.at, rppt@linux.ibm.com, shorne@gmail.com, tony.luck@intel.com, tsbogend@alpha.franken.de, vgupta@synopsys.com, ysato@users.sourceforge.jp


The patch titled
     Subject: mm: make early_pfn_to_nid() and related defintions close to each other
has been added to the -mm tree.  Its filename is
     mm-make-early_pfn_to_nid-and-related-defintions-close-to-each-other.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-make-early_pfn_to_nid-and-related-defintions-close-to-each-other.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-make-early_pfn_to_nid-and-related-defintions-close-to-each-other.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mike Rapoport <rppt@linux.ibm.com>
Subject: mm: make early_pfn_to_nid() and related defintions close to each other

early_pfn_to_nid() and its helper __early_pfn_to_nid() are spread around
include/linux/mm.h, include/linux/mmzone.h and mm/page_alloc.c.

Drop unused stub for __early_pfn_to_nid() and move its actual generic
implementation close to its users.

Link: http://lkml.kernel.org/r/20200412194859.12663-3-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Brian Cain <bcain@codeaurora.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Greentime Hu <green.hu@gmail.com>
Cc: Greg Ungerer <gerg@linux-m68k.org>
Cc: Guan Xuetao <gxt@pku.edu.cn>
Cc: Guo Ren <guoren@kernel.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Helge Deller <deller@gmx.de>
Cc: Hoan Tran <Hoan@os.amperecomputing.com>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Ley Foon Tan <ley.foon.tan@intel.com>
Cc: Mark Salter <msalter@redhat.com>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Nick Hu <nickhu@andestech.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Rich Felker <dalias@libc.org>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Stafford Horne <shorne@gmail.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Vineet Gupta <vgupta@synopsys.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h     |    4 +--
 include/linux/mmzone.h |    9 ------
 mm/page_alloc.c        |   51 +++++++++++++++++++--------------------
 3 files changed, 27 insertions(+), 37 deletions(-)

--- a/include/linux/mm.h~mm-make-early_pfn_to_nid-and-related-defintions-close-to-each-other
+++ a/include/linux/mm.h
@@ -2388,9 +2388,9 @@ extern void sparse_memory_present_with_a
 
 #if !defined(CONFIG_HAVE_MEMBLOCK_NODE_MAP) && \
     !defined(CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID)
-static inline int __early_pfn_to_nid(unsigned long pfn,
-					struct mminit_pfnnid_cache *state)
+static inline int early_pfn_to_nid(unsigned long pfn)
 {
+	BUILD_BUG_ON(IS_ENABLED(CONFIG_NUMA));
 	return 0;
 }
 #else
--- a/include/linux/mmzone.h~mm-make-early_pfn_to_nid-and-related-defintions-close-to-each-other
+++ a/include/linux/mmzone.h
@@ -1078,15 +1078,6 @@ static inline struct zoneref *first_zone
 #include <asm/sparsemem.h>
 #endif
 
-#if !defined(CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID) && \
-	!defined(CONFIG_HAVE_MEMBLOCK_NODE_MAP)
-static inline unsigned long early_pfn_to_nid(unsigned long pfn)
-{
-	BUILD_BUG_ON(IS_ENABLED(CONFIG_NUMA));
-	return 0;
-}
-#endif
-
 #ifdef CONFIG_FLATMEM
 #define pfn_to_nid(pfn)		(0)
 #endif
--- a/mm/page_alloc.c~mm-make-early_pfn_to_nid-and-related-defintions-close-to-each-other
+++ a/mm/page_alloc.c
@@ -1504,6 +1504,31 @@ void __free_pages_core(struct page *page
 
 static struct mminit_pfnnid_cache early_pfnnid_cache __meminitdata;
 
+#ifndef CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID
+
+/*
+ * Required by SPARSEMEM. Given a PFN, return what node the PFN is on.
+ */
+int __meminit __early_pfn_to_nid(unsigned long pfn,
+					struct mminit_pfnnid_cache *state)
+{
+	unsigned long start_pfn, end_pfn;
+	int nid;
+
+	if (state->last_start <= pfn && pfn < state->last_end)
+		return state->last_nid;
+
+	nid = memblock_search_pfn_nid(pfn, &start_pfn, &end_pfn);
+	if (nid != NUMA_NO_NODE) {
+		state->last_start = start_pfn;
+		state->last_end = end_pfn;
+		state->last_nid = nid;
+	}
+
+	return nid;
+}
+#endif /* CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID */
+
 int __meminit early_pfn_to_nid(unsigned long pfn)
 {
 	static DEFINE_SPINLOCK(early_pfn_lock);
@@ -6298,32 +6323,6 @@ void __meminit init_currently_empty_zone
 	zone->initialized = 1;
 }
 
-#ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
-#ifndef CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID
-
-/*
- * Required by SPARSEMEM. Given a PFN, return what node the PFN is on.
- */
-int __meminit __early_pfn_to_nid(unsigned long pfn,
-					struct mminit_pfnnid_cache *state)
-{
-	unsigned long start_pfn, end_pfn;
-	int nid;
-
-	if (state->last_start <= pfn && pfn < state->last_end)
-		return state->last_nid;
-
-	nid = memblock_search_pfn_nid(pfn, &start_pfn, &end_pfn);
-	if (nid != NUMA_NO_NODE) {
-		state->last_start = start_pfn;
-		state->last_end = end_pfn;
-		state->last_nid = nid;
-	}
-
-	return nid;
-}
-#endif /* CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID */
