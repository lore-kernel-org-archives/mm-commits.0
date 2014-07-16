From: akpm@linux-foundation.org
Subject: + mm-remove-the-unused-gfp-arg-to-shmem_add_to_page_cache.patch
 added to -mm tree
Date: Wed, 16 Jul 2014 14:01:00 -0700
Message-ID: <53c6e80c.jTGVQFNViVGRU/5o%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oi0-f74.google.com ([209.85.218.74]:32816 "EHLO
	mail-oi0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752454AbaGPVBB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Jul 2014 17:01:01 -0400
Received: by mail-oi0-f74.google.com with SMTP id a141so45286oig.1
        for <mm-commits@vger.kernel.org>; Wed, 16 Jul 2014 14:01:00 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shhuiw@gmail.com, hughd@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/shmem.c: remove the unused gfp arg to shmem_add_to_page_cache()
has been added to the -mm tree.  Its filename is
     mm-remove-the-unused-gfp-arg-to-shmem_add_to_page_cache.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-remove-the-unused-gfp-arg-to-shmem_add_to_page_cache.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-remove-the-unused-gfp-arg-to-shmem_add_to_page_cache.patch

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
 
@@ -662,7 +662,7 @@ static int shmem_unuse_inode(struct shme
 	 */
 	if (!error)
 		error = shmem_add_to_page_cache(*pagep, mapping, index,
-						GFP_NOWAIT, radswap);
+						radswap);
 	if (error != -ENOMEM) {
 		/*
 		 * Truncation and eviction use free_swap_and_cache(), which
@@ -1113,7 +1113,7 @@ repeat:
 		error = mem_cgroup_try_charge(page, current->mm, gfp, &memcg);
 		if (!error) {
 			error = shmem_add_to_page_cache(page, mapping, index,
-						gfp, swp_to_radix_entry(swap));
+						swp_to_radix_entry(swap));
 			/*
 			 * We already confirmed swap under page lock, and make
 			 * no memory allocation here, so usually no possibility
@@ -1179,7 +1179,7 @@ repeat:
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

mm-update-the-description-for-madvise_remove.patch
mm-update-the-description-for-vm_total_pages.patch
mm-remove-the-unused-gfp-arg-to-shmem_add_to_page_cache.patch

