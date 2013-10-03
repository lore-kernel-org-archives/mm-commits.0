From: akpm@linux-foundation.org
Subject: + epoll-optimize-epoll_ctl_del-using-rcu.patch added to -mm tree
Date: Thu, 03 Oct 2013 14:52:09 -0700
Message-ID: <524de709.7oEmfgaxaPCeMa4h%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58353 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755381Ab3JCVwK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Oct 2013 17:52:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, paulmck@us.ibm.com, nzimmer@sgi.com, normalperson@yhbt.net, nelhage@nelhage.com, davidel@xmailserver.org, jbaron@akamai.com

Subject: + epoll-optimize-epoll_ctl_del-using-rcu.patch added to -mm tree
To: jbaron@akamai.com,davidel@xmailserver.org,nelhage@nelhage.com,normalperson@yhbt.net,nzimmer@sgi.com,paulmck@us.ibm.com,viro@zeniv.linux.org.uk
From: akpm@linux-foundation.org
Date: Thu, 03 Oct 2013 14:52:09 -0700


The patch titled
     Subject: epoll: optimize EPOLL_CTL_DEL using rcu
has been added to the -mm tree.  Its filename is
     epoll-optimize-epoll_ctl_del-using-rcu.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/epoll-optimize-epoll_ctl_del-using-rcu.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/epoll-optimize-epoll_ctl_del-using-rcu.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jason Baron <jbaron@akamai.com>
Subject: epoll: optimize EPOLL_CTL_DEL using rcu

Nathan Zimmer found that once we get over 10+ cpus, the scalability of
SPECjbb falls over due to the contention on the global 'epmutex', which is
taken in on EPOLL_CTL_ADD and EPOLL_CTL_DEL operations.

Patch #1 removes the 'epmutex' lock completely from the EPOLL_CTL_DEL path
by using rcu to guard against any concurrent traversals.

Patch #2 remove the 'epmutex' lock from EPOLL_CTL_ADD operations for
simple topologies.  IE when adding a link from an epoll file descriptor to
a wakeup source, where the epoll file descriptor is not nested.


This patch (of 2):

Optimize EPOLL_CTL_DEL such that it does not require the 'epmutex' by
converting the file->f_ep_links list into an rcu one.  In this way, we can
traverse the epoll network on the add path in parallel with deletes. 
Since deletes can't create loops or worse wakeup paths, this is safe.

This patch in combination with the patch "epoll: Do not take global 'epmutex'
for simple topologies", shows a dramatic performance improvement in
scalability for SPECjbb.

Signed-off-by: Jason Baron <jbaron@akamai.com>
Tested-by: Nathan Zimmer <nzimmer@sgi.com>
Cc: Eric Wong <normalperson@yhbt.net>
Cc: Nelson Elhage <nelhage@nelhage.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Davide Libenzi <davidel@xmailserver.org>
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventpoll.c |   65 +++++++++++++++++++++++++++++------------------
 1 file changed, 41 insertions(+), 24 deletions(-)

diff -puN fs/eventpoll.c~epoll-optimize-epoll_ctl_del-using-rcu fs/eventpoll.c
--- a/fs/eventpoll.c~epoll-optimize-epoll_ctl_del-using-rcu
+++ a/fs/eventpoll.c
@@ -42,6 +42,7 @@
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
 #include <linux/compat.h>
+#include <linux/rculist.h>
 
 /*
  * LOCKING:
@@ -134,8 +135,12 @@ struct nested_calls {
  * of these on a server and we do not want this to take another cache line.
  */
 struct epitem {
-	/* RB tree node used to link this structure to the eventpoll RB tree */
-	struct rb_node rbn;
+	union {
+		/* RB tree node links this structure to the eventpoll RB tree */
+		struct rb_node rbn;
+		/* Used to free the struct epitem */
+		struct rcu_head rcu;
+	};
 
 	/* List header used to link this structure to the eventpoll ready list */
 	struct list_head rdllink;
@@ -166,6 +171,9 @@ struct epitem {
 
 	/* The structure that describe the interested events and the source fd */
 	struct epoll_event event;
+
+	/* The fllink is in use. Since rcu can't do 'list_del_init()' */
+	int on_list;
 };
 
 /*
@@ -672,6 +680,12 @@ static int ep_scan_ready_list(struct eve
 	return error;
 }
 
+static void epi_rcu_free(struct rcu_head *head)
+{
+	struct epitem *epi = container_of(head, struct epitem, rcu);
+	kmem_cache_free(epi_cache, epi);
+}
+
 /*
  * Removes a "struct epitem" from the eventpoll RB tree and deallocates
  * all the associated resources. Must be called with "mtx" held.
@@ -693,8 +707,10 @@ static int ep_remove(struct eventpoll *e
 
 	/* Remove the current item from the list of epoll hooks */
 	spin_lock(&file->f_lock);
-	if (ep_is_linked(&epi->fllink))
-		list_del_init(&epi->fllink);
+	if (epi->on_list) {
+		list_del_rcu(&epi->fllink);
+		epi->on_list = 0;
+	}
 	spin_unlock(&file->f_lock);
 
 	rb_erase(&epi->rbn, &ep->rbr);
@@ -705,9 +721,14 @@ static int ep_remove(struct eventpoll *e
 	spin_unlock_irqrestore(&ep->lock, flags);
 
 	wakeup_source_unregister(ep_wakeup_source(epi));
-
-	/* At this point it is safe to free the eventpoll item */
-	kmem_cache_free(epi_cache, epi);
+	/*
+	 * At this point it is safe to free the eventpoll item. Use the union
+	 * field epi->rcu, since we are trying to minimize the size of
+	 * 'struct epitem'. The 'rbn' field is no longer in use. Protected by
+	 * ep->mtx. The rcu read side, reverse_path_check_proc(), does not make
+	 * use of the rbn field.
+	 */
+	call_rcu(&epi->rcu, epi_rcu_free);
 
 	atomic_long_dec(&ep->user->epoll_watches);
 
@@ -873,7 +894,6 @@ static const struct file_operations even
  */
 void eventpoll_release_file(struct file *file)
 {
-	struct list_head *lsthead = &file->f_ep_links;
 	struct eventpoll *ep;
 	struct epitem *epi;
 
@@ -891,17 +911,12 @@ void eventpoll_release_file(struct file
 	 * Besides, ep_remove() acquires the lock, so we can't hold it here.
 	 */
 	mutex_lock(&epmutex);
-
-	while (!list_empty(lsthead)) {
-		epi = list_first_entry(lsthead, struct epitem, fllink);
-
+	list_for_each_entry_rcu(epi, &file->f_ep_links, fllink) {
 		ep = epi->ep;
-		list_del_init(&epi->fllink);
 		mutex_lock_nested(&ep->mtx, 0);
 		ep_remove(ep, epi);
 		mutex_unlock(&ep->mtx);
 	}
-
 	mutex_unlock(&epmutex);
 }
 
@@ -1139,7 +1154,9 @@ static int reverse_path_check_proc(void
 	struct file *child_file;
 	struct epitem *epi;
 
-	list_for_each_entry(epi, &file->f_ep_links, fllink) {
+	/* CTL_DEL can remove links here, but that can't increase our count */
+	rcu_read_lock();
+	list_for_each_entry_rcu(epi, &file->f_ep_links, fllink) {
 		child_file = epi->ep->file;
 		if (is_file_epoll(child_file)) {
 			if (list_empty(&child_file->f_ep_links)) {
@@ -1161,6 +1178,7 @@ static int reverse_path_check_proc(void
 				"file is not an ep!\n");
 		}
 	}
+	rcu_read_unlock();
 	return error;
 }
 
@@ -1255,6 +1273,7 @@ static int ep_insert(struct eventpoll *e
 	epi->event = *event;
 	epi->nwait = 0;
 	epi->next = EP_UNACTIVE_PTR;
+	epi->on_list = 0;
 	if (epi->event.events & EPOLLWAKEUP) {
 		error = ep_create_wakeup_source(epi);
 		if (error)
@@ -1287,7 +1306,8 @@ static int ep_insert(struct eventpoll *e
 
 	/* Add the current item to the list of active epoll hook for this file */
 	spin_lock(&tfile->f_lock);
-	list_add_tail(&epi->fllink, &tfile->f_ep_links);
+	list_add_tail_rcu(&epi->fllink, &tfile->f_ep_links);
+	epi->on_list = 1;
 	spin_unlock(&tfile->f_lock);
 
 	/*
@@ -1328,8 +1348,8 @@ static int ep_insert(struct eventpoll *e
 
 error_remove_epi:
 	spin_lock(&tfile->f_lock);
-	if (ep_is_linked(&epi->fllink))
-		list_del_init(&epi->fllink);
+	if (epi->on_list)
+		list_del_rcu(&epi->fllink);
 	spin_unlock(&tfile->f_lock);
 
 	rb_erase(&epi->rbn, &ep->rbr);
@@ -1846,15 +1866,12 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, in
 	 * and hang them on the tfile_check_list, so we can check that we
 	 * haven't created too many possible wakeup paths.
 	 *
-	 * We need to hold the epmutex across both ep_insert and ep_remove
-	 * b/c we want to make sure we are looking at a coherent view of
-	 * epoll network.
+	 * We need to hold the epmutex across ep_insert to prevent
+	 * multple adds from creating loops in parallel.
 	 */
-	if (op == EPOLL_CTL_ADD || op == EPOLL_CTL_DEL) {
+	if (op == EPOLL_CTL_ADD) {
 		mutex_lock(&epmutex);
 		did_lock_epmutex = 1;
-	}
-	if (op == EPOLL_CTL_ADD) {
 		if (is_file_epoll(tf.file)) {
 			error = -ELOOP;
 			if (ep_loop_check(ep, tf.file) != 0) {
_

Patches currently in -mm which might be from jbaron@akamai.com are

epoll-optimize-epoll_ctl_del-using-rcu.patch
epoll-do-not-take-global-epmutex-for-simple-topologies.patch
epoll-do-not-take-global-epmutex-for-simple-topologies-fix.patch

