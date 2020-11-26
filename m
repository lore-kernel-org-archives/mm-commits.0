Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB9ABC56201
	for <mm-commits@archiver.kernel.org>; Thu, 26 Nov 2020 00:48:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 47B69216C4
	for <mm-commits@archiver.kernel.org>; Thu, 26 Nov 2020 00:48:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PAm0RekR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728449AbgKZAsi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Nov 2020 19:48:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:56016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725836AbgKZAsh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 25 Nov 2020 19:48:37 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D3AB421534;
        Thu, 26 Nov 2020 00:48:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1606351717;
        bh=5euHPKi1O29lpEYSxxqCwMnqdyNQR2gsif5Ud4crmwM=;
        h=Date:From:To:Subject:From;
        b=PAm0RekRFZf4G08g80h+tXZxZNCxspuAqjYM+yk2eLVPejiwTEu+7ddT/nnxc9F7F
         nf2fz0I6bzDElBcoGsdvkxw82Y0lnzQEaILRNSOKA/xJfH4Ocaq7xwLPXmbkKUahk4
         xR8iUuyOml+eyzlIMs5TByqc0LvAZyGYi8j0KuiQ=
Date:   Wed, 25 Nov 2020 16:48:36 -0800
From:   akpm@linux-foundation.org
To:     arnd@arndb.de, mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        willemb@google.com, willy@infradead.org
Subject:  + epoll-add-syscall-epoll_pwait2.patch added to -mm tree
Message-ID: <20201126004836.N-IMUwm-X%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: epoll: add syscall epoll_pwait2
has been added to the -mm tree.  Its filename is
     epoll-add-syscall-epoll_pwait2.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/epoll-add-syscall-epoll_pwait2.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/epoll-add-syscall-epoll_pwait2.patch

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
@@ -2239,11 +2239,10 @@ SYSCALL_DEFINE4(epoll_wait, int, epfd, s
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
@@ -2254,22 +2253,48 @@ SYSCALL_DEFINE6(epoll_pwait, int, epfd,
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
@@ -2280,13 +2305,47 @@ COMPAT_SYSCALL_DEFINE6(epoll_pwait, int,
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

Patches currently in -mm which might be from willemb@google.com are

epoll-convert-internal-api-to-timespec64.patch
epoll-add-syscall-epoll_pwait2.patch
epoll-wire-up-syscall-epoll_pwait2.patch
selftests-filesystems-expand-epoll-with-epoll_pwait2.patch

