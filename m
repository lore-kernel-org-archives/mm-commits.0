Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EE27C6FD18
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 23:38:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231423AbjDRXia (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Apr 2023 19:38:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231659AbjDRXgy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2023 19:36:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28D3ED333
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 16:35:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0A1DA61528
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 23:35:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64657C433D2;
        Tue, 18 Apr 2023 23:35:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681860937;
        bh=/14HmPzMhkr61tcStxvZPuxvPH1vfwNSejqutJOcG0o=;
        h=Date:To:From:Subject:From;
        b=Zckf6R0J3TbZ1iu0ywzIsS+5eJGzuwKn7zudB3sc91EDQmjojuYyMkL2zN06ONfSc
         oKQsX0intd+tny4DIeUeZLDwX/N77/RWJr6/4y0/OOQD3Yvbm/rm1+0JE9e8eA/+ZG
         bvuCJrDCgqlV/ITMmLhAGFfjFaEmihiFAhcqD7tI=
Date:   Tue, 18 Apr 2023 16:35:36 -0700
To:     mm-commits@vger.kernel.org, zokeefe@google.com, rppt@kernel.org,
        mike.kravetz@oracle.com, david@redhat.com, colin.i.king@gmail.com,
        axelrasmussen@google.com, 0x7f454c46@gmail.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-allow-uffd-test-to-skip-properly-with-no-privilege.patch removed from -mm tree
Message-Id: <20230418233537.64657C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests/mm: allow uffd test to skip properly with no privilege
has been removed from the -mm tree.  Its filename was
     selftests-mm-allow-uffd-test-to-skip-properly-with-no-privilege.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: selftests/mm: allow uffd test to skip properly with no privilege
Date: Wed, 12 Apr 2023 12:45:20 -0400

Allow skip a unit test properly due to no privilege (e.g.  sigbus and
events tests).

[colin.i.king@gmail.com: fix spelling mistake "priviledge" -> "privilege"]
  Link: https://lkml.kernel.org/r/20230414081506.1678998-1-colin.i.king@gmail.com
Link: https://lkml.kernel.org/r/20230412164520.329163-1-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dmitry Safonov <0x7f454c46@gmail.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Zach O'Keefe <zokeefe@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/uffd-common.c     |   27 ++++++++++-------
 tools/testing/selftests/mm/uffd-common.h     |    4 +-
 tools/testing/selftests/mm/uffd-stress.c     |    6 ++-
 tools/testing/selftests/mm/uffd-unit-tests.c |   10 +++---
 4 files changed, 29 insertions(+), 18 deletions(-)

--- a/tools/testing/selftests/mm/uffd-common.c~selftests-mm-allow-uffd-test-to-skip-properly-with-no-privilege
+++ a/tools/testing/selftests/mm/uffd-common.c
@@ -232,7 +232,7 @@ void uffd_stats_report(struct uffd_args
 	printf("\n");
 }
 
-void userfaultfd_open(uint64_t *features)
+int userfaultfd_open(uint64_t *features)
 {
 	struct uffdio_api uffdio_api;
 
@@ -241,18 +241,19 @@ void userfaultfd_open(uint64_t *features
 	else
 		uffd = uffd_open_sys(UFFD_FLAGS);
 	if (uffd < 0)
-		err("uffd open failed (dev=%d)", test_dev_userfaultfd);
+		return -1;
 	uffd_flags = fcntl(uffd, F_GETFD, NULL);
 
 	uffdio_api.api = UFFD_API;
 	uffdio_api.features = *features;
 	if (ioctl(uffd, UFFDIO_API, &uffdio_api))
-		err("UFFDIO_API failed.\nPlease make sure to "
-		    "run with either root or ptrace capability.");
+		/* Probably lack of CAP_PTRACE? */
+		return -1;
 	if (uffdio_api.api != UFFD_API)
 		err("UFFDIO_API error: %" PRIu64, (uint64_t)uffdio_api.api);
 
 	*features = uffdio_api.features;
+	return 0;
 }
 
 static inline void munmap_area(void **area)
@@ -295,7 +296,7 @@ static void uffd_test_ctx_clear(void)
 	munmap_area((void **)&area_remap);
 }
 
-int uffd_test_ctx_init(uint64_t features)
+int uffd_test_ctx_init(uint64_t features, const char **errmsg)
 {
 	unsigned long nr, cpu;
 	int ret;
@@ -303,13 +304,19 @@ int uffd_test_ctx_init(uint64_t features
 	uffd_test_ctx_clear();
 
 	ret = uffd_test_ops->allocate_area((void **)&area_src, true);
-	if (ret)
-		return ret;
-	ret = uffd_test_ops->allocate_area((void **)&area_dst, false);
-	if (ret)
+	ret |= uffd_test_ops->allocate_area((void **)&area_dst, false);
+	if (ret) {
+		if (errmsg)
+			*errmsg = "memory allocation failed";
 		return ret;
+	}
 
-	userfaultfd_open(&features);
+	ret = userfaultfd_open(&features);
+	if (ret) {
+		if (errmsg)
+			*errmsg = "possible lack of privilege";
+		return ret;
+	}
 
 	count_verify = malloc(nr_pages * sizeof(unsigned long long));
 	if (!count_verify)
--- a/tools/testing/selftests/mm/uffd-common.h~selftests-mm-allow-uffd-test-to-skip-properly-with-no-privilege
+++ a/tools/testing/selftests/mm/uffd-common.h
@@ -101,8 +101,8 @@ extern uffd_test_ops_t hugetlb_uffd_test
 extern uffd_test_ops_t *uffd_test_ops;
 
 void uffd_stats_report(struct uffd_args *args, int n_cpus);
-int uffd_test_ctx_init(uint64_t features);
-void userfaultfd_open(uint64_t *features);
+int uffd_test_ctx_init(uint64_t features, const char **errmsg);
+int userfaultfd_open(uint64_t *features);
 int uffd_read_msg(int ufd, struct uffd_msg *msg);
 void wp_range(int ufd, __u64 start, __u64 len, bool wp);
 void uffd_handle_page_fault(struct uffd_msg *msg, struct uffd_args *args);
--- a/tools/testing/selftests/mm/uffd-stress.c~selftests-mm-allow-uffd-test-to-skip-properly-with-no-privilege
+++ a/tools/testing/selftests/mm/uffd-stress.c
@@ -271,7 +271,8 @@ static int userfaultfd_stress(void)
 	struct uffd_args args[nr_cpus];
 	uint64_t mem_size = nr_pages * page_size;
 
-	uffd_test_ctx_init(UFFD_FEATURE_WP_UNPOPULATED);
+	if (uffd_test_ctx_init(UFFD_FEATURE_WP_UNPOPULATED, NULL))
+		err("context init failed");
 
 	if (posix_memalign(&area, page_size, page_size))
 		err("out of memory");
@@ -435,7 +436,8 @@ static void parse_test_type_arg(const ch
 	 * feature.
 	 */
 
-	userfaultfd_open(&features);
+	if (userfaultfd_open(&features))
+		err("Userfaultfd open failed");
 
 	test_uffdio_wp = test_uffdio_wp &&
 		(features & UFFD_FEATURE_PAGEFAULT_FLAG_WP);
--- a/tools/testing/selftests/mm/uffd-unit-tests.c~selftests-mm-allow-uffd-test-to-skip-properly-with-no-privilege
+++ a/tools/testing/selftests/mm/uffd-unit-tests.c
@@ -172,7 +172,8 @@ out:
  * This function initializes the global variables.  TODO: remove global
  * vars and then remove this.
  */
-static int uffd_setup_environment(uffd_test_case_t *test, mem_type_t *mem_type)
+static int uffd_setup_environment(uffd_test_case_t *test, mem_type_t *mem_type,
+				  const char **errmsg)
 {
 	map_shared = mem_type->shared;
 	uffd_test_ops = mem_type->mem_ops;
@@ -186,7 +187,7 @@ static int uffd_setup_environment(uffd_t
 	/* TODO: remove this global var.. it's so ugly */
 	nr_cpus = 1;
 
-	return uffd_test_ctx_init(test->uffd_feature_required);
+	return uffd_test_ctx_init(test->uffd_feature_required, errmsg);
 }
 
 static bool uffd_feature_supported(uffd_test_case_t *test)
@@ -835,6 +836,7 @@ int main(int argc, char *argv[])
 	uffd_test_case_t *test;
 	mem_type_t *mem_type;
 	char test_name[128];
+	const char *errmsg;
 	int has_uffd;
 	int i, j;
 
@@ -860,8 +862,8 @@ int main(int argc, char *argv[])
 				uffd_test_skip("feature missing");
 				continue;
 			}
-			if (uffd_setup_environment(test, mem_type)) {
-				uffd_test_skip("environment setup failed");
+			if (uffd_setup_environment(test, mem_type, &errmsg)) {
+				uffd_test_skip(errmsg);
 				continue;
 			}
 			test->uffd_fn();
_

Patches currently in -mm which might be from peterx@redhat.com are

selftests-mm-drop-sys-dev-test-in-uffd-stress-test.patch
selftests-mm-add-shmem-private-test-to-uffd-stress.patch
selftests-mm-add-uffdio-register-ioctls-test.patch
mm-hugetlb-fix-uffd-wp-during-fork.patch
mm-hugetlb-fix-uffd-wp-bit-lost-when-unsharing-happens.patch
selftests-mm-add-a-few-options-for-uffd-unit-test.patch
selftests-mm-extend-and-rename-uffd-pagemap-test.patch
selftests-mm-rename-cow_extra_libs-to-iouring_extra_libs.patch
selftests-mm-add-tests-for-ro-pinning-vs-fork.patch

