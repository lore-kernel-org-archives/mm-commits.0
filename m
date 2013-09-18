From: akpm@linux-foundation.org
Subject: + mm-use-pgdat_end_pfn-to-simplify-the-code-in-others.patch added to -mm tree
Date: Wed, 18 Sep 2013 16:12:36 -0700
Message-ID: <523a3364.8exAmJDi5L/83mzj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47871 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751828Ab3IRXMh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Sep 2013 19:12:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, qiuxishi@huawei.com

Subject: + mm-use-pgdat_end_pfn-to-simplify-the-code-in-others.patch added to -mm tree
To: qiuxishi@huawei.com
From: akpm@linux-foundation.org
Date: Wed, 18 Sep 2013 16:12:36 -0700


The patch titled
     Subject: mm: use pgdat_end_pfn() to simplify the code in others
has been added to the -mm tree.  Its filename is
     mm-use-pgdat_end_pfn-to-simplify-the-code-in-others.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-use-pgdat_end_pfn-to-simplify-the-code-in-others.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-use-pgdat_end_pfn-to-simplify-the-code-in-others.patch

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
Subject: mm: use pgdat_end_pfn() to simplify the code in others

Use "pgdat_end_pfn()" instead of "pgdat->node_start_pfn +
pgdat->node_spanned_pages".  Simplify the code, no functional change.

Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/kcore.c     |    3 +--
 mm/bootmem.c        |    2 +-
 mm/memory_hotplug.c |    9 ++++-----
 3 files changed, 6 insertions(+), 8 deletions(-)

diff -puN fs/proc/kcore.c~mm-use-pgdat_end_pfn-to-simplify-the-code-in-others fs/proc/kcore.c
--- a/fs/proc/kcore.c~mm-use-pgdat_end_pfn-to-simplify-the-code-in-others
+++ a/fs/proc/kcore.c
@@ -255,8 +255,7 @@ static int kcore_update_ram(void)
 	end_pfn = 0;
 	for_each_node_state(nid, N_MEMORY) {
 		unsigned long node_end;
-		node_end  = NODE_DATA(nid)->node_start_pfn +
-			NODE_DATA(nid)->node_spanned_pages;
+		node_end = node_end_pfn(nid);
 		if (end_pfn < node_end)
 			end_pfn = node_end;
 	}
diff -puN mm/bootmem.c~mm-use-pgdat_end_pfn-to-simplify-the-code-in-others mm/bootmem.c
--- a/mm/bootmem.c~mm-use-pgdat_end_pfn-to-simplify-the-code-in-others
+++ a/mm/bootmem.c
@@ -784,7 +784,7 @@ void * __init __alloc_bootmem_node_high(
 		return kzalloc_node(size, GFP_NOWAIT, pgdat->node_id);
 
 	/* update goal according ...MAX_DMA32_PFN */
-	end_pfn = pgdat->node_start_pfn + pgdat->node_spanned_pages;
+	end_pfn = pgdat_end_pfn(pgdat);
 
 	if (end_pfn > MAX_DMA32_PFN + (128 >> (20 - PAGE_SHIFT)) &&
 	    (goal >> PAGE_SHIFT) < MAX_DMA32_PFN) {
diff -puN mm/memory_hotplug.c~mm-use-pgdat_end_pfn-to-simplify-the-code-in-others mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-use-pgdat_end_pfn-to-simplify-the-code-in-others
+++ a/mm/memory_hotplug.c
@@ -365,8 +365,7 @@ out_fail:
 static void grow_pgdat_span(struct pglist_data *pgdat, unsigned long start_pfn,
 			    unsigned long end_pfn)
 {
-	unsigned long old_pgdat_end_pfn =
-		pgdat->node_start_pfn + pgdat->node_spanned_pages;
+	unsigned long old_pgdat_end_pfn = pgdat_end_pfn(pgdat);
 
 	if (!pgdat->node_spanned_pages || start_pfn < pgdat->node_start_pfn)
 		pgdat->node_start_pfn = start_pfn;
@@ -579,9 +578,9 @@ static void shrink_zone_span(struct zone
 static void shrink_pgdat_span(struct pglist_data *pgdat,
 			      unsigned long start_pfn, unsigned long end_pfn)
 {
-	unsigned long pgdat_start_pfn =  pgdat->node_start_pfn;
-	unsigned long pgdat_end_pfn =
-		pgdat->node_start_pfn + pgdat->node_spanned_pages;
+	unsigned long pgdat_start_pfn = pgdat->node_start_pfn;
+	unsigned long p = pgdat_end_pfn(pgdat); /* pgdat_end_pfn namespace clash */
+	unsigned long pgdat_end_pfn = p;
 	unsigned long pfn;
 	struct mem_section *ms;
 	int nid = pgdat->node_id;
_

Patches currently in -mm which might be from qiuxishi@huawei.com are

mm-arch-use-__free_reserved_page-to-simplify-the-code.patch
drivers-video-acornfbc-use-__free_reserved_page-to-simplify-the-code.patch
mm-use-pgdat_end_pfn-to-simplify-the-code-in-arch.patch
mm-use-pgdat_end_pfn-to-simplify-the-code-in-others.patch
documentation-dma-attributestxt-fix-typo.patch

