From: akpm@linux-foundation.org
Subject: + mm-mmapc-clean-up-config_debug_vm_rb-checks.patch added to -mm
 tree
Date: Thu, 04 Sep 2014 13:33:12 -0700
Message-ID: <5408cc88.BEdC+eTNBNBlNSsw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55497 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755474AbaIDUdN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Sep 2014 16:33:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, sasha.levin@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap.c: clean up CONFIG_DEBUG_VM_RB checks
has been added to the -mm tree.  Its filename is
     mm-mmapc-clean-up-config_debug_vm_rb-checks.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mmapc-clean-up-config_debug_vm_rb-checks.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mmapc-clean-up-config_debug_vm_rb-checks.patch

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
Subject: mm/mmap.c: clean up CONFIG_DEBUG_VM_RB checks

- be consistent in printing the test which failed

- one message was actually wrong (a<b != b>a)

- don't print second bogus warning if browse_rb() failed

Cc: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff -puN mm/mmap.c~mm-mmapc-clean-up-config_debug_vm_rb-checks mm/mmap.c
--- a/mm/mmap.c~mm-mmapc-clean-up-config_debug_vm_rb-checks
+++ a/mm/mmap.c
@@ -368,16 +368,18 @@ static int browse_rb(struct rb_root *roo
 		struct vm_area_struct *vma;
 		vma = rb_entry(nd, struct vm_area_struct, vm_rb);
 		if (vma->vm_start < prev) {
-			pr_emerg("vm_start %lx prev %lx\n", vma->vm_start, prev);
+			pr_emerg("vm_start %lx < prev %lx\n",
+				  vma->vm_start, prev);
 			bug = 1;
 		}
 		if (vma->vm_start < pend) {
-			pr_emerg("vm_start %lx pend %lx\n", vma->vm_start, pend);
+			pr_emerg("vm_start %lx < pend %lx\n",
+				  vma->vm_start, pend);
 			bug = 1;
 		}
 		if (vma->vm_start > vma->vm_end) {
-			pr_emerg("vm_end %lx < vm_start %lx\n",
-				vma->vm_end, vma->vm_start);
+			pr_emerg("vm_start %lx > vm_end %lx\n",
+				  vma->vm_start, vma->vm_end);
 			bug = 1;
 		}
 		if (vma->rb_subtree_gap != vma_compute_subtree_gap(vma)) {
@@ -419,8 +421,10 @@ static void validate_mm(struct mm_struct
 	int i = 0;
 	unsigned long highest_address = 0;
 	struct vm_area_struct *vma = mm->mmap;
+
 	while (vma) {
 		struct anon_vma_chain *avc;
+
 		vma_lock_anon_vma(vma);
 		list_for_each_entry(avc, &vma->anon_vma_chain, same_vma)
 			anon_vma_interval_tree_verify(avc);
@@ -435,12 +439,13 @@ static void validate_mm(struct mm_struct
 	}
 	if (highest_address != mm->highest_vm_end) {
 		pr_emerg("mm->highest_vm_end %lx, found %lx\n",
-		       mm->highest_vm_end, highest_address);
+			  mm->highest_vm_end, highest_address);
 		bug = 1;
 	}
 	i = browse_rb(&mm->mm_rb);
 	if (i != mm->map_count) {
-		pr_emerg("map_count %d rb %d\n", mm->map_count, i);
+		if (i != -1)
+			pr_emerg("map_count %d rb %d\n", mm->map_count, i);
 		bug = 1;
 	}
 	BUG_ON(bug);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
maintainers-akpm-maintenance.patch
mem-hotplug-let-memblock-skip-the-hotpluggable-memory-regions-in-__next_mem_range-fix.patch
mm-slab_commonc-suppress-warning.patch
mem-hotplug-fix-boot-failed-in-case-all-the-nodes-are-hotpluggable-checkpatch-fixes.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
fs-ocfs2-stack_userc-fix-typo-in-ocfs2_control_release.patch
o2dlm-fix-null-pointer-dereference-in-o2dlm_blocking_ast_wrapper-checkpatch-fixes.patch
ocfs2-free-inode-when-i_count-becomes-zero.patch
mm.patch
fs-proc-task_mmuc-shift-mm_access-from-m_start-to-proc_maps_open-checkpatch-fixes.patch
fs-proc-task_mmuc-simplify-the-vma_stop-logic-checkpatch-fixes.patch
fs-proc-task_nommuc-shift-mm_access-from-m_start-to-proc_maps_open-checkpatch-fixes.patch
not-adding-modules-range-to-kcore-if-its-equal-to-vmcore-range-checkpatch-fixes.patch
mm-slab_common-move-kmem_cache-definition-to-internal-header-fix.patch
memory-hotplug-add-sysfs-zones_online_to-attribute-fix.patch
memory-hotplug-add-sysfs-zones_online_to-attribute-fix-2.patch
memory-hotplug-add-sysfs-zones_online_to-attribute-fix-3-fix.patch
mm-compaction-defer-each-zone-individually-instead-of-preferred-zone-fix.patch
mm-compaction-khugepaged-should-not-give-up-due-to-need_resched-fix.patch
prctl-pr_set_mm-introduce-pr_set_mm_map-operation-v4.patch
prctl-pr_set_mm-introduce-pr_set_mm_map-operation-v3-fix.patch
include-linux-migrateh-remove-migratepage-define.patch
mm-balloon_compaction-keep-ballooned-pages-away-from-normal-migration-path-fix.patch
mm-introduce-common-page-state-for-ballooned-memory-fix.patch
mm-balloon_compaction-use-common-page-ballooning-fix.patch
mm-balloon_compaction-general-cleanup-fix.patch
mm-balloon_compaction-general-cleanup-checkpatch-fixes.patch
introduce-dump_vma-fix.patch
convert-a-few-vm_bug_on-callers-to-vm_bug_on_vma-checkpatch-fixes.patch
mm-mmapc-clean-up-config_debug_vm_rb-checks.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
zram-zram-memory-size-limitation-fix.patch
zram-zram-memory-size-limitation-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
acct-eliminate-compile-warning-fix.patch
checkpatch-fix-spello.patch
x86-optimize-resource-lookups-for-ioremap-fix.patch
init-resolve-shadow-warnings-checkpatch-fixes.patch
linux-next.patch
drivers-gpio-gpio-zevioc-fix-build.patch
lib-string_helpers-introduce-string_escape_mem-fix.patch
lib-vsprintf-add-%pe-format-specifier-fix.patch
wireless-hostap-proc-print-properly-escaped-ssid-fix.patch
watchdog-control-hard-lockup-detection-default-fix.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
debugging-keep-track-of-page-owners.patch
debugging-keep-track-of-page-owners-fix.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

