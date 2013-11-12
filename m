From: akpm@linux-foundation.org
Subject: [folded-merged] epoll-optimize-epoll_ctl_del-using-rcu-fix.patch
 removed from -mm tree
Date: Tue, 12 Nov 2013 14:41:36 -0800
Message-ID: <5282aea0.kD1PARh2M8zEpNyz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60705 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757324Ab3KLWlj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Nov 2013 17:41:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, paulmck@us.ibm.com, nzimmer@sgi.com, normalperson@yhbt.net, nelhage@nelhage.com, fengguang.wu@intel.com, davidel@xmailserver.org, jbaron@akamai.com

Subject: [folded-merged] epoll-optimize-epoll_ctl_del-using-rcu-fix.patch removed from -mm tree
To: jbaron@akamai.com,davidel@xmailserver.org,fengguang.wu@intel.com,nelhage@nelhage.com,normalperson@yhbt.net,nzimmer@sgi.com,paulmck@us.ibm.com,viro@zeniv.linux.org.uk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 12 Nov 2013 14:41:36 -0800


The patch titled
     Subject: epoll: remove the on_list check for 'struct epitem'
has been removed from the -mm tree.  Its filename was
     epoll-optimize-epoll_ctl_del-using-rcu-fix.patch

This patch was dropped because it was folded into epoll-optimize-epoll_ctl_del-using-rcu.patch

------------------------------------------------------
From: Jason Baron <jbaron@akamai.com>
Subject: epoll: remove the on_list check for 'struct epitem'

By removing the 'int on_list' field from 'struct epitem', we avoid hitting
the BUILD_BUG_ON() for 'struct epitem' being larger than 128 bytes.

In file included from include/linux/init.h:4:0,
                 from fs/eventpoll.c:14:
fs/eventpoll.c: In function 'eventpoll_init':
include/linux/compiler.h:321:20: error: call to '__compiletime_assert_2137' declared with attribute error: BUILD_BUG_ON failed: sizeof(void *) <= 8 && sizeof(struct epitem) > 128
    prefix ## suffix();    \

The check to make sure that the 'struct epitem' was actually linked via
epi->fllink was added to avoid having the list removal primitives called
twice for the same 'struct epitem'.  However, the double call possibility
was removed by 'Subject: epoll: optimize EPOLL_CTL_DEL using rcu'.  There,
the call to 'list_del_init()' in eventpoll_release_file() was removed (we
now rely on the list delete happening entirely in 'ep_remove()', which is
called from eventpoll_release_file()).

There is also the question as to whether multiple ep_remove() calls could
happen concurrently.  This can not happen since EPOLL_CTL_DEL can't race
with eventpoll_release_file() or ep_free() - it has to do an fget() to
proceed.  Further, eventpoll_release_file() can not race with ep_free(),
since they both acquire the 'epmutex'.

Signed-off-by: Jason Baron <jbaron@akamai.com>
Reported-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Nathan Zimmer <nzimmer@sgi.com>
Cc: Eric Wong <normalperson@yhbt.net>
Cc: Nelson Elhage <nelhage@nelhage.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Davide Libenzi <davidel@xmailserver.org>
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventpoll.c |   13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff -puN fs/eventpoll.c~epoll-optimize-epoll_ctl_del-using-rcu-fix fs/eventpoll.c
--- a/fs/eventpoll.c~epoll-optimize-epoll_ctl_del-using-rcu-fix
+++ a/fs/eventpoll.c
@@ -170,9 +170,6 @@ struct epitem {
 
 	/* The structure that describe the interested events and the source fd */
 	struct epoll_event event;
-
-	/* The fllink is in use. Since rcu can't do 'list_del_init()' */
-	int on_list;
 };
 
 /*
@@ -706,10 +703,7 @@ static int ep_remove(struct eventpoll *e
 
 	/* Remove the current item from the list of epoll hooks */
 	spin_lock(&file->f_lock);
-	if (epi->on_list) {
-		list_del_rcu(&epi->fllink);
-		epi->on_list = 0;
-	}
+	list_del_rcu(&epi->fllink);
 	spin_unlock(&file->f_lock);
 
 	rb_erase(&epi->rbn, &ep->rbr);
@@ -1272,7 +1266,6 @@ static int ep_insert(struct eventpoll *e
 	epi->event = *event;
 	epi->nwait = 0;
 	epi->next = EP_UNACTIVE_PTR;
-	epi->on_list = 0;
 	if (epi->event.events & EPOLLWAKEUP) {
 		error = ep_create_wakeup_source(epi);
 		if (error)
@@ -1306,7 +1299,6 @@ static int ep_insert(struct eventpoll *e
 	/* Add the current item to the list of active epoll hook for this file */
 	spin_lock(&tfile->f_lock);
 	list_add_tail_rcu(&epi->fllink, &tfile->f_ep_links);
-	epi->on_list = 1;
 	spin_unlock(&tfile->f_lock);
 
 	/*
@@ -1347,8 +1339,7 @@ static int ep_insert(struct eventpoll *e
 
 error_remove_epi:
 	spin_lock(&tfile->f_lock);
-	if (epi->on_list)
-		list_del_rcu(&epi->fllink);
+	list_del_rcu(&epi->fllink);
 	spin_unlock(&tfile->f_lock);
 
 	rb_erase(&epi->rbn, &ep->rbr);
_

Patches currently in -mm which might be from jbaron@akamai.com are

epoll-optimize-epoll_ctl_del-using-rcu.patch
epoll-do-not-take-global-epmutex-for-simple-topologies.patch
epoll-do-not-take-global-epmutex-for-simple-topologies-fix.patch

