Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BAB3C43334
	for <mm-commits@archiver.kernel.org>; Mon,  4 Jul 2022 22:41:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229641AbiGDWlQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 4 Jul 2022 18:41:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiGDWlP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 4 Jul 2022 18:41:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22792E02D
        for <mm-commits@vger.kernel.org>; Mon,  4 Jul 2022 15:41:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AA2F861785
        for <mm-commits@vger.kernel.org>; Mon,  4 Jul 2022 22:41:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E50B4C3411E;
        Mon,  4 Jul 2022 22:41:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656974472;
        bh=WjbQI/hYOV+i70DvshVvEyBeGEgv6sT1GEp5ixlB7ZE=;
        h=Date:To:From:Subject:From;
        b=iGdN3IHLo////M8/I+dEwX7fwG/9fWsnSzJMN+Y8Sir843X2e6E3Hpqt2euqz4i6Y
         VEz4ihz9D+KZC6MXPJw43OfAFL8yGPNcJ2rp4b1rNyHH+uVN5zZPP35tKmXVnesfVY
         mr776RmN4DIy0wtOfMcVkTApYGAaZ8owabDc59n8=
Date:   Mon, 04 Jul 2022 15:41:11 -0700
To:     mm-commits@vger.kernel.org, void@manifault.com, shuah@kernel.org,
        adam@wowsignal.io, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-vm-fix-errno-handling-in-mrelease_test.patch added to mm-unstable branch
Message-Id: <20220704224111.E50B4C3411E@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/vm: fix errno handling in mrelease_test
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-vm-fix-errno-handling-in-mrelease_test.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-vm-fix-errno-handling-in-mrelease_test.patch

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
Subject: selftests/vm: fix errno handling in mrelease_test
Date: Mon, 4 Jul 2022 19:33:51 +0200

mrelease_test should return KSFT_SKIP when process_mrelease is not
defined, but due to a perror call consuming the errno, it returns
KSFT_FAIL.

This patch decides the exit code before calling perror.

Link: https://lkml.kernel.org/r/20220704173351.19595-1-adam@wowsignal.io
Signed-off-by: Adam Sindelar <adam@wowsignal.io>
Cc: David Vernet <void@manifault.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/mrelease_test.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/vm/mrelease_test.c~selftests-vm-fix-errno-handling-in-mrelease_test
+++ a/tools/testing/selftests/vm/mrelease_test.c
@@ -100,8 +100,10 @@ int main(void)
 
 	/* Test a wrong pidfd */
 	if (!syscall(__NR_process_mrelease, -1, 0) || errno != EBADF) {
+		/* perror overwrites errno, so this line must be first */
+		res = (errno == ENOSYS ? KSFT_SKIP : KSFT_FAIL);
 		perror("process_mrelease with wrong pidfd");
-		exit(errno == ENOSYS ? KSFT_SKIP : KSFT_FAIL);
+		exit(res);
 	}
 
 	/* Start the test with 1MB child memory allocation */
@@ -156,8 +158,9 @@ retry:
 	run_negative_tests(pidfd);
 
 	if (kill(pid, SIGKILL)) {
+		res = (errno == ENOSYS ? KSFT_SKIP : KSFT_FAIL);
 		perror("kill");
-		exit(errno == ENOSYS ? KSFT_SKIP : KSFT_FAIL);
+		exit(res);
 	}
 
 	success = (syscall(__NR_process_mrelease, pidfd, 0) == 0);
_

Patches currently in -mm which might be from adam@wowsignal.io are

selftests-vm-fix-errno-handling-in-mrelease_test.patch

