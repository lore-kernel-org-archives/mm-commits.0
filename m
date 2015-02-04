From: akpm@linux-foundation.org
Subject: + zram-rework-reset-and-destroy-path-fix-2.patch added to -mm
 tree
Date: Wed, 04 Feb 2015 14:30:19 -0800
Message-ID: <54d29d7b.NGIpL9CSy0lOLcTg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47120 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933817AbbBDWaU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Feb 2015 17:30:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, jmarchan@redhat.com, minchan@kernel.org, ngupta@vflare.org, opensource.ganesh@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: set default dev_id value to zero in zram_init()
has been added to the -mm tree.  Its filename is
     zram-rework-reset-and-destroy-path-fix-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zram-rework-reset-and-destroy-path-fix-2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zram-rework-reset-and-destroy-path-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: zram: set default dev_id value to zero in zram_init()

Set dev_id to zero and fix zram_devices allocation error handling
path, can pass uninit dev_id to destroy_devices().

cosmetic:
change destroy_devices() message from pr_debug() to pr_info(), as
proposed by Minchan Kim.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Ganesh Mahendran <opensource.ganesh@gmail.com>
Cc: Jerome Marchand <jmarchan@redhat.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff -puN drivers/block/zram/zram_drv.c~zram-rework-reset-and-destroy-path-fix-2 drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-rework-reset-and-destroy-path-fix-2
+++ a/drivers/block/zram/zram_drv.c
@@ -1136,12 +1136,12 @@ static void destroy_devices(unsigned int
 
 	kfree(zram_devices);
 	unregister_blkdev(zram_major, "zram");
-	pr_debug("Destroyed %u device(s)\n", nr);
+	pr_info("Destroyed %u device(s)\n", nr);
 }
 
 static int __init zram_init(void)
 {
-	int ret, dev_id;
+	int ret = -ENOMEM, dev_id = 0;
 
 	if (num_devices > max_num_devices) {
 		pr_warn("Invalid value for num_devices: %u\n",
@@ -1157,10 +1157,8 @@ static int __init zram_init(void)
 
 	/* Allocate the device array and initialize each one */
 	zram_devices = kzalloc(num_devices * sizeof(struct zram), GFP_KERNEL);
-	if (!zram_devices) {
-		ret = -ENOMEM;
+	if (!zram_devices)
 		goto out_error;
-	}
 
 	for (dev_id = 0; dev_id < num_devices; dev_id++) {
 		ret = create_device(&zram_devices[dev_id], dev_id);
_

Patches currently in -mm which might be from sergey.senozhatsky@gmail.com are

zram-clean-up-zram_meta_alloc.patch
zram-free-meta-table-in-zram_meta_free.patch
zram-fix-umount-reset_store-mount-race-condition.patch
zram-rework-reset-and-destroy-path.patch
zram-rework-reset-and-destroy-path-fix.patch
zram-rework-reset-and-destroy-path-fix-2.patch
zram-rework-reset-and-destroy-path-fix-2-fix.patch
zram-check-bd_openers-instead-bd_holders.patch
linux-next.patch

