Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8ADE2C4167B
	for <mm-commits@archiver.kernel.org>; Wed,  1 Nov 2023 19:47:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347364AbjKATri (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 1 Nov 2023 15:47:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347370AbjKATrf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 1 Nov 2023 15:47:35 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E361BD
        for <mm-commits@vger.kernel.org>; Wed,  1 Nov 2023 12:47:29 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F62BC433C8;
        Wed,  1 Nov 2023 19:47:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1698868048;
        bh=nOmjIuBDRBdjJ1JS+xEmflhB4lON0lSLc3GrJyDW1GU=;
        h=Date:To:From:Subject:From;
        b=ikCNlbe34u+P+N61+rwBbPYoX9CMoLkTbF3BP2o5B+xRqO/J8tvsdH6EI8SCefsrQ
         hg4icKwPLRDx9m/Ps8aGknkLjaSOiF22aimfUZmGILE67DUtN1COm+1o7GWj3rtuke
         IfoJJXZ7gB28pNpKmvcT8Jy9v6ELmgOKfKrjjFGE=
Date:   Wed, 01 Nov 2023 12:47:28 -0700
To:     mm-commits@vger.kernel.org, adobriyan@gmail.com,
        swarupkotikalapudi@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] proc-test-protectionkey-in-proc-empty-vm-test.patch removed from -mm tree
Message-Id: <20231101194728.9F62BC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: proc: test ProtectionKey in proc-empty-vm test
has been removed from the -mm tree.  Its filename was
     proc-test-protectionkey-in-proc-empty-vm-test.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Swarup Laxman Kotiaklapudi <swarupkotikalapudi@gmail.com>
Subject: proc: test ProtectionKey in proc-empty-vm test
Date: Fri, 27 Oct 2023 17:26:24 +0300

Check ProtectionKey field in /proc/*/smaps output, if system supports
protection keys feature.

[adobriyan@gmail.com: test support in the beginning of the program, use syscall, not glibc pkey_alloc(3) which may not compile]

Link: https://lkml.kernel.org/r/ac05efa7-d2a0-48ad-b704-ffdd5450582e@p183
Signed-off-by: Swarup Laxman Kotiaklapudi <swarupkotikalapudi@gmail.com>
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Reviewed-by: Swarup Laxman Kotikalapudi<swarupkotikalapudi@gmail.com>
Tested-by: Swarup Laxman Kotikalapudi<swarupkotikalapudi@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/proc/proc-empty-vm.c |   79 +++++++++++++----
 1 file changed, 61 insertions(+), 18 deletions(-)

--- a/tools/testing/selftests/proc/proc-empty-vm.c~proc-test-protectionkey-in-proc-empty-vm-test
+++ a/tools/testing/selftests/proc/proc-empty-vm.c
@@ -23,6 +23,9 @@
  *	/proc/${pid}/smaps
  *	/proc/${pid}/smaps_rollup
  */
+#undef _GNU_SOURCE
+#define _GNU_SOURCE
+
 #undef NDEBUG
 #include <assert.h>
 #include <errno.h>
@@ -34,6 +37,7 @@
 #include <sys/mman.h>
 #include <sys/ptrace.h>
 #include <sys/resource.h>
+#include <sys/syscall.h>
 #include <sys/types.h>
 #include <sys/wait.h>
 #include <unistd.h>
@@ -42,6 +46,43 @@
 #define TEST_VSYSCALL
 #endif
 
+#if defined __amd64__
+	#ifndef SYS_pkey_alloc
+		#define SYS_pkey_alloc 330
+	#endif
+	#ifndef SYS_pkey_free
+		#define SYS_pkey_free 331
+	#endif
+#elif defined __i386__
+	#ifndef SYS_pkey_alloc
+		#define SYS_pkey_alloc 381
+	#endif
+	#ifndef SYS_pkey_free
+		#define SYS_pkey_free 382
+	#endif
+#else
+	#error "SYS_pkey_alloc"
+#endif
+
+static int g_protection_key_support;
+
+static int protection_key_support(void)
+{
+	long rv = syscall(SYS_pkey_alloc, 0, 0);
+	if (rv > 0) {
+		syscall(SYS_pkey_free, (int)rv);
+		return 1;
+	} else if (rv == -1 && errno == ENOSYS) {
+		return 0;
+	} else if (rv == -1 && errno == EINVAL) {
+		// ospke=n
+		return 0;
+	} else {
+		fprintf(stderr, "%s: error: rv %ld, errno %d\n", __func__, rv, errno);
+		exit(EXIT_FAILURE);
+	}
+}
+
 /*
  * 0: vsyscall VMA doesn't exist	vsyscall=none
  * 1: vsyscall VMA is --xp		vsyscall=xonly
@@ -84,10 +125,6 @@ static const char proc_pid_smaps_vsyscal
 "SwapPss:               0 kB\n"
 "Locked:                0 kB\n"
 "THPeligible:           0\n"
-/*
- * "ProtectionKey:" field is conditional. It is possible to check it as well,
- * but I don't have such machine.
- */
 ;
 
 static const char proc_pid_smaps_vsyscall_2[] =
@@ -115,10 +152,6 @@ static const char proc_pid_smaps_vsyscal
 "SwapPss:               0 kB\n"
 "Locked:                0 kB\n"
 "THPeligible:           0\n"
-/*
- * "ProtectionKey:" field is conditional. It is possible to check it as well,
- * but I'm too tired.
- */
 ;
 
 static void sigaction_SIGSEGV(int _, siginfo_t *__, void *___)
@@ -240,19 +273,27 @@ static int test_proc_pid_smaps(pid_t pid
 		}
 		perror("open /proc/${pid}/smaps");
 		return EXIT_FAILURE;
+	}
+	ssize_t rv = read(fd, buf, sizeof(buf));
+	close(fd);
+
+	assert(0 <= rv);
+	assert(rv <= sizeof(buf));
+
+	if (g_vsyscall == 0) {
+		assert(rv == 0);
 	} else {
-		ssize_t rv = read(fd, buf, sizeof(buf));
-		close(fd);
-		if (g_vsyscall == 0) {
-			assert(rv == 0);
-		} else {
-			size_t len = strlen(g_proc_pid_smaps_vsyscall);
-			/* TODO "ProtectionKey:" */
-			assert(rv > len);
-			assert(memcmp(buf, g_proc_pid_smaps_vsyscall, len) == 0);
+		size_t len = strlen(g_proc_pid_smaps_vsyscall);
+		assert(rv > len);
+		assert(memcmp(buf, g_proc_pid_smaps_vsyscall, len) == 0);
+
+		if (g_protection_key_support) {
+#define PROTECTION_KEY "ProtectionKey:         0\n"
+			assert(memmem(buf, rv, PROTECTION_KEY, strlen(PROTECTION_KEY)));
 		}
-		return EXIT_SUCCESS;
 	}
+
+	return EXIT_SUCCESS;
 }
 
 static const char g_smaps_rollup[] =
@@ -419,6 +460,8 @@ int main(void)
 		abort();
 	}
 
+	g_protection_key_support = protection_key_support();
+
 	pid_t pid = fork();
 	if (pid == -1) {
 		perror("fork");
_

Patches currently in -mm which might be from swarupkotikalapudi@gmail.com are


