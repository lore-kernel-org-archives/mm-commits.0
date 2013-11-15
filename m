From: akpm@linux-foundation.org
Subject: [merged] tile-handle-pgtable_page_ctor-fail.patch removed from
 -mm tree
Date: Fri, 15 Nov 2013 12:08:34 -0800
Message-ID: <52867f42.ZKS7ziZoBjtAPC9f%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35713 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753058Ab3KOUIe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Nov 2013 15:08:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, cmetcalf@tilera.com, kirill.shutemov@linux.intel.com

Subject: [merged] tile-handle-pgtable_page_ctor-fail.patch removed from -mm tree
To: kirill.shutemov@linux.intel.com,cmetcalf@tilera.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 15 Nov 2013 12:08:34 -0800


The patch titled
     Subject: tile: handle pgtable_page_ctor() fail
has been removed from the -mm tree.  Its filename was
     tile-handle-pgtable_page_ctor-fail.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: tile: handle pgtable_page_ctor() fail

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Chris Metcalf <cmetcalf@tilera.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/tile/mm/pgtable.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN arch/tile/mm/pgtable.c~tile-handle-pgtable_page_ctor-fail arch/tile/mm/pgtable.c
--- a/arch/tile/mm/pgtable.c~tile-handle-pgtable_page_ctor-fail
+++ a/arch/tile/mm/pgtable.c
@@ -241,6 +241,11 @@ struct page *pgtable_alloc_one(struct mm
 	if (p == NULL)
 		return NULL;
 
+	if (!pgtable_page_ctor(p)) {
+		__free_pages(p, L2_USER_PGTABLE_ORDER);
+		return NULL;
+	}
+
 	/*
 	 * Make every page have a page_count() of one, not just the first.
 	 * We don't use __GFP_COMP since it doesn't look like it works
@@ -251,7 +256,6 @@ struct page *pgtable_alloc_one(struct mm
 		inc_zone_page_state(p+i, NR_PAGETABLE);
 	}
 
-	pgtable_page_ctor(p);
 	return p;
 }
 
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

origin.patch
x86-mm-get-aslr-work-for-hugetlb-mappings.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch

