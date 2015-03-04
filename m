From: akpm@linux-foundation.org
Subject: + zram-add-dynamic-device-add-remove-functionality-fix.patch
 added to -mm tree
Date: Wed, 04 Mar 2015 14:14:07 -0800
Message-ID: <54f783af.0ylZUTswo1gRI290%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33485 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752246AbbCDWOI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Mar 2015 17:14:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, minchan@kernel.org, ngupta@vflare.org, sergey.senozhatsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zram-add-dynamic-device-add-remove-functionality-fix
has been added to the -mm tree.  Its filename is
     zram-add-dynamic-device-add-remove-functionality-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zram-add-dynamic-device-add-remove-functionality-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zram-add-dynamic-device-add-remove-functionality-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -1220,8 +1220,10 @@ static int zram_control(int cmd, const c
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
@@ -1234,10 +1236,12 @@ static int zram_control(int cmd, const c
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

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
mm-fix-anon_vma-degree-underflow-in-anon_vma-endless-growing-prevention.patch
mm.patch
mm-cma-release-trigger-checkpatch-fixes.patch
mm-cma-allocation-trigger-fix.patch
mm-compaction-enhance-compaction-finish-condition-fix.patch
page_writeback-cleanup-mess-around-cancel_dirty_page-checkpatch-fixes.patch
mm-hide-per-cpu-lists-in-output-of-show_mem-fix.patch
mm-clarify-__gfp_nofail-deprecation-status-checkpatch-fixes.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
zram-add-dynamic-device-add-remove-functionality-fix.patch
zram-introduce-automatic-device_id-generation-fix.patch
kernel-conditionally-support-non-root-users-groups-and-capabilities-checkpatch-fixes.patch
lib-vsprintf-add-%pcnr-format-specifiers-for-clocks-fix.patch
lib-find__bit-reimplementation-fix.patch
binfmt_misc-simplify-entry_status-fix.patch
rtc-add-abracon-abx80x-driver-fix.patch
fs-fat-remove-unnecessary-includes-fix.patch
kconfig-use-macros-which-are-already-defined-fix.patch
linux-next.patch
lib-kconfig-fix-up-have_arch_bitreverse-help-text.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

