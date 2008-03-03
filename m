From: akpm@linux-foundation.org
Subject: + md-fix-possible-raid1-raid10-deadlock-on-read-error-during-resync.patch added to -mm tree
Date: Mon, 03 Mar 2008 00:23:40 -0800
Message-ID: <200803030823.m238NeEk006540@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36576 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752252AbYCCIYR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Mar 2008 03:24:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: neilb@suse.de, k-tanaka@ce.jp.nec.com


The patch titled
     md: fix possible raid1/raid10 deadlock on read error during resync
has been added to the -mm tree.  Its filename is
     md-fix-possible-raid1-raid10-deadlock-on-read-error-during-resync.patch

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
Subject: md: fix possible raid1/raid10 deadlock on read error during resync
From: NeilBrown <neilb@suse.de>

Thanks to K.Tanaka and the scsi fault injection framework, here is a fix for
another possible deadlock in raid1/raid10 error handing.

If a read request returns an error while a resync is happening and a resync
request is pending, the attempt to fix the error will block until the resync
progresses, and the resync will block until the read request completes.  Thus
a deadlock.

This patch fixes the problem.

Cc: "K.Tanaka" <k-tanaka@ce.jp.nec.com>
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/raid1.c  |   11 +++++++++--
 drivers/md/raid10.c |   11 +++++++++--
 2 files changed, 18 insertions(+), 4 deletions(-)

diff -puN drivers/md/raid1.c~md-fix-possible-raid1-raid10-deadlock-on-read-error-during-resync drivers/md/raid1.c
--- a/drivers/md/raid1.c~md-fix-possible-raid1-raid10-deadlock-on-read-error-during-resync
+++ a/drivers/md/raid1.c
@@ -704,13 +704,20 @@ static void freeze_array(conf_t *conf)
 	/* stop syncio and normal IO and wait for everything to
 	 * go quite.
 	 * We increment barrier and nr_waiting, and then
-	 * wait until barrier+nr_pending match nr_queued+2
+	 * wait until nr_pending match nr_queued+1
+	 * This is called in the context of one normal IO request
+	 * that has failed. Thus any sync request that might be pending
+	 * will be blocked by nr_pending, and we need to wait for
+	 * pending IO requests to complete or be queued for re-try.
+	 * Thus the number queued (nr_queued) plus this request (1)
+	 * must match the number of pending IOs (nr_pending) before
+	 * we continue.
 	 */
 	spin_lock_irq(&conf->resync_lock);
 	conf->barrier++;
 	conf->nr_waiting++;
 	wait_event_lock_irq(conf->wait_barrier,
-			    conf->barrier+conf->nr_pending == conf->nr_queued+2,
+			    conf->nr_pending == conf->nr_queued+1,
 			    conf->resync_lock,
 			    ({ flush_pending_writes(conf);
 			       raid1_unplug(conf->mddev->queue); }));
diff -puN drivers/md/raid10.c~md-fix-possible-raid1-raid10-deadlock-on-read-error-during-resync drivers/md/raid10.c
--- a/drivers/md/raid10.c~md-fix-possible-raid1-raid10-deadlock-on-read-error-during-resync
+++ a/drivers/md/raid10.c
@@ -747,13 +747,20 @@ static void freeze_array(conf_t *conf)
 	/* stop syncio and normal IO and wait for everything to
 	 * go quiet.
 	 * We increment barrier and nr_waiting, and then
-	 * wait until barrier+nr_pending match nr_queued+2
+	 * wait until nr_pending match nr_queued+1
+	 * This is called in the context of one normal IO request
+	 * that has failed. Thus any sync request that might be pending
+	 * will be blocked by nr_pending, and we need to wait for
+	 * pending IO requests to complete or be queued for re-try.
+	 * Thus the number queued (nr_queued) plus this request (1)
+	 * must match the number of pending IOs (nr_pending) before
+	 * we continue.
 	 */
 	spin_lock_irq(&conf->resync_lock);
 	conf->barrier++;
 	conf->nr_waiting++;
 	wait_event_lock_irq(conf->wait_barrier,
-			    conf->barrier+conf->nr_pending == conf->nr_queued+2,
+			    conf->nr_pending == conf->nr_queued+1,
 			    conf->resync_lock,
 			    ({ flush_pending_writes(conf);
 			       raid10_unplug(conf->mddev->queue); }));
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

