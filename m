From: akpm@linux-foundation.org
Subject: [merged] epoll-lock-ep-mtx-in-ep_free-to-silence-lockdep.patch removed from -mm tree
Date: Tue, 07 May 2013 10:48:11 -0700
Message-ID: <20130507174811.8F8E35A4174@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:48088 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759293Ab3EGRsN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 13:48:13 -0400
Received: by mail-vc0-f201.google.com with SMTP id hz10so85336vcb.0
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 10:48:13 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: normalperson@yhbt.net, arve@android.com, davidel@xmailserver.org, eric.dumazet@gmail.com, neilb@suse.de, oleg@redhat.com, rjw@sisk.pl, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: epoll: lock ep->mtx in ep_free to silence lockdep
has been removed from the -mm tree.  Its filename was
     epoll-lock-ep-mtx-in-ep_free-to-silence-lockdep.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

------------------------------------------------------
=46rom: Eric Wong <normalperson@yhbt.net>
Subject: epoll: lock ep->mtx in ep_free to silence lockdep

Technically we do not need to hold ep->mtx during ep_free since we are
certain there are no other users of ep at that point.  However, lockdep
complains with a "suspicious rcu_dereference_check() usage!" message; s=
o
lock the mutex before ep_remove to silence the warning.

Signed-off-by: Eric Wong <normalperson@yhbt.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Arve Hj=F8nnev=E5g <arve@android.com>
Cc: Davide Libenzi <davidel@xmailserver.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: NeilBrown <neilb@suse.de>,
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventpoll.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN fs/eventpoll.c~epoll-lock-ep-mtx-in-ep_free-to-silence-lockde=
p fs/eventpoll.c
--- a/fs/eventpoll.c~epoll-lock-ep-mtx-in-ep_free-to-silence-lockdep
+++ a/fs/eventpoll.c
@@ -745,11 +745,15 @@ static void ep_free(struct eventpoll *ep
 	 * point we are sure no poll callbacks will be lingering around, and =
also by
 	 * holding "epmutex" we can be sure that no file cleanup code will hi=
t
 	 * us during this operation. So we can avoid the lock on "ep->lock".
+	 * We do not need to lock ep->mtx, either, we only do it to prevent
+	 * a lockdep warning.
 	 */
+	mutex_lock(&ep->mtx);
 	while ((rbp =3D rb_first(&ep->rbr)) !=3D NULL) {
 		epi =3D rb_entry(rbp, struct epitem, rbn);
 		ep_remove(ep, epi);
 	}
+	mutex_unlock(&ep->mtx);
=20
 	mutex_unlock(&epmutex);
 	mutex_destroy(&ep->mtx);
_

Patches currently in -mm which might be from normalperson@yhbt.net are

origin.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
