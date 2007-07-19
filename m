From: akpm@linux-foundation.org
Subject: - hugetlb-use-set_compound_page_dtor.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:04:17 -0700
Message-ID: <200707192004.l6JK4Ho9019937@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51955 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756036AbXGSU0D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:26:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, agl@us.ibm.com, wli@holomorphy.com, mm-commits@vger.kernel.org


The patch titled
     hugetlb: use set_compound_page_dtor
has been removed from the -mm tree.  Its filename was
     hugetlb-use-set_compound_page_dtor.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: hugetlb: use set_compound_page_dtor
From: Akinobu Mita <akinobu.mita@gmail.com>

Use appropriate accessor function to set compound page destructor
function.

Cc:  William Irwin <wli@holomorphy.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Acked-by: Adam Litke <agl@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/hugetlb.c~hugetlb-use-set_compound_page_dtor mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-use-set_compound_page_dtor
+++ a/mm/hugetlb.c
@@ -208,7 +208,7 @@ static void update_and_free_page(struct 
 				1 << PG_dirty | 1 << PG_active | 1 << PG_reserved |
 				1 << PG_private | 1<< PG_writeback);
 	}
-	page[1].lru.next = NULL;
+	set_compound_page_dtor(page, NULL);
 	set_page_refcounted(page);
 	__free_pages(page, HUGETLB_PAGE_ORDER);
 }
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
auth_gss-unregister-gss_domain-when-unloading-module.patch
