Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30F63C00144
	for <mm-commits@archiver.kernel.org>; Sat, 30 Jul 2022 00:55:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239548AbiG3AzO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Jul 2022 20:55:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239465AbiG3AzN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Jul 2022 20:55:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDB985F6A
        for <mm-commits@vger.kernel.org>; Fri, 29 Jul 2022 17:55:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 79B5561738
        for <mm-commits@vger.kernel.org>; Sat, 30 Jul 2022 00:55:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC5D5C433D6;
        Sat, 30 Jul 2022 00:55:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1659142510;
        bh=HlD3YQCJVteQONfYe+EZ1AuJOrnsvEjvTWOQX76d9lU=;
        h=Date:To:From:Subject:From;
        b=zeKAybgOE/mYXqDBZ2GjhCL/BzAVwwpGfAT+1F/hoxaHBqUwgE9tQvZ6gUiJAzssf
         s1kGwGmFMSd/R4S8Y9Gfw2hboBScbF90sPZ1NQ6TPvab4oksyXz6nBNI69M0WNZrUT
         oktEoAKsb5oaEzJSPKtefdGeDi/wReZp7iI9mxoQ=
Date:   Fri, 29 Jul 2022 17:55:10 -0700
To:     mm-commits@vger.kernel.org, void@manifault.com, surenb@google.com,
        shuah@kernel.org, adam@wowsignal.io, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] selftests-vm-fix-errno-handling-in-mrelease_test-v4.patch removed from -mm tree
Message-Id: <20220730005510.CC5D5C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests-vm-fix-errno-handling-in-mrelease_test-v4
has been removed from the -mm tree.  Its filename was
     selftests-vm-fix-errno-handling-in-mrelease_test-v4.patch

This patch was dropped because it was folded into selftests-vm-fix-errno-handling-in-mrelease_test.patch

------------------------------------------------------
From: Adam Sindelar <adam@wowsignal.io>
Subject: selftests-vm-fix-errno-handling-in-mrelease_test-v4
Date: Wed, 6 Jul 2022 16:16:02 +0200

fix remaining instances of errno mishandling

Link: https://lkml.kernel.org/r/20220706141602.10159-1-adam@wowsignal.io
Fixes: 33776141b812 ("selftests: vm: add process_mrelease tests")
Signed-off-by: Adam Sindelar <adam@wowsignal.io>
Reviewed-by: David Vernet <void@manifault.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/mrelease_test.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/tools/testing/selftests/vm/mrelease_test.c~selftests-vm-fix-errno-handling-in-mrelease_test-v4
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
 
@@ -100,7 +103,6 @@ int main(void)
 
 	/* Test a wrong pidfd */
 	if (!syscall(__NR_process_mrelease, -1, 0) || errno != EBADF) {
-		/* perror overwrites errno, so this line must be first */
 		res = (errno == ENOSYS ? KSFT_SKIP : KSFT_FAIL);
 		perror("process_mrelease with wrong pidfd");
 		exit(res);
@@ -175,9 +177,10 @@ retry:
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

selftests-vm-fix-errno-handling-in-mrelease_test.patch
selftests-vm-skip-128tbswitch-on-unsupported-arch.patch

