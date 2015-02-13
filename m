From: akpm@linux-foundation.org
Subject: [merged] zram-check-bd_openers-instead-bd_holders.patch removed
 from -mm tree
Date: Fri, 13 Feb 2015 12:21:21 -0800
Message-ID: <54de5cc1.QXbi28sooAAWqtFC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48961 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753254AbbBMUVW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Feb 2015 15:21:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, jmarchan@redhat.com, ngupta@vflare.org, opensource.ganesh@gmail.com, sergey.senozhatsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: check bd_openers instead of bd_holders
has been removed from the -mm tree.  Its filename was
     zram-check-bd_openers-instead-bd_holders.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: zram: check bd_openers instead of bd_holders

bd_holders is increased only when user open the device file as FMODE_EXCL
so if something opens zram0 as !FMODE_EXCL and request I/O while another
user reset zram0, we can see following warning.

[   30.683449] zram0: detected capacity change from 0 to 64424509440
[   33.736869] Buffer I/O error on dev zram0, logical block 180823, lost async page write
[   33.738814] Buffer I/O error on dev zram0, logical block 180824, lost async page write
[   33.740654] Buffer I/O error on dev zram0, logical block 180825, lost async page write
[   33.742551] Buffer I/O error on dev zram0, logical block 180826, lost async page write
[   33.744153] Buffer I/O error on dev zram0, logical block 180827, lost async page write
[   33.745807] Buffer I/O error on dev zram0, logical block 180828, lost async page write
[   33.747419] Buffer I/O error on dev zram0, logical block 180829, lost async page write
[   33.749060] Buffer I/O error on dev zram0, logical block 180830, lost async page write
[   33.750687] Buffer I/O error on dev zram0, logical block 180831, lost async page write
[   33.752286] Buffer I/O error on dev zram0, logical block 180832, lost async page write
[   33.811590] ------------[ cut here ]------------
[   33.812038] WARNING: CPU: 11 PID: 1996 at fs/block_dev.c:57 __blkdev_put+0x1d7/0x210()
[   33.812817] Modules linked in:
[   33.813142] CPU: 11 PID: 1996 Comm: dd Not tainted 3.19.0-rc6-next-20150202+ #1125
[   33.813837] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
[   33.814525]  ffffffff81801a2d ffff880061e77db8 ffffffff815b848e 0000000000000001
[   33.815196]  0000000000000000 ffff880061e77df8 ffffffff8104de2a 0000000000000000
[   33.815867]  ffff88005da287f0 ffff88005da28680 ffff88005da28770 ffff88005da28698
[   33.816536] Call Trace:
[   33.816817]  [<ffffffff815b848e>] dump_stack+0x45/0x57
[   33.817304]  [<ffffffff8104de2a>] warn_slowpath_common+0x8a/0xc0
[   33.817829]  [<ffffffff8104df1a>] warn_slowpath_null+0x1a/0x20
[   33.818331]  [<ffffffff811b60b7>] __blkdev_put+0x1d7/0x210
[   33.818797]  [<ffffffff811b69c0>] blkdev_put+0x50/0x130
[   33.819244]  [<ffffffff811b6b55>] blkdev_close+0x25/0x30
[   33.819723]  [<ffffffff8118079f>] __fput+0xdf/0x1e0
[   33.820140]  [<ffffffff811808ee>] ____fput+0xe/0x10
[   33.820576]  [<ffffffff81068e07>] task_work_run+0xa7/0xe0
[   33.821151]  [<ffffffff81002b89>] do_notify_resume+0x49/0x60
[   33.821721]  [<ffffffff815bf09d>] int_signal+0x12/0x17
[   33.822228] ---[ end trace 274fbbc5664827d2 ]---

The warning comes from bdev_write_node in blkdev_put path.

tatic void bdev_write_inode(struct inode *inode)
{
        spin_lock(&inode->i_lock);
        while (inode->i_state & I_DIRTY) {
                spin_unlock(&inode->i_lock);
                WARN_ON_ONCE(write_inode_now(inode, true)); <========= here.
                spin_lock(&inode->i_lock);
        }
        spin_unlock(&inode->i_lock);
}

The reason is dd process encounters I/O fails due to sudden block device
disappear so in filemap_check_errors in __writeback_single_inode returns
-EIO.

If we check bd_openers instead of bd_holders, we could address the
problem.  When I see the brd, it already have used it rather than
bd_holders so although I'm not a expert of block layer, it seems to be
better.

I can make following warning with below simple script.  In addition, I
added msleep(2000) below set_capacity(zram->disk, 0) after applying your
patch to make window huge(Kudos to Ganesh!)

script:

echo $((60<<30)) > /sys/block/zram0/disksize
setsid dd if=/dev/zero of=/dev/zram0 &
sleep 1
setsid echo 1 > /sys/block/zram0/reset

Signed-off-by: Minchan Kim <minchan@kernel.org>
Acked-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Jerome Marchand <jmarchan@redhat.com>
Cc: Ganesh Mahendran <opensource.ganesh@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/block/zram/zram_drv.c~zram-check-bd_openers-instead-bd_holders drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-check-bd_openers-instead-bd_holders
+++ a/drivers/block/zram/zram_drv.c
@@ -810,7 +810,7 @@ static ssize_t reset_store(struct device
 
 	mutex_lock(&bdev->bd_mutex);
 	/* Do not reset an active device! */
-	if (bdev->bd_holders) {
+	if (bdev->bd_openers) {
 		ret = -EBUSY;
 		goto out;
 	}
_

Patches currently in -mm which might be from minchan@kernel.org are

origin.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
mm-page_isolation-check-pfn-validity-before-access.patch
mm-support-madvisemadv_free.patch
mm-support-madvisemadv_free-fix.patch
x86-add-pmd_-for-thp.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp.patch
sparc-add-pmd_-for-thp-fix.patch
powerpc-add-pmd_-for-thp.patch
arm-add-pmd_mkclean-for-thp.patch
arm64-add-pmd_-for-thp.patch
mm-dont-split-thp-page-when-syscall-is-called.patch
mm-dont-split-thp-page-when-syscall-is-called-fix.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-2.patch

