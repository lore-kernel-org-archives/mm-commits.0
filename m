From: akpm@linux-foundation.org
Subject: [merged] epoll-cleanup-use-rcu_init_pointer-when-nulling.patch removed from -mm tree
Date: Tue, 07 May 2013 10:48:18 -0700
Message-ID: <20130507174818.739EA5A4174@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:64636 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757701Ab3EGRsT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 13:48:19 -0400
Received: by mail-vc0-f201.google.com with SMTP id hz10so85205vcb.4
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 10:48:18 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: normalperson@yhbt.net, mm-commits@vger.kernel.org


The patch titled
     Subject: epoll: cleanup: use RCU_INIT_POINTER when nulling
has been removed from the -mm tree.  Its filename was
     epoll-cleanup-use-rcu_init_pointer-when-nulling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -1213,7 +1213,7 @@ static noinline void ep_destroy_wakeup_s
 {
 	struct wakeup_source *ws = ep_wakeup_source(epi);
 
-	rcu_assign_pointer(epi->ws, NULL);
+	RCU_INIT_POINTER(epi->ws, NULL);
 
 	/*
 	 * wait for ep_pm_stay_awake_rcu to finish, synchronize_rcu is
_

Patches currently in -mm which might be from normalperson@yhbt.net are

origin.patch

