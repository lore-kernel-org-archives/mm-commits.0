From: akpm@linux-foundation.org
Subject: [merged]
 revert-cpumask-dont-perform-while-loop-in-cpumask_next_and.patch removed
 from -mm tree
Date: Tue, 23 Jun 2015 11:21:46 -0700
Message-ID: <5589a3ba.aoYfksQ5aqlJ1q2M%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57132 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932543AbbFWSVr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 23 Jun 2015 14:21:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, amirv@mellanox.com, davem@davemloft.net, peterz@infradead.org, sergey.senozhatsky@gmail.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: revert "cpumask: don't perform while loop in cpumask_next_and()"
has been removed from the -mm tree.  Its filename was
     revert-cpumask-dont-perform-while-loop-in-cpumask_next_and.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: revert "cpumask: don't perform while loop in cpumask_next_and()"

Revert

: commit 534b483a86e6b96f1b5cc03bbe4b696f3daead6d
: Author: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
: Date:   Thu Apr 16 12:48:04 2015 -0700
: 
:     cpumask: don't perform while loop in cpumask_next_and()

This was a minor optimization, but it puts a `struct cpumask' on the
stack, which consumes too much stack space.

Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Reported-by: Peter Zijlstra <peterz@infradead.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Amir Vadai <amirv@mellanox.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/cpumask.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff -puN lib/cpumask.c~revert-cpumask-dont-perform-while-loop-in-cpumask_next_and lib/cpumask.c
--- a/lib/cpumask.c~revert-cpumask-dont-perform-while-loop-in-cpumask_next_and
+++ a/lib/cpumask.c
@@ -16,11 +16,10 @@
 int cpumask_next_and(int n, const struct cpumask *src1p,
 		     const struct cpumask *src2p)
 {
-	struct cpumask tmp;
-
-	if (cpumask_and(&tmp, src1p, src2p))
-		return cpumask_next(n, &tmp);
-	return nr_cpu_ids;
+	while ((n = cpumask_next(n, src1p)) < nr_cpu_ids)
+		if (cpumask_test_cpu(n, src2p))
+			break;
+	return n;
 }
 EXPORT_SYMBOL(cpumask_next_and);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
ocfs2-reduce-object-size-of-mlog-uses-fix.patch
ocfs2-remove-__mlog_cpu_guess.patch
ocfs2-remove-__mlog_cpu_guess-fix.patch
ocfs2-fix-null-pointer-dereference-in-function-ocfs2_abort_trigger-fix.patch
mm.patch
mm-slab_common-support-the-slub_debug-boot-option-on-specific-object-size-fix.patch
slab-infrastructure-for-bulk-object-allocation-and-freeing-v3-fix.patch
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
checkpatch-emit-an-error-when-theres-a-diff-in-a-changelog.patch
init-do_mounts-add-create_dev-failure-log-fix.patch
devpts-if-initialization-failed-dont-crash-when-opening-dev-ptmx-fix.patch
ipcshm-move-bug_on-check-into-shm_lock-fix.patch
scsi-resolve-sg-buffer-const-ness-issue-fix.patch
linux-next.patch
linux-next-rejects.patch
drivers-block-nvme-corec-fix-build-with-gcc-444.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
net-netfilter-ipset-work-around-gcc-444-initializer-bug.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

