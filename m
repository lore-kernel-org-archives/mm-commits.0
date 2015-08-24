From: akpm@linux-foundation.org
Subject: +
 memhp-add-hot-added-memory-ranges-to-memblock-before-allocate-node_data-for-a-node-checkpatch-fixes.patch added to -mm tree
Date: Mon, 24 Aug 2015 12:37:39 -0700
Message-ID: <55db7283.R+0encGqUSMzZy7G%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34804 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179AbbHXThk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 24 Aug 2015 15:37:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, tangchen@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memhp-add-hot-added-memory-ranges-to-memblock-before-allocate-node_data-for-a-node-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     memhp-add-hot-added-memory-ranges-to-memblock-before-allocate-node_data-for-a-node-checkpatch-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memhp-add-hot-added-memory-ranges-to-memblock-before-allocate-node_data-for-a-node-checkpatch-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memhp-add-hot-added-memory-ranges-to-memblock-before-allocate-node_data-for-a-node-checkpatch-fixes.patch

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
Subject: memhp-add-hot-added-memory-ranges-to-memblock-before-allocate-node_data-for-a-node-checkpatch-fixes

WARNING: Possible unwrapped commit description (prefer a maximum 75 chars per line)
#16: 
|--> memblock_add_node(start, size, nid)    --------    Here, just too late.

WARNING: line over 80 characters
#54: FILE: mm/memory_hotplug.c:1252:
+	 * Add new range to memblock so that when hotadd_new_pgdat() is called to

WARNING: line over 80 characters
#56: FILE: mm/memory_hotplug.c:1254:
+	 * new range and calculate total pages correctly. The range will be remove

total: 0 errors, 3 warnings, 28 lines checked

./patches/memhp-add-hot-added-memory-ranges-to-memblock-before-allocate-node_data-for-a-node.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Tang Chen <tangchen@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN mm/memory_hotplug.c~memhp-add-hot-added-memory-ranges-to-memblock-before-allocate-node_data-for-a-node-checkpatch-fixes mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~memhp-add-hot-added-memory-ranges-to-memblock-before-allocate-node_data-for-a-node-checkpatch-fixes
+++ a/mm/memory_hotplug.c
@@ -1249,10 +1249,10 @@ int __ref add_memory(int nid, u64 start,
 	mem_hotplug_begin();
 
 	/*
-	 * Add new range to memblock so that when hotadd_new_pgdat() is called to
-	 * allocate new pgdat, get_pfn_range_for_nid() will be able to find this
-	 * new range and calculate total pages correctly. The range will be remove
-	 * at hot-remove time.
+	 * Add new range to memblock so that when hotadd_new_pgdat() is called
+	 * to allocate new pgdat, get_pfn_range_for_nid() will be able to find
+	 * this new range and calculate total pages correctly.  The range will
+	 * be removed at hot-remove time.
 	 */
 	memblock_add_node(start, size, nid);
 
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
memory-hot-addedthe-memory-can-not-been-added-to-movable-zone-fix.patch
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
schedh-dont-include-mm_typesh.patch
schedh-dont-include-mm_typesh-fix.patch
uaccess-reimplement-probe_kernel_address-using-probe_kernel_read.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

