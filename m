From: akpm@linux-foundation.org
Subject: + mm-slab-use-list_first_entry_or_null.patch added to -mm tree
Date: Wed, 02 Dec 2015 14:58:38 -0800
Message-ID: <565f779e.3pprzXE6mQupJUHS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38050 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756438AbbLBW6j (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Dec 2015 17:58:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geliangtang@163.com, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slab.c use list_first_entry_or_null()
has been added to the -mm tree.  Its filename is
     mm-slab-use-list_first_entry_or_null.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-slab-use-list_first_entry_or_null.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-slab-use-list_first_entry_or_null.patch

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
Subject: mm/slab.c use list_first_entry_or_null()

Simplify the code with list_first_entry_or_null().

Signed-off-by: Geliang Tang <geliangtang@163.com>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff -puN mm/slab.c~mm-slab-use-list_first_entry_or_null mm/slab.c
--- a/mm/slab.c~mm-slab-use-list_first_entry_or_null
+++ a/mm/slab.c
@@ -2791,18 +2791,18 @@ retry:
 	}
 
 	while (batchcount > 0) {
-		struct list_head *entry;
 		struct page *page;
 		/* Get slab alloc is to come from. */
-		entry = n->slabs_partial.next;
-		if (entry == &n->slabs_partial) {
+		page = list_first_entry_or_null(&n->slabs_partial,
+				struct page, lru);
+		if (!page) {
 			n->free_touched = 1;
-			entry = n->slabs_free.next;
-			if (entry == &n->slabs_free)
+			page = list_first_entry_or_null(&n->slabs_free,
+					struct page, lru);
+			if (!page)
 				goto must_grow;
 		}
 
-		page = list_entry(entry, struct page, lru);
 		check_spinlock_acquired(cachep);
 
 		/*
@@ -3085,7 +3085,6 @@ retry:
 static void *____cache_alloc_node(struct kmem_cache *cachep, gfp_t flags,
 				int nodeid)
 {
-	struct list_head *entry;
 	struct page *page;
 	struct kmem_cache_node *n;
 	void *obj;
@@ -3098,15 +3097,16 @@ static void *____cache_alloc_node(struct
 retry:
 	check_irq_off();
 	spin_lock(&n->list_lock);
-	entry = n->slabs_partial.next;
-	if (entry == &n->slabs_partial) {
+	page = list_first_entry_or_null(&n->slabs_partial,
+			struct page, lru);
+	if (!page) {
 		n->free_touched = 1;
-		entry = n->slabs_free.next;
-		if (entry == &n->slabs_free)
+		page = list_first_entry_or_null(&n->slabs_free,
+				struct page, lru);
+		if (!page)
 			goto must_grow;
 	}
 
-	page = list_entry(entry, struct page, lru);
 	check_spinlock_acquired_node(cachep, nodeid);
 
 	STATS_INC_NODEALLOCS(cachep);
_

Patches currently in -mm which might be from geliangtang@163.com are

fsnotify-use-list_next_entry-in-fsnotify_unmount_inodes.patch
mm-slab-use-list_first_entry_or_null.patch
mm-slab-use-list_for_each_entry-in-cache_flusharray.patch
mm-vmalloc-use-list_nextfirst_entry.patch
mm-thp-use-list_first_entry_or_null.patch
mm-page_allocc-use-list_firstlast_entry-instead-of-list_entry.patch
mm-page_allocc-use-list_for_each_entry-in-mark_free_pages.patch
dma-mapping-use-offset_in_page-macro.patch

