Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CAE4C7619A
	for <mm-commits@archiver.kernel.org>; Wed, 12 Apr 2023 20:03:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230096AbjDLUD4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Apr 2023 16:03:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229887AbjDLUDY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Apr 2023 16:03:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C9B7768C
        for <mm-commits@vger.kernel.org>; Wed, 12 Apr 2023 13:03:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 09F3C61727
        for <mm-commits@vger.kernel.org>; Wed, 12 Apr 2023 20:03:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66970C433D2;
        Wed, 12 Apr 2023 20:03:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681329802;
        bh=ilzyAdRs4/Blt32OqWbjSLUF/b8RaM2iBcoyhQsE094=;
        h=Date:To:From:Subject:From;
        b=uz8zJgPSxIueRshkfcLRhd+8jbnmww1ZF45uPMXU813IEBz4qtOK2ttK/EbAlL5Gd
         GHrh0wfmYA5ZeRn3FJ83S7ghjyIncAeJsek002hBicBk9pxD3innJuxAVP6D3EjuJ8
         5Nv/YMHt8FsUjCJyaxtzfzvpMHqfjGKrzd+AOJ+U=
Date:   Wed, 12 Apr 2023 13:03:21 -0700
To:     mm-commits@vger.kernel.org, zokeefe@google.com, rppt@kernel.org,
        mike.kravetz@oracle.com, david@redhat.com,
        axelrasmussen@google.com, 0x7f454c46@gmail.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-drop-sys-dev-test-in-uffd-stress-test.patch added to mm-unstable branch
Message-Id: <20230412200322.66970C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/mm: drop sys/dev test in uffd-stress test
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-drop-sys-dev-test-in-uffd-stress-test.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-drop-sys-dev-test-in-uffd-stress-test.patch

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
Subject: selftests/mm: drop sys/dev test in uffd-stress test
Date: Wed, 12 Apr 2023 12:45:25 -0400

With the new uffd unit test covering the /dev/userfaultfd path and syscall
path of uffd initializations, we can safely drop the devnode test in the
old stress test.

One thing is to avoid duplication of running the stress test twice which is
an overkill to only test the /dev/ interface in run_vmtests.sh.

The other benefit is now all uffd tests (that uses userfaultfd_open) can
run automatically as long as any type of interface is enabled (either
syscall or dev), so it's more likely to succeed rather than fail due to
unprivilege.

With this patch lands, we can drop all the "mem_type:XXX" handlings too.

Link: https://lkml.kernel.org/r/20230412164525.329176-1-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dmitry Safonov <0x7f454c46@gmail.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Zach O'Keefe <zokeefe@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/run_vmtests.sh |   15 ++++-------
 tools/testing/selftests/mm/uffd-common.c  |    7 +----
 tools/testing/selftests/mm/uffd-common.h  |    2 -
 tools/testing/selftests/mm/uffd-stress.c  |   27 +-------------------
 4 files changed, 11 insertions(+), 40 deletions(-)

--- a/tools/testing/selftests/mm/run_vmtests.sh~selftests-mm-drop-sys-dev-test-in-uffd-stress-test
+++ a/tools/testing/selftests/mm/run_vmtests.sh
@@ -197,16 +197,13 @@ CATEGORY="gup_test" run_test ./gup_test
 CATEGORY="gup_test" run_test ./gup_test -ct -F 0x1 0 19 0x1000
 
 CATEGORY="userfaultfd" run_test ./uffd-unit-tests
-uffd_mods=("" ":dev")
 uffd_stress_bin=./uffd-stress
-for mod in "${uffd_mods[@]}"; do
-	CATEGORY="userfaultfd" run_test ${uffd_stress_bin} anon${mod} 20 16
-	# Hugetlb tests require source and destination huge pages. Pass in half
-	# the size ($half_ufd_size_MB), which is used for *each*.
-	CATEGORY="userfaultfd" run_test ${uffd_stress_bin} hugetlb${mod} "$half_ufd_size_MB" 32
-	CATEGORY="userfaultfd" run_test ${uffd_stress_bin} hugetlb_shared${mod} "$half_ufd_size_MB" 32
-	CATEGORY="userfaultfd" run_test ${uffd_stress_bin} shmem${mod} 20 16
-done
+CATEGORY="userfaultfd" run_test ${uffd_stress_bin} anon 20 16
+# Hugetlb tests require source and destination huge pages. Pass in half
+# the size ($half_ufd_size_MB), which is used for *each*.
+CATEGORY="userfaultfd" run_test ${uffd_stress_bin} hugetlb "$half_ufd_size_MB" 32
+CATEGORY="userfaultfd" run_test ${uffd_stress_bin} hugetlb_shared "$half_ufd_size_MB" 32
+CATEGORY="userfaultfd" run_test ${uffd_stress_bin} shmem 20 16
 
 #cleanup
 echo "$nr_hugepgs" > /proc/sys/vm/nr_hugepages
--- a/tools/testing/selftests/mm/uffd-common.c~selftests-mm-drop-sys-dev-test-in-uffd-stress-test
+++ a/tools/testing/selftests/mm/uffd-common.c
@@ -13,7 +13,7 @@ volatile bool test_uffdio_copy_eexist =
 unsigned long nr_cpus, nr_pages, nr_pages_per_cpu, page_size;
 char *area_src, *area_src_alias, *area_dst, *area_dst_alias, *area_remap;
 int uffd = -1, uffd_flags, finished, *pipefd, test_type;
-bool map_shared, test_dev_userfaultfd;
+bool map_shared;
 bool test_uffdio_wp = true;
 unsigned long long *count_verify;
 uffd_test_ops_t *uffd_test_ops;
@@ -236,10 +236,7 @@ int userfaultfd_open(uint64_t *features)
 {
 	struct uffdio_api uffdio_api;
 
-	if (test_dev_userfaultfd)
-		uffd = uffd_open_dev(UFFD_FLAGS);
-	else
-		uffd = uffd_open_sys(UFFD_FLAGS);
+	uffd = uffd_open(UFFD_FLAGS);
 	if (uffd < 0)
 		return -1;
 	uffd_flags = fcntl(uffd, F_GETFD, NULL);
--- a/tools/testing/selftests/mm/uffd-common.h~selftests-mm-drop-sys-dev-test-in-uffd-stress-test
+++ a/tools/testing/selftests/mm/uffd-common.h
@@ -90,7 +90,7 @@ typedef struct uffd_test_ops uffd_test_o
 extern unsigned long nr_cpus, nr_pages, nr_pages_per_cpu, page_size;
 extern char *area_src, *area_src_alias, *area_dst, *area_dst_alias, *area_remap;
 extern int uffd, uffd_flags, finished, *pipefd, test_type;
-extern bool map_shared, test_dev_userfaultfd;
+extern bool map_shared;
 extern bool test_uffdio_wp;
 extern unsigned long long *count_verify;
 extern volatile bool test_uffdio_copy_eexist;
--- a/tools/testing/selftests/mm/uffd-stress.c~selftests-mm-drop-sys-dev-test-in-uffd-stress-test
+++ a/tools/testing/selftests/mm/uffd-stress.c
@@ -55,8 +55,6 @@ pthread_attr_t attr;
 const char *examples =
     "# Run anonymous memory test on 100MiB region with 99999 bounces:\n"
     "./userfaultfd anon 100 99999\n\n"
-    "# Run the same anonymous memory test, but using /dev/userfaultfd:\n"
-    "./userfaultfd anon:dev 100 99999\n\n"
     "# Run share memory test on 1GiB region with 99 bounces:\n"
     "./userfaultfd shmem 1000 99\n\n"
     "# Run hugetlb memory test on 256MiB region with 50 bounces:\n"
@@ -69,18 +67,9 @@ const char *examples =
 
 static void usage(void)
 {
-	fprintf(stderr, "\nUsage: ./userfaultfd <test type> <MiB> <bounces> "
-		"[hugetlbfs_file]\n\n");
+	fprintf(stderr, "\nUsage: ./userfaultfd <test type> <MiB> <bounces>\n\n");
 	fprintf(stderr, "Supported <test type>: anon, hugetlb, "
 		"hugetlb_shared, shmem\n\n");
-	fprintf(stderr, "'Test mods' can be joined to the test type string with a ':'. "
-		"Supported mods:\n");
-	fprintf(stderr, "\tsyscall - Use userfaultfd(2) (default)\n");
-	fprintf(stderr, "\tdev - Use /dev/userfaultfd instead of userfaultfd(2)\n");
-	fprintf(stderr, "\nExample test mod usage:\n");
-	fprintf(stderr, "# Run anonymous memory test with /dev/userfaultfd:\n");
-	fprintf(stderr, "./userfaultfd anon:dev 100 99999\n\n");
-
 	fprintf(stderr, "Examples:\n\n");
 	fprintf(stderr, "%s", examples);
 	exit(1);
@@ -400,21 +389,9 @@ static void set_test_type(const char *ty
 
 static void parse_test_type_arg(const char *raw_type)
 {
-	char *buf = strdup(raw_type);
 	uint64_t features = UFFD_API_FEATURES;
 
-	while (buf) {
-		const char *token = strsep(&buf, ":");
-
-		if (!test_type)
-			set_test_type(token);
-		else if (!strcmp(token, "dev"))
-			test_dev_userfaultfd = true;
-		else if (!strcmp(token, "syscall"))
-			test_dev_userfaultfd = false;
-		else
-			err("unrecognized test mod '%s'", token);
-	}
+	set_test_type(raw_type);
 
 	if (!test_type)
 		err("failed to parse test type argument: '%s'", raw_type);
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

