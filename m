From: akpm@linux-foundation.org
Subject: [folded-merged] block-remove-deadlock-in-disk_clear_events-fix.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:26:29 -0800
Message-ID: <20121218202629.D5C9C82004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:37006 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753743Ab2LRU0a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:26:30 -0500
Received: by mail-qa0-f74.google.com with SMTP id r4so160925qaq.3
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:26:30 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, axboe@kernel.dk, dbasehore@chromium.org, msb@chromium.org, mm-commits@vger.kernel.org


The patch titled
     Subject: block-remove-deadlock-in-disk_clear_events-fix
has been removed from the -mm tree.  Its filename was
     block-remove-deadlock-in-disk_clear_events-fix.patch

This patch was dropped because it was folded into block-remove-deadlock-in-disk_clear_events.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: block-remove-deadlock-in-disk_clear_events-fix

fix up comment

Cc: Derek Basehore <dbasehore@chromium.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Mandeep Singh Baines <msb@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/genhd.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN block/genhd.c~block-remove-deadlock-in-disk_clear_events-fix block/genhd.c
--- a/block/genhd.c~block-remove-deadlock-in-disk_clear_events-fix
+++ a/block/genhd.c
@@ -1565,9 +1565,10 @@ unsigned int disk_clear_events(struct ge
 
 	/* uncondtionally schedule event check and wait for it to finish */
 	disk_block_events(disk);
-	/* We need to put the work on system_nrt_wq here since there is a
+	/*
+	 * We need to put the work on system_nrt_wq here since there is a
 	 * deadlock that happens while probing a usb device while suspending. If
-	 * we put work on a freezable worqueue here, a usb probe will wait here
+	 * we put work on a freezable workqueue here, a usb probe will wait here
 	 * until the workqueue is unfrozen during suspend. Since suspend waits
 	 * on all probes to complete, we have a deadlock
 	 */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
irq-tsk-comm-is-an-array.patch
block-remove-deadlock-in-disk_clear_events.patch
block-prevent-race-cleanup-fix.patch

