From: akpm@linux-foundation.org
Subject: + poll-add-poll_requested_events-function.patch added to -mm tree
Date: Wed, 07 Sep 2011 16:51:08 -0700
Message-ID: <201109072351.p87Np8UV031031@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34229 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756647Ab1IGXvM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Sep 2011 19:51:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hverkuil@xs4all.nl, corbet@lwn.net, davidel@xmailserver.org, hans.verkuil@cisco.com, viro@zeniv.linux.org.uk


The patch titled
     poll: add poll_requested_events() function
has been added to the -mm tree.  Its filename is
     poll-add-poll_requested_events-function.patch

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
Subject: poll: add poll_requested_events() function
From: Hans Verkuil <hverkuil@xs4all.nl>

In some cases the poll() implementation in a driver has to do different
things depending on the events the caller wants to poll for.  An example
is when a driver needs to start a DMA engine if the caller polls for
POLLIN, but doesn't want to do that if POLLIN is not requested but instead
only POLLOUT or POLLPRI is requested.  This is something that can happen
in the video4linux subsystem.

Unfortunately, the current epoll/poll/select implementation doesn't
provide that information reliably.  The poll_table_struct does have it: it
has a key field with the event mask.  But once a poll() call matches one
or more bits of that mask any following poll() calls are passed a NULL
poll_table_struct pointer.

The solution is to set the qproc field to NULL in poll_table_struct once
poll() matches the events, not the poll_table_struct pointer itself.  That
way drivers can obtain the mask through a new poll_requested_events
inline.

The poll_table_struct can still be NULL since some kernel code calls it
internally (netfs_state_poll() in ./drivers/staging/pohmelfs/netfs.h).  In
that case poll_requested_events() returns ~0 (i.e.  all events).

Since eventpoll always leaves the key field at ~0 instead of using the
requested events mask, that source was changed as well to properly fill in
the key field.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Reviewed-by: Jonathan Corbet <corbet@lwn.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Davide Libenzi <davidel@xmailserver.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventpoll.c       |   19 +++++++++++++++----
 fs/select.c          |   38 +++++++++++++++++---------------------
 include/linux/poll.h |    7 ++++++-
 3 files changed, 38 insertions(+), 26 deletions(-)

diff -puN fs/eventpoll.c~poll-add-poll_requested_events-function fs/eventpoll.c
--- a/fs/eventpoll.c~poll-add-poll_requested_events-function
+++ a/fs/eventpoll.c
@@ -650,9 +650,12 @@ static int ep_read_events_proc(struct ev
 			       void *priv)
 {
 	struct epitem *epi, *tmp;
+	poll_table pt;
 
+	init_poll_funcptr(&pt, NULL);
 	list_for_each_entry_safe(epi, tmp, head, rdllink) {
-		if (epi->ffd.file->f_op->poll(epi->ffd.file, NULL) &
+		pt.key = epi->event.events;
+		if (epi->ffd.file->f_op->poll(epi->ffd.file, &pt) &
 		    epi->event.events)
 			return POLLIN | POLLRDNORM;
 		else {
@@ -946,6 +949,7 @@ static int ep_insert(struct eventpoll *e
 	/* Initialize the poll table using the queue callback */
 	epq.epi = epi;
 	init_poll_funcptr(&epq.pt, ep_ptable_queue_proc);
+	epq.pt.key = event->events;
 
 	/*
 	 * Attach the item to the poll hooks and get current event bits.
@@ -1027,20 +1031,23 @@ static int ep_modify(struct eventpoll *e
 {
 	int pwake = 0;
 	unsigned int revents;
+	poll_table pt;
+
+	init_poll_funcptr(&pt, NULL);
 
 	/*
 	 * Set the new event interest mask before calling f_op->poll();
 	 * otherwise we might miss an event that happens between the
 	 * f_op->poll() call and the new event set registering.
 	 */
-	epi->event.events = event->events;
+	epi->event.events = pt.key = event->events;
 	epi->event.data = event->data; /* protected by mtx */
 
 	/*
 	 * Get current event bits. We can safely use the file* here because
 	 * its usage count has been increased by the caller of this function.
 	 */
-	revents = epi->ffd.file->f_op->poll(epi->ffd.file, NULL);
+	revents = epi->ffd.file->f_op->poll(epi->ffd.file, &pt);
 
 	/*
 	 * If the item is "hot" and it is not registered inside the ready
@@ -1075,6 +1082,9 @@ static int ep_send_events_proc(struct ev
 	unsigned int revents;
 	struct epitem *epi;
 	struct epoll_event __user *uevent;
+	poll_table pt;
+
+	init_poll_funcptr(&pt, NULL);
 
 	/*
 	 * We can loop without lock because we are passed a task private list.
@@ -1087,7 +1097,8 @@ static int ep_send_events_proc(struct ev
 
 		list_del_init(&epi->rdllink);
 
-		revents = epi->ffd.file->f_op->poll(epi->ffd.file, NULL) &
+		pt.key = epi->event.events;
+		revents = epi->ffd.file->f_op->poll(epi->ffd.file, &pt) &
 			epi->event.events;
 
 		/*
diff -puN fs/select.c~poll-add-poll_requested_events-function fs/select.c
--- a/fs/select.c~poll-add-poll_requested_events-function
+++ a/fs/select.c
@@ -386,13 +386,11 @@ get_max:
 static inline void wait_key_set(poll_table *wait, unsigned long in,
 				unsigned long out, unsigned long bit)
 {
-	if (wait) {
-		wait->key = POLLEX_SET;
-		if (in & bit)
-			wait->key |= POLLIN_SET;
-		if (out & bit)
-			wait->key |= POLLOUT_SET;
-	}
+	wait->key = POLLEX_SET;
+	if (in & bit)
+		wait->key |= POLLIN_SET;
+	if (out & bit)
+		wait->key |= POLLOUT_SET;
 }
 
 int do_select(int n, fd_set_bits *fds, struct timespec *end_time)
@@ -414,7 +412,7 @@ int do_select(int n, fd_set_bits *fds, s
 	poll_initwait(&table);
 	wait = &table.pt;
 	if (end_time && !end_time->tv_sec && !end_time->tv_nsec) {
-		wait = NULL;
+		wait->qproc = NULL;
 		timed_out = 1;
 	}
 
@@ -459,17 +457,17 @@ int do_select(int n, fd_set_bits *fds, s
 					if ((mask & POLLIN_SET) && (in & bit)) {
 						res_in |= bit;
 						retval++;
-						wait = NULL;
+						wait->qproc = NULL;
 					}
 					if ((mask & POLLOUT_SET) && (out & bit)) {
 						res_out |= bit;
 						retval++;
-						wait = NULL;
+						wait->qproc = NULL;
 					}
 					if ((mask & POLLEX_SET) && (ex & bit)) {
 						res_ex |= bit;
 						retval++;
-						wait = NULL;
+						wait->qproc = NULL;
 					}
 				}
 			}
@@ -481,7 +479,7 @@ int do_select(int n, fd_set_bits *fds, s
 				*rexp = res_ex;
 			cond_resched();
 		}
-		wait = NULL;
+		wait->qproc = NULL;
 		if (retval || timed_out || signal_pending(current))
 			break;
 		if (table.error) {
@@ -720,7 +718,7 @@ struct poll_list {
  * interested in events matching the pollfd->events mask, and the result
  * matching that mask is both recorded in pollfd->revents and returned. The
  * pwait poll_table will be used by the fd-provided poll handler for waiting,
- * if non-NULL.
+ * if pwait->qproc is non-NULL.
  */
 static inline unsigned int do_pollfd(struct pollfd *pollfd, poll_table *pwait)
 {
@@ -738,9 +736,7 @@ static inline unsigned int do_pollfd(str
 		if (file != NULL) {
 			mask = DEFAULT_POLLMASK;
 			if (file->f_op && file->f_op->poll) {
-				if (pwait)
-					pwait->key = pollfd->events |
-							POLLERR | POLLHUP;
+				pwait->key = pollfd->events | POLLERR | POLLHUP;
 				mask = file->f_op->poll(file, pwait);
 			}
 			/* Mask out unneeded events. */
@@ -763,7 +759,7 @@ static int do_poll(unsigned int nfds,  s
 
 	/* Optimise the no-wait case */
 	if (end_time && !end_time->tv_sec && !end_time->tv_nsec) {
-		pt = NULL;
+		pt->qproc = NULL;
 		timed_out = 1;
 	}
 
@@ -781,22 +777,22 @@ static int do_poll(unsigned int nfds,  s
 			for (; pfd != pfd_end; pfd++) {
 				/*
 				 * Fish for events. If we found one, record it
-				 * and kill the poll_table, so we don't
+				 * and kill poll_table->qproc, so we don't
 				 * needlessly register any other waiters after
 				 * this. They'll get immediately deregistered
 				 * when we break out and return.
 				 */
 				if (do_pollfd(pfd, pt)) {
 					count++;
-					pt = NULL;
+					pt->qproc = NULL;
 				}
 			}
 		}
 		/*
 		 * All waiters have already been registered, so don't provide
-		 * a poll_table to them on the next loop iteration.
+		 * a poll_table->qproc to them on the next loop iteration.
 		 */
-		pt = NULL;
+		pt->qproc = NULL;
 		if (!count) {
 			count = wait->error;
 			if (signal_pending(current))
diff -puN include/linux/poll.h~poll-add-poll_requested_events-function include/linux/poll.h
--- a/include/linux/poll.h~poll-add-poll_requested_events-function
+++ a/include/linux/poll.h
@@ -39,10 +39,15 @@ typedef struct poll_table_struct {
 
 static inline void poll_wait(struct file * filp, wait_queue_head_t * wait_address, poll_table *p)
 {
-	if (p && wait_address)
+	if (p && p->qproc && wait_address)
 		p->qproc(filp, wait_address, p);
 }
 
+static inline unsigned long poll_requested_events(const poll_table *p)
+{
+	return p ? p->key : ~0UL;
+}
+
 static inline void init_poll_funcptr(poll_table *pt, poll_queue_proc qproc)
 {
 	pt->qproc = qproc;
_

Patches currently in -mm which might be from hverkuil@xs4all.nl are

linux-next.patch
poll-add-poll_requested_events-function.patch

