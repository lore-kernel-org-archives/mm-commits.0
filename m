From: akpm@linux-foundation.org
Subject: + zram-fix-unbalanced-idr-management-at-hot-removal.patch added
 to -mm tree
Date: Mon, 21 Nov 2016 22:42:48 -0800
Message-ID: <5833e8e8.SEYSi6WilRXQilYi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60902 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752159AbcKVGmu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Nov 2016 01:42:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tiwai@suse.de, ddiss@suse.de, minchan@kernel.org, sergey.senozhatsky@gmail.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: fix unbalanced idr management at hot removal
has been added to the -mm tree.  Its filename is
     zram-fix-unbalanced-idr-management-at-hot-removal.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zram-fix-unbalanced-idr-management-at-hot-removal.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zram-fix-unbalanced-idr-management-at-hot-removal.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Takashi Iwai <tiwai@suse.de>
Subject: zram: fix unbalanced idr management at hot removal

The zram hot removal code calls idr_remove() even when zram_remove()
returns an error (typically -EBUSY).  This results in a leftover at the
device release, eventually leading to a crash when the module is reloaded.

As described in the bug report below, the following procedure would cause
an Oops with zram:

- provision three zram devices via modprobe zram num_devices=3
- configure a size for each device
  + echo "1G" > /sys/block/$zram_name/disksize
- mkfs and mount zram0 only
- attempt to hot remove all three devices
  + echo 2 > /sys/class/zram-control/hot_remove
  + echo 1 > /sys/class/zram-control/hot_remove
  + echo 0 > /sys/class/zram-control/hot_remove
     - zram0 removal fails with EBUSY, as expected
- unmount zram0
- try zram0 hot remove again
  + echo 0 > /sys/class/zram-control/hot_remove
     - fails with ENODEV (unexpected)
- unload zram kernel module
  + completes successfully
- zram0 device node still exists
- attempt to mount /dev/zram0
  + mount command is killed
  + following BUG is encountered

 BUG: unable to handle kernel paging request at ffffffffa0002ba0
 IP: [<ffffffff812eead6>] get_disk+0x16/0x50
 Oops: 0000 [#1] SMP
 CPU: 0 PID: 252 Comm: mount Not tainted 4.9.0-rc6 #176
 task: ffff88001a9f2800 task.stack: ffffc90000300000
 RIP: 0010:[<ffffffff812eead6>]  [<ffffffff812eead6>] get_disk+0x16/0x50
 Call Trace:
  [<ffffffff812eeb1c>] exact_lock+0xc/0x20
  [<ffffffff813b3e1c>] kobj_lookup+0xdc/0x160
  [<ffffffff812edce0>] ? disk_map_sector_rcu+0x70/0x70
  [<ffffffff81127410>] ? blkdev_get_by_dev+0x50/0x50
  [<ffffffff812eef4f>] get_gendisk+0x2f/0x110
  [<ffffffff81127410>] ? blkdev_get_by_dev+0x50/0x50
  [<ffffffff81126e2c>] __blkdev_get+0x10c/0x3c0
  [<ffffffff81127410>] ? blkdev_get_by_dev+0x50/0x50
  [<ffffffff8112727d>] blkdev_get+0x19d/0x2e0
  [<ffffffff81127410>] ? blkdev_get_by_dev+0x50/0x50
  [<ffffffff81127466>] blkdev_open+0x56/0x70
  [<ffffffff810f3e0f>] do_dentry_open.isra.19+0x1ff/0x310
  [<ffffffff810f4aa3>] vfs_open+0x43/0x60
  [<ffffffff81103009>] path_openat+0x2c9/0xf30
  [<ffffffff81023c00>] ? __save_stack_trace+0x40/0xd0
  [<ffffffff81104b79>] do_filp_open+0x79/0xd0
  [<ffffffff81538219>] ? kmemleak_alloc+0x49/0xa0
  [<ffffffff810f4e44>] do_sys_open+0x114/0x1e0
  [<ffffffff810f4f29>] SyS_open+0x19/0x20
  [<ffffffff8153c2e0>] entry_SYSCALL_64_fastpath+0x13/0x94

This patch adds the proper error check in hot_remove_store() not to
call idr_remove() unconditionally.

Fixes: 17ec4cd98578 ("zram: don't call idr_remove() from zram_remove()")
Bugzilla: https://bugzilla.opensuse.org/show_bug.cgi?id=1010970
Link: http://lkml.kernel.org/r/20161121132140.12683-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Reviewed-by: David Disseldorp <ddiss@suse.de>
Reported-by: David Disseldorp <ddiss@suse.de>
Tested-by: David Disseldorp <ddiss@suse.de>
Acked-by: Minchan Kim <minchan@kernel.org>
Acked-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: <stable@vger.kernel.org>    [4.4+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/block/zram/zram_drv.c~zram-fix-unbalanced-idr-management-at-hot-removal drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-fix-unbalanced-idr-management-at-hot-removal
+++ a/drivers/block/zram/zram_drv.c
@@ -1403,7 +1403,8 @@ static ssize_t hot_remove_store(struct c
 	zram = idr_find(&zram_index_idr, dev_id);
 	if (zram) {
 		ret = zram_remove(zram);
-		idr_remove(&zram_index_idr, dev_id);
+		if (!ret)
+			idr_remove(&zram_index_idr, dev_id);
 	} else {
 		ret = -ENODEV;
 	}
_

Patches currently in -mm which might be from tiwai@suse.de are

zram-fix-unbalanced-idr-management-at-hot-removal.patch

