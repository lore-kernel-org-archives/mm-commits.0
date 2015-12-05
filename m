From: akpm@linux-foundation.org
Subject: + mm-slabc-add-a-helper-function-get_first_slab.patch added to
 -mm tree
Date: Fri, 04 Dec 2015 16:45:26 -0800
Message-ID: <566233a6.8v3XA2YeLVl8btuA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48887 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752181AbbLEAp1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Dec 2015 19:45:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geliangtang@163.com, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slab.c: add a helper function get_first_slab
has been added to the -mm tree.  Its filename is
     mm-slabc-add-a-helper-function-get_first_slab.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-slabc-add-a-helper-function-get_first_slab.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-slabc-add-a-helper-function-get_first_slab.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Geliang Tang <geliangtang@163.com>
Subject: mm/slab.c: add a helper function get_first_slab

Add a new helper function get_first_slab() that get the first slab from a
kmem_cache_node.

Signed-off-by: Geliang Tang <geliangtang@163.com>
Acked-by: Christoph Lameter <cl@linux.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |   39 +++++++++++++++++++++------------------
 1 file changed, 21 insertions(+), 18 deletions(-)

diff -puN mm/slab.c~mm-slabc-add-a-helper-function-get_first_slab mm/slab.c
--- a/mm/slab.c~mm-slabc-add-a-helper-function-get_first_slab
+++ a/mm/slab.c
@@ -2756,6 +2756,21 @@ static void *cache_free_debugcheck(struc
 #define cache_free_debugcheck(x,objp,z) (objp)
 #endif
 
+static struct page *get_first_slab(struct kmem_cache_node *n)
+{
+	struct page *page;
+
+	page = list_first_entry_or_null(&n->slabs_partial,
+			struct page, lru);
+	if (!page) {
+		n->free_touched = 1;
+		page = list_first_entry_or_null(&n->slabs_free,
+				struct page, lru);
+	}
+
+	return page;
+}
+
 static void *cache_alloc_refill(struct kmem_cache *cachep, gfp_t flags,
 							bool force_refill)
 {
@@ -2793,15 +2808,9 @@ retry:
 	while (batchcount > 0) {
 		struct page *page;
 		/* Get slab alloc is to come from. */
-		page = list_first_entry_or_null(&n->slabs_partial,
-				struct page, lru);
-		if (!page) {
-			n->free_touched = 1;
-			page = list_first_entry_or_null(&n->slabs_free,
-					struct page, lru);
-			if (!page)
-				goto must_grow;
-		}
+		page = get_first_slab(n);
+		if (!page)
+			goto must_grow;
 
 		check_spinlock_acquired(cachep);
 
@@ -3097,15 +3106,9 @@ static void *____cache_alloc_node(struct
 retry:
 	check_irq_off();
 	spin_lock(&n->list_lock);
-	page = list_first_entry_or_null(&n->slabs_partial,
-			struct page, lru);
-	if (!page) {
-		n->free_touched = 1;
-		page = list_first_entry_or_null(&n->slabs_free,
-				struct page, lru);
-		if (!page)
-			goto must_grow;
-	}
+	page = get_first_slab(n);
+	if (!page)
+		goto must_grow;
 
 	check_spinlock_acquired_node(cachep, nodeid);
 
_

Patches currently in -mm which might be from geliangtang@163.com are

fsnotify-use-list_next_entry-in-fsnotify_unmount_inodes.patch
mm-slab-use-list_first_entry_or_null.patch
mm-slab-use-list_for_each_entry-in-cache_flusharray.patch
mm-slabc-add-a-helper-function-get_first_slab.patch
mm-vmalloc-use-list_nextfirst_entry.patch
mm-thp-use-list_first_entry_or_null.patch
mm-page_allocc-use-list_firstlast_entry-instead-of-list_entry.patch
mm-page_allocc-use-list_for_each_entry-in-mark_free_pages.patch
mm-swapfilec-use-list_nextfirst_entry.patch
dma-mapping-use-offset_in_page-macro.patch

