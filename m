From: akpm@linux-foundation.org
Subject: [merged]
 fs-nfs-inform-the-vm-about-pages-being-committed-or-unstable.patch removed
 from -mm tree
Date: Mon, 08 Jul 2013 12:25:04 -0700
Message-ID: <51db1210.7FdML00RRJlP4o+Q%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50351 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753165Ab3GHTZF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:25:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zcalusic@bitsync.net, trond.myklebust@fys.uio.no, riel@redhat.com, mhocko@suse.cz, kamezawa.hiroyu@jp.fujitsu.com, jslaby@suse.cz, hannes@cmpxchg.org, dormando@rydia.net, Valdis.Kletnieks@vt.edu, mgorman@suse.de

Subject: [merged] fs-nfs-inform-the-vm-about-pages-being-committed-or-unstable.patch removed from -mm tree
To: mgorman@suse.de,Valdis.Kletnieks@vt.edu,dormando@rydia.net,hannes@cmpxchg.org,jslaby@suse.cz,kamezawa.hiroyu@jp.fujitsu.com,mhocko@suse.cz,riel@redhat.com,trond.myklebust@fys.uio.no,zcalusic@bitsync.net,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:25:04 -0700


The patch titled
     Subject: fs: nfs: inform the VM about pages being committed or unstable
has been removed from the -mm tree.  Its filename was
     fs-nfs-inform-the-vm-about-pages-being-committed-or-unstable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch
fs-bump-inode-and-dentry-counters-to-long.patch
super-fix-calculation-of-shrinkable-objects-for-small-numbers.patch
dcache-convert-dentry_statnr_unused-to-per-cpu-counters.patch
dentry-move-to-per-sb-lru-locks.patch
dcache-remove-dentries-from-lru-before-putting-on-dispose-list.patch
mm-new-shrinker-api.patch
shrinker-convert-superblock-shrinkers-to-new-api.patch
list-add-a-new-lru-list-type.patch
inode-convert-inode-lru-list-to-generic-lru-list-code.patch
dcache-convert-to-use-new-lru-list-infrastructure.patch
list_lru-per-node-list-infrastructure.patch
list_lru-per-node-api.patch
shrinker-add-node-awareness.patch
vmscan-per-node-deferred-work.patch
fs-convert-inode-and-dentry-shrinking-to-be-node-aware.patch
xfs-convert-buftarg-lru-to-generic-code.patch
xfs-rework-buffer-dispose-list-tracking.patch
xfs-convert-dquot-cache-lru-to-list_lru.patch
fs-convert-fs-shrinkers-to-new-scan-count-api.patch
drivers-convert-shrinkers-to-new-count-scan-api.patch
i915-bail-out-earlier-when-shrinker-cannot-acquire-mutex.patch
shrinker-convert-remaining-shrinkers-to-count-scan-api.patch
hugepage-convert-huge-zero-page-shrinker-to-new-shrinker-api.patch
shrinker-kill-old-shrink-api.patch
list_lru-dynamically-adjust-node-arrays.patch
zbud-add-to-mm.patch
zswap-add-to-mm.patch
zswap-add-documentation.patch
mm-vmscan-do-not-continue-scanning-if-reclaim-was-aborted-for-compaction.patch
mm-vmscan-do-not-scale-writeback-pages-when-deciding-whether-to-set-zone_writeback.patch
mm-memmap_init_zone-performance-improvement.patch

