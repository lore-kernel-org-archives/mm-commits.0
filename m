From: akpm@linux-foundation.org
Subject: [merged] nommu-ramfs-dont-leak-pages-when-adding-to-page-cache-fails.patch removed from -mm tree
Date: Wed, 18 Mar 2009 15:47:43 -0700
Message-ID: <200903182247.n2IMlhaF020182@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54946 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751955AbZCRWwT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Mar 2009 18:52:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, Enrik.Berkhan@ge.com, a.p.zijlstra@chello.nl, dhowells@redhat.com, nickpiggin@yahoo.com.au, mm-commits@vger.kernel.org


The patch titled
     nommu: ramfs: don't leak pages when adding to page cache fails
has been removed from the -mm tree.  Its filename was
     nommu-ramfs-dont-leak-pages-when-adding-to-page-cache-fails.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: nommu: ramfs: don't leak pages when adding to page cache fails
From: Johannes Weiner <hannes@cmpxchg.org>

When a ramfs nommu mapping is expanded, contiguous pages are allocated
and added to the pagecache.  The caller's reference is then passed on
by moving whole pagevecs to the file lru list.

If the page cache adding fails, make sure that the error path also
moves the pagevec contents which might still contain up to PAGEVEC_SIZE
successfully added pages, of which we would leak references otherwise.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Enrik Berkhan <Enrik.Berkhan@ge.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ramfs/file-nommu.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/ramfs/file-nommu.c~nommu-ramfs-dont-leak-pages-when-adding-to-page-cache-fails fs/ramfs/file-nommu.c
--- a/fs/ramfs/file-nommu.c~nommu-ramfs-dont-leak-pages-when-adding-to-page-cache-fails
+++ a/fs/ramfs/file-nommu.c
@@ -129,6 +129,7 @@ int ramfs_nommu_expand_for_mapping(struc
 	return -EFBIG;
 
  add_error:
+	pagevec_lru_add_file(&lru_pvec);
 	page_cache_release(pages + loop);
 	for (loop++; loop < npages; loop++)
 		__free_page(pages + loop);
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
linux-next.patch
cifs-use-kzfree.patch
s390-use-kzfree.patch
crypto-use-kzfree.patch
vmscan-rename-scmay_swap-to-may_unmap.patch
mm-introduce-for_each_populated_zone-macro.patch
mm-introduce-for_each_populated_zone-macro-cleanup.patch
mm-shrink_all_memory-use-scnr_reclaimed.patch
mm-shrink_all_memory-use-scnr_reclaimed-checkpatch-fixes.patch
vmscan-clip-swap_cluster_max-in-shrink_all_memory.patch
vmscan-respect-higher-order-in-zone_reclaim.patch
mm-move-pagevec-stripping-to-save-unlock-relock.patch
mm-dont-free-swap-slots-on-page-deactivation.patch
mm-remove-pagevec_swap_free.patch
nommu-there-is-no-mlock-for-nommu-so-dont-provide-the-bits.patch
nommu-make-config_unevictable_lru-available-when-config_mmu=n.patch
ecryptfs-use-kzfree.patch
memcg-remove-mem_cgroup_calc_mapped_ratio-take2.patch

