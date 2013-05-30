From: akpm@linux-foundation.org
Subject: +
 fs-nfs-inform-the-vm-about-pages-being-committed-or-unstable.patch added to -mm tree
Date: Thu, 30 May 2013 12:55:07 -0700
Message-ID: <51a7ae9b.vvp7qVZN3L6Z4zlH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59537 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757131Ab3E3TzJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 30 May 2013 15:55:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zcalusic@bitsync.net, trond.myklebust@fys.uio.no, riel@redhat.com, mhocko@suse.cz, kamezawa.hiroyu@jp.fujitsu.com, jslaby@suse.cz, hannes@cmpxchg.org, dormando@rydia.net, Valdis.Kletnieks@vt.edu, mgorman@suse.de

Subject: + fs-nfs-inform-the-vm-about-pages-being-committed-or-unstable.patch added to -mm tree
To: mgorman@suse.de,Valdis.Kletnieks@vt.edu,dormando@rydia.net,hannes@cmpxchg.org,jslaby@suse.cz,kamezawa.hiroyu@jp.fujitsu.com,mhocko@suse.cz,riel@redhat.com,trond.myklebust@fys.uio.no,zcalusic@bitsync.net
From: akpm@linux-foundation.org
Date: Thu, 30 May 2013 12:55:07 -0700


The patch titled
     Subject: fs: nfs: inform the VM about pages being committed or unstable
has been added to the -mm tree.  Its filename is
     fs-nfs-inform-the-vm-about-pages-being-committed-or-unstable.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: fs: nfs: inform the VM about pages being committed or unstable

VM page reclaim uses dirty and writeback page states to determine if
flushers are cleaning pages too slowly and that page reclaim should stall
waiting on flushers to catch up.  Page state in NFS is a bit more complex
and a clean page can be unreclaimable due to being unstable which is
effectively "dirty" from the perspective of the VM from reclaim context. 
Similarly, if the inode is currently being committed then it's similar to
being under writeback.

This patch adds a is_dirty_writeback() handled for NFS that checks if a
pages backing inode is being committed and should be accounted as
writeback and if a page has private state indicating that it is
effectively dirty.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Rik van Riel <riel@redhat.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Cc: Zlatko Calusic <zcalusic@bitsync.net>
Cc: dormando <dormando@rydia.net>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfs/file.c |   30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff -puN fs/nfs/file.c~fs-nfs-inform-the-vm-about-pages-being-committed-or-unstable fs/nfs/file.c
--- a/fs/nfs/file.c~fs-nfs-inform-the-vm-about-pages-being-committed-or-unstable
+++ a/fs/nfs/file.c
@@ -495,6 +495,35 @@ static int nfs_release_page(struct page
 	return nfs_fscache_release_page(page, gfp);
 }
 
+static void nfs_check_dirty_writeback(struct page *page,
+				bool *dirty, bool *writeback)
+{
+	struct nfs_inode *nfsi;
+	struct address_space *mapping = page_file_mapping(page);
+
+	if (!mapping || PageSwapCache(page))
+		return;
+
+	/*
+	 * Check if an unstable page is currently being committed and
+	 * if so, have the VM treat it as if the page is under writeback
+	 * so it will not block due to pages that will shortly be freeable.
+	 */
+	nfsi = NFS_I(mapping->host);
+	if (test_bit(NFS_INO_COMMIT, &nfsi->flags)) {
+		*writeback = true;
+		return;
+	}
+
+	/*
+	 * If PagePrivate() is set, then the page is not freeable and as the
+	 * inode is not being committed, it's not going to be cleaned in the
+	 * near future so treat it as dirty
+	 */
+	if (PagePrivate(page))
+		*dirty = true;
+}
+
 /*
  * Attempt to clear the private state associated with a page when an error
  * occurs that requires the cached contents of an inode to be written back or
@@ -542,6 +571,7 @@ const struct address_space_operations nf
 	.direct_IO = nfs_direct_IO,
 	.migratepage = nfs_migrate_page,
 	.launder_page = nfs_launder_page,
+	.is_dirty_writeback = nfs_check_dirty_writeback,
 	.error_remove_page = generic_error_remove_page,
 #ifdef CONFIG_NFS_SWAP
 	.swap_activate = nfs_swap_activate,
_

Patches currently in -mm which might be from mgorman@suse.de are

linux-next.patch
mm-page_alloc-factor-out-setting-of-pcp-high-and-pcp-batch.patch
mm-page_alloc-prevent-concurrent-updaters-of-pcp-batch-and-high.patch
mm-page_alloc-insert-memory-barriers-to-allow-async-update-of-pcp-batch-and-high.patch
mm-page_alloc-protect-pcp-batch-accesses-with-access_once.patch
mm-page_alloc-convert-zone_pcp_update-to-rely-on-memory-barriers-instead-of-stop_machine.patch
mm-page_alloc-when-handling-percpu_pagelist_fraction-dont-unneedly-recalulate-high.patch
mm-page_alloc-factor-setup_pageset-into-pageset_init-and-pageset_set_batch.patch
mm-page_alloc-relocate-comment-to-be-directly-above-code-it-refers-to.patch
mm-page_alloc-factor-zone_pageset_init-out-of-setup_zone_pageset.patch
mm-page_alloc-in-zone_pcp_update-uze-zone_pageset_init.patch
mm-page_alloc-rename-setup_pagelist_highmark-to-match-naming-of-pageset_set_batch.patch
mm-vmscan-limit-the-number-of-pages-kswapd-reclaims-at-each-priority.patch
mm-vmscan-obey-proportional-scanning-requirements-for-kswapd.patch
mm-vmscan-flatten-kswapd-priority-loop.patch
mm-vmscan-decide-whether-to-compact-the-pgdat-based-on-reclaim-progress.patch
mm-vmscan-do-not-allow-kswapd-to-scan-at-maximum-priority.patch
mm-vmscan-have-kswapd-writeback-pages-based-on-dirty-pages-encountered-not-priority.patch
mm-vmscan-block-kswapd-if-it-is-encountering-pages-under-writeback.patch
mm-vmscan-block-kswapd-if-it-is-encountering-pages-under-writeback-fix.patch
mm-vmscan-block-kswapd-if-it-is-encountering-pages-under-writeback-fix-2.patch
mm-vmscan-check-if-kswapd-should-writepage-once-per-pgdat-scan.patch
mm-vmscan-move-logic-from-balance_pgdat-to-kswapd_shrink_zone.patch
mm-vmscan-stall-page-reclaim-and-writeback-pages-based-on-dirty-writepage-pages-encountered-v3.patch
mm-vmscan-stall-page-reclaim-after-a-list-of-pages-have-been-processed-v3.patch
mm-vmscan-set-zone-flags-before-blocking.patch
mm-vmscan-move-direct-reclaim-wait_iff_congested-into-shrink_list.patch
mm-vmscan-treat-pages-marked-for-immediate-reclaim-as-zone-congestion.patch
mm-vmscan-take-page-buffers-dirty-and-locked-state-into-account-v3.patch
fs-nfs-inform-the-vm-about-pages-being-committed-or-unstable.patch
mm-add-tracepoints-for-lru-activation-and-insertions.patch
mm-pagevec-defer-deciding-what-lru-to-add-a-page-to-until-pagevec-drain-time.patch
mm-activate-pagelru-pages-on-mark_page_accessed-if-page-is-on-local-pagevec.patch
mm-remove-lru-parameter-from-__pagevec_lru_add-and-remove-parts-of-pagevec-api.patch
mm-remove-lru-parameter-from-__lru_cache_add-and-lru_cache_add_lru.patch
mm-memmap_init_zone-performance-improvement.patch

