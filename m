From: akpm@linux-foundation.org
Subject: + epoll-convert-max_user_watches-to-long.patch added to -mm tree
Date: Wed, 27 Oct 2010 16:45:10 -0700
Message-ID: <201010272345.o9RNjARO026550@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58915 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757605Ab0J0Xpw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Oct 2010 19:45:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: holt@sgi.com, davidel@xmailserver.org, ebiederm@xmission.com, penberg@cs.helsinki.fi


The patch titled
     epoll: convert max_user_watches to long.
has been added to the -mm tree.  Its filename is
     epoll-convert-max_user_watches-to-long.patch

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
Subject: epoll: convert max_user_watches to long.
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
@@ -673,7 +673,7 @@ struct user_struct {
 	atomic_t inotify_devs;	/* How many inotify devs does this user have opened? */
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
linux-next.patch
net-avoid-limits-overflow.patch
epoll-convert-max_user_watches-to-long.patch

