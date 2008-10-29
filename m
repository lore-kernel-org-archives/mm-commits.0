From: akpm@linux-foundation.org
Subject: - nfsd-fix-vm-overcommit-crash-checkpatch-fixes.patch removed from -mm tree
Date: Wed, 29 Oct 2008 12:59:03 -0700
Message-ID: <200810291959.m9TJx3Q4020936@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34776 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752974AbYJ2T7q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 29 Oct 2008 15:59:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, alan@redhat.com, hooanon05@yahoo.co.jp, jmorris@namei.org, mm-commits@vger.kernel.org


The patch titled
     nfsd-fix-vm-overcommit-crash-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     nfsd-fix-vm-overcommit-crash-checkpatch-fixes.patch

This patch was dropped because it was folded into nfsd-fix-vm-overcommit-crash.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: nfsd-fix-vm-overcommit-crash-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: spaces required around that ':' (ctx:VxW)
#75: FILE: mm/shmem.c:165:
+		security_vm_enough_memory_kern(VM_ACCT(size)): 0;
 		                                             ^

ERROR: spaces required around that ':' (ctx:VxW)
#84: FILE: mm/shmem.c:183:
+		0: security_vm_enough_memory_kern(VM_ACCT(PAGE_CACHE_SIZE));
 		 ^

WARNING: labels should not be indented
#84: FILE: mm/shmem.c:183:
+		0: security_vm_enough_memory_kern(VM_ACCT(PAGE_CACHE_SIZE));

total: 2 errors, 1 warnings, 64 lines checked

./patches/nfsd-fix-vm-overcommit-crash.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Alan Cox <alan@redhat.com>
Cc: James Morris <jmorris@namei.org>
Cc: Junjiro R. Okajima <hooanon05@yahoo.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN mm/shmem.c~nfsd-fix-vm-overcommit-crash-checkpatch-fixes mm/shmem.c
--- a/mm/shmem.c~nfsd-fix-vm-overcommit-crash-checkpatch-fixes
+++ a/mm/shmem.c
@@ -161,8 +161,8 @@ static inline struct shmem_sb_info *SHME
  */
 static inline int shmem_acct_size(unsigned long flags, loff_t size)
 {
-	return (flags & VM_ACCOUNT)?
-		security_vm_enough_memory_kern(VM_ACCT(size)): 0;
+	return (flags & VM_ACCOUNT) ?
+		security_vm_enough_memory_kern(VM_ACCT(size)) : 0;
 }
 
 static inline void shmem_unacct_size(unsigned long flags, loff_t size)
@@ -179,8 +179,8 @@ static inline void shmem_unacct_size(uns
  */
 static inline int shmem_acct_block(unsigned long flags)
 {
-	return (flags & VM_ACCOUNT)?
-		0: security_vm_enough_memory_kern(VM_ACCT(PAGE_CACHE_SIZE));
+	return (flags & VM_ACCOUNT) ?
+		0 : security_vm_enough_memory_kern(VM_ACCT(PAGE_CACHE_SIZE));
 }
 
 static inline void shmem_unacct_blocks(unsigned long flags, long pages)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

epoll-avoid-double-inserts-in-case-of-efault-checkpatch-fixes.patch
freezer_cg-use-thaw_process-in-unfreeze_cgroup.patch
fs-remove-prepare_write-commit_write.patch
mm-write_cache_pages-writepage-error-fix.patch
nfsd-fix-vm-overcommit-crash.patch
nfsd-fix-vm-overcommit-crash-checkpatch-fixes.patch
nfsd-fix-vm-overcommit-crash-fix.patch
mm-remove-the-might_sleep-from-lock_page.patch
linux-next.patch
linux-next-rejects.patch
next-remove-localversion.patch
arch-x86-kernel-setupc-omit-dmi_low_memory_corruption-when-it-is-unneeded.patch
tick-schedc-suppress-needless-timer-reprogramming.patch
linux-timexh-cleanup-for-userspace-checkpatch-fixes.patch
drivers-input-touchscreen-ucb1400_tsc-needs-gpio.patch
kbuild-prevent-modpost-from-looking-for-a-cmd-file-for-a-static-library-linked-into-a-module.patch
led-driver-for-leds-on-pcengines-alix2-and-alix3-boards.patch
drivers-rtc-rtc-ds1286c-is-borked.patch
drivers-rtc-rtc-m48t35c-is-borked-too.patch
drivers-net-sfc-falconc-fix-min-warnings.patch
pci-uninline-pci_ioremap_bar.patch
autofs4-collect-version-check-return-checkpatch-fixes.patch
maintainers-make-ioat-easier-to-find.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
mm-cleanup-to-make-remove_memory-arch-neutral-fix-fix.patch
mm-invoke-oom-killer-from-page-fault-fix.patch
mm-invoke-oom-killer-from-page-fault-fix-fix-2.patch
fs-truncate-blocks-outside-i_size-after-generic_file_direct_write-error-fix.patch
init-properly-placing-noinline-keyword.patch
spi_gpio-driver-cleanups.patch
rtc-rtc-wm8350-add-support-for-wm8350-rtc.patch
rtc-basic-implementation-of-epson-rx-8581-i2c-real-time-clock-fix.patch
quota-move-quotaio_vh-from-include-linux-to-fs-fix.patch
quota-move-quotaio_vh-from-include-linux-to-fs-fix-2.patch
quota-convert-union-in-mem_dqinfo-to-a-pointer-cleanup.patch
quota-support-64-bit-quota-format-fix.patch
quota-support-64-bit-quota-format-fix-2.patch
memcg-introduce-charge-commit-cancel-style-of-functions-fix.patch
w1-export-w1_read_8-function-checkpatch-fixes.patch
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

