From: akpm@linux-foundation.org
Subject: + mm-trivial-comment-cleanup-in-slabc.patch added to -mm tree
Date: Tue, 22 Jul 2014 13:30:38 -0700
Message-ID: <53cec9ee.WQ2t83YWd9jkgQSa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oi0-f73.google.com ([209.85.218.73]:45100 "EHLO
	mail-oi0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756693AbaGVUaj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 22 Jul 2014 16:30:39 -0400
Received: by mail-oi0-f73.google.com with SMTP id u20so45269oif.4
        for <mm-commits@vger.kernel.org>; Tue, 22 Jul 2014 13:30:38 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shhuiw@gmail.com, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slab.c: fix comments
has been added to the -mm tree.  Its filename is
     mm-trivial-comment-cleanup-in-slabc.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-trivial-comment-cleanup-in-slabc.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-trivial-comment-cleanup-in-slabc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wang Sheng-Hui <shhuiw@gmail.com>
Subject: mm/slab.c: fix comments

Current struct kmem_cache has no 'lock' field, and slab page is managed by
struct kmem_cache_node, which has 'list_lock' field.

Clean up the related comment.

Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff -puN mm/slab.c~mm-trivial-comment-cleanup-in-slabc mm/slab.c
--- a/mm/slab.c~mm-trivial-comment-cleanup-in-slabc
+++ a/mm/slab.c
@@ -1611,7 +1611,8 @@ slab_out_of_memory(struct kmem_cache *ca
 }
 
 /*
- * Interface to system's page allocator. No need to hold the cache-lock.
+ * Interface to system's page allocator. No need to hold the
+ * kmem_cache_node ->list_lock.
  *
  * If we requested dmaable memory, we will get it. Even if we
  * did not request dmaable memory, we might get it, but that
@@ -1913,9 +1914,9 @@ static void slab_destroy_debugcheck(stru
  * @cachep: cache pointer being destroyed
  * @page: page pointer being destroyed
  *
- * Destroy all the objs in a slab, and release the mem back to the system.
- * Before calling the slab must have been unlinked from the cache.  The
- * cache-lock is not held/needed.
+ * Destroy all the objs in a slab page, and release the mem back to the system.
+ * Before calling the slab page must have been unlinked from the cache. The
+ * kmem_cache_node ->list_lock is not held/needed.
  */
 static void slab_destroy(struct kmem_cache *cachep, struct page *page)
 {
_

Patches currently in -mm which might be from shhuiw@gmail.com are

mm-trivial-comment-cleanup-in-slabc.patch
mm-update-the-description-for-madvise_remove.patch
mm-update-the-description-for-vm_total_pages.patch
mm-remove-the-unused-gfp-arg-to-shmem_add_to_page_cache.patch

