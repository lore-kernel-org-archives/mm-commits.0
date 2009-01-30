From: akpm@linux-foundation.org
Subject: [merged] epoll-drop-max_user_instances-and-rely-only-on-max_user_watches.patch removed from -mm tree
Date: Fri, 30 Jan 2009 11:14:25 -0800
Message-ID: <200901301914.n0UJEPQK027427@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57292 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753556AbZA3TSJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Jan 2009 14:18:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davidel@xmailserver.org, brong@fastmail.fm, mtk.manpages@googlemail.com, stable@kernel.org, w@1wt.eu, mm-commits@vger.kernel.org


The patch titled
     epoll: drop max_user_instances and rely only on max_user_watches
has been removed from the -mm tree.  Its filename was
     epoll-drop-max_user_instances-and-rely-only-on-max_user_watches.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: epoll: drop max_user_instances and rely only on max_user_watches
From: Davide Libenzi <davidel@xmailserver.org>

Linus suggested to put limits where the money is, and max_user_watches
already does that w/out the need of max_user_instances.  That has the
advantage to mitigate the potential DoS while allowing pretty generous
default behavior.

Allowing top 4% of low memory (per user) to be allocated in epoll watches,
we have:

LOMEM    MAX_WATCHES (per user)
512MB    ~178000
1GB      ~356000
2GB      ~712000

A box with 512MB of lomem, will meet some challenge in hitting 180K
watches, socket buffers math teaches us.  No more max_user_instances
limits then.

Signed-off-by: Davide Libenzi <davidel@xmailserver.org>
Cc: Willy Tarreau <w@1wt.eu>
Cc: Michael Kerrisk <mtk.manpages@googlemail.com>
Cc: Bron Gondwana <brong@fastmail.fm>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventpoll.c        |   22 ++++------------------
 include/linux/sched.h |    1 -
 2 files changed, 4 insertions(+), 19 deletions(-)

diff -puN fs/eventpoll.c~epoll-drop-max_user_instances-and-rely-only-on-max_user_watches fs/eventpoll.c
--- a/fs/eventpoll.c~epoll-drop-max_user_instances-and-rely-only-on-max_user_watches
+++ a/fs/eventpoll.c
@@ -234,8 +234,6 @@ struct ep_pqueue {
 /*
  * Configuration options available inside /proc/sys/fs/epoll/
  */
-/* Maximum number of epoll devices, per user */
-static int max_user_instances __read_mostly;
 /* Maximum number of epoll watched descriptors, per user */
 static int max_user_watches __read_mostly;
 
@@ -261,14 +259,6 @@ static int zero;
 
 ctl_table epoll_table[] = {
 	{
-		.procname	= "max_user_instances",
-		.data		= &max_user_instances,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_minmax,
-		.extra1		= &zero,
-	},
-	{
 		.procname	= "max_user_watches",
 		.data		= &max_user_watches,
 		.maxlen		= sizeof(int),
@@ -491,7 +481,6 @@ static void ep_free(struct eventpoll *ep
 
 	mutex_unlock(&epmutex);
 	mutex_destroy(&ep->mtx);
-	atomic_dec(&ep->user->epoll_devs);
 	free_uid(ep->user);
 	kfree(ep);
 }
@@ -581,10 +570,6 @@ static int ep_alloc(struct eventpoll **p
 	struct eventpoll *ep;
 
 	user = get_current_user();
-	error = -EMFILE;
-	if (unlikely(atomic_read(&user->epoll_devs) >=
-			max_user_instances))
-		goto free_uid;
 	error = -ENOMEM;
 	ep = kzalloc(sizeof(*ep), GFP_KERNEL);
 	if (unlikely(!ep))
@@ -1141,7 +1126,6 @@ SYSCALL_DEFINE1(epoll_create1, int, flag
 			      flags & O_CLOEXEC);
 	if (fd < 0)
 		ep_free(ep);
-	atomic_inc(&ep->user->epoll_devs);
 
 error_return:
 	DNPRINTK(3, (KERN_INFO "[%p] eventpoll: sys_epoll_create(%d) = %d\n",
@@ -1366,8 +1350,10 @@ static int __init eventpoll_init(void)
 	struct sysinfo si;
 
 	si_meminfo(&si);
-	max_user_instances = 128;
-	max_user_watches = (((si.totalram - si.totalhigh) / 32) << PAGE_SHIFT) /
+	/*
+	 * Allows top 4% of lomem to be allocated for epoll watches (per user).
+	 */
+	max_user_watches = (((si.totalram - si.totalhigh) / 25) << PAGE_SHIFT) /
 		EP_ITEM_COST;
 
 	/* Initialize the structure used to perform safe poll wait head wake ups */
diff -puN include/linux/sched.h~epoll-drop-max_user_instances-and-rely-only-on-max_user_watches include/linux/sched.h
--- a/include/linux/sched.h~epoll-drop-max_user_instances-and-rely-only-on-max_user_watches
+++ a/include/linux/sched.h
@@ -630,7 +630,6 @@ struct user_struct {
 	atomic_t inotify_devs;	/* How many inotify devs does this user have opened? */
 #endif
 #ifdef CONFIG_EPOLL
-	atomic_t epoll_devs;	/* The number of epoll descriptors currently open */
 	atomic_t epoll_watches;	/* The number of file descriptors currently watched */
 #endif
 #ifdef CONFIG_POSIX_MQUEUE
_

Patches currently in -mm which might be from davidel@xmailserver.org are

origin.patch
linux-next.patch
epoll-fix-own-poll.patch
epoll-fix-epolls-own-poll-update.patch
epoll-remove-debugging-code.patch

