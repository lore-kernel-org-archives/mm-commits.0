From: akpm@linux-foundation.org
Subject: + fs-coda-fix-readlink-buffer-overflow-checkpatch-fixes.patch
 added to -mm tree
Date: Mon, 27 Jul 2015 16:04:32 -0700
Message-ID: <55b6b900.wmb9bn9TMEelvZ+a%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50009 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752739AbbG0XEd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 27 Jul 2015 19:04:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jaharkes@cs.cmu.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: fs-coda-fix-readlink-buffer-overflow-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     fs-coda-fix-readlink-buffer-overflow-checkpatch-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-coda-fix-readlink-buffer-overflow-checkpatch-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-coda-fix-readlink-buffer-overflow-checkpatch-fixes.patch

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
Subject: fs-coda-fix-readlink-buffer-overflow-checkpatch-fixes

ERROR: need consistent spacing around '+' (ctx:VxW)
#35: FILE: fs/coda/upcall.c:356:
+		     INSIZE(readlink), OUTSIZE(readlink)+ *length);
 		                                        ^

ERROR: space prohibited after that open parenthesis '('
#45: FILE: fs/coda/upcall.c:364:
+		if ( retlen >= *length )

ERROR: space prohibited before that close parenthesis ')'
#45: FILE: fs/coda/upcall.c:364:
+		if ( retlen >= *length )

total: 3 errors, 0 warnings, 18 lines checked

./patches/fs-coda-fix-readlink-buffer-overflow.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Jan Harkes <jaharkes@cs.cmu.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/coda/upcall.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/coda/upcall.c~fs-coda-fix-readlink-buffer-overflow-checkpatch-fixes fs/coda/upcall.c
--- a/fs/coda/upcall.c~fs-coda-fix-readlink-buffer-overflow-checkpatch-fixes
+++ a/fs/coda/upcall.c
@@ -361,7 +361,7 @@ int venus_readlink(struct super_block *s
 	error = coda_upcall(coda_vcp(sb), insize, &outsize, inp);
 	if (!error) {
 		retlen = outp->coda_readlink.count;
-		if ( retlen >= *length )
+		if (retlen >= *length)
 			retlen = *length - 1;
 		*length = retlen;
 		result =  (char *)outp + (long)outp->coda_readlink.data;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
kernel-kthreadc-kthread_create_on_node-clarify-documentation.patch
scripts-spellingtxt-adding-misspelled-word-for-check-fix.patch
ocfs2-sysfile-interfaces-for-online-file-check-fix.patch
mm.patch
userfaultfd-change-the-read-api-to-return-a-uffd_msg-fix-2.patch
userfaultfd-change-the-read-api-to-return-a-uffd_msg-fix-2-fix.patch
userfaultfd-avoid-mmap_sem-read-recursion-in-mcopy_atomic-fix.patch
mm-mlock-refactor-mlock-munlock-and-munlockall-code-checkpatch-fixes.patch
mm-gup-add-mm_lock_present-checkpatch-fixes.patch
mm-mlock-introduce-vm_lockonfault-and-add-mlock-flags-to-enable-it-v4-checkpatch-fixes.patch
mm-mmap-add-mmap-flag-to-request-vm_lockonfault-v4-fix.patch
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
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
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
kexec-split-kexec_load-syscall-from-kexec-core-code-checkpatch-fixes.patch
linux-next.patch
linux-next-rejects.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
net-netfilter-ipset-work-around-gcc-444-initializer-bug.patch
fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void-fix.patch
mm-mpx-add-vm_flags_t-vm_flags-arg-to-do_mmap_pgoff-fix-checkpatch-fixes.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

