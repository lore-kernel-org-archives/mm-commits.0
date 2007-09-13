From: akpm@linux-foundation.org
Subject: + ufs-fix-sun-state-fix-mount-check-in-ufs_fill_super.patch added to -mm tree
Date: Thu, 13 Sep 2007 15:01:18 -0700
Message-ID: <200709132201.l8DM1Iru008052@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44377 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752645AbXIMWBe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Sep 2007 18:01:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: satyam@infradead.org, dushistov@mail.ru


The patch titled
     ufs: Fix mount check in ufs_fill_super()
has been added to the -mm tree.  Its filename is
     ufs-fix-sun-state-fix-mount-check-in-ufs_fill_super.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ufs: Fix mount check in ufs_fill_super()
From: Satyam Sharma <satyam@infradead.org>

The current code skips the check to verify whether the filesystem was
previously cleanly unmounted, if (flags & UFS_ST_MASK) == UFS_ST_44BSD or
UFS_ST_OLD.  This looks like an inadvertent bug that slipped in due to
parantheses in the compound conditional to me, especially given that
ufs_get_fs_state() handles the UFS_ST_44BSD case perfectly well.  So, let's
fix the compound condition appropriately.

Signed-off-by: Satyam Sharma <satyam@infradead.org>
Cc: Evgeniy Dushistov <dushistov@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ufs/super.c |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

diff -puN fs/ufs/super.c~ufs-fix-sun-state-fix-mount-check-in-ufs_fill_super fs/ufs/super.c
--- a/fs/ufs/super.c~ufs-fix-sun-state-fix-mount-check-in-ufs_fill_super
+++ a/fs/ufs/super.c
@@ -934,19 +934,20 @@ magic_found:
 		flags |=  UFS_ST_SUN;
 	}
 
-	sbi->s_flags = flags;/*after that line some functions use s_flags*/
+	/* Set sbi->s_flags here, used by ufs_get_fs_state() below */
+	sbi->s_flags = flags;
 	ufs_print_super_stuff(sb, usb1, usb2, usb3);
 
 	/*
 	 * Check, if file system was correctly unmounted.
 	 * If not, make it read only.
 	 */
-	if (((flags & UFS_ST_MASK) == UFS_ST_44BSD) ||
-	  ((flags & UFS_ST_MASK) == UFS_ST_OLD) ||
-	  (((flags & UFS_ST_MASK) == UFS_ST_SUN || 
-	    (flags & UFS_ST_MASK) == UFS_ST_SUNOS ||
-	  (flags & UFS_ST_MASK) == UFS_ST_SUNx86) && 
-	  (ufs_get_fs_state(sb, usb1, usb3) == (UFS_FSOK - fs32_to_cpu(sb, usb1->fs_time))))) {
+	if ((((flags & UFS_ST_MASK) == UFS_ST_44BSD)	||
+	     ((flags & UFS_ST_MASK) == UFS_ST_OLD)	||
+	     ((flags & UFS_ST_MASK) == UFS_ST_SUN)	||
+	     ((flags & UFS_ST_MASK) == UFS_ST_SUNOS)	||
+	     ((flags & UFS_ST_MASK) == UFS_ST_SUNx86))	&&
+	    (ufs_get_fs_state(sb, usb1, usb3) == (UFS_FSOK - fs32_to_cpu(sb, usb1->fs_time)))) {
 		switch(usb1->fs_clean) {
 		case UFS_FSCLEAN:
 			UFSD("fs is clean\n");
_

Patches currently in -mm which might be from satyam@infradead.org are

h8-300-fix-misnamed-config_blkdev_reserve_address-kconfig-variable.patch
cpufreq-mark-hotplug-notifier-callback-as-__cpuinit.patch
cpufreq-implement-config_cpu_freq-stub-for.patch
cpufreq_stats-misc-cpuinit-section-annotations.patch
drivers-char-nozomic-__devexit_p-usage-build-fix.patch
git-hwmon.patch
ia64-tree-wide-misc-__cpuinitdata-init-exit.patch
git-ieee1394.patch
ehca_irq-misc-cpuinit-section-annotations-and-ifdef-cleanups.patch
git-netdev-all.patch
3c59x-fix-uninitialized-variable-bug.patch
git-net.patch
net-sched-sch_cbqc-shut-up-uninitialized-variable.patch
git-s390.patch
sched-use-show_regs-to-improve-__schedule_bug-output.patch
use-mutex-instead-of-semaphore-in-the-onstream-scsi-tape-driver.patch
ll_rw_blk-blk_cpu_notifier-should-be-__cpuinitdata.patch
git-watchdog.patch
intel_cacheinfo-misc-section-annotation-fixes.patch
intel_cacheinfo-call-cache_add_dev-from-cache_sysfs_init.patch
therm_throtc-fix-section-mismatch.patch
i386-cpuid_count-fix-argument-signedness-warnings.patch
slub-slob-use-unlikely-for-kfreezero_or_null_ptr-check.patch
softlockup-improve-debug-output-fix.patch
argv_split-allow-argv_split-to-handle-null-pointer-in-argcp-parameter-gracefully.patch
ufs-fix-sun-state-fix-mount-check-in-ufs_fill_super.patch
remove-superfluous-definition-of-__setup_null_param-macro-and-broken-for-module-__setup_param.patch
i2o-fix-defined-but-not-used-build-warnings.patch
i2o-fix-defined-but-not-used-build-warnings-fix.patch
redefine-unregister_hotcpu_notifier-hotplug_cpu-stubs.patch
x86-msr-driver-misc-cpuinit-annotations.patch
i386-cpuid-misc-cpuinit-annotations.patch
