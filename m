From: akpm@linux-foundation.org
Subject: [to-be-updated]
 zram-add-dynamic-device-add-remove-functionality-fix.patch removed from -mm tree
Date: Wed, 22 Apr 2015 13:30:09 -0700
Message-ID: <553804d1.pzW7tZsOBqupcao/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49678 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754115AbbDVUaK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Apr 2015 16:30:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, minchan@kernel.org, ngupta@vflare.org, sergey.senozhatsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zram-add-dynamic-device-add-remove-functionality-fix
has been removed from the -mm tree.  Its filename was
     zram-add-dynamic-device-add-remove-functionality-fix.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: zram-add-dynamic-device-add-remove-functionality-fix

fix comment layout

Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff -puN drivers/block/zram/zram_drv.c~zram-add-dynamic-device-add-remove-functionality-fix drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-add-dynamic-device-add-remove-functionality-fix
+++ a/drivers/block/zram/zram_drv.c
@@ -1283,8 +1283,10 @@ static int zram_control(int cmd, const c
 			break;
 		}
 
-		/* First, make ->disksize device attr RO, closing
-		 * ZRAM_CTL_REMOVE vs disksize_store() race window */
+		/*
+		 * First, make ->disksize device attr RO, closing
+		 * ZRAM_CTL_REMOVE vs disksize_store() race window
+		 */
 		ret = sysfs_chmod_file(&disk_to_dev(zram->disk)->kobj,
 				&dev_attr_disksize.attr, S_IRUGO);
 		if (ret)
@@ -1297,10 +1299,12 @@ static int zram_control(int cmd, const c
 			break;
 		}
 
-		/* If there are still device bd_openers, try to make ->disksize
+		/*
+		 * If there are still device bd_openers, try to make ->disksize
 		 * RW again and return. even if we fail to make ->disksize RW,
 		 * user still has RW ->reset attr. so it's possible to destroy
-		 * that device */
+		 * that device.
+		 */
 		err = sysfs_chmod_file(&disk_to_dev(zram->disk)->kobj,
 				&dev_attr_disksize.attr,
 				S_IWUSR | S_IRUGO);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
revert-zram-move-compact_store-to-sysfs-functions-area.patch
mm.patch
slub-bulk-allocation-from-per-cpu-partial-pages-fix.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix-fix.patch
zram-introduce-automatic-device_id-generation-fix.patch
rtc-omap-add-external-32k-clock-feature-fix.patch
linux-next.patch
linux-next-git-rejects.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

