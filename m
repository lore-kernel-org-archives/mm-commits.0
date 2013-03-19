From: akpm@linux-foundation.org
Subject: + epoll-lock-ep-mtx-in-ep_free-to-silence-lockdep.patch added to -mm tree
Date: Tue, 19 Mar 2013 14:17:04 -0700
Message-ID: <20130319211704.87C0A31C1FB@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:59545 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934272Ab3CSVRG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Mar 2013 17:17:06 -0400
Received: by mail-qa0-f73.google.com with SMTP id g10so102201qah.2
        for <mm-commits@vger.kernel.org>; Tue, 19 Mar 2013 14:17:05 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: normalperson@yhbt.net, arve@android.com, davidel@xmailserver.org, eric.dumazet@gmail.com, neilb@suse.de, oleg@redhat.com, rjw@sisk.pl, viro@zeniv.linux.org.uk


The patch titled
     Subject: epoll: lock ep->mtx in ep_free to silence lockdep
has been added to the -mm tree.  Its filename is
     epoll-lock-ep-mtx-in-ep_free-to-silence-lockdep.patch

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
@@ -776,11 +776,15 @@ static void ep_free(struct eventpoll *ep
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

epoll-trim-epitem-by-one-cache-line-on-x86_64.patch
epoll-trim-epitem-by-one-cache-line-on-x86_64-fix.patch
epoll-trim-epitem-by-one-cache-line-on-x86_64-fix-fix.patch
epoll-use-rcu-to-protect-wakeup_source-in-epitem.patch
epoll-lock-ep-mtx-in-ep_free-to-silence-lockdep.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
