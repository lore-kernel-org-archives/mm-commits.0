From: akpm@linux-foundation.org
Subject: - vmalloc-show-vmalloced-areas-via-proc-vmallocinfo-fix-2.patch removed from -mm tree
Date: Sun, 27 Apr 2008 23:53:52 -0700
Message-ID: <200804280653.m3S6rqSb012683@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47842 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761882AbYD1Gyf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 02:54:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, arjan@infradead.org, clameter@sgi.com, hugh@veritas.com, nickpiggin@yahoo.com.au, mm-commits@vger.kernel.org


The patch titled
     vmalloc-show-vmalloced-areas-via-proc-vmallocinfo-fix-2
has been removed from the -mm tree.  Its filename was
     vmalloc-show-vmalloced-areas-via-proc-vmallocinfo-fix-2.patch

This patch was dropped because it was folded into vmalloc-show-vmalloced-areas-via-proc-vmallocinfo.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmalloc-show-vmalloced-areas-via-proc-vmallocinfo-fix-2
From: Andrew Morton <akpm@linux-foundation.org>

Fix CONFIG_MMU=n build (vmalloc_op undefined)

Cc: Arjan van de Ven <arjan@infradead.org>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/proc_misc.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN fs/proc/proc_misc.c~vmalloc-show-vmalloced-areas-via-proc-vmallocinfo-fix-2 fs/proc/proc_misc.c
--- a/fs/proc/proc_misc.c~vmalloc-show-vmalloced-areas-via-proc-vmallocinfo-fix-2
+++ a/fs/proc/proc_misc.c
@@ -456,6 +456,7 @@ static const struct file_operations proc
 #endif
 #endif
 
+#ifdef CONFIG_MMU
 static int vmalloc_open(struct inode *inode, struct file *file)
 {
 	return seq_open(file, &vmalloc_op);
@@ -467,6 +468,7 @@ static const struct file_operations proc
 	.llseek		= seq_lseek,
 	.release	= seq_release,
 };
+#endif
 
 static int show_stat(struct seq_file *p, void *v)
 {
@@ -881,7 +883,9 @@ void __init proc_misc_init(void)
 	create_seq_entry("slab_allocators", 0 ,&proc_slabstats_operations);
 #endif
 #endif
+#ifdef CONFIG_MMU
 	proc_create("vmallocinfo", S_IRUSR, NULL, &proc_vmalloc_operations);
+#endif
 	create_seq_entry("buddyinfo",S_IRUGO, &fragmentation_file_operations);
 	create_seq_entry("pagetypeinfo", S_IRUGO, &pagetypeinfo_file_ops);
 	create_seq_entry("vmstat",S_IRUGO, &proc_vmstat_file_operations);
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
vmalloc-show-vmalloced-areas-via-proc-vmallocinfo-fix-2.patch
vmallocinfo-add-caller-information-checkpatch-fixes.patch
page_mapping-add-ifdef-around-reference-to-swapper_space.patch
smaps-account-swap-entries-sneak-in-a-coding-style-fix.patch
mm-introduce-pte_special-pte-bit-fix.patch
hugetlb-vmstat-events-for-huge-page-allocations-cleanup.patch
mempolicy-use-struct-mempolicy-pointer-in-shmem_sb_info-fix.patch
mempolicy-use-struct-mempolicy-pointer-in-shmem_sb_info-fix-fix.patch
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

