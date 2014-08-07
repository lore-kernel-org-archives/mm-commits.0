From: akpm@linux-foundation.org
Subject: [merged]
 slab-move-up-code-to-get-kmem_cache_node-in-free_block.patch removed from
 -mm tree
Date: Thu, 07 Aug 2014 13:03:05 -0700
Message-ID: <53e3db79.OJc2VqwZzet8aZnM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:32782 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751265AbaHGUDG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:03:06 -0400
Received: by mail-vc0-f202.google.com with SMTP id hq11so605371vcb.5
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:03:05 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, cl@linux.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slab: move up code to get kmem_cache_node in free_block()
has been removed from the -mm tree.  Its filename was
     slab-move-up-code-to-get-kmem_cache_node-in-free_block.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: slab: move up code to get kmem_cache_node in free_block()

node isn't changed, so we don't need to retreive this structure everytime
we move the object.  Maybe compiler do this optimization, but making it
explicitly is better.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN mm/slab.c~slab-move-up-code-to-get-kmem_cache_node-in-free_block mm/slab.c
--- a/mm/slab.c~slab-move-up-code-to-get-kmem_cache_node-in-free_block
+++ a/mm/slab.c
@@ -3398,7 +3398,7 @@ static void free_block(struct kmem_cache
 		       int node)
 {
 	int i;
-	struct kmem_cache_node *n;
+	struct kmem_cache_node *n = get_node(cachep, node);
 
 	for (i = 0; i < nr_objects; i++) {
 		void *objp;
@@ -3408,7 +3408,6 @@ static void free_block(struct kmem_cache
 		objp = objpp[i];
 
 		page = virt_to_head_page(objp);
-		n = get_node(cachep, node);
 		list_del(&page->lru);
 		check_spinlock_acquired_node(cachep, node);
 		slab_put_obj(cachep, page, objp, node);
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

origin.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
page-owners-correct-page-order-when-to-free-page.patch

