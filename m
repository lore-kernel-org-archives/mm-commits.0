From: akpm@linux-foundation.org
Subject: + epoll-drop-max_user_instances-and-rely-only-on-max_user_watches.patch added to -mm tree
Date: Thu, 29 Jan 2009 00:57:24 -0800
Message-ID: <200901290857.n0T8vORt019370@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37475 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751135AbZA2I6J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Jan 2009 03:58:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: davidel@xmailserver.org, brong@fastmail.fm, mtk.manpages@googlemail.com, w@1wt.eu


The patch titled
     epoll: drop max_user_instances and rely only on max_user_watches
has been added to the -mm tree.  Its filename is
     epoll-drop-max_user_instances-and-rely-only-on-max_user_watches.patch

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventpoll.c        |   23 ++++-------------------
 include/linux/sched.h |    1 -
 2 files changed, 4 insertions(+), 20 deletions(-)

diff -puN fs/eventpoll.c~epoll-drop-max_user_instances-and-rely-only-on-max_user_watches fs/eventpoll.c
--- a/fs/eventpoll.c~epoll-drop-max_user_instances-and-rely-only-on-max_user_watches
+++ a/fs/eventpoll.c
@@ -219,8 +219,6 @@ struct ep_send_events_data {
 /*
  * Configuration options available inside /proc/sys/fs/epoll/
  */
-/* Maximum number of epoll devices, per user */
-static int max_user_instances __read_mostly;
 /* Maximum number of epoll watched descriptors, per user */
 static int max_user_watches __read_mostly;
 
@@ -249,14 +247,6 @@ static int zero;
 
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
@@ -606,7 +596,6 @@ static void ep_free(struct eventpoll *ep
 
 	mutex_unlock(&epmutex);
 	mutex_destroy(&ep->mtx);
-	atomic_dec(&ep->user->epoll_devs);
 	free_uid(ep->user);
 	kfree(ep);
 }
@@ -720,10 +709,6 @@ static int ep_alloc(struct eventpoll **p
 	struct eventpoll *ep;
 
 	user = get_current_user();
-	error = -EMFILE;
-	if (unlikely(atomic_read(&user->epoll_devs) >=
-			max_user_instances))
-		goto free_uid;
 	error = -ENOMEM;
 	ep = kzalloc(sizeof(*ep), GFP_KERNEL);
 	if (unlikely(!ep))
@@ -1197,8 +1182,6 @@ SYSCALL_DEFINE1(epoll_create1, int, flag
 				 flags & O_CLOEXEC);
 	if (error < 0)
 		ep_free(ep);
-	else
-		atomic_inc(&ep->user->epoll_devs);
 
 error_return:
 
@@ -1411,8 +1394,10 @@ static int __init eventpoll_init(void)
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
@@ -646,7 +646,6 @@ struct user_struct {
 	atomic_t inotify_devs;	/* How many inotify devs does this user have opened? */
 #endif
 #ifdef CONFIG_EPOLL
-	atomic_t epoll_devs;	/* The number of epoll descriptors currently open */
 	atomic_t epoll_watches;	/* The number of file descriptors currently watched */
 #endif
 #ifdef CONFIG_POSIX_MQUEUE
_

Patches currently in -mm which might be from davidel@xmailserver.org are

linux-next.patch
epoll-fix-own-poll.patch
epoll-remove-debugging-code.patch
epoll-drop-max_user_instances-and-rely-only-on-max_user_watches.patch

