From: akpm@linux-foundation.org
Subject: [alternative-merged] block-remove-deadlock-in-disk_clear_events.patch removed from -mm tree
Date: Thu, 20 Dec 2012 12:15:03 -0800
Message-ID: <20121220201504.2000E200061@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f201.google.com ([74.125.82.201]:39799 "EHLO
	mail-we0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533Ab2LTUPH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 20 Dec 2012 15:15:07 -0500
Received: by mail-we0-f201.google.com with SMTP id t11so207125wey.2
        for <mm-commits@vger.kernel.org>; Thu, 20 Dec 2012 12:15:05 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dbasehore@chromium.org, axboe@kernel.dk, msb@chromium.org, mm-commits@vger.kernel.org


The patch titled
     Subject: block: remove deadlock in disk_clear_events
has been removed from the -mm tree.  Its filename was
     block-remove-deadlock-in-disk_clear_events.patch

This patch was dropped because an alternative patch was merged

------------------------------------------------------
From: Derek Basehore <dbasehore@chromium.org>
Subject: block: remove deadlock in disk_clear_events

In disk_clear_events, do not put work on system_nrt_freezable_wq. 
Instead, put it on system_nrt_wq.

There is a race between probing a usb and suspending the device.  Since
probing a usb calls disk_clear_events, which puts work on a frozen
workqueue, probing cannot finish after the workqueue is frozen.  However,
suspending cannot finish until the usb probe is finished, so we get a
deadlock, causing the system to reboot.

The way to reproduce this bug is to wake up from suspend with a usb
storage device plugged in, or plugging in a usb storage device right
before suspend.  The window of time is on the order of time it takes to
probe the usb device.  As long as the workqueues are frozen before the
call to add_disk within sd_probe_async finishes, there will be a deadlock
(which calls blkdev_get, sd_open, check_disk_change, then
disk_clear_events).  This is not difficult to reproduce after figuring out
the timings.

[akpm@linux-foundation.org: fix up comment]
Signed-off-by: Derek Basehore <dbasehore@chromium.org>
Reviewed-by: Mandeep Singh Baines <msb@chromium.org>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/genhd.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff -puN block/genhd.c~block-remove-deadlock-in-disk_clear_events block/genhd.c
--- a/block/genhd.c~block-remove-deadlock-in-disk_clear_events
+++ a/block/genhd.c
@@ -1565,7 +1565,14 @@ unsigned int disk_clear_events(struct ge
 
 	/* uncondtionally schedule event check and wait for it to finish */
 	disk_block_events(disk);
-	queue_delayed_work(system_freezable_wq, &ev->dwork, 0);
+	/*
+	 * We need to put the work on system_nrt_wq here since there is a
+	 * deadlock that happens while probing a usb device while suspending. If
+	 * we put work on a freezable workqueue here, a usb probe will wait here
+	 * until the workqueue is unfrozen during suspend. Since suspend waits
+	 * on all probes to complete, we have a deadlock
+	 */
+	queue_delayed_work(system_nrt_wq, &ev->dwork, 0);
 	flush_delayed_work(&ev->dwork);
 	__disk_unblock_events(disk, false);
 
_

Patches currently in -mm which might be from dbasehore@chromium.org are

origin.patch
linux-next.patch
block-prevent-race-cleanup.patch

