Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92523CDB465
	for <mm-commits@archiver.kernel.org>; Sat, 14 Oct 2023 23:12:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229867AbjJNXMo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 14 Oct 2023 19:12:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbjJNXMo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 14 Oct 2023 19:12:44 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB589B7;
        Sat, 14 Oct 2023 16:12:42 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 770DBC433C8;
        Sat, 14 Oct 2023 23:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697325162;
        bh=v+nYtYPI2ctj3SA7cUP65iMCy38xT+md7TH/CNEuk1U=;
        h=Date:To:From:Subject:From;
        b=Dc6YOkWSn0UjlmjQxkKDaUeIzLSdfvZ4x1H7/rymzubgHVAMmqTEmkq/eW9Dv/Zea
         Tc7oDcwpaKeR3H1KUtrCg6x/3Lq0QiR3rtLkwHMY/1F2rrAmp1Ga3Fet0PnFnprjVM
         nNRrLc1PPx4FODnqDfMkwQS6DMI7+MEY7rR5qWtE=
Date:   Sat, 14 Oct 2023 16:12:35 -0700
To:     mm-commits@vger.kernel.org, tglx@linutronix.de,
        stable@vger.kernel.org, shuah@kernel.org, brauner@kernel.org,
        yangtiezhu@loongson.cn, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-clone3-fix-broken-test-under-config_time_ns.patch added to mm-hotfixes-unstable branch
Message-Id: <20231014231241.770DBC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/clone3: Fix broken test under !CONFIG_TIME_NS
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     selftests-clone3-fix-broken-test-under-config_time_ns.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-clone3-fix-broken-test-under-config_time_ns.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Tiezhu Yang <yangtiezhu@loongson.cn>
Subject: selftests/clone3: Fix broken test under !CONFIG_TIME_NS
Date: Tue, 11 Jul 2023 17:13:34 +0800

When execute the following command to test clone3 under !CONFIG_TIME_NS:

  # make headers && cd tools/testing/selftests/clone3 && make && ./clone3

we can see the following error info:

  # [7538] Trying clone3() with flags 0x80 (size 0)
  # Invalid argument - Failed to create new process
  # [7538] clone3() with flags says: -22 expected 0
  not ok 18 [7538] Result (-22) is different than expected (0)
  ...
  # Totals: pass:18 fail:1 xfail:0 xpass:0 skip:0 error:0

This is because if CONFIG_TIME_NS is not set, but the flag
CLONE_NEWTIME (0x80) is used to clone a time namespace, it
will return -EINVAL in copy_time_ns().

If kernel does not support CONFIG_TIME_NS, /proc/self/ns/time
will be not exist, and then we should skip clone3() test with
CLONE_NEWTIME.

With this patch under !CONFIG_TIME_NS:

  # make headers && cd tools/testing/selftests/clone3 && make && ./clone3
  ...
  # Time namespaces are not supported
  ok 18 # SKIP Skipping clone3() with CLONE_NEWTIME
  ...
  # Totals: pass:18 fail:0 xfail:0 xpass:0 skip:1 error:0

Link: https://lkml.kernel.org/r/1689066814-13295-1-git-send-email-yangtiezhu@loongson.cn
Fixes: 515bddf0ec41 ("selftests/clone3: test clone3 with CLONE_NEWTIME")
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/clone3/clone3.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/clone3/clone3.c~selftests-clone3-fix-broken-test-under-config_time_ns
+++ a/tools/testing/selftests/clone3/clone3.c
@@ -196,7 +196,12 @@ int main(int argc, char *argv[])
 			CLONE3_ARGS_NO_TEST);
 
 	/* Do a clone3() in a new time namespace */
-	test_clone3(CLONE_NEWTIME, 0, 0, CLONE3_ARGS_NO_TEST);
+	if (access("/proc/self/ns/time", F_OK) == 0) {
+		test_clone3(CLONE_NEWTIME, 0, 0, CLONE3_ARGS_NO_TEST);
+	} else {
+		ksft_print_msg("Time namespaces are not supported\n");
+		ksft_test_result_skip("Skipping clone3() with CLONE_NEWTIME\n");
+	}
 
 	/* Do a clone3() with exit signal (SIGCHLD) in flags */
 	test_clone3(SIGCHLD, 0, -EINVAL, CLONE3_ARGS_NO_TEST);
_

Patches currently in -mm which might be from yangtiezhu@loongson.cn are

selftests-clone3-fix-broken-test-under-config_time_ns.patch

