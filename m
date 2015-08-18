From: akpm@linux-foundation.org
Subject: + mm-mmap-simplify-the-failure-return-working-flow-fix.patch
 added to -mm tree
Date: Tue, 18 Aug 2015 15:57:26 -0700
Message-ID: <55d3b856.yqbRBR0hVYaAXEY7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48556 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751504AbbHRW51 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Aug 2015 18:57:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, gang.chen.5i5j@gmail.com, xili_gchen_5257@hotmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-mmap-simplify-the-failure-return-working-flow-fix
has been added to the -mm tree.  Its filename is
     mm-mmap-simplify-the-failure-return-working-flow-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mmap-simplify-the-failure-return-working-flow-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mmap-simplify-the-failure-return-working-flow-fix.patch

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
Subject: mm-mmap-simplify-the-failure-return-working-flow-fix

Cc: Chen Gang <gang.chen.5i5j@gmail.com>
Cc: Chen Gang <xili_gchen_5257@hotmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN mm/mmap.c~mm-mmap-simplify-the-failure-return-working-flow-fix mm/mmap.c
--- a/mm/mmap.c~mm-mmap-simplify-the-failure-return-working-flow-fix
+++ a/mm/mmap.c
@@ -2952,7 +2952,7 @@ struct vm_area_struct *copy_vma(struct v
 	} else {
 		new_vma = kmem_cache_alloc(vm_area_cachep, GFP_KERNEL);
 		if (!new_vma)
-			return NULL;
+			goto out;
 		*new_vma = *vma;
 		new_vma->vm_start = addr;
 		new_vma->vm_end = addr + len;
@@ -2971,10 +2971,11 @@ struct vm_area_struct *copy_vma(struct v
 	}
 	return new_vma;
 
- out_free_mempol:
+out_free_mempol:
 	mpol_put(vma_policy(new_vma));
- out_free_vma:
+out_free_vma:
 	kmem_cache_free(vm_area_cachep, new_vma);
+out:
 	return NULL;
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
net-netfilter-ipset-work-around-gcc-444-initializer-bug.patch
mm-make-page-pfmemalloc-check-more-robust-fix.patch
kernel-kthreadc-kthread_create_on_node-clarify-documentation.patch
scripts-spellingtxt-adding-misspelled-word-for-check-fix.patch
ocfs2-sysfile-interfaces-for-online-file-check-fix.patch
fs-create-and-use-seq_show_option-for-escaping-fix.patch
watchdog-introduce-watchdog_suspend-and-watchdog_resume-fix.patch
watchdog-use-suspend-resume-interface-in-fixup_ht_bug-fix.patch
mm.patch
userfaultfd-change-the-read-api-to-return-a-uffd_msg-fix-2.patch
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
mm-hugetlb-proc-add-hugetlbpages-field-to-proc-pid-status-fix-2.patch
mm-mmap-simplify-the-failure-return-working-flow-fix.patch
zswap-dynamic-pool-creation-fix.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
proc-add-kpageidle-file-fix-6-fix.patch
proc-add-kpageidle-file-fix-6-fix-2-fix.patch
proc-export-idle-flag-via-kpageflags-fix.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-3.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix-fix.patch
procfs-always-expose-proc-pid-map_files-and-make-it-readable-fix.patch
procfs-always-expose-proc-pid-map_files-and-make-it-readable-fix-fix.patch
fs-coda-fix-readlink-buffer-overflow-checkpatch-fixes.patch
kexec-split-kexec_file-syscall-code-to-kexec_filec-fix.patch
kexec-split-kexec_file-syscall-code-to-kexec_filec-fix-2.patch
kexec-split-kexec_file-syscall-code-to-kexec_filec-fix-2-fix.patch
kexec-split-kexec_file-syscall-code-to-kexec_filec-fix-2-fix-fix.patch
kexec-split-kexec_load-syscall-from-kexec-core-code-checkpatch-fixes.patch
align-crash_notes-allocation-to-make-it-be-inside-one-physical-page-fix.patch
linux-next.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void-fix.patch
fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void-fix-fix.patch
mm-mpx-add-vm_flags_t-vm_flags-arg-to-do_mmap_pgoff-fix-checkpatch-fixes.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

