From: akpm@linux-foundation.org
Subject: + epoll-use-rcu-to-protect-wakeup_source-in-epitem.patch added to -mm tree
Date: Mon, 11 Mar 2013 16:49:33 -0700
Message-ID: <20130311234933.89AA05A4265@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f202.google.com ([209.85.128.202]:64611 "EHLO
	mail-ve0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754178Ab3CKXtg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Mar 2013 19:49:36 -0400
Received: by mail-ve0-f202.google.com with SMTP id m1so444677ves.3
        for <mm-commits@vger.kernel.org>; Mon, 11 Mar 2013 16:49:35 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: normalperson@yhbt.net, arve@android.com, davidel@xmailserver.org, eric.dumazet@gmail.com, neilb@suse.de, oleg@redhat.com, paulmck@us.ibm.com, rjw@sisk.pl, viro@zeniv.linux.org.uk


The patch titled
     Subject: epoll: use RCU to protect wakeup_source in epitem
has been added to the -mm tree.  Its filename is
     epoll-use-rcu-to-protect-wakeup_source-in-epitem.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
=46rom: Eric Wong <normalperson@yhbt.net>
Subject: epoll: use RCU to protect wakeup_source in epitem

This prevents wakeup_source destruction when a user hits the item with
EPOLL_CTL_MOD while ep_poll_callback is running.

Tested with CONFIG_SPARSE_RCU_POINTER=3Dy and "make fs/eventpoll.o C=3D=
2"

Signed-off-by: Eric Wong <normalperson@yhbt.net>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Arve Hj=F8nnev=E5g <arve@android.com>
Cc: Davide Libenzi <davidel@xmailserver.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: NeilBrown <neilb@suse.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventpoll.c |   92 ++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 71 insertions(+), 21 deletions(-)

diff -puN fs/eventpoll.c~epoll-use-rcu-to-protect-wakeup_source-in-epit=
em fs/eventpoll.c
--- a/fs/eventpoll.c~epoll-use-rcu-to-protect-wakeup_source-in-epitem
+++ a/fs/eventpoll.c
@@ -159,7 +159,7 @@ struct epitem {
 	struct list_head fllink;
=20
 	/* wakeup_source used when EPOLLWAKEUP is set */
-	struct wakeup_source *ws;
+	struct wakeup_source __rcu *ws;
=20
 	/* The structure that describe the interested events and the source f=
d */
 	struct epoll_event event;
@@ -537,6 +537,38 @@ static void ep_unregister_pollwait(struc
 	}
 }
=20
+/* call only when ep->mtx is held */
+static inline struct wakeup_source *ep_wakeup_source(struct epitem *ep=
i)
+{
+	return rcu_dereference_check(epi->ws, lockdep_is_held(&epi->ep->mtx))=
;
+}
+
+/* call only when ep->mtx is held */
+static inline void ep_pm_stay_awake(struct epitem *epi)
+{
+	struct wakeup_source *ws =3D ep_wakeup_source(epi);
+
+	if (ws)
+		__pm_stay_awake(ws);
+}
+
+static inline bool ep_has_wakeup_source(struct epitem *epi)
+{
+	return rcu_access_pointer(epi->ws) ? true : false;
+}
+
+/* call when ep->mtx cannot be held (ep_poll_callback) */
+static inline void ep_pm_stay_awake_rcu(struct epitem *epi)
+{
+	struct wakeup_source *ws;
+
+	rcu_read_lock();
+	ws =3D rcu_dereference(epi->ws);
+	if (ws)
+		__pm_stay_awake(ws);
+	rcu_read_unlock();
+}
+
 /**
  * ep_scan_ready_list - Scans the ready list in a way that makes possi=
ble for
  *                      the scan code, to call f_op->poll(). Also allo=
ws for
@@ -600,7 +632,7 @@ static int ep_scan_ready_list(struct eve
 		 */
 		if (!ep_is_linked(&epi->rdllink)) {
 			list_add_tail(&epi->rdllink, &ep->rdllist);
-			__pm_stay_awake(epi->ws);
+			ep_pm_stay_awake(epi);
 		}
 	}
 	/*
@@ -669,7 +701,7 @@ static int ep_remove(struct eventpoll *e
 		list_del_init(&epi->rdllink);
 	spin_unlock_irqrestore(&ep->lock, flags);
=20
-	wakeup_source_unregister(epi->ws);
+	wakeup_source_unregister(ep_wakeup_source(epi));
=20
 	/* At this point it is safe to free the eventpoll item */
 	kmem_cache_free(epi_cache, epi);
@@ -783,7 +815,7 @@ static int ep_read_events_proc(struct ev
 			 * callback, but it's not actually ready, as far as
 			 * caller requested events goes. We can remove it here.
 			 */
-			__pm_relax(epi->ws);
+			__pm_relax(ep_wakeup_source(epi));
 			list_del_init(&epi->rdllink);
 		}
 	}
@@ -1015,7 +1047,7 @@ static int ep_poll_callback(wait_queue_t
 	/* If this file is already in the ready list we exit soon */
 	if (!ep_is_linked(&epi->rdllink)) {
 		list_add_tail(&epi->rdllink, &ep->rdllist);
-		__pm_stay_awake(epi->ws);
+		ep_pm_stay_awake(epi);
 	}
=20
 	/*
@@ -1175,6 +1207,7 @@ static int reverse_path_check(void)
 static int ep_create_wakeup_source(struct epitem *epi)
 {
 	const char *name;
+	struct wakeup_source *ws;
=20
 	if (!epi->ep->ws) {
 		epi->ep->ws =3D wakeup_source_register("eventpoll");
@@ -1183,17 +1216,29 @@ static int ep_create_wakeup_source(struc
 	}
=20
 	name =3D epi->ffd.file->f_path.dentry->d_name.name;
-	epi->ws =3D wakeup_source_register(name);
-	if (!epi->ws)
+	ws =3D wakeup_source_register(name);
+
+	if (!ws)
 		return -ENOMEM;
+	rcu_assign_pointer(epi->ws, ws);
=20
 	return 0;
 }
=20
-static void ep_destroy_wakeup_source(struct epitem *epi)
+/* rare code path, only used when EPOLL_CTL_MOD removes a wakeup sourc=
e */
+static noinline void ep_destroy_wakeup_source(struct epitem *epi)
 {
-	wakeup_source_unregister(epi->ws);
-	epi->ws =3D NULL;
+	struct wakeup_source *ws =3D ep_wakeup_source(epi);
+
+	rcu_assign_pointer(epi->ws, NULL);
+
+	/*
+	 * wait for ep_pm_stay_awake_rcu to finish, synchronize_rcu is
+	 * used internally by wakeup_source_remove, too (called by
+	 * wakeup_source_unregister), so we cannot use call_rcu
+	 */
+	synchronize_rcu();
+	wakeup_source_unregister(ws);
 }
=20
 /*
@@ -1228,7 +1273,7 @@ static int ep_insert(struct eventpoll *e
 		if (error)
 			goto error_create_wakeup_source;
 	} else {
-		epi->ws =3D NULL;
+		RCU_INIT_POINTER(epi->ws, NULL);
 	}
=20
 	/* Initialize the poll table using the queue callback */
@@ -1276,7 +1321,7 @@ static int ep_insert(struct eventpoll *e
 	/* If the file is already "ready" we drop it inside the ready list */
 	if ((revents & event->events) && !ep_is_linked(&epi->rdllink)) {
 		list_add_tail(&epi->rdllink, &ep->rdllist);
-		__pm_stay_awake(epi->ws);
+		ep_pm_stay_awake(epi);
=20
 		/* Notify waiting tasks that events are available */
 		if (waitqueue_active(&ep->wq))
@@ -1317,7 +1362,7 @@ error_unregister:
 		list_del_init(&epi->rdllink);
 	spin_unlock_irqrestore(&ep->lock, flags);
=20
-	wakeup_source_unregister(epi->ws);
+	wakeup_source_unregister(ep_wakeup_source(epi));
=20
 error_create_wakeup_source:
 	kmem_cache_free(epi_cache, epi);
@@ -1346,9 +1391,9 @@ static int ep_modify(struct eventpoll *e
 	pt._key =3D event->events;
 	epi->event.data =3D event->data; /* protected by mtx */
 	if (epi->event.events & EPOLLWAKEUP) {
-		if (!epi->ws)
+		if (!ep_has_wakeup_source(epi))
 			ep_create_wakeup_source(epi);
-	} else if (epi->ws) {
+	} else if (ep_has_wakeup_source(epi)) {
 		ep_destroy_wakeup_source(epi);
 	}
=20
@@ -1386,7 +1431,7 @@ static int ep_modify(struct eventpoll *e
 		spin_lock_irq(&ep->lock);
 		if (!ep_is_linked(&epi->rdllink)) {
 			list_add_tail(&epi->rdllink, &ep->rdllist);
-			__pm_stay_awake(epi->ws);
+			ep_pm_stay_awake(epi);
=20
 			/* Notify waiting tasks that events are available */
 			if (waitqueue_active(&ep->wq))
@@ -1412,6 +1457,7 @@ static int ep_send_events_proc(struct ev
 	unsigned int revents;
 	struct epitem *epi;
 	struct epoll_event __user *uevent;
+	struct wakeup_source *ws;
 	poll_table pt;
=20
 	init_poll_funcptr(&pt, NULL);
@@ -1434,9 +1480,13 @@ static int ep_send_events_proc(struct ev
 		 * instead, but then epi->ws would temporarily be out of sync
 		 * with ep_is_linked().
 		 */
-		if (epi->ws && epi->ws->active)
-			__pm_stay_awake(ep->ws);
-		__pm_relax(epi->ws);
+		ws =3D ep_wakeup_source(epi);
+		if (ws) {
+			if (ws->active)
+				__pm_stay_awake(ep->ws);
+			__pm_relax(ws);
+		}
+
 		list_del_init(&epi->rdllink);
=20
 		pt._key =3D epi->event.events;
@@ -1453,7 +1503,7 @@ static int ep_send_events_proc(struct ev
 			if (__put_user(revents, &uevent->events) ||
 			    __put_user(epi->event.data, &uevent->data)) {
 				list_add(&epi->rdllink, head);
-				__pm_stay_awake(epi->ws);
+				ep_pm_stay_awake(epi);
 				return eventcnt ? eventcnt : -EFAULT;
 			}
 			eventcnt++;
@@ -1473,7 +1523,7 @@ static int ep_send_events_proc(struct ev
 				 * poll callback will queue them in ep->ovflist.
 				 */
 				list_add_tail(&epi->rdllink, &ep->rdllist);
-				__pm_stay_awake(epi->ws);
+				ep_pm_stay_awake(epi);
 			}
 		}
 	}
_

Patches currently in -mm which might be from normalperson@yhbt.net are

epoll-trim-epitem-by-one-cache-line-on-x86_64.patch
epoll-trim-epitem-by-one-cache-line-on-x86_64-fix.patch
epoll-use-rcu-to-protect-wakeup_source-in-epitem.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
