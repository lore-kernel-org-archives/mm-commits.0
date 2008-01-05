From: akpm@linux-foundation.org
Subject: + sunrpc-allow-svc_pool_map_set_cpumask-to-work-with-any-task.patch added to -mm tree
Date: Fri, 04 Jan 2008 22:51:54 -0800
Message-ID: <200801050652.m056qdTl032492@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47388 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752700AbYAEGxx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 5 Jan 2008 01:53:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jlayton@redhat.com, bfields@fieldses.org, neilb@suse.de, trond.myklebust@fys.uio.no


The patch titled
     sunrpc: allow svc_pool_map_set_cpumask to work with any task
has been added to the -mm tree.  Its filename is
     sunrpc-allow-svc_pool_map_set_cpumask-to-work-with-any-task.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sunrpc: allow svc_pool_map_set_cpumask to work with any task
From: Jeff Layton <jlayton@redhat.com>

This patchset fixes the use-after-free problem in lockd, and to convert lockd
to use the kthread API instead of kernel_thread.  The main change from the
last patchset is the elimination of the svc_create_kthread helper function,
and having lockd_up call kthread_run directly.  I've also made some changes to
the function prototype for the lockd function to eliminate the need for
casting the function pointer.

Tested against the reproducer I have for the main issue (detailed in patch
#7).  As always, comments and suggestions are appreciated.



This patch:

svc_pool_map_set_cpumask will only affect "current" as of now.  Add a new arg
so that it can change the cpumask on any given task.  Also if we're not
changing "current" we don't care what the oldmask was, so allow it to be a
NULL pointer.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Neil Brown <neilb@suse.de>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/sunrpc/svc.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff -puN net/sunrpc/svc.c~sunrpc-allow-svc_pool_map_set_cpumask-to-work-with-any-task net/sunrpc/svc.c
--- a/net/sunrpc/svc.c~sunrpc-allow-svc_pool_map_set_cpumask-to-work-with-any-task
+++ a/net/sunrpc/svc.c
@@ -297,7 +297,8 @@ svc_pool_map_put(void)
  * Returns 1 and fills in oldmask iff a cpumask was applied.
  */
 static inline int
-svc_pool_map_set_cpumask(unsigned int pidx, cpumask_t *oldmask)
+svc_pool_map_set_cpumask(struct task_struct *task, unsigned int pidx,
+			 cpumask_t *oldmask)
 {
 	struct svc_pool_map *m = &svc_pool_map;
 	unsigned int node; /* or cpu */
@@ -314,13 +315,15 @@ svc_pool_map_set_cpumask(unsigned int pi
 		return 0;
 	case SVC_POOL_PERCPU:
 		node = m->pool_to[pidx];
-		*oldmask = current->cpus_allowed;
-		set_cpus_allowed(current, cpumask_of_cpu(node));
+		if (oldmask != NULL)
+			*oldmask = task->cpus_allowed;
+		set_cpus_allowed(task, cpumask_of_cpu(node));
 		return 1;
 	case SVC_POOL_PERNODE:
 		node = m->pool_to[pidx];
-		*oldmask = current->cpus_allowed;
-		set_cpus_allowed(current, node_to_cpumask(node));
+		if (oldmask != NULL)
+			*oldmask = task->cpus_allowed;
+		set_cpus_allowed(task, node_to_cpumask(node));
 		return 1;
 	}
 }
@@ -564,7 +567,8 @@ __svc_create_thread(svc_thread_fn func, 
 	rqstp->rq_pool = pool;
 
 	if (serv->sv_nrpools > 1)
-		have_oldmask = svc_pool_map_set_cpumask(pool->sp_id, &oldmask);
+		have_oldmask = svc_pool_map_set_cpumask(current, pool->sp_id,
+							&oldmask);
 
 	error = kernel_thread((int (*)(void *)) func, rqstp, 0);
 
_

Patches currently in -mm which might be from jlayton@redhat.com are

sunrpc-allow-svc_pool_map_set_cpumask-to-work-with-any-task.patch
sunrpc-spin-svc_rqst-initialization-to-its-own-function.patch
sunrpc-export-svc_sock_update_bufs.patch
nlm-initialize-completion-variable-in-lockd_up.patch
nlm-have-lockd-call-try_to_freeze.patch
nlm-convert-lockd-to-use-kthreads.patch
nlm-add-reference-counting-to-lockd.patch
git-unionfs.patch
smbfs-fix-calculation-of-kernel_recvmsg-size-parameter-in-smb_receive.patch
deprecate-smbfs-in-favour-of-cifs.patch
