Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67D5FC4361B
	for <mm-commits@archiver.kernel.org>; Fri, 18 Dec 2020 22:05:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3AF6823B5D
	for <mm-commits@archiver.kernel.org>; Fri, 18 Dec 2020 22:05:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726520AbgLRWFy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 18 Dec 2020 17:05:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:39298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726504AbgLRWFy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 18 Dec 2020 17:05:54 -0500
Date:   Fri, 18 Dec 2020 14:05:38 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608329139;
        bh=cScJVjf2e9RhdV5mgebB1/uKz6YeNP6orIKwJoQk6rw=;
        h=From:To:Subject:In-Reply-To:From;
        b=Fm6PjUPCHkkRGnrSqTn2GHOJLaE143rVYJU7BOraeNQxveBHlcgwYZkn8WrpEMPpZ
         dMbGO2EPwgIoQWMv6yLIk+VCPXDypBeJVZOM6kv0Qsz587x+Sb0Ce9/gMl2xVe9Y9c
         fnWnfkym7I3WgN5xdVITZkJ6NB/4ZdHcPC9TSb14=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, arnd@arndb.de, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        viro@zeniv.linux.org.uk, willemb@google.com, willy@infradead.org
Subject:  [patch 76/78] epoll: add syscall epoll_pwait2
Message-ID: <20201218220538.j23gQP2if%akpm@linux-foundation.org>
In-Reply-To: <20201218140046.497484741326828e5b5d46ec@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>
Subject: epoll: add syscall epoll_pwait2

Add syscall epoll_pwait2, an epoll_wait variant with nsec resolution that
replaces int timeout with struct timespec.  It is equivalent otherwise.

    int epoll_pwait2(int fd, struct epoll_event *events,
                     int maxevents,
                     const struct timespec *timeout,
                     const sigset_t *sigset);

The underlying hrtimer is already programmed with nsec resolution. 
pselect and ppoll also set nsec resolution timeout with timespec.

The sigset_t in epoll_pwait has a compat variant. epoll_pwait2 needs
the same.

For timespec, only support this new interface on 2038 aware platforms
that define __kernel_timespec_t. So no CONFIG_COMPAT_32BIT_TIME.

Link: https://lkml.kernel.org/r/20201121144401.3727659-3-willemdebruijn.kernel@gmail.com
Signed-off-by: Willem de Bruijn <willemb@google.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventpoll.c |   87 +++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 73 insertions(+), 14 deletions(-)

--- a/fs/eventpoll.c~epoll-add-syscall-epoll_pwait2
+++ a/fs/eventpoll.c
@@ -2237,11 +2237,10 @@ SYSCALL_DEFINE4(epoll_wait, int, epfd, s
  * Implement the event wait interface for the eventpoll file. It is the kernel
  * part of the user space epoll_pwait(2).
  */
-SYSCALL_DEFINE6(epoll_pwait, int, epfd, struct epoll_event __user *, events,
-		int, maxevents, int, timeout, const sigset_t __user *, sigmask,
-		size_t, sigsetsize)
+static int do_epoll_pwait(int epfd, struct epoll_event __user *events,
+			  int maxevents, struct timespec64 *to,
+			  const sigset_t __user *sigmask, size_t sigsetsize)
 {
-	struct timespec64 to;
 	int error;
 
 	/*
@@ -2252,22 +2251,48 @@ SYSCALL_DEFINE6(epoll_pwait, int, epfd,
 	if (error)
 		return error;
 
-	error = do_epoll_wait(epfd, events, maxevents,
-			      ep_timeout_to_timespec(&to, timeout));
+	error = do_epoll_wait(epfd, events, maxevents, to);
 
 	restore_saved_sigmask_unless(error == -EINTR);
 
 	return error;
 }
 
-#ifdef CONFIG_COMPAT
-COMPAT_SYSCALL_DEFINE6(epoll_pwait, int, epfd,
-			struct epoll_event __user *, events,
-			int, maxevents, int, timeout,
-			const compat_sigset_t __user *, sigmask,
-			compat_size_t, sigsetsize)
+SYSCALL_DEFINE6(epoll_pwait, int, epfd, struct epoll_event __user *, events,
+		int, maxevents, int, timeout, const sigset_t __user *, sigmask,
+		size_t, sigsetsize)
 {
 	struct timespec64 to;
+
+	return do_epoll_pwait(epfd, events, maxevents,
+			      ep_timeout_to_timespec(&to, timeout),
+			      sigmask, sigsetsize);
+}
+
+SYSCALL_DEFINE6(epoll_pwait2, int, epfd, struct epoll_event __user *, events,
+		int, maxevents, const struct __kernel_timespec __user *, timeout,
+		const sigset_t __user *, sigmask, size_t, sigsetsize)
+{
+	struct timespec64 ts, *to = NULL;
+
+	if (timeout) {
+		if (get_timespec64(&ts, timeout))
+			return -EFAULT;
+		to = &ts;
+		if (poll_select_set_timeout(to, ts.tv_sec, ts.tv_nsec))
+			return -EINVAL;
+	}
+
+	return do_epoll_pwait(epfd, events, maxevents, to,
+			      sigmask, sigsetsize);
+}
+
+#ifdef CONFIG_COMPAT
+static int do_compat_epoll_pwait(int epfd, struct epoll_event __user *events,
+				 int maxevents, struct timespec64 *timeout,
+				 const compat_sigset_t __user *sigmask,
+				 compat_size_t sigsetsize)
+{
 	long err;
 
 	/*
@@ -2278,13 +2303,47 @@ COMPAT_SYSCALL_DEFINE6(epoll_pwait, int,
 	if (err)
 		return err;
 
-	err = do_epoll_wait(epfd, events, maxevents,
-			    ep_timeout_to_timespec(&to, timeout));
+	err = do_epoll_wait(epfd, events, maxevents, timeout);
 
 	restore_saved_sigmask_unless(err == -EINTR);
 
 	return err;
 }
+
+COMPAT_SYSCALL_DEFINE6(epoll_pwait, int, epfd,
+		       struct epoll_event __user *, events,
+		       int, maxevents, int, timeout,
+		       const compat_sigset_t __user *, sigmask,
+		       compat_size_t, sigsetsize)
+{
+	struct timespec64 to;
+
+	return do_compat_epoll_pwait(epfd, events, maxevents,
+				     ep_timeout_to_timespec(&to, timeout),
+				     sigmask, sigsetsize);
+}
+
+COMPAT_SYSCALL_DEFINE6(epoll_pwait2, int, epfd,
+		       struct epoll_event __user *, events,
+		       int, maxevents,
+		       const struct __kernel_timespec __user *, timeout,
+		       const compat_sigset_t __user *, sigmask,
+		       compat_size_t, sigsetsize)
+{
+	struct timespec64 ts, *to = NULL;
+
+	if (timeout) {
+		if (get_timespec64(&ts, timeout))
+			return -EFAULT;
+		to = &ts;
+		if (poll_select_set_timeout(to, ts.tv_sec, ts.tv_nsec))
+			return -EINVAL;
+	}
+
+	return do_compat_epoll_pwait(epfd, events, maxevents, to,
+				     sigmask, sigsetsize);
+}
+
 #endif
 
 static int __init eventpoll_init(void)
_
