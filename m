From: akpm@linux-foundation.org
Subject: + mm-remap_pfn_range-restore-missing-flush.patch added to -mm tree
Date: Fri, 14 Nov 2008 16:25:58 -0800
Message-ID: <200811150025.mAF0Pwd0018917@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50621 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751176AbYKOA0i (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Nov 2008 19:26:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeremy@goop.org, hannes@cmpxchg.org, hugh@veritas.com, jeremy.fitzhardinge@citix.com, nickpiggin@yahoo.com.au, venkatesh.pallipadi@intel.com


The patch titled
     mm/remap_pfn_range: restore missing flush
has been added to the -mm tree.  Its filename is
     mm-remap_pfn_range-restore-missing-flush.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
mm-implement-remap_pfn_range-with-apply_to_page_range.patch
mm-apply_to_range-call-pte-function-with-lazy-updates.patch
mm-remap_pfn_range-restore-missing-flush.patch
drivers-xen-xenbus-xenbus_clientc-cleanup-kerneldoc.patch

