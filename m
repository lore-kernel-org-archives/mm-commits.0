Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15DC61FDE31
	for <mm-commits@vger.kernel.org>; Tue, 27 Jan 2026 20:22:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769545364; cv=none; b=tsSXhW/zzy2miYtiL8h424QxE+Zynho8jF9N5zq2ujmNyxA1E9EIq5Kn/l4IpVMg/3Y6Hkm559nk8U/VTMB1WKgDRjNQ+5vyhuMDxE3HZi6+OtpvX8n79rJY0tSZTvw/E9VZtcowyOj5v3ODtcfDbpb9rjmBkPsRRWy76C+UrcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769545364; c=relaxed/simple;
	bh=ncABgnKQua+86JaNothTGYYi2daonNQUIGn3oB3XY6M=;
	h=Date:To:From:Subject:Message-Id; b=Te93idOI3ILTPTW3ccsASt70WXvupbg4lwBxDVnhOQD60PhrAwCam7t26V9rK87gsgmcymii4T0N5PVC+MqoYhRzdnlBrt240bAbrECooJa/9gNkewBdXQwfNut0AOo/c+YtyAT26qqJDy8aFEX5TOy/mionfJiOJx52HNtelOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QswmBmdy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QswmBmdy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 771C6C116C6;
	Tue, 27 Jan 2026 20:22:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769545363;
	bh=ncABgnKQua+86JaNothTGYYi2daonNQUIGn3oB3XY6M=;
	h=Date:To:From:Subject:From;
	b=QswmBmdy4DtAI18sAVKUKglwSMAmKR/LXQjX+jU3QPGfr2/zg6mQcYxF/m9F8d+tm
	 BF8bhP+JsjGjkEA8ScLEfXR7Er0mIB8ux8W6QyyxGVDFJezfL5Pw8qBzfZTkbzJ2Nb
	 1xWm3G0MRXtidKku0B5aXInk5blj6849BCfrG6Wk=
Date: Tue, 27 Jan 2026 12:22:42 -0800
To: mm-commits@vger.kernel.org,usama.anjum@collabora.com,tglx@linutronix.de,shuah@kernel.org,peterz@infradead.org,ndesaulniers@google.com,nathan@kernel.org,morbo@google.com,mingo@redhat.com,justinstitt@google.com,edliaw@google.com,dvhart@infradead.org,dave@stgolabs.net,colin.i.king@gmail.com,bigeasy@linutronix.de,andrealmeid@igalia.com,ywen.chen@foxmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] selftests-futex-fix-the-failed-futex_requeue-test-issue.patch removed from -mm tree
Message-Id: <20260127202243.771C6C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/futex: fix the failed futex_requeue test issue
has been removed from the -mm tree.  Its filename was
     selftests-futex-fix-the-failed-futex_requeue-test-issue.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Yuwen Chen <ywen.chen@foxmail.com>
Subject: selftests/futex: fix the failed futex_requeue test issue
Date: Mon, 26 Jan 2026 17:33:30 +0800

This test item has extremely high requirements for timing and can only
pass the test under specific conditions.  The following situations will
lead to test failure:

    MainThread                  Thread1
        │
  pthread_create-------------------┐
        │                          │
 futex_cmp_requeue                 │
        │                     futex_wait
        │                          │

If the child thread is not waiting in the futex_wait function when the
main thread reaches the futex_cmp_requeue function, the test will fail.

This patch avoids this problem by checking whether the child thread is in
a sleeping state in the main thread.

Link: https://lkml.kernel.org/r/tencent_B9DBF2ECBE56BAB68BDAB949C6935D01CE09@qq.com
Fixes: 7cb5dd8e2c8c ("selftests: futex: Add futex compare requeue test")
Signed-off-by: Yuwen Chen <ywen.chen@foxmail.com>
Co-developed-by: Edward Liaw <edliaw@google.com>
Signed-off-by: Edward Liaw <edliaw@google.com>
Cc: Andre Almeida <andrealmeid@igalia.com>
Cc: Bill Wendling <morbo@google.com>
Cc: Colin Ian King <colin.i.king@gmail.com>
Cc: Darren Hart <dvhart@infradead.org>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Justin Stitt <justinstitt@google.com>
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: ndesaulniers@google.com <ndesaulniers@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/futex/functional/futex_requeue.c |   70 ++++++++--
 1 file changed, 59 insertions(+), 11 deletions(-)

--- a/tools/testing/selftests/futex/functional/futex_requeue.c~selftests-futex-fix-the-failed-futex_requeue-test-issue
+++ a/tools/testing/selftests/futex/functional/futex_requeue.c
@@ -7,21 +7,27 @@
 
 #include <pthread.h>
 #include <limits.h>
+#include <stdatomic.h>
 
 #include "futextest.h"
 #include "kselftest_harness.h"
 
-#define timeout_ns  30000000
-#define WAKE_WAIT_US 10000
+#define timeout_s  3 /* 3s */
+#define WAKE_WAIT_US (10000 * 100) /* 1s */
 
 volatile futex_t *f1;
+static pthread_barrier_t barrier;
 
 void *waiterfn(void *arg)
 {
 	struct timespec to;
+	atomic_int *tid = (atomic_int *)arg;
 
-	to.tv_sec = 0;
-	to.tv_nsec = timeout_ns;
+	to.tv_sec = timeout_s;
+	to.tv_nsec = 0;
+
+	atomic_store(tid, gettid());
+	pthread_barrier_wait(&barrier);
 
 	if (futex_wait(f1, *f1, &to, 0))
 		printf("waiter failed errno %d\n", errno);
@@ -29,22 +35,52 @@ void *waiterfn(void *arg)
 	return NULL;
 }
 
+static int get_thread_state(pid_t pid)
+{
+	FILE *fp;
+	char buf[80], tag[80];
+	char val = 0;
+
+	snprintf(buf, sizeof(buf), "/proc/%d/status", pid);
+	fp = fopen(buf, "r");
+	if (!fp)
+		return -1;
+
+	while (fgets(buf, sizeof(buf), fp))
+		if (sscanf(buf, "%s %c", tag, &val) == 2 && !strcmp(tag, "State:")) {
+			fclose(fp);
+			return val;
+		}
+
+	fclose(fp);
+	return -1;
+}
+
 TEST(requeue_single)
 {
 	volatile futex_t _f1 = 0;
 	volatile futex_t f2 = 0;
 	pthread_t waiter[10];
-	int res;
+	atomic_int tid = 0;
+	int res, state, retry = 100;
 
 	f1 = &_f1;
+	pthread_barrier_init(&barrier, NULL, 2);
 
 	/*
 	 * Requeue a waiter from f1 to f2, and wake f2.
 	 */
-	if (pthread_create(&waiter[0], NULL, waiterfn, NULL))
+	if (pthread_create(&waiter[0], NULL, waiterfn, &tid))
 		ksft_exit_fail_msg("pthread_create failed\n");
 
-	usleep(WAKE_WAIT_US);
+	pthread_barrier_wait(&barrier);
+	pthread_barrier_destroy(&barrier);
+	while ((state = get_thread_state(atomic_load(&tid))) != 'S') {
+		usleep(WAKE_WAIT_US / 100);
+
+		if (state < 0 || retry-- <= 0)
+			break;
+	}
 
 	ksft_print_dbg_msg("Requeuing 1 futex from f1 to f2\n");
 	res = futex_cmp_requeue(f1, 0, &f2, 0, 1, 0);
@@ -69,7 +105,8 @@ TEST(requeue_multiple)
 	volatile futex_t _f1 = 0;
 	volatile futex_t f2 = 0;
 	pthread_t waiter[10];
-	int res, i;
+	atomic_int tids[10] = {0};
+	int res, i, state, retry = 0;
 
 	f1 = &_f1;
 
@@ -78,11 +115,22 @@ TEST(requeue_multiple)
 	 * At futex_wake, wake INT_MAX (should be exactly 7).
 	 */
 	for (i = 0; i < 10; i++) {
-		if (pthread_create(&waiter[i], NULL, waiterfn, NULL))
+		pthread_barrier_init(&barrier, NULL, 2);
+
+		if (pthread_create(&waiter[i], NULL, waiterfn, &tids[i]))
 			ksft_exit_fail_msg("pthread_create failed\n");
-	}
 
-	usleep(WAKE_WAIT_US);
+		pthread_barrier_wait(&barrier);
+		pthread_barrier_destroy(&barrier);
+
+		retry += 10;
+		while ((state = get_thread_state(atomic_load(&tids[i]))) != 'S') {
+			usleep(WAKE_WAIT_US / 100);
+
+			if (state < 0 || retry-- <= 0)
+				break;
+		}
+	}
 
 	ksft_print_dbg_msg("Waking 3 futexes at f1 and requeuing 7 futexes from f1 to f2\n");
 	res = futex_cmp_requeue(f1, 0, &f2, 3, 7, 0);
_

Patches currently in -mm which might be from ywen.chen@foxmail.com are


