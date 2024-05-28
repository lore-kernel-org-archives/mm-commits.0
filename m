Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA69817B432
	for <mm-commits@vger.kernel.org>; Tue, 28 May 2024 21:29:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716931780; cv=none; b=NQNYqrwPvM8J+UFwc0Za137aynqzw6bBsGthU6L3XlxZwZTLjgw3Ld0BQiRaedtBlirWSL1Uk23HB6l/eo8WibFxyh4Mnko4e+iVbAQhr3+tyIJSDCdQAhQ8iHlq4643aOn8P5AFjZqtYvEzkR7rXMaVCSa6fFqUAFihq4BdRhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716931780; c=relaxed/simple;
	bh=cbntOjTckIDUFfYQtFqfD0zpTLIZ2RKFsSy8RPinDiA=;
	h=Date:To:From:Subject:Message-Id; b=ExK+ymhZs/MEMkWucc51/rNQvJQlzp2zlYVen4noOGz7bIzWUA0iPD94PcO1As5WaL7kR0BdIYI1xk7X6vtubY2JK65l8nyTZa1x2NhxbSa0xYQUrR1ooTmT7ARJk1+ZN1gzurdi9r1DbWZTaY3nRwG4iDY/m+vl45t8RFa8344=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vBNqAd2+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vBNqAd2+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C065C3277B;
	Tue, 28 May 2024 21:29:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716931780;
	bh=cbntOjTckIDUFfYQtFqfD0zpTLIZ2RKFsSy8RPinDiA=;
	h=Date:To:From:Subject:From;
	b=vBNqAd2+mYSnYHdtaK5nnZkrGYVleIUyp3AL4/JTODFNGlFaUFt+sZBwBPXvhxP28
	 EkIJuHV+09Fpg1ol3qgVTQqiV8el7w3ccj9lE6WtYvq0gSEa22f2aRiGDIxtseJQLu
	 lJAY+01dZX0OqfPMjYFNUK6SBe9Txqmq5tgPEk2c=
Date: Tue, 28 May 2024 14:29:39 -0700
To: mm-commits@vger.kernel.org,tim.bird@sony.com,shuah@kernel.org,rostedt@goodmis.org,mathieu.desnoyers@efficios.com,dyoung@redhat.com,brauner@kernel.org,avagin@google.com,wen.yang@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-introduce-additional-eventfd-test-coverage.patch added to mm-nonmm-unstable branch
Message-Id: <20240528212940.4C065C3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests: introduce additional eventfd test coverage
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     selftests-introduce-additional-eventfd-test-coverage.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-introduce-additional-eventfd-test-coverage.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Wen Yang <wen.yang@linux.dev>
Subject: selftests: introduce additional eventfd test coverage
Date: Mon, 27 May 2024 08:02:00 +0800

Add several new test cases which assert corner cases on the eventfd
mechanism, for example, the supplied buffer is less than 8 bytes,
attempting to write a value that is too large, etc.

	./eventfd_test
	# Starting 9 tests from 1 test cases.
	#  RUN           global.eventfd_check_flag_rdwr ...
	#            OK  global.eventfd_check_flag_rdwr
	ok 1 global.eventfd_check_flag_rdwr
	#  RUN           global.eventfd_check_flag_cloexec ...
	#            OK  global.eventfd_check_flag_cloexec
	ok 2 global.eventfd_check_flag_cloexec
	#  RUN           global.eventfd_check_flag_nonblock ...
	#            OK  global.eventfd_check_flag_nonblock
	ok 3 global.eventfd_check_flag_nonblock
	#  RUN           global.eventfd_chek_flag_cloexec_and_nonblock ...
	#            OK  global.eventfd_chek_flag_cloexec_and_nonblock
	ok 4 global.eventfd_chek_flag_cloexec_and_nonblock
	#  RUN           global.eventfd_check_flag_semaphore ...
	#            OK  global.eventfd_check_flag_semaphore
	ok 5 global.eventfd_check_flag_semaphore
	#  RUN           global.eventfd_check_write ...
	#            OK  global.eventfd_check_write
	ok 6 global.eventfd_check_write
	#  RUN           global.eventfd_check_read ...
	#            OK  global.eventfd_check_read
	ok 7 global.eventfd_check_read
	#  RUN           global.eventfd_check_read_with_nonsemaphore ...
	#            OK  global.eventfd_check_read_with_nonsemaphore
	ok 8 global.eventfd_check_read_with_nonsemaphore
	#  RUN           global.eventfd_check_read_with_semaphore ...
	#            OK  global.eventfd_check_read_with_semaphore
	ok 9 global.eventfd_check_read_with_semaphore
	# PASSED: 9 / 9 tests passed.
	# Totals: pass:9 fail:0 xfail:0 xpass:0 skip:0 error:0

Link: https://lkml.kernel.org/r/20240527000200.5615-1-wen.yang@linux.dev
Signed-off-by: Wen Yang <wen.yang@linux.dev>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Andrei Vagin <avagin@google.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Dave Young <dyoung@redhat.com>
Cc: Tim Bird <tim.bird@sony.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/filesystems/eventfd/eventfd_test.c |  136 +++++++++-
 1 file changed, 131 insertions(+), 5 deletions(-)

--- a/tools/testing/selftests/filesystems/eventfd/eventfd_test.c~selftests-introduce-additional-eventfd-test-coverage
+++ a/tools/testing/selftests/filesystems/eventfd/eventfd_test.c
@@ -13,6 +13,8 @@
 #include <sys/eventfd.h>
 #include "../../kselftest_harness.h"
 
+#define EVENTFD_TEST_ITERATIONS 100000UL
+
 struct error {
 	int  code;
 	char msg[512];
@@ -40,7 +42,7 @@ static inline int sys_eventfd2(unsigned
 	return syscall(__NR_eventfd2, count, flags);
 }
 
-TEST(eventfd01)
+TEST(eventfd_check_flag_rdwr)
 {
 	int fd, flags;
 
@@ -54,7 +56,7 @@ TEST(eventfd01)
 	close(fd);
 }
 
-TEST(eventfd02)
+TEST(eventfd_check_flag_cloexec)
 {
 	int fd, flags;
 
@@ -68,7 +70,7 @@ TEST(eventfd02)
 	close(fd);
 }
 
-TEST(eventfd03)
+TEST(eventfd_check_flag_nonblock)
 {
 	int fd, flags;
 
@@ -83,7 +85,7 @@ TEST(eventfd03)
 	close(fd);
 }
 
-TEST(eventfd04)
+TEST(eventfd_chek_flag_cloexec_and_nonblock)
 {
 	int fd, flags;
 
@@ -161,7 +163,7 @@ static int verify_fdinfo(int fd, struct
 	return 0;
 }
 
-TEST(eventfd05)
+TEST(eventfd_check_flag_semaphore)
 {
 	struct error err = {0};
 	int fd, ret;
@@ -182,5 +184,129 @@ TEST(eventfd05)
 
 	close(fd);
 }
+
+/*
+ * A write(2) fails with the error EINVAL if the size of the supplied buffer
+ * is less than 8 bytes, or if an attempt is made to write the value
+ * 0xffffffffffffffff.
+ */
+TEST(eventfd_check_write)
+{
+	uint64_t value = 1;
+	ssize_t size;
+	int fd;
+
+	fd = sys_eventfd2(0, 0);
+	ASSERT_GE(fd, 0);
+
+	size = write(fd, &value, sizeof(int));
+	EXPECT_EQ(size, -1);
+	EXPECT_EQ(errno, EINVAL);
+
+	size = write(fd, &value, sizeof(value));
+	EXPECT_EQ(size, sizeof(value));
+
+	value = (uint64_t)-1;
+	size = write(fd, &value, sizeof(value));
+	EXPECT_EQ(size, -1);
+	EXPECT_EQ(errno, EINVAL);
+
+	close(fd);
+}
+
+/*
+ * A read(2) fails with the error EINVAL if the size of the supplied buffer is
+ * less than 8 bytes.
+ */
+TEST(eventfd_check_read)
+{
+	uint64_t value;
+	ssize_t size;
+	int fd;
+
+	fd = sys_eventfd2(1, 0);
+	ASSERT_GE(fd, 0);
+
+	size = read(fd, &value, sizeof(int));
+	EXPECT_EQ(size, -1);
+	EXPECT_EQ(errno, EINVAL);
+
+	size = read(fd, &value, sizeof(value));
+	EXPECT_EQ(size, sizeof(value));
+	EXPECT_EQ(value, 1);
+
+	close(fd);
+}
+
+
+/*
+ * If EFD_SEMAPHORE was not specified and the eventfd counter has a nonzero
+ * value, then a read(2) returns 8 bytes containing that value, and the
+ * counter's value is reset to zero.
+ * If the eventfd counter is zero at the time of the call to read(2), then the
+ * call fails with the error EAGAIN if the file descriptor has been made nonblocking.
+ */
+TEST(eventfd_check_read_with_nonsemaphore)
+{
+	uint64_t value;
+	ssize_t size;
+	int fd;
+	int i;
+
+	fd = sys_eventfd2(0, EFD_NONBLOCK);
+	ASSERT_GE(fd, 0);
+
+	value = 1;
+	for (i = 0; i < EVENTFD_TEST_ITERATIONS; i++) {
+		size = write(fd, &value, sizeof(value));
+		EXPECT_EQ(size, sizeof(value));
+	}
+
+	size = read(fd, &value, sizeof(value));
+	EXPECT_EQ(size, sizeof(uint64_t));
+	EXPECT_EQ(value, EVENTFD_TEST_ITERATIONS);
+
+	size = read(fd, &value, sizeof(value));
+	EXPECT_EQ(size, -1);
+	EXPECT_EQ(errno, EAGAIN);
+
+	close(fd);
+}
+
+/*
+ * If EFD_SEMAPHORE was specified and the eventfd counter has a nonzero value,
+ * then a read(2) returns 8 bytes containing the value 1, and the counter's
+ * value is decremented by 1.
+ * If the eventfd counter is zero at the time of the call to read(2), then the
+ * call fails with the error EAGAIN if the file descriptor has been made nonblocking.
+ */
+TEST(eventfd_check_read_with_semaphore)
+{
+	uint64_t value;
+	ssize_t size;
+	int fd;
+	int i;
+
+	fd = sys_eventfd2(0, EFD_SEMAPHORE|EFD_NONBLOCK);
+	ASSERT_GE(fd, 0);
+
+	value = 1;
+	for (i = 0; i < EVENTFD_TEST_ITERATIONS; i++) {
+		size = write(fd, &value, sizeof(value));
+		EXPECT_EQ(size, sizeof(value));
+	}
+
+	for (i = 0; i < EVENTFD_TEST_ITERATIONS; i++) {
+		size = read(fd, &value, sizeof(value));
+		EXPECT_EQ(size, sizeof(value));
+		EXPECT_EQ(value, 1);
+	}
+
+	size = read(fd, &value, sizeof(value));
+	EXPECT_EQ(size, -1);
+	EXPECT_EQ(errno, EAGAIN);
+
+	close(fd);
+}
 
 TEST_HARNESS_MAIN
_

Patches currently in -mm which might be from wen.yang@linux.dev are

selftests-introduce-additional-eventfd-test-coverage.patch

