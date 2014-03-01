From: akpm@linux-foundation.org
Subject: + zram-use-zcomp-compressing-backends-fix.patch added to -mm tree
Date: Fri, 28 Feb 2014 16:32:38 -0800
Message-ID: <53112aa6.RkN6COhQNSKhnrnV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52896 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752167AbaCAAcj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 28 Feb 2014 19:32:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sergey.senozhatsky@gmail.com, ngupta@vflare.org, minchan@kernel.org, jmarchan@redhat.com, akpm@linux-foundation.org

Subject: + zram-use-zcomp-compressing-backends-fix.patch added to -mm tree
To: akpm@linux-foundation.org,jmarchan@redhat.com,minchan@kernel.org,ngupta@vflare.org,sergey.senozhatsky@gmail.com
From: akpm@linux-foundation.org
Date: Fri, 28 Feb 2014 16:32:38 -0800


The patch titled
     Subject: zram-use-zcomp-compressing-backends-fix
has been added to the -mm tree.  Its filename is
     zram-use-zcomp-compressing-backends-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zram-use-zcomp-compressing-backends-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zram-use-zcomp-compressing-backends-fix.patch

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
Subject: zram-use-zcomp-compressing-backends-fix

resolve conflicts with zram-delete-zram_init_device-fix.patch

Cc: Jerome Marchand <jmarchan@redhat.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff -puN drivers/block/zram/zram_drv.c~zram-use-zcomp-compressing-backends-fix drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-use-zcomp-compressing-backends-fix
+++ a/drivers/block/zram/zram_drv.c
@@ -519,6 +519,7 @@ static ssize_t disksize_store(struct dev
 	u64 disksize;
 	struct zram_meta *meta;
 	struct zram *zram = dev_to_zram(dev);
+	int err;
 
 	disksize = memparse(buf, NULL);
 	if (!disksize)
@@ -531,18 +532,17 @@ static ssize_t disksize_store(struct dev
 
 	down_write(&zram->init_lock);
 	if (init_done(zram)) {
-		zram_meta_free(meta);
-		up_write(&zram->init_lock);
 		pr_info("Cannot change disksize for initialized device\n");
-		return -EBUSY;
+		err = -EBUSY;
+		goto out_free_meta;
 	}
 
 	zram->comp = zcomp_create(default_compressor);
 	if (!zram->comp) {
-		up_write(&zram->init_lock);
 		pr_info("Cannot initialise %s compressing backend\n",
 				default_compressor);
-		return -EINVAL;
+		err = -EINVAL;
+		goto out_free_meta;
 	}
 
 	zram->meta = meta;
@@ -551,6 +551,11 @@ static ssize_t disksize_store(struct dev
 	up_write(&zram->init_lock);
 
 	return len;
+
+out_free_meta:
+	up_write(&zram->init_lock);
+	zram_meta_free(meta);
+	return err;
 }
 
 static ssize_t reset_store(struct device *dev,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
maintainers-akpm-maintenance.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
ocfs2-add-dlm_recover_callback_support-in-sysfs-fix.patch
ocfs2-flock-drop-cross-node-lock-when-failed-locally-checkpatch-fixes.patch
mm.patch
mm-hugetlb-improve-page-fault-scalability-fix.patch
mm-vmstat-fix-up-zone-state-accounting-fix.patch
mm-keep-page-cache-radix-tree-nodes-in-check-fix-fix.patch
mm-process_vm_accessc-mark-function-as-static-fix.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v2-checkpatch-fixes.patch
pagewalk-update-page-table-walker-core-fix-end-address-calculation-in-walk_page_range-fix.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry-fix-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
drop_caches-add-some-documentation-and-info-message.patch
mmnuma-reorganize-change_pmd_range-fix.patch
mm-add-debugfs-tunable-for-fault_around_order-checkpatch-fixes.patch
zram-use-zcomp-compressing-backends-fix.patch
include-linux-syscallsh-add-sys32_quotactl-prototype-fix.patch
sys_sysfs-add-config_sysfs_syscall-fix.patch
kernel-groupsc-remove-return-value-of-set_groups-fix.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix-fix.patch
hfsplus-fix-concurrent-acess-of-alloc_blocks-fix.patch
hfsplus-fix-concurrent-acess-of-alloc_blocks-fix-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch
include-linux-crash_dumph-add-vmcore_cleanup-prototype-fix.patch
kernel-panicc-display-reason-at-end-pr_emerg-fix.patch
fault-injection-set-bounds-on-what-proc-self-make-it-fail-accepts-fix.patch
initramfs-debug-detected-compression-method-fix.patch
linux-next.patch
linux-next-rejects.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

