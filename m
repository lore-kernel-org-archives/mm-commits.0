Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92B6BC433EF
	for <mm-commits@archiver.kernel.org>; Wed, 13 Jul 2022 16:23:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236950AbiGMQXX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 13 Jul 2022 12:23:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236758AbiGMQXX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 13 Jul 2022 12:23:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E1052CCA0
        for <mm-commits@vger.kernel.org>; Wed, 13 Jul 2022 09:23:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E6B1BB820D8
        for <mm-commits@vger.kernel.org>; Wed, 13 Jul 2022 16:23:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FE34C34114;
        Wed, 13 Jul 2022 16:23:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1657729399;
        bh=tgZPqO2Zeuqin0srJFTe35B1Xj/jDm5gfimWUO07vbs=;
        h=Date:To:From:Subject:From;
        b=FZu0rvNLzT8NKj4f+WRjNGsErddvutMSIqwNXr2G1e7E8+7Gdjshn0JxoJBx35JMm
         2aqyPIaKPGsKOYXmsDsdQ2KL5eJ4+zddeVrFX1bipp6NnRYMacHdkrNeYeNKdwWQKH
         ReGG6H00zHS+NF8zcW5ihdREPRsdylvuI9nWUzEg=
Date:   Wed, 13 Jul 2022 09:23:18 -0700
To:     mm-commits@vger.kernel.org, skhan@linuxfoundation.org,
        dylanbhatch@google.com, adobriyan@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + proc-fix-test-for-vsyscall=xonly-boot-option.patch added to mm-nonmm-unstable branch
Message-Id: <20220713162319.7FE34C34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: proc: fix test for "vsyscall=xonly" boot option
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     proc-fix-test-for-vsyscall=xonly-boot-option.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/proc-fix-test-for-vsyscall=xonly-boot-option.patch

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
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: proc: fix test for "vsyscall=xonly" boot option
Date: Tue, 12 Jul 2022 17:51:45 +0300

Booting with vsyscall=xonly results in the following vsyscall VMA:

	ffffffffff600000-ffffffffff601000 --xp ... [vsyscall]


Test does read from fixed vsyscall address to determine if kernel
supports vsyscall page but it doesn't work because, well, vsyscall
page is execute only.

Fix test by trying to execute from the first byte of the page which
contains gettimeofday() stub. This should work because vsyscall
entry points have stable addresses by design.

	Alexey, avoiding parsing .config, /proc/config.gz and
	/proc/cmdline at all costs.

Link: https://lkml.kernel.org/r/Ys2KgeiEMboU8Ytu@localhost.localdomain
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: <dylanbhatch@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/proc/proc-pid-vm.c |   75 +++++++++++++++++--
 1 file changed, 68 insertions(+), 7 deletions(-)

--- a/tools/testing/selftests/proc/proc-pid-vm.c~proc-fix-test-for-vsyscall=xonly-boot-option
+++ a/tools/testing/selftests/proc/proc-pid-vm.c
@@ -211,10 +211,19 @@ static int make_exe(const uint8_t *paylo
 }
 #endif
 
-static bool g_vsyscall = false;
+/*
+ * 0: vsyscall VMA doesn't exist	vsyscall=none
+ * 1: vsyscall VMA is r-xp		vsyscall=emulate
+ * 2: vsyscall VMA is --xp		vsyscall=xonly
+ */
+static int g_vsyscall;
+static const char *str_vsyscall;
 
-static const char str_vsyscall[] =
+static const char str_vsyscall_0[] = "";
+static const char str_vsyscall_1[] =
 "ffffffffff600000-ffffffffff601000 r-xp 00000000 00:00 0                  [vsyscall]\n";
+static const char str_vsyscall_2[] =
+"ffffffffff600000-ffffffffff601000 --xp 00000000 00:00 0                  [vsyscall]\n";
 
 #ifdef __x86_64__
 static void sigaction_SIGSEGV(int _, siginfo_t *__, void *___)
@@ -223,7 +232,7 @@ static void sigaction_SIGSEGV(int _, sig
 }
 
 /*
- * vsyscall page can't be unmapped, probe it with memory load.
+ * vsyscall page can't be unmapped, probe it directly.
  */
 static void vsyscall(void)
 {
@@ -246,13 +255,52 @@ static void vsyscall(void)
 		act.sa_sigaction = sigaction_SIGSEGV;
 		(void)sigaction(SIGSEGV, &act, NULL);
 
+		/* gettimeofday(NULL, NULL); */
+		asm volatile (
+			"call %P0"
+			:
+			: "i" (0xffffffffff600000), "D" (NULL), "S" (NULL)
+			: "rax", "rcx", "r11"
+		);
+		exit(0);
+	}
+	waitpid(pid, &wstatus, 0);
+	if (WIFEXITED(wstatus) && WEXITSTATUS(wstatus) == 0) {
+		/* vsyscall page exists and is executable. */
+	} else {
+		/* vsyscall page doesn't exist. */
+		g_vsyscall = 0;
+		return;
+	}
+
+	pid = fork();
+	if (pid < 0) {
+		fprintf(stderr, "fork, errno %d\n", errno);
+		exit(1);
+	}
+	if (pid == 0) {
+		struct rlimit rlim = {0, 0};
+		(void)setrlimit(RLIMIT_CORE, &rlim);
+
+		/* Hide "segfault at ffffffffff600000" messages. */
+		struct sigaction act;
+		memset(&act, 0, sizeof(struct sigaction));
+		act.sa_flags = SA_SIGINFO;
+		act.sa_sigaction = sigaction_SIGSEGV;
+		(void)sigaction(SIGSEGV, &act, NULL);
+
 		*(volatile int *)0xffffffffff600000UL;
 		exit(0);
 	}
 	waitpid(pid, &wstatus, 0);
 	if (WIFEXITED(wstatus) && WEXITSTATUS(wstatus) == 0) {
-		g_vsyscall = true;
+		/* vsyscall page is readable and executable. */
+		g_vsyscall = 1;
+		return;
 	}
+
+	/* vsyscall page is executable but unreadable. */
+	g_vsyscall = 2;
 }
 
 int main(void)
@@ -261,6 +309,19 @@ int main(void)
 	int exec_fd;
 
 	vsyscall();
+	switch (g_vsyscall) {
+	case 0:
+		str_vsyscall = str_vsyscall_0;
+		break;
+	case 1:
+		str_vsyscall = str_vsyscall_1;
+		break;
+	case 2:
+		str_vsyscall = str_vsyscall_2;
+		break;
+	default:
+		abort();
+	}
 
 	atexit(ate);
 
@@ -314,7 +375,7 @@ int main(void)
 
 	/* Test /proc/$PID/maps */
 	{
-		const size_t len = strlen(buf0) + (g_vsyscall ? strlen(str_vsyscall) : 0);
+		const size_t len = strlen(buf0) + strlen(str_vsyscall);
 		char buf[256];
 		ssize_t rv;
 		int fd;
@@ -327,7 +388,7 @@ int main(void)
 		rv = read(fd, buf, sizeof(buf));
 		assert(rv == len);
 		assert(memcmp(buf, buf0, strlen(buf0)) == 0);
-		if (g_vsyscall) {
+		if (g_vsyscall > 0) {
 			assert(memcmp(buf + strlen(buf0), str_vsyscall, strlen(str_vsyscall)) == 0);
 		}
 	}
@@ -374,7 +435,7 @@ int main(void)
 			assert(memmem(buf, rv, S[i], strlen(S[i])));
 		}
 
-		if (g_vsyscall) {
+		if (g_vsyscall > 0) {
 			assert(memmem(buf, rv, str_vsyscall, strlen(str_vsyscall)));
 		}
 	}
_

Patches currently in -mm which might be from adobriyan@gmail.com are

proc-delete-unused-linux-uaccessh-includes.patch
proc-fix-test-for-vsyscall=xonly-boot-option.patch

