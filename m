From: akpm@linux-foundation.org
Subject: + epoll-add-a-reschedule-point-in-ep_free.patch added to -mm tree
Date: Tue, 20 Aug 2013 12:58:30 -0700
Message-ID: <5213ca66.yhnLdDsjNiJIHjNE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36883 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130Ab3HTT6b (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 20 Aug 2013 15:58:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@ZenIV.linux.org.uk, tytso@mit.edu, edumazet@google.com

Subject: + epoll-add-a-reschedule-point-in-ep_free.patch added to -mm tree
To: edumazet@google.com,tytso@mit.edu,viro@ZenIV.linux.org.uk
From: akpm@linux-foundation.org
Date: Tue, 20 Aug 2013 12:58:30 -0700


The patch titled
     Subject: epoll: add a reschedule point in ep_free()
has been added to the -mm tree.  Its filename is
     epoll-add-a-reschedule-point-in-ep_free.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/epoll-add-a-reschedule-point-in-ep_free.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/epoll-add-a-reschedule-point-in-ep_free.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Eric Dumazet <edumazet@google.com>
Subject: epoll: add a reschedule point in ep_free()

ep_free() might iterate on a huge set of epitems and hold cpu too long. 
Add two cond_resched() in order to yield cpu to other tasks.  This is safe
as we only hold mutexes in this function.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventpoll.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN fs/eventpoll.c~epoll-add-a-reschedule-point-in-ep_free fs/eventpoll.c
--- a/fs/eventpoll.c~epoll-add-a-reschedule-point-in-ep_free
+++ a/fs/eventpoll.c
@@ -740,6 +740,7 @@ static void ep_free(struct eventpoll *ep
 		epi = rb_entry(rbp, struct epitem, rbn);
 
 		ep_unregister_pollwait(ep, epi);
+		cond_resched();
 	}
 
 	/*
@@ -754,6 +755,7 @@ static void ep_free(struct eventpoll *ep
 	while ((rbp = rb_first(&ep->rbr)) != NULL) {
 		epi = rb_entry(rbp, struct epitem, rbn);
 		ep_remove(ep, epi);
+		cond_resched();
 	}
 	mutex_unlock(&ep->mtx);
 
_

Patches currently in -mm which might be from edumazet@google.com are

epoll-add-a-reschedule-point-in-ep_free.patch
linux-next.patch

