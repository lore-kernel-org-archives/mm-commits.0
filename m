From: akpm@linux-foundation.org
Subject: + idr-dont-need-to-shink-the-free-list-when-idr_remove.patch
 added to -mm tree
Date: Tue, 22 Apr 2014 12:40:47 -0700
Message-ID: <5356c5bf.Li3m9N2pvdh9Pm7c%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48671 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755684AbaDVTks (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 22 Apr 2014 15:40:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, laijs@cn.fujitsu.com

Subject: + idr-dont-need-to-shink-the-free-list-when-idr_remove.patch added to -mm tree
To: laijs@cn.fujitsu.com,tj@kernel.org
From: akpm@linux-foundation.org
Date: Tue, 22 Apr 2014 12:40:47 -0700


The patch titled
     Subject: idr: don't need to shink the free list when idr_remove()
has been added to the -mm tree.  Its filename is
     idr-dont-need-to-shink-the-free-list-when-idr_remove.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/idr-dont-need-to-shink-the-free-list-when-idr_remove.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/idr-dont-need-to-shink-the-free-list-when-idr_remove.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mem-hotplug-implement-get-put_online_mems.patch
slab-get_online_mems-for-kmem_cache_createdestroyshrink.patch
idr-fix-overflow-bug-during-maximum-id-calculation-at-maximum-height.patch
idr-fix-unexpected-id-removal-when-idr_removeunallocated_id.patch
idr-fix-null-pointer-dereference-when-ida_removeunallocated_id.patch
idr-fix-idr_replaces-returned-error-code.patch
idr-dont-need-to-shink-the-free-list-when-idr_remove.patch
idr-reduce-the-unneeded-check-in-free_layer.patch
linux-next.patch

