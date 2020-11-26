Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72185C56202
	for <mm-commits@archiver.kernel.org>; Thu, 26 Nov 2020 00:48:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F3BDB207BC
	for <mm-commits@archiver.kernel.org>; Thu, 26 Nov 2020 00:48:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="utW39oQn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726719AbgKZAsf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Nov 2020 19:48:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:55956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725836AbgKZAsf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 25 Nov 2020 19:48:35 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1AD08207BC;
        Thu, 26 Nov 2020 00:48:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1606351714;
        bh=MTF54dBUSWnAYpeVZM87cTNfxDDI+yWZCR+o7YdFE40=;
        h=Date:From:To:Subject:From;
        b=utW39oQnlA/2s8Dv3sKt57F1SaRUyBi+eLI3Fn/YJwF2EAbEsOPep7PvifHSPruxx
         yuTn7A4Y2NVj9j6yFOug9A6iB58xNLp6NgbQBK0h9bfKEdJaE4a3ZvVzMsv0RdtEyM
         xg/kvORpcaYC86A/lVlbaGU0pmnzWoPD2WP7chaw=
Date:   Wed, 25 Nov 2020 16:48:33 -0800
From:   akpm@linux-foundation.org
To:     arnd@arndb.de, mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        willemb@google.com, willy@infradead.org
Subject:  + epoll-convert-internal-api-to-timespec64.patch added to
 -mm tree
Message-ID: <20201126004833.GSUjW9Eck%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: epoll: convert internal api to timespec64
has been added to the -mm tree.  Its filename is
     epoll-convert-internal-api-to-timespec64.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/epoll-convert-internal-api-to-timespec64.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/epoll-convert-internal-api-to-timespec64.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -1714,15 +1714,25 @@ static int ep_send_events(struct eventpo
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
@@ -1734,8 +1744,8 @@ static inline struct timespec64 ep_set_m
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
@@ -1743,7 +1753,7 @@ static inline struct timespec64 ep_set_m
  *          error code, in case of error.
  */
 static int ep_poll(struct eventpoll *ep, struct epoll_event __user *events,
-		   int maxevents, long timeout)
+		   int maxevents, struct timespec64 *timeout)
 {
 	int res, eavail, timed_out = 0;
 	u64 slack = 0;
@@ -1752,13 +1762,11 @@ static int ep_poll(struct eventpoll *ep,
 
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
@@ -2177,7 +2185,7 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, in
  * part of the user space epoll_wait(2).
  */
 static int do_epoll_wait(int epfd, struct epoll_event __user *events,
-			 int maxevents, int timeout)
+			 int maxevents, struct timespec64 *to)
 {
 	int error;
 	struct fd f;
@@ -2211,7 +2219,7 @@ static int do_epoll_wait(int epfd, struc
 	ep = f.file->private_data;
 
 	/* Time to fish for events ... */
-	error = ep_poll(ep, events, maxevents, timeout);
+	error = ep_poll(ep, events, maxevents, to);
 
 error_fput:
 	fdput(f);
@@ -2221,7 +2229,10 @@ error_fput:
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
@@ -2232,6 +2243,7 @@ SYSCALL_DEFINE6(epoll_pwait, int, epfd,
 		int, maxevents, int, timeout, const sigset_t __user *, sigmask,
 		size_t, sigsetsize)
 {
+	struct timespec64 to;
 	int error;
 
 	/*
@@ -2242,7 +2254,9 @@ SYSCALL_DEFINE6(epoll_pwait, int, epfd,
 	if (error)
 		return error;
 
-	error = do_epoll_wait(epfd, events, maxevents, timeout);
+	error = do_epoll_wait(epfd, events, maxevents,
+			      ep_timeout_to_timespec(&to, timeout));
+
 	restore_saved_sigmask_unless(error == -EINTR);
 
 	return error;
@@ -2255,6 +2269,7 @@ COMPAT_SYSCALL_DEFINE6(epoll_pwait, int,
 			const compat_sigset_t __user *, sigmask,
 			compat_size_t, sigsetsize)
 {
+	struct timespec64 to;
 	long err;
 
 	/*
@@ -2265,7 +2280,9 @@ COMPAT_SYSCALL_DEFINE6(epoll_pwait, int,
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

epoll-convert-internal-api-to-timespec64.patch
epoll-add-syscall-epoll_pwait2.patch
epoll-wire-up-syscall-epoll_pwait2.patch
selftests-filesystems-expand-epoll-with-epoll_pwait2.patch

