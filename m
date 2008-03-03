From: akpm@linux-foundation.org
Subject: + md-make-sure-a-reshape-is-started-when-device-switches-to-read-write.patch added to -mm tree
Date: Mon, 03 Mar 2008 00:23:34 -0800
Message-ID: <200803030823.m238NY6K006530@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35253 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752195AbYCCIYI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Mar 2008 03:24:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: neilb@suse.de


The patch titled
     md: make sure a reshape is started when device switches to read-write
has been added to the -mm tree.  Its filename is
     md-make-sure-a-reshape-is-started-when-device-switches-to-read-write.patch

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
Subject: md: make sure a reshape is started when device switches to read-write
From: NeilBrown <neilb@suse.de>

A resync/reshape/recovery thread will refuse to progress when the array is
marked read-only.  So whenever it mark it not read-only, it is important to
wake up thread resync thread.  There is one place we didn't do this.

The problem manifests if the start_ro module parameters is set, and a raid5
array that is in the middle of a reshape (restripe) is started.  The array
will initially be semi-read-only (meaning it acts like it is readonly until
the first write).  So the reshape will not proceed.

On the first write, the array will become read-write, but the reshape will not
be started, and there is no event which will ever restart that thread.

Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/md.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/md/md.c~md-make-sure-a-reshape-is-started-when-device-switches-to-read-write drivers/md/md.c
--- a/drivers/md/md.c~md-make-sure-a-reshape-is-started-when-device-switches-to-read-write
+++ a/drivers/md/md.c
@@ -5356,6 +5356,7 @@ void md_write_start(mddev_t *mddev, stru
 		mddev->ro = 0;
 		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 		md_wakeup_thread(mddev->thread);
+		md_wakeup_thread(mddev->sync_thread);
 	}
 	atomic_inc(&mddev->writes_pending);
 	if (mddev->in_sync) {
_

Patches currently in -mm which might be from neilb@suse.de are

git-nfsd.patch
md-fix-deadlock-in-md-raid1-and-md-raid10-when-handling-a-read-error.patch
md-reduce-cpu-wastage-on-idle-md-array-with-a-write-intent-bitmap.patch
md-guard-against-possible-bad-array-geometry-in-v1-metadata.patch
md-clean-up-irregularity-with-raid-autodetect.patch
md-make-sure-a-reshape-is-started-when-device-switches-to-read-write.patch
md-lock-access-to-rdev-attributes-properly.patch
md-dont-attempt-read-balancing-for-raid10-far-layouts.patch
md-fix-possible-raid1-raid10-deadlock-on-read-error-during-resync.patch
md-the-md-raid10-resync-thread-could-cause-a-md-raid10-array-deadlock.patch
md-fix-integer-as-null-pointer-warnings-in-mdc.patch

