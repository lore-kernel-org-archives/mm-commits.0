From: akpm@linux-foundation.org
Subject: [folded-merged] memcg-deprecate-memoryforce_empty-knob-fix.patch
 removed from -mm tree
Date: Wed, 16 Jul 2014 13:45:05 -0700
Message-ID: <53c6e451.VmjHB4wXRondm0Y0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qg0-f73.google.com ([209.85.192.73]:52684 "EHLO
	mail-qg0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084AbaGPUpH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Jul 2014 16:45:07 -0400
Received: by mail-qg0-f73.google.com with SMTP id q107so67472qgd.0
        for <mm-commits@vger.kernel.org>; Wed, 16 Jul 2014 13:45:06 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hannes@cmpxchg.org, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg-deprecate-memoryforce_empty-knob-fix
has been removed from the -mm tree.  Its filename was
     memcg-deprecate-memoryforce_empty-knob-fix.patch

This patch was dropped because it was folded into memcg-deprecate-memoryforce_empty-knob.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: memcg-deprecate-memoryforce_empty-knob-fix

- s/pr_info/pr_info_once/
- fix garbled printk text

Cc: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroups/memory.txt |    2 +-
 mm/memcontrol.c                  |    8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff -puN Documentation/cgroups/memory.txt~memcg-deprecate-memoryforce_empty-knob-fix Documentation/cgroups/memory.txt
--- a/Documentation/cgroups/memory.txt~memcg-deprecate-memoryforce_empty-knob-fix
+++ a/Documentation/cgroups/memory.txt
@@ -474,7 +474,7 @@ About use_hierarchy, see Section 6.
   memory.kmem.usage_in_bytes == memory.usage_in_bytes.
 
   Please note that this knob is considered deprecated and will be removed
-  in future.
+  in the future.
 
   About use_hierarchy, see Section 6.
 
diff -puN mm/memcontrol.c~memcg-deprecate-memoryforce_empty-knob-fix mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-deprecate-memoryforce_empty-knob-fix
+++ a/mm/memcontrol.c
@@ -4086,10 +4086,10 @@ static ssize_t mem_cgroup_force_empty_wr
 
 	if (mem_cgroup_is_root(memcg))
 		return -EINVAL;
-	pr_info("%s (%d): memory.force_empty is deprecated and will be removed.",
-			current->comm, task_pid_nr(current));
-	pr_cont(" Let us know if you know if it needed in your usecase at");
-	pr_cont(" linux-mm@kvack.org\n");
+	pr_info_once("%s (%d): memory.force_empty is deprecated and will be "
+		     "removed.  Let us know if it is needed in your usecase at "
+		     "linux-mm@kvack.org\n",
+		     current->comm, task_pid_nr(current));
 	return mem_cgroup_force_empty(memcg) ?: nbytes;
 }
 
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
linux-next-git-rejects.patch
drivers-gpio-gpio-zevioc-fix-build.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix.patch
memcg-deprecate-memoryforce_empty-knob.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

