From: akpm@linux-foundation.org
Subject: [merged]
 idr-dont-need-to-shink-the-free-list-when-idr_remove.patch removed from -mm tree
Date: Mon, 09 Jun 2014 12:35:17 -0700
Message-ID: <53960c75.R8OPB7j0qKAW47Up%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54138 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753704AbaFITfS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2014 15:35:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, laijs@cn.fujitsu.com

Subject: [merged] idr-dont-need-to-shink-the-free-list-when-idr_remove.patch removed from -mm tree
To: laijs@cn.fujitsu.com,tj@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Jun 2014 12:35:17 -0700


The patch titled
     Subject: idr: don't need to shink the free list when idr_remove()
has been removed from the -mm tree.  Its filename was
     idr-dont-need-to-shink-the-free-list-when-idr_remove.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: idr: don't need to shink the free list when idr_remove()

After idr subsystem is changed to RCU-awared, the free layer will not go
to the free list.  The free list will not be filled up when idr_remove(). 
So we don't need to shink it too.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/idr.c |   16 ----------------
 1 file changed, 16 deletions(-)

diff -puN lib/idr.c~idr-dont-need-to-shink-the-free-list-when-idr_remove lib/idr.c
--- a/lib/idr.c~idr-dont-need-to-shink-the-free-list-when-idr_remove
+++ a/lib/idr.c
@@ -18,12 +18,6 @@
  * pointer or what ever, we treat it as a (void *).  You can pass this
  * id to a user for him to pass back at a later time.  You then pass
  * that id to this code and it returns your pointer.
-
- * You can release ids at any time. When all ids are released, most of
- * the memory is returned (we keep MAX_IDR_FREE) in a local pool so we
- * don't need to go to the memory "store" during an id allocate, just
- * so you don't need to be too concerned about locking and conflicts
- * with the slab allocator.
  */
 
 #ifndef TEST                        // to test in user space...
@@ -584,16 +578,6 @@ void idr_remove(struct idr *idp, int id)
 		bitmap_clear(to_free->bitmap, 0, IDR_SIZE);
 		free_layer(idp, to_free);
 	}
-	while (idp->id_free_cnt >= MAX_IDR_FREE) {
-		p = get_from_free_list(idp);
-		/*
-		 * Note: we don't call the rcu callback here, since the only
-		 * layers that fall into the freelist are those that have been
-		 * preallocated.
-		 */
-		kmem_cache_free(idr_layer_cache, p);
-	}
-	return;
 }
 EXPORT_SYMBOL(idr_remove);
 
_

Patches currently in -mm which might be from laijs@cn.fujitsu.com are

origin.patch
linux-next.patch

