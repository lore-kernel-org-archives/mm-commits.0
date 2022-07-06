Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DFAEC433EF
	for <mm-commits@archiver.kernel.org>; Wed,  6 Jul 2022 18:58:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232578AbiGFS6S (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 6 Jul 2022 14:58:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230502AbiGFS6S (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 6 Jul 2022 14:58:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A86FB2A941
        for <mm-commits@vger.kernel.org>; Wed,  6 Jul 2022 11:58:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 55CE0B81E83
        for <mm-commits@vger.kernel.org>; Wed,  6 Jul 2022 18:58:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB012C3411C;
        Wed,  6 Jul 2022 18:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1657133893;
        bh=9G+DSu/uakVjE+HYxS9/HxvpaYZOpVAIaxouy1mc9/w=;
        h=Date:To:From:Subject:From;
        b=gdeJ461oA2q5uN8Hud7+UhHbfxUeXkLT1y0enDwr2cIf9KiJ3MbKuyAbM3idn0j0X
         SG3KhgLZOVoDEu39AmwE3IIuiqUDh1JZW1hVnAacEZztGt2ly0fZossPh5KSDjHydG
         1bJ92GNJmnKqAQot/aNPg+7Fpr00hfSrJ9PW7jzY=
Date:   Wed, 06 Jul 2022 11:58:12 -0700
To:     mm-commits@vger.kernel.org, void@manifault.com, surenb@google.com,
        shuah@kernel.org, adam@wowsignal.io, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-vm-fix-errno-handling-in-mrelease_test-v4.patch added to mm-unstable branch
Message-Id: <20220706185812.EB012C3411C@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests-vm-fix-errno-handling-in-mrelease_test-v4
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-vm-fix-errno-handling-in-mrelease_test-v4.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-vm-fix-errno-handling-in-mrelease_test-v4.patch

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
selftests-vm-fix-errno-handling-in-mrelease_test-v4.patch
selftests-vm-skip-128tbswitch-on-unsupported-arch.patch

