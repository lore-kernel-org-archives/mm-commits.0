From: akpm@linux-foundation.org
Subject: [merged] fs-jfs-remove-slab-object-constructor.patch removed from -mm tree
Date: Thu, 16 Apr 2015 09:52:12 -0700
Message-ID: <552fe8bc.1/8cB/GOUkeXO/f1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42734 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752855AbbDPQqo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Apr 2015 12:46:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, catalin.marinas@arm.com, dave.kleikamp@oracle.com, hch@lst.de, mpatocka@redhat.com, sebott@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs, jfs: remove slab object constructor
has been removed from the -mm tree.  Its filename was
     fs-jfs-remove-slab-object-constructor.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: fs, jfs: remove slab object constructor

Mempools based on slab caches with object constructors are risky because
element allocation can happen either from the slab cache itself, meaning
the constructor is properly called before returning, or from the mempool
reserve pool, meaning the constructor is not called before returning,
depending on the allocation context.

For this reason, we should disallow creating mempools based on slab caches
that have object constructors.  Callers of mempool_alloc() will be
responsible for properly initializing the returned element.

Then, it doesn't matter if the element came from the slab cache or the
mempool reserved pool.

The only occurrence of a mempool being based on a slab cache with an
object constructor in the tree is in fs/jfs/jfs_metapage.c.  Remove it and
properly initialize the element in alloc_metapage().

At the same time, META_free is never used, so remove it as well.

Signed-off-by: David Rientjes <rientjes@google.com>
Acked-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Sebastian Ott <sebott@linux.vnet.ibm.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jfs/jfs_metapage.c |   31 ++++++++++++-------------------
 fs/jfs/jfs_metapage.h |    1 -
 2 files changed, 12 insertions(+), 20 deletions(-)

diff -puN fs/jfs/jfs_metapage.c~fs-jfs-remove-slab-object-constructor fs/jfs/jfs_metapage.c
--- a/fs/jfs/jfs_metapage.c~fs-jfs-remove-slab-object-constructor
+++ a/fs/jfs/jfs_metapage.c
@@ -183,30 +183,23 @@ static inline void remove_metapage(struc
 
 #endif
 
-static void init_once(void *foo)
-{
-	struct metapage *mp = (struct metapage *)foo;
-
-	mp->lid = 0;
-	mp->lsn = 0;
-	mp->flag = 0;
-	mp->data = NULL;
-	mp->clsn = 0;
-	mp->log = NULL;
-	set_bit(META_free, &mp->flag);
-	init_waitqueue_head(&mp->wait);
-}
-
 static inline struct metapage *alloc_metapage(gfp_t gfp_mask)
 {
-	return mempool_alloc(metapage_mempool, gfp_mask);
+	struct metapage *mp = mempool_alloc(metapage_mempool, gfp_mask);
+
+	if (mp) {
+		mp->lid = 0;
+		mp->lsn = 0;
+		mp->data = NULL;
+		mp->clsn = 0;
+		mp->log = NULL;
+		init_waitqueue_head(&mp->wait);
+	}
+	return mp;
 }
 
 static inline void free_metapage(struct metapage *mp)
 {
-	mp->flag = 0;
-	set_bit(META_free, &mp->flag);
-
 	mempool_free(mp, metapage_mempool);
 }
 
@@ -216,7 +209,7 @@ int __init metapage_init(void)
 	 * Allocate the metapage structures
 	 */
 	metapage_cache = kmem_cache_create("jfs_mp", sizeof(struct metapage),
-					   0, 0, init_once);
+					   0, 0, NULL);
 	if (metapage_cache == NULL)
 		return -ENOMEM;
 
diff -puN fs/jfs/jfs_metapage.h~fs-jfs-remove-slab-object-constructor fs/jfs/jfs_metapage.h
--- a/fs/jfs/jfs_metapage.h~fs-jfs-remove-slab-object-constructor
+++ a/fs/jfs/jfs_metapage.h
@@ -48,7 +48,6 @@ struct metapage {
 
 /* metapage flag */
 #define META_locked	0
-#define META_free	1
 #define META_dirty	2
 #define META_sync	3
 #define META_discard	4
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
jbd2-revert-must-not-fail-allocation-loops-back-to-gfp_nofail.patch
slab-infrastructure-for-bulk-object-allocation-and-freeing-v3.patch
slub-bulk-alloc-extract-objects-from-the-per-cpu-slab.patch
slub-bulk-allocation-from-per-cpu-partial-pages.patch
slub-bulk-allocation-from-per-cpu-partial-pages-fix.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch
mm-utilc-add-kstrimdup.patch
linux-next.patch
cxgb4-drop-__gfp_nofail-allocation.patch

