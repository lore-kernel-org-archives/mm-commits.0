Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07946C6FD18
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 23:39:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231270AbjDRXj3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Apr 2023 19:39:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231625AbjDRXhh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2023 19:37:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5EF7B47A
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 16:36:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B7D1360244
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 23:36:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E1B5C433EF;
        Tue, 18 Apr 2023 23:36:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681860963;
        bh=b3nFf1/qbT7NC4p8V2gaWmrKjOn4xqDfOQe7TWVqsN4=;
        h=Date:To:From:Subject:From;
        b=cSVfgXhAO0WS23Pl9ul5SPkpjGwmsnDqI3e0D0Ig/r7OITsQKos9UpfklI0q4cHf4
         +B+nf5LAIN1Yf6TsLBKT9Orfdk6U8lqkgQb2ZXF3PllxkjIoF3qev2pLvakesFSRbS
         JkfOl6I2LPseh5rkULrNUQ0fRf+EYK6Z/TIRLJbE=
Date:   Tue, 18 Apr 2023 16:36:02 -0700
To:     mm-commits@vger.kernel.org, yujie.liu@intel.com,
        skhan@linuxfoundation.org, keescook@chromium.org,
        jorgelo@chromium.org, jannh@google.com, hughd@google.com,
        dverkamp@chromium.org, dmitry.torokhov@gmail.com,
        jeffxu@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-memfd-fix-test_sysctl.patch removed from -mm tree
Message-Id: <20230418233603.1E1B5C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests/memfd: fix test_sysctl
has been removed from the -mm tree.  Its filename was
     selftests-memfd-fix-test_sysctl.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


