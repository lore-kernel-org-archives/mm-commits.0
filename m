Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AA0AC64E75
	for <mm-commits@archiver.kernel.org>; Thu, 26 Nov 2020 00:48:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA3FF2168B
	for <mm-commits@archiver.kernel.org>; Thu, 26 Nov 2020 00:48:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Qlh4nbJO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728542AbgKZAsq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Nov 2020 19:48:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:56176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725836AbgKZAsq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 25 Nov 2020 19:48:46 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D73D821534;
        Thu, 26 Nov 2020 00:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1606351726;
        bh=kxpLJlvUMz2c6yJVcPQYs6pHR/OsTi9Hqfl2oXYh+hE=;
        h=Date:From:To:Subject:From;
        b=Qlh4nbJOZ6kWNsV8wWjsO+X7/ok6zgyl0Ce9NSCQ7CSLdFFvb36jRYbRqXzEOphhw
         VPHU3zrwAF27XfbCJaET2mJCJyCQzQ/FqjQgyTQJy9B8QfJilURD51gubihhI3jWuc
         yHfZUNolI3bbRbbx57Pwhqlro1IAba1MZRysG8UY=
Date:   Wed, 25 Nov 2020 16:48:45 -0800
From:   akpm@linux-foundation.org
To:     arnd@arndb.de, mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        willemb@google.com, willy@infradead.org
Subject:  +
 selftests-filesystems-expand-epoll-with-epoll_pwait2.patch added to -mm
 tree
Message-ID: <20201126004845.vVAyIfqID%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/filesystems: expand epoll with epoll_pwait2
has been added to the -mm tree.  Its filename is
     selftests-filesystems-expand-epoll-with-epoll_pwait2.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/selftests-filesystems-expand-epoll-with-epoll_pwait2.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/selftests-filesystems-expand-epoll-with-epoll_pwait2.patch

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

Patches currently in -mm which might be from willemb@google.com are

epoll-convert-internal-api-to-timespec64.patch
epoll-add-syscall-epoll_pwait2.patch
epoll-wire-up-syscall-epoll_pwait2.patch
selftests-filesystems-expand-epoll-with-epoll_pwait2.patch

