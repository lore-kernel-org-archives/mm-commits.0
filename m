From: akpm@linux-foundation.org
Subject: - mempolicy-use-struct-mempolicy-pointer-in-shmem_sb_info-fix-fix-fix.patch removed from -mm tree
Date: Sun, 27 Apr 2008 23:55:44 -0700
Message-ID: <200804280655.m3S6tiV9012740@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36677 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762992AbYD1G4d (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 02:56:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ak@suse.de, clameter@sgi.com, lee.schermerhorn@hp.com, mel@csn.ul.ie, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     mempolicy-use-struct-mempolicy-pointer-in-shmem_sb_info-fix-fix-fix
has been removed from the -mm tree.  Its filename was
     mempolicy-use-struct-mempolicy-pointer-in-shmem_sb_info-fix-fix-fix.patch

This patch was dropped because it was folded into mempolicy-use-struct-mempolicy-pointer-in-shmem_sb_info.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mempolicy-use-struct-mempolicy-pointer-in-shmem_sb_info-fix-fix-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Andi Kleen <ak@suse.de>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mempolicy.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN include/linux/mempolicy.h~mempolicy-use-struct-mempolicy-pointer-in-shmem_sb_info-fix-fix-fix include/linux/mempolicy.h
--- a/include/linux/mempolicy.h~mempolicy-use-struct-mempolicy-pointer-in-shmem_sb_info-fix-fix-fix
+++ a/include/linux/mempolicy.h
@@ -321,7 +321,8 @@ static inline void check_highest_zone(in
 }
 
 #ifdef CONFIG_TMPFS
-static inline int mpol_parse_str(char *str, struct mempolicy **mpol)
+static inline int mpol_parse_str(char *str, struct mempolicy **mpol,
+				int no_context)
 {
 	return 1;	/* error */
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
mempolicy-use-struct-mempolicy-pointer-in-shmem_sb_info-fix-fix-fix.patch
capabilities-implement-per-process-securebits-warning-fix.patch
lsm-introduce-inode_getsecid-and-ipc_getsecid-hooks-checkpatch-fixes.patch
lsm-audit-introduce-generic-audit-lsm-hooks-checkpatch-fixes.patch
selinux-use-new-audit-hooks-remove-redundant-exports-checkpatch-fixes.patch
audit-final-renamings-and-cleanup-checkpatch-fixes.patch
arch-alpha-kernel-trapsc-use-time_-macros-fix.patch
alpha-teach-the-compiler-that-bug-doesnt-return.patch
uart_get_baud_rate-stop-mangling-termios-fix.patch
drivers-acpi-thermalc-fix-build-with-config_dmi=n.patch
oprofile-change-cpu_buffer-from-array-to-per_cpu-variable-checkpatch-fixes.patch
vt-notifier-extension-for-accessibility-checkpatch-fixes.patch
kprobes-prevent-probing-of-preempt_schedule-fix.patch
kprobes-prevent-probing-of-preempt_schedule-checkpatch-fixes.patch
quota-various-style-cleanups-checkpatch-fixes.patch
quota-quota-core-changes-for-quotaon-on-remount-quota-ext3-make-ext3-handle-quotaon-on-remount-checkpatch-fixes.patch
quota-quota-core-changes-for-quotaon-on-remount-quota-ext4-make-ext4-handle-quotaon-on-remount-checkpatch-fixes.patch
quota-convert-stub-functions-from-macros-into-inlines.patch
gpiochip_reserve-fix.patch
fb-add-support-for-foreign-endianness-force-it-on.patch
fbcon-replace-mono_col-macro-with-static-inline-fix.patch
pm-gxfb-add-hook-to-pm-console-layer-that-allows-disabling-of-suspend-vt-switch-fix.patch
lxfb-add-power-management-functionality-fix.patch
drivers-video-uvesafbc-fix-error-path-memory-leak.patch
fb-convert-proc-fb-to-seq_file-interface-checkpatch-fixes.patch
drivers-video-w100fbc-avoid-a-couple-of-error-path-null-derefs.patch
drivers-md-use-time_before-time_before_eq-etc-checkpatch-fixes.patch
pnp-use-dev_printk-for-quirk-messages-fix.patch
ext2-retry-block-allocation-if-new-blocks-are-allocated-from-system-zone-comment-typo.patch
ext3-retry-block-allocation-if-new-blocks-are-allocated-from-system-zone-comment-typo.patch
fat_valid_media-remove-pointless-test.patch
documentation-build-source-files-in-documentation-sub-dir-disable.patch

