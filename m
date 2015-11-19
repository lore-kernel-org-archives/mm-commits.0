From: akpm@linux-foundation.org
Subject: +
 ptrace-task_stopped_codeptrace-=-true-cant-see-task_stopped-task-fix.patch
 added to -mm tree
Date: Thu, 19 Nov 2015 15:11:26 -0800
Message-ID: <564e571e.xKBtfUwJTxo3thpc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52335 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758294AbbKSXL1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 Nov 2015 18:11:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, oleg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ptrace-task_stopped_codeptrace-=-true-cant-see-task_stopped-task-fix
has been added to the -mm tree.  Its filename is
     ptrace-task_stopped_codeptrace-=-true-cant-see-task_stopped-task-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ptrace-task_stopped_codeptrace-%3D-true-cant-see-task_stopped-task-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ptrace-task_stopped_codeptrace-%3D-true-cant-see-task_stopped-task-fix.patch

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
Subject: ptrace-task_stopped_codeptrace-=-true-cant-see-task_stopped-task-fix

teeny cleanup

Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN kernel/exit.c~ptrace-task_stopped_codeptrace-=-true-cant-see-task_stopped-task-fix kernel/exit.c
--- a/kernel/exit.c~ptrace-task_stopped_codeptrace-=-true-cant-see-task_stopped-task-fix
+++ a/kernel/exit.c
@@ -1120,8 +1120,7 @@ static int wait_task_zombie(struct wait_
 static int *task_stopped_code(struct task_struct *p, bool ptrace)
 {
 	if (ptrace) {
-		if (task_is_traced(p) &&
-		    !(p->jobctl & JOBCTL_LISTENING))
+		if (task_is_traced(p) && !(p->jobctl & JOBCTL_LISTENING))
 			return &p->exit_code;
 	} else {
 		if (p->signal->flags & SIGNAL_STOP_STOPPED)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
ncpfs-dont-allow-negative-timeouts-fix.patch
writeback-initialize-m_dirty-to-avoid-compile-warning-fix.patch
slub-optimize-bulk-slowpath-free-by-detached-freelist-fix.patch
mm.patch
account-certain-kmem-allocations-to-memcg-checkpatch-fixes.patch
mm-mmapc-remove-redundant-local-variables-for-may_expand_vm-fix.patch
include-define-__phys_to_pfn-as-phys_pfn-fix.patch
mempolicy-convert-the-shared_policy-lock-to-a-rwlock-fix.patch
mempolicy-convert-the-shared_policy-lock-to-a-rwlock-fix-2.patch
mm-zonelist-enumerate-zonelists-array-index-checkpatch-fixes.patch
mm-zonelist-enumerate-zonelists-array-index-fix.patch
mm-get-rid-of-__alloc_pages_high_priority-checkpatch-fixes.patch
page-flags-define-pg_locked-behavior-on-compound-pages-fix.patch
mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix.patch
mm-hwpoison-adjust-for-new-thp-refcounting-fix.patch
mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting-checkpatch-fixes.patch
mm-increase-swap_cluster_max-to-batch-tlb-flushes-fix-fix.patch
ptrace-task_stopped_codeptrace-=-true-cant-see-task_stopped-task-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

