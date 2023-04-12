Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FB53C77B72
	for <mm-commits@archiver.kernel.org>; Wed, 12 Apr 2023 20:03:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229527AbjDLUD6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Apr 2023 16:03:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229753AbjDLUDe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Apr 2023 16:03:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02B4B6A7A
        for <mm-commits@vger.kernel.org>; Wed, 12 Apr 2023 13:03:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 83471638E0
        for <mm-commits@vger.kernel.org>; Wed, 12 Apr 2023 20:03:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBD27C433D2;
        Wed, 12 Apr 2023 20:03:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681329806;
        bh=dlQkyg2Rv5A2kFKp1FmS8dQIN/i+TTeLH8/74/t1fR8=;
        h=Date:To:From:Subject:From;
        b=zacWTTn1QRnaI9aSs7bhZJ16nSVDKAn2jIxMs6/8GvZgxLOxiCI3RWkmZcpvgZrZV
         QOAeSAOSmwmfYcOvV0fx7haPiKigbeQ/xlyLZXeCTGB52IzTdXWUYCzKoFuU3T+/lT
         rL83rq0H2XihDlFreiN8n8zfi3+RQglzsjVOtMo0=
Date:   Wed, 12 Apr 2023 13:03:26 -0700
To:     mm-commits@vger.kernel.org, zokeefe@google.com, rppt@kernel.org,
        mike.kravetz@oracle.com, david@redhat.com,
        axelrasmussen@google.com, 0x7f454c46@gmail.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-add-uffdio-register-ioctls-test.patch added to mm-unstable branch
Message-Id: <20230412200326.DBD27C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/mm: add uffdio register ioctls test
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-add-uffdio-register-ioctls-test.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-add-uffdio-register-ioctls-test.patch

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

mm-khugepaged-check-again-on-anon-uffd-wp-during-isolation.patch
revert-userfaultfd-dont-fail-on-unrecognized-features.patch
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

