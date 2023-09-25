Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58CA0CE7A8C
	for <mm-commits@archiver.kernel.org>; Mon, 25 Sep 2023 15:45:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230184AbjIYPpQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 25 Sep 2023 11:45:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231616AbjIYPpK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 25 Sep 2023 11:45:10 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BF5811B
        for <mm-commits@vger.kernel.org>; Mon, 25 Sep 2023 08:45:03 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C2F8C433C9;
        Mon, 25 Sep 2023 15:45:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1695656703;
        bh=1m2z04H4hcqXEAoAHA83rLJ4UsQtd2Sh3BZgEM6HreI=;
        h=Date:To:From:Subject:From;
        b=p4JLHwT1xkynmA27yYR5JueMk2wZIwesiR1cnv/8+JA6dUAAp+Xtkaxs0vyW0hlUG
         boJ4Q2X3jvH43MKU3f0OiGvA1mZv1lXDCwVSwdDydF47H84uj5oHwPee/H52u2Jckt
         JFh6p0xtPoR4sGRZOBOF1LkurdndjFRukBOpgKdU=
Date:   Mon, 25 Sep 2023 08:45:02 -0700
To:     mm-commits@vger.kernel.org, riel@surriel.com, hannes@cmpxchg.org,
        david@redhat.com, carl@uvos.xyz, shr@devkernel.io,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-ksm-test-case-for-prctl-fork-exec-workflow.patch added to mm-unstable branch
Message-Id: <20230925154503.1C2F8C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/ksm: test case for prctl fork/exec workflow
has been added to the -mm mm-unstable branch.  Its filename is
     mm-ksm-test-case-for-prctl-fork-exec-workflow.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-ksm-test-case-for-prctl-fork-exec-workflow.patch

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

mm-ksm-add-smart-page-scanning-mode.patch
mm-ksm-add-pages_skipped-metric.patch
mm-ksm-document-smart-scan-mode.patch
mm-ksm-document-pages_skipped-sysfs-knob.patch
mm-ksm-support-fork-exec-for-prctl.patch
mm-ksm-test-case-for-prctl-fork-exec-workflow.patch

