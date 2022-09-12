Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0A0EECAAA1
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 04:57:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbiILE5A (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 12 Sep 2022 00:57:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbiILE4r (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Sep 2022 00:56:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C43B27DDA
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 21:56:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CCB3BB80BA8
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 04:56:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F853C433D7;
        Mon, 12 Sep 2022 04:56:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662958588;
        bh=2fV+WsI9vErRJiNO93/BQwnuot7mhovW36ERXbKRoj0=;
        h=Date:To:From:Subject:From;
        b=DYyCrlmLSaqdjiyhOeKYVMGbxAub6WM6Yya+GaxN9qH0xT8Ru+6ZDFMSVqBM5GzV9
         YD2wMsRmKndSfEdfZz6A3FKct3Pm5NLF0MpSrOvYQkJPapXuCCdC/dY5drWqVyAv5k
         eT+9gfXALjpPPYTevQsa+5i9PPpadxldY6NI1iVo=
Date:   Sun, 11 Sep 2022 21:56:27 -0700
To:     mm-commits@vger.kernel.org, adobriyan@gmail.com,
        bfoster@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] proc-save-loc-in-vsyscall-test.patch removed from -mm tree
Message-Id: <20220912045628.7F853C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: proc: save LOC in vsyscall test
has been removed from the -mm tree.  Its filename was
     proc-save-loc-in-vsyscall-test.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Brian Foster <bfoster@redhat.com>
Subject: proc: save LOC in vsyscall test
Date: Mon, 15 Aug 2022 12:50:04 +0300

Do one fork in vsyscall detection code and let SIGSEGV handler exit and
carry information to the parent saving LOC.

[adobriyan@gmail.com: redo original patch, delete unnecessary variables, minimise code changes]
Link: https://lkml.kernel.org/r/YvoWzAn5dlhF75xa@localhost.localdomain
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Brian Foster <bfoster@redhat.com>
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


