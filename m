From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-show-proportional-swap-share-of-the-mapping-fix.patch removed from -mm
 tree
Date: Tue, 08 Sep 2015 14:37:56 -0700
Message-ID: <55ef5534.BecpJBtKUEbPIlyG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52610 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753030AbbIHVh5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Sep 2015 17:37:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, bongkyu.kim@lge.com, corbet@lwn.net, hughd@google.com, minchan@kernel.org, sergey.senozhatsky.work@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-show-proportional-swap-share-of-the-mapping-fix
has been removed from the -mm tree.  Its filename was
     mm-show-proportional-swap-share-of-the-mapping-fix.patch

This patch was dropped because it was folded into mm-show-proportional-swap-share-of-the-mapping.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-show-proportional-swap-share-of-the-mapping-fix

simplify kunmap_atomic() call

Cc: Bongkyu Kim <bongkyu.kim@lge.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/swapfile.c~mm-show-proportional-swap-share-of-the-mapping-fix mm/swapfile.c
--- a/mm/swapfile.c~mm-show-proportional-swap-share-of-the-mapping-fix
+++ a/mm/swapfile.c
@@ -904,8 +904,8 @@ int swp_swapcount(swp_entry_t entry)
 
 	do {
 		page = list_entry(page->lru.next, struct page, lru);
-		map = kmap_atomic(page) + offset;
-		tmp_count = *map;
+		map = kmap_atomic(page);
+		tmp_count = map[offset];
 		kunmap_atomic(map);
 
 		count += (tmp_count & ~COUNT_CONTINUED) * n;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

dax-revert-userfaultfd-change.patch
mm-show-proportional-swap-share-of-the-mapping.patch
mm-improve-__gfp_noretry-comment-based-on-implementation-fix.patch
memcg-export-struct-mem_cgroup-fix.patch
memcg-export-struct-mem_cgroup-fix-2.patch
mm-hugetlb-add-cache-of-descriptors-to-resv_map-for-region_add-fix.patch
x86-use-generic-early-mem-copy-fix.patch
mm-mmap-simplify-the-failure-return-working-flow-fix.patch
zswap-dynamic-pool-creation-fix.patch

