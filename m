From: akpm@linux-foundation.org
Subject: + block-remove-deadlock-in-disk_clear_events.patch added to -mm tree
Date: Mon, 03 Dec 2012 16:22:52 -0800
Message-ID: <20121204002253.7CEE320004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ea0-f202.google.com ([209.85.215.202]:42061 "EHLO
	mail-ea0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502Ab2LDAW4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Dec 2012 19:22:56 -0500
Received: by mail-ea0-f202.google.com with SMTP id j12so242677eaa.1
        for <mm-commits@vger.kernel.org>; Mon, 03 Dec 2012 16:22:54 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dbasehore@chromium.org, axboe@kernel.dk, msb@chromium.org


The patch titled
     Subject: block: remove deadlock in disk_clear_events
has been added to the -mm tree.  Its filename is
     block-remove-deadlock-in-disk_clear_events.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Derek Basehore <dbasehore@chromium.org>
Subject: block: remove deadlock in disk_clear_events

In disk_clear_events(), do not put work on system_nrt_freezable_wq. 
Instead, put it on system_nrt_wq.

There is a race between probing a usb and suspending the device.  Since
probing a usb calls disk_clear_events, which puts work on a frozen
workqueue, probing cannot finish after the workqueue is frozen.  However,
suspending cannot finish until the usb probe is finished, so we get a
deadlock.

Signed-off-by: Derek Basehore <dbasehore@chromium.org>
Reviewed-by: Mandeep Singh Baines <msb@chromium.org>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/genhd.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN block/genhd.c~block-remove-deadlock-in-disk_clear_events block/genhd.c
--- a/block/genhd.c~block-remove-deadlock-in-disk_clear_events
+++ a/block/genhd.c
@@ -1565,7 +1565,13 @@ unsigned int disk_clear_events(struct ge
 
 	/* uncondtionally schedule event check and wait for it to finish */
 	disk_block_events(disk);
-	queue_delayed_work(system_freezable_wq, &ev->dwork, 0);
+	/* We need to put the work on system_nrt_wq here since there is a
+	 * deadlock that happens while probing a usb device while suspending. If
+	 * we put work on a freezable worqueue here, a usb probe will wait here
+	 * until the workqueue is unfrozen during suspend. Since suspend waits
+	 * on all probes to complete, we have a deadlock
+	 */
+	queue_delayed_work(system_nrt_wq, &ev->dwork, 0);
 	flush_delayed_work(&ev->dwork);
 	__disk_unblock_events(disk, false);
 
_

Patches currently in -mm which might be from dbasehore@chromium.org are

linux-next.patch
block-remove-deadlock-in-disk_clear_events.patch
block-remove-deadlock-in-disk_clear_events-fix.patch
block-prevent-race-cleanup.patch
block-prevent-race-cleanup-fix.patch

