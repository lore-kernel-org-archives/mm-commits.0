From: akpm@linux-foundation.org
Subject: + epoll-do-not-take-the-nested-ep-mtx-on-epoll_ctl_del.patch
 added to -mm tree
Date: Thu, 26 Dec 2013 14:19:21 -0800
Message-ID: <52bcab69.OZ6L0ERTqrPvM/kq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39072 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753445Ab3LZWTW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 26 Dec 2013 17:19:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, paulmck@us.ibm.com, nzimmer@sgi.com, normalperson@yhbt.net, nelhage@nelhage.com, davidel@xmailserver.org, jbaron@akamai.com

Subject: + epoll-do-not-take-the-nested-ep-mtx-on-epoll_ctl_del.patch added to -mm tree
To: jbaron@akamai.com,davidel@xmailserver.org,nelhage@nelhage.com,normalperson@yhbt.net,nzimmer@sgi.com,paulmck@us.ibm.com,viro@zeniv.linux.org.uk
From: akpm@linux-foundation.org
Date: Thu, 26 Dec 2013 14:19:21 -0800


The patch titled
     Subject: epoll: do not take the nested ep->mtx on EPOLL_CTL_DEL
has been added to the -mm tree.  Its filename is
     epoll-do-not-take-the-nested-ep-mtx-on-epoll_ctl_del.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/epoll-do-not-take-the-nested-ep-mtx-on-epoll_ctl_del.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/epoll-do-not-take-the-nested-ep-mtx-on-epoll_ctl_del.patch

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
Subject: epoll: do not take the nested ep->mtx on EPOLL_CTL_DEL

The EPOLL_CTL_DEL path of epoll contains a classic, ab-ba deadlock.  That
is, epoll_ctl(a, EPOLL_CTL_DEL, b, x), will deadlock with epoll_ctl(b,
EPOLL_CTL_DEL, a, x).  The deadlock was introduced with commmit
67347fe4e6326 ("epoll: do not take global 'epmutex' for simple
topologies").

The acquistion of the ep->mtx for the destination 'ep' was added such that
a concurrent EPOLL_CTL_ADD operation would see the correct state of the
ep.  (Specifically, the check for '!list_empty(&f.file->f_ep_links'.)
However, by simply not acquiring the lock, we do not serialize behind the
ep->mtx from the add path, and thus may perform a full path check when if
we had waited a little longer it may not have been necessary.  However,
this is a transient state, and performing the full loop checking in this
case is not harmful.

The important point is that we wouldn't miss doing the full loop checking
when required, since EPOLL_CTL_ADD always locks any 'ep's that its
operating upon.  The reason we don't need to do lock ordering in the add
path, is that we are already are holding the global 'epmutex' whenever we
do the double lock.  Further, the original posting of this patch, which
was tested for the intended performance gains, did not perform this
additional locking.

Signed-off-by: Jason Baron <jbaron@akamai.com>
Cc: Nathan Zimmer <nzimmer@sgi.com>
Cc: Eric Wong <normalperson@yhbt.net>
Cc: Nelson Elhage <nelhage@nelhage.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Davide Libenzi <davidel@xmailserver.org>
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventpoll.c |    4 ----
 1 file changed, 4 deletions(-)

diff -puN fs/eventpoll.c~epoll-do-not-take-the-nested-ep-mtx-on-epoll_ctl_del fs/eventpoll.c
--- a/fs/eventpoll.c~epoll-do-not-take-the-nested-ep-mtx-on-epoll_ctl_del
+++ a/fs/eventpoll.c
@@ -1907,10 +1907,6 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, in
 			}
 		}
 	}
-	if (op == EPOLL_CTL_DEL && is_file_epoll(tf.file)) {
-		tep = tf.file->private_data;
-		mutex_lock_nested(&tep->mtx, 1);
-	}
 
 	/*
 	 * Try to lookup the file inside our RB tree, Since we grabbed "mtx"
_

Patches currently in -mm which might be from jbaron@akamai.com are

epoll-do-not-take-the-nested-ep-mtx-on-epoll_ctl_del.patch
lib-parserc-add-match_wildcard-function.patch
dynamic_debug-add-wildcard-support-to-filter-files-functions-modules.patch
dynamic-debug-howtotxt-update-since-new-wildcard-support.patch
linux-next.patch

