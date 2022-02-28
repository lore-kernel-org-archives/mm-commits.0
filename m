Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3828C433F5
	for <mm-commits@archiver.kernel.org>; Mon, 28 Feb 2022 02:58:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232701AbiB1C6p (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 27 Feb 2022 21:58:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232626AbiB1C6m (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 27 Feb 2022 21:58:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24B1C2DAA3
        for <mm-commits@vger.kernel.org>; Sun, 27 Feb 2022 18:58:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B65C860EB5
        for <mm-commits@vger.kernel.org>; Mon, 28 Feb 2022 02:58:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B9C6C340F2;
        Mon, 28 Feb 2022 02:58:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646017082;
        bh=MyzcTS+bB+vghT84ZHIb2hNdZsdnMsLx+upaq5aNxSo=;
        h=Date:To:From:Subject:From;
        b=oEUZRdQeyF4jiT3nEBPLoW9zcFwI7rGvRUW9oujheNLPuEPG/coyWvdgaHXJvpnAm
         JEVSYSsZvFaKadOTualwp42lcqmc+ApJE+V39PuwKWc5cGS/GOB9paJxjhsBLujFKN
         RzfDGJYkGB6jq9HRIGmCBBAysI4VVcenFu5LPGms=
Date:   Sun, 27 Feb 2022 18:58:01 -0800
To:     mm-commits@vger.kernel.org, yangyingliang@huawei.com,
        willy@infradead.org, viro@zeniv.linux.org.uk, shuah@kernel.org,
        mtk.manpages@gmail.com, ebiederm@xmission.com, dalias@libc.org,
        brauner@kernel.org, ariadne@dereferenced.org,
        keescook@chromium.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] selftests-exec-test-for-empty-string-on-null-argv.patch removed from -mm tree
Message-Id: <20220228025802.1B9C6C340F2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/exec: test for empty string on NULL argv
has been removed from the -mm tree.  Its filename was
     selftests-exec-test-for-empty-string-on-null-argv.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: selftests/exec: test for empty string on NULL argv

Test for the NULL argv argument producing a single empty string on exec.

Link: https://lkml.kernel.org/r/20220201011637.2457646-1-keescook@chromium.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Yang Yingliang <yangyingliang@huawei.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Ariadne Conill <ariadne@dereferenced.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Rich Felker <dalias@libc.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/exec/Makefile    |    1 
 tools/testing/selftests/exec/null-argv.c |   78 +++++++++++++++++++++
 2 files changed, 79 insertions(+)

--- a/tools/testing/selftests/exec/Makefile~selftests-exec-test-for-empty-string-on-null-argv
+++ a/tools/testing/selftests/exec/Makefile
@@ -10,6 +10,7 @@ TEST_GEN_FILES := execveat.symlink execv
 TEST_FILES := Makefile
 
 TEST_GEN_PROGS += recursion-depth
+TEST_GEN_PROGS += null-argv
 
 EXTRA_CLEAN := $(OUTPUT)/subdir.moved $(OUTPUT)/execveat.moved $(OUTPUT)/xxxxx*	\
 	       $(OUTPUT)/S_I*.test
--- /dev/null
+++ a/tools/testing/selftests/exec/null-argv.c
@@ -0,0 +1,78 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Test that empty argvs are swapped out for a single empty string. */
+#include <stdio.h>
+#include <unistd.h>
+#include <sys/types.h>
+#include <sys/wait.h>
+
+#include "../kselftest.h"
+
+#define FORK(exec)				\
+do {						\
+	pid = fork();				\
+	if (pid == 0) {				\
+		/* Child */			\
+		exec; /* Some kind of exec */	\
+		perror("# " #exec);		\
+		return 1;			\
+	}					\
+	check_result(pid, #exec);		\
+} while (0)
+
+void check_result(pid_t pid, const char *msg)
+{
+	int wstatus;
+
+	if (pid == (pid_t)-1) {
+		perror("# fork");
+		ksft_test_result_fail("fork failed: %s\n", msg);
+		return;
+	}
+	if (waitpid(pid, &wstatus, 0) < 0) {
+		perror("# waitpid");
+		ksft_test_result_fail("waitpid failed: %s\n", msg);
+		return;
+	}
+	if (!WIFEXITED(wstatus)) {
+		ksft_test_result_fail("child did not exit: %s\n", msg);
+		return;
+	}
+	if (WEXITSTATUS(wstatus) != 0) {
+		ksft_test_result_fail("non-zero exit: %s\n", msg);
+		return;
+	}
+	ksft_test_result_pass("%s\n", msg);
+}
+
+int main(int argc, char *argv[], char *envp[])
+{
+	pid_t pid;
+	static char * const args[] = { NULL };
+	static char * const str[] = { "", NULL };
+
+	/* argc counting checks */
+	if (argc < 1) {
+		fprintf(stderr, "# FAIL: saw argc == 0 (old kernel?)\n");
+		return 1;
+	}
+	if (argc != 1) {
+		fprintf(stderr, "# FAIL: unknown argc (%d)\n", argc);
+		return 1;
+	}
+	if (argv[0][0] == '\0') {
+		/* Good, we found a NULL terminated string at argv[0]! */
+		return 0;
+	}
+
+	/* Test runner. */
+	ksft_print_header();
+	ksft_set_plan(5);
+
+	FORK(execve(argv[0], str, NULL));
+	FORK(execve(argv[0], NULL, NULL));
+	FORK(execve(argv[0], NULL, envp));
+	FORK(execve(argv[0], args, NULL));
+	FORK(execve(argv[0], args, envp));
+
+	ksft_exit(ksft_cnt.ksft_pass == ksft_plan);
+}
_

Patches currently in -mm which might be from keescook@chromium.org are

kconfigdebug-make-debug_info-selectable-from-a-choice.patch
kconfigdebug-make-debug_info-selectable-from-a-choice-fix.patch
selftests-kselftest-framework-provide-finished-helper.patch

