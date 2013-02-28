From: akpm@linux-foundation.org
Subject: [merged] nbd-show-read-only-state-in-sysfs.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:17:02 -0800
Message-ID: <20130228201703.11A875A42B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:64027 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754343Ab3B1URE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:17:04 -0500
Received: by mail-qa0-f73.google.com with SMTP id g10so261612qah.0
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:17:03 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pbonzini@redhat.com, Paul.Clements@steeleye.com, alex@alex.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: nbd: show read-only state in sysfs
has been removed from the -mm tree.  Its filename was
     nbd-show-read-only-state-in-sysfs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Paolo Bonzini <pbonzini@redhat.com>
Subject: nbd: show read-only state in sysfs

Pass the read-only flag to set_device_ro, so that it will be visible to
the block layer and in sysfs.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Cc: Paul Clements <Paul.Clements@steeleye.com>
Cc: Alex Bligh <alex@alex.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/nbd.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN drivers/block/nbd.c~nbd-show-read-only-state-in-sysfs drivers/block/nbd.c
--- a/drivers/block/nbd.c~nbd-show-read-only-state-in-sysfs
+++ a/drivers/block/nbd.c
@@ -703,6 +703,8 @@ static int __nbd_ioctl(struct block_devi
 
 		mutex_unlock(&nbd->tx_lock);
 
+		if (nbd->flags & NBD_FLAG_READ_ONLY)
+			set_device_ro(bdev, true);
 		if (nbd->flags & NBD_FLAG_SEND_TRIM)
 			queue_flag_set_unlocked(QUEUE_FLAG_DISCARD,
 				nbd->disk->queue);
@@ -730,6 +732,7 @@ static int __nbd_ioctl(struct block_devi
 		dev_warn(disk_to_dev(nbd->disk), "queue cleared\n");
 		kill_bdev(bdev);
 		queue_flag_clear_unlocked(QUEUE_FLAG_DISCARD, nbd->disk->queue);
+		set_device_ro(bdev, false);
 		if (file)
 			fput(file);
 		nbd->flags = 0;
_

Patches currently in -mm which might be from pbonzini@redhat.com are

origin.patch

