From: akpm@linux-foundation.org
Subject: [merged] fork-report-pid-reservation-failure-properly.patch
 removed from -mm tree
Date: Mon, 20 Apr 2015 12:19:36 -0700
Message-ID: <55355148.hIaWrooCfCpDL4Xg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40367 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751575AbbDTTNP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Apr 2015 15:13:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.cz, ebiederm@xmission.com, mtk.manpages@gmail.com, oleg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fork: report pid reservation failure properly
has been removed from the -mm tree.  Its filename was
     fork-report-pid-reservation-failure-properly.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: fork: report pid reservation failure properly

copy_process will report any failure in alloc_pid as ENOMEM currently
which is misleading because the pid allocation might fail not only when
the memory is short but also when the pid space is consumed already.

The current man page even mentions this case:

: EAGAIN
: 
:       A system-imposed limit on the number of threads was encountered.
:       There are a number of limits that may trigger this error: the
:       RLIMIT_NPROC soft resource limit (set via setrlimit(2)), which
:       limits the number of processes and threads for a real user ID, was
:       reached; the kernel's system-wide limit on the number of processes
:       and threads, /proc/sys/kernel/threads-max, was reached (see
:       proc(5)); or the maximum number of PIDs, /proc/sys/kernel/pid_max,
:       was reached (see proc(5)).


so the current behavior is also incorrect wrt.  documentation.  POSIX man
page also suggest returing EAGAIN when the process count limit is reached.

This patch simply propagates error code from alloc_pid and makes sure we
return -EAGAIN due to reservation failure.  This will make behavior of
fork closer to both our documentation and POSIX.

alloc_pid might alsoo fail when the reaper in the pid namespace is dead
(the namespace basically disallows all new processes) and there is no
good error code which would match documented ones. We have traditionally
returned ENOMEM for this case which is misleading as well but as per
Eric W. Biederman this behavior is documented in man pid_namespaces(7)

: If the "init" process of a PID namespace terminates, the kernel
: terminates all of the processes in the namespace via a SIGKILL signal.
: This behavior reflects the fact that the "init" process is essential for
: the correct operation of a PID namespace.  In this case, a subsequent
: fork(2) into this PID namespace will fail with the error ENOMEM; it is
: not possible to create a new processes in a PID namespace whose "init"
: process has terminated.

and introducing a new error code would be too risky so let's stick to
ENOMEM for this case.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |    5 +++--
 kernel/pid.c  |   15 ++++++++-------
 2 files changed, 11 insertions(+), 9 deletions(-)

diff -puN kernel/fork.c~fork-report-pid-reservation-failure-properly kernel/fork.c
--- a/kernel/fork.c~fork-report-pid-reservation-failure-properly
+++ a/kernel/fork.c
@@ -1403,10 +1403,11 @@ static struct task_struct *copy_process(
 		goto bad_fork_cleanup_io;
 
 	if (pid != &init_struct_pid) {
-		retval = -ENOMEM;
 		pid = alloc_pid(p->nsproxy->pid_ns_for_children);
-		if (!pid)
+		if (IS_ERR(pid)) {
+			retval = PTR_ERR(pid);
 			goto bad_fork_cleanup_io;
+		}
 	}
 
 	p->set_child_tid = (clone_flags & CLONE_CHILD_SETTID) ? child_tidptr : NULL;
diff -puN kernel/pid.c~fork-report-pid-reservation-failure-properly kernel/pid.c
--- a/kernel/pid.c~fork-report-pid-reservation-failure-properly
+++ a/kernel/pid.c
@@ -182,7 +182,7 @@ static int alloc_pidmap(struct pid_names
 			spin_unlock_irq(&pidmap_lock);
 			kfree(page);
 			if (unlikely(!map->page))
-				break;
+				return -ENOMEM;
 		}
 		if (likely(atomic_read(&map->nr_free))) {
 			for ( ; ; ) {
@@ -210,7 +210,7 @@ static int alloc_pidmap(struct pid_names
 		}
 		pid = mk_pid(pid_ns, map, offset);
 	}
-	return -1;
+	return -EAGAIN;
 }
 
 int next_pidmap(struct pid_namespace *pid_ns, unsigned int last)
@@ -301,17 +301,20 @@ struct pid *alloc_pid(struct pid_namespa
 	int i, nr;
 	struct pid_namespace *tmp;
 	struct upid *upid;
+	int retval = -ENOMEM;
 
 	pid = kmem_cache_alloc(ns->pid_cachep, GFP_KERNEL);
 	if (!pid)
-		goto out;
+		return ERR_PTR(retval);
 
 	tmp = ns;
 	pid->level = ns->level;
 	for (i = ns->level; i >= 0; i--) {
 		nr = alloc_pidmap(tmp);
-		if (nr < 0)
+		if (IS_ERR_VALUE(nr)) {
+			retval = nr;
 			goto out_free;
+		}
 
 		pid->numbers[i].nr = nr;
 		pid->numbers[i].ns = tmp;
@@ -339,7 +342,6 @@ struct pid *alloc_pid(struct pid_namespa
 	}
 	spin_unlock_irq(&pidmap_lock);
 
-out:
 	return pid;
 
 out_unlock:
@@ -351,8 +353,7 @@ out_free:
 		free_pidmap(pid->numbers + i);
 
 	kmem_cache_free(ns->pid_cachep, pid);
-	pid = NULL;
-	goto out;
+	return ERR_PTR(retval);
 }
 
 void disable_pid_allocation(struct pid_namespace *ns)
_

Patches currently in -mm which might be from mhocko@suse.cz are

origin.patch
jbd2-revert-must-not-fail-allocation-loops-back-to-gfp_nofail.patch
page-flags-trivial-cleanup-for-pagetrans-helpers.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages.patch
page-flags-define-pg_locked-behavior-on-compound-pages.patch
page-flags-define-behavior-of-fs-io-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-xen-related-flags-on-compound-pages.patch
page-flags-define-pg_reserved-behavior-on-compound-pages.patch
page-flags-define-pg_swapbacked-behavior-on-compound-pages.patch
page-flags-define-pg_swapcache-behavior-on-compound-pages.patch
page-flags-define-pg_mlocked-behavior-on-compound-pages.patch
page-flags-define-pg_uncached-behavior-on-compound-pages.patch
page-flags-define-pg_uptodate-behavior-on-compound-pages.patch
page-flags-look-on-head-page-if-the-flag-is-encoded-in-page-mapping.patch
mm-sanitize-page-mapping-for-tail-pages.patch
mm-vmscan-do-not-throttle-based-on-pfmemalloc-reserves-if-node-has-no-reclaimable-pages.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
mm-page_isolation-check-pfn-validity-before-access.patch
mm-support-madvisemadv_free.patch
mm-support-madvisemadv_free-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-2.patch
mm-move-lazy-free-pages-to-inactive-list.patch
mm-move-lazy-free-pages-to-inactive-list-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch

