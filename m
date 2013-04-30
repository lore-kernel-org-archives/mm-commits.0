From: akpm@linux-foundation.org
Subject: [folded-merged] epoll-use-rcu-to-protect-wakeup_source-in-epitem-fix.patch removed from -mm tree
Date: Tue, 30 Apr 2013 15:16:11 -0700
Message-ID: <20130430221611.E51235A4082@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f73.google.com ([209.85.128.73]:46100 "EHLO
	mail-qe0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761088Ab3D3WQN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 18:16:13 -0400
Received: by mail-qe0-f73.google.com with SMTP id 9so113796qea.4
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 15:16:12 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: normalperson@yhbt.net, mm-commits@vger.kernel.org


The patch titled
     Subject: epoll: fix suspicious RCU usage in ep_poll_callback
has been removed from the -mm tree.  Its filename was
     epoll-use-rcu-to-protect-wakeup_source-in-epitem-fix.patch

This patch was dropped because it was folded into epoll-use-rcu-to-protect-wakeup_source-in-epitem.patch

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
@@ -1019,7 +1019,7 @@ static int ep_poll_callback(wait_queue_t
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
epoll-use-rcu-to-protect-wakeup_source-in-epitem.patch
epoll-lock-ep-mtx-in-ep_free-to-silence-lockdep.patch
epoll-cleanup-hoist-out-f_op-poll-calls.patch
epoll-cleanup-use-rcu_init_pointer-when-nulling.patch

