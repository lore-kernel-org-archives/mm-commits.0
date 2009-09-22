From: akpm@linux-foundation.org
Subject: [merged] md-avoid-use-of-broken-kzalloc-mempool.patch removed from -mm tree
Date: Tue, 22 Sep 2009 13:41:33 -0700
Message-ID: <200909222041.n8MKfXue007795@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47807 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750978AbZIVUlf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 16:41:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sage@newdream.net, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     md: avoid use of broken kzalloc mempool
has been removed from the -mm tree.  Its filename was
     md-avoid-use-of-broken-kzalloc-mempool.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: md: avoid use of broken kzalloc mempool
From: Sage Weil <sage@newdream.net>

The kzalloc mempool does not re-zero items that have been used and then
returned to the pool.  Manually zero the allocated multipath_bh instead.

Acked-by: Neil Brown <neilb@suse.de>
Signed-off-by: Sage Weil <sage@newdream.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/multipath.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/md/multipath.c~md-avoid-use-of-broken-kzalloc-mempool drivers/md/multipath.c
--- a/drivers/md/multipath.c~md-avoid-use-of-broken-kzalloc-mempool
+++ a/drivers/md/multipath.c
@@ -150,6 +150,7 @@ static int multipath_make_request (struc
 	}
 
 	mp_bh = mempool_alloc(conf->pool, GFP_NOIO);
+	memset(mp_bh, 0, sizeof(*mp_bh));
 
 	mp_bh->master_bio = bio;
 	mp_bh->mddev = mddev;
@@ -493,7 +494,7 @@ static int multipath_run (mddev_t *mddev
 	}
 	mddev->degraded = conf->raid_disks - conf->working_disks;
 
-	conf->pool = mempool_create_kzalloc_pool(NR_RESERVED_BUFS,
+	conf->pool = mempool_create_kmalloc_pool(NR_RESERVED_BUFS,
 						 sizeof(struct multipath_bh));
 	if (conf->pool == NULL) {
 		printk(KERN_ERR 
_

Patches currently in -mm which might be from sage@newdream.net are

origin.patch
vfs-fix-vfs_rename_dir-for-fs_rename_does_d_move-filesystems.patch

