From: akpm@linux-foundation.org
Subject: [merged]
 kernel-kthreadc-kthread_create_on_node-clarify-documentation.patch removed
 from -mm tree
Date: Tue, 08 Sep 2015 11:01:17 -0700
Message-ID: <55ef226d.XlWzwATTq6QceccL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58624 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753989AbbIHSBS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Sep 2015 14:01:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, edumazet@google.com, nzimmer@sgi.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/kthread.c:kthread_create_on_node(): clarify documentation
has been removed from the -mm tree.  Its filename was
     kernel-kthreadc-kthread_create_on_node-clarify-documentation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: kernel/kthread.c:kthread_create_on_node(): clarify documentation

- Make it clear that the `node' arg refers to memory allocations only:
  kthread_create_on_node() does not pin the new thread to that node's
  CPUs.

- Encourage the use of NUMA_NO_NODE.

[nzimmer@sgi.com: use NUMA_NO_NODE in kthread_create() also]
Cc: Nathan Zimmer <nzimmer@sgi.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Eric Dumazet <edumazet@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kthread.h |    2 +-
 kernel/kthread.c        |    7 ++++---
 2 files changed, 5 insertions(+), 4 deletions(-)

diff -puN include/linux/kthread.h~kernel-kthreadc-kthread_create_on_node-clarify-documentation include/linux/kthread.h
--- a/include/linux/kthread.h~kernel-kthreadc-kthread_create_on_node-clarify-documentation
+++ a/include/linux/kthread.h
@@ -11,7 +11,7 @@ struct task_struct *kthread_create_on_no
 					   const char namefmt[], ...);
 
 #define kthread_create(threadfn, data, namefmt, arg...) \
-	kthread_create_on_node(threadfn, data, -1, namefmt, ##arg)
+	kthread_create_on_node(threadfn, data, NUMA_NO_NODE, namefmt, ##arg)
 
 
 struct task_struct *kthread_create_on_cpu(int (*threadfn)(void *data),
diff -puN kernel/kthread.c~kernel-kthreadc-kthread_create_on_node-clarify-documentation kernel/kthread.c
--- a/kernel/kthread.c~kernel-kthreadc-kthread_create_on_node-clarify-documentation
+++ a/kernel/kthread.c
@@ -248,15 +248,16 @@ static void create_kthread(struct kthrea
  * kthread_create_on_node - create a kthread.
  * @threadfn: the function to run until signal_pending(current).
  * @data: data ptr for @threadfn.
- * @node: memory node number.
+ * @node: task and thread structures for the thread are allocated on this node
  * @namefmt: printf-style name for the thread.
  *
  * Description: This helper function creates and names a kernel
  * thread.  The thread will be stopped: use wake_up_process() to start
- * it.  See also kthread_run().
+ * it.  See also kthread_run().  The new thread has SCHED_NORMAL policy and
+ * is affine to all CPUs.
  *
  * If thread is going to be bound on a particular cpu, give its node
- * in @node, to get NUMA affinity for kthread stack, or else give -1.
+ * in @node, to get NUMA affinity for kthread stack, or else give NUMA_NO_NODE.
  * When woken, the thread will run @threadfn() with @data as its
  * argument. @threadfn() can either call do_exit() directly if it is a
  * standalone thread for which no one will call kthread_stop(), or
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
mm.patch
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

