From: akpm@linux-foundation.org
Subject: +
 kselftests-introduce-new-epoll60-testcase-for-catching-lost-wakeups.patch
 added to -mm tree
Date: Thu, 30 Apr 2020 14:55:31 -0700
Message-ID: <20200430215531.5N4ylPCxt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:51816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726736AbgD3Vzd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 30 Apr 2020 17:55:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jbaron@akamai.com, khazhy@google.com, mm-commits@vger.kernel.org, r@hev.cc, rpenyaev@suse.de, viro@zeniv.linux.org.uk


The patch titled
     Subject: kselftests: introduce new epoll60 testcase for catching lost wakeups
has been added to the -mm tree.  Its filename is
     kselftests-introduce-new-epoll60-testcase-for-catching-lost-wakeups.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kselftests-introduce-new-epoll60-testcase-for-catching-lost-wakeups.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kselftests-introduce-new-epoll60-testcase-for-catching-lost-wakeups.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from rpenyaev@suse.de are

kselftests-introduce-new-epoll60-testcase-for-catching-lost-wakeups.patch
epoll-atomically-remove-wait-entry-on-wake-up.patch
