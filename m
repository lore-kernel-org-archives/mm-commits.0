From: akpm@linux-foundation.org
Subject: [folded-merged]
 convert-a-few-vm_bug_on-callers-to-vm_bug_on_vma-checkpatch-fixes.patch
 removed from -mm tree
Date: Thu, 09 Oct 2014 13:39:51 -0700
Message-ID: <5436f297.QUWUH4ioAMKqvHO3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35618 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210AbaJIUjv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Oct 2014 16:39:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, sasha.levin@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: convert-a-few-vm_bug_on-callers-to-vm_bug_on_vma-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     convert-a-few-vm_bug_on-callers-to-vm_bug_on_vma-checkpatch-fixes.patch

This patch was dropped because it was folded into convert-a-few-vm_bug_on-callers-to-vm_bug_on_vma.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: convert-a-few-vm_bug_on-callers-to-vm_bug_on_vma-checkpatch-fixes

WARNING: line over 80 characters
#194: FILE: mm/mremap.c:198:
+				VM_BUG_ON_VMA(vma->vm_file || !vma->anon_vma, vma);

total: 0 errors, 1 warnings, 160 lines checked

./patches/convert-a-few-vm_bug_on-callers-to-vm_bug_on_vma.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/mremap.c~convert-a-few-vm_bug_on-callers-to-vm_bug_on_vma-checkpatch-fixes mm/mremap.c
--- a/mm/mremap.c~convert-a-few-vm_bug_on-callers-to-vm_bug_on_vma-checkpatch-fixes
+++ a/mm/mremap.c
@@ -195,7 +195,8 @@ unsigned long move_page_tables(struct vm
 		if (pmd_trans_huge(*old_pmd)) {
 			int err = 0;
 			if (extent == HPAGE_PMD_SIZE) {
-				VM_BUG_ON_VMA(vma->vm_file || !vma->anon_vma, vma);
+				VM_BUG_ON_VMA(vma->vm_file || !vma->anon_vma,
+					      vma);
 				/* See comment in move_ptes() */
 				if (need_rmap_locks)
 					anon_vma_lock_write(vma->anon_vma);
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
mm-slab_common-move-kmem_cache-definition-to-internal-header.patch
memory-hotplug-add-sysfs-zones_online_to-attribute.patch
mm-compaction-defer-each-zone-individually-instead-of-preferred-zone.patch
mm-compaction-khugepaged-should-not-give-up-due-to-need_resched.patch
prctl-pr_set_mm-introduce-pr_set_mm_map-operation-v3.patch
include-linux-migrateh-remove-migratepage-define.patch
introduce-dump_vma.patch
convert-a-few-vm_bug_on-callers-to-vm_bug_on_vma.patch
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

