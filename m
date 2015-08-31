From: akpm@linux-foundation.org
Subject: + mm-fix-type-information-of-memoryless-node.patch added to -mm
 tree
Date: Mon, 31 Aug 2015 13:03:08 -0700
Message-ID: <55e4b2fc.WfVbnbr3c4b2APdH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49372 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345AbbHaUDJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 31 Aug 2015 16:03:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: thunder.leizhen@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc.c: fix type information of memoryless node
has been added to the -mm tree.  Its filename is
     mm-fix-type-information-of-memoryless-node.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fix-type-information-of-memoryless-node.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-type-information-of-memoryless-node.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Zhen Lei <thunder.leizhen@huawei.com>
Subject: mm/page_alloc.c: fix type information of memoryless node

For a memoryless node, the output of get_pfn_range_for_nid are all zero.
It will display mem from 0 to -1.

Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-fix-type-information-of-memoryless-node mm/page_alloc.c
--- a/mm/page_alloc.c~mm-fix-type-information-of-memoryless-node
+++ a/mm/page_alloc.c
@@ -5455,7 +5455,8 @@ void __paginginit free_area_init_node(in
 #ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
 	get_pfn_range_for_nid(nid, &start_pfn, &end_pfn);
 	pr_info("Initmem setup node %d [mem %#018Lx-%#018Lx]\n", nid,
-		(u64)start_pfn << PAGE_SHIFT, ((u64)end_pfn << PAGE_SHIFT) - 1);
+		(u64)start_pfn << PAGE_SHIFT,
+		end_pfn ? ((u64)end_pfn << PAGE_SHIFT) - 1 : 0);
 #endif
 	calculate_node_totalpages(pgdat, start_pfn, end_pfn,
 				  zones_size, zholes_size);
_

Patches currently in -mm which might be from thunder.leizhen@huawei.com are

mm-fix-type-information-of-memoryless-node.patch

