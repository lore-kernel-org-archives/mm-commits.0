From: akpm@linux-foundation.org
Subject: + mm-page_alloc-add-a-vm_bug-in-__free_one_page-if-the-zone-is-uninitialized.patch added to -mm tree
Date: Fri, 01 Feb 2013 16:39:49 -0800
Message-ID: <20130202003950.4BFAB5A41B5@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f201.google.com ([209.85.216.201]:59739 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756660Ab3BBAjv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Feb 2013 19:39:51 -0500
Received: by mail-qc0-f201.google.com with SMTP id a22so505988qcs.2
        for <mm-commits@vger.kernel.org>; Fri, 01 Feb 2013 16:39:51 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jmesmon@gmail.com, catalin.marinas@arm.com, cody@linux.vnet.ibm.com, dave@linux.vnet.ibm.com, hannes@cmpxchg.org, mel@csn.ul.ie


The patch titled
     Subject: mm/page_alloc: add a VM_BUG in __free_one_page() if the zone is uninitialized.
has been added to the -mm tree.  Its filename is
     mm-page_alloc-add-a-vm_bug-in-__free_one_page-if-the-zone-is-uninitialized.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Cody P Schafer <jmesmon@gmail.com>
Subject: mm/page_alloc: add a VM_BUG in __free_one_page() if the zone is uninitialized.

Freeing pages to uninitialized zones is not handled by __free_one_page(),
and should never happen when the code is correct.

Ran into this while writing some code that dynamically onlines extra
zones.

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
Cc: David Hansen <dave@linux.vnet.ibm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/page_alloc.c~mm-page_alloc-add-a-vm_bug-in-__free_one_page-if-the-zone-is-uninitialized mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-add-a-vm_bug-in-__free_one_page-if-the-zone-is-uninitialized
+++ a/mm/page_alloc.c
@@ -537,6 +537,8 @@ static inline void __free_one_page(struc
 	unsigned long uninitialized_var(buddy_idx);
 	struct page *buddy;
 
+	VM_BUG_ON(!zone_is_initialized(zone));
+
 	if (unlikely(PageCompound(page)))
 		if (unlikely(destroy_compound_page(page, order)))
 			return;
_

Patches currently in -mm which might be from jmesmon@gmail.com are

mm-page_alloc-add-a-vm_bug-in-__free_one_page-if-the-zone-is-uninitialized.patch
mmzone-add-pgdat_end_pfnis_empty-helpers-consolidate.patch
mm-add-helper-ensure_zone_is_initialized.patch

