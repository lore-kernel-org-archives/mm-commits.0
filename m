Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FA3AC25B08
	for <mm-commits@archiver.kernel.org>; Wed, 17 Aug 2022 18:28:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240183AbiHQS2P (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 17 Aug 2022 14:28:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240853AbiHQS2P (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 17 Aug 2022 14:28:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EA16F4
        for <mm-commits@vger.kernel.org>; Wed, 17 Aug 2022 11:28:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ED31B61382
        for <mm-commits@vger.kernel.org>; Wed, 17 Aug 2022 18:28:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A852C433D7;
        Wed, 17 Aug 2022 18:28:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660760887;
        bh=AzCVYxL/cLDKAY986YVeKGVnRCDWiwZhKfmG0Dc+LgU=;
        h=Date:To:From:Subject:From;
        b=slqE3zZd0aOUfUpqQujs7p/bdCqyA8+zaWnS5j7nlpRtAHHqfrZHjW+hoqy3bWiI6
         mILr+pc3Wlyn7TvYNl4/c4pYVXTuFNbRLkXHVqYfUXxg4sjiqRSTup/+RzYPOM9qzx
         cZkNavrf9MoHGFbkJCcA961ND87eYzb1pXno4FGI=
Date:   Wed, 17 Aug 2022 11:28:06 -0700
To:     mm-commits@vger.kernel.org, adobriyan@gmail.com,
        bfoster@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + proc-save-loc-in-vsyscall-test.patch added to mm-nonmm-unstable branch
Message-Id: <20220817182807.4A852C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: proc: save LOC in vsyscall test
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     proc-save-loc-in-vsyscall-test.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/proc-save-loc-in-vsyscall-test.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Brian Foster <bfoster@redhat.com>
Subject: proc: save LOC in vsyscall test
Date: Mon, 15 Aug 2022 12:50:04 +0300

Do one fork in vsyscall detection code and let SIGSEGV handler exit and
carry information to the parent saving LOC.

[adobriyan@gmail.com: redo original patch, delete unnecessary variables, minimise code changes]
Link: https://lkml.kernel.org/r/YvoWzAn5dlhF75xa@localhost.localdomain
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Tested-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/proc/proc-pid-vm.c |   56 +++++--------------
 1 file changed, 16 insertions(+), 40 deletions(-)

--- a/tools/testing/selftests/proc/proc-pid-vm.c~proc-save-loc-in-vsyscall-test
+++ a/tools/testing/selftests/proc/proc-pid-vm.c
@@ -213,22 +213,22 @@ static int make_exe(const uint8_t *paylo
 
 /*
  * 0: vsyscall VMA doesn't exist	vsyscall=none
- * 1: vsyscall VMA is r-xp		vsyscall=emulate
- * 2: vsyscall VMA is --xp		vsyscall=xonly
+ * 1: vsyscall VMA is --xp		vsyscall=xonly
+ * 2: vsyscall VMA is r-xp		vsyscall=emulate
  */
-static int g_vsyscall;
+static volatile int g_vsyscall;
 static const char *str_vsyscall;
 
 static const char str_vsyscall_0[] = "";
 static const char str_vsyscall_1[] =
-"ffffffffff600000-ffffffffff601000 r-xp 00000000 00:00 0                  [vsyscall]\n";
-static const char str_vsyscall_2[] =
 "ffffffffff600000-ffffffffff601000 --xp 00000000 00:00 0                  [vsyscall]\n";
+static const char str_vsyscall_2[] =
+"ffffffffff600000-ffffffffff601000 r-xp 00000000 00:00 0                  [vsyscall]\n";
 
 #ifdef __x86_64__
 static void sigaction_SIGSEGV(int _, siginfo_t *__, void *___)
 {
-	_exit(1);
+	_exit(g_vsyscall);
 }
 
 /*
@@ -255,6 +255,7 @@ static void vsyscall(void)
 		act.sa_sigaction = sigaction_SIGSEGV;
 		(void)sigaction(SIGSEGV, &act, NULL);
 
+		g_vsyscall = 0;
 		/* gettimeofday(NULL, NULL); */
 		asm volatile (
 			"call %P0"
@@ -262,45 +263,20 @@ static void vsyscall(void)
 			: "i" (0xffffffffff600000), "D" (NULL), "S" (NULL)
 			: "rax", "rcx", "r11"
 		);
-		exit(0);
-	}
-	waitpid(pid, &wstatus, 0);
-	if (WIFEXITED(wstatus) && WEXITSTATUS(wstatus) == 0) {
-		/* vsyscall page exists and is executable. */
-	} else {
-		/* vsyscall page doesn't exist. */
-		g_vsyscall = 0;
-		return;
-	}
-
-	pid = fork();
-	if (pid < 0) {
-		fprintf(stderr, "fork, errno %d\n", errno);
-		exit(1);
-	}
-	if (pid == 0) {
-		struct rlimit rlim = {0, 0};
-		(void)setrlimit(RLIMIT_CORE, &rlim);
-
-		/* Hide "segfault at ffffffffff600000" messages. */
-		struct sigaction act;
-		memset(&act, 0, sizeof(struct sigaction));
-		act.sa_flags = SA_SIGINFO;
-		act.sa_sigaction = sigaction_SIGSEGV;
-		(void)sigaction(SIGSEGV, &act, NULL);
 
+		g_vsyscall = 1;
 		*(volatile int *)0xffffffffff600000UL;
-		exit(0);
+
+		g_vsyscall = 2;
+		exit(g_vsyscall);
 	}
 	waitpid(pid, &wstatus, 0);
-	if (WIFEXITED(wstatus) && WEXITSTATUS(wstatus) == 0) {
-		/* vsyscall page is readable and executable. */
-		g_vsyscall = 1;
-		return;
+	if (WIFEXITED(wstatus)) {
+		g_vsyscall = WEXITSTATUS(wstatus);
+	} else {
+		fprintf(stderr, "error: wstatus %08x\n", wstatus);
+		exit(1);
 	}
-
-	/* vsyscall page is executable but unreadable. */
-	g_vsyscall = 2;
 }
 
 int main(void)
_

Patches currently in -mm which might be from bfoster@redhat.com are

proc-save-loc-in-vsyscall-test.patch

