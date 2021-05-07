Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F3EFC433ED
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 01:04:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 68EBA613C2
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 01:04:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234074AbhEGBFF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 6 May 2021 21:05:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:45352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230499AbhEGBFF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 6 May 2021 21:05:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EC08F610FA;
        Fri,  7 May 2021 01:04:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620349445;
        bh=j7wCziCvAoT2JGArM/ONoEufnHWTlPipm4gFJgwyJbg=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Rv8segFtOLlJb4iyQPrKKVPIG4SxyQzWD150HCHHhctxtY0SQ+BHP5NBXCB9ziE+k
         ZUzC+xRa58tXh1NTTAg/pbl/DsvreJy7VPEN8WKUCJpMp2/+305MzCjlx2jwnW3/Vc
         dnWfSt7dw1OKVvEi7AejlZDsYsN/EJd2ZBx94fhY=
Date:   Thu, 06 May 2021 18:04:04 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, dave@stgolabs.net, dbueso@suse.de,
        jbaron@akamai.com, linux-mm@kvack.org, mm-commits@vger.kernel.org,
        rpenyaev@suse.de, torvalds@linux-foundation.org,
        viro@zeniv.linux.org.uk
Subject:  [patch 39/91] kselftest: introduce new epoll test case
Message-ID: <20210507010404.J7uhlTQco%akpm@linux-foundation.org>
In-Reply-To: <20210506180126.03e1baee7ca52bedb6cc6003@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
