Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25A2EC77B72
	for <mm-commits@archiver.kernel.org>; Fri, 14 Apr 2023 21:16:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbjDNVQk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Apr 2023 17:16:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229647AbjDNVQj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Apr 2023 17:16:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C181D59C6
        for <mm-commits@vger.kernel.org>; Fri, 14 Apr 2023 14:16:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5C2E364A48
        for <mm-commits@vger.kernel.org>; Fri, 14 Apr 2023 21:16:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE1BDC433EF;
        Fri, 14 Apr 2023 21:16:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681506996;
        bh=L4YE5cQYvs2z5m6F5/J2vHk1wcQcSL75jWVOWFenC+c=;
        h=Date:To:From:Subject:From;
        b=jb/bvPIog08UwI4kUUpzmwA++Mzv+quLZpVxE1IuC3dLgfYfQRhsZFBaxxXBhOop4
         sUoOtvbbyx6bH5d8GGrCYj/fzVFxPkXAMBSuoPIJohLPD9+/WPV47EcmHVs3vv4pOE
         5h9vg7SQ4t7gwlNBBbMdYb/oHpo7Kqd3/IO9jc+k=
Date:   Fri, 14 Apr 2023 14:16:35 -0700
To:     mm-commits@vger.kernel.org, yujie.liu@intel.com,
        skhan@linuxfoundation.org, keescook@chromium.org,
        jorgelo@chromium.org, jannh@google.com, hughd@google.com,
        dverkamp@chromium.org, dmitry.torokhov@gmail.com,
        jeffxu@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-memfd-fix-test_sysctl.patch added to mm-unstable branch
Message-Id: <20230414211636.AE1BDC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/memfd: fix test_sysctl
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-memfd-fix-test_sysctl.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-memfd-fix-test_sysctl.patch

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
From: Jeff Xu <jeffxu@google.com>
Subject: selftests/memfd: fix test_sysctl
Date: Fri, 14 Apr 2023 02:28:01 +0000

sysctl memfd_noexec is pid-namespaced, non-reservable, and inherent to the
child process.

Move the inherence test from init ns to child ns, so init ns can keep the
default value.

Link: https://lkml.kernel.org/r/20230414022801.2545257-1-jeffxu@google.com
Signed-off-by: Jeff Xu <jeffxu@google.com>
Reported-by: kernel test robot <yujie.liu@intel.com>
  Link: https://lore.kernel.org/oe-lkp/202303312259.441e35db-yujie.liu@intel.com
Tested-by: Yujie Liu <yujie.liu@intel.com>
Cc: Daniel Verkamp <dverkamp@chromium.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jorge Lucangeli Obes <jorgelo@chromium.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/memfd/memfd_test.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/tools/testing/selftests/memfd/memfd_test.c~selftests-memfd-fix-test_sysctl
+++ a/tools/testing/selftests/memfd/memfd_test.c
@@ -43,6 +43,9 @@
  */
 static size_t mfd_def_size = MFD_DEF_SIZE;
 static const char *memfd_str = MEMFD_STR;
+static pid_t spawn_newpid_thread(unsigned int flags, int (*fn)(void *));
+static int newpid_thread_fn2(void *arg);
+static void join_newpid_thread(pid_t pid);
 
 static ssize_t fd2name(int fd, char *buf, size_t bufsize)
 {
@@ -1111,6 +1114,7 @@ static void test_noexec_seal(void)
 static void test_sysctl_child(void)
 {
 	int fd;
+	int pid;
 
 	printf("%s sysctl 0\n", memfd_str);
 	sysctl_assert_write("0");
@@ -1129,6 +1133,10 @@ static void test_sysctl_child(void)
 			    mfd_def_size,
 			    MFD_CLOEXEC | MFD_ALLOW_SEALING);
 
+	printf("%s child ns\n", memfd_str);
+	pid = spawn_newpid_thread(CLONE_NEWPID, newpid_thread_fn2);
+	join_newpid_thread(pid);
+
 	mfd_assert_mode(fd, 0666);
 	mfd_assert_has_seals(fd, F_SEAL_EXEC);
 	mfd_fail_chmod(fd, 0777);
@@ -1206,12 +1214,6 @@ static void test_sysctl(void)
 	int pid = spawn_newpid_thread(CLONE_NEWPID, newpid_thread_fn);
 
 	join_newpid_thread(pid);
-
-	printf("%s child ns\n", memfd_str);
-	sysctl_assert_write("1");
-
-	pid = spawn_newpid_thread(CLONE_NEWPID, newpid_thread_fn2);
-	join_newpid_thread(pid);
 }
 
 /*
_

Patches currently in -mm which might be from jeffxu@google.com are

selftests-memfd-fix-test_sysctl.patch

