From: akpm@linux-foundation.org
Subject: + md-skip-all-metadata-update-processing-when-using-external-metadata.patch added to -mm tree
Date: Mon, 28 Apr 2008 20:56:23 -0700
Message-ID: <200804290356.m3T3uN74032353@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35962 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752624AbYD2D41 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 23:56:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: neilb@suse.de


The patch titled
     md: skip all metadata update processing when using external metadata.
has been added to the -mm tree.  Its filename is
     md-skip-all-metadata-update-processing-when-using-external-metadata.patch

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
Subject: md: skip all metadata update processing when using external metadata.
From: NeilBrown <neilb@suse.de>

All the metadata update processing for external metadata is on in user-space
or through the sysfs interfaces, so make "md_update_sb" a no-op in that case.

Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/md.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/md/md.c~md-skip-all-metadata-update-processing-when-using-external-metadata drivers/md/md.c
--- a/drivers/md/md.c~md-skip-all-metadata-update-processing-when-using-external-metadata
+++ a/drivers/md/md.c
@@ -1651,6 +1651,8 @@ static void md_update_sb(mddev_t * mddev
 	int sync_req;
 	int nospares = 0;
 
+	if (mddev->external)
+		return;
 repeat:
 	spin_lock_irq(&mddev->write_lock);
 
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

