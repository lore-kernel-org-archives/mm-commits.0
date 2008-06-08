From: akpm@linux-foundation.org
Subject: - md-fix-uninitialized-use-of-mddev-recovery_wait.patch removed from -mm tree
Date: Sun, 08 Jun 2008 12:46:58 -0700
Message-ID: <200806081946.m58Jkwpx017378@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40605 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753902AbYFHTsB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 8 Jun 2008 15:48:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, neilb@suse.de, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     md: fix uninitialized use of mddev->recovery_wait
has been removed from the -mm tree.  Its filename was
     md-fix-uninitialized-use-of-mddev-recovery_wait.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: md: fix uninitialized use of mddev->recovery_wait
From: Dan Williams <dan.j.williams@intel.com>

If an array was created with --assume-clean we will oops when trying to
set ->resync_max.

Fix this by initializing ->recovery_wait in mddev_find.

Cc: <stable@kernel.org>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/md.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/md/md.c~md-fix-uninitialized-use-of-mddev-recovery_wait drivers/md/md.c
--- a/drivers/md/md.c~md-fix-uninitialized-use-of-mddev-recovery_wait
+++ a/drivers/md/md.c
@@ -276,6 +276,7 @@ static mddev_t * mddev_find(dev_t unit)
 	atomic_set(&new->active, 1);
 	spin_lock_init(&new->write_lock);
 	init_waitqueue_head(&new->sb_wait);
+	init_waitqueue_head(&new->recovery_wait);
 	new->reshape_position = MaxSector;
 	new->resync_max = MaxSector;
 	new->level = LEVEL_NONE;
@@ -5665,7 +5666,6 @@ void md_do_sync(mddev_t *mddev)
 		window/2,(unsigned long long) max_sectors/2);
 
 	atomic_set(&mddev->recovery_active, 0);
-	init_waitqueue_head(&mddev->recovery_wait);
 	last_check = 0;
 
 	if (j>2) {
_

Patches currently in -mm which might be from dan.j.williams@intel.com are

origin.patch
linux-next.patch
arm-fix-header-guards.patch
fsldma-the-mpc8377mds-board-device-tree-node-for-fsldma-driver.patch

