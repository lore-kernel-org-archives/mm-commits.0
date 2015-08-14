From: akpm@linux-foundation.org
Subject: + kexec-split-kexec_file-syscall-code-to-kexec_filec-fix-2.patch
 added to -mm tree
Date: Fri, 14 Aug 2015 13:25:24 -0700
Message-ID: <55ce4eb4.T1NmXNPkP2qdaE/L%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53891 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004AbbHNUZZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 14 Aug 2015 16:25:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dyoung@redhat.com, jwboyer@fedoraproject.org, vgoyal@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kexec-split-kexec_file-syscall-code-to-kexec_filec-fix-fix
has been added to the -mm tree.  Its filename is
     kexec-split-kexec_file-syscall-code-to-kexec_filec-fix-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kexec-split-kexec_file-syscall-code-to-kexec_filec-fix-2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kexec-split-kexec_file-syscall-code-to-kexec_filec-fix-2.patch

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
Subject: kexec-split-kexec_file-syscall-code-to-kexec_filec-fix-fix

kernel/kexec_file.c:126:1: sparse: symbol 'arch_kexec_apply_relocations' was not declared. Should it be static?

the various arch_kexec functions don't appear to be declared anywhere. 
Confused.

Cc: Dave Young <dyoung@redhat.com>
Cc: Josh Boyer <jwboyer@fedoraproject.org>
Cc: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kexec.h |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff -puN include/linux/kexec.h~kexec-split-kexec_file-syscall-code-to-kexec_filec-fix-2 include/linux/kexec.h
--- a/include/linux/kexec.h~kexec-split-kexec_file-syscall-code-to-kexec_filec-fix-2
+++ a/include/linux/kexec.h
@@ -318,6 +318,17 @@ int crash_shrink_memory(unsigned long ne
 size_t crash_get_memory_size(void);
 void crash_free_reserved_phys_range(unsigned long begin, unsigned long end);
 
+int __weak arch_kexec_kernel_image_probe(struct kimage *image, void *buf,
+					 unsigned long buf_len);
+void * __weak arch_kexec_kernel_image_load(struct kimage *image);
+void __weak arch_kimage_file_post_load_cleanup(struct kimage *image);
+int __weak arch_kexec_kernel_verify_sig(struct kimage *image, void *buf,
+					unsigned long buf_len);
+int __weak arch_kexec_apply_relocations_add(const Elf_Ehdr *ehdr,
+					Elf_Shdr *sechdrs, unsigned int relsec);
+int __weak arch_kexec_apply_relocations(const Elf_Ehdr *ehdr, Elf_Shdr *sechdrs,
+					unsigned int relsec);
+
 #else /* !CONFIG_KEXEC */
 struct pt_regs;
 struct task_struct;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
ipcsem-fix-use-after-free-on-ipc_rmid-after-a-task-using-same-semaphore-set-exits-fix.patch
mm-hwpoison-fix-panic-due-to-split-huge-zero-page-fix.patch
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
zswap-dynamic-pool-creation-fix.patch
procfs-always-expose-proc-pid-map_files-and-make-it-readable-fix.patch
procfs-always-expose-proc-pid-map_files-and-make-it-readable-fix-fix.patch
fs-coda-fix-readlink-buffer-overflow-checkpatch-fixes.patch
kexec-split-kexec_file-syscall-code-to-kexec_filec-fix.patch
kexec-split-kexec_file-syscall-code-to-kexec_filec-fix-2.patch
kexec-split-kexec_load-syscall-from-kexec-core-code-checkpatch-fixes.patch
align-crash_notes-allocation-to-make-it-be-inside-one-physical-page-fix.patch
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

