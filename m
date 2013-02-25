From: akpm@linux-foundation.org
Subject: [merged] mm-page_alloc-add-a-vm_bug-in-__free_one_page-if-the-zone-is-uninitialized.patch removed from -mm tree
Date: Mon, 25 Feb 2013 12:54:35 -0800
Message-ID: <20130225205435.A9B8E5A426D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f201.google.com ([209.85.128.201]:59791 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932072Ab3BYUyh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 15:54:37 -0500
Received: by mail-ve0-f201.google.com with SMTP id 14so348007vea.0
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 12:54:36 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cody@linux.vnet.ibm.com, catalin.marinas@arm.com, dave@linux.vnet.ibm.com, hannes@cmpxchg.org, mel@csn.ul.ie, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: add a VM_BUG in __free_one_page() if the zone is uninitialized.
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-add-a-vm_bug-in-__free_one_page-if-the-zone-is-uninitialized.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Cody P Schafer <cody@linux.vnet.ibm.com>
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
@@ -538,6 +538,8 @@ static inline void __free_one_page(struc
 	unsigned long uninitialized_var(buddy_idx);
 	struct page *buddy;
 
+	VM_BUG_ON(!zone_is_initialized(zone));
+
 	if (unlikely(PageCompound(page)))
 		if (unlikely(destroy_compound_page(page, order)))
 			return;
_

Patches currently in -mm which might be from cody@linux.vnet.ibm.com are

origin.patch

