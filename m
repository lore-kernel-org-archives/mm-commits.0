From: akpm@linux-foundation.org
Subject: + nbd-show-read-only-state-in-sysfs.patch added to -mm tree
Date: Tue, 12 Feb 2013 13:43:08 -0800
Message-ID: <20130212214309.292CC31C1CF@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f201.google.com ([209.85.128.201]:32848 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752886Ab3BLVnK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Feb 2013 16:43:10 -0500
Received: by mail-ve0-f201.google.com with SMTP id 14so61550vea.0
        for <mm-commits@vger.kernel.org>; Tue, 12 Feb 2013 13:43:09 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pbonzini@redhat.com, Paul.Clements@steeleye.com, alex@alex.org.uk


The patch titled
     Subject: nbd: show read-only state in sysfs
has been added to the -mm tree.  Its filename is
     nbd-show-read-only-state-in-sysfs.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

linux-next.patch
nbd-support-flush-requests.patch
nbd-fsync-and-kill-block-device-on-shutdown.patch
nbd-show-read-only-state-in-sysfs.patch

