From: akpm@linux-foundation.org
Subject: [merged]
 mm-remove-the-unused-gfp-arg-to-shmem_add_to_page_cache.patch removed from
 -mm tree
Date: Thu, 07 Aug 2014 13:05:55 -0700
Message-ID: <53e3dc23.eA3pxZ9ccVS4hIml%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ie0-f202.google.com ([209.85.223.202]:49080 "EHLO
	mail-ie0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755110AbaHGUF4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:05:56 -0400
Received: by mail-ie0-f202.google.com with SMTP id rl12so841071iec.3
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:05:55 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shhuiw@gmail.com, hughd@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/shmem.c: remove the unused gfp arg to shmem_add_to_page_cache()
has been removed from the -mm tree.  Its filename was
     mm-remove-the-unused-gfp-arg-to-shmem_add_to_page_cache.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wang Sheng-Hui <shhuiw@gmail.com>
Subject: mm/shmem.c: remove the unused gfp arg to shmem_add_to_page_cache()

The gfp arg is not used in shmem_add_to_page_cache.  Remove this unused
arg.

Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN mm/shmem.c~mm-remove-the-unused-gfp-arg-to-shmem_add_to_page_cache mm/shmem.c
--- a/mm/shmem.c~mm-remove-the-unused-gfp-arg-to-shmem_add_to_page_cache
+++ a/mm/shmem.c
@@ -293,7 +293,7 @@ static bool shmem_confirm_swap(struct ad
  */
 static int shmem_add_to_page_cache(struct page *page,
 				   struct address_space *mapping,
-				   pgoff_t index, gfp_t gfp, void *expected)
+				   pgoff_t index, void *expected)
 {
 	int error;
 
@@ -666,7 +666,7 @@ static int shmem_unuse_inode(struct shme
 	 */
 	if (!error)
 		error = shmem_add_to_page_cache(*pagep, mapping, index,
-						GFP_NOWAIT, radswap);
+						radswap);
 	if (error != -ENOMEM) {
 		/*
 		 * Truncation and eviction use free_swap_and_cache(), which
@@ -1112,7 +1112,7 @@ repeat:
 						gfp & GFP_RECLAIM_MASK);
 		if (!error) {
 			error = shmem_add_to_page_cache(page, mapping, index,
-						gfp, swp_to_radix_entry(swap));
+						swp_to_radix_entry(swap));
 			/*
 			 * We already confirmed swap under page lock, and make
 			 * no memory allocation here, so usually no possibility
@@ -1175,7 +1175,7 @@ repeat:
 		error = radix_tree_maybe_preload(gfp & GFP_RECLAIM_MASK);
 		if (!error) {
 			error = shmem_add_to_page_cache(page, mapping, index,
-							gfp, NULL);
+							NULL);
 			radix_tree_preload_end();
 		}
 		if (error) {
_

Patches currently in -mm which might be from shhuiw@gmail.com are

origin.patch

