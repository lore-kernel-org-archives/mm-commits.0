Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69D30C77B76
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 23:38:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231618AbjDRXiQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Apr 2023 19:38:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231620AbjDRXgx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2023 19:36:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2F10AD19
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 16:35:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C69CA62CA1
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 23:35:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27D70C433EF;
        Tue, 18 Apr 2023 23:35:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681860931;
        bh=JERthfC2LhqbnbRVdXiwzGdI1jLS97Gkjww0gobD+30=;
        h=Date:To:From:Subject:From;
        b=PP31CXW5tqSSP9+8f+UH5cXpkFY4p7DXOvgEdZ4VSt8Iu/mF2+GQPiQ77mQ+RpP6A
         eKzT8BDEsjRHSxgm1o1yJ1CHBlGbJ91NAY5+RSpKWSi6IUpO968Kh17drya6oDMfux
         TshJYeWM+4lKHuj0UeDXmv8tqJpIVFaJVnKBUtW0=
Date:   Tue, 18 Apr 2023 16:35:30 -0700
To:     mm-commits@vger.kernel.org, zokeefe@google.com, rppt@kernel.org,
        mike.kravetz@oracle.com, david@redhat.com,
        axelrasmussen@google.com, 0x7f454c46@gmail.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-add-framework-for-uffd-unit-test.patch removed from -mm tree
Message-Id: <20230418233531.27D70C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests/mm: add framework for uffd-unit-test
has been removed from the -mm tree.  Its filename was
     selftests-mm-add-framework-for-uffd-unit-test.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: selftests/mm: add framework for uffd-unit-test
Date: Wed, 12 Apr 2023 12:43:48 -0400

Add a framework to be prepared to move unit tests from uffd-stress.c into
uffd-unit-tests.c.  The goal is to allow detection of uffd features for
each test, and also loop over specified types of memory that a test
support.

Link: https://lkml.kernel.org/r/20230412164348.328710-1-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dmitry Safonov <0x7f454c46@gmail.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Zach O'Keefe <zokeefe@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/uffd-unit-tests.c |  124 +++++++++++++++++
 tools/testing/selftests/mm/vm_util.c         |   37 +++++
 tools/testing/selftests/mm/vm_util.h         |    2 
 3 files changed, 163 insertions(+)

--- a/tools/testing/selftests/mm/uffd-unit-tests.c~selftests-mm-add-framework-for-uffd-unit-test
+++ a/tools/testing/selftests/mm/uffd-unit-tests.c
@@ -9,6 +9,66 @@
 
 #ifdef __NR_userfaultfd
 
+/* The unit test doesn't need a large or random size, make it 32MB for now */
+#define  UFFD_TEST_MEM_SIZE               (32UL << 20)
+
+#define  MEM_ANON                         BIT_ULL(0)
+#define  MEM_SHMEM                        BIT_ULL(1)
+#define  MEM_SHMEM_PRIVATE                BIT_ULL(2)
+#define  MEM_HUGETLB                      BIT_ULL(3)
+#define  MEM_HUGETLB_PRIVATE              BIT_ULL(4)
+
+struct mem_type {
+	const char *name;
+	unsigned int mem_flag;
+	uffd_test_ops_t *mem_ops;
+	bool shared;
+};
+typedef struct mem_type mem_type_t;
+
+mem_type_t mem_types[] = {
+	{
+		.name = "anon",
+		.mem_flag = MEM_ANON,
+		.mem_ops = &anon_uffd_test_ops,
+		.shared = false,
+	},
+	{
+		.name = "shmem",
+		.mem_flag = MEM_SHMEM,
+		.mem_ops = &shmem_uffd_test_ops,
+		.shared = true,
+	},
+	{
+		.name = "shmem-private",
+		.mem_flag = MEM_SHMEM_PRIVATE,
+		.mem_ops = &shmem_uffd_test_ops,
+		.shared = false,
+	},
+	{
+		.name = "hugetlb",
+		.mem_flag = MEM_HUGETLB,
+		.mem_ops = &hugetlb_uffd_test_ops,
+		.shared = true,
+	},
+	{
+		.name = "hugetlb-private",
+		.mem_flag = MEM_HUGETLB_PRIVATE,
+		.mem_ops = &hugetlb_uffd_test_ops,
+		.shared = false,
+	},
+};
+
+/* Returns: UFFD_TEST_* */
+typedef void (*uffd_test_fn)(void);
+
+typedef struct {
+	const char *name;
+	uffd_test_fn uffd_fn;
+	unsigned int mem_targets;
+	uint64_t uffd_feature_required;
+} uffd_test_case_t;
+
 static void uffd_test_report(void)
 {
 	printf("Userfaults unit tests: pass=%u, skip=%u, fail=%u (total=%u)\n",
@@ -105,9 +165,50 @@ out:
 	return 1;
 }
 
+/*
+ * This function initializes the global variables.  TODO: remove global
+ * vars and then remove this.
+ */
+static int uffd_setup_environment(uffd_test_case_t *test, mem_type_t *mem_type)
+{
+	map_shared = mem_type->shared;
+	uffd_test_ops = mem_type->mem_ops;
+
+	if (mem_type->mem_flag & (MEM_HUGETLB_PRIVATE | MEM_HUGETLB))
+		page_size = default_huge_page_size();
+	else
+		page_size = psize();
+
+	nr_pages = UFFD_TEST_MEM_SIZE / page_size;
+	/* TODO: remove this global var.. it's so ugly */
+	nr_cpus = 1;
+
+	return uffd_test_ctx_init(test->uffd_feature_required);
+}
+
+static bool uffd_feature_supported(uffd_test_case_t *test)
+{
+	uint64_t features;
+
+	if (uffd_get_features(&features))
+		return false;
+
+	return (features & test->uffd_feature_required) ==
+	    test->uffd_feature_required;
+}
+
+uffd_test_case_t uffd_tests[] = {
+};
+
 int main(int argc, char *argv[])
 {
+	int n_tests = sizeof(uffd_tests) / sizeof(uffd_test_case_t);
+	int n_mems = sizeof(mem_types) / sizeof(mem_type_t);
+	uffd_test_case_t *test;
+	mem_type_t *mem_type;
+	char test_name[128];
 	int has_uffd;
+	int i, j;
 
 	has_uffd = test_uffd_api(false);
 	has_uffd |= test_uffd_api(true);
@@ -116,6 +217,29 @@ int main(int argc, char *argv[])
 		printf("Userfaultfd not supported or unprivileged, skip all tests\n");
 		exit(KSFT_SKIP);
 	}
+
+	for (i = 0; i < n_tests; i++) {
+		test = &uffd_tests[i];
+		for (j = 0; j < n_mems; j++) {
+			mem_type = &mem_types[j];
+			if (!(test->mem_targets & mem_type->mem_flag))
+				continue;
+			snprintf(test_name, sizeof(test_name),
+				 "%s on %s", test->name, mem_type->name);
+
+			uffd_test_start(test_name);
+			if (!uffd_feature_supported(test)) {
+				uffd_test_skip("feature missing");
+				continue;
+			}
+			if (uffd_setup_environment(test, mem_type)) {
+				uffd_test_skip("environment setup failed");
+				continue;
+			}
+			test->uffd_fn();
+		}
+	}
+
 	uffd_test_report();
 
 	return ksft_get_fail_cnt() ? KSFT_FAIL : KSFT_PASS;
--- a/tools/testing/selftests/mm/vm_util.c~selftests-mm-add-framework-for-uffd-unit-test
+++ a/tools/testing/selftests/mm/vm_util.c
@@ -254,3 +254,40 @@ int uffd_open_sys(unsigned int flags)
 	return -1;
 #endif
 }
+
+int uffd_open(unsigned int flags)
+{
+	int uffd = uffd_open_sys(flags);
+
+	if (uffd < 0)
+		uffd = uffd_open_dev(flags);
+
+	return uffd;
+}
+
+int uffd_get_features(uint64_t *features)
+{
+	struct uffdio_api uffdio_api = { .api = UFFD_API, .features = 0 };
+	/*
+	 * This should by default work in most kernels; the feature list
+	 * will be the same no matter what we pass in here.
+	 */
+	int fd = uffd_open(UFFD_USER_MODE_ONLY);
+
+	if (fd < 0)
+		/* Maybe the kernel is older than user-only mode? */
+		fd = uffd_open(0);
+
+	if (fd < 0)
+		return fd;
+
+	if (ioctl(fd, UFFDIO_API, &uffdio_api)) {
+		close(fd);
+		return -errno;
+	}
+
+	*features = uffdio_api.features;
+	close(fd);
+
+	return 0;
+}
--- a/tools/testing/selftests/mm/vm_util.h~selftests-mm-add-framework-for-uffd-unit-test
+++ a/tools/testing/selftests/mm/vm_util.h
@@ -50,6 +50,8 @@ int uffd_register(int uffd, void *addr,
 int uffd_unregister(int uffd, void *addr, uint64_t len);
 int uffd_open_dev(unsigned int flags);
 int uffd_open_sys(unsigned int flags);
+int uffd_open(unsigned int flags);
+int uffd_get_features(uint64_t *features);
 
 /*
  * On ppc64 this will only work with radix 2M hugepage size
_

Patches currently in -mm which might be from peterx@redhat.com are

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

