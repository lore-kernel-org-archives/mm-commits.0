From: akpm@linux-foundation.org
Subject: [merged] vfs-__read_cache_page-should-use-gfp-argument-rather-than-gfp_kernel.patch removed from -mm tree
Date: Thu, 22 Dec 2011 11:49:43 -0800
Message-ID: <20111222203131.CA74420004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:43606 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135Ab1LVUbe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 Dec 2011 15:31:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave.kleikamp@oracle.com, hughd@google.com, stable@vger.kernel.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: vfs: __read_cache_page() should use gfp argument rather than GFP_KERNEL
has been removed from the -mm tree.  Its filename was
     vfs-__read_cache_page-should-use-gfp-argument-rather-than-gfp_kernel.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Dave Kleikamp <dave.kleikamp@oracle.com>
Subject: vfs: __read_cache_page() should use gfp argument rather than GFP_KERNEL

lockdep reports a deadlock in jfs because a special inode's rw semaphore
is taken recursively.  The mapping's gfp mask is GFP_NOFS, but is not used
when __read_cache_page() calls add_to_page_cache_lru().

Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Acked-by: Hugh Dickins <hughd@google.com>
Acked-by: Al Viro <viro@zeniv.linux.org.uk>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff -puN mm/filemap.c~vfs-__read_cache_page-should-use-gfp-argument-rather-than-gfp_kernel mm/filemap.c
--- a/mm/filemap.c~vfs-__read_cache_page-should-use-gfp-argument-rather-than-gfp_kernel
+++ a/mm/filemap.c
@@ -1814,7 +1814,7 @@ repeat:
 		page = __page_cache_alloc(gfp | __GFP_COLD);
 		if (!page)
 			return ERR_PTR(-ENOMEM);
-		err = add_to_page_cache_lru(page, mapping, index, GFP_KERNEL);
+		err = add_to_page_cache_lru(page, mapping, index, gfp);
 		if (unlikely(err)) {
 			page_cache_release(page);
 			if (err == -EEXIST)
@@ -1911,10 +1911,7 @@ static struct page *wait_on_page_read(st
  * @gfp:	the page allocator flags to use if allocating
  *
  * This is the same as "read_mapping_page(mapping, index, NULL)", but with
- * any new page allocations done using the specified allocation flags. Note
- * that the Radix tree operations will still use GFP_KERNEL, so you can't
- * expect to do this atomically or anything like that - but you can pass in
- * other page requirements.
+ * any new page allocations done using the specified allocation flags.
  *
  * If the page does not get brought uptodate, return -EIO.
  */
_

Patches currently in -mm which might be from dave.kleikamp@oracle.com are

origin.patch

