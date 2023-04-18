Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6C95C6FD18
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 23:38:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231431AbjDRXij (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Apr 2023 19:38:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231667AbjDRXgz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2023 19:36:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A75810240
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 16:35:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7BDC263A01
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 23:35:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2167C4339B;
        Tue, 18 Apr 2023 23:35:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681860940;
        bh=yeTjEnz148nia/nuDmxmo0+1QBZVRkUisHG/eGzKX5I=;
        h=Date:To:From:Subject:From;
        b=YKfMRF39OQlbXrIlptwcmoAq09DfKUoqERHx9plxxbUkekF7NruwLQLwgl4I38JlO
         4Xvp7Wc/lNVhUMnqXTUVATn5dfqvsf7X/7fYvsGTX3WVrazwVR0b9w65lEN5YMfDPc
         yn9GALpii1cbDvYmXBHFadump/HuxOGGhcmzDI8s=
Date:   Tue, 18 Apr 2023 16:35:40 -0700
To:     mm-commits@vger.kernel.org, zokeefe@google.com, rppt@kernel.org,
        mike.kravetz@oracle.com, david@redhat.com,
        axelrasmussen@google.com, 0x7f454c46@gmail.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-add-uffdio-register-ioctls-test.patch removed from -mm tree
Message-Id: <20230418233540.D2167C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests/mm: add uffdio register ioctls test
has been removed from the -mm tree.  Its filename was
     selftests-mm-add-uffdio-register-ioctls-test.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: selftests/mm: add uffdio register ioctls test
Date: Wed, 12 Apr 2023 12:45:48 -0400

This new test tests against the returned ioctls from UFFDIO_REGISTER,
where put into uffdio_register.ioctls.

This also tests the expected failure cases of UFFDIO_REGISTER, aka:

  - Register with empty mode should fail with -EINVAL
  - Register minor without page cache (anon) should fail with -EINVAL

Link: https://lkml.kernel.org/r/20230412164548.329376-1-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dmitry Safonov <0x7f454c46@gmail.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Zach O'Keefe <zokeefe@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/uffd-unit-tests.c |  112 ++++++++++++++---
 1 file changed, 97 insertions(+), 15 deletions(-)

--- a/tools/testing/selftests/mm/uffd-unit-tests.c~selftests-mm-add-uffdio-register-ioctls-test
+++ a/tools/testing/selftests/mm/uffd-unit-tests.c
@@ -62,8 +62,14 @@ mem_type_t mem_types[] = {
 	},
 };
 
+/* Arguments to be passed over to each uffd unit test */
+struct uffd_test_args {
+	mem_type_t *mem_type;
+};
+typedef struct uffd_test_args uffd_test_args_t;
+
 /* Returns: UFFD_TEST_* */
-typedef void (*uffd_test_fn)(void);
+typedef void (*uffd_test_fn)(uffd_test_args_t *);
 
 typedef struct {
 	const char *name;
@@ -172,8 +178,9 @@ out:
  * This function initializes the global variables.  TODO: remove global
  * vars and then remove this.
  */
-static int uffd_setup_environment(uffd_test_case_t *test, mem_type_t *mem_type,
-				  const char **errmsg)
+static int
+uffd_setup_environment(uffd_test_args_t *args, uffd_test_case_t *test,
+		       mem_type_t *mem_type, const char **errmsg)
 {
 	map_shared = mem_type->shared;
 	uffd_test_ops = mem_type->mem_ops;
@@ -187,6 +194,9 @@ static int uffd_setup_environment(uffd_t
 	/* TODO: remove this global var.. it's so ugly */
 	nr_cpus = 1;
 
+	/* Initialize test arguments */
+	args->mem_type = mem_type;
+
 	return uffd_test_ctx_init(test->uffd_feature_required, errmsg);
 }
 
@@ -239,7 +249,7 @@ static int pagemap_test_fork(bool presen
 	return result;
 }
 
-static void uffd_wp_unpopulated_test(void)
+static void uffd_wp_unpopulated_test(uffd_test_args_t *args)
 {
 	uint64_t value;
 	int pagemap_fd;
@@ -285,7 +295,7 @@ static void uffd_wp_unpopulated_test(voi
 	uffd_test_pass();
 }
 
-static void uffd_pagemap_test(void)
+static void uffd_pagemap_test(uffd_test_args_t *args)
 {
 	int pagemap_fd;
 	uint64_t value;
@@ -415,17 +425,17 @@ static void uffd_minor_test_common(bool
 		uffd_test_pass();
 }
 
-void uffd_minor_test(void)
+void uffd_minor_test(uffd_test_args_t *args)
 {
 	uffd_minor_test_common(false, false);
 }
 
-void uffd_minor_wp_test(void)
+void uffd_minor_wp_test(uffd_test_args_t *args)
 {
 	uffd_minor_test_common(false, true);
 }
 
-void uffd_minor_collapse_test(void)
+void uffd_minor_collapse_test(uffd_test_args_t *args)
 {
 	uffd_minor_test_common(true, false);
 }
@@ -603,12 +613,12 @@ static void uffd_sigbus_test_common(bool
 		uffd_test_pass();
 }
 
-static void uffd_sigbus_test(void)
+static void uffd_sigbus_test(uffd_test_args_t *args)
 {
 	uffd_sigbus_test_common(false);
 }
 
-static void uffd_sigbus_wp_test(void)
+static void uffd_sigbus_wp_test(uffd_test_args_t *args)
 {
 	uffd_sigbus_test_common(true);
 }
@@ -651,12 +661,12 @@ static void uffd_events_test_common(bool
 		uffd_test_pass();
 }
 
-static void uffd_events_test(void)
+static void uffd_events_test(uffd_test_args_t *args)
 {
 	uffd_events_test_common(false);
 }
 
-static void uffd_events_wp_test(void)
+static void uffd_events_wp_test(uffd_test_args_t *args)
 {
 	uffd_events_test_common(true);
 }
@@ -724,7 +734,7 @@ uffd_register_detect_zeropage(int uffd,
 }
 
 /* exercise UFFDIO_ZEROPAGE */
-static void uffd_zeropage_test(void)
+static void uffd_zeropage_test(uffd_test_args_t *args)
 {
 	bool has_zeropage;
 	int i;
@@ -748,8 +758,78 @@ static void uffd_zeropage_test(void)
 	uffd_test_pass();
 }
 
+/*
+ * Test the returned uffdio_register.ioctls with different register modes.
+ * Note that _UFFDIO_ZEROPAGE is tested separately in the zeropage test.
+ */
+static void
+do_register_ioctls_test(uffd_test_args_t *args, bool miss, bool wp, bool minor)
+{
+	uint64_t ioctls = 0, expected = BIT_ULL(_UFFDIO_WAKE);
+	mem_type_t *mem_type = args->mem_type;
+	int ret;
+
+	ret = uffd_register_with_ioctls(uffd, area_dst, page_size,
+					miss, wp, minor, &ioctls);
+
+	/*
+	 * Handle special cases of UFFDIO_REGISTER here where it should
+	 * just fail with -EINVAL first..
+	 *
+	 * Case 1: register MINOR on anon
+	 * Case 2: register with no mode selected
+	 */
+	if ((minor && (mem_type->mem_flag == MEM_ANON)) ||
+	    (!miss && !wp && !minor)) {
+		if (ret != -EINVAL)
+			err("register (miss=%d, wp=%d, minor=%d) failed "
+			    "with wrong errno=%d", miss, wp, minor, ret);
+		return;
+	}
+
+	/* UFFDIO_REGISTER should succeed, then check ioctls returned */
+	if (miss)
+		expected |= BIT_ULL(_UFFDIO_COPY);
+	if (wp)
+		expected |= BIT_ULL(_UFFDIO_WRITEPROTECT);
+	if (minor)
+		expected |= BIT_ULL(_UFFDIO_CONTINUE);
+
+	if ((ioctls & expected) != expected)
+		err("unexpected uffdio_register.ioctls "
+		    "(miss=%d, wp=%d, minor=%d): expected=0x%"PRIx64", "
+		    "returned=0x%"PRIx64, miss, wp, minor, expected, ioctls);
+
+	if (uffd_unregister(uffd, area_dst, page_size))
+		err("unregister");
+}
+
+static void uffd_register_ioctls_test(uffd_test_args_t *args)
+{
+	int miss, wp, minor;
+
+	for (miss = 0; miss <= 1; miss++)
+		for (wp = 0; wp <= 1; wp++)
+			for (minor = 0; minor <= 1; minor++)
+				do_register_ioctls_test(args, miss, wp, minor);
+
+	uffd_test_pass();
+}
+
 uffd_test_case_t uffd_tests[] = {
 	{
+		/* Test returned uffdio_register.ioctls. */
+		.name = "register-ioctls",
+		.uffd_fn = uffd_register_ioctls_test,
+		.mem_targets = MEM_ALL,
+		.uffd_feature_required = UFFD_FEATURE_MISSING_HUGETLBFS |
+		UFFD_FEATURE_MISSING_SHMEM |
+		UFFD_FEATURE_PAGEFAULT_FLAG_WP |
+		UFFD_FEATURE_WP_HUGETLBFS_SHMEM |
+		UFFD_FEATURE_MINOR_HUGETLBFS |
+		UFFD_FEATURE_MINOR_SHMEM,
+	},
+	{
 		.name = "zeropage",
 		.uffd_fn = uffd_zeropage_test,
 		.mem_targets = MEM_ALL,
@@ -835,6 +915,7 @@ int main(int argc, char *argv[])
 	int n_mems = sizeof(mem_types) / sizeof(mem_type_t);
 	uffd_test_case_t *test;
 	mem_type_t *mem_type;
+	uffd_test_args_t args;
 	char test_name[128];
 	const char *errmsg;
 	int has_uffd;
@@ -862,11 +943,12 @@ int main(int argc, char *argv[])
 				uffd_test_skip("feature missing");
 				continue;
 			}
-			if (uffd_setup_environment(test, mem_type, &errmsg)) {
+			if (uffd_setup_environment(&args, test, mem_type,
+						   &errmsg)) {
 				uffd_test_skip(errmsg);
 				continue;
 			}
-			test->uffd_fn();
+			test->uffd_fn(&args);
 		}
 	}
 
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-hugetlb-fix-uffd-wp-during-fork.patch
mm-hugetlb-fix-uffd-wp-bit-lost-when-unsharing-happens.patch
selftests-mm-add-a-few-options-for-uffd-unit-test.patch
selftests-mm-extend-and-rename-uffd-pagemap-test.patch
selftests-mm-rename-cow_extra_libs-to-iouring_extra_libs.patch
selftests-mm-add-tests-for-ro-pinning-vs-fork.patch

