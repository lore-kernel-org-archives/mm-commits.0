From: akpm@linux-foundation.org
Subject: [failures] free-the-reserved-memblock-when-free-cma-pages.patch
 removed from -mm tree
Date: Tue, 23 Sep 2014 16:24:17 -0700
Message-ID: <54220121.iisI3fYu2ISKiMdK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39180 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932171AbaIWXYS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 23 Sep 2014 19:24:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Yalin.Wang@sonymobile.com, b.zolnierkie@samsung.com, hughd@google.com, iamjoonsoo.kim@lge.com, m.szyprowski@samsung.com, mhocko@suse.cz, minchan@kernel.org, sasha.levin@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/cma.c: free the reserved memblock when free cma pages
has been removed from the -mm tree.  Its filename was
     free-the-reserved-memblock-when-free-cma-pages.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
Subject: mm/cma.c: free the reserved memblock when free cma pages

Add memblock_free to also free the reserved memblock, so that the cma
pages are not marked as reserved memory in
/sys/kernel/debug/memblock/reserved debug file

Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Hugh Dickins <hughd@google.com>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma.c        |    6 +++++-
 mm/page_alloc.c |    2 +-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff -puN mm/cma.c~free-the-reserved-memblock-when-free-cma-pages mm/cma.c
--- a/mm/cma.c~free-the-reserved-memblock-when-free-cma-pages
+++ a/mm/cma.c
@@ -217,7 +217,11 @@ int __init cma_declare_contiguous(phys_a
 		goto err;
 	}
 
-	/* Reserve memory */
+	/*
+	 * Reserve memory, and the reserved memory are marked as reserved by
+	 * memblock driver, remember to clear the reserved status when free
+	 * these cma pages, see init_cma_reserved_pageblock()
+	 */
 	if (base && fixed) {
 		if (memblock_is_region_reserved(base, size) ||
 		    memblock_reserve(base, size) < 0) {
diff -puN mm/page_alloc.c~free-the-reserved-memblock-when-free-cma-pages mm/page_alloc.c
--- a/mm/page_alloc.c~free-the-reserved-memblock-when-free-cma-pages
+++ a/mm/page_alloc.c
@@ -835,8 +835,8 @@ void __init init_cma_reserved_pageblock(
 		set_page_refcounted(page);
 		__free_pages(page, pageblock_order);
 	}
