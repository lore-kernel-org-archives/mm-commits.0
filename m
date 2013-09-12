From: akpm@linux-foundation.org
Subject: [merged] mm-zswapc-get-swapper-address_space-by-using-macro.patch removed from -mm tree
Date: Thu, 12 Sep 2013 12:42:25 -0700
Message-ID: <52321921.0MzggzszoSlxIqhN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57993 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753000Ab3ILTmZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:42:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sjenning@linux.vnet.ibm.com, liwanp@linux.vnet.ibm.com, bob.liu@oracle.com, sunghan.suh@samsung.com

Subject: [merged] mm-zswapc-get-swapper-address_space-by-using-macro.patch removed from -mm tree
To: sunghan.suh@samsung.com,bob.liu@oracle.com,liwanp@linux.vnet.ibm.com,sjenning@linux.vnet.ibm.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:42:25 -0700


The patch titled
     Subject: mm/zswap.c: get swapper address_space by using macro
has been removed from the -mm tree.  Its filename was
     mm-zswapc-get-swapper-address_space-by-using-macro.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sunghan Suh <sunghan.suh@samsung.com>
Subject: mm/zswap.c: get swapper address_space by using macro

There is a proper macro to get the corresponding swapper address space
from a swap entry.  Instead of directly accessing "swapper_spaces" array,
use the "swap_address_space" macro.

Signed-off-by: Sunghan Suh <sunghan.suh@samsung.com>
Reviewed-by: Bob Liu <bob.liu@oracle.com>
Reviewed-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Acked-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/zswap.c~mm-zswapc-get-swapper-address_space-by-using-macro mm/zswap.c
--- a/mm/zswap.c~mm-zswapc-get-swapper-address_space-by-using-macro
+++ a/mm/zswap.c
@@ -409,7 +409,7 @@ static int zswap_get_swap_cache_page(swp
 				struct page **retpage)
 {
 	struct page *found_page, *new_page = NULL;
-	struct address_space *swapper_space = &swapper_spaces[swp_type(entry)];
+	struct address_space *swapper_space = swap_address_space(entry);
 	int err;
 
 	*retpage = NULL;
_

Patches currently in -mm which might be from sunghan.suh@samsung.com are

origin.patch

