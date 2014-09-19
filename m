From: akpm@linux-foundation.org
Subject: [to-be-updated]
 free-the-reserved-memblock-when-free-cma-pages.patch removed from -mm tree
Date: Fri, 19 Sep 2014 15:42:42 -0700
Message-ID: <541cb162.it1rF4cCmIAxWQmp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56581 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757949AbaISWmn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 19 Sep 2014 18:42:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Yalin.Wang@sonymobile.com, b.zolnierkie@samsung.com, hughd@google.com, m.szyprowski@samsung.com, mhocko@suse.cz, yalin.wang@sonymobile.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/cma.c: free the reserved memblock when free cma pages
has been removed from the -mm tree.  Its filename was
     free-the-reserved-memblock-when-free-cma-pages.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
Subject: mm/cma.c: free the reserved memblock when free cma pages

Add memblock_free to also free the reserved memblock, so that the cma
pages are not marked as reserved memory in
/sys/kernel/debug/memblock/reserved debug file

Marek said:

: When cma_activate_area() is called noone should use memblock to allocate
: memory, but it is ok to call memblock_free() to update memblock
: statistics, so users won't be confused by cma entries in
: /sys/kernel/debug/memblock/reserved file.

Signed-off-by: Yalin Wang <yalin.wang@sonymobile.com>
Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Hugh Dickins <hughd@google.com>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/cma.c~free-the-reserved-memblock-when-free-cma-pages mm/cma.c
--- a/mm/cma.c~free-the-reserved-memblock-when-free-cma-pages
+++ a/mm/cma.c
@@ -115,6 +115,8 @@ static int __init cma_activate_area(stru
 				goto err;
 		}
 		init_cma_reserved_pageblock(pfn_to_page(base_pfn));
+		memblock_free(__pfn_to_phys(base_pfn),
+				pageblock_nr_pages * PAGE_SIZE);
 	} while (--i);
 
 	mutex_init(&cma->lock);
_

Patches currently in -mm which might be from Yalin.Wang@sonymobile.com are

free-the-reserved-memblock-when-free-cma-pages-v2.patch
linux-next.patch

