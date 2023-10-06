Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E6E1E94131
	for <mm-commits@archiver.kernel.org>; Fri,  6 Oct 2023 21:48:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233805AbjJFVs1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 6 Oct 2023 17:48:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233803AbjJFVs0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 6 Oct 2023 17:48:26 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72B1DC5
        for <mm-commits@vger.kernel.org>; Fri,  6 Oct 2023 14:48:25 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF6D8C433C8;
        Fri,  6 Oct 2023 21:48:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696628905;
        bh=dIbwv//SgGRkes0qS4ZA0jJraUABm87mM6AHQWkOZ7Y=;
        h=Date:To:From:Subject:From;
        b=FO6xGXTFvHnzKnya5oIaCLU1AwgzsLRlpPxVUKsvmMRyiJSsS2E94Cx+hTWxpSwUj
         J3Gb0agXph9P/YVZM1ZngaUc6bR6QojjQG18mrU74UaohpDc9hEvAyw6+PcOSCPf60
         XWQ+5mU2OuH6iRP/XD9UAz6nMG7T/TaZzKlhOG+c=
Date:   Fri, 06 Oct 2023 14:48:22 -0700
To:     mm-commits@vger.kernel.org, riel@surriel.com, hannes@cmpxchg.org,
        david@redhat.com, carl@uvos.xyz, shr@devkernel.io,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-ksm-test-case-for-prctl-fork-exec-workflow.patch removed from -mm tree
Message-Id: <20231006214824.AF6D8C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/ksm: test case for prctl fork/exec workflow
has been removed from the -mm tree.  Its filename was
     mm-ksm-test-case-for-prctl-fork-exec-workflow.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Stefan Roesch <shr@devkernel.io>
Subject: mm/ksm: test case for prctl fork/exec workflow
Date: Fri, 22 Sep 2023 14:11:41 -0700

This adds a new test case to the ksm functional tests to make sure that
the KSM setting is inherited by the child process when doing a fork/exec.

Link: https://lkml.kernel.org/r/20230922211141.320789-3-shr@devkernel.io
Signed-off-by: Stefan Roesch <shr@devkernel.io>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Carl Klemm <carl@uvos.xyz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Rik van Riel <riel@surriel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/ksm_functional_tests.c |   66 +++++++++++-
 1 file changed, 65 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/ksm_functional_tests.c~mm-ksm-test-case-for-prctl-fork-exec-workflow
+++ a/tools/testing/selftests/mm/ksm_functional_tests.c
@@ -26,6 +26,7 @@
 
 #define KiB 1024u
 #define MiB (1024 * KiB)
+#define FORK_EXEC_CHILD_PRG_NAME "ksm_fork_exec_child"
 
 static int mem_fd;
 static int ksm_fd;
@@ -479,6 +480,64 @@ static void test_prctl_fork(void)
 	ksft_test_result_pass("PR_SET_MEMORY_MERGE value is inherited\n");
 }
 
+static int ksm_fork_exec_child(void)
+{
+	/* Test if KSM is enabled for the process. */
+	return prctl(PR_GET_MEMORY_MERGE, 0, 0, 0, 0) == 1;
+}
+
+static void test_prctl_fork_exec(void)
+{
+	int ret, status;
+	pid_t child_pid;
+
+	ksft_print_msg("[RUN] %s\n", __func__);
+
+	ret = prctl(PR_SET_MEMORY_MERGE, 1, 0, 0, 0);
+	if (ret < 0 && errno == EINVAL) {
+		ksft_test_result_skip("PR_SET_MEMORY_MERGE not supported\n");
+		return;
+	} else if (ret) {
+		ksft_test_result_fail("PR_SET_MEMORY_MERGE=1 failed\n");
+		return;
+	}
+
+	child_pid = fork();
+	if (child_pid == -1) {
+		ksft_test_result_skip("fork() failed\n");
+		return;
+	} else if (child_pid == 0) {
+		char *prg_name = "./ksm_functional_tests";
+		char *argv_for_program[] = { prg_name, FORK_EXEC_CHILD_PRG_NAME };
+
+		execv(prg_name, argv_for_program);
+		return;
+	}
+
+	if (waitpid(child_pid, &status, 0) > 0) {
+		if (WIFEXITED(status)) {
+			status = WEXITSTATUS(status);
+			if (status) {
+				ksft_test_result_fail("KSM not enabled\n");
+				return;
+			}
+		} else {
+			ksft_test_result_fail("program didn't terminate normally\n");
+			return;
+		}
+	} else {
+		ksft_test_result_fail("waitpid() failed\n");
+		return;
+	}
+
+	if (prctl(PR_SET_MEMORY_MERGE, 0, 0, 0, 0)) {
+		ksft_test_result_fail("PR_SET_MEMORY_MERGE=0 failed\n");
+		return;
+	}
+
+	ksft_test_result_pass("PR_SET_MEMORY_MERGE value is inherited\n");
+}
+
 static void test_prctl_unmerge(void)
 {
 	const unsigned int size = 2 * MiB;
@@ -536,9 +595,13 @@ unmap:
 
 int main(int argc, char **argv)
 {
-	unsigned int tests = 7;
+	unsigned int tests = 8;
 	int err;
 
+	if (argc > 1 && !strcmp(argv[1], FORK_EXEC_CHILD_PRG_NAME)) {
+		exit(ksm_fork_exec_child() == 1 ? 0 : 1);
+	}
+
 #ifdef __NR_userfaultfd
 	tests++;
 #endif
@@ -576,6 +639,7 @@ int main(int argc, char **argv)
 
 	test_prctl();
 	test_prctl_fork();
+	test_prctl_fork_exec();
 	test_prctl_unmerge();
 
 	err = ksft_get_fail_cnt();
_

Patches currently in -mm which might be from shr@devkernel.io are


