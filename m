From: akpm@linux-foundation.org
Subject: - mm-remap_pfn_range-restore-missing-flush.patch removed from -mm tree
Date: Sat, 15 Nov 2008 08:25:23 -0800
Message-ID: <200811151625.mAFGPN3C004009@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34867 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751345AbYKOQZg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 15 Nov 2008 11:25:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeremy@goop.org, hannes@cmpxchg.org, hugh@veritas.com, jeremy.fitzhardinge@citix.com, nickpiggin@yahoo.com.au, venkatesh.pallipadi@intel.com, mm-commits@vger.kernel.org


The patch titled
     mm/remap_pfn_range: restore missing flush
has been removed from the -mm tree.  Its filename was
     mm-remap_pfn_range-restore-missing-flush.patch

This patch was dropped because it was nacked

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm/remap_pfn_range: restore missing flush
From: Jeremy Fitzhardinge <jeremy@goop.org>

Restore the cache flush and BUG_ON removed in the conversion to using
apply_to_page_range().

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citix.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN mm/memory.c~mm-remap_pfn_range-restore-missing-flush mm/memory.c
--- a/mm/memory.c~mm-remap_pfn_range-restore-missing-flush
+++ a/mm/memory.c
@@ -1485,6 +1485,8 @@ static int remap_area_pte_fn(pte_t *ptep
 	struct remap_data *rmd = data;
 	pte_t pte = pte_mkspecial(pfn_pte(rmd->pfn++, rmd->prot));
 
+	BUG_ON(!pte_none(*ptep));
+
 	set_pte_at(rmd->mm, addr, ptep, pte);
 
 	return 0;
@@ -1536,6 +1538,8 @@ int remap_pfn_range(struct vm_area_struc
 
 	BUG_ON(addr >= end);
 
+	flush_cache_range(vma, addr, end);
+
 	rmd.mm = mm;
 	rmd.pfn = pfn;
 	rmd.prot = prot;
_

Patches currently in -mm which might be from jeremy@goop.org are

linux-next.patch
mm-apply_to_range-call-pte-function-with-lazy-updates.patch
mm-remap_pfn_range-restore-missing-flush.patch
drivers-xen-xenbus-xenbus_clientc-cleanup-kerneldoc.patch

