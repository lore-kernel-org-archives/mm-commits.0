From: akpm@linux-foundation.org
Subject: + perf-fix-perf-bug-in-fork.patch added to -mm tree
Date: Wed, 01 Oct 2014 15:45:50 -0700
Message-ID: <542c841e.WOoavQZX85fk+El5%akpm__33356.4638895497$1412203560$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45239 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753285AbaJAWpu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Oct 2014 18:45:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: peterz@infradead.org, mingo@kernel.org, oleg@redhat.com, stable@vger.kernel.org, sylvain.hitier@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: perf: fix perf bug in fork()
has been added to the -mm tree.  Its filename is
     perf-fix-perf-bug-in-fork.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/perf-fix-perf-bug-in-fork.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/perf-fix-perf-bug-in-fork.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Peter Zijlstra <peterz@infradead.org>
Subject: perf: fix perf bug in fork()

Oleg noticed that a cleanup by Sylvain actually uncovered a bug; by
calling perf_event_free_task() when failing sched_fork() we will not yet
have done the memset() on ->perf_event_ctxp[] and will therefore try and
'free' the inherited contexts, which are still in use by the parent
process.  This is bad..

Suggested-by: Oleg Nesterov <oleg@redhat.com>
Reported-by: Oleg Nesterov <oleg@redhat.com>
Reported-by: Sylvain 'ythier' Hitier <sylvain.hitier@gmail.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/events/core.c |    4 +++-
 kernel/fork.c        |    5 +++--
 2 files changed, 6 insertions(+), 3 deletions(-)

diff -puN kernel/events/core.c~perf-fix-perf-bug-in-fork kernel/events/core.c
--- a/kernel/events/core.c~perf-fix-perf-bug-in-fork
+++ a/kernel/events/core.c
@@ -7948,8 +7948,10 @@ int perf_event_init_task(struct task_str
 
 	for_each_task_context_nr(ctxn) {
 		ret = perf_event_init_context(child, ctxn);
-		if (ret)
+		if (ret) {
+			perf_event_free_task(child);
 			return ret;
+		}
 	}
 
 	return 0;
diff -puN kernel/fork.c~perf-fix-perf-bug-in-fork kernel/fork.c
--- a/kernel/fork.c~perf-fix-perf-bug-in-fork
+++ a/kernel/fork.c
@@ -1360,7 +1360,7 @@ static struct task_struct *copy_process(
 		goto bad_fork_cleanup_policy;
 	retval = audit_alloc(p);
 	if (retval)
-		goto bad_fork_cleanup_policy;
+		goto bad_fork_cleanup_perf;
 	/* copy all the process information */
 	shm_init_task(p);
 	retval = copy_semundo(clone_flags, p);
@@ -1566,8 +1566,9 @@ bad_fork_cleanup_semundo:
 	exit_sem(p);
 bad_fork_cleanup_audit:
 	audit_free(p);
-bad_fork_cleanup_policy:
+bad_fork_cleanup_perf:
 	perf_event_free_task(p);
+bad_fork_cleanup_policy:
 #ifdef CONFIG_NUMA
 	mpol_put(p->mempolicy);
 bad_fork_cleanup_threadgroup_lock:
_

Patches currently in -mm which might be from peterz@infradead.org are

mm-memcontrol-do-not-iterate-uninitialized-memcgs.patch
perf-fix-perf-bug-in-fork.patch
mempolicy-change-alloc_pages_vma-to-use-mpol_cond_put.patch
mempolicy-change-get_task_policy-to-return-default_policy-rather-than-null.patch
mempolicy-sanitize-the-usage-of-get_task_policy.patch
mempolicy-remove-the-task-arg-of-vma_policy_mof-and-simplify-it.patch
mempolicy-introduce-__get_vma_policy-export-get_task_policy.patch
mempolicy-fix-show_numa_map-vs-exec-do_set_mempolicy-race.patch
mempolicy-kill-do_set_mempolicy-down_writemm-mmap_sem.patch
mempolicy-unexport-get_vma_policy-and-remove-its-task-arg.patch
vmstat-on-demand-vmstat-workers-v8.patch
vmstat-on-demand-vmstat-workers-v8-do-not-open-code-alloc_cpumask_var.patch
printk-git-rid-of-message-for-printk_deferred.patch
lib-remove-prio_heap.patch
x86-optimize-resource-lookups-for-ioremap.patch
x86-optimize-resource-lookups-for-ioremap-fix.patch
x86-use-optimized-ioresource-lookup-in-ioremap-function.patch
linux-next.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch

