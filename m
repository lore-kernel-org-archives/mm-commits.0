Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E371FC7618E
	for <mm-commits@archiver.kernel.org>; Fri, 21 Apr 2023 21:52:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233563AbjDUVwl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 21 Apr 2023 17:52:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231955AbjDUVwg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 21 Apr 2023 17:52:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C363310FF
        for <mm-commits@vger.kernel.org>; Fri, 21 Apr 2023 14:52:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5FE266532C
        for <mm-commits@vger.kernel.org>; Fri, 21 Apr 2023 21:52:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAC99C4339B;
        Fri, 21 Apr 2023 21:52:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1682113954;
        bh=8SvjXXmiZixOJvjX23jMwgdboHiFlydjgbOe+PeCKMI=;
        h=Date:To:From:Subject:From;
        b=tg40vSQUqcYV49jLXpVBvk4co0wyq4woA/rRxqPjEESSESLi4ycQnRuTPIcpSMasI
         ZgyRDDTYOpBt46EQFQacAw6iOFOvlODjfwH7g/J+UHkxb2QCSizlYFpnKTDvLEtneX
         ammGg0tVtzjyfsrMJU3vQuves0FBdKsWsro+HrY8=
Date:   Fri, 21 Apr 2023 14:52:34 -0700
To:     mm-commits@vger.kernel.org, nadav.amit@gmail.com,
        mpenttil@redhat.com, mike.kravetz@oracle.com, david@redhat.com,
        axelrasmussen@google.com, aarcange@redhat.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-add-a-few-options-for-uffd-unit-test.patch removed from -mm tree
Message-Id: <20230421215234.BAC99C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests/mm: add a few options for uffd-unit-test
has been removed from the -mm tree.  Its filename was
     selftests-mm-add-a-few-options-for-uffd-unit-test.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
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


