From: akpm@linux-foundation.org
Subject: + md-make-sure-a-re-add-after-a-restart-honours-bitmap-when-resyncing.patch added to -mm tree
Date: Fri, 17 Aug 2007 11:49:44 -0700
Message-ID: <200708171849.l7HIniUP024336@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45806 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753586AbXHQStz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 17 Aug 2007 14:49:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: neilb@suse.de


The patch titled
     md: make sure a re-add after a restart honours bitmap when resyncing
has been added to the -mm tree.  Its filename is
     md-make-sure-a-re-add-after-a-restart-honours-bitmap-when-resyncing.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

md-make-sure-a-re-add-after-a-restart-honours-bitmap-when-resyncing.patch
md-correctly-update-sysfs-when-a-raid1-is-reshaped.patch
git-nfsd.patch
mm-revert-kernel_ds-buffered-write-optimisation.patch
fs-nfsd-exportc-make-3-functions-static.patch
sysctl-remove-broken-sunrpc-debug-binary-sysctls.patch
