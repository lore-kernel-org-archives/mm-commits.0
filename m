Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FF13235045
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 02:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791338650; cv=none; b=MVBVU0LcKiBVPUMRTaFBp2C2tOItD/y5y9eFL2O3YybGtgygLsn5k1WNDZpu2Lzx4bupBXjysgwHSX0OPcUJHEdINkj4q8++Kse8oir7+pWRrMIh6z9BqCo/6X6tWPNm0yypaf1fh5Ydp5E+BBxbyHku0IRT7lwaxoNvis5ihDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791338650; c=relaxed/simple;
	bh=bSOeFYpZuJTYVkJCkKL29fLn9npvBfDEC7DCqzEI6ec=;
	h=Date:To:From:Subject:Message-Id; b=ETEd6PrEJ5PC546qSml/H9PhtyUSpSL5Y5WcUsoUit6aZ8k86185OZJiCmXmMaP+WE5GDhGkM8CGERQmxuK70KMmeLHsvgkAAWCvPLmZS6/DnVohVryKp1YrrRoYyq50TnJOIGhczD4AuYN4Vbk6tkoiqVPH5XedDHSE2BAvsOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ey0swD+F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ey0swD+F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 065541F0089B;
	Wed,  7 Oct 2026 02:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791338649;
	bh=3wuigDk6+PTbOAmMDQNcvjnR/Yxlalg6aN0hxrQCiVo=;
	h=Date:To:From:Subject;
	b=Ey0swD+FtM+Ut0INtYmrSqOZf7Iu+yJpsvXiPOoLChdfxMZPJN5SzPYAR/W2Y/3vV
	 tgMbLsAotOTwrYT5eng9EsDkZqueebKOWFdjvDT8/0lzlDIsAzIkaZ75TiuUgsy+aO
	 IBIx+R984fABbXtiFTAyhBEpQmH/Sg6XqYeS2axg=
Date: Tue, 06 Oct 2026 19:04:08 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,rpenyaev@suse.de,r@hev.cc,brauner@kernel.org,florian.schmaus@codasip.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] selftests-epoll-fix-race-condition-in-multi-waiter-wakeup-tests.patch removed from -mm tree
Message-Id: <20261007020409.065541F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/epoll: fix race condition in multi-waiter wakeup tests
has been removed from the -mm tree.  Its filename was
     selftests-epoll-fix-race-condition-in-multi-waiter-wakeup-tests.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Florian Schmaus <florian.schmaus@codasip.com>
Subject: selftests/epoll: fix race condition in multi-waiter wakeup tests
Date: Fri, 28 Aug 2026 17:54:07 +0200

In tests with multiple concurrent waiters on edge-triggered epoll
instances where an emitter writes to multiple sockets (epoll16, epoll56,
epoll58):

When the emitter performs its first write(), ep_poll_callback() fires and
wakes up both waiters because one waiter uses epoll_wait() and the other
one uses poll().  This translates to different wait queues, ep->wq for
epoll and ep->poll_wait for poll/select, which are both awoken by the
kernel because of that single write.  Next, both waiter threads invoke
epoll_wait(), but since there is only one event, only one epoll_wait()
will return non-zero because of the edge-triggered mode being used (in
level-triggered mode, the kernel would re-queue the event because of
remaining unread data).

Since the second waiter sees an empty ready list, it does not increment
ctx.count and the test fails spuriously with ctx.count == 1 instead of 2.

  Emitter (CPU 0)      Thread 0 (CPU 1)        Thread 1 (CPU 2)
  ===============      ================        ================
                       epoll_wait(e0, -1)      poll(e0, -1)
                       [on e0->wq]             [on e0->poll_wait]

  write(sfd[1])
       |
       +--(Kernel wakes BOTH e0->wq and e0->poll_wait via callback)--+
       |                                                             |
       |               wakes up                wakes up              |
       |               epoll_wait() reaps e1   poll() returns 1      |
       |               (e1 removed via ET)     (wants event)         |
       |               e0->rdllist is EMPTY          |               |
       |               count++ (count = 1)           v               |
       |                                       epoll_wait(e0, 0)     |
       |                                       sees EMPTY list!      |
       |                                       returns 0!            |
       |                                       thread exits          |
       v                                                             |
  write(sfd[3])                                                      |
  (event arrives too late!)                                          v
                           EXPECT_EQ(count, 2)  <-- SPURIOUS FAILURE!

Introduce waiter_entry1ap_loop() to retry poll() if the initial
epoll_wait(..., 0) yielded no events.  This ensures the thread waits for
the subsequent write rather than failing immediately.  Apply this helper
in epoll16, epoll56, and for both waiter threads in epoll58.

Link: https://lore.kernel.org/20260828-selftest-epoll-fix-race-v2-1-953ab57fd60a@codasip.com
Fixes: f2728fe80cef ("selftests: add epoll selftests")
Signed-off-by: Florian Schmaus <florian.schmaus@codasip.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Heiher <r@hev.cc>
Cc: Roman Penyaev <rpenyaev@suse.de>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>
---

 tools/testing/selftests/filesystems/epoll/epoll_wakeup_test.c |   32 ++++++----
 1 file changed, 22 insertions(+), 10 deletions(-)

--- a/tools/testing/selftests/filesystems/epoll/epoll_wakeup_test.c~selftests-epoll-fix-race-condition-in-multi-waiter-wakeup-tests
+++ a/tools/testing/selftests/filesystems/epoll/epoll_wakeup_test.c
@@ -74,6 +74,24 @@ static void *waiter_entry1ap(void *data)
 	return NULL;
 }
 
+static void *waiter_entry1ap_loop(void *data)
+{
+	struct pollfd pfd;
+	struct epoll_event e;
+	struct epoll_mtcontext *ctx = data;
+
+	pfd.fd = ctx->efd[0];
+	pfd.events = POLLIN;
+	while (poll(&pfd, 1, 2000) > 0) {
+		if (epoll_wait(ctx->efd[0], &e, 1, 0) > 0) {
+			__sync_fetch_and_add(&ctx->count, 1);
+			break;
+		}
+	}
+
+	return NULL;
+}
+
 static void *waiter_entry1o(void *data)
 {
 	struct epoll_event e;
@@ -809,7 +827,7 @@ TEST(epoll16)
 	ASSERT_EQ(epoll_ctl(ctx.efd[0], EPOLL_CTL_ADD, ctx.sfd[2], events), 0);
 
 	ctx.main = pthread_self();
-	ASSERT_EQ(pthread_create(&ctx.waiter, NULL, waiter_entry1ap, &ctx), 0);
+	ASSERT_EQ(pthread_create(&ctx.waiter, NULL, waiter_entry1ap_loop, &ctx), 0);
 	ASSERT_EQ(pthread_create(&emitter, NULL, emitter_entry2, &ctx), 0);
 
 	if (epoll_wait(ctx.efd[0], events, 1, -1) > 0)
@@ -2925,7 +2943,7 @@ TEST(epoll56)
 	ASSERT_EQ(epoll_ctl(ctx.efd[0], EPOLL_CTL_ADD, ctx.efd[2], &e), 0);
 
 	ctx.main = pthread_self();
-	ASSERT_EQ(pthread_create(&ctx.waiter, NULL, waiter_entry1ap, &ctx), 0);
+	ASSERT_EQ(pthread_create(&ctx.waiter, NULL, waiter_entry1ap_loop, &ctx), 0);
 	ASSERT_EQ(pthread_create(&emitter, NULL, emitter_entry2, &ctx), 0);
 
 	if (epoll_wait(ctx.efd[0], &e, 1, -1) > 0)
@@ -3030,7 +3048,6 @@ TEST(epoll57)
 TEST(epoll58)
 {
 	pthread_t emitter;
-	struct pollfd pfd;
 	struct epoll_event e;
 	struct epoll_mtcontext ctx = { 0 };
 
@@ -3061,15 +3078,10 @@ TEST(epoll58)
 	ASSERT_EQ(epoll_ctl(ctx.efd[0], EPOLL_CTL_ADD, ctx.efd[2], &e), 0);
 
 	ctx.main = pthread_self();
-	ASSERT_EQ(pthread_create(&ctx.waiter, NULL, waiter_entry1ap, &ctx), 0);
+	ASSERT_EQ(pthread_create(&ctx.waiter, NULL, waiter_entry1ap_loop, &ctx), 0);
 	ASSERT_EQ(pthread_create(&emitter, NULL, emitter_entry2, &ctx), 0);
 
-	pfd.fd = ctx.efd[0];
-	pfd.events = POLLIN;
-	if (poll(&pfd, 1, -1) > 0) {
-		if (epoll_wait(ctx.efd[0], &e, 1, 0) > 0)
-			__sync_fetch_and_add(&ctx.count, 1);
-	}
+	waiter_entry1ap_loop(&ctx);
 
 	ASSERT_EQ(pthread_join(ctx.waiter, NULL), 0);
 	EXPECT_EQ(ctx.count, 2);
_

Patches currently in -mm which might be from florian.schmaus@codasip.com are


