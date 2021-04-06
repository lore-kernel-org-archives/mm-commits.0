Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B09D1C433B4
	for <mm-commits@archiver.kernel.org>; Tue,  6 Apr 2021 01:52:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 78FFC61380
	for <mm-commits@archiver.kernel.org>; Tue,  6 Apr 2021 01:52:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243166AbhDFBwd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 5 Apr 2021 21:52:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:44360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238146AbhDFBwd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 5 Apr 2021 21:52:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 15EBE61382;
        Tue,  6 Apr 2021 01:52:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1617673946;
        bh=1RhP04egCiDkscNnsFILhZxVGsOgiVF+CbL+sXt86eg=;
        h=Date:From:To:Subject:From;
        b=MRbyk8TAviKNqhHhQhZ7wI7GK5i8l9hEWBFqpOJZfcAKcBLv3/+kID9/xFx9Im6DK
         wCZsQIEnrR443AwaHkeYUuAAkP4NauM1GeNwgG5WKF3eN/G5MHcswmMKeykLhliHvS
         dUaZB161HtM8LvSIh61BdRvOeDbaRB6LlXIkaEMU=
Date:   Mon, 05 Apr 2021 18:52:25 -0700
From:   akpm@linux-foundation.org
To:     dave@stgolabs.net, dbueso@suse.de, jbaron@akamai.com,
        mm-commits@vger.kernel.org, rpenyaev@suse.de,
        viro@zeniv.linux.org.uk
Subject:  + kselftest-introduce-new-epoll-test-case.patch added to
 -mm tree
Message-ID: <20210406015225.pbfAaZyqd%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kselftest: introduce new epoll test case
has been added to the -mm tree.  Its filename is
     kselftest-introduce-new-epoll-test-case.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kselftest-introduce-new-epoll-test-case.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kselftest-introduce-new-epoll-test-case.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Davidlohr Bueso <dave@stgolabs.net>
Subject: kselftest: introduce new epoll test case

Patch series "fs/epoll: restore user-visible behavior upon event ready".

This series tries to address a change in user visible behavior, reported
in https://bugzilla.kernel.org/show_bug.cgi?id=208943.

Epoll does not report an event to all the threads running epoll_wait()
on the same epoll descriptor. Unsurprisingly, this was bisected back to
339ddb53d373 (fs/epoll: remove unnecessary wakeups of nested epoll), which
has had various problems in the past, beyond only nested epoll usage.


This patch (of 2):

This incorporates the testcase originally reported in:

     https://bugzilla.kernel.org/show_bug.cgi?id=208943

Which ensures an event is reported to all threads blocked on the same
epoll descriptor, otherwise only a single thread will receive the wakeup
once the event become ready.

Link: https://lkml.kernel.org/r/20210405231025.33829-1-dave@stgolabs.net
Link: https://lkml.kernel.org/r/20210405231025.33829-2-dave@stgolabs.net
Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Cc: Jason Baron <jbaron@akamai.com>
Cc: Roman Penyaev <rpenyaev@suse.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/filesystems/epoll/epoll_wakeup_test.c |   44 ++++++++++
 1 file changed, 44 insertions(+)

--- a/tools/testing/selftests/filesystems/epoll/epoll_wakeup_test.c~kselftest-introduce-new-epoll-test-case
+++ a/tools/testing/selftests/filesystems/epoll/epoll_wakeup_test.c
@@ -3449,4 +3449,48 @@ TEST(epoll63)
 	close(sfd[1]);
 }
 
+/*
+ *        t0    t1
+ *     (ew) \  / (ew)
+ *           e0
+ *            | (lt)
+ *           s0
+ */
+TEST(epoll64)
+{
+	pthread_t waiter[2];
+	struct epoll_event e;
+	struct epoll_mtcontext ctx = { 0 };
+
+	signal(SIGUSR1, signal_handler);
+
+	ASSERT_EQ(socketpair(AF_UNIX, SOCK_STREAM, 0, ctx.sfd), 0);
+
+	ctx.efd[0] = epoll_create(1);
+	ASSERT_GE(ctx.efd[0], 0);
+
+	e.events = EPOLLIN;
+	ASSERT_EQ(epoll_ctl(ctx.efd[0], EPOLL_CTL_ADD, ctx.sfd[0], &e), 0);
+
+	/*
+	 * main will act as the emitter once both waiter threads are
+	 * blocked and expects to both be awoken upon the ready event.
+	 */
+	ctx.main = pthread_self();
+	ASSERT_EQ(pthread_create(&waiter[0], NULL, waiter_entry1a, &ctx), 0);
+	ASSERT_EQ(pthread_create(&waiter[1], NULL, waiter_entry1a, &ctx), 0);
+
+	usleep(100000);
+	ASSERT_EQ(write(ctx.sfd[1], "w", 1), 1);
+
+	ASSERT_EQ(pthread_join(waiter[0], NULL), 0);
+	ASSERT_EQ(pthread_join(waiter[1], NULL), 0);
+
+	EXPECT_EQ(ctx.count, 2);
+
+	close(ctx.efd[0]);
+	close(ctx.sfd[0]);
+	close(ctx.sfd[1]);
+}
+
 TEST_HARNESS_MAIN
_

Patches currently in -mm which might be from dave@stgolabs.net are

kselftest-introduce-new-epoll-test-case.patch
fs-epoll-restore-waking-from-ep_done_scan.patch

