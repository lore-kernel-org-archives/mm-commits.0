From: akpm@linux-foundation.org
Subject: [merged] fs-buffer_head-remove-kmem_cache-constructor-to-reduce-memory-usage-under-slub.patch removed from -mm tree
Date: Sun, 14 Mar 2010 23:52:34 -0400
Message-ID: <201003150653.o2F6r7Ej015977@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48570 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756997Ab0COGxt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 02:53:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: richard@rsk.demon.co.uk, jens.axboe@oracle.com, npiggin@suse.de, riel@redhat.com, tytso@mit.edu, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     fs: buffer_head: remove kmem_cache constructor to reduce memory usage under slub
has been removed from the -mm tree.  Its filename was
     fs-buffer_head-remove-kmem_cache-constructor-to-reduce-memory-usage-under-slub.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs: buffer_head: remove kmem_cache constructor to reduce memory usage under slub
From: Richard Kennedy <richard@rsk.demon.co.uk>

When using slub, having a kmem_cache constructor forces slub to add a free
pointer to the size of the cached object, which can have a significant
impact to the number of small objects that can fit into a slab.

As buffer_head is relatively small and we can have large numbers of them,
removing the constructor is a definite win.

On x86_64 removing the constructor gives me 39 objects/slab, 3 more than
without the patch.  And on x86_32 73 objects/slab, which is 9 more.

As alloc_buffer_head() already initializes each new object there is very
little difference in actual code run.

Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Jens Axboe <jens.axboe@oracle.com>
Acked-by: Nick Piggin <npiggin@suse.de>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Reviewed-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c |   13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff -puN fs/buffer.c~fs-buffer_head-remove-kmem_cache-constructor-to-reduce-memory-usage-under-slub fs/buffer.c
--- a/fs/buffer.c~fs-buffer_head-remove-kmem_cache-constructor-to-reduce-memory-usage-under-slub
+++ a/fs/buffer.c
@@ -3265,7 +3265,7 @@ static void recalc_bh_state(void)
 	
 struct buffer_head *alloc_buffer_head(gfp_t gfp_flags)
 {
-	struct buffer_head *ret = kmem_cache_alloc(bh_cachep, gfp_flags);
+	struct buffer_head *ret = kmem_cache_zalloc(bh_cachep, gfp_flags);
 	if (ret) {
 		INIT_LIST_HEAD(&ret->b_assoc_buffers);
 		get_cpu_var(bh_accounting).nr++;
@@ -3352,15 +3352,6 @@ int bh_submit_read(struct buffer_head *b
 }
 EXPORT_SYMBOL(bh_submit_read);
 
-static void
-init_buffer_head(void *data)
-{
-	struct buffer_head *bh = data;
-
-	memset(bh, 0, sizeof(*bh));
-	INIT_LIST_HEAD(&bh->b_assoc_buffers);
-}
