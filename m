Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96F1FC35296
	for <mm-commits@archiver.kernel.org>; Sun, 20 Dec 2020 02:59:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D3DD23B05
	for <mm-commits@archiver.kernel.org>; Sun, 20 Dec 2020 02:59:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727034AbgLTC66 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 19 Dec 2020 21:58:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:54464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727050AbgLTC66 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 19 Dec 2020 21:58:58 -0500
Date:   Sat, 19 Dec 2020 18:58:04 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608433084;
        bh=5GC0XhCUSWi3IqEBt47vM0v2TqFTuOdzLvuTlK7AV0c=;
        h=From:To:Subject:From;
        b=JGqcSe/ar4ylYptSWowXQ1pLDICYKmSx66iJq4T//JyTY9VYBR0KtMMHLQVtZhWVQ
         XXSXUMs3hdwerun9tCJGtGWaLOYnFRBo+XlAzQFgey7T/ZWsyTb3NFiFPyjTox9NtL
         lef/rnVtY3Q89nAW+RhLsgh2UkrFyM7a/jM/VYis=
From:   akpm@linux-foundation.org
To:     arnd@arndb.de, mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        willemb@google.com, willy@infradead.org
Subject:  [merged] epoll-convert-internal-api-to-timespec64.patch
 removed from -mm tree
Message-ID: <20201220025804.XPKO8kpiu%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: epoll: convert internal api to timespec64
has been removed from the -mm tree.  Its filename was
     epoll-convert-internal-api-to-timespec64.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Willem de Bruijn <willemb@google.com>
Subject: epoll: convert internal api to timespec64

Patch series "add epoll_pwait2 syscall", v4.

Enable nanosecond timeouts for epoll.

Analogous to pselect and ppoll, introduce an epoll_wait syscall
variant that takes a struct timespec instead of int timeout.


This patch (of 4):

Make epoll more consistent with select/poll: pass along the timeout as
timespec64 pointer.

In anticipation of additional changes affecting all three polling
mechanisms:

- add epoll_pwait2 syscall with timespec semantics,
  and share poll_select_set_timeout implementation.
- compute slack before conversion to absolute time,
  to save one ktime_get_ts64 call.

Link: https://lkml.kernel.org/r/20201121144401.3727659-1-willemdebruijn.kernel@gmail.com
Link: https://lkml.kernel.org/r/20201121144401.3727659-2-willemdebruijn.kernel@gmail.com
Signed-off-by: Willem de Bruijn <willemb@google.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventpoll.c |   57 ++++++++++++++++++++++++++++++-----------------
 1 file changed, 37 insertions(+), 20 deletions(-)

--- a/fs/eventpoll.c~epoll-convert-internal-api-to-timespec64
+++ a/fs/eventpoll.c
@@ -1712,15 +1712,25 @@ static int ep_send_events(struct eventpo
 	return res;
 }
 
-static inline struct timespec64 ep_set_mstimeout(long ms)
+static struct timespec64 *ep_timeout_to_timespec(struct timespec64 *to, long ms)
 {
-	struct timespec64 now, ts = {
-		.tv_sec = ms / MSEC_PER_SEC,
-		.tv_nsec = NSEC_PER_MSEC * (ms % MSEC_PER_SEC),
-	};
+	struct timespec64 now;
+
+	if (ms < 0)
+		return NULL;
+
+	if (!ms) {
+		to->tv_sec = 0;
+		to->tv_nsec = 0;
+		return to;
+	}
+
+	to->tv_sec = ms / MSEC_PER_SEC;
+	to->tv_nsec = NSEC_PER_MSEC * (ms % MSEC_PER_SEC);
 
 	ktime_get_ts64(&now);
-	return timespec64_add_safe(now, ts);
+	*to = timespec64_add_safe(now, *to);
+	return to;
 }
 
 /**
@@ -1732,8 +1742,8 @@ static inline struct timespec64 ep_set_m
  *          stored.
  * @maxevents: Size (in terms of number of events) of the caller event buffer.
  * @timeout: Maximum timeout for the ready events fetch operation, in
- *           milliseconds. If the @timeout is zero, the function will not block,
- *           while if the @timeout is less than zero, the function will block
+ *           timespec. If the timeout is zero, the function will not block,
+ *           while if the @timeout ptr is NULL, the function will block
  *           until at least one event has been retrieved (or an error
  *           occurred).
  *
@@ -1741,7 +1751,7 @@ static inline struct timespec64 ep_set_m
  *          error code, in case of error.
  */
 static int ep_poll(struct eventpoll *ep, struct epoll_event __user *events,
-		   int maxevents, long timeout)
+		   int maxevents, struct timespec64 *timeout)
 {
 	int res, eavail, timed_out = 0;
 	u64 slack = 0;
@@ -1750,13 +1760,11 @@ static int ep_poll(struct eventpoll *ep,
 
 	lockdep_assert_irqs_enabled();
 
-	if (timeout > 0) {
-		struct timespec64 end_time = ep_set_mstimeout(timeout);
-
-		slack = select_estimate_accuracy(&end_time);
+	if (timeout && (timeout->tv_sec | timeout->tv_nsec)) {
+		slack = select_estimate_accuracy(timeout);
 		to = &expires;
-		*to = timespec64_to_ktime(end_time);
-	} else if (timeout == 0) {
+		*to = timespec64_to_ktime(*timeout);
+	} else if (timeout) {
 		/*
 		 * Avoid the unnecessary trip to the wait queue loop, if the
 		 * caller specified a non blocking operation.
@@ -2175,7 +2183,7 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, in
  * part of the user space epoll_wait(2).
  */
 static int do_epoll_wait(int epfd, struct epoll_event __user *events,
-			 int maxevents, int timeout)
+			 int maxevents, struct timespec64 *to)
 {
 	int error;
 	struct fd f;
@@ -2209,7 +2217,7 @@ static int do_epoll_wait(int epfd, struc
 	ep = f.file->private_data;
 
 	/* Time to fish for events ... */
-	error = ep_poll(ep, events, maxevents, timeout);
+	error = ep_poll(ep, events, maxevents, to);
 
 error_fput:
 	fdput(f);
@@ -2219,7 +2227,10 @@ error_fput:
 SYSCALL_DEFINE4(epoll_wait, int, epfd, struct epoll_event __user *, events,
 		int, maxevents, int, timeout)
 {
-	return do_epoll_wait(epfd, events, maxevents, timeout);
+	struct timespec64 to;
+
+	return do_epoll_wait(epfd, events, maxevents,
+			     ep_timeout_to_timespec(&to, timeout));
 }
 
 /*
@@ -2230,6 +2241,7 @@ SYSCALL_DEFINE6(epoll_pwait, int, epfd,
 		int, maxevents, int, timeout, const sigset_t __user *, sigmask,
 		size_t, sigsetsize)
 {
+	struct timespec64 to;
 	int error;
 
 	/*
@@ -2240,7 +2252,9 @@ SYSCALL_DEFINE6(epoll_pwait, int, epfd,
 	if (error)
 		return error;
 
-	error = do_epoll_wait(epfd, events, maxevents, timeout);
+	error = do_epoll_wait(epfd, events, maxevents,
+			      ep_timeout_to_timespec(&to, timeout));
+
 	restore_saved_sigmask_unless(error == -EINTR);
 
 	return error;
@@ -2253,6 +2267,7 @@ COMPAT_SYSCALL_DEFINE6(epoll_pwait, int,
 			const compat_sigset_t __user *, sigmask,
 			compat_size_t, sigsetsize)
 {
+	struct timespec64 to;
 	long err;
 
 	/*
@@ -2263,7 +2278,9 @@ COMPAT_SYSCALL_DEFINE6(epoll_pwait, int,
 	if (err)
 		return err;
 
-	err = do_epoll_wait(epfd, events, maxevents, timeout);
+	err = do_epoll_wait(epfd, events, maxevents,
+			    ep_timeout_to_timespec(&to, timeout));
+
 	restore_saved_sigmask_unless(err == -EINTR);
 
 	return err;
_

Patches currently in -mm which might be from willemb@google.com are


