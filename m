Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4A3FC2D0E4
	for <mm-commits@archiver.kernel.org>; Fri, 18 Dec 2020 22:06:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9986B23B5D
	for <mm-commits@archiver.kernel.org>; Fri, 18 Dec 2020 22:06:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726149AbgLRWG0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 18 Dec 2020 17:06:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:39984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725939AbgLRWG0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 18 Dec 2020 17:06:26 -0500
Date:   Fri, 18 Dec 2020 14:05:44 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608329145;
        bh=T+Uzd1okeJMYlcO+itJriRw0Z8tWJ79iJqUckl6xXpw=;
        h=From:To:Subject:In-Reply-To:From;
        b=wPBfIHeeyq9isjXwPTiWeeiLWJF9PqqMafRKxqnMHA/u1it2isIQQYCHUOEHXUucC
         yYLk4QFM5n06MhGmzfjqR2Xh5gyzFTz3uOgsKq6JtpFpTWW/Ti7POBWSBrAq0K1elJ
         fUK/6vwye2qpm46OicJB351ZYBJ3Km5bCM0daDZ0=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, arnd@arndb.de, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        viro@zeniv.linux.org.uk, willemb@google.com, willy@infradead.org
Subject:  [patch 78/78] selftests/filesystems: expand epoll with
 epoll_pwait2
Message-ID: <20201218220544.-qfLR98pC%akpm@linux-foundation.org>
In-Reply-To: <20201218140046.497484741326828e5b5d46ec@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>
Subject: selftests/filesystems: expand epoll with epoll_pwait2

Code coverage for the epoll_pwait2 syscall.

epoll62: Repeat basic test epoll1, but exercising the new syscall.
epoll63: Pass a timespec and exercise the timeout wakeup path.

Link: https://lkml.kernel.org/r/20201121144401.3727659-5-willemdebruijn.kernel@gmail.com
Signed-off-by: Willem de Bruijn <willemb@google.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/filesystems/epoll/epoll_wakeup_test.c |   72 ++++++++++
 1 file changed, 72 insertions(+)

--- a/tools/testing/selftests/filesystems/epoll/epoll_wakeup_test.c~selftests-filesystems-expand-epoll-with-epoll_pwait2
+++ a/tools/testing/selftests/filesystems/epoll/epoll_wakeup_test.c
@@ -1,6 +1,8 @@
 // SPDX-License-Identifier: GPL-2.0
 
 #define _GNU_SOURCE
+#include <asm/unistd.h>
+#include <linux/time_types.h>
 #include <poll.h>
 #include <unistd.h>
 #include <assert.h>
@@ -21,6 +23,19 @@ struct epoll_mtcontext
 	pthread_t waiter;
 };
 
+#ifndef __NR_epoll_pwait2
+#define __NR_epoll_pwait2 -1
+#endif
+
+static inline int sys_epoll_pwait2(int fd, struct epoll_event *events,
+				   int maxevents,
+				   const struct __kernel_timespec *timeout,
+				   const sigset_t *sigset, size_t sigsetsize)
+{
+	return syscall(__NR_epoll_pwait2, fd, events, maxevents, timeout,
+		       sigset, sigsetsize);
+}
+
 static void signal_handler(int signum)
 {
 }
@@ -3377,4 +3392,61 @@ TEST(epoll61)
 	close(ctx.evfd);
 }
 
+/* Equivalent to basic test epoll1, but exercising epoll_pwait2. */
+TEST(epoll62)
+{
+	int efd;
+	int sfd[2];
+	struct epoll_event e;
+
+	ASSERT_EQ(socketpair(AF_UNIX, SOCK_STREAM, 0, sfd), 0);
+
+	efd = epoll_create(1);
+	ASSERT_GE(efd, 0);
+
+	e.events = EPOLLIN;
+	ASSERT_EQ(epoll_ctl(efd, EPOLL_CTL_ADD, sfd[0], &e), 0);
+
+	ASSERT_EQ(write(sfd[1], "w", 1), 1);
+
+	EXPECT_EQ(sys_epoll_pwait2(efd, &e, 1, NULL, NULL, 0), 1);
+	EXPECT_EQ(sys_epoll_pwait2(efd, &e, 1, NULL, NULL, 0), 1);
+
+	close(efd);
+	close(sfd[0]);
+	close(sfd[1]);
+}
+
+/* Epoll_pwait2 basic timeout test. */
+TEST(epoll63)
+{
+	const int cfg_delay_ms = 10;
+	unsigned long long tdiff;
+	struct __kernel_timespec ts;
+	int efd;
+	int sfd[2];
+	struct epoll_event e;
+
+	ASSERT_EQ(socketpair(AF_UNIX, SOCK_STREAM, 0, sfd), 0);
+
+	efd = epoll_create(1);
+	ASSERT_GE(efd, 0);
+
+	e.events = EPOLLIN;
+	ASSERT_EQ(epoll_ctl(efd, EPOLL_CTL_ADD, sfd[0], &e), 0);
+
+	ts.tv_sec = 0;
+	ts.tv_nsec = cfg_delay_ms * 1000 * 1000;
+
+	tdiff = msecs();
+	EXPECT_EQ(sys_epoll_pwait2(efd, &e, 1, &ts, NULL, 0), 0);
+	tdiff = msecs() - tdiff;
+
+	EXPECT_GE(tdiff, cfg_delay_ms);
+
+	close(efd);
+	close(sfd[0]);
+	close(sfd[1]);
+}
+
 TEST_HARNESS_MAIN
_
