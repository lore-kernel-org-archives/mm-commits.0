From: akpm@linux-foundation.org
Subject: [merged] mm-dont-call-__page_cache_release-for-hugetlb.patch
 removed from -mm tree
Date: Thu, 16 Apr 2015 09:52:34 -0700
Message-ID: <552fe8d2.EhnbAQOq6IQ0iyei%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42799 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753223AbbDPQrF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Apr 2015 12:47:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, hannes@cmpxchg.org, hughd@google.com, mgorman@suse.de, mhocko@suse.cz, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: don't call __page_cache_release for hugetlb
has been removed from the -mm tree.  Its filename was
     mm-dont-call-__page_cache_release-for-hugetlb.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: mm: don't call __page_cache_release for hugetlb

__put_compound_page() calls __page_cache_release() to do some freeing
work, but it's obviously for thps, not for hugetlb.  We don't care because
PageLRU is always cleared and page->mem_cgroup is always NULL for hugetlb.
But it's not correct and has potential risks, so let's make it
conditional.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Hugh Dickins <hughd@google.com>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff -puN mm/swap.c~mm-dont-call-__page_cache_release-for-hugetlb mm/swap.c
--- a/mm/swap.c~mm-dont-call-__page_cache_release-for-hugetlb
+++ a/mm/swap.c
@@ -31,6 +31,7 @@
 #include <linux/memcontrol.h>
 #include <linux/gfp.h>
 #include <linux/uio.h>
+#include <linux/hugetlb.h>
 
 #include "internal.h"
 
@@ -75,7 +76,14 @@ static void __put_compound_page(struct p
 {
 	compound_page_dtor *dtor;
 
-	__page_cache_release(page);
+	/*
+	 * __page_cache_release() is supposed to be called for thp, not for
+	 * hugetlb. This is because hugetlb page does never have PageLRU set
+	 * (it's never listed to any LRU lists) and no memcg routines should
+	 * be called for hugetlb (it has a separate hugetlb_cgroup.)
+	 */
+	if (!PageHuge(page))
+		__page_cache_release(page);
 	dtor = get_compound_page_dtor(page);
 	(*dtor)(page);
 }
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

origin.patch
page-flags-trivial-cleanup-for-pagetrans-helpers.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages.patch
page-flags-define-pg_locked-behavior-on-compound-pages.patch
page-flags-define-behavior-of-fs-io-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-xen-related-flags-on-compound-pages.patch
page-flags-define-pg_reserved-behavior-on-compound-pages.patch
page-flags-define-pg_swapbacked-behavior-on-compound-pages.patch
page-flags-define-pg_swapcache-behavior-on-compound-pages.patch
page-flags-define-pg_mlocked-behavior-on-compound-pages.patch
page-flags-define-pg_uncached-behavior-on-compound-pages.patch
page-flags-define-pg_uptodate-behavior-on-compound-pages.patch
page-flags-look-on-head-page-if-the-flag-is-encoded-in-page-mapping.patch
mm-sanitize-page-mapping-for-tail-pages.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

