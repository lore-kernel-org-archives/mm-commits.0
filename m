From: akpm@linux-foundation.org
Subject: - drivers-md-use-time_before-time_before_eq-etc-checkpatch-fixes.patch removed from -mm tree
Date: Mon, 28 Apr 2008 00:02:46 -0700
Message-ID: <200804280702.m3S72kY7013126@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48615 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763515AbYD1HC6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 03:02:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, julia@diku.dk, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     drivers-md-use-time_before-time_before_eq-etc-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     drivers-md-use-time_before-time_before_eq-etc-checkpatch-fixes.patch

This patch was dropped because it was folded into drivers-md-use-time_before-time_before_eq-etc.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers-md-use-time_before-time_before_eq-etc-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: space prohibited after that open parenthesis '('
#58: FILE: drivers/md/raid6algos.c:124:
+			while ( time_before(jiffies,

WARNING: line over 80 characters
#59: FILE: drivers/md/raid6algos.c:125:
+					    j1 + (1<<RAID6_TIME_JIFFIES_LG2)) ) {

ERROR: space prohibited before that close parenthesis ')'
#59: FILE: drivers/md/raid6algos.c:125:
+					    j1 + (1<<RAID6_TIME_JIFFIES_LG2)) ) {

total: 2 errors, 1 warnings, 9 lines checked

./patches/drivers-md-use-time_before-time_before_eq-etc.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Julia Lawall <julia@diku.dk>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/raid6algos.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/md/raid6algos.c~drivers-md-use-time_before-time_before_eq-etc-checkpatch-fixes drivers/md/raid6algos.c
--- a/drivers/md/raid6algos.c~drivers-md-use-time_before-time_before_eq-etc-checkpatch-fixes
+++ a/drivers/md/raid6algos.c
@@ -121,8 +121,8 @@ int __init raid6_select_algo(void)
 			j0 = jiffies;
 			while ( (j1 = jiffies) == j0 )
 				cpu_relax();
-			while ( time_before(jiffies,
-					    j1 + (1<<RAID6_TIME_JIFFIES_LG2)) ) {
+			while (time_before(jiffies,
+					    j1 + (1<<RAID6_TIME_JIFFIES_LG2))) {
 				(*algo)->gen_syndrome(disks, PAGE_SIZE, dptrs);
 				perf++;
 			}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
rtc-isl1208-new-style-conversion-and-minor-bug-fixes.patch
rtc-pcf8563-new-style-conversion.patch
rtc-x1205-new-style-conversion.patch
hotplug-memory-make-online_page-common.patch
remove-sparse-warning-for-mmzoneh.patch
fix-invalidate_inode_pages2_range-to-not-clear-ret.patch
mm-make-reserve_bootmem-can-crossed-the-nodes-checkpatch-fixes.patch
mm-make-early_pfn_to_nid-a-c-function.patch
vmalloc-show-vmalloced-areas-via-proc-vmallocinfo.patch
vmallocinfo-add-caller-information.patch
page_mapping-add-ifdef-around-reference-to-swapper_space.patch
smaps-account-swap-entries.patch
mm-introduce-pte_special-pte-bit.patch
hugetlb-vmstat-events-for-huge-page-allocations.patch
mempolicy-use-struct-mempolicy-pointer-in-shmem_sb_info.patch
capabilities-implement-per-process-securebits.patch
lsm-introduce-inode_getsecid-and-ipc_getsecid-hooks-checkpatch-fixes.patch
lsm-audit-introduce-generic-audit-lsm-hooks-checkpatch-fixes.patch
selinux-use-new-audit-hooks-remove-redundant-exports-checkpatch-fixes.patch
audit-final-renamings-and-cleanup-checkpatch-fixes.patch
arch-alpha-kernel-trapsc-use-time_-macros.patch
alpha-teach-the-compiler-that-bug-doesnt-return.patch
uart_get_baud_rate-stop-mangling-termios.patch
drivers-acpi-thermalc-fix-build-with-config_dmi=n.patch
oprofile-change-cpu_buffer-from-array-to-per_cpu-variable.patch
vt-notifier-extension-for-accessibility.patch
kprobes-prevent-probing-of-preempt_schedule.patch
quota-various-style-cleanups.patch
quota-quota-core-changes-for-quotaon-on-remount-quota-ext3-make-ext3-handle-quotaon-on-remount.patch
quota-quota-core-changes-for-quotaon-on-remount-quota-ext4-make-ext4-handle-quotaon-on-remount.patch
quota-convert-stub-functions-from-macros-into-inlines.patch
gpiochip_reserve.patch
fbcon-replace-mono_col-macro-with-static-inline.patch
pm-gxfb-add-hook-to-pm-console-layer-that-allows-disabling-of-suspend-vt-switch.patch
lxfb-add-power-management-functionality.patch
drivers-video-uvesafbc-fix-error-path-memory-leak.patch
fb-convert-proc-fb-to-seq_file-interface.patch
drivers-video-w100fbc-avoid-a-couple-of-error-path-null-derefs.patch
drivers-md-use-time_before-time_before_eq-etc.patch
drivers-md-use-time_before-time_before_eq-etc-checkpatch-fixes.patch
pnp-use-dev_printk-for-quirk-messages-fix.patch
ext2-retry-block-allocation-if-new-blocks-are-allocated-from-system-zone-comment-typo.patch
ext3-retry-block-allocation-if-new-blocks-are-allocated-from-system-zone-comment-typo.patch
fat_valid_media-remove-pointless-test.patch
documentation-build-source-files-in-documentation-sub-dir-disable.patch

