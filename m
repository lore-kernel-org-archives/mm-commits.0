From: akpm@linux-foundation.org
Subject: + fs-ufs-re-arrange-the-code-a-bit-checkpatch-fixes.patch added to -mm tree
Date: Thu, 12 Jul 2012 15:56:34 -0700
Message-ID: <20120712225635.4DA6B20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:42379 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162166Ab2GLW4h (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Jul 2012 18:56:37 -0400
Received: by fat25 with SMTP id 25so149178fat.1
        for <mm-commits@vger.kernel.org>; Thu, 12 Jul 2012 15:56:36 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, artem.bityutskiy@linux.intel.com


The patch titled
     Subject: fs-ufs-re-arrange-the-code-a-bit-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     fs-ufs-re-arrange-the-code-a-bit-checkpatch-fixes.patch

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
Subject: Subject: fs-ufs-re-arrange-the-code-a-bit-checkpatch-fixes

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
arch-x86-kernel-cpu-perf_event_intel_uncoreh-make-uncore_pmu_hrtimer_interval-64-bit.patch
sysfs-fail-dentry-revalidation-after-namespace-change-fix.patch
hfs-get-rid-of-hfs_sync_super-checkpatch-fixes.patch
coredump-warn-about-unsafe-suid_dumpable-core_pattern-combo.patch
mm.patch
mm-make-vb_alloc-more-foolproof-fix.patch
mm-hugetlb-add-new-hugetlb-cgroup-fix.patch
mm-hugetlb-add-new-hugetlb-cgroup-fix-fix.patch
hugetlb-cgroup-add-hugetlb-cgroup-control-files-fix.patch
hugetlb-cgroup-add-hugetlb-cgroup-control-files-fix-fix.patch
mm-memblockc-memblock_double_array-cosmetic-cleanups.patch
memcg-make-mem_cgroup_force_empty_list-return-bool-fix.patch
memcg-prevent-oom-with-too-many-dirty-pages.patch
mm-fadvise-dont-return-einval-when-filesystem-cannot-implement-fadvise-checkpatch-fixes.patch
memcg-rename-config-variables.patch
memcg-rename-config-variables-fix-fix.patch
mm-have-order-0-compaction-start-off-where-it-left-checkpatch-fixes.patch
mm-have-order-0-compaction-start-off-where-it-left-v3-typo.patch
memory-hotplug-fix-kswapd-looping-forever-problem-fix.patch
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
hfsplus-get-rid-of-write_super-checkpatch-fixes.patch
fs-ufs-re-arrange-the-code-a-bit-checkpatch-fixes.patch
kernel-kmodc-document-call_usermodehelper_fns-a-bit.patch
kmod-avoid-deadlock-from-recursive-kmod-call.patch
fork-use-vma_pages-to-simplify-the-code-fix.patch
revert-sched-fix-fork-error-path-to-not-crash.patch
fs-cachefiles-add-support-for-large-files-in-filesystem-caching-fix.patch
include-linux-aioh-cpp-c-conversions.patch
resource-make-sure-requested-range-intersects-root-range-fix.patch
fault-injection-add-selftests-for-cpu-and-memory-hotplug.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

