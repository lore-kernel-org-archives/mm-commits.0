Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4003C77B76
	for <mm-commits@archiver.kernel.org>; Mon, 17 Apr 2023 23:52:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229804AbjDQXwh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 17 Apr 2023 19:52:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229884AbjDQXwg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 17 Apr 2023 19:52:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E3A740ED
        for <mm-commits@vger.kernel.org>; Mon, 17 Apr 2023 16:52:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AE9AA6206E
        for <mm-commits@vger.kernel.org>; Mon, 17 Apr 2023 23:52:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12582C433D2;
        Mon, 17 Apr 2023 23:52:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681775554;
        bh=akynzh8Yqu0mKzRuVqZTgYPOm+lrvNLrqpf3Ix9p1q4=;
        h=Date:To:From:Subject:From;
        b=iLQ6BGxqDXIR06P5UFRbceA8kijhY9zhHweDcSDQNgW/nFidqd4el3B1ZRBxtyCmV
         3oRMRPDNBUrHjtgxa2PdVDVzuHIJHUNf12wTHifX4bdPMkICPvBcXWzqx4GpLuBP51
         dL4Vtz4kcHWhXqTUYZMnd171eyPWGi/Brnyl3VPI=
Date:   Mon, 17 Apr 2023 16:52:33 -0700
To:     mm-commits@vger.kernel.org, nadav.amit@gmail.com,
        mpenttil@redhat.com, mike.kravetz@oracle.com, david@redhat.com,
        axelrasmussen@google.com, aarcange@redhat.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-add-a-few-options-for-uffd-unit-test.patch added to mm-unstable branch
Message-Id: <20230417235234.12582C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/mm: add a few options for uffd-unit-test
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-add-a-few-options-for-uffd-unit-test.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-add-a-few-options-for-uffd-unit-test.patch

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
From: Peter Xu <peterx@redhat.com>
Subject: selftests/mm: add a few options for uffd-unit-test
Date: Mon, 17 Apr 2023 15:53:14 -0400

Namely:

  "-f": add a wildcard filter for tests to run
  "-l": list tests rather than running any
  "-h": help msg

Link: https://lkml.kernel.org/r/20230417195317.898696-4-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Mika Penttilä <mpenttil@redhat.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Nadav Amit <nadav.amit@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/uffd-unit-tests.c |   52 ++++++++++++++---
 1 file changed, 45 insertions(+), 7 deletions(-)

--- a/tools/testing/selftests/mm/uffd-unit-tests.c~selftests-mm-add-a-few-options-for-uffd-unit-test
+++ a/tools/testing/selftests/mm/uffd-unit-tests.c
@@ -909,28 +909,65 @@ uffd_test_case_t uffd_tests[] = {
 	},
 };
 
+static void usage(const char *prog)
+{
+	printf("usage: %s [-f TESTNAME]\n", prog);
+	puts("");
+	puts(" -f: test name to filter (e.g., event)");
+	puts(" -h: show the help msg");
+	puts(" -l: list tests only");
+	puts("");
+	exit(KSFT_FAIL);
+}
+
 int main(int argc, char *argv[])
 {
 	int n_tests = sizeof(uffd_tests) / sizeof(uffd_test_case_t);
 	int n_mems = sizeof(mem_types) / sizeof(mem_type_t);
+	const char *test_filter = NULL;
+	bool list_only = false;
 	uffd_test_case_t *test;
 	mem_type_t *mem_type;
 	uffd_test_args_t args;
 	char test_name[128];
 	const char *errmsg;
-	int has_uffd;
+	int has_uffd, opt;
 	int i, j;
 
-	has_uffd = test_uffd_api(false);
-	has_uffd |= test_uffd_api(true);
+	while ((opt = getopt(argc, argv, "f:hl")) != -1) {
+		switch (opt) {
+		case 'f':
+			test_filter = optarg;
+			break;
+		case 'l':
+			list_only = true;
+			break;
+		case 'h':
+		default:
+			/* Unknown */
+			usage(argv[0]);
+			break;
+		}
+	}
 
-	if (!has_uffd) {
-		printf("Userfaultfd not supported or unprivileged, skip all tests\n");
-		exit(KSFT_SKIP);
+	if (!test_filter && !list_only) {
+		has_uffd = test_uffd_api(false);
+		has_uffd |= test_uffd_api(true);
+
+		if (!has_uffd) {
+			printf("Userfaultfd not supported or unprivileged, skip all tests\n");
+			exit(KSFT_SKIP);
+		}
 	}
 
 	for (i = 0; i < n_tests; i++) {
 		test = &uffd_tests[i];
+		if (test_filter && !strstr(test->name, test_filter))
+			continue;
+		if (list_only) {
+			printf("%s\n", test->name);
+			continue;
+		}
 		for (j = 0; j < n_mems; j++) {
 			mem_type = &mem_types[j];
 			if (!(test->mem_targets & mem_type->mem_flag))
@@ -952,7 +989,8 @@ int main(int argc, char *argv[])
 		}
 	}
 
-	uffd_test_report();
+	if (!list_only)
+		uffd_test_report();
 
 	return ksft_get_fail_cnt() ? KSFT_FAIL : KSFT_PASS;
 }
_

Patches currently in -mm which might be from peterx@redhat.com are

selftests-mm-update-gitignore-with-two-missing-tests.patch
selftests-mm-dump-a-summary-in-run_vmtestssh.patch
selftests-mm-merge-utilh-into-vm_utilh.patch
selftests-mm-use-test_gen_progs-where-proper.patch
selftests-mm-link-vm_utilc-always.patch
selftests-mm-merge-default_huge_page_size-into-one.patch
selftests-mm-use-pm_-macros-in-vm_utilsh.patch
selftests-mm-reuse-pagemap_get_entry-in-vm_utilh.patch
selftests-mm-test-uffdio_zeropage-only-when-hugetlb.patch
selftests-mm-drop-test_uffdio_zeropage_eexist.patch
selftests-mm-create-uffd-common.patch
selftests-mm-split-uffd-tests-into-uffd-stress-and-uffd-unit-tests.patch
selftests-mm-uffd_register.patch
selftests-mm-uffd_open_devsys.patch
selftests-mm-uffdio_api-test.patch
selftests-mm-drop-global-mem_fd-in-uffd-tests.patch
selftests-mm-drop-global-hpage_size-in-uffd-tests.patch
selftests-mm-rename-uffd_stats-to-uffd_args.patch
selftests-mm-let-uffd_handle_page_fault-take-wp-parameter.patch
selftests-mm-allow-allocate_area-to-fail-properly.patch
selftests-mm-add-framework-for-uffd-unit-test.patch
selftests-mm-move-uffd-pagemap-test-to-unit-test.patch
selftests-mm-move-uffd-minor-test-to-unit-test.patch
selftests-mm-move-uffd-sig-events-tests-into-uffd-unit-tests.patch
selftests-mm-move-zeropage-test-into-uffd-unit-tests.patch
selftests-mm-workaround-no-way-to-detect-uffd-minor-wp.patch
selftests-mm-allow-uffd-test-to-skip-properly-with-no-privilege.patch
selftests-mm-drop-sys-dev-test-in-uffd-stress-test.patch
selftests-mm-add-shmem-private-test-to-uffd-stress.patch
selftests-mm-add-uffdio-register-ioctls-test.patch
mm-hugetlb-fix-uffd-wp-during-fork.patch
mm-hugetlb-fix-uffd-wp-bit-lost-when-unsharing-happens.patch
selftests-mm-add-a-few-options-for-uffd-unit-test.patch
selftests-mm-extend-and-rename-uffd-pagemap-test.patch
selftests-mm-rename-cow_extra_libs-to-iouring_extra_libs.patch
selftests-mm-add-tests-for-ro-pinning-vs-fork.patch

