Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24CFAC433F5
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 22:44:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234055AbiCYWqA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Mar 2022 18:46:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234057AbiCYWpH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 25 Mar 2022 18:45:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50FC520C1BE
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 15:43:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F310CB82A35
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 22:43:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A65F8C004DD;
        Fri, 25 Mar 2022 22:43:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648248206;
        bh=PDkEJVV4vaJOnB8m3DcUo0VZJNfylridtgNYvQU7q00=;
        h=Date:To:From:Subject:From;
        b=c417KqeYDEEZEdOT3v5+zWW3llBeNqDHUYBI/6+Nk9iHnn/Xhr/f7GWTghHuLtjSt
         D89sYJtMDDaKvsoGEMLquNFQyfVf/5jxIxoxrWfdAUacCoEpn/HmB41HWsiD1SbHhB
         1K2580bhG1mAlY065qHjt4xXbNF5JQ5oilhThINA=
Date:   Fri, 25 Mar 2022 15:43:26 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org,
        keescook@chromium.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] selftests-kselftest-framework-provide-finished-helper.patch removed from -mm tree
Message-Id: <20220325224326.A65F8C004DD@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests: kselftest framework: provide "finished" helper
has been removed from the -mm tree.  Its filename was
     selftests-kselftest-framework-provide-finished-helper.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


