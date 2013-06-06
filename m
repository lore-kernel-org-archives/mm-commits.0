From: akpm@linux-foundation.org
Subject: [to-be-updated]
 hugepage-convert-huge-zero-page-shrinker-to-new-shrinker-api.patch removed
 from -mm tree
Date: Thu, 06 Jun 2013 12:35:05 -0700
Message-ID: <51b0e469.d30EaFaauw+nHFAV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51977 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753423Ab3FFTfG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Jun 2013 15:35:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, dchinner@redhat.com, glommer@openvz.org

Subject: [to-be-updated] hugepage-convert-huge-zero-page-shrinker-to-new-shrinker-api.patch removed from -mm tree
To: glommer@openvz.org,dchinner@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 06 Jun 2013 12:35:05 -0700


The patch titled
     Subject: hugepage: convert huge zero page shrinker to new shrinker API
has been removed from the -mm tree.  Its filename was
     hugepage-convert-huge-zero-page-shrinker-to-new-shrinker-api.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Glauber Costa <glommer@openvz.org>
Subject: hugepage: convert huge zero page shrinker to new shrinker API

It consists of:

* returning long instead of int
* separating count from scan
* returning the number of freed entities in scan

Cc: Glauber Costa <glommer@openvz.org>
Cc: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff -puN mm/huge_memory.c~hugepage-convert-huge-zero-page-shrinker-to-new-shrinker-api mm/huge_memory.c
--- a/mm/huge_memory.c~hugepage-convert-huge-zero-page-shrinker-to-new-shrinker-api
+++ a/mm/huge_memory.c
@@ -211,24 +211,29 @@ static void put_huge_zero_page(void)
 	BUG_ON(atomic_dec_and_test(&huge_zero_refcount));
 }
 
-static int shrink_huge_zero_page(struct shrinker *shrink,
-		struct shrink_control *sc)
+static long shrink_huge_zero_page_count(struct shrinker *shrink,
+					struct shrink_control *sc)
 {
-	if (!sc->nr_to_scan)
-		/* we can free zero page only if last reference remains */
-		return atomic_read(&huge_zero_refcount) == 1 ? HPAGE_PMD_NR : 0;
+	/* we can free zero page only if last reference remains */
+	return atomic_read(&huge_zero_refcount) == 1 ? HPAGE_PMD_NR : 0;
+}
 
+static long shrink_huge_zero_page_scan(struct shrinker *shrink,
+				       struct shrink_control *sc)
+{
 	if (atomic_cmpxchg(&huge_zero_refcount, 1, 0) == 1) {
 		struct page *zero_page = xchg(&huge_zero_page, NULL);
 		BUG_ON(zero_page == NULL);
 		__free_page(zero_page);
+		return HPAGE_PMD_NR;
 	}
 
 	return 0;
 }
 
 static struct shrinker huge_zero_page_shrinker = {
-	.shrink = shrink_huge_zero_page,
+	.count_objects = shrink_huge_zero_page_count,
+	.scan_objects = shrink_huge_zero_page_scan,
 	.seeks = DEFAULT_SEEKS,
 };
 
_

Patches currently in -mm which might be from glommer@openvz.org are

shrinker-kill-old-shrink-api.patch
vmscan-also-shrink-slab-in-memcg-pressure.patch
memcglist_lru-duplicate-lrus-upon-kmemcg-creation.patch
lru-add-an-element-to-a-memcg-list.patch
list_lru-per-memcg-walks.patch
memcg-per-memcg-kmem-shrinking.patch
memcg-scan-cache-objects-hierarchically.patch
vmscan-take-at-least-one-pass-with-shrinkers.patch
super-targeted-memcg-reclaim.patch
memcg-move-initialization-to-memcg-creation.patch
vmpressure-in-kernel-notifications.patch
memcg-reap-dead-memcgs-upon-global-memory-pressure.patch

