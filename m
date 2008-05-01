From: akpm@linux-foundation.org
Subject: - md-fix-up-switching-md-arrays-between-read-only-and-read-write.patch removed from -mm tree
Date: Thu, 01 May 2008 02:25:35 -0700
Message-ID: <200805010925.m419PZJV030216@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51213 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755369AbYEAJ0I (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:26:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     md: fix up switching md arrays between read-only and read-write
has been removed from the -mm tree.  Its filename was
     md-fix-up-switching-md-arrays-between-read-only-and-read-write.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: md: fix up switching md arrays between read-only and read-write
From: NeilBrown <neilb@suse.de>

When setting an array to 'readonly' or to 'active' via sysfs, we must make the
appropriate set_disk_ro call too.

Also when switching to "read_auto" (which is like readonly, but blocks on the
first write so that metadata can be marked 'dirty') we need to be more careful
about what state we are changing from.

Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/md.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff -puN drivers/md/md.c~md-fix-up-switching-md-arrays-between-read-only-and-read-write drivers/md/md.c
--- a/drivers/md/md.c~md-fix-up-switching-md-arrays-between-read-only-and-read-write
+++ a/drivers/md/md.c
@@ -2594,15 +2594,20 @@ array_state_store(mddev_t *mddev, const 
 			err = do_md_stop(mddev, 1);
 		else {
 			mddev->ro = 1;
+			set_disk_ro(mddev->gendisk, 1);
 			err = do_md_run(mddev);
 		}
 		break;
 	case read_auto:
-		/* stopping an active array */
 		if (mddev->pers) {
-			err = do_md_stop(mddev, 1);
-			if (err == 0)
-				mddev->ro = 2; /* FIXME mark devices writable */
+			if (mddev->ro != 1)
+				err = do_md_stop(mddev, 1);
+			else
+				err = restart_array(mddev);
+			if (err == 0) {
+				mddev->ro = 2;
+				set_disk_ro(mddev->gendisk, 0);
+			}
 		} else {
 			mddev->ro = 2;
 			err = do_md_run(mddev);
@@ -2640,6 +2645,7 @@ array_state_store(mddev_t *mddev, const 
 			err = 0;
 		} else {
 			mddev->ro = 0;
+			set_disk_ro(mddev->gendisk, 0);
 			err = do_md_run(mddev);
 		}
 		break;
_

Patches currently in -mm which might be from neilb@suse.de are

origin.patch
sunrpc-assign-pde-data-before-gluing-pde-into-proc-tree.patch

