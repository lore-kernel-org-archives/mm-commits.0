From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 137/166] kselftest: introduce new epoll test case
Date: Mon, 06 Apr 2020 20:11:20 -0700
Message-ID: <20200407031120.SCqdQY1nS%akpm@linux-foundation.org>
References: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:57046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726633AbgDGDLX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 6 Apr 2020 23:11:23 -0400
In-Reply-To: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, chris.kohlhoff@clearpool.io, dbueso@suse.de, jbaron@akamai.com, jes.sorensen@gmail.com, kuba@kernel.org, linux-mm@kvack.org, max@arangodb.com, mm-commits@vger.kernel.org, rpenyaev@suse.de, torvalds@linux-foundation.org

From: Roman Penyaev <rpenyaev@suse.de>
Subject: kselftest: introduce new epoll test case

This testcase repeats epollbug.c from the bug:

  https://bugzilla.kernel.org/show_bug.cgi?id=205933

What it tests?  It tests the race between epoll_ctl() and epoll_wait(). 
New event mask passed to epoll_ctl() triggers wake up, which can be missed
because of the bug described in the link.  Reproduction is 100%, so easy
to fix.  Kudos, Max, for wonderful test case.

Link: http://lkml.kernel.org/r/20200214170211.561524-2-rpenyaev@suse.de
Signed-off-by: Roman Penyaev <rpenyaev@suse.de>
Cc: Max Neunhoeffer <max@arangodb.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Christopher Kohlhoff <chris.kohlhoff@clearpool.io>
Cc: Davidlohr Bueso <dbueso@suse.de>
Cc: Jason Baron <jbaron@akamai.com>
Cc: Jes Sorensen <jes.sorensen@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/filesystems/epoll/epoll_wakeup_test.c |   67 +++++++++-
 1 file changed, 66 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/filesystems/epoll/epoll_wakeup_test.c~kselftest-introduce-new-epoll-test-case
+++ a/tools/testing/selftests/filesystems/epoll/epoll_wakeup_test.c
@@ -7,13 +7,14 @@
 #include <pthread.h>
 #include <sys/epoll.h>
 #include <sys/socket.h>
+#include <sys/eventfd.h>
 #include "../../kselftest_harness.h"
 
 struct epoll_mtcontext
 {
 	int efd[3];
 	int sfd[4];
-	int count;
+	volatile int count;
 
 	pthread_t main;
 	pthread_t waiter;
@@ -3071,4 +3072,68 @@ TEST(epoll58)
 	close(ctx.sfd[3]);
 }
 
+static void *epoll59_thread(void *ctx_)
+{
+	struct epoll_mtcontext *ctx = ctx_;
+	struct epoll_event e;
+	int i;
+
+	for (i = 0; i < 100000; i++) {
+		while (ctx->count == 0)
+			;
+
+		e.events = EPOLLIN | EPOLLERR | EPOLLET;
+		epoll_ctl(ctx->efd[0], EPOLL_CTL_MOD, ctx->sfd[0], &e);
+		ctx->count = 0;
+	}
+
+	return NULL;
+}
+
+/*
+ *        t0
+ *      (p) \
+ *           e0
+ *     (et) /
+ *        e0
+ *
+ * Based on https://bugzilla.kernel.org/show_bug.cgi?id=205933
+ */
+TEST(epoll59)
+{
+	pthread_t emitter;
+	struct pollfd pfd;
+	struct epoll_event e;
+	struct epoll_mtcontext ctx = { 0 };
+	int i, ret;
+
+	signal(SIGUSR1, signal_handler);
+
+	ctx.efd[0] = epoll_create1(0);
+	ASSERT_GE(ctx.efd[0], 0);
+
+	ctx.sfd[0] = eventfd(1, 0);
+	ASSERT_GE(ctx.sfd[0], 0);
+
+	e.events = EPOLLIN | EPOLLERR | EPOLLET;
+	ASSERT_EQ(epoll_ctl(ctx.efd[0], EPOLL_CTL_ADD, ctx.sfd[0], &e), 0);
+
+	ASSERT_EQ(pthread_create(&emitter, NULL, epoll59_thread, &ctx), 0);
+
+	for (i = 0; i < 100000; i++) {
+		ret = epoll_wait(ctx.efd[0], &e, 1, 1000);
+		ASSERT_GT(ret, 0);
+
+		while (ctx.count != 0)
+			;
+		ctx.count = 1;
+	}
+	if (pthread_tryjoin_np(emitter, NULL) < 0) {
+		pthread_kill(emitter, SIGUSR1);
+		pthread_join(emitter, NULL);
+	}
+	close(ctx.efd[0]);
+	close(ctx.sfd[0]);
+}
+
 TEST_HARNESS_MAIN
_
