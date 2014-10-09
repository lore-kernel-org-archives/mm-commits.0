From: akpm@linux-foundation.org
Subject: [folded-merged]
 fs-proc-task_mmuc-simplify-the-vma_stop-logic-checkpatch-fixes.patch
 removed from -mm tree
Date: Thu, 09 Oct 2014 13:28:24 -0700
Message-ID: <5436efe8.mIv3sqHthxaRsb4O%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35355 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008AbaJIU2Z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Oct 2014 16:28:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, oleg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs-proc-task_mmuc-simplify-the-vma_stop-logic-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     fs-proc-task_mmuc-simplify-the-vma_stop-logic-checkpatch-fixes.patch

This patch was dropped because it was folded into fs-proc-task_mmuc-simplify-the-vma_stop-logic.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: fs-proc-task_mmuc-simplify-the-vma_stop-logic-checkpatch-fixes

WARNING: Missing a blank line after declarations
#50: FILE: fs/proc/task_mmu.c:135:
+	struct mm_struct *mm = priv->mm;
+	release_task_mempolicy(priv);

ERROR: spaces required around that '?' (ctx:VxW)
#86: FILE: fs/proc/task_mmu.c:220:
+	next = (vma != tail_vma)? tail_vma: NULL;
 	                        ^

ERROR: spaces required around that ':' (ctx:VxW)
#86: FILE: fs/proc/task_mmu.c:220:
+	next = (vma != tail_vma)? tail_vma: NULL;
 	                                  ^

total: 2 errors, 1 warnings, 65 lines checked

./patches/fs-proc-task_mmuc-simplify-the-vma_stop-logic.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/proc/task_mmu.c~fs-proc-task_mmuc-simplify-the-vma_stop-logic-checkpatch-fixes fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~fs-proc-task_mmuc-simplify-the-vma_stop-logic-checkpatch-fixes
+++ a/fs/proc/task_mmu.c
@@ -132,6 +132,7 @@ static void release_task_mempolicy(struc
 static void vma_stop(struct proc_maps_private *priv)
 {
 	struct mm_struct *mm = priv->mm;
+
 	release_task_mempolicy(priv);
 	up_read(&mm->mmap_sem);
 	mmput(mm);
@@ -217,7 +218,7 @@ static void *m_next(struct seq_file *m,
 	if (vma && (vma != tail_vma) && vma->vm_next)
 		return vma->vm_next;
 
-	next = (vma != tail_vma)? tail_vma: NULL;
+	next = (vma != tail_vma) ? tail_vma : NULL;
 	if (!next)
 		vma_stop(priv);
 	return next;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
fs-notify-groupc-make-fsnotify_final_destroy_group-static.patch
fs-ocfs2-stack_userc-fix-typo-in-ocfs2_control_release.patch
fs-proc-task_mmuc-shift-mm_access-from-m_start-to-proc_maps_open.patch
fs-proc-task_mmuc-simplify-the-vma_stop-logic.patch
fs-proc-task_nommuc-change-maps_open-to-use-__seq_open_private-fix.patch
fs-proc-task_nommuc-shift-mm_access-from-m_start-to-proc_maps_open-checkpatch-fixes.patch
not-adding-modules-range-to-kcore-if-its-equal-to-vmcore-range-checkpatch-fixes.patch
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

