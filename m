From: akpm@linux-foundation.org
Subject: [merged]
 mm-page_alloc-use-new-pageanonhead-helper-in-the-free-page-fast-path.patch
 removed from -mm tree
Date: Fri, 20 May 2016 14:06:11 -0700
Message-ID: <573f7c43.ps/3k8eAKN8sxqwj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47295 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196AbcETVGM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 17:06:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@techsingularity.net, brouer@redhat.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_alloc: use new PageAnonHead helper in the free page fast path
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-use-new-pageanonhead-helper-in-the-free-page-fast-path.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm, page_alloc: use new PageAnonHead helper in the free page fast path

The PageAnon check always checks for compound_head but this is a
relatively expensive check if the caller already knows the page is a head
page.  This patch creates a helper and uses it in the page free path which
only operates on head pages.

With this patch and "Only check PageCompound for high-order pages", the
performance difference on a page allocator microbenchmark is;

                                           4.6.0-rc2                  4.6.0-rc2
                                             vanilla           nocompound-v1r20
Min      alloc-odr0-1               425.00 (  0.00%)           417.00 (  1.88%)
Min      alloc-odr0-2               313.00 (  0.00%)           308.00 (  1.60%)
Min      alloc-odr0-4               257.00 (  0.00%)           253.00 (  1.56%)
Min      alloc-odr0-8               224.00 (  0.00%)           221.00 (  1.34%)
Min      alloc-odr0-16              208.00 (  0.00%)           205.00 (  1.44%)
Min      alloc-odr0-32              199.00 (  0.00%)           199.00 (  0.00%)
Min      alloc-odr0-64              195.00 (  0.00%)           193.00 (  1.03%)
Min      alloc-odr0-128             192.00 (  0.00%)           191.00 (  0.52%)
Min      alloc-odr0-256             204.00 (  0.00%)           200.00 (  1.96%)
Min      alloc-odr0-512             213.00 (  0.00%)           212.00 (  0.47%)
Min      alloc-odr0-1024            219.00 (  0.00%)           219.00 (  0.00%)
Min      alloc-odr0-2048            225.00 (  0.00%)           225.00 (  0.00%)
Min      alloc-odr0-4096            230.00 (  0.00%)           231.00 ( -0.43%)
Min      alloc-odr0-8192            235.00 (  0.00%)           234.00 (  0.43%)
Min      alloc-odr0-16384           235.00 (  0.00%)           234.00 (  0.43%)
Min      free-odr0-1                215.00 (  0.00%)           191.00 ( 11.16%)
Min      free-odr0-2                152.00 (  0.00%)           136.00 ( 10.53%)
Min      free-odr0-4                119.00 (  0.00%)           107.00 ( 10.08%)
Min      free-odr0-8                106.00 (  0.00%)            96.00 (  9.43%)
Min      free-odr0-16                97.00 (  0.00%)            87.00 ( 10.31%)
Min      free-odr0-32                91.00 (  0.00%)            83.00 (  8.79%)
Min      free-odr0-64                89.00 (  0.00%)            81.00 (  8.99%)
Min      free-odr0-128               88.00 (  0.00%)            80.00 (  9.09%)
Min      free-odr0-256              106.00 (  0.00%)            95.00 ( 10.38%)
Min      free-odr0-512              116.00 (  0.00%)           111.00 (  4.31%)
Min      free-odr0-1024             125.00 (  0.00%)           118.00 (  5.60%)
Min      free-odr0-2048             133.00 (  0.00%)           126.00 (  5.26%)
Min      free-odr0-4096             136.00 (  0.00%)           130.00 (  4.41%)
Min      free-odr0-8192             138.00 (  0.00%)           130.00 (  5.80%)
Min      free-odr0-16384            137.00 (  0.00%)           130.00 (  5.11%)

There is a sizable boost to the free allocator performance.  While there
is an apparent boost on the allocation side, it's likely a co-incidence or
due to the patches slightly reducing cache footprint.

Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    7 ++++++-
 mm/page_alloc.c            |    2 +-
 2 files changed, 7 insertions(+), 2 deletions(-)

diff -puN include/linux/page-flags.h~mm-page_alloc-use-new-pageanonhead-helper-in-the-free-page-fast-path include/linux/page-flags.h
--- a/include/linux/page-flags.h~mm-page_alloc-use-new-pageanonhead-helper-in-the-free-page-fast-path
+++ a/include/linux/page-flags.h
@@ -371,10 +371,15 @@ PAGEFLAG(Idle, idle, PF_ANY)
 #define PAGE_MAPPING_KSM	2
 #define PAGE_MAPPING_FLAGS	(PAGE_MAPPING_ANON | PAGE_MAPPING_KSM)
 
+static __always_inline int PageAnonHead(struct page *page)
+{
+	return ((unsigned long)page->mapping & PAGE_MAPPING_ANON) != 0;
+}
+
 static __always_inline int PageAnon(struct page *page)
 {
 	page = compound_head(page);
-	return ((unsigned long)page->mapping & PAGE_MAPPING_ANON) != 0;
+	return PageAnonHead(page);
 }
 
 #ifdef CONFIG_KSM
diff -puN mm/page_alloc.c~mm-page_alloc-use-new-pageanonhead-helper-in-the-free-page-fast-path mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-use-new-pageanonhead-helper-in-the-free-page-fast-path
+++ a/mm/page_alloc.c
@@ -1048,7 +1048,7 @@ static bool free_pages_prepare(struct pa
 			bad += free_pages_check(page + i);
 		}
 	}
-	if (PageAnon(page))
+	if (PageAnonHead(page))
 		page->mapping = NULL;
 	bad += free_pages_check(page);
 	if (bad)
_

Patches currently in -mm which might be from mgorman@techsingularity.net are


