From: akpm@linux-foundation.org
Subject: + filesystem-freeze-implement-generic-freeze-feature-fix.patch added to -mm tree
Date: Thu, 30 Oct 2008 17:48:26 -0700
Message-ID: <200810310048.m9V0mQhA032621@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48948 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756514AbYJaAs2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 30 Oct 2008 20:48:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, t-sato@yk.jp.nec.com


The patch titled
     filesystem-freeze-implement-generic-freeze-feature-fix
has been added to the -mm tree.  Its filename is
     filesystem-freeze-implement-generic-freeze-feature-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: filesystem-freeze-implement-generic-freeze-feature-fix
From: Andrew Morton <akpm@linux-foundation.org>

Fix CONFIG_BLOCK=n.

Cc: Takashi Sato <t-sato@yk.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/buffer_head.h |    9 +++++++++
 1 file changed, 9 insertions(+)

diff -puN include/linux/buffer_head.h~filesystem-freeze-implement-generic-freeze-feature-fix include/linux/buffer_head.h
--- a/include/linux/buffer_head.h~filesystem-freeze-implement-generic-freeze-feature-fix
+++ a/include/linux/buffer_head.h
@@ -345,6 +345,15 @@ static inline int remove_inode_buffers(s
 static inline int sync_mapping_buffers(struct address_space *mapping) { return 0; }
 static inline void invalidate_bdev(struct block_device *bdev) {}
 
+static inline struct super_block *freeze_bdev(struct block_device *sb)
+{
+	return NULL;
+}
+
+static inline int thaw_bdev(struct block_device *bdev, struct super_block *sb)
+{
+	return 0;
+}
 
 #endif /* CONFIG_BLOCK */
 #endif /* _LINUX_BUFFER_HEAD_H */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

freezer_cg-use-thaw_process-in-unfreeze_cgroup.patch
fs-remove-prepare_write-commit_write.patch
nfsd-fix-vm-overcommit-crash.patch
autofs4-collect-version-check-return-checkpatch-fixes.patch
maintainers-make-ioat-easier-to-find.patch
mm-remove-the-might_sleep-from-lock_page.patch
linux-next.patch
linux-next-rejects.patch
next-remove-localversion.patch
arch-x86-kernel-setupc-omit-dmi_low_memory_corruption-when-it-is-unneeded.patch
tick-schedc-suppress-needless-timer-reprogramming.patch
linux-timexh-cleanup-for-userspace.patch
drivers-input-touchscreen-ucb1400_tsc-needs-gpio.patch
pci-uninline-pci_ioremap_bar.patch
cpusets-update-mems-allowed-in-page-allocator-fix.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
mm-invoke-oom-killer-from-page-fault-fix.patch
mm-invoke-oom-killer-from-page-fault-fix-fix-2.patch
mm-write_cache_pages-more-terminate-quickly.patch
init-properly-placing-noinline-keyword.patch
oops-handling-ensure-that-any-oops-is-flushed-to-the-mtdoops-console-fix.patch
spi_gpio-driver-cleanups.patch
rtc-rtc-wm8350-add-support-for-wm8350-rtc.patch
rtc-basic-implementation-of-epson-rx-8581-i2c-real-time-clock-fix.patch
quota-permit-separately-enabling-quota-accounting-and-enforcing-limits-fix.patch
quota-move-quotaio_vh-from-include-linux-to-fs-fix.patch
quota-move-quotaio_vh-from-include-linux-to-fs-fix-2.patch
quota-convert-union-in-mem_dqinfo-to-a-pointer-cleanup.patch
quota-support-64-bit-quota-format-fix.patch
quota-support-64-bit-quota-format-fix-2.patch
memcg-introduce-charge-commit-cancel-style-of-functions-fix.patch
w1-export-w1_read_8-function-checkpatch-fixes.patch
filesystem-freeze-implement-generic-freeze-feature-fix.patch
nilfs2-inode-operations-fix.patch
nilfs2-pathname-operations-fix.patch
nilfs2-super-block-operations-fix.patch
reiser4.patch
reiser4-tree_lock-fixes.patch
reiser4-tree_lock-fixes-fix.patch
reiser4-semaphore-fix.patch
slb-drop-kmem-cache-argument-from-constructor-reiser4.patch
reiser4-suid.patch
reiser4-track-upstream-changes.patch
reiser4-broke.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
profile-likely-unlikely-macros.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

