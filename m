From: akpm@linux-foundation.org
Subject: + lockd-convert-reclaimer-thread-to-kthread-interface.patch added to -mm tree
Date: Mon, 03 Nov 2008 13:12:20 -0800
Message-ID: <200811032112.mA3LCK6G002686@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45744 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756848AbYKCVMr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Nov 2008 16:12:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jlayton@redhat.com, bfields@fieldses.org, trond.myklebust@fys.uio.no


The patch titled
     lockd: convert reclaimer thread to kthread interface
has been added to the -mm tree.  Its filename is
     lockd-convert-reclaimer-thread-to-kthread-interface.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lockd: convert reclaimer thread to kthread interface
From: Jeff Layton <jlayton@redhat.com>

My understanding is that there is a push to turn the kernel_thread
interface into a non-exported symbol and move all kernel threads to use
the kthread API.  This patch changes lockd to use kthread_run to spawn the
reclaimer thread.

I've made the assumption here that the extra module references taken when
we spawn this thread are unnecessary and removed them.  I've also added a
KERN_ERR printk that pops if the thread can't be spawned to warn the admin
that the locks won't be reclaimed.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/lockd/clntlock.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

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
@@ -261,5 +265,5 @@ restart:
 	nlm_release_host(host);
 	lockd_down();
 	unlock_kernel();
-	module_put_and_exit(0);
+	return 0;
 }
_

Patches currently in -mm which might be from jlayton@redhat.com are

linux-next.patch
lockd-convert-reclaimer-thread-to-kthread-interface.patch

