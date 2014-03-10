From: akpm@linux-foundation.org
Subject: + zram-propagate-error-to-user-fix.patch added to -mm tree
Date: Mon, 10 Mar 2014 13:16:38 -0700
Message-ID: <531e1da6.LIOFFB/3fpRK4ekJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40682 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752703AbaCJUQj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 10 Mar 2014 16:16:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sergey.senozhatsky@gmail.com, ngupta@vflare.org, minchan@kernel.org, jmarchan@redhat.com, akpm@linux-foundation.org

Subject: + zram-propagate-error-to-user-fix.patch added to -mm tree
To: akpm@linux-foundation.org,jmarchan@redhat.com,minchan@kernel.org,ngupta@vflare.org,sergey.senozhatsky@gmail.com
From: akpm@linux-foundation.org
Date: Mon, 10 Mar 2014 13:16:38 -0700


The patch titled
     Subject: zram-propagate-error-to-user-fix
has been added to the -mm tree.  Its filename is
     zram-propagate-error-to-user-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zram-propagate-error-to-user-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zram-propagate-error-to-user-fix.patch

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
Subject: zram-propagate-error-to-user-fix

don't return with the lock held, per Sergey

Cc: Jerome Marchand <jmarchan@redhat.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff -puN drivers/block/zram/zram_drv.c~zram-propagate-error-to-user-fix drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-propagate-error-to-user-fix
+++ a/drivers/block/zram/zram_drv.c
@@ -126,26 +126,28 @@ static ssize_t max_comp_streams_store(st
 {
 	int num;
 	struct zram *zram = dev_to_zram(dev);
+	int ret;
 
-	if (kstrtoint(buf, 0, &num))
-		goto out;
+	ret = kstrtoint(buf, 0, &num);
+	if (ret < 0)
+		return ret;
 	if (num < 1)
-		goto out;
+		return -EINVAL;
 
 	down_write(&zram->init_lock);
 	if (init_done(zram)) {
 		if (!zcomp_set_max_streams(zram->comp, num)) {
 			pr_info("Cannot change max compression streams\n");
-			goto out_unlock;
+			ret = -EINVAL;
+			goto out;
 		}
 	}
 
 	zram->max_comp_streams = num;
-	return len;
-out_unlock:
-	up_write(&zram->init_lock);
+	ret = len;
 out:
-	return -EINVAL;
+	up_write(&zram->init_lock);
+	return ret;
 }
 
 static ssize_t comp_algorithm_show(struct device *dev,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
maintainers-akpm-maintenance.patch
revert-kallsyms-fix-absolute-addresses-for-kaslr.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
ocfs2-add-dlm_recover_callback_support-in-sysfs-fix.patch
ocfs2-flock-drop-cross-node-lock-when-failed-locally-checkpatch-fixes.patch
ocfs2-do-not-return-dlm_migrate_response_mastery_ref-to-avoid-endlessloop-during-umount-checkpatch-fixes.patch
mm.patch
mm-hugetlb-improve-page-fault-scalability-fix.patch
mm-vmstat-fix-up-zone-state-accounting-fix.patch
mm-keep-page-cache-radix-tree-nodes-in-check-fix-fix.patch
mm-process_vm_accessc-mark-function-as-static-fix.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3-fix.patch
pagewalk-update-page-table-walker-core-fix-end-address-calculation-in-walk_page_range-fix.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry-fix-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
drop_caches-add-some-documentation-and-info-message.patch
mmnuma-reorganize-change_pmd_range-fix.patch
drivers-lguest-page_tablesc-rename-do_set_pte.patch
mm-add-debugfs-tunable-for-fault_around_order-checkpatch-fixes.patch
mm-per-thread-vma-caching.patch
mm-per-thread-vma-caching-fix-3.patch
mm-use-macros-from-compilerh-instead-of-__attribute__-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
zram-use-zcomp-compressing-backends-fix.patch
zram-return-error-valued-pointer-from-zcomp_create-fix.patch
zram-propagate-error-to-user-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
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
linux-next-git-rejects.patch
drivers-gpio-gpio-zevioc-fix-build.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

