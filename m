Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 394E5C00144
	for <mm-commits@archiver.kernel.org>; Sat, 30 Jul 2022 01:08:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231613AbiG3BIW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Jul 2022 21:08:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239591AbiG3BIS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Jul 2022 21:08:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC7FB820F4
        for <mm-commits@vger.kernel.org>; Fri, 29 Jul 2022 18:08:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7D46261BF4
        for <mm-commits@vger.kernel.org>; Sat, 30 Jul 2022 01:08:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEF79C433C1;
        Sat, 30 Jul 2022 01:08:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1659143296;
        bh=0EZVC8cjn5icsvwULRh8vVuqbKJGBsTDJzGGZO7Uflo=;
        h=Date:To:From:Subject:From;
        b=o8e+AVqKxWhW758Xto66ipBd9YpPCgij7VUICPjuy2gQygux9l/+rKIKkPv/YSCC7
         tWYsy5dxspRuFriUhVkXyMbJy0ZS4n+kU7voSEIBzYXu2yZxBR0ItNXowGJOU9s101
         jTWQYHjGnatZikrHC3VVhOlcl2G93595h0D4sbEw=
Date:   Fri, 29 Jul 2022 18:08:16 -0700
To:     mm-commits@vger.kernel.org, void@manifault.com, surenb@google.com,
        shuah@kernel.org, adam@wowsignal.io, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-vm-fix-errno-handling-in-mrelease_test.patch removed from -mm tree
Message-Id: <20220730010816.CEF79C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests/vm: fix errno handling in mrelease_test
has been removed from the -mm tree.  Its filename was
     selftests-vm-fix-errno-handling-in-mrelease_test.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Adam Sindelar <adam@wowsignal.io>
Subject: selftests/vm: fix errno handling in mrelease_test
Date: Mon, 4 Jul 2022 19:33:51 +0200

mrelease_test should return KSFT_SKIP when process_mrelease is not
defined, but due to a perror call consuming the errno, it returns
KSFT_FAIL.

This patch decides the exit code before calling perror.

[adam@wowsignal.io: fix remaining instances of errno mishandling]
  Link: https://lkml.kernel.org/r/20220706141602.10159-1-adam@wowsignal.io
Link: https://lkml.kernel.org/r/20220704173351.19595-1-adam@wowsignal.io
Fixes: 33776141b812 ("selftests: vm: add process_mrelease tests")
Signed-off-by: Adam Sindelar <adam@wowsignal.io>
Reviewed-by: David Vernet <void@manifault.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/mrelease_test.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

--- a/tools/testing/selftests/vm/mrelease_test.c~selftests-vm-fix-errno-handling-in-mrelease_test
+++ a/tools/testing/selftests/vm/mrelease_test.c
@@ -62,19 +62,22 @@ static int alloc_noexit(unsigned long nr
 /* The process_mrelease calls in this test are expected to fail */
 static void run_negative_tests(int pidfd)
 {
+	int res;
 	/* Test invalid flags. Expect to fail with EINVAL error code. */
 	if (!syscall(__NR_process_mrelease, pidfd, (unsigned int)-1) ||
 			errno != EINVAL) {
+		res = (errno == ENOSYS ? KSFT_SKIP : KSFT_FAIL);
 		perror("process_mrelease with wrong flags");
-		exit(errno == ENOSYS ? KSFT_SKIP : KSFT_FAIL);
+		exit(res);
 	}
 	/*
 	 * Test reaping while process is alive with no pending SIGKILL.
 	 * Expect to fail with EINVAL error code.
 	 */
 	if (!syscall(__NR_process_mrelease, pidfd, 0) || errno != EINVAL) {
+		res = (errno == ENOSYS ? KSFT_SKIP : KSFT_FAIL);
 		perror("process_mrelease on a live process");
-		exit(errno == ENOSYS ? KSFT_SKIP : KSFT_FAIL);
+		exit(res);
 	}
 }
 
@@ -100,8 +103,9 @@ int main(void)
 
 	/* Test a wrong pidfd */
 	if (!syscall(__NR_process_mrelease, -1, 0) || errno != EBADF) {
+		res = (errno == ENOSYS ? KSFT_SKIP : KSFT_FAIL);
 		perror("process_mrelease with wrong pidfd");
-		exit(errno == ENOSYS ? KSFT_SKIP : KSFT_FAIL);
+		exit(res);
 	}
 
 	/* Start the test with 1MB child memory allocation */
@@ -156,8 +160,9 @@ retry:
 	run_negative_tests(pidfd);
 
 	if (kill(pid, SIGKILL)) {
+		res = (errno == ENOSYS ? KSFT_SKIP : KSFT_FAIL);
 		perror("kill");
-		exit(errno == ENOSYS ? KSFT_SKIP : KSFT_FAIL);
+		exit(res);
 	}
 
 	success = (syscall(__NR_process_mrelease, pidfd, 0) == 0);
@@ -172,9 +177,10 @@ retry:
 		if (errno == ESRCH) {
 			retry = (size <= MAX_SIZE_MB);
 		} else {
+			res = (errno == ENOSYS ? KSFT_SKIP : KSFT_FAIL);
 			perror("process_mrelease");
 			waitpid(pid, NULL, 0);
-			exit(errno == ENOSYS ? KSFT_SKIP : KSFT_FAIL);
+			exit(res);
 		}
 	}
 
_

Patches currently in -mm which might be from adam@wowsignal.io are


