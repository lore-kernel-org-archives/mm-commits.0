Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C75F7CDB483
	for <mm-commits@archiver.kernel.org>; Wed, 18 Oct 2023 21:37:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229891AbjJRVhC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Oct 2023 17:37:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235236AbjJRVgZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Oct 2023 17:36:25 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FC09198
        for <mm-commits@vger.kernel.org>; Wed, 18 Oct 2023 14:35:39 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEE60C433B6;
        Wed, 18 Oct 2023 21:35:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697664935;
        bh=Iva0A++KX/VSC9in12y6zWEkmPzlkf+R+XB9SIxd4vo=;
        h=Date:To:From:Subject:From;
        b=nfvxoQLPnESat6b71VaNZz7DGqO7MyNuBP5SRmCVdC/xgke3TljkdcUFtTrrk6xRC
         PJY1OzTguteDShARMvWFw5Ykh8oFZ1U4GUkiTrxkvfoeGPYeRyo1ZIlFCZCvsaisqs
         wN/7xvzZYfP0wClpnXGXMA0STLyhjd2uoeS2+V+g=
Date:   Wed, 18 Oct 2023 14:35:34 -0700
To:     mm-commits@vger.kernel.org, riel@surriel.com,
        muchun.song@linux.dev, mike.kravetz@oracle.com, leitao@debian.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-add-a-new-test-for-madv-and-hugetlb.patch removed from -mm tree
Message-Id: <20231018213534.DEE60C433B6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests/mm: add a new test for madv and hugetlb
has been removed from the -mm tree.  Its filename was
     selftests-mm-add-a-new-test-for-madv-and-hugetlb.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Breno Leitao <leitao@debian.org>
Subject: selftests/mm: add a new test for madv and hugetlb
Date: Thu, 5 Oct 2023 09:39:22 -0700

Create a selftest that exercises the race between page faults and
madvise(MADV_DONTNEED) in the same huge page. Do it by running two
threads that touches the huge page and madvise(MADV_DONTNEED) at the same
time.

In case of a SIGBUS coming at pagefault, the test should fail, since we
hit the bug.

The test doesn't have a signal handler, and if it fails, it fails like
the following

  ----------------------------------
  running ./hugetlb_fault_after_madv
  ----------------------------------
  ./run_vmtests.sh: line 186: 595563 Bus error    (core dumped) "$@"
  [FAIL]

This selftest goes together with the fix of the bug[1] itself.

[1] https://lore.kernel.org/all/20231001005659.2185316-1-riel@surriel.com/#r

Link: https://lkml.kernel.org/r/20231005163922.87568-3-leitao@debian.org
Signed-off-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Rik van Riel <riel@surriel.com>
Tested-by: Rik van Riel <riel@surriel.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/Makefile                   |    1 
 tools/testing/selftests/mm/hugetlb_fault_after_madv.c |   73 ++++++++++
 tools/testing/selftests/mm/run_vmtests.sh             |    4 
 3 files changed, 78 insertions(+)

--- /dev/null
+++ a/tools/testing/selftests/mm/hugetlb_fault_after_madv.c
@@ -0,0 +1,73 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <pthread.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <sys/mman.h>
+#include <sys/types.h>
+#include <unistd.h>
+
+#include "vm_util.h"
+#include "../kselftest.h"
+
+#define MMAP_SIZE (1 << 21)
+#define INLOOP_ITER 100
+
+char *huge_ptr;
+
+/* Touch the memory while it is being madvised() */
+void *touch(void *unused)
+{
+	char *ptr = (char *)huge_ptr;
+
+	for (int i = 0; i < INLOOP_ITER; i++)
+		ptr[0] = '.';
+
+	return NULL;
+}
+
+void *madv(void *unused)
+{
+	usleep(rand() % 10);
+
+	for (int i = 0; i < INLOOP_ITER; i++)
+		madvise(huge_ptr, MMAP_SIZE, MADV_DONTNEED);
+
+	return NULL;
+}
+
+int main(void)
+{
+	unsigned long free_hugepages;
+	pthread_t thread1, thread2;
+	/*
+	 * On kernel 6.4, we are able to reproduce the problem with ~1000
+	 * interactions
+	 */
+	int max = 10000;
+
+	srand(getpid());
+
+	free_hugepages = get_free_hugepages();
+	if (free_hugepages != 1) {
+		ksft_exit_skip("This test needs one and only one page to execute. Got %lu\n",
+			       free_hugepages);
+	}
+
+	while (max--) {
+		huge_ptr = mmap(NULL, MMAP_SIZE, PROT_READ | PROT_WRITE,
+				MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB,
+				-1, 0);
+
+		if ((unsigned long)huge_ptr == -1)
+			ksft_exit_skip("Failed to allocated huge page\n");
+
+		pthread_create(&thread1, NULL, madv, NULL);
+		pthread_create(&thread2, NULL, touch, NULL);
+
+		pthread_join(thread1, NULL);
+		pthread_join(thread2, NULL);
+		munmap(huge_ptr, MMAP_SIZE);
+	}
+
+	return KSFT_PASS;
+}
--- a/tools/testing/selftests/mm/Makefile~selftests-mm-add-a-new-test-for-madv-and-hugetlb
+++ a/tools/testing/selftests/mm/Makefile
@@ -69,6 +69,7 @@ TEST_GEN_FILES += split_huge_page_test
 TEST_GEN_FILES += ksm_tests
 TEST_GEN_FILES += ksm_functional_tests
 TEST_GEN_FILES += mdwe_test
+TEST_GEN_FILES += hugetlb_fault_after_madv
 
 ifneq ($(ARCH),arm64)
 TEST_GEN_PROGS += soft-dirty
--- a/tools/testing/selftests/mm/run_vmtests.sh~selftests-mm-add-a-new-test-for-madv-and-hugetlb
+++ a/tools/testing/selftests/mm/run_vmtests.sh
@@ -223,6 +223,10 @@ CATEGORY="hugetlb" run_test ./hugepage-m
 CATEGORY="hugetlb" run_test ./hugepage-vmemmap
 CATEGORY="hugetlb" run_test ./hugetlb-madvise
 
+# For this test, we need one and just one huge page
+echo 1 > /proc/sys/vm/nr_hugepages
+CATEGORY="hugetlb" run_test ./hugetlb_fault_after_madv
+
 if test_selected "hugetlb"; then
 	echo "NOTE: These hugetlb tests provide minimal coverage.  Use"
 	echo "      https://github.com/libhugetlbfs/libhugetlbfs.git for"
_

Patches currently in -mm which might be from leitao@debian.org are


