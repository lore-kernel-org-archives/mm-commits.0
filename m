From: akpm@linux-foundation.org
Subject: +
 mm-mlock-refactor-mlock-munlock-and-munlockall-code-checkpatch-fixes.patch
 added to -mm tree
Date: Tue, 21 Jul 2015 14:01:44 -0700
Message-ID: <55aeb338.xq6xlF8Ctmix9Ew1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41047 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755659AbbGUVBp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 21 Jul 2015 17:01:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, emunson@akamai.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-mlock-refactor-mlock-munlock-and-munlockall-code-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     mm-mlock-refactor-mlock-munlock-and-munlockall-code-checkpatch-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mlock-refactor-mlock-munlock-and-munlockall-code-checkpatch-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mlock-refactor-mlock-munlock-and-munlockall-code-checkpatch-fixes.patch

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
Subject: mm-mlock-refactor-mlock-munlock-and-munlockall-code-checkpatch-fixes

ERROR: "foo * bar" should be "foo *bar"
#244: FILE: mm/mlock.c:728:
+	struct vm_area_struct * vma, * prev = NULL;

ERROR: space prohibited after that '*' (ctx:WxW)
#244: FILE: mm/mlock.c:728:
+	struct vm_area_struct * vma, * prev = NULL;
 	                             ^

total: 2 errors, 0 warnings, 115 lines checked

./patches/mm-mlock-refactor-mlock-munlock-and-munlockall-code.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Eric B Munson <emunson@akamai.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mlock.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/mlock.c~mm-mlock-refactor-mlock-munlock-and-munlockall-code-checkpatch-fixes mm/mlock.c
--- a/mm/mlock.c~mm-mlock-refactor-mlock-munlock-and-munlockall-code-checkpatch-fixes
+++ a/mm/mlock.c
@@ -725,7 +725,7 @@ out:
 
 static int do_munlockall(int flags)
 {
-	struct vm_area_struct * vma, * prev = NULL;
+	struct vm_area_struct *vma, *prev = NULL;
 
 	if (flags & MCL_FUTURE)
 		current->mm->def_flags &= ~VM_LOCKED;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
kernel-kthreadc-kthread_create_on_node-clarify-documentation.patch
scripts-spellingtxt-adding-misspelled-word-for-check-fix.patch
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
mm-show-proportional-swap-share-of-the-mapping-fix.patch
mm-improve-__gfp_noretry-comment-based-on-implementation-fix.patch
memcg-export-struct-mem_cgroup-fix.patch
memcg-export-struct-mem_cgroup-fix-2.patch
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
linux-next.patch
linux-next-rejects.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
net-netfilter-ipset-work-around-gcc-444-initializer-bug.patch
fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

