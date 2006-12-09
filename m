From: akpm@osdl.org
Subject: + md-allow-mddevs-to-live-a-bit-longer-to-avoid-a-loop-with-udev.patch added to -mm tree
Date: Fri, 08 Dec 2006 16:02:53 -0800
Message-ID: <200612090002.kB902rW6010096@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:55040 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1947555AbWLIAC5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 19:02:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: neilb@suse.de


The patch titled
     md: allow mddevs to live a bit longer to avoid a loop with udev
has been added to the -mm tree.  Its filename is
     md-allow-mddevs-to-live-a-bit-longer-to-avoid-a-loop-with-udev.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: md: allow mddevs to live a bit longer to avoid a loop with udev
From: NeilBrown <neilb@suse.de>

As md devices a automatically created on first open, and automatically
destroyed on last close if they have no significant state, a loop can be
caused with udev.

If you open/close an md device that will generate add and remove events to
udev.  udev will open the device, notice nothing is there and close it again
...  which generates another pair of add/remove events.  Ad infinitum.

So: Change md to only destroy a device if an explicity MD_STOP was requested. 
This means that md devices might hang around longer than you would like, but
it is easy to get rid of them, and that could even be automated in user-space
(e.g.  by mdadm --monitor).

Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/md/md.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/md/md.c~md-allow-mddevs-to-live-a-bit-longer-to-avoid-a-loop-with-udev drivers/md/md.c
--- a/drivers/md/md.c~md-allow-mddevs-to-live-a-bit-longer-to-avoid-a-loop-with-udev
+++ a/drivers/md/md.c
@@ -292,7 +292,7 @@ static mddev_t * mddev_find(dev_t unit)
 	atomic_set(&new->active, 1);
 	spin_lock_init(&new->write_lock);
 	init_waitqueue_head(&new->sb_wait);
-	new->dead = 1;
+	new->dead = 0;
 
 	new->queue = blk_alloc_queue(GFP_KERNEL);
 	if (!new->queue) {
_

Patches currently in -mm which might be from neilb@suse.de are

origin.patch
readahead-nfsd-case.patch
readahead-nfsd-case-fix.patch
md-tidy-up-device-change-notification-when-an-md-array-is-stopped.patch
md-define-raid5_mergeable_bvec.patch
md-handle-bypassing-the-read-cache-assuming-nothing-fails.patch
md-allow-reads-that-have-bypassed-the-cache-to-be-retried-on-failure.patch
md-allow-reads-that-have-bypassed-the-cache-to-be-retried-on-failure-fix.patch
md-allow-reads-that-have-bypassed-the-cache-to-be-retried-on-failure-misc-fixes-for-aligned-read-handling-including-raid6-read-corruption.patch
md-allow-reads-that-have-bypassed-the-cache-to-be-retried-on-failure-misc-fixes-for-error-handling-of-aligned-reads.patch
md-enable-bypassing-cache-for-reads.patch
md-fix-innocuous-bug-in-raid6-stripe_to_pdidx.patch
md-conditionalize-some-code.patch
md-remove-some-old-ifdefed-out-code-from-raid5c.patch
md-return-a-non-zero-error-to-bi_end_io-as-appropriate-in-raid5.patch
md-assorted-md-and-raid1-one-liners.patch
md-change-lifetime-rules-for-md-devices.patch
md-close-a-race-between-destroying-and-recreating-an-md-device.patch
md-allow-mddevs-to-live-a-bit-longer-to-avoid-a-loop-with-udev.patch
md-dm-reduce-stack-usage-with-stacked-block-devices.patch

