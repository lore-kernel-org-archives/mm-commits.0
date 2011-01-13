From: akpm@linux-foundation.org
Subject: [merged] epoll-convert-max_user_watches-to-long.patch removed from -mm tree
Date: Thu, 13 Jan 2011 12:07:10 -0800
Message-ID: <201101132009.p0DK9paq029985@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59248 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933352Ab1AMUKg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 15:10:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: holt@sgi.com, davidel@xmailserver.org, ebiederm@xmission.com, penberg@cs.helsinki.fi, mm-commits@vger.kernel.org


The patch titled
     epoll: convert max_user_watches to long
has been removed from the -mm tree.  Its filename was
     epoll-convert-max_user_watches-to-long.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: epoll: convert max_user_watches to long
From: Robin Holt <holt@sgi.com>

On a 16TB machine, max_user_watches has an integer overflow.  Convert it
to use a long and handle the associated fallout.

Signed-off-by: Robin Holt <holt@sgi.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Acked-by: Davide Libenzi <davidel@xmailserver.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventpoll.c        |   20 ++++++++++++--------
 include/linux/sched.h |    2 +-
 2 files changed, 13 insertions(+), 9 deletions(-)

diff -puN fs/eventpoll.c~epoll-convert-max_user_watches-to-long fs/eventpoll.c
--- a/fs/eventpoll.c~epoll-convert-max_user_watches-to-long
+++ a/fs/eventpoll.c
@@ -217,7 +217,7 @@ struct ep_send_events_data {
  * Configuration options available inside /proc/sys/fs/epoll/
  */
 /* Maximum number of epoll watched descriptors, per user */
-static int max_user_watches __read_mostly;
+static long max_user_watches __read_mostly;
 
 /*
  * This mutex is used to serialize ep_free() and eventpoll_release_file().
@@ -240,16 +240,18 @@ static struct kmem_cache *pwq_cache __re
 
 #include <linux/sysctl.h>
 
-static int zero;
+static long zero;
+static long long_max = LONG_MAX;
 
 ctl_table epoll_table[] = {
 	{
 		.procname	= "max_user_watches",
 		.data		= &max_user_watches,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(max_user_watches),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
+		.proc_handler	= proc_doulongvec_minmax,
 		.extra1		= &zero,
+		.extra2		= &long_max,
 	},
 	{ }
 };
@@ -561,7 +563,7 @@ static int ep_remove(struct eventpoll *e
 	/* At this point it is safe to free the eventpoll item */
 	kmem_cache_free(epi_cache, epi);
 
-	atomic_dec(&ep->user->epoll_watches);
+	atomic_long_dec(&ep->user->epoll_watches);
 
 	return 0;
 }
@@ -898,11 +900,12 @@ static int ep_insert(struct eventpoll *e
 {
 	int error, revents, pwake = 0;
 	unsigned long flags;
+	long user_watches;
 	struct epitem *epi;
 	struct ep_pqueue epq;
 
-	if (unlikely(atomic_read(&ep->user->epoll_watches) >=
-		     max_user_watches))
+	user_watches = atomic_long_read(&ep->user->epoll_watches);
+	if (unlikely(user_watches >= max_user_watches))
 		return -ENOSPC;
 	if (!(epi = kmem_cache_alloc(epi_cache, GFP_KERNEL)))
 		return -ENOMEM;
@@ -966,7 +969,7 @@ static int ep_insert(struct eventpoll *e
 
 	spin_unlock_irqrestore(&ep->lock, flags);
 
-	atomic_inc(&ep->user->epoll_watches);
+	atomic_long_inc(&ep->user->epoll_watches);
 
 	/* We have to call this outside the lock */
 	if (pwake)
@@ -1426,6 +1429,7 @@ static int __init eventpoll_init(void)
 	 */
 	max_user_watches = (((si.totalram - si.totalhigh) / 25) << PAGE_SHIFT) /
 		EP_ITEM_COST;
+	BUG_ON(max_user_watches < 0);
 
 	/* Initialize the structure used to perform safe poll wait head wake ups */
 	ep_nested_calls_init(&poll_safewake_ncalls);
diff -puN include/linux/sched.h~epoll-convert-max_user_watches-to-long include/linux/sched.h
--- a/include/linux/sched.h~epoll-convert-max_user_watches-to-long
+++ a/include/linux/sched.h
@@ -683,7 +683,7 @@ struct user_struct {
 	atomic_t fanotify_listeners;
 #endif
 #ifdef CONFIG_EPOLL
-	atomic_t epoll_watches;	/* The number of file descriptors currently watched */
+	atomic_long_t epoll_watches; /* The number of file descriptors currently watched */
 #endif
 #ifdef CONFIG_POSIX_MQUEUE
 	/* protected by mq_lock	*/
_

Patches currently in -mm which might be from holt@sgi.com are

origin.patch

