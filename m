From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-debug-mm-introduce-vm_bug_on_mm-fix-fixpatch-fix.patch removed from -mm
 tree
Date: Thu, 09 Oct 2014 13:42:52 -0700
Message-ID: <5436f34c.URjbux4gOHybSj8Y%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35659 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015AbaJIUmx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Oct 2014 16:42:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, Valdis.Kletnieks@vt.edu, davej@redhat.com, mhocko@suse.cz, sasha.levin@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-debug-mm-introduce-vm_bug_on_mm-fix-fixpatch-fix
has been removed from the -mm tree.  Its filename was
     mm-debug-mm-introduce-vm_bug_on_mm-fix-fixpatch-fix.patch

This patch was dropped because it was folded into mm-introduce-vm_bug_on_mm.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-debug-mm-introduce-vm_bug_on_mm-fix-fixpatch-fix

do strange things to avoid doing strange things for the comma separators

Cc: Dave Jones <davej@redhat.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff -puN mm/debug.c~mm-debug-mm-introduce-vm_bug_on_mm-fix-fixpatch-fix mm/debug.c
--- a/mm/debug.c~mm-debug-mm-introduce-vm_bug_on_mm-fix-fixpatch-fix
+++ a/mm/debug.c
@@ -197,7 +197,9 @@ void dump_mm(const struct mm_struct *mm)
 #if defined(CONFIG_NUMA_BALANCING) || defined(CONFIG_COMPACTION)
 		"tlb_flush_pending %d\n"
 #endif
-		, mm, mm->mmap, mm->vmacache_seqnum, mm->task_size,
+		"%s",	/* This is here to hold the comma */
+
+		mm, mm->mmap, mm->vmacache_seqnum, mm->task_size,
 #ifdef CONFIG_MMU
 		mm->get_unmapped_area,
 #endif
@@ -218,16 +220,17 @@ void dump_mm(const struct mm_struct *mm)
 #ifdef CONFIG_MEMCG
 		mm->owner,
 #endif
-		mm->exe_file
+		mm->exe_file,
 #ifdef CONFIG_MMU_NOTIFIER
-		, mm->mmu_notifier_mm
+		mm->mmu_notifier_mm,
 #endif
 #ifdef CONFIG_NUMA_BALANCING
-		, mm->numa_next_scan, mm->numa_scan_offset, mm->numa_scan_seq
+		mm->numa_next_scan, mm->numa_scan_offset, mm->numa_scan_seq,
 #endif
 #if defined(CONFIG_NUMA_BALANCING) || defined(CONFIG_COMPACTION)
-		, mm->tlb_flush_pending
+		mm->tlb_flush_pending,
 #endif
+		""		/* This is here to not have a comma! */
 		);
 
 		dump_flags(mm->def_flags, vmaflags_names,
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
mm-introduce-vm_bug_on_mm.patch
mm-debugc-use-pr_emerg.patch
mm-ksm-use-pr_err-instead-of-printk-fix.patch
mm-introduce-a-general-rcu-get_user_pages_fast-fix.patch
arm64-mm-enable-rcu-fast_gup-checkpatch-fixes.patch
zram-zram-memory-size-limitation-fix.patch
zram-zram-memory-size-limitation-fix-fix.patch
acct-eliminate-compile-warning-fix.patch

