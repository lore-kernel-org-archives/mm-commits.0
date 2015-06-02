From: akpm@linux-foundation.org
Subject: + zswap-runtime-enable-disable-fix.patch added to -mm tree
Date: Tue, 02 Jun 2015 15:53:56 -0700
Message-ID: <556e3404.0aJ54O9Mw7VPwMbp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46876 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668AbbFBWx5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Jun 2015 18:53:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ddstreet@ieee.org, sjennings@variantweb.net, mm-commits@vger.kernel.org


The patch titled
     Subject: zswap-runtime-enable-disable-fix
has been added to the -mm tree.  Its filename is
     zswap-runtime-enable-disable-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zswap-runtime-enable-disable-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zswap-runtime-enable-disable-fix.patch

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
Subject: zswap-runtime-enable-disable-fix

tweak documentation

Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Seth Jennings <sjennings@variantweb.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/zswap.txt |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff -puN Documentation/vm/zswap.txt~zswap-runtime-enable-disable-fix Documentation/vm/zswap.txt
--- a/Documentation/vm/zswap.txt~zswap-runtime-enable-disable-fix
+++ a/Documentation/vm/zswap.txt
@@ -27,21 +27,21 @@ device when the compressed pool reaches
 been identified in prior community discussions.
 
 Zswap is disabled by default but can be enabled at boot time by setting
-the "enabled" attribute to 1 at boot time. e.g. zswap.enabled=1. Zswap
+the "enabled" attribute to 1 at boot time. ie: zswap.enabled=1.  Zswap
 can also be enabled and disabled at runtime using the sysfs interface.
-An exmaple command to enable zswap at runtime, assuming sysfs is mounted
+An example command to enable zswap at runtime, assuming sysfs is mounted
 at /sys, is:
 
 echo 1 > /sys/modules/zswap/parameters/enabled
 
-When zswap is disabled at runtime, it will stop storing pages that are
-being swapped out. However, it will _not_ immediately write out or
-fault back into memory all of the pages stored in the compressed pool.
-The pages stored in zswap will continue to remain in the compressed pool
-until they are either invalidated or faulted back into memory. In order
-to force all pages out of the compressed pool, a swapoff on the swap
-device(s) will fault all swapped out pages, included those in the
-compressed pool, back into memory.
+When zswap is disabled at runtime it will stop storing pages that are
+being swapped out.  However, it will _not_ immediately write out or fault
+back into memory all of the pages stored in the compressed pool.  The
+pages stored in zswap will remain in the compressed pool until they are
+either invalidated or faulted back into memory.  In order to force all
+pages out of the compressed pool, a swapoff on the swap device(s) will
+fault back into memory all swapped out pages, including those in the
+compressed pool.
 
 Design:
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
ocfs2-reduce-object-size-of-mlog-uses-fix.patch
ocfs2-remove-__mlog_cpu_guess.patch
ocfs2-remove-__mlog_cpu_guess-fix.patch
ocfs2-fix-null-pointer-dereference-in-function-ocfs2_abort_trigger-fix.patch
mm.patch
mm-slab_common-support-the-slub_debug-boot-option-on-specific-object-size-fix.patch
slub-bulk-allocation-from-per-cpu-partial-pages-fix.patch
mm-fix-mprotect-behaviour-on-vm_locked-vmas-fix.patch
mm-new-mm-hook-framework.patch
mm-meminit-inline-some-helper-functions-fix.patch
mm-meminit-finish-initialisation-of-struct-pages-before-basic-setup-fix.patch
mm-memory-failure-introduce-get_hwpoison_page-for-consistent-refcount-handling-fix.patch
rmap-fix-theoretical-race-between-do_wp_page-and-shrink_active_list-fix.patch
rmap-fix-theoretical-race-between-do_wp_page-and-shrink_active_list-fix-fix.patch
userfaultfd-change-the-read-api-to-return-a-uffd_msg-fix-2.patch
userfaultfd-change-the-read-api-to-return-a-uffd_msg-fix-2-fix.patch
userfaultfd-avoid-mmap_sem-read-recursion-in-mcopy_atomic-fix.patch
fs-userfaultfdc-work-around-i386-build-error.patch
hugetlb-do-not-account-hugetlb-pages-as-nr_file_pages-fix.patch
mm-do-not-ignore-mapping_gfp_mask-in-page-cache-allocation-paths-checkpatch-fixes.patch
oom-split-out-forced-oom-killer-checkpatch-fixes.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-3.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix-fix.patch
zswap-runtime-enable-disable-fix.patch
prctl-more-prctlpr_set_mm_-checks-fix.patch
proc-fix-page_size-limit-of-proc-pid-cmdline-fix.patch
bitmap-remove-explicit-newline-handling-using-scnprintf-format-string-fix.patch
radix-tree-replace-preallocated-node-array-with-linked-list-fix.patch
init-do_mounts-add-create_dev-failure-log-fix.patch
rtc-omap-add-external-32k-clock-feature-fix.patch
devpts-if-initialization-failed-dont-crash-when-opening-dev-ptmx-fix.patch
ipcshm-move-bug_on-check-into-shm_lock-fix-2.patch
ipcshm-move-bug_on-check-into-shm_lock-fix.patch
scsi-resolve-sg-buffer-const-ness-issue-fix.patch
linux-next.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
drivers-block-nvme-corec-fix-build-with-gcc-444.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

