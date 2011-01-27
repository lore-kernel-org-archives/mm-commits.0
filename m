From: akpm@linux-foundation.org
Subject: + epoll-epoll_wait-should-not-use-timespec_add_ns.patch added to -mm tree
Date: Thu, 27 Jan 2011 15:40:38 -0800
Message-ID: <201101272340.p0RNecZH006535@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50173 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751874Ab1A0XlM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 27 Jan 2011 18:41:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: eric.dumazet@gmail.com, akpm@linux-foundation.org, davidel@xmailserver.org, shawn.bohrer@gmail.com, sim@hostway.ca, stable@kernel.org


The patch titled
     epoll: epoll_wait() should not use timespec_add_ns()
has been added to the -mm tree.  Its filename is
     epoll-epoll_wait-should-not-use-timespec_add_ns.patch

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
Subject: epoll: epoll_wait() should not use timespec_add_ns()
From: Eric Dumazet <eric.dumazet@gmail.com>

commit 95aac7b1cd224f ("epoll: make epoll_wait() use the hrtimer range
feature") added a performance regression because it uses timespec_add_ns()
with potential very large 'ns' values.

Reported-by: Simon Kirby <sim@hostway.ca>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Shawn Bohrer <shawn.bohrer@gmail.com>
Cc: Davide Libenzi <davidel@xmailserver.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: <stable@kernel.org>		[2.6.37.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventpoll.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff -puN fs/eventpoll.c~epoll-epoll_wait-should-not-use-timespec_add_ns fs/eventpoll.c
--- a/fs/eventpoll.c~epoll-epoll_wait-should-not-use-timespec_add_ns
+++ a/fs/eventpoll.c
@@ -1114,6 +1114,17 @@ static int ep_send_events(struct eventpo
 	return ep_scan_ready_list(ep, ep_send_events_proc, &esed);
 }
 
+static inline struct timespec epoll_set_mstimeout(long ms)
+{
+	struct timespec now, ts = {
+		.tv_sec = ms / MSEC_PER_SEC,
+		.tv_nsec = NSEC_PER_MSEC * (ms % MSEC_PER_SEC),
+	};
+
+	ktime_get_ts(&now);
+	return timespec_add_safe(now, ts);
+}
+
 static int ep_poll(struct eventpoll *ep, struct epoll_event __user *events,
 		   int maxevents, long timeout)
 {
@@ -1121,12 +1132,11 @@ static int ep_poll(struct eventpoll *ep,
 	unsigned long flags;
 	long slack;
 	wait_queue_t wait;
-	struct timespec end_time;
 	ktime_t expires, *to = NULL;
 
 	if (timeout > 0) {
-		ktime_get_ts(&end_time);
-		timespec_add_ns(&end_time, (u64)timeout * NSEC_PER_MSEC);
+		struct timespec end_time = epoll_set_mstimeout(timeout);
+
 		slack = select_estimate_accuracy(&end_time);
 		to = &expires;
 		*to = timespec_to_ktime(end_time);
_

Patches currently in -mm which might be from eric.dumazet@gmail.com are

origin.patch
epoll-epoll_wait-should-not-use-timespec_add_ns.patch
mm-numa-aware-alloc_task_struct_node.patch
mm-numa-aware-alloc_thread_info_node.patch
kthread-numa-aware-kthread_create_on_cpu.patch
kthread-use-kthread_create_on_cpu.patch
net-convert-%p-usage-to-%pk.patch

