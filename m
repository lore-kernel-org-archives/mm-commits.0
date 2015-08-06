From: akpm@linux-foundation.org
Subject: +
 fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void-fix-fix.patch added to -mm tree
Date: Thu, 06 Aug 2015 12:31:22 -0700
Message-ID: <55c3b60a.lpF7GX9qO7/DEiUn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39272 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752390AbbHFTbY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Aug 2015 15:31:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, broonie@kernel.org, joe@perches.com, rostedt@goodmis.org, sfr@canb.auug.org.au, viro@ZenIV.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void-fix-fix
has been added to the -mm tree.  Its filename is
     fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void-fix-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void-fix-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void-fix-fix.patch

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
Subject: fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void-fix-fix

fix drivers/iommu/omap-iommu-debug.c for fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void.patch

Cc: Mark Brown <broonie@kernel.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Joe Perches <joe@perches.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/iommu/omap-iommu-debug.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/iommu/omap-iommu-debug.c~fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void-fix-fix drivers/iommu/omap-iommu-debug.c
--- a/drivers/iommu/omap-iommu-debug.c~fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void-fix-fix
+++ a/drivers/iommu/omap-iommu-debug.c
@@ -135,8 +135,9 @@ __dump_tlb_entries(struct omap_iommu *ob
 static ssize_t iotlb_dump_cr(struct omap_iommu *obj, struct cr_regs *cr,
 			     struct seq_file *s)
 {
-	return seq_printf(s, "%08x %08x %01x\n", cr->cam, cr->ram,
+	seq_printf(s, "%08x %08x %01x\n", cr->cam, cr->ram,
 			  (cr->cam & MMU_CAM_P) ? 1 : 0);
+	return 0;
 }
 
 static size_t omap_dump_tlb_entries(struct omap_iommu *obj, struct seq_file *s)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
kernel-kthreadc-kthread_create_on_node-clarify-documentation.patch
scripts-spellingtxt-adding-misspelled-word-for-check-fix.patch
ocfs2-sysfile-interfaces-for-online-file-check-fix.patch
watchdog-introduce-watchdog_suspend-and-watchdog_resume-fix.patch
watchdog-use-suspend-resume-interface-in-fixup_ht_bug-fix.patch
mm.patch
userfaultfd-change-the-read-api-to-return-a-uffd_msg-fix-2.patch
userfaultfd-change-the-read-api-to-return-a-uffd_msg-fix-2-fix.patch
userfaultfd-avoid-mmap_sem-read-recursion-in-mcopy_atomic-fix.patch
mm-mlock-refactor-mlock-munlock-and-munlockall-code-checkpatch-fixes.patch
mm-mlock-add-new-mlock-system-call-checkpatch-fixes.patch
mm-introduce-vm_lockonfault-checkpatch-fixes.patch
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
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
proc-add-kpageidle-file-fix-6-fix.patch
proc-export-idle-flag-via-kpageflags-fix.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-3.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix-fix.patch
zswap-dynamic-pool-creation-fix.patch
procfs-always-expose-proc-pid-map_files-and-make-it-readable-fix.patch
procfs-always-expose-proc-pid-map_files-and-make-it-readable-fix-fix.patch
fs-coda-fix-readlink-buffer-overflow-checkpatch-fixes.patch
kexec-split-kexec_load-syscall-from-kexec-core-code-checkpatch-fixes.patch
linux-next.patch
linux-next-rejects.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
net-netfilter-ipset-work-around-gcc-444-initializer-bug.patch
fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void-fix.patch
fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void-fix-fix.patch
mm-mpx-add-vm_flags_t-vm_flags-arg-to-do_mmap_pgoff-fix-checkpatch-fixes.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

