From: akpm@linux-foundation.org
Subject: +
 kernel-kthreadc-kthread_create_on_node-clarify-documentation.patch added to -mm tree
Date: Thu, 09 Jul 2015 15:16:01 -0700
Message-ID: <559ef2a1.xjS32bF0+IHLI6Aq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53036 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754321AbbGIWQC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Jul 2015 18:16:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, edumazet@google.com, nzimmer@sgi.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/kthread.c:kthread_create_on_node(): clarify documentation
has been added to the -mm tree.  Its filename is
     kernel-kthreadc-kthread_create_on_node-clarify-documentation.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-kthreadc-kthread_create_on_node-clarify-documentation.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-kthreadc-kthread_create_on_node-clarify-documentation.patch

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
Subject: kernel/kthread.c:kthread_create_on_node(): clarify documentation

- Make it clear that the `node' arg refers to memory allocations only:
  kthread_create_on_node() does not pin the new thread to that node's
  CPUs.

- Encourage the use of NUMA_NO_NODE.

Cc: Nathan Zimmer <nzimmer@sgi.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Eric Dumazet <edumazet@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kthread.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN kernel/kthread.c~kernel-kthreadc-kthread_create_on_node-clarify-documentation kernel/kthread.c
--- a/kernel/kthread.c~kernel-kthreadc-kthread_create_on_node-clarify-documentation
+++ a/kernel/kthread.c
@@ -246,15 +246,16 @@ static void create_kthread(struct kthrea
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
openrisc-fix-config_uid16-setting.patch
kernel-kthreadc-kthread_create_on_node-clarify-documentation.patch
mm.patch
userfaultfd-change-the-read-api-to-return-a-uffd_msg-fix-2.patch
userfaultfd-change-the-read-api-to-return-a-uffd_msg-fix-2-fix.patch
userfaultfd-avoid-mmap_sem-read-recursion-in-mcopy_atomic-fix.patch
genalloc-add-name-arg-to-gen_pool_get-and-devm_gen_pool_create-fix.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-3.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix-fix.patch
linux-next.patch
linux-next-rejects.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
net-netfilter-ipset-work-around-gcc-444-initializer-bug.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

