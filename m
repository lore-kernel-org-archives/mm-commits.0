From: akpm@linux-foundation.org
Subject: - oprofile-change-cpu_buffer-from-array-to-per_cpu-variable-checkpatch-fixes.patch removed from -mm tree
Date: Sun, 27 Apr 2008 23:57:13 -0700
Message-ID: <200804280657.m3S6vDOB012855@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46378 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763297AbYD1G5q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 02:57:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, phil.el@wanadoo.fr, travis@sgi.com, mm-commits@vger.kernel.org


The patch titled
     oprofile-change-cpu_buffer-from-array-to-per_cpu-variable-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     oprofile-change-cpu_buffer-from-array-to-per_cpu-variable-checkpatch-fixes.patch

This patch was dropped because it was folded into oprofile-change-cpu_buffer-from-array-to-per_cpu-variable.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: oprofile-change-cpu_buffer-from-array-to-per_cpu-variable-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: "foo * bar" should be "foo *bar"
#24: FILE: drivers/oprofile/buffer_sync.c:497:
+	struct oprofile_cpu_buffer * cpu_buf = &per_cpu(cpu_buffer, cpu);

ERROR: "foo * bar" should be "foo *bar"
#54: FILE: drivers/oprofile/cpu_buffer.c:52:
+		struct oprofile_cpu_buffer * b = &per_cpu(cpu_buffer, i);

ERROR: "foo * bar" should be "foo *bar"
#63: FILE: drivers/oprofile/cpu_buffer.c:86:
+		struct oprofile_cpu_buffer * b = &per_cpu(cpu_buffer, i);

ERROR: "foo * bar" should be "foo *bar"
#72: FILE: drivers/oprofile/cpu_buffer.c:103:
+		struct oprofile_cpu_buffer * b = &per_cpu(cpu_buffer, i);

ERROR: "foo * bar" should be "foo *bar"
#81: FILE: drivers/oprofile/cpu_buffer.c:230:
+	struct oprofile_cpu_buffer * cpu_buf = &__get_cpu_var(cpu_buffer);

ERROR: "foo * bar" should be "foo *bar"
#90: FILE: drivers/oprofile/cpu_buffer.c:257:
+	struct oprofile_cpu_buffer * cpu_buf = &__get_cpu_var(cpu_buffer);

ERROR: "foo * bar" should be "foo *bar"
#97: FILE: drivers/oprofile/cpu_buffer.c:263:
+	struct oprofile_cpu_buffer * cpu_buf = &__get_cpu_var(cpu_buffer);

total: 7 errors, 0 warnings, 102 lines checked

./patches/oprofile-change-cpu_buffer-from-array-to-per_cpu-variable.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Mike Travis <travis@sgi.com>
Cc: Philippe Elie <phil.el@wanadoo.fr>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/oprofile/buffer_sync.c |    2 +-
 drivers/oprofile/cpu_buffer.c  |   12 ++++++------
 2 files changed, 7 insertions(+), 7 deletions(-)

diff -puN drivers/oprofile/buffer_sync.c~oprofile-change-cpu_buffer-from-array-to-per_cpu-variable-checkpatch-fixes drivers/oprofile/buffer_sync.c
--- a/drivers/oprofile/buffer_sync.c~oprofile-change-cpu_buffer-from-array-to-per_cpu-variable-checkpatch-fixes
+++ a/drivers/oprofile/buffer_sync.c
@@ -491,7 +491,7 @@ typedef enum {
  */
 void sync_buffer(int cpu)
 {
-	struct oprofile_cpu_buffer * cpu_buf = &per_cpu(cpu_buffer, cpu);
+	struct oprofile_cpu_buffer *cpu_buf = &per_cpu(cpu_buffer, cpu);
 	struct mm_struct *mm = NULL;
 	struct task_struct * new;
 	unsigned long cookie = 0;
diff -puN drivers/oprofile/cpu_buffer.c~oprofile-change-cpu_buffer-from-array-to-per_cpu-variable-checkpatch-fixes drivers/oprofile/cpu_buffer.c
--- a/drivers/oprofile/cpu_buffer.c~oprofile-change-cpu_buffer-from-array-to-per_cpu-variable-checkpatch-fixes
+++ a/drivers/oprofile/cpu_buffer.c
@@ -49,7 +49,7 @@ int alloc_cpu_buffers(void)
 	unsigned long buffer_size = fs_cpu_buffer_size;
  
 	for_each_online_cpu(i) {
-		struct oprofile_cpu_buffer * b = &per_cpu(cpu_buffer, i);
+		struct oprofile_cpu_buffer *b = &per_cpu(cpu_buffer, i);
  
 		b->buffer = vmalloc_node(sizeof(struct op_sample) * buffer_size,
 			cpu_to_node(i));
@@ -83,7 +83,7 @@ void start_cpu_work(void)
 	work_enabled = 1;
 
 	for_each_online_cpu(i) {
-		struct oprofile_cpu_buffer * b = &per_cpu(cpu_buffer, i);
+		struct oprofile_cpu_buffer *b = &per_cpu(cpu_buffer, i);
 
 		/*
 		 * Spread the work by 1 jiffy per cpu so they dont all
@@ -100,7 +100,7 @@ void end_cpu_work(void)
 	work_enabled = 0;
 
 	for_each_online_cpu(i) {
-		struct oprofile_cpu_buffer * b = &per_cpu(cpu_buffer, i);
+		struct oprofile_cpu_buffer *b = &per_cpu(cpu_buffer, i);
 
 		cancel_delayed_work(&b->work);
 	}
@@ -227,7 +227,7 @@ static void oprofile_end_trace(struct op
 void oprofile_add_ext_sample(unsigned long pc, struct pt_regs * const regs,
 				unsigned long event, int is_kernel)
 {
-	struct oprofile_cpu_buffer * cpu_buf = &__get_cpu_var(cpu_buffer);
+	struct oprofile_cpu_buffer *cpu_buf = &__get_cpu_var(cpu_buffer);
 
 	if (!backtrace_depth) {
 		log_sample(cpu_buf, pc, is_kernel, event);
@@ -254,13 +254,13 @@ void oprofile_add_sample(struct pt_regs 
 
 void oprofile_add_pc(unsigned long pc, int is_kernel, unsigned long event)
 {
-	struct oprofile_cpu_buffer * cpu_buf = &__get_cpu_var(cpu_buffer);
+	struct oprofile_cpu_buffer *cpu_buf = &__get_cpu_var(cpu_buffer);
 	log_sample(cpu_buf, pc, is_kernel, event);
 }
 
 void oprofile_add_trace(unsigned long pc)
 {
-	struct oprofile_cpu_buffer * cpu_buf = &__get_cpu_var(cpu_buffer);
+	struct oprofile_cpu_buffer *cpu_buf = &__get_cpu_var(cpu_buffer);
 
 	if (!cpu_buf->tracing)
 		return;
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

