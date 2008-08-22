From: akpm@linux-foundation.org
Subject: + mm-skip-memory-holes-in-flatmem-when-reading-proc-pagetypeinfo.patch added to -mm tree
Date: Fri, 22 Aug 2008 09:15:55 -0700
Message-ID: <200808221615.m7MGFt0a004520@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57675 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751581AbYHVQQ7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 22 Aug 2008 12:16:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie, hsweeten@visionengravers.com, rmk@arm.linux.org.uk, stable@kernel.org


The patch titled
     mm: skip memory holes in FLATMEM when reading /proc/pagetypeinfo
has been added to the -mm tree.  Its filename is
     mm-skip-memory-holes-in-flatmem-when-reading-proc-pagetypeinfo.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: skip memory holes in FLATMEM when reading /proc/pagetypeinfo
From: Mel Gorman <mel@csn.ul.ie>

Fixes an oops on arm.

Ordinarily, memory holes in flatmem still have a valid memmap and is safe
to use.  However, an architecture (ARM) frees up the memmap backing memory
holes on the assumption it is never used.  /proc/pagetypeinfo reads the
whole range of pages in a zone believing that the memmap is valid and that
pfn_valid will return false if it is not.  On ARM, freeing the memmap
breaks the page->zone linkages even though pfn_valid() returns true and
the kernel can oops shortly afterwards due to accessing a bogus struct
zone *.

This patch lets architectures say when FLATMEM can have holes in the
memmap.  Rather than an expensive check for valid memory,
/proc/pagetypeinfo will confirm that the page linkages are still valid by
checking page->zone is still the expected zone.  The lookup of page_zone
is safe as there is a limited range of memory that is accessed when
calling page_zone.  Even if page_zone happens to return the correct zone,
the impact is that the counters in /proc/pagetypeinfo are slightly off but
fragmentation monitoring is unlikely to be relevant on an embedded system.

Reported-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Tested-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: <stable@kernel.org>		[2.6.25.x, 2.6.26.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/Kconfig |    5 +++++
 mm/vmstat.c      |   19 ++++++++++++++++++-
 2 files changed, 23 insertions(+), 1 deletion(-)

diff -puN arch/arm/Kconfig~mm-skip-memory-holes-in-flatmem-when-reading-proc-pagetypeinfo arch/arm/Kconfig
--- a/arch/arm/Kconfig~mm-skip-memory-holes-in-flatmem-when-reading-proc-pagetypeinfo
+++ a/arch/arm/Kconfig
@@ -810,6 +810,11 @@ config OABI_COMPAT
 	  UNPREDICTABLE (in fact it can be predicted that it won't work
 	  at all). If in doubt say Y.
 
+config ARCH_FLATMEM_HAS_HOLES
+	bool
+	default y
+	depends on FLATMEM
+
 config ARCH_DISCONTIGMEM_ENABLE
 	bool
 	default (ARCH_LH7A40X && !LH7A40X_CONTIGMEM)
diff -puN mm/vmstat.c~mm-skip-memory-holes-in-flatmem-when-reading-proc-pagetypeinfo mm/vmstat.c
--- a/mm/vmstat.c~mm-skip-memory-holes-in-flatmem-when-reading-proc-pagetypeinfo
+++ a/mm/vmstat.c
@@ -516,9 +516,26 @@ static void pagetypeinfo_showblockcount_
 			continue;
 
 		page = pfn_to_page(pfn);
+#ifdef CONFIG_ARCH_FLATMEM_HAS_HOLES
+		/*
+		 * Ordinarily, memory holes in flatmem still have a valid
+		 * memmap for the PFN range. However, an architecture for
+		 * embedded systems (e.g. ARM) can free up the memmap backing
+		 * holes to save memory on the assumption the memmap is
+		 * never used. The page_zone linkages are then broken even
+		 * though pfn_valid() returns true. Skip the page if the
+		 * linkages are broken. Even if this test passed, the impact
+		 * is that the counters for the movable type are off but
+		 * fragmentation monitoring is likely meaningless on small
+		 * systems.
+		 */
+		if (page_zone(page) != zone)
+			continue;
+#endif
 		mtype = get_pageblock_migratetype(page);
 
-		count[mtype]++;
+		if (mtype < MIGRATE_TYPES)
+			count[mtype]++;
 	}
 
 	/* Print counts */
_

Patches currently in -mm which might be from mel@csn.ul.ie are

mm-make-setup_zone_migrate_reserve-aware-of-overlapping-nodes.patch
mm-skip-memory-holes-in-flatmem-when-reading-proc-pagetypeinfo.patch
mm-page_allocc-free_area_init_nodes-fix-inappropriate-use-of-enum.patch
page-owner-tracking-leak-detector.patch
add-debugging-aid-for-memory-initialisation-problems.patch

