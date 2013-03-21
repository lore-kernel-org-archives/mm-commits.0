From: akpm@linux-foundation.org
Subject: + epoll-use-rcu-to-protect-wakeup_source-in-epitem-fix.patch added to -mm tree
Date: Thu, 21 Mar 2013 12:27:48 -0700
Message-ID: <20130321192748.6D86F31C23C@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:56081 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752171Ab3CUT1t (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Mar 2013 15:27:49 -0400
Received: by mail-qa0-f74.google.com with SMTP id k4so80207qaq.5
        for <mm-commits@vger.kernel.org>; Thu, 21 Mar 2013 12:27:48 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: normalperson@yhbt.net


The patch titled
     Subject: epoll: fix suspicious RCU usage in ep_poll_callback
has been added to the -mm tree.  Its filename is
     epoll-use-rcu-to-protect-wakeup_source-in-epitem-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Eric Wong <normalperson@yhbt.net>
Subject: epoll: fix suspicious RCU usage in ep_poll_callback

The commit "epoll: use RCU to protect wakeup_source in epitem"
introduced the ep_pm_stay_awake_rcu function for ep_poll_callback
use, but I left it unused on accident.  ep->mtx cannot be held in
ep_poll_callback, so RCU should be used here.

Signed-off-by: Eric Wong <normalperson@yhbt.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventpoll.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/eventpoll.c~epoll-use-rcu-to-protect-wakeup_source-in-epitem-fix fs/eventpoll.c
--- a/fs/eventpoll.c~epoll-use-rcu-to-protect-wakeup_source-in-epitem-fix
+++ a/fs/eventpoll.c
@@ -1049,7 +1049,7 @@ static int ep_poll_callback(wait_queue_t
 	/* If this file is already in the ready list we exit soon */
 	if (!ep_is_linked(&epi->rdllink)) {
 		list_add_tail(&epi->rdllink, &ep->rdllist);
-		ep_pm_stay_awake(epi);
+		ep_pm_stay_awake_rcu(epi);
 	}
 
 	/*
_

Patches currently in -mm which might be from normalperson@yhbt.net are

epoll-trim-epitem-by-one-cache-line-on-x86_64.patch
epoll-trim-epitem-by-one-cache-line-on-x86_64-fix.patch
epoll-trim-epitem-by-one-cache-line-on-x86_64-fix-fix.patch
epoll-use-rcu-to-protect-wakeup_source-in-epitem.patch
epoll-use-rcu-to-protect-wakeup_source-in-epitem-fix.patch
epoll-lock-ep-mtx-in-ep_free-to-silence-lockdep.patch
epoll-cleanup-hoist-out-f_op-poll-calls.patch

