From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 11/15] kselftests: introduce new epoll60 testcase
 for catching lost wakeups
Date: Thu, 07 May 2020 18:36:13 -0700
Message-ID: <20200508013613.QGw54D6Rf%akpm@linux-foundation.org>
References: <20200507183509.c5ef146c5aaeb118a25a39a8@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:58784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726612AbgEHBgP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 7 May 2020 21:36:15 -0400
In-Reply-To: <20200507183509.c5ef146c5aaeb118a25a39a8@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jbaron@akamai.com, khazhy@google.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, r@hev.cc, rpenyaev@suse.de, torvalds@linux-foundation.org, viro@zeniv.linux.org.uk

From: Roman Penyaev <rpenyaev@suse.de>
Subject: kselftests: introduce new epoll60 testcase for catching lost wakeups

This test case catches lost wake up introduced by:
  339ddb53d373 ("fs/epoll: remove unnecessary wakeups of nested epoll")

The test is simple: we have 10 threads and 10 event fds.  Each thread can
harvest only 1 event.  1 producer fires all 10 events at once and waits
that all 10 events will be observed by 10 threads.

In case of lost wakeup epoll_wait() will timeout and 0 will be returned.

Test case catches two sort of problems: forgotten wakeup on event, which
hits the ->ovflist list, this problem was fixed by:

  5a2513239750 ("eventpoll: fix missing wakeup for ovflist in ep_poll_callback")

the other problem is when several sequential events hit the same waiting
thread, thus other waiters get no wakeups.  Problem is fixed in the
following patch.

Link: http://lkml.kernel.org/r/20200430130326.1368509-1-rpenyaev@suse.de
Signed-off-by: Roman Penyaev <rpenyaev@suse.de>
Cc: Khazhismel Kumykov <khazhy@google.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Heiher <r@hev.cc>
Cc: Jason Baron <jbaron@akamai.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/filesystems/epoll/epoll_wakeup_test.c |  146 ++++++++++
 1 file changed, 146 insertions(+)

--- a/tools/testing/selftests/filesystems/epoll/epoll_wakeup_test.c~kselftests-introduce-new-epoll60-testcase-for-catching-lost-wakeups
+++ a/tools/testing/selftests/filesystems/epoll/epoll_wakeup_test.c
@@ -3,6 +3,7 @@
 #define _GNU_SOURCE
 #include <poll.h>
 #include <unistd.h>
+#include <assert.h>
 #include <signal.h>
 #include <pthread.h>
 #include <sys/epoll.h>
@@ -3136,4 +3137,149 @@ TEST(epoll59)
 	close(ctx.sfd[0]);
 }
 
+enum {
+	EPOLL60_EVENTS_NR = 10,
+};
+
+struct epoll60_ctx {
+	volatile int stopped;
+	int ready;
+	int waiters;
+	int epfd;
+	int evfd[EPOLL60_EVENTS_NR];
+};
+
+static void *epoll60_wait_thread(void *ctx_)
+{
+	struct epoll60_ctx *ctx = ctx_;
+	struct epoll_event e;
+	sigset_t sigmask;
+	uint64_t v;
+	int ret;
+
+	/* Block SIGUSR1 */
+	sigemptyset(&sigmask);
+	sigaddset(&sigmask, SIGUSR1);
+	sigprocmask(SIG_SETMASK, &sigmask, NULL);
+
+	/* Prepare empty mask for epoll_pwait() */
+	sigemptyset(&sigmask);
+
+	while (!ctx->stopped) {
+		/* Mark we are ready */
+		__atomic_fetch_add(&ctx->ready, 1, __ATOMIC_ACQUIRE);
+
+		/* Start when all are ready */
+		while (__atomic_load_n(&ctx->ready, __ATOMIC_ACQUIRE) &&
+		       !ctx->stopped);
+
+		/* Account this waiter */
+		__atomic_fetch_add(&ctx->waiters, 1, __ATOMIC_ACQUIRE);
+
+		ret = epoll_pwait(ctx->epfd, &e, 1, 2000, &sigmask);
+		if (ret != 1) {
+			/* We expect only signal delivery on stop */
+			assert(ret < 0 && errno == EINTR && "Lost wakeup!\n");
+			assert(ctx->stopped);
+			break;
+		}
+
+		ret = read(e.data.fd, &v, sizeof(v));
+		/* Since we are on ET mode, thus each thread gets its own fd. */
+		assert(ret == sizeof(v));
+
+		__atomic_fetch_sub(&ctx->waiters, 1, __ATOMIC_RELEASE);
+	}
+
+	return NULL;
+}
+
+static inline unsigned long long msecs(void)
+{
+	struct timespec ts;
+	unsigned long long msecs;
+
+	clock_gettime(CLOCK_REALTIME, &ts);
+	msecs = ts.tv_sec * 1000ull;
+	msecs += ts.tv_nsec / 1000000ull;
+
+	return msecs;
+}
+
+static inline int count_waiters(struct epoll60_ctx *ctx)
+{
+	return __atomic_load_n(&ctx->waiters, __ATOMIC_ACQUIRE);
+}
+
+TEST(epoll60)
+{
+	struct epoll60_ctx ctx = { 0 };
+	pthread_t waiters[ARRAY_SIZE(ctx.evfd)];
+	struct epoll_event e;
+	int i, n, ret;
+
+	signal(SIGUSR1, signal_handler);
+
+	ctx.epfd = epoll_create1(0);
+	ASSERT_GE(ctx.epfd, 0);
+
+	/* Create event fds */
+	for (i = 0; i < ARRAY_SIZE(ctx.evfd); i++) {
+		ctx.evfd[i] = eventfd(0, EFD_NONBLOCK);
+		ASSERT_GE(ctx.evfd[i], 0);
+
+		e.events = EPOLLIN | EPOLLET;
+		e.data.fd = ctx.evfd[i];
+		ASSERT_EQ(epoll_ctl(ctx.epfd, EPOLL_CTL_ADD, ctx.evfd[i], &e), 0);
+	}
+
+	/* Create waiter threads */
+	for (i = 0; i < ARRAY_SIZE(waiters); i++)
+		ASSERT_EQ(pthread_create(&waiters[i], NULL,
+					 epoll60_wait_thread, &ctx), 0);
+
+	for (i = 0; i < 300; i++) {
+		uint64_t v = 1, ms;
+
+		/* Wait for all to be ready */
+		while (__atomic_load_n(&ctx.ready, __ATOMIC_ACQUIRE) !=
+		       ARRAY_SIZE(ctx.evfd))
+			;
+
+		/* Steady, go */
+		__atomic_fetch_sub(&ctx.ready, ARRAY_SIZE(ctx.evfd),
+				   __ATOMIC_ACQUIRE);
+
+		/* Wait all have gone to kernel */
+		while (count_waiters(&ctx) != ARRAY_SIZE(ctx.evfd))
+			;
+
+		/* 1ms should be enough to schedule away */
+		usleep(1000);
+
+		/* Quickly signal all handles at once */
+		for (n = 0; n < ARRAY_SIZE(ctx.evfd); n++) {
+			ret = write(ctx.evfd[n], &v, sizeof(v));
+			ASSERT_EQ(ret, sizeof(v));
+		}
+
+		/* Busy loop for 1s and wait for all waiters to wake up */
+		ms = msecs();
+		while (count_waiters(&ctx) && msecs() < ms + 1000)
+			;
+
+		ASSERT_EQ(count_waiters(&ctx), 0);
+	}
+	ctx.stopped = 1;
+	/* Stop waiters */
+	for (i = 0; i < ARRAY_SIZE(waiters); i++)
+		ret = pthread_kill(waiters[i], SIGUSR1);
+	for (i = 0; i < ARRAY_SIZE(waiters); i++)
+		pthread_join(waiters[i], NULL);
+
+	for (i = 0; i < ARRAY_SIZE(waiters); i++)
+		close(ctx.evfd[i]);
+	close(ctx.epfd);
+}
+
 TEST_HARNESS_MAIN
_
