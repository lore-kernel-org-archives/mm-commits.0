From: akpm@linux-foundation.org
Subject: [merged] mm-bootmemc-properly-__init-annotate-helper-functions.patch removed from -mm tree
Date: Tue, 15 Dec 2009 13:54:16 -0800
Message-ID: <200912152154.nBFLsGAp015344@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49881 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933877AbZLOWLM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 17:11:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: JBeulich@novell.com, hannes@cmpxchg.org, jbeulich@novell.com, mm-commits@vger.kernel.org


The patch titled
     mm/bootmem.c: properly __init-annotate helper functions
has been removed from the -mm tree.  Its filename was
     mm-bootmemc-properly-__init-annotate-helper-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm/bootmem.c: properly __init-annotate helper functions
From: "Jan Beulich" <JBeulich@novell.com>

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/bootmem.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN mm/bootmem.c~mm-bootmemc-properly-__init-annotate-helper-functions mm/bootmem.c
--- a/mm/bootmem.c~mm-bootmemc-properly-__init-annotate-helper-functions
+++ a/mm/bootmem.c
@@ -432,8 +432,8 @@ int __init reserve_bootmem(unsigned long
 	return mark_bootmem(start, end, 1, flags);
 }
 
-static unsigned long align_idx(struct bootmem_data *bdata, unsigned long idx,
-			unsigned long step)
+static unsigned long __init align_idx(struct bootmem_data *bdata,
+				      unsigned long idx, unsigned long step)
 {
 	unsigned long base = bdata->node_min_pfn;
 
@@ -445,8 +445,8 @@ static unsigned long align_idx(struct bo
 	return ALIGN(base + idx, step) - base;
 }
 
-static unsigned long align_off(struct bootmem_data *bdata, unsigned long off,
-			unsigned long align)
+static unsigned long __init align_off(struct bootmem_data *bdata,
+				      unsigned long off, unsigned long align)
 {
 	unsigned long base = PFN_PHYS(bdata->node_min_pfn);
 
_

Patches currently in -mm which might be from JBeulich@novell.com are

origin.patch
linux-next.patch
mm-vmallocc-dont-use-vmalloc_end.patch
fix-section-mismatch-in-early-ehci-dbgp.patch
dma-mapping-fix-off-by-one-error-in-dma_capable.patch

