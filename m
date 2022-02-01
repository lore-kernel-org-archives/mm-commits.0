Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77E0BC433F5
	for <mm-commits@archiver.kernel.org>; Tue,  1 Feb 2022 02:03:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232541AbiBACDH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 31 Jan 2022 21:03:07 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:57688 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232874AbiBACCB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 31 Jan 2022 21:02:01 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8A4EEB82CEE
        for <mm-commits@vger.kernel.org>; Tue,  1 Feb 2022 02:02:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC9E3C34104;
        Tue,  1 Feb 2022 02:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643680919;
        bh=y9vLdK9O8sBrAaVQ3uhJ1M7pMNZL6lZCPhsZ8RiGyD0=;
        h=Date:To:From:Subject:From;
        b=ZFdTi/JEiz8mNKZ4DupNNoiC7u4PsxZxuXNS1yzmWRNBFnDdPV48SqCl3Nra89BBP
         hs7btrh+cYuzofx+L02jTyPpJ9SGU4cfgOEUgL8wZeqr9AYEwfvLjjO54uVZbK5NrX
         xrYHJ3xIjU2ETe5Vf0GKDUzihq6RlTBg7eSlkVlM=
Received: by hp1 (sSMTP sendmail emulation); Mon, 31 Jan 2022 18:01:57 -0800
Date:   Mon, 31 Jan 2022 18:01:57 -0800
To:     mm-commits@vger.kernel.org, shuah@kernel.org,
        keescook@chromium.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-kselftest-framework-provide-finished-helper.patch added to -mm tree
Message-Id: <20220201020157.DC9E3C34104@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests: kselftest framework: provide "finished" helper
has been added to the -mm tree.  Its filename is
     selftests-kselftest-framework-provide-finished-helper.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/selftests-kselftest-framework-provide-finished-helper.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/selftests-kselftest-framework-provide-finished-helper.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: selftests: kselftest framework: provide "finished" helper

Instead of having each time that wants to use ksft_exit() have to figure
out the internals of kselftest.h, add the helper ksft_finished() that
makes sure the passes, xfails, and skips are equal to the test plan count.

Link: https://lkml.kernel.org/r/20220201013717.2464392-1-keescook@chromium.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/kselftest.h       |   10 ++++++++++
 tools/testing/selftests/vm/memfd_secret.c |    2 +-
 2 files changed, 11 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/kselftest.h~selftests-kselftest-framework-provide-finished-helper
+++ a/tools/testing/selftests/kselftest.h
@@ -28,6 +28,7 @@
  *
  * When all tests are finished, clean up and exit the program with one of:
  *
+ *    ksft_finished();
  *    ksft_exit(condition);
  *    ksft_exit_pass();
  *    ksft_exit_fail();
@@ -235,6 +236,15 @@ static inline int ksft_exit_fail(void)
 		ksft_exit_fail();	\
 	} while (0)
 
+/**
+ * ksft_finished() - Exit selftest with success if all tests passed
+ */
+#define ksft_finished()			\
+	ksft_exit(ksft_plan ==		\
+		  ksft_cnt.ksft_pass +	\
+		  ksft_cnt.ksft_xfail +	\
+		  ksft_cnt.ksft_xskip)
+
 static inline int ksft_exit_fail_msg(const char *msg, ...)
 {
 	int saved_errno = errno;
--- a/tools/testing/selftests/vm/memfd_secret.c~selftests-kselftest-framework-provide-finished-helper
+++ a/tools/testing/selftests/vm/memfd_secret.c
@@ -282,7 +282,7 @@ int main(int argc, char *argv[])
 
 	close(fd);
 
-	ksft_exit(!ksft_get_fail_cnt());
+	ksft_finished();
 }
 
 #else /* __NR_memfd_secret */
_

Patches currently in -mm which might be from keescook@chromium.org are

kconfigdebug-make-debug_info-selectable-from-a-choice.patch
kconfigdebug-make-debug_info-selectable-from-a-choice-fix.patch
exec-force-single-empty-string-when-argv-is-empty.patch
selftests-exec-test-for-empty-string-on-null-argv.patch
selftests-kselftest-framework-provide-finished-helper.patch

