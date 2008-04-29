From: akpm@linux-foundation.org
Subject: + md-fix-up-switching-md-arrays-between-read-only-and-read-write.patch added to -mm tree
Date: Mon, 28 Apr 2008 20:56:29 -0700
Message-ID: <200804290356.m3T3uTs7032365@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55712 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753572AbYD2D4d (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 23:56:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: neilb@suse.de


The patch titled
     md: fix up switching md arrays between read-only and read-write
has been added to the -mm tree.  Its filename is
     md-fix-up-switching-md-arrays-between-read-only-and-read-write.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -2593,15 +2593,20 @@ array_state_store(mddev_t *mddev, const 
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
@@ -2639,6 +2644,7 @@ array_state_store(mddev_t *mddev, const 
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
git-nfsd.patch
md-fix-use-after-free-when-removing-rdev-via-sysfs.patch
md-skip-all-metadata-update-processing-when-using-external-metadata.patch
md-reinitialise-more-mddev-fields-in-do_md_stop.patch
md-fix-safemode-handling-for-external-metadata.patch
md-fix-up-switching-md-arrays-between-read-only-and-read-write.patch
md-remove-a-stray-command-from-a-copy-and-paste-error-in-resync_start_store.patch
md-prevent-duplicates-in-bind_rdev_to_array.patch
md-md-raid5-rate-limit-error-printk.patch
md-md-support-blocking-writes-to-an-array-on-device-failure.patch
proc-introduce-proc_create_data-to-setup-de-data.patch
nfsd-use-proc_create-to-setup-de-proc_fops.patch
drivers-use-non-racy-method-for-proc-entries-creation-2.patch

