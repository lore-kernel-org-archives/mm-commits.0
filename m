Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74A0C2B9B7
	for <mm-commits@vger.kernel.org>; Fri, 28 Aug 2026 16:48:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787935701; cv=none; b=W+LES6hQXgWG5oMF4RoAz8I98oHJrP0U/GAKiM4k7YgQU7lBn229i/zwDVb2qhUQv9xngk7LdP8cqO8rPu5qY6VKH2O4f8qvNhCORzlqYD9PHTfT5AAFXjSOFEyy8TkBNedBQWxjem9dSDX7jrc/ZboR98oZLsTTUx9QMdYmdVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787935701; c=relaxed/simple;
	bh=6zADOj47r+BVNIxEV73NLopvDzDrUH2+YDHR/02U8KE=;
	h=Date:To:From:Subject:Message-Id; b=scSjXOfBErvNDXOzv6K6ptyLuu+MEPULtX/OI8nw1GMOmbymXyOUsgkhd5s/1P2zwqYfSc0pfFJCxgFvGrvqraT6uIHUwi0N2VLRgn2AixA12FeWEXEpd2oL1eAo2NqKu+UYtZjAhxtUKFXw25rSIX9Ipt0Qv0MtY4ES7gbq9nc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AC3RE+ul; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AC3RE+ul"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEC0F1F000E9;
	Fri, 28 Aug 2026 16:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787935700;
	bh=Giq2kyGziX9uFzloI1IbjH2EN0Mc19xzfPHZRd0T+zQ=;
	h=Date:To:From:Subject;
	b=AC3RE+ulNIbkOUev3UAJhUNmg9Fv+mQjbnU+/uNxOOVqA07V+HhddevTVspPQ8sAI
	 Ws3CuK1n1nWHECnECZCj782Gt3vlo9LVI7+YfGZ6s2Iglo1m8e7awF7gzIgJsilThi
	 zxRuhofSb+bYpqtmszd40aHT8uPEYl7gAL/8RIik=
Date: Fri, 28 Aug 2026 09:48:19 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,rpenyaev@suse.de,r@hev.cc,brauner@kernel.org,florian.schmaus@codasip.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-epoll-fix-race-condition-in-multi-waiter-wakeup-tests.patch added to mm-nonmm-unstable branch
Message-Id: <20260828164819.EEC0F1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/epoll: fix race condition in multi-waiter wakeup tests
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     selftests-epoll-fix-race-condition-in-multi-waiter-wakeup-tests.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-epoll-fix-race-condition-in-multi-waiter-wakeup-tests.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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
Cc: Heiher <r@hev.cc>
Cc: Roman Penyaev <rpenyaev@suse.de>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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

selftests-epoll-fix-race-condition-in-multi-waiter-wakeup-tests.patch

