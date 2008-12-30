From: akpm@linux-foundation.org
Subject: - lockd-convert-reclaimer-thread-to-kthread-interface.patch removed from -mm tree
Date: Tue, 30 Dec 2008 12:40:10 -0800
Message-ID: <200812302040.mBUKeA1S000513@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39053 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751702AbYL3UlI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Dec 2008 15:41:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jlayton@redhat.com, bfields@fieldses.org, trond.myklebust@fys.uio.no, mm-commits@vger.kernel.org


The patch titled
     lockd: convert reclaimer thread to kthread interface
has been removed from the -mm tree.  Its filename was
     lockd-convert-reclaimer-thread-to-kthread-interface.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lockd: convert reclaimer thread to kthread interface
From: Jeff Layton <jlayton@redhat.com>

My understanding is that there is a push to turn the kernel_thread
interface into a non-exported symbol and move all kernel threads to use
the kthread API. This patch changes lockd to use kthread_run to spawn
the reclaimer thread.

I've made the assumption here that the extra module references taken
when we spawn this thread are unnecessary and removed them. I've also
added a KERN_ERR printk that pops if the thread can't be spawned to warn
the admin that the locks won't be reclaimed.

In the future, it would be nice to be able to notify userspace that
locks have been lost (probably by implementing SIGLOST), and adding some
good policies about how long we should reattempt to reclaim the locks.

Finally, I removed a comment about memory leaks that I believe is
obsolete and added a new one to clarify the result of sending a SIGKILL
to the reclaimer thread. As best I can tell, doing so doesn't actually
cause a memory leak.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/lockd/clntlock.c |   21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff -puN fs/lockd/clntlock.c~lockd-convert-reclaimer-thread-to-kthread-interface fs/lockd/clntlock.c
--- a/fs/lockd/clntlock.c~lockd-convert-reclaimer-thread-to-kthread-interface
+++ a/fs/lockd/clntlock.c
@@ -14,6 +14,7 @@
 #include <linux/sunrpc/svc.h>
 #include <linux/lockd/lockd.h>
 #include <linux/smp_lock.h>
+#include <linux/kthread.h>
 
 #define NLMDBG_FACILITY		NLMDBG_CLIENT
 
@@ -191,11 +192,15 @@ __be32 nlmclnt_grant(const struct sockad
 void
 nlmclnt_recovery(struct nlm_host *host)
 {
+	struct task_struct *task;
+
 	if (!host->h_reclaiming++) {
 		nlm_get_host(host);
-		__module_get(THIS_MODULE);
-		if (kernel_thread(reclaimer, host, CLONE_FS | CLONE_FILES) < 0)
-			module_put(THIS_MODULE);
+		task = kthread_run(reclaimer, host, "%s-reclaim", host->h_name);
+		if (IS_ERR(task))
+			printk(KERN_ERR "lockd: unable to spawn reclaimer "
+				"thread. Locks for %s won't be reclaimed! "
+				"(%ld)\n", host->h_name, PTR_ERR(task));
 	}
 }
 
@@ -207,7 +212,6 @@ reclaimer(void *ptr)
 	struct file_lock *fl, *next;
 	u32 nsmstate;
 
-	daemonize("%s-reclaim", host->h_name);
 	allow_signal(SIGKILL);
 
 	down_write(&host->h_rwsem);
@@ -233,7 +237,12 @@ restart:
 	list_for_each_entry_safe(fl, next, &host->h_reclaim, fl_u.nfs_fl.list) {
 		list_del_init(&fl->fl_u.nfs_fl.list);
 
-		/* Why are we leaking memory here? --okir */
+		/*
+		 * sending this thread a SIGKILL will result in any unreclaimed
+		 * locks being removed from the h_granted list. This means that
+		 * the kernel will not attempt to reclaim them again if a new
+		 * reclaimer thread is spawned for this host.
+		 */
 		if (signalled())
 			continue;
 		if (nlmclnt_reclaim(host, fl) != 0)
@@ -261,5 +270,5 @@ restart:
 	nlm_release_host(host);
 	lockd_down();
 	unlock_kernel();
-	module_put_and_exit(0);
+	return 0;
 }
_

Patches currently in -mm which might be from jlayton@redhat.com are

origin.patch
linux-next.patch

