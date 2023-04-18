Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6941EC6FD18
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 23:38:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231737AbjDRXiB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Apr 2023 19:38:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231263AbjDRXgn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2023 19:36:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2EC5D326
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 16:35:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6EBED61528
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 23:35:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFD72C433EF;
        Tue, 18 Apr 2023 23:35:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681860924;
        bh=vN9ZkSfqVWCyOJYdxbF5507dByLCXO4AcWg0vVuirb8=;
        h=Date:To:From:Subject:From;
        b=NmdPR/NMs4XEM/jcouPs5T9ReUvOECovTkTUQryRrGZawNraSdNYTzcS1Kib+K7Hv
         2ydo7xfd4lV7/iYxiCpVdfkay190mhLwI07bwa+MYf+vdt3nAIIjXe9ofdce1e71qr
         3OqfziP9tv8w+xv+1blErWuy3p87/3ZV1COWCyVo=
Date:   Tue, 18 Apr 2023 16:35:24 -0700
To:     mm-commits@vger.kernel.org, zokeefe@google.com, rppt@kernel.org,
        mike.kravetz@oracle.com, david@redhat.com,
        axelrasmussen@google.com, 0x7f454c46@gmail.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-uffdio_api-test.patch removed from -mm tree
Message-Id: <20230418233524.BFD72C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests/mm: UFFDIO_API test
has been removed from the -mm tree.  Its filename was
     selftests-mm-uffdio_api-test.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: selftests/mm: UFFDIO_API test
Date: Wed, 12 Apr 2023 12:42:57 -0400

Add one simple test for UFFDIO_API.  With that, I also added a bunch of
small but handy helpers along the way.

Link: https://lkml.kernel.org/r/20230412164257.328375-1-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dmitry Safonov <0x7f454c46@gmail.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Zach O'Keefe <zokeefe@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/uffd-unit-tests.c |  109 ++++++++++++++++-
 1 file changed, 108 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/uffd-unit-tests.c~selftests-mm-uffdio_api-test
+++ a/tools/testing/selftests/mm/uffd-unit-tests.c
@@ -9,9 +9,116 @@
 
 #ifdef __NR_userfaultfd
 
+static void uffd_test_report(void)
+{
+	printf("Userfaults unit tests: pass=%u, skip=%u, fail=%u (total=%u)\n",
+	       ksft_get_pass_cnt(),
+	       ksft_get_xskip_cnt(),
+	       ksft_get_fail_cnt(),
+	       ksft_test_num());
+}
+
+static void uffd_test_pass(void)
+{
+	printf("done\n");
+	ksft_inc_pass_cnt();
+}
+
+#define  uffd_test_start(...)  do {		\
+		printf("Testing ");		\
+		printf(__VA_ARGS__);		\
+		printf("... ");			\
+		fflush(stdout);			\
+	} while (0)
+
+#define  uffd_test_fail(...)  do {		\
+		printf("failed [reason: ");	\
+		printf(__VA_ARGS__);		\
+		printf("]\n");			\
+		ksft_inc_fail_cnt();		\
+	} while (0)
+
+#define  uffd_test_skip(...)  do {		\
+		printf("skipped [reason: ");	\
+		printf(__VA_ARGS__);		\
+		printf("]\n");			\
+		ksft_inc_xskip_cnt();		\
+	} while (0)
+
+/*
+ * Returns 1 if specific userfaultfd supported, 0 otherwise.  Note, we'll
+ * return 1 even if some test failed as long as uffd supported, because in
+ * that case we still want to proceed with the rest uffd unit tests.
+ */
+static int test_uffd_api(bool use_dev)
+{
+	struct uffdio_api uffdio_api;
+	int uffd;
+
+	uffd_test_start("UFFDIO_API (with %s)",
+			use_dev ? "/dev/userfaultfd" : "syscall");
+
+	if (use_dev)
+		uffd = uffd_open_dev(UFFD_FLAGS);
+	else
+		uffd = uffd_open_sys(UFFD_FLAGS);
+	if (uffd < 0) {
+		uffd_test_skip("cannot open userfaultfd handle");
+		return 0;
+	}
+
+	/* Test wrong UFFD_API */
+	uffdio_api.api = 0xab;
+	uffdio_api.features = 0;
+	if (ioctl(uffd, UFFDIO_API, &uffdio_api) == 0) {
+		uffd_test_fail("UFFDIO_API should fail with wrong api but didn't");
+		goto out;
+	}
+
+	/* Test wrong feature bit */
+	uffdio_api.api = UFFD_API;
+	uffdio_api.features = BIT_ULL(63);
+	if (ioctl(uffd, UFFDIO_API, &uffdio_api) == 0) {
+		uffd_test_fail("UFFDIO_API should fail with wrong feature but didn't");
+		goto out;
+	}
+
+	/* Test normal UFFDIO_API */
+	uffdio_api.api = UFFD_API;
+	uffdio_api.features = 0;
+	if (ioctl(uffd, UFFDIO_API, &uffdio_api)) {
+		uffd_test_fail("UFFDIO_API should succeed but failed");
+		goto out;
+	}
+
+	/* Test double requests of UFFDIO_API with a random feature set */
+	uffdio_api.features = BIT_ULL(0);
+	if (ioctl(uffd, UFFDIO_API, &uffdio_api) == 0) {
+		uffd_test_fail("UFFDIO_API should reject initialized uffd");
+		goto out;
+	}
+
+	uffd_test_pass();
+out:
+	close(uffd);
+	/* We have a valid uffd handle */
+	return 1;
+}
+
 int main(int argc, char *argv[])
 {
-	return KSFT_PASS;
+	int has_uffd;
+
+	has_uffd = test_uffd_api(false);
+	has_uffd |= test_uffd_api(true);
+
+	if (!has_uffd) {
+		printf("Userfaultfd not supported or unprivileged, skip all tests\n");
+		exit(KSFT_SKIP);
+	}
+	uffd_test_report();
+
+	return ksft_get_fail_cnt() ? KSFT_FAIL : KSFT_PASS;
 }
 
 #else /* __NR_userfaultfd */
_

Patches currently in -mm which might be from peterx@redhat.com are

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

