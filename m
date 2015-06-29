From: akpm@linux-foundation.org
Subject: [merged] sparc-use-for_each_sg.patch removed from -mm tree
Date: Mon, 29 Jun 2015 13:36:59 -0700
Message-ID: <5591ac6b.tN+5Nb33h0Pegixd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50196 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753975AbbF2UhA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jun 2015 16:37:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, davem@davemloft.net, mm-commits@vger.kernel.org


The patch titled
     Subject: sparc: use for_each_sg()
has been removed from the -mm tree.  Its filename was
     sparc-use-for_each_sg.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: sparc: use for_each_sg()

This replaces the plain loop over the sglist array with for_each_sg()
macro which consists of sg_next() function calls.  Since sparc does select
ARCH_HAS_SG_CHAIN, it is necessary to use for_each_sg() in order to loop
over each sg element.  This also help find problems with drivers that do
not properly initialize their sg tables when CONFIG_DEBUG_SG is enabled.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/kernel/ldc.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN arch/sparc/kernel/ldc.c~sparc-use-for_each_sg arch/sparc/kernel/ldc.c
--- a/arch/sparc/kernel/ldc.c~sparc-use-for_each_sg
+++ a/arch/sparc/kernel/ldc.c
@@ -2086,6 +2086,7 @@ int ldc_map_sg(struct ldc_channel *lp,
 	struct cookie_state state;
 	struct ldc_iommu *iommu;
 	int err;
+	struct scatterlist *s;
 
 	if (map_perm & ~LDC_MAP_ALL)
 		return -EINVAL;
@@ -2112,9 +2113,10 @@ int ldc_map_sg(struct ldc_channel *lp,
 	state.pte_idx = (base - iommu->page_table);
 	state.nc = 0;
 
-	for (i = 0; i < num_sg; i++)
-		fill_cookies(&state, page_to_pfn(sg_page(&sg[i])) << PAGE_SHIFT,
-			     sg[i].offset, sg[i].length);
+	for_each_sg(sg, s, num_sg, i) {
+		fill_cookies(&state, page_to_pfn(sg_page(s)) << PAGE_SHIFT,
+			     s->offset, s->length);
+	}
 
 	return state.nc;
 }
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
arc-use-for_each_sg.patch
lib-scatterlist-fix-kerneldoc-for-sg_pcopy_tofrom_buffer.patch
lib-scatterlist-mark-input-buffer-parameters-as-const.patch
linux-next.patch

