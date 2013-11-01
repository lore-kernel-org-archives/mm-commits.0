From: akpm@linux-foundation.org
Subject: +
 mm-zswap-bugfix-memory-leak-when-invalidate-and-reclaim-occur-concurrentu200bly.patch added to -mm tree
Date: Fri, 01 Nov 2013 14:45:37 -0700
Message-ID: <52742101.WIuVwoGZbXsKuhzZ%akpm__17412.6701582738$1383342355$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54720 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149Ab3KAVpi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Nov 2013 17:45:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, sjenning@linux.vnet.ibm.com, minchan@kernel.org, bob.liu@oracle.com, weijie.yang@samsung.com

Subject: + mm-zswap-bugfix-memory-leak-when-invalidate-and-reclaim-occur-concurrentu200bly.patch added to -mm tree
To: weijie.yang@samsung.com,bob.liu@oracle.com,minchan@kernel.org,sjenning@linux.vnet.ibm.com,stable@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 01 Nov 2013 14:45:37 -0700


The patch titled
     Subject: mm/zswap: bugfix: memory leak when invalidate and reclaim occur concurrent\u200bly
has been added to the -mm tree.  Its filename is
     mm-zswap-bugfix-memory-leak-when-invalidate-and-reclaim-occur-concurrentu200bly.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-zswap-bugfix-memory-leak-when-invalidate-and-reclaim-occur-concurrentu200bly.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-zswap-bugfix-memory-leak-when-invalidate-and-reclaim-occur-concurrentu200bly.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Weijie Yang <weijie.yang@samsung.com>
Subject: mm/zswap: bugfix: memory leak when invalidate and reclaim occur concurrent\u200bly

Consider the following scenario:
thread 0: reclaim entry x (get refcount, but not call zswap_get_swap_cache_page)
thread 1: call zswap_frontswap_invalidate_page to invalidate entry x.
	finished, entry x and its zbud is not freed as its refcount != 0
	now, the swap_map[x] = 0
thread 0: now call zswap_get_swap_cache_page
	swapcache_prepare return -ENOENT because entry x is not used any more
	zswap_get_swap_cache_page return ZSWAP_SWAPCACHE_NOMEM
	zswap_writeback_entry do nothing except put refcount
Now, the memory of zswap_entry x and its zpage leak.

Modify:
 - check the refcount in fail path, free memory if it is not referenced.

 - use ZSWAP_SWAPCACHE_FAIL instead of ZSWAP_SWAPCACHE_NOMEM as the fail path
   can be not only caused by nomem but also by invalidate.

Signed-off-by: Weijie Yang <weijie.yang@samsung.com>
Reviewed-by: Bob Liu <bob.liu@oracle.com>
Reviewed-by: Minchan Kim <minchan@kernel.org>
Acked-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |   22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff -puN mm/zswap.c~mm-zswap-bugfix-memory-leak-when-invalidate-and-reclaim-occur-concurrentu200bly mm/zswap.c
--- a/mm/zswap.c~mm-zswap-bugfix-memory-leak-when-invalidate-and-reclaim-occur-concurrentu200bly
+++ a/mm/zswap.c
@@ -387,7 +387,7 @@ static void zswap_free_entry(struct zswa
 enum zswap_get_swap_ret {
 	ZSWAP_SWAPCACHE_NEW,
 	ZSWAP_SWAPCACHE_EXIST,
-	ZSWAP_SWAPCACHE_NOMEM
+	ZSWAP_SWAPCACHE_FAIL,
 };
 
 /*
@@ -401,9 +401,10 @@ enum zswap_get_swap_ret {
  * added to the swap cache, and returned in retpage.
  *
  * If success, the swap cache page is returned in retpage
- * Returns 0 if page was already in the swap cache, page is not locked
- * Returns 1 if the new page needs to be populated, page is locked
- * Returns <0 on error
+ * Returns ZSWAP_SWAPCACHE_EXIST if page was already in the swap cache
+ * Returns ZSWAP_SWAPCACHE_NEW if the new page needs to be populated,
+ *     the new page is added to swapcache and locked
+ * Returns ZSWAP_SWAPCACHE_FAIL on error
  */
 static int zswap_get_swap_cache_page(swp_entry_t entry,
 				struct page **retpage)
@@ -475,7 +476,7 @@ static int zswap_get_swap_cache_page(swp
 	if (new_page)
 		page_cache_release(new_page);
 	if (!found_page)
-		return ZSWAP_SWAPCACHE_NOMEM;
+		return ZSWAP_SWAPCACHE_FAIL;
 	*retpage = found_page;
 	return ZSWAP_SWAPCACHE_EXIST;
 }
@@ -529,11 +530,11 @@ static int zswap_writeback_entry(struct
 
 	/* try to allocate swap cache page */
 	switch (zswap_get_swap_cache_page(swpentry, &page)) {
-	case ZSWAP_SWAPCACHE_NOMEM: /* no memory */
+	case ZSWAP_SWAPCACHE_FAIL: /* no memory or invalidate happened */
 		ret = -ENOMEM;
 		goto fail;
 
-	case ZSWAP_SWAPCACHE_EXIST: /* page is unlocked */
+	case ZSWAP_SWAPCACHE_EXIST:
 		/* page is already in the swap cache, ignore for now */
 		page_cache_release(page);
 		ret = -EEXIST;
@@ -594,7 +595,12 @@ static int zswap_writeback_entry(struct
 
 fail:
 	spin_lock(&tree->lock);
-	zswap_entry_put(entry);
+	refcount = zswap_entry_put(entry);
+	if (refcount <= 0) {
+		/* invalidate happened, consider writeback as success */
+		zswap_free_entry(tree, entry);
+		ret = 0;
+	}
 	spin_unlock(&tree->lock);
 	return ret;
 }
_

Patches currently in -mm which might be from weijie.yang@samsung.com are

mm-zswap-avoid-unnecessary-page-scanning.patch
mm-zswap-bugfix-memory-leak-when-invalidate-and-reclaim-occur-concurrentu200bly.patch
linux-next.patch

