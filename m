From: akpm@linux-foundation.org
Subject: - md-make-sure-a-reshape-is-started-when-device-switches-to-read-write.patch removed from -mm tree
Date: Tue, 04 Mar 2008 23:46:29 -0800
Message-ID: <200803050746.m257kTV2021775@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37631 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764505AbYCEHqd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Mar 2008 02:46:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     md: make sure a reshape is started when device switches to read-write
has been removed from the -mm tree.  Its filename was
     md-make-sure-a-reshape-is-started-when-device-switches-to-read-write.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
md-fix-integer-as-null-pointer-warnings-in-mdc.patch

