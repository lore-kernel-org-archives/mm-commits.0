From: akpm@linux-foundation.org
Subject: - md-make-sure-a-re-add-after-a-restart-honours-bitmap-when-resyncing.patch removed from -mm tree
Date: Fri, 24 Aug 2007 13:56:44 -0700
Message-ID: <200708242056.l7OKuiov014092@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57651 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759882AbXHXVIK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Aug 2007 17:08:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     md: make sure a re-add after a restart honours bitmap when resyncing
has been removed from the -mm tree.  Its filename was
     md-make-sure-a-re-add-after-a-restart-honours-bitmap-when-resyncing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: md: make sure a re-add after a restart honours bitmap when resyncing
From: NeilBrown <neilb@suse.de>

Commit 1757128438d41670ded8bc3bc735325cc07dc8f9 was slightly bad.  If an array
has a write-intent bitmap, and you remove a drive, then readd it, only the
changed parts should be resynced.  However after the above commit, this only
works if the array has not been shut down and restarted.

This is because it sets 'fullsync' at little more often than it should.  This
patch is more careful.

Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/raid1.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/md/raid1.c~md-make-sure-a-re-add-after-a-restart-honours-bitmap-when-resyncing drivers/md/raid1.c
--- a/drivers/md/raid1.c~md-make-sure-a-re-add-after-a-restart-honours-bitmap-when-resyncing
+++ a/drivers/md/raid1.c
@@ -1972,7 +1972,8 @@ static int run(mddev_t *mddev)
 		    !test_bit(In_sync, &disk->rdev->flags)) {
 			disk->head_position = 0;
 			mddev->degraded++;
-			conf->fullsync = 1;
+			if (disk->rdev)
+				conf->fullsync = 1;
 		}
 	}
 	if (mddev->degraded == conf->raid_disks) {
_

Patches currently in -mm which might be from neilb@suse.de are

origin.patch
git-nfsd.patch
mm-revert-kernel_ds-buffered-write-optimisation.patch
fs-nfsd-exportc-make-3-functions-static.patch
sysctl-remove-broken-sunrpc-debug-binary-sysctls.patch
