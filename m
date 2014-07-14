From: akpm@linux-foundation.org
Subject: + mm-vmscan-clean-up-struct-scan_control-checkpatch-fixes.patch
 added to -mm tree
Date: Mon, 14 Jul 2014 12:57:48 -0700
Message-ID: <53c4363c.lQD4J3SOstfUwHc1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f201.google.com ([209.85.214.201]:59625 "EHLO
	mail-ob0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756975AbaGNT5t (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 14 Jul 2014 15:57:49 -0400
Received: by mail-ob0-f201.google.com with SMTP id nu7so963393obb.0
        for <mm-commits@vger.kernel.org>; Mon, 14 Jul 2014 12:57:48 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hannes@cmpxchg.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-vmscan-clean-up-struct-scan_control-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     mm-vmscan-clean-up-struct-scan_control-checkpatch-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmscan-clean-up-struct-scan_control-checkpatch-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscan-clean-up-struct-scan_control-checkpatch-fixes.patch

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
Subject: mm-vmscan-clean-up-struct-scan_control-checkpatch-fixes

ERROR: code indent should use tabs where possible
#268: FILE: mm/vmscan.c:2713:
+^I^I            (GFP_HIGHUSER_MOVABLE & ~GFP_RECLAIM_MASK),$

ERROR: code indent should use tabs where possible
#302: FILE: mm/vmscan.c:2754:
+^I^I            (GFP_HIGHUSER_MOVABLE & ~GFP_RECLAIM_MASK),$

ERROR: code indent should use tabs where possible
#369: FILE: mm/vmscan.c:3410:
+^I^I         MAY_SKIP_CONGESTION,$

total: 3 errors, 0 warnings, 340 lines checked

NOTE: whitespace errors detected, you may wish to use scripts/cleanpatch or
      scripts/cleanfile

./patches/mm-vmscan-clean-up-struct-scan_control.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/vmscan.c~mm-vmscan-clean-up-struct-scan_control-checkpatch-fixes mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-clean-up-struct-scan_control-checkpatch-fixes
+++ a/mm/vmscan.c
@@ -2710,7 +2710,7 @@ unsigned long mem_cgroup_shrink_node_zon
 	struct scan_control sc = {
 		.nr_to_reclaim = SWAP_CLUSTER_MAX,
 		.gfp_mask = (gfp_mask & GFP_RECLAIM_MASK) |
-		            (GFP_HIGHUSER_MOVABLE & ~GFP_RECLAIM_MASK),
+			    (GFP_HIGHUSER_MOVABLE & ~GFP_RECLAIM_MASK),
 		.target_mem_cgroup = memcg,
 		.flags = MAY_UNMAP,
 	};
@@ -2751,7 +2751,7 @@ unsigned long try_to_free_mem_cgroup_pag
 	struct scan_control sc = {
 		.nr_to_reclaim = SWAP_CLUSTER_MAX,
 		.gfp_mask = (gfp_mask & GFP_RECLAIM_MASK) |
-		            (GFP_HIGHUSER_MOVABLE & ~GFP_RECLAIM_MASK),
+			    (GFP_HIGHUSER_MOVABLE & ~GFP_RECLAIM_MASK),
 		.target_mem_cgroup = memcg,
 		.priority = DEF_PRIORITY,
 		.flags = MAY_UNMAP,
@@ -3407,7 +3407,7 @@ unsigned long shrink_all_memory(unsigned
 		.gfp_mask = GFP_HIGHUSER_MOVABLE,
 		.priority = DEF_PRIORITY,
 		.flags = MAY_WRITEPAGE | MAY_UNMAP | MAY_SWAP |
-		         MAY_SKIP_CONGESTION,
+			 MAY_SKIP_CONGESTION,
 	};
 	struct zonelist *zonelist = node_zonelist(numa_node_id(), sc.gfp_mask);
 	struct task_struct *p = current;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
maintainers-akpm-maintenance.patch
revert-fs-seq_file-fallback-to-vmalloc-allocation.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
kbuild-explain-stack-protector-strong-config-logic.patch
ocfs2-free-inode-when-i_count-becomes-zero-checkpatch-fixes.patch
mm.patch
slub-use-new-node-functions-checkpatch-fixes.patch
slab-use-get_node-and-kmem_cache_node-functions-fix-2.patch
slab-use-get_node-and-kmem_cache_node-functions-fix-2-fix.patch
slab-change-int-to-size_t-for-representing-allocation-size.patch
mm-page_allocc-unexport-alloc_pages_exact_nid.patch
dma-cma-support-arbitrary-bitmap-granularity-fix.patch
mm-vmscan-clean-up-struct-scan_control-checkpatch-fixes.patch
mm-vmallocc-add-a-schedule-point-to-vmalloc-fix.patch
include-linux-mmdebugh-add-vm_warn_once.patch
mm-catch-memory-commitment-underflow-fix.patch
mm-hugetlb-generalize-writes-to-nr_hugepages-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
mm-zpool-implement-common-zpool-api-to-zbud-zsmalloc-fix.patch
mm-zpool-prevent-zbud-zsmalloc-from-unloading-when-used-checkpatch-fixes.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
list-fix-order-of-arguments-for-hlist_add_after_rcu-checkpatch-fixes.patch
add-lib-globc-fix.patch
lib-list_sortc-convert-to-pr_foo.patch
lib-list_sortc-convert-to-pr_foo-fix.patch
checkpatch-add-test-for-commit-id-formatting-style-in-commit-log.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting-fix.patch
fs-isofs-logging-clean-up-fix.patch
proc-remove-proc_tty_ldisc-variable-fix.patch
kexec-implementation-of-new-syscall-kexec_file_load-checkpatch-fixes.patch
kexec-support-kexec-kdump-on-efi-systems-fix.patch
panic-add-taint_softlockup-fix.patch
linux-next.patch
drivers-gpio-gpio-zevioc-fix-build.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix.patch
memcg-deprecate-memoryforce_empty-knob-fix.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

