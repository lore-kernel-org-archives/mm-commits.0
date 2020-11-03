Return-Path: <SRS0=UcEf=EJ=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D20AC2D0A3
	for <mm-commits@archiver.kernel.org>; Tue,  3 Nov 2020 18:15:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EFD3922243
	for <mm-commits@archiver.kernel.org>; Tue,  3 Nov 2020 18:15:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604427349;
	bh=bTlzAVt/1gjsZkc9fSHjXq2ajtJKee0+HXArtxnVC6g=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=aFFhVFfBGLbDNEDYeXhDXVHa49WEX3SJRTVAgLt1Qe0MS46PezixtTjSTTp/yQ5Bj
	 LQWRcnpTYxx6RsUNgMWExPcO//Av7J73upTcphd/F93aiQUFu7EmR+ZiJymaUBfitj
	 CsNijmAh4ajcd9J8ENeXrHMOTpzHdNC4XHHarYS0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728969AbgKCSPs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 3 Nov 2020 13:15:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:38786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727706AbgKCSPs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 3 Nov 2020 13:15:48 -0500
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 941CB207BB;
        Tue,  3 Nov 2020 18:15:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604427347;
        bh=bTlzAVt/1gjsZkc9fSHjXq2ajtJKee0+HXArtxnVC6g=;
        h=Date:From:To:Subject:From;
        b=Q1YD9LIydxo9SsDgOPhq7C3Kx2zVGyS/ykUrFyQUgZaiLlpi8984IL4abXntmRv/I
         PXr8Go/CnrLj/iHHdjcLtTXmGr6JC2nao+b0I62USp+qn4nBLxaRPhv8mahCSKm84V
         z/aBr1uqpZTlu2RQgBMJUTrQ11OR3h/snfP5JimA=
Date:   Tue, 03 Nov 2020 10:15:47 -0800
From:   akpm@linux-foundation.org
To:     dave@stgolabs.net, edumazet@google.com, guantaol@google.com,
        khazhy@google.com, mm-commits@vger.kernel.org, soheil@google.com,
        viro@zeniv.linux.org.uk, willemb@google.com
Subject:  [to-be-updated]
 epoll-add-a-selftest-for-epoll-timeout-race.patch removed from -mm tree
Message-ID: <20201103181547.gOn7-nKaI%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: epoll: add a selftest for epoll timeout race
has been removed from the -mm tree.  Its filename was
     epoll-add-a-selftest-for-epoll-timeout-race.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
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

Patches currently in -mm which might be from soheil@google.com are


