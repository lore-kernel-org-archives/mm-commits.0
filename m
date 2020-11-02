Return-Path: <SRS0=ZqYO=EI=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A47E0C4741F
	for <mm-commits@archiver.kernel.org>; Mon,  2 Nov 2020 01:08:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7465422268
	for <mm-commits@archiver.kernel.org>; Mon,  2 Nov 2020 01:08:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604279289;
	bh=FmhNJy3VAegKNlpBj8rp9AdiX3cR0THRPvnAnoCVStw=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=U1U40osvbmxeLMUvI5qeXdUsS76Yh+JJWr1n/i5Z9ba3zQC9E5ibhwpa6w7mnW0aH
	 SxHwxwR/+293qSkxa4x0Cy6u4wqifeh3MLdpUBkRVUIWUAr364OamWLV9qhzidG/0A
	 KisDrYIzJgpa6/aZVBXAyfzC3+/1gOFmMWvTICo8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727570AbgKBBIJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 1 Nov 2020 20:08:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:49776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727335AbgKBBIJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 1 Nov 2020 20:08:09 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D5D742224E;
        Mon,  2 Nov 2020 01:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604279288;
        bh=FmhNJy3VAegKNlpBj8rp9AdiX3cR0THRPvnAnoCVStw=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=p6B8vNwmKrWcNJrX6b+IBhp/t/11SJee4ISD2zHuuFO89VgPxRUwEX8bzhrSvD13z
         ZcHo1zL8oOFvHkXHCnLgC4aAKX2a66NV8viw0kdU5oB+bYSCwokfdkCOxYGkt7WG90
         GmbbgXov0viwiHtk9efHjBNgppNT5mD6wk4PezKg=
Date:   Sun, 01 Nov 2020 17:08:07 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, dave@stgolabs.net, edumazet@google.com,
        guantaol@google.com, khazhy@google.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, soheil@google.com,
        torvalds@linux-foundation.org, viro@zeniv.linux.org.uk,
        willemb@google.com
Subject:  [patch 14/15] epoll: add a selftest for epoll timeout
 race
Message-ID: <20201102010807.RcKS-TLIz%akpm@linux-foundation.org>
In-Reply-To: <20201101170656.48abbd5e88375219f868af5e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Soheil Hassas Yeganeh <soheil@google.com>
Subject: epoll: add a selftest for epoll timeout race

Add a test case to ensure an event is observed by at least one poller when
an epoll timeout is used.

Link: https://lkml.kernel.org/r/20201028180202.952079-2-soheil.kdev@gmail.com
Signed-off-by: Guantao Liu <guantaol@google.com>
Signed-off-by: Soheil Hassas Yeganeh <soheil@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Acked-by: Willem de Bruijn <willemb@google.com>
Reviewed-by: Khazhismel Kumykov <khazhy@google.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/filesystems/epoll/epoll_wakeup_test.c |   95 ++++++++++
 1 file changed, 95 insertions(+)

--- a/tools/testing/selftests/filesystems/epoll/epoll_wakeup_test.c~epoll-add-a-selftest-for-epoll-timeout-race
+++ a/tools/testing/selftests/filesystems/epoll/epoll_wakeup_test.c
@@ -3282,4 +3282,99 @@ TEST(epoll60)
 	close(ctx.epfd);
 }
 
+struct epoll61_ctx {
+	int epfd;
+	int evfd;
+};
+
+static void *epoll61_write_eventfd(void *ctx_)
+{
+	struct epoll61_ctx *ctx = ctx_;
+	int64_t l = 1;
+
+	usleep(10950);
+	write(ctx->evfd, &l, sizeof(l));
+	return NULL;
+}
+
+static void *epoll61_epoll_with_timeout(void *ctx_)
+{
+	struct epoll61_ctx *ctx = ctx_;
+	struct epoll_event events[1];
+	int n;
+
+	n = epoll_wait(ctx->epfd, events, 1, 11);
+	/*
+	 * If epoll returned the eventfd, write on the eventfd to wake up the
+	 * blocking poller.
+	 */
+	if (n == 1) {
+		int64_t l = 1;
+
+		write(ctx->evfd, &l, sizeof(l));
+	}
+	return NULL;
+}
+
+static void *epoll61_blocking_epoll(void *ctx_)
+{
+	struct epoll61_ctx *ctx = ctx_;
+	struct epoll_event events[1];
+
+	epoll_wait(ctx->epfd, events, 1, -1);
+	return NULL;
+}
+
+TEST(epoll61)
+{
+	struct epoll61_ctx ctx;
+	struct epoll_event ev;
+	int i, r;
+
+	ctx.epfd = epoll_create1(0);
+	ASSERT_GE(ctx.epfd, 0);
+	ctx.evfd = eventfd(0, EFD_NONBLOCK);
+	ASSERT_GE(ctx.evfd, 0);
+
+	ev.events = EPOLLIN | EPOLLET | EPOLLERR | EPOLLHUP;
+	ev.data.ptr = NULL;
+	r = epoll_ctl(ctx.epfd, EPOLL_CTL_ADD, ctx.evfd, &ev);
+	ASSERT_EQ(r, 0);
+
+	/*
+	 * We are testing a race.  Repeat the test case 1000 times to make it
+	 * more likely to fail in case of a bug.
+	 */
+	for (i = 0; i < 1000; i++) {
+		pthread_t threads[3];
+		int n;
+
+		/*
+		 * Start 3 threads:
+		 * Thread 1 sleeps for 10.9ms and writes to the evenfd.
+		 * Thread 2 calls epoll with a timeout of 11ms.
+		 * Thread 3 calls epoll with a timeout of -1.
+		 *
+		 * The eventfd write by Thread 1 should either wakeup Thread 2
+		 * or Thread 3.  If it wakes up Thread 2, Thread 2 writes on the
+		 * eventfd to wake up Thread 3.
+		 *
+		 * If no events are missed, all three threads should eventually
+		 * be joinable.
+		 */
+		ASSERT_EQ(pthread_create(&threads[0], NULL,
+					 epoll61_write_eventfd, &ctx), 0);
+		ASSERT_EQ(pthread_create(&threads[1], NULL,
+					 epoll61_epoll_with_timeout, &ctx), 0);
+		ASSERT_EQ(pthread_create(&threads[2], NULL,
+					 epoll61_blocking_epoll, &ctx), 0);
+
+		for (n = 0; n < ARRAY_SIZE(threads); ++n)
+			ASSERT_EQ(pthread_join(threads[n], NULL), 0);
+	}
+
+	close(ctx.epfd);
+	close(ctx.evfd);
+}
+
 TEST_HARNESS_MAIN
_
