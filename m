From: akpm@linux-foundation.org
Subject: + epoll-fix-compiler-warning-and-optimize-the-non-blocking-path-fix.patch added to -mm tree
Date: Wed, 26 Jan 2011 11:08:26 -0800
Message-ID: <201101261908.p0QJ8QnP031535@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56850 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751728Ab1AZTJG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Jan 2011 14:09:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@cmpxchg.org, davidel@xmailserver.org, shawn.bohrer@gmail.com


The patch titled
     epoll-fix-compiler-warning-and-optimize-the-non-blocking-path-fix
has been added to the -mm tree.  Its filename is
     epoll-fix-compiler-warning-and-optimize-the-non-blocking-path-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: epoll-fix-compiler-warning-and-optimize-the-non-blocking-path-fix
From: Johannes Weiner <hannes@cmpxchg.org>

The non-blocking ep_poll path optimization introduced skipping over the
return value setup.

Initialize it properly, my userspace gets upset by epoll_wait() returning
random things.

In addition, remove the reinitialization at the fetch_events label, the
return value is garuanteed to be zero when execution reaches there.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Shawn Bohrer <shawn.bohrer@gmail.com>
Acked-by: Davide Libenzi <davidel@xmailserver.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventpoll.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN fs/eventpoll.c~epoll-fix-compiler-warning-and-optimize-the-non-blocking-path-fix fs/eventpoll.c
--- a/fs/eventpoll.c~epoll-fix-compiler-warning-and-optimize-the-non-blocking-path-fix
+++ a/fs/eventpoll.c
@@ -1147,7 +1147,7 @@ static int ep_send_events(struct eventpo
 static int ep_poll(struct eventpoll *ep, struct epoll_event __user *events,
 		   int maxevents, long timeout)
 {
-	int res, eavail, timed_out = 0;
+	int res = 0, eavail, timed_out = 0;
 	unsigned long flags;
 	long slack = 0;
 	wait_queue_t wait;
@@ -1173,7 +1173,6 @@ static int ep_poll(struct eventpoll *ep,
 fetch_events:
 	spin_lock_irqsave(&ep->lock, flags);
 
-	res = 0;
 	if (!ep_events_available(ep)) {
 		/*
 		 * We don't have any available event to return to the caller.
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-fix-deferred-congestion-timeout-if-preferred-zone-is-not-allowed.patch
mm-clear-pages_scanned-only-if-draining-a-pcp-adds-pages-to-the-buddy-allocator.patch
memcg-fix-account-leak-at-failure-of-memsw-acconting.patch
memcg-bugfix-check-mem_cgroup_disabled-at-split-fixup.patch
memcg-fix-race-at-move_parent-around-compound_order.patch
epoll-fix-compiler-warning-and-optimize-the-non-blocking-path-fix.patch

