From: akpm@linux-foundation.org
Subject: [folded-merged] mm-use-unsigned-int-for-page-order-fix-2.patch
 removed from -mm tree
Date: Fri, 06 Nov 2015 16:13:01 -0800
Message-ID: <563d420d.MkAITEAx2e6LYz02%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52669 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753331AbbKGANB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 19:13:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: use unsigned int for page order fix 2
has been removed from the -mm tree.  Its filename was
     mm-use-unsigned-int-for-page-order-fix-2.patch

This patch was dropped because it was folded into mm-use-unsigned-int-for-page-order.patch

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm: use unsigned int for page order fix 2

Some configs now end up with MAX_ORDER and pageblock_order having
different types: silence compiler warning in __free_one_page().

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-use-unsigned-int-for-page-order-fix-2 mm/page_alloc.c
--- a/mm/page_alloc.c~mm-use-unsigned-int-for-page-order-fix-2
+++ a/mm/page_alloc.c
@@ -675,7 +675,7 @@ static inline void __free_one_page(struc
 		 * pageblock. Without this, pageblock isolation
 		 * could cause incorrect freepage accounting.
 		 */
-		max_order = min(MAX_ORDER, pageblock_order + 1);
+		max_order = min_t(unsigned int, MAX_ORDER, pageblock_order + 1);
 	} else {
 		__mod_zone_freepage_state(zone, 1 << order, migratetype);
 	}
_

Patches currently in -mm which might be from hughd@google.com are

mm-use-unsigned-int-for-page-order.patch

