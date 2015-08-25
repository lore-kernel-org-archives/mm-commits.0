From: akpm@linux-foundation.org
Subject: [folded-merged]
 memory-hot-addedthe-memory-can-not-been-added-to-movable-zone-fix.patch
 removed from -mm tree
Date: Tue, 25 Aug 2015 13:57:52 -0700
Message-ID: <55dcd6d0.Kez7TMZWG+ruE/lM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36582 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632AbbHYU5w (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 25 Aug 2015 16:57:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, isimatu.yasuaki@jp.fujitsu.com, liuchangcheng@inspur.com, tangchen@cn.fujitsu.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: memory-hot-addedthe-memory-can-not-been-added-to-movable-zone-fix
has been removed from the -mm tree.  Its filename was
     memory-hot-addedthe-memory-can-not-been-added-to-movable-zone-fix.patch

This patch was dropped because it was folded into memory-hot-addedthe-memory-can-not-been-added-to-movable-zone.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: memory-hot-addedthe-memory-can-not-been-added-to-movable-zone-fix

cleanup

Cc: Changsheng Liu <liuchangcheng@inspur.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Tang Chen <tangchen@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff -puN mm/memory_hotplug.c~memory-hot-addedthe-memory-can-not-been-added-to-movable-zone-fix mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~memory-hot-addedthe-memory-can-not-been-added-to-movable-zone-fix
+++ a/mm/memory_hotplug.c
@@ -1181,13 +1181,9 @@ static int should_add_memory_movable(int
 	pg_data_t *pgdat = NODE_DATA(nid);
 	struct zone *movable_zone = pgdat->node_zones + ZONE_MOVABLE;
 
-	if (zone_is_empty(movable_zone)) {
-	#ifdef CONFIG_MOVABLE_NODE
-		return 1;
-	#else
-		return 0;
-	#endif
-	}
+	if (zone_is_empty(movable_zone))
+		return IS_ENABLED(CONFIG_MOVABLE_NODE);
+
 	if (movable_zone->zone_start_pfn <= start_pfn)
 		return 1;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
net-netfilter-ipset-work-around-gcc-444-initializer-bug.patch
memhp-add-hot-added-memory-ranges-to-memblock-before-allocate-node_data-for-a-node-checkpatch-fixes.patch
kernel-kthreadc-kthread_create_on_node-clarify-documentation.patch
scripts-spellingtxt-adding-misspelled-word-for-check-fix.patch
fs-create-and-use-seq_show_option-for-escaping-fix.patch
watchdog-introduce-watchdog_suspend-and-watchdog_resume-fix.patch
watchdog-use-suspend-resume-interface-in-fixup_ht_bug-fix.patch
mm.patch
userfaultfd-change-the-read-api-to-return-a-uffd_msg-fix-2-fix.patch
userfaultfd-avoid-mmap_sem-read-recursion-in-mcopy_atomic-fix.patch
genalloc-add-name-arg-to-gen_pool_get-and-devm_gen_pool_create-fix.patch
genalloc-add-support-of-multiple-gen_pools-per-device-fix.patch
mm-make-gup-handle-pfn-mapping-unless-foll_get-is-requested-fix.patch
dax-revert-userfaultfd-change.patch
thp-prepare-for-dax-huge-pages-fix.patch
pagemap-add-mmap-exclusive-bit-for-marking-pages-mapped-only-here-fix.patch
pagemap-update-documentation-fix.patch
mm-show-proportional-swap-share-of-the-mapping-fix.patch
mm-improve-__gfp_noretry-comment-based-on-implementation-fix.patch
memcg-export-struct-mem_cgroup-fix.patch
memcg-export-struct-mem_cgroup-fix-2.patch
mm-hugetlb-add-cache-of-descriptors-to-resv_map-for-region_add-fix.patch
mm-srcu-ify-shrinkers-fix-fix.patch
x86-use-generic-early-mem-copy-fix.patch
mm-mmap-simplify-the-failure-return-working-flow-fix.patch
memory-hot-addedthe-memory-can-not-been-added-to-movable-zone.patch
zswap-dynamic-pool-creation-fix.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
proc-add-kpageidle-file-fix-6-fix.patch
proc-add-kpageidle-file-fix-6-fix-2-fix.patch
proc-export-idle-flag-via-kpageflags-fix.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-3.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
procfs-always-expose-proc-pid-map_files-and-make-it-readable-fix.patch
procfs-always-expose-proc-pid-map_files-and-make-it-readable-fix-fix.patch
fs-coda-fix-readlink-buffer-overflow-checkpatch-fixes.patch
kexec-split-kexec_file-syscall-code-to-kexec_filec-fix.patch
kexec-split-kexec_file-syscall-code-to-kexec_filec-fix-2.patch
kexec-split-kexec_file-syscall-code-to-kexec_filec-fix-2-fix.patch
kexec-split-kexec_file-syscall-code-to-kexec_filec-fix-2-fix-fix.patch
kexec-split-kexec_load-syscall-from-kexec-core-code-checkpatch-fixes.patch
align-crash_notes-allocation-to-make-it-be-inside-one-physical-page-fix.patch
linux-next-rejects.patch
fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void-fix.patch
fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void-fix-fix.patch
mm-mpx-add-vm_flags_t-vm_flags-arg-to-do_mmap_pgoff-fix-checkpatch-fixes.patch
uaccess-reimplement-probe_kernel_address-using-probe_kernel_read.patch
uaccess-reimplement-probe_kernel_address-using-probe_kernel_read-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

