From: akpm@linux-foundation.org
Subject: + epoll-cleanup-use-rcu_init_pointer-when-nulling.patch added to -mm tree
Date: Wed, 24 Apr 2013 15:55:15 -0700
Message-ID: <20130424225515.6F75D31C19E@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:63656 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757971Ab3DXWzQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 24 Apr 2013 18:55:16 -0400
Received: by mail-vc0-f201.google.com with SMTP id hz11so256778vcb.0
        for <mm-commits@vger.kernel.org>; Wed, 24 Apr 2013 15:55:15 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: normalperson@yhbt.net


The patch titled
     Subject: epoll: cleanup: use RCU_INIT_POINTER when nulling
has been added to the -mm tree.  Its filename is
     epoll-cleanup-use-rcu_init_pointer-when-nulling.patch

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
Subject: epoll: cleanup: use RCU_INIT_POINTER when nulling

It is always safe to use RCU_INIT_POINTER to NULL a pointer.  This results
in slightly smaller/faster code.

Signed-off-by: Eric Wong <normalperson@yhbt.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventpoll.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/eventpoll.c~epoll-cleanup-use-rcu_init_pointer-when-nulling fs/eventpoll.c
--- a/fs/eventpoll.c~epoll-cleanup-use-rcu_init_pointer-when-nulling
+++ a/fs/eventpoll.c
@@ -1214,7 +1214,7 @@ static noinline void ep_destroy_wakeup_s
 {
 	struct wakeup_source *ws = ep_wakeup_source(epi);
 
-	rcu_assign_pointer(epi->ws, NULL);
+	RCU_INIT_POINTER(epi->ws, NULL);
 
 	/*
 	 * wait for ep_pm_stay_awake_rcu to finish, synchronize_rcu is
_

Patches currently in -mm which might be from normalperson@yhbt.net are

epoll-trim-epitem-by-one-cache-line-on-x86_64.patch
epoll-trim-epitem-by-one-cache-line-on-x86_64-fix.patch
epoll-trim-epitem-by-one-cache-line-on-x86_64-fix-fix.patch
epoll-use-rcu-to-protect-wakeup_source-in-epitem.patch
epoll-use-rcu-to-protect-wakeup_source-in-epitem-fix.patch
epoll-lock-ep-mtx-in-ep_free-to-silence-lockdep.patch
epoll-cleanup-hoist-out-f_op-poll-calls.patch
epoll-cleanup-use-rcu_init_pointer-when-nulling.patch

