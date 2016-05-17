From: akpm@linux-foundation.org
Subject: + allocate-idle-task-for-a-cpu-always-on-its-local-node-fix.patch added to -mm tree
Date: Tue, 17 May 2016 14:13:17 -0700
Message-ID: <573b896d.d501OrcLskfI6WUg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37598 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675AbcEQVNT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 May 2016 17:13:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ak@linux.intel.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: allocate-idle-task-for-a-cpu-always-on-its-local-node-fix
has been added to the -mm tree.  Its filename is
     allocate-idle-task-for-a-cpu-always-on-its-local-node-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/allocate-idle-task-for-a-cpu-always-on-its-local-node-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/allocate-idle-task-for-a-cpu-always-on-its-local-node-fix.patch

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
Subject: allocate-idle-task-for-a-cpu-always-on-its-local-node-fix

use NUMA_NO_NODE, not a bare -1

Cc: Andi Kleen <ak@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/fork.c~allocate-idle-task-for-a-cpu-always-on-its-local-node-fix kernel/fork.c
--- a/kernel/fork.c~allocate-idle-task-for-a-cpu-always-on-its-local-node-fix
+++ a/kernel/fork.c
@@ -346,7 +346,7 @@ static struct task_struct *dup_task_stru
 	struct thread_info *ti;
 	int err;
 
-	if (node < 0)
+	if (node == NUMA_NO_NODE)
 		node = tsk_fork_get_node(orig);
 	tsk = alloc_task_struct_node(node);
 	if (!tsk)
@@ -1754,7 +1754,7 @@ long _do_fork(unsigned long clone_flags,
 	}
 
 	p = copy_process(clone_flags, stack_start, stack_size,
-			 child_tidptr, NULL, trace, tls, -1);
+			 child_tidptr, NULL, trace, tls, NUMA_NO_NODE);
 	/*
 	 * Do this prior waking up the new thread - the thread pointer
 	 * might get invalid after that point, if the thread exits quickly.
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
fsnotify-avoid-spurious-emfile-errors-from-inotify_init-checkpatch-fixes.patch
kernel-padata-hide-unused-functions-checkpatch-fixes.patch
mm.patch
mm-slab-freelist-randomization-v5-fix.patch
mm-rename-_count-field-of-the-struct-page-to-_refcount-fix.patch
mm-rename-_count-field-of-the-struct-page-to-_refcount-fix-fix.patch
include-linux-apply-__malloc-attribute-checkpatch-fixes.patch
include-linux-nodemaskh-create-next_node_in-helper.patch
include-linux-nodemaskh-create-next_node_in-helper-fix-fix.patch
mm-hugetlbc-use-first_memory_node.patch
mm-mempolicyc-offset_il_node-document-and-clarify.patch
mm-uninline-page_mapped.patch
mm-uninline-page_mapped-checkpatch-fixes.patch
memory_hotplug-introduce-config_memory_hotplug_default_online-fix.patch
oom-oom_reaper-try-to-reap-tasks-which-skip-regular-oom-killer-path-try-to-reap-tasks-which-skip-regular-memcg-oom-killer-path-fix.patch
mm-page_alloc-only-check-pagecompound-for-high-order-pages-fix.patch
mm-page_alloc-remove-unnecessary-initialisation-from-__alloc_pages_nodemask-fix.patch
mm-page_alloc-shorten-the-page-allocator-fast-path-fix.patch
mm-page_alloc-avoid-looking-up-the-first-zone-in-a-zonelist-twice-fix.patch
mm-page_alloc-un-inline-the-bad-part-of-free_pages_check-fix.patch
mm-page_alloc-defer-debugging-checks-of-freed-pages-until-a-pcp-drain-fix.patch
mm-page_alloc-dont-duplicate-code-in-free_pcp_prepare-fix.patch
mm-page_alloc-dont-duplicate-code-in-free_pcp_prepare-fix-fix.patch
mm-compaction-abstract-compaction-feedback-to-helpers-fix.patch
mm-oom-compaction-prevent-from-should_compact_retry-looping-for-ever-for-costly-orders-fix.patch
mm-oom-protect-costly-allocations-some-more-for-config_compaction-checkpatch-fixes.patch
vmstat-get-rid-of-the-ugly-cpu_stat_off-variable-v2-fix.patch
mm-thp-avoid-unnecessary-swapin-in-khugepaged-fix.patch
procfs-fixes-pthread-cross-thread-naming-if-pr_dumpable-fix.patch
exit_thread-remove-empty-bodies-fix.patch
exit_thread-accept-a-task-parameter-to-be-exited-checkpatch-fixes.patch
lib-gcd-use-binary-gcd-algorithm-instead-of-euclidean-fix.patch
allocate-idle-task-for-a-cpu-always-on-its-local-node-fix.patch
fs-execc-fix-minor-memory-leak.patch
linux-next-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

