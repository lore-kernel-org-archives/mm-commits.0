From: akpm@linux-foundation.org
Subject: [merged] fs-ufs-re-arrange-the-code-a-bit-checkpatch-fixes.patch removed from -mm tree
Date: Tue, 17 Jul 2012 13:05:12 -0700
Message-ID: <20120717200513.597F220004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:57501 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756539Ab2GQUFO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Jul 2012 16:05:14 -0400
Received: by mail-ee0-f74.google.com with SMTP id b47so48473eek.1
        for <mm-commits@vger.kernel.org>; Tue, 17 Jul 2012 13:05:14 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, artem.bityutskiy@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs-ufs-re-arrange-the-code-a-bit-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     fs-ufs-re-arrange-the-code-a-bit-checkpatch-fixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: fs-ufs-re-arrange-the-code-a-bit-checkpatch-fixes

ERROR: "foo * bar" should be "foo *bar"
#27: FILE: fs/ufs/super.c:696:
+	struct ufs_sb_private_info * uspi;

ERROR: "foo * bar" should be "foo *bar"
#28: FILE: fs/ufs/super.c:697:
+	struct ufs_super_block_first * usb1;

ERROR: "foo * bar" should be "foo *bar"
#29: FILE: fs/ufs/super.c:698:
+	struct ufs_super_block_third * usb3;

ERROR: "foo * bar" should be "foo *bar"
#68: FILE: fs/ufs/super.c:737:
+	struct ufs_sb_info * sbi = UFS_SB(sb);

WARNING: space prohibited between function name and open parenthesis '('
#75: FILE: fs/ufs/super.c:744:
+	ubh_brelse_uspi (sbi->s_uspi);

WARNING: space prohibited between function name and open parenthesis '('
#76: FILE: fs/ufs/super.c:745:
+	kfree (sbi->s_uspi);

WARNING: space prohibited between function name and open parenthesis '('
#77: FILE: fs/ufs/super.c:746:
+	kfree (sbi);

total: 4 errors, 3 warnings, 129 lines checked

./patches/fs-ufs-re-arrange-the-code-a-bit.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ufs/super.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN fs/ufs/super.c~fs-ufs-re-arrange-the-code-a-bit-checkpatch-fixes fs/ufs/super.c
--- a/fs/ufs/super.c~fs-ufs-re-arrange-the-code-a-bit-checkpatch-fixes
+++ a/fs/ufs/super.c
@@ -693,9 +693,9 @@ static void ufs_put_super_internal(struc
 
 static int ufs_sync_fs(struct super_block *sb, int wait)
 {
-	struct ufs_sb_private_info * uspi;
-	struct ufs_super_block_first * usb1;
-	struct ufs_super_block_third * usb3;
+	struct ufs_sb_private_info *uspi;
+	struct ufs_super_block_first *usb1;
+	struct ufs_super_block_third *usb3;
 	unsigned flags;
 
 	lock_ufs(sb);
@@ -734,16 +734,16 @@ static void ufs_write_super(struct super
 
 static void ufs_put_super(struct super_block *sb)
 {
-	struct ufs_sb_info * sbi = UFS_SB(sb);
+	struct ufs_sb_info *sbi = UFS_SB(sb);
 
 	UFSD("ENTER\n");
 
 	if (!(sb->s_flags & MS_RDONLY))
 		ufs_put_super_internal(sb);
 
-	ubh_brelse_uspi (sbi->s_uspi);
-	kfree (sbi->s_uspi);
-	kfree (sbi);
+	ubh_brelse_uspi(sbi->s_uspi);
+	kfree(sbi->s_uspi);
+	kfree(sbi);
 	sb->s_fs_info = NULL;
 	UFSD("EXIT\n");
 	return;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
arch-x86-kernel-cpu-perf_event_intel_uncoreh-make-uncore_pmu_hrtimer_interval-64-bit.patch
sysfs-fail-dentry-revalidation-after-namespace-change-fix.patch
thermal-add-generic-cpufreq-cooling-implementation.patch
thermal-exynos5-add-exynos5-thermal-sensor-driver-support.patch
thermal-exynos-register-the-tmu-sensor-with-the-kernel-thermal-layer.patch
coredump-warn-about-unsafe-suid_dumpable-core_pattern-combo.patch
mm.patch
mm-make-vb_alloc-more-foolproof-fix.patch
mm-hugetlb-add-new-hugetlb-cgroup-fix.patch
mm-hugetlb-add-new-hugetlb-cgroup-fix-fix.patch
hugetlb-cgroup-add-hugetlb-cgroup-control-files-fix.patch
hugetlb-cgroup-add-hugetlb-cgroup-control-files-fix-fix.patch
mm-memblockc-memblock_double_array-cosmetic-cleanups.patch
memcg-make-mem_cgroup_force_empty_list-return-bool-fix.patch
mm-fadvise-dont-return-einval-when-filesystem-cannot-implement-fadvise-checkpatch-fixes.patch
memcg-rename-config-variables.patch
memcg-rename-config-variables-fix-fix.patch
mm-have-order-0-compaction-start-off-where-it-left-checkpatch-fixes.patch
mm-have-order-0-compaction-start-off-where-it-left-v3-typo.patch
memory-hotplug-fix-kswapd-looping-forever-problem-fix.patch
mm-memcg-fix-compaction-migration-failing-due-to-memcg-limits-checkpatch-fixes.patch
memcg-prevent-oom-with-too-many-dirty-pages.patch
avr32-mm-faultc-port-oom-changes-to-do_page_fault-fix.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume.patch
kernel-sysc-avoid-argv_freenull.patch
kmsg-dev-kmsg-properly-return-possible-copy_from_user-failure.patch
printk-add-generic-functions-to-find-kern_level-headers-fix.patch
btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout-fix.patch
btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout-checkpatch-fixes.patch
lib-vsprintfc-remind-people-to-update-documentation-printk-formatstxt-when-adding-printk-formats.patch
string-introduce-memweight-fix.patch
drivers-rtc-rtc-ab8500c-use-uie-emulation-checkpatch-fixes.patch
drivers-rtc-rtc-r9701c-check-that-r9701_set_datetime-succeeded.patch
kernel-kmodc-document-call_usermodehelper_fns-a-bit.patch
kmod-avoid-deadlock-from-recursive-kmod-call.patch
fork-use-vma_pages-to-simplify-the-code-fix.patch
revert-sched-fix-fork-error-path-to-not-crash.patch
ipc-use-kconfig-options-for-__arch_want_ipc_parse_version.patch
fs-cachefiles-add-support-for-large-files-in-filesystem-caching-fix.patch
include-linux-aioh-cpp-c-conversions.patch
fault-injection-add-selftests-for-cpu-and-memory-hotplug.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

