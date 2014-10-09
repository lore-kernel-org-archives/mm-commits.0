From: akpm@linux-foundation.org
Subject: [folded-merged]
 not-adding-modules-range-to-kcore-if-its-equal-to-vmcore-range-checkpatch-fixes.patch removed from -mm tree
Date: Thu, 09 Oct 2014 13:29:46 -0700
Message-ID: <5436f03a.heOkyewKw6381LnT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35396 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064AbaJIU3r (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Oct 2014 16:29:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, bhe@redhat.com, paul.gortmaker@windriver.com, qiuxishi@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: not-adding-modules-range-to-kcore-if-its-equal-to-vmcore-range-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     not-adding-modules-range-to-kcore-if-its-equal-to-vmcore-range-checkpatch-fixes.patch

This patch was dropped because it was folded into not-adding-modules-range-to-kcore-if-its-equal-to-vmcore-range.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: not-adding-modules-range-to-kcore-if-its-equal-to-vmcore-range-checkpatch-fixes

ERROR: space prohibited after that open parenthesis '('
#34: FILE: fs/proc/kcore.c:613:
+	if ( (MODULES_VADDR != VMALLOC_START) &&

ERROR: space prohibited before that close parenthesis ')'
#35: FILE: fs/proc/kcore.c:614:
+		(MODULES_END != VMALLOC_END) ) {

total: 2 errors, 0 warnings, 12 lines checked

./patches/not-adding-modules-range-to-kcore-if-its-equal-to-vmcore-range.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Baoquan He <bhe@redhat.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Xishi Qiu <qiuxishi@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/kcore.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN fs/proc/kcore.c~not-adding-modules-range-to-kcore-if-its-equal-to-vmcore-range-checkpatch-fixes fs/proc/kcore.c
--- a/fs/proc/kcore.c~not-adding-modules-range-to-kcore-if-its-equal-to-vmcore-range-checkpatch-fixes
+++ a/fs/proc/kcore.c
@@ -610,8 +610,7 @@ static void __init proc_kcore_text_init(
 struct kcore_list kcore_modules;
 static void __init add_modules_range(void)
 {
-	if ( (MODULES_VADDR != VMALLOC_START) &&
-		(MODULES_END != VMALLOC_END) ) {
+	if (MODULES_VADDR != VMALLOC_START && MODULES_END != VMALLOC_END) {
 		kclist_add(&kcore_modules, (void *)MODULES_VADDR,
 			MODULES_END - MODULES_VADDR, KCORE_VMALLOC);
 	}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
fs-notify-groupc-make-fsnotify_final_destroy_group-static.patch
fs-ocfs2-stack_userc-fix-typo-in-ocfs2_control_release.patch
fs-proc-task_mmuc-shift-mm_access-from-m_start-to-proc_maps_open.patch
fs-proc-task_mmuc-simplify-the-vma_stop-logic.patch
fs-proc-task_nommuc-change-maps_open-to-use-__seq_open_private.patch
fs-proc-task_nommuc-shift-mm_access-from-m_start-to-proc_maps_open.patch
not-adding-modules-range-to-kcore-if-its-equal-to-vmcore-range.patch
mm-slab_commonc-suppress-warning.patch
mm-slab_common-move-kmem_cache-definition-to-internal-header-fix.patch
memory-hotplug-add-sysfs-zones_online_to-attribute-fix.patch
memory-hotplug-add-sysfs-zones_online_to-attribute-fix-2.patch
memory-hotplug-add-sysfs-zones_online_to-attribute-fix-3-fix.patch
mm-compaction-defer-each-zone-individually-instead-of-preferred-zone-fix.patch
mm-compaction-khugepaged-should-not-give-up-due-to-need_resched-fix.patch
prctl-pr_set_mm-introduce-pr_set_mm_map-operation-v4.patch
prctl-pr_set_mm-introduce-pr_set_mm_map-operation-v3-fix.patch
include-linux-migrateh-remove-migratepage-define.patch
introduce-dump_vma-fix.patch
convert-a-few-vm_bug_on-callers-to-vm_bug_on_vma-checkpatch-fixes.patch
mm-mmapc-clean-up-config_debug_vm_rb-checks.patch
mm-introduce-vm_bug_on_mm-checkpatch-fixes.patch
mm-debug-mm-introduce-vm_bug_on_mm-fix-fixpatch-fix.patch
mm-debugc-use-pr_emerg.patch
mm-ksm-use-pr_err-instead-of-printk-fix.patch
mm-introduce-a-general-rcu-get_user_pages_fast-fix.patch
arm64-mm-enable-rcu-fast_gup-checkpatch-fixes.patch
zram-zram-memory-size-limitation-fix.patch
zram-zram-memory-size-limitation-fix-fix.patch
acct-eliminate-compile-warning-fix.patch

