Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 421D1C04A94
	for <mm-commits@archiver.kernel.org>; Mon, 14 Aug 2023 19:28:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229775AbjHNT1b (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Aug 2023 15:27:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231743AbjHNT1A (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 14 Aug 2023 15:27:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96D909C
        for <mm-commits@vger.kernel.org>; Mon, 14 Aug 2023 12:26:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 25F01643E5
        for <mm-commits@vger.kernel.org>; Mon, 14 Aug 2023 19:26:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A78AC433C7;
        Mon, 14 Aug 2023 19:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692041217;
        bh=yYHOUJqbU87tBaOJmip/+S+8Z5nhdtRammAEKfk11Es=;
        h=Date:To:From:Subject:From;
        b=W/YGZHx9OEQz1Utp4Lts14oV6oXPToC7021ySK1qPu28eCX2wU82bBlgTsGbq4z7T
         uvM0xuUBxndTUWDhrpfxipav8Eu3NCo30GrKPex/6Eq2B3HcdlhNpcUhT3JM0zOGJu
         bUz9JOsIuWfRUHqxHMqSe3F70KZRYyKA7yU8dBdw=
Date:   Mon, 14 Aug 2023 12:26:56 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org,
        keescook@chromium.org, jeffxu@google.com, dverkamp@chromium.org,
        brauner@kernel.org, asmadeus@codewreck.org, cyphar@cyphar.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-improve-vmmemfd_noexec-sysctl-tests.patch added to mm-unstable branch
Message-Id: <20230814192657.7A78AC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests: improve vm.memfd_noexec sysctl tests
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-improve-vmmemfd_noexec-sysctl-tests.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-improve-vmmemfd_noexec-sysctl-tests.patch

This patch will later appear in the mm-unstable branch at
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
From: Aleksa Sarai <cyphar@cyphar.com>
Subject: selftests: improve vm.memfd_noexec sysctl tests
Date: Mon, 14 Aug 2023 18:41:01 +1000

This adds proper tests for the nesting functionality of vm.memfd_noexec as
well as some minor cleanups to spawn_*_thread().

Link: https://lkml.kernel.org/r/20230814-memfd-vm-noexec-uapi-fixes-v2-5-7ff9e3e10ba6@cyphar.com
Signed-off-by: Aleksa Sarai <cyphar@cyphar.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Daniel Verkamp <dverkamp@chromium.org>
Cc: Dominique Martinet <asmadeus@codewreck.org>
Cc: Jeff Xu <jeffxu@google.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/memfd/memfd_test.c |  339 ++++++++++++++-----
 1 file changed, 254 insertions(+), 85 deletions(-)

--- a/tools/testing/selftests/memfd/memfd_test.c~selftests-improve-vmmemfd_noexec-sysctl-tests
+++ a/tools/testing/selftests/memfd/memfd_test.c
@@ -18,6 +18,7 @@
 #include <sys/syscall.h>
 #include <sys/wait.h>
 #include <unistd.h>
+#include <ctype.h>
 
 #include "common.h"
 
@@ -43,7 +44,6 @@
  */
 static size_t mfd_def_size = MFD_DEF_SIZE;
 static const char *memfd_str = MEMFD_STR;
-static pid_t spawn_newpid_thread(unsigned int flags, int (*fn)(void *));
 static int newpid_thread_fn2(void *arg);
 static void join_newpid_thread(pid_t pid);
 
@@ -96,12 +96,12 @@ static void sysctl_assert_write(const ch
 	int fd = open("/proc/sys/vm/memfd_noexec", O_WRONLY | O_CLOEXEC);
 
 	if (fd < 0) {
-		printf("open sysctl failed\n");
+		printf("open sysctl failed: %m\n");
 		abort();
 	}
 
 	if (write(fd, val, strlen(val)) < 0) {
-		printf("write sysctl failed\n");
+		printf("write sysctl %s failed: %m\n", val);
 		abort();
 	}
 }
@@ -111,7 +111,7 @@ static void sysctl_fail_write(const char
 	int fd = open("/proc/sys/vm/memfd_noexec", O_WRONLY | O_CLOEXEC);
 
 	if (fd < 0) {
-		printf("open sysctl failed\n");
+		printf("open sysctl failed: %m\n");
 		abort();
 	}
 
@@ -122,6 +122,33 @@ static void sysctl_fail_write(const char
 	}
 }
 
+static void sysctl_assert_equal(const char *val)
+{
+	char *p, buf[128] = {};
+	int fd = open("/proc/sys/vm/memfd_noexec", O_RDONLY | O_CLOEXEC);
+
+	if (fd < 0) {
+		printf("open sysctl failed: %m\n");
+		abort();
+	}
+
+	if (read(fd, buf, sizeof(buf)) < 0) {
+		printf("read sysctl failed: %m\n");
+		abort();
+	}
+
+	/* Strip trailing whitespace. */
+	p = buf;
+	while (!isspace(*p))
+		p++;
+	*p = '\0';
+
+	if (strcmp(buf, val) != 0) {
+		printf("unexpected sysctl value: expected %s, got %s\n", val, buf);
+		abort();
+	}
+}
+
 static int mfd_assert_reopen_fd(int fd_in)
 {
 	int fd;
@@ -736,7 +763,7 @@ static int idle_thread_fn(void *arg)
 	return 0;
 }
 
-static pid_t spawn_idle_thread(unsigned int flags)
+static pid_t spawn_thread(unsigned int flags, int (*fn)(void *), void *arg)
 {
 	uint8_t *stack;
 	pid_t pid;
@@ -747,10 +774,7 @@ static pid_t spawn_idle_thread(unsigned
 		abort();
 	}
 
-	pid = clone(idle_thread_fn,
-		    stack + STACK_SIZE,
-		    SIGCHLD | flags,
-		    NULL);
+	pid = clone(fn, stack + STACK_SIZE, SIGCHLD | flags, arg);
 	if (pid < 0) {
 		printf("clone() failed: %m\n");
 		abort();
@@ -759,6 +783,33 @@ static pid_t spawn_idle_thread(unsigned
 	return pid;
 }
 
+static void join_thread(pid_t pid)
+{
+	int wstatus;
+
+	if (waitpid(pid, &wstatus, 0) < 0) {
+		printf("newpid thread: waitpid() failed: %m\n");
+		abort();
+	}
+
+	if (WIFEXITED(wstatus) && WEXITSTATUS(wstatus) != 0) {
+		printf("newpid thread: exited with non-zero error code %d\n",
+		       WEXITSTATUS(wstatus));
+		abort();
+	}
+
+	if (WIFSIGNALED(wstatus)) {
+		printf("newpid thread: killed by signal %d\n",
+		       WTERMSIG(wstatus));
+		abort();
+	}
+}
+
+static pid_t spawn_idle_thread(unsigned int flags)
+{
+	return spawn_thread(flags, idle_thread_fn, NULL);
+}
+
 static void join_idle_thread(pid_t pid)
 {
 	kill(pid, SIGTERM);
@@ -1111,42 +1162,69 @@ static void test_noexec_seal(void)
 	close(fd);
 }
 
-static void test_sysctl_child(void)
+static void test_sysctl_sysctl0(void)
 {
 	int fd;
-	int pid;
 
-	printf("%s sysctl 0\n", memfd_str);
-	sysctl_assert_write("0");
-	fd = mfd_assert_new("kern_memfd_sysctl_0",
+	sysctl_assert_equal("0");
+
+	fd = mfd_assert_new("kern_memfd_sysctl_0_dfl",
 			    mfd_def_size,
 			    MFD_CLOEXEC | MFD_ALLOW_SEALING);
-
 	mfd_assert_mode(fd, 0777);
 	mfd_assert_has_seals(fd, 0);
 	mfd_assert_chmod(fd, 0644);
 	close(fd);
+}
 
-	printf("%s sysctl 1\n", memfd_str);
-	sysctl_assert_write("1");
-	fd = mfd_assert_new("kern_memfd_sysctl_1",
+static void test_sysctl_set_sysctl0(void)
+{
+	sysctl_assert_write("0");
+	test_sysctl_sysctl0();
+}
+
+static void test_sysctl_sysctl1(void)
+{
+	int fd;
+
+	sysctl_assert_equal("1");
+
+	fd = mfd_assert_new("kern_memfd_sysctl_1_dfl",
 			    mfd_def_size,
 			    MFD_CLOEXEC | MFD_ALLOW_SEALING);
+	mfd_assert_mode(fd, 0666);
+	mfd_assert_has_seals(fd, F_SEAL_EXEC);
+	mfd_fail_chmod(fd, 0777);
+	close(fd);
 
-	printf("%s child ns\n", memfd_str);
-	pid = spawn_newpid_thread(CLONE_NEWPID, newpid_thread_fn2);
-	join_newpid_thread(pid);
+	fd = mfd_assert_new("kern_memfd_sysctl_1_exec",
+			    mfd_def_size,
+			    MFD_CLOEXEC | MFD_EXEC | MFD_ALLOW_SEALING);
+	mfd_assert_mode(fd, 0777);
+	mfd_assert_has_seals(fd, 0);
+	mfd_assert_chmod(fd, 0644);
+	close(fd);
 
+	fd = mfd_assert_new("kern_memfd_sysctl_1_noexec",
+			    mfd_def_size,
+			    MFD_CLOEXEC | MFD_NOEXEC_SEAL | MFD_ALLOW_SEALING);
 	mfd_assert_mode(fd, 0666);
 	mfd_assert_has_seals(fd, F_SEAL_EXEC);
 	mfd_fail_chmod(fd, 0777);
-	sysctl_fail_write("0");
 	close(fd);
+}
 
-	printf("%s sysctl 2\n", memfd_str);
-	sysctl_assert_write("2");
-	mfd_fail_new("kern_memfd_sysctl_2_exec",
-		     MFD_EXEC | MFD_CLOEXEC | MFD_ALLOW_SEALING);
+static void test_sysctl_set_sysctl1(void)
+{
+	sysctl_assert_write("1");
+	test_sysctl_sysctl1();
+}
+
+static void test_sysctl_sysctl2(void)
+{
+	int fd;
+
+	sysctl_assert_equal("2");
 
 	fd = mfd_assert_new("kern_memfd_sysctl_2_dfl",
 			    mfd_def_size,
@@ -1156,98 +1234,188 @@ static void test_sysctl_child(void)
 	mfd_fail_chmod(fd, 0777);
 	close(fd);
 
-	fd = mfd_assert_new("kern_memfd_sysctl_2_noexec_seal",
+	mfd_fail_new("kern_memfd_sysctl_2_exec",
+		     MFD_CLOEXEC | MFD_EXEC | MFD_ALLOW_SEALING);
+
+	fd = mfd_assert_new("kern_memfd_sysctl_2_noexec",
 			    mfd_def_size,
-			    MFD_NOEXEC_SEAL | MFD_CLOEXEC | MFD_ALLOW_SEALING);
+			    MFD_CLOEXEC | MFD_NOEXEC_SEAL | MFD_ALLOW_SEALING);
 	mfd_assert_mode(fd, 0666);
 	mfd_assert_has_seals(fd, F_SEAL_EXEC);
 	mfd_fail_chmod(fd, 0777);
 	close(fd);
-
-	sysctl_fail_write("0");
-	sysctl_fail_write("1");
 }
 
-static int newpid_thread_fn(void *arg)
+static void test_sysctl_set_sysctl2(void)
 {
-	test_sysctl_child();
-	return 0;
+	sysctl_assert_write("2");
+	test_sysctl_sysctl2();
 }
 
-static void test_sysctl_child2(void)
+static int sysctl_simple_child(void *arg)
 {
 	int fd;
+	int pid;
 
-	sysctl_fail_write("0");
-	fd = mfd_assert_new("kern_memfd_sysctl_1",
-			    mfd_def_size,
-			    MFD_CLOEXEC | MFD_ALLOW_SEALING);
+	printf("%s sysctl 0\n", memfd_str);
+	test_sysctl_set_sysctl0();
 
-	mfd_assert_mode(fd, 0666);
-	mfd_assert_has_seals(fd, F_SEAL_EXEC);
-	mfd_fail_chmod(fd, 0777);
-	close(fd);
+	printf("%s sysctl 1\n", memfd_str);
+	test_sysctl_set_sysctl1();
+
+	printf("%s sysctl 0\n", memfd_str);
+	test_sysctl_set_sysctl0();
+
+	printf("%s sysctl 2\n", memfd_str);
+	test_sysctl_set_sysctl2();
+
+	printf("%s sysctl 1\n", memfd_str);
+	test_sysctl_set_sysctl1();
+
+	printf("%s sysctl 0\n", memfd_str);
+	test_sysctl_set_sysctl0();
+
+	return 0;
+}
+
+/*
+ * Test sysctl
+ * A very basic test to make sure the core sysctl semantics work.
+ */
+static void test_sysctl_simple(void)
+{
+	int pid = spawn_thread(CLONE_NEWPID, sysctl_simple_child, NULL);
+
+	join_thread(pid);
 }
 
-static int newpid_thread_fn2(void *arg)
+static int sysctl_nested(void *arg)
 {
-	test_sysctl_child2();
+	void (*fn)(void) = arg;
+
+	fn();
 	return 0;
 }
-static pid_t spawn_newpid_thread(unsigned int flags, int (*fn)(void *))
+
+static int sysctl_nested_wait(void *arg)
 {
-	uint8_t *stack;
-	pid_t pid;
+	/* Wait for a SIGCONT. */
+	kill(getpid(), SIGSTOP);
+	return sysctl_nested(arg);
+}
 
-	stack = malloc(STACK_SIZE);
-	if (!stack) {
-		printf("malloc(STACK_SIZE) failed: %m\n");
-		abort();
-	}
+static void test_sysctl_sysctl1_failset(void)
+{
+	sysctl_fail_write("0");
+	test_sysctl_sysctl1();
+}
 
-	pid = clone(fn,
-		    stack + STACK_SIZE,
-		    SIGCHLD | flags,
-		    NULL);
-	if (pid < 0) {
-		printf("clone() failed: %m\n");
-		abort();
-	}
+static void test_sysctl_sysctl2_failset(void)
+{
+	sysctl_fail_write("1");
+	test_sysctl_sysctl2();
 
-	return pid;
+	sysctl_fail_write("0");
+	test_sysctl_sysctl2();
 }
 
-static void join_newpid_thread(pid_t pid)
+static int sysctl_nested_child(void *arg)
 {
-	int wstatus;
+	int fd;
+	int pid;
 
-	if (waitpid(pid, &wstatus, 0) < 0) {
-		printf("newpid thread: waitpid() failed: %m\n");
-		abort();
-	}
+	printf("%s nested sysctl 0\n", memfd_str);
+	sysctl_assert_write("0");
+	/* A further nested pidns works the same. */
+	pid = spawn_thread(CLONE_NEWPID, sysctl_simple_child, NULL);
+	join_thread(pid);
 
-	if (WIFEXITED(wstatus) && WEXITSTATUS(wstatus) != 0) {
-		printf("newpid thread: exited with non-zero error code %d\n",
-		       WEXITSTATUS(wstatus));
-		abort();
-	}
+	printf("%s nested sysctl 1\n", memfd_str);
+	sysctl_assert_write("1");
+	/* Child inherits our setting. */
+	pid = spawn_thread(CLONE_NEWPID, sysctl_nested, test_sysctl_sysctl1);
+	join_thread(pid);
+	/* Child cannot raise the setting. */
+	pid = spawn_thread(CLONE_NEWPID, sysctl_nested,
+			   test_sysctl_sysctl1_failset);
+	join_thread(pid);
+	/* Child can lower the setting. */
+	pid = spawn_thread(CLONE_NEWPID, sysctl_nested,
+			   test_sysctl_set_sysctl2);
+	join_thread(pid);
+	/* Child lowering the setting has no effect on our setting. */
+	test_sysctl_sysctl1();
 
-	if (WIFSIGNALED(wstatus)) {
-		printf("newpid thread: killed by signal %d\n",
-		       WTERMSIG(wstatus));
-		abort();
-	}
+	printf("%s nested sysctl 2\n", memfd_str);
+	sysctl_assert_write("2");
+	/* Child inherits our setting. */
+	pid = spawn_thread(CLONE_NEWPID, sysctl_nested, test_sysctl_sysctl2);
+	join_thread(pid);
+	/* Child cannot raise the setting. */
+	pid = spawn_thread(CLONE_NEWPID, sysctl_nested,
+			   test_sysctl_sysctl2_failset);
+	join_thread(pid);
+
+	/* Verify that the rules are actually inherited after fork. */
+	printf("%s nested sysctl 0 -> 1 after fork\n", memfd_str);
+	sysctl_assert_write("0");
+
+	pid = spawn_thread(CLONE_NEWPID, sysctl_nested_wait,
+			   test_sysctl_sysctl1_failset);
+	sysctl_assert_write("1");
+	kill(pid, SIGCONT);
+	join_thread(pid);
+
+	printf("%s nested sysctl 0 -> 2 after fork\n", memfd_str);
+	sysctl_assert_write("0");
+
+	pid = spawn_thread(CLONE_NEWPID, sysctl_nested_wait,
+			   test_sysctl_sysctl2_failset);
+	sysctl_assert_write("2");
+	kill(pid, SIGCONT);
+	join_thread(pid);
+
+	/*
+	 * Verify that the current effective setting is saved on fork, meaning
+	 * that the parent lowering the sysctl doesn't affect already-forked
+	 * children.
+	 */
+	printf("%s nested sysctl 2 -> 1 after fork\n", memfd_str);
+	sysctl_assert_write("2");
+	pid = spawn_thread(CLONE_NEWPID, sysctl_nested_wait,
+			   test_sysctl_sysctl2);
+	sysctl_assert_write("1");
+	kill(pid, SIGCONT);
+	join_thread(pid);
+
+	printf("%s nested sysctl 2 -> 0 after fork\n", memfd_str);
+	sysctl_assert_write("2");
+	pid = spawn_thread(CLONE_NEWPID, sysctl_nested_wait,
+			   test_sysctl_sysctl2);
+	sysctl_assert_write("0");
+	kill(pid, SIGCONT);
+	join_thread(pid);
+
+	printf("%s nested sysctl 1 -> 0 after fork\n", memfd_str);
+	sysctl_assert_write("1");
+	pid = spawn_thread(CLONE_NEWPID, sysctl_nested_wait,
+			   test_sysctl_sysctl1);
+	sysctl_assert_write("0");
+	kill(pid, SIGCONT);
+	join_thread(pid);
+
+	return 0;
 }
 
 /*
- * Test sysctl
- * A very basic sealing test to see whether setting/retrieving seals works.
+ * Test sysctl with nested pid namespaces
+ * Make sure that the sysctl nesting semantics work correctly.
  */
-static void test_sysctl(void)
+static void test_sysctl_nested(void)
 {
-	int pid = spawn_newpid_thread(CLONE_NEWPID, newpid_thread_fn);
+	int pid = spawn_thread(CLONE_NEWPID, sysctl_nested_child, NULL);
 
-	join_newpid_thread(pid);
+	join_thread(pid);
 }
 
 /*
@@ -1433,6 +1601,9 @@ int main(int argc, char **argv)
 	test_seal_grow();
 	test_seal_resize();
 
+	test_sysctl_simple();
+	test_sysctl_nested();
+
 	test_share_dup("SHARE-DUP", "");
 	test_share_mmap("SHARE-MMAP", "");
 	test_share_open("SHARE-OPEN", "");
@@ -1447,8 +1618,6 @@ int main(int argc, char **argv)
 	test_share_fork("SHARE-FORK", SHARED_FT_STR);
 	join_idle_thread(pid);
 
-	test_sysctl();
-
 	printf("memfd: DONE\n");
 
 	return 0;
_

Patches currently in -mm which might be from cyphar@cyphar.com are

selftests-memfd-error-out-test-process-when-child-test-fails.patch
memfd-do-not-eacces-old-memfd_create-users-with-vmmemfd_noexec=2.patch
memfd-improve-userspace-warnings-for-missing-exec-related-flags.patch
memfd-replace-ratcheting-feature-from-vmmemfd_noexec-with-hierarchy.patch
selftests-improve-vmmemfd_noexec-sysctl-tests.patch

