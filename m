From: akpm@linux-foundation.org
Subject: + git-nfs-server-cluster-locking-api-fixup.patch added to -mm tree
Date: Fri, 11 May 2007 22:30:06 -0700
Message-ID: <200705120530.l4C5U5nW002019@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:36306 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750930AbXELFaI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 12 May 2007 01:30:08 -0400
Received: from shell0.pdx.osdl.net (fw.osdl.org [65.172.181.6])
	by smtp1.linux-foundation.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with ESMTP id l4C5U6Zs024466
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Fri, 11 May 2007 22:30:07 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org


The patch titled
     git-nfs-server-cluster-locking-api-fixup
has been added to the -mm tree.  Its filename is
     git-nfs-server-cluster-locking-api-fixup.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: git-nfs-server-cluster-locking-api-fixup
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/locks.c |   54 ---------------------------------------------------
 1 file changed, 54 deletions(-)

diff -puN fs/locks.c~git-nfs-server-cluster-locking-api-fixup fs/locks.c
--- a/fs/locks.c~git-nfs-server-cluster-locking-api-fixup
+++ a/fs/locks.c
@@ -1598,59 +1598,6 @@ asmlinkage long sys_flock(unsigned int f
 	return error;
 }
 
-<<<<<<< HEAD/fs/locks.c
-/**
- * vfs_test_lock - test file byte range lock
- * @filp: The file to test lock for
- * @fl: The lock to test
- * @conf: Place to return a copy of the conflicting lock, if found
- *
- * Returns -ERRNO on failure.  Indicates presence of conflicting lock by
- * setting conf->fl_type to something other than F_UNLCK.
- */
-int vfs_test_lock(struct file *filp, struct file_lock *fl)
-{
-	if (filp->f_op && filp->f_op->lock)
-		return filp->f_op->lock(filp, F_GETLK, fl);
-	posix_test_lock(filp, fl);
-	return 0;
-}
-EXPORT_SYMBOL_GPL(vfs_test_lock);
-
-static int posix_lock_to_flock(struct flock *flock, struct file_lock *fl)
-{
-	flock->l_pid = fl->fl_pid;
-#if BITS_PER_LONG == 32
-	/*
-	 * Make sure we can represent the posix lock via
-	 * legacy 32bit flock.
-	 */
-	if (fl->fl_start > OFFT_OFFSET_MAX)
-		return -EOVERFLOW;
-	if (fl->fl_end != OFFSET_MAX && fl->fl_end > OFFT_OFFSET_MAX)
-		return -EOVERFLOW;
-#endif
-	flock->l_start = fl->fl_start;
-	flock->l_len = fl->fl_end == OFFSET_MAX ? 0 :
-		fl->fl_end - fl->fl_start + 1;
-	flock->l_whence = 0;
-	flock->l_type = fl->fl_type;
-	return 0;
-}
-
-#if BITS_PER_LONG == 32
-static void posix_lock_to_flock64(struct flock64 *flock, struct file_lock *fl)
-{
-	flock->l_pid = fl->fl_pid;
-	flock->l_start = fl->fl_start;
-	flock->l_len = fl->fl_end == OFFSET_MAX ? 0 :
-		fl->fl_end - fl->fl_start + 1;
-	flock->l_whence = 0;
-	flock->l_type = fl->fl_type;
-}
-#endif
-
-=======
 /**
  * vfs_test_lock - test file byte range lock
  * @filp: The file to test lock for
@@ -1701,7 +1648,6 @@ static void posix_lock_to_flock64(struct
 }
 #endif
 
->>>>>>> /fs/locks.c
 /* Report the first existing lock that would conflict with l.
  * This implements the F_GETLK command of fcntl().
  */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
ntfs-use-zero_user_page.patch
git-acpi-export-acpi_set_cstate_limit.patch
git-alsa.patch
git-alsa-fixup.patch
working-3d-dri-intel-agpko-resume-for-i815-chip-tidy.patch
git-arm.patch
git-avr32.patch
git-dvb-fixup.patch
cinergyt2-fix-file-release-handler.patch
i2c-add-driver-for-dallas-ds1682-elapsed-time-recorder.patch
git-gfs2-nmw.patch
git-hid-fixup.patch
git-ieee1394.patch
git-leds.patch
git-leds-fixup.patch
pata_acpi-restore-driver-vs-libata-clean-up-sff-init-mess-fix.patch
git-mips-fixup.patch
fix-race-condition-about-network-device-name-fix.patch
git-battery.patch
git-nfs-server-cluster-locking-api-fixup.patch
git-ocfs2.patch
git-parisc.patch
fix-gregkh-pci-pci-remove-the-broken-pci_multithread_probe-option.patch
git-pciseg.patch
scsi-fix-config_scsi_wait_scan=m.patch
git-block-fixup.patch
git-unionfs.patch
auerswald-fix-file-release-handler.patch
git-wireless.patch
git-wireless-fixup.patch
i386-add-support-for-picopower-irq-router.patch
x86_64-extract-helper-function-from-e820_register_active_regions.patch
mmconfig-x86_64-i386-insert-unclaimed-mmconfig-resources-fix.patch
xfs-clean-up-shrinker-games.patch
remove-slab_ctor_constructor-fix.patch
change-zonelist-order-v6-zonelist-fix.patch
lazy-freeing-of-memory-through-madv_free.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
group-short-lived-and-reclaimable-kernel-allocations-use-slab_account_reclaim-to-determine-when-__gfp_reclaimable-should-be-used-fix.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
mm-merge-nopfn-into-fault.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-add-proc-pid-pagemap-interface.patch
freezer-fix-kthread_create-vs-freezer-theoretical-race.patch
alpha-support-graphics-on-non-zero-pci-domains-fix.patch
cache-pipe-buf-page-address-for-non-highmem-arch.patch
use-write_trylock_irqsave-in-ptrace_attach-fix.patch
add-lzo1x-compression-support-to-the-kernel-fix.patch
use-no_pci_devices-in-pci-searchc.patch
introduce-boot-based-time-fix.patch
use-boot-based-time-for-process-start-time-and-boot-time-fix.patch
add-argv_split-fix.patch
add-common-orderly_poweroff-fix.patch
crc7-support-fix.patch
revoke-wire-up-i386-system-calls.patch
lguest-the-host-code.patch
reiser4.patch
integrity-new-hooks.patch
integrity-evm-as-an-integrity-service-provider.patch
integrity-ima-integrity_measure-support.patch
integrity-tpm-internal-kernel-interface.patch
w1-build-fix.patch
check_dirty_inode_list.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists.patch
