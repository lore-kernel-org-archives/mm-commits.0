From: akpm@linux-foundation.org
Subject: + mm-use-pgdat_end_pfn-to-simplify-the-code-in-arch.patch added
 to -mm tree
Date: Wed, 18 Sep 2013 16:12:35 -0700
Message-ID: <523a3363.Eu4KTB4nolpoYqem%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47868 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511Ab3IRXMg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Sep 2013 19:12:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tony.luck@intel.com, paulus@samba.org, lethal@linux-sh.org, james.hogan@imgtec.com, benh@kernel.crashing.org, qiuxishi@huawei.com

Subject: + mm-use-pgdat_end_pfn-to-simplify-the-code-in-arch.patch added to -mm tree
To: qiuxishi@huawei.com,benh@kernel.crashing.org,james.hogan@imgtec.com,lethal@linux-sh.org,paulus@samba.org,tony.luck@intel.com
From: akpm@linux-foundation.org
Date: Wed, 18 Sep 2013 16:12:35 -0700


The patch titled
     Subject: mm: use pgdat_end_pfn() to simplify the code in arch
has been added to the -mm tree.  Its filename is
     mm-use-pgdat_end_pfn-to-simplify-the-code-in-arch.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-use-pgdat_end_pfn-to-simplify-the-code-in-arch.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-use-pgdat_end_pfn-to-simplify-the-code-in-arch.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Xishi Qiu <qiuxishi@huawei.com>
Subject: mm: use pgdat_end_pfn() to simplify the code in arch

Use "pgdat_end_pfn()" instead of "pgdat->node_start_pfn +
pgdat->node_spanned_pages".  Simplify the code, no functional change.

Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
Cc: James Hogan <james.hogan@imgtec.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/mm/init.c    |    4 +---
 arch/metag/mm/init.c   |    2 +-
 arch/powerpc/mm/numa.c |    3 +--
 arch/sh/mm/init.c      |    2 +-
 4 files changed, 4 insertions(+), 7 deletions(-)

diff -puN arch/ia64/mm/init.c~mm-use-pgdat_end_pfn-to-simplify-the-code-in-arch arch/ia64/mm/init.c
--- a/arch/ia64/mm/init.c~mm-use-pgdat_end_pfn-to-simplify-the-code-in-arch
+++ a/arch/ia64/mm/init.c
@@ -357,9 +357,7 @@ int vmemmap_find_next_valid_pfn(int node
 
 	end_address = (unsigned long) &vmem_map[pgdat->node_start_pfn + i];
 	end_address = PAGE_ALIGN(end_address);
-
-	stop_address = (unsigned long) &vmem_map[
-		pgdat->node_start_pfn + pgdat->node_spanned_pages];
+	stop_address = (unsigned long) &vmem_map[pgdat_end_pfn(pgdat)];
 
 	do {
 		pgd_t *pgd;
diff -puN arch/metag/mm/init.c~mm-use-pgdat_end_pfn-to-simplify-the-code-in-arch arch/metag/mm/init.c
--- a/arch/metag/mm/init.c~mm-use-pgdat_end_pfn-to-simplify-the-code-in-arch
+++ a/arch/metag/mm/init.c
@@ -149,7 +149,7 @@ static void __init bootmem_init_one_node
 	if (!p->node_spanned_pages)
 		return;
 
-	end_pfn = p->node_start_pfn + p->node_spanned_pages;
+	end_pfn = pgdat_end_pfn(p);
 #ifdef CONFIG_HIGHMEM
 	if (end_pfn > max_low_pfn)
 		end_pfn = max_low_pfn;
diff -puN arch/powerpc/mm/numa.c~mm-use-pgdat_end_pfn-to-simplify-the-code-in-arch arch/powerpc/mm/numa.c
--- a/arch/powerpc/mm/numa.c~mm-use-pgdat_end_pfn-to-simplify-the-code-in-arch
+++ a/arch/powerpc/mm/numa.c
@@ -938,8 +938,7 @@ static void __init mark_reserved_regions
 		unsigned long start_pfn = physbase >> PAGE_SHIFT;
 		unsigned long end_pfn = PFN_UP(physbase + size);
 		struct node_active_region node_ar;
-		unsigned long node_end_pfn = node->node_start_pfn +
-					     node->node_spanned_pages;
+		unsigned long node_end_pfn = pgdat_end_pfn(node);
 
 		/*
 		 * Check to make sure that this memblock.reserved area is
diff -puN arch/sh/mm/init.c~mm-use-pgdat_end_pfn-to-simplify-the-code-in-arch arch/sh/mm/init.c
--- a/arch/sh/mm/init.c~mm-use-pgdat_end_pfn-to-simplify-the-code-in-arch
+++ a/arch/sh/mm/init.c
@@ -231,7 +231,7 @@ static void __init bootmem_init_one_node
 	if (!p->node_spanned_pages)
 		return;
 
-	end_pfn = p->node_start_pfn + p->node_spanned_pages;
+	end_pfn = pgdat_end_pfn(p);
 
 	total_pages = bootmem_bootmap_pages(p->node_spanned_pages);
 
_

Patches currently in -mm which might be from qiuxishi@huawei.com are

mm-arch-use-__free_reserved_page-to-simplify-the-code.patch
drivers-video-acornfbc-use-__free_reserved_page-to-simplify-the-code.patch
mm-use-pgdat_end_pfn-to-simplify-the-code-in-arch.patch
mm-use-pgdat_end_pfn-to-simplify-the-code-in-others.patch
documentation-dma-attributestxt-fix-typo.patch

