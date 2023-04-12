Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 116B1C77B6E
	for <mm-commits@archiver.kernel.org>; Wed, 12 Apr 2023 20:03:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229901AbjDLUD5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Apr 2023 16:03:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbjDLUDe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Apr 2023 16:03:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2D2E4C3D
        for <mm-commits@vger.kernel.org>; Wed, 12 Apr 2023 13:03:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6DCC7638DE
        for <mm-commits@vger.kernel.org>; Wed, 12 Apr 2023 20:03:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2B2FC4339B;
        Wed, 12 Apr 2023 20:03:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681329804;
        bh=5UT5bufj7vYLtm1UJfOvWSjHmjIE2pFgI+dJDwciaNM=;
        h=Date:To:From:Subject:From;
        b=txiqqsZdlQWuOhby2Yxpcrop7/7k4PrbZd8i/6Nb6Yav6aE3fuD5JCquYM+GAgcYM
         hA6CXJKicx6VEK+Oztcp5tVcdXzput8HNnbP9/2Kgxu8FGSSrMDEh948AWocGqvOrT
         R4vtiV8ELr3YcjZNrdBKlRQNyPhC0pFCjjJSK3Wg=
Date:   Wed, 12 Apr 2023 13:03:24 -0700
To:     mm-commits@vger.kernel.org, zokeefe@google.com, rppt@kernel.org,
        mike.kravetz@oracle.com, david@redhat.com,
        axelrasmussen@google.com, 0x7f454c46@gmail.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-add-shmem-private-test-to-uffd-stress.patch added to mm-unstable branch
Message-Id: <20230412200324.C2B2FC4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/mm: add shmem-private test to uffd-stress
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-add-shmem-private-test-to-uffd-stress.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-add-shmem-private-test-to-uffd-stress.patch

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
Subject: selftests/mm: add shmem-private test to uffd-stress
Date: Wed, 12 Apr 2023 12:45:46 -0400

The userfaultfd stress test never tested private shmem, which I think was
overlooked long due.  Add it so it matches with uffd unit test and it'll
cover all memory supported with the three memory types.

Meanwhile, rename the memory types a bit.  Considering shared mem is the
major use case for both shmem / hugetlbfs, changing from:

  anon, hugetlb, hugetlb_shared, shmem

To (with shmem-private added):

  anon, hugetlb, hugetlb-private, shmem, shmem-private

Add the shmem-private to run_vmtests.sh too.

Link: https://lkml.kernel.org/r/20230412164546.329355-1-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dmitry Safonov <0x7f454c46@gmail.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Zach O'Keefe <zokeefe@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/run_vmtests.sh |    3 ++-
 tools/testing/selftests/mm/uffd-stress.c  |   11 +++++++----
 2 files changed, 9 insertions(+), 5 deletions(-)

--- a/tools/testing/selftests/mm/run_vmtests.sh~selftests-mm-add-shmem-private-test-to-uffd-stress
+++ a/tools/testing/selftests/mm/run_vmtests.sh
@@ -202,8 +202,9 @@ CATEGORY="userfaultfd" run_test ${uffd_s
 # Hugetlb tests require source and destination huge pages. Pass in half
 # the size ($half_ufd_size_MB), which is used for *each*.
 CATEGORY="userfaultfd" run_test ${uffd_stress_bin} hugetlb "$half_ufd_size_MB" 32
-CATEGORY="userfaultfd" run_test ${uffd_stress_bin} hugetlb_shared "$half_ufd_size_MB" 32
+CATEGORY="userfaultfd" run_test ${uffd_stress_bin} hugetlb-private "$half_ufd_size_MB" 32
 CATEGORY="userfaultfd" run_test ${uffd_stress_bin} shmem 20 16
+CATEGORY="userfaultfd" run_test ${uffd_stress_bin} shmem-private 20 16
 
 #cleanup
 echo "$nr_hugepgs" > /proc/sys/vm/nr_hugepages
--- a/tools/testing/selftests/mm/uffd-stress.c~selftests-mm-add-shmem-private-test-to-uffd-stress
+++ a/tools/testing/selftests/mm/uffd-stress.c
@@ -59,8 +59,8 @@ const char *examples =
     "./userfaultfd shmem 1000 99\n\n"
     "# Run hugetlb memory test on 256MiB region with 50 bounces:\n"
     "./userfaultfd hugetlb 256 50\n\n"
-    "# Run the same hugetlb test but using shared file:\n"
-    "./userfaultfd hugetlb_shared 256 50\n\n"
+    "# Run the same hugetlb test but using private file:\n"
+    "./userfaultfd hugetlb-private 256 50\n\n"
     "# 10MiB-~6GiB 999 bounces anonymous test, "
     "continue forever unless an error triggers\n"
     "while ./userfaultfd anon $[RANDOM % 6000 + 10] 999; do true; done\n\n";
@@ -69,7 +69,7 @@ static void usage(void)
 {
 	fprintf(stderr, "\nUsage: ./userfaultfd <test type> <MiB> <bounces>\n\n");
 	fprintf(stderr, "Supported <test type>: anon, hugetlb, "
-		"hugetlb_shared, shmem\n\n");
+		"hugetlb-private, shmem, shmem-private\n\n");
 	fprintf(stderr, "Examples:\n\n");
 	fprintf(stderr, "%s", examples);
 	exit(1);
@@ -376,14 +376,17 @@ static void set_test_type(const char *ty
 	} else if (!strcmp(type, "hugetlb")) {
 		test_type = TEST_HUGETLB;
 		uffd_test_ops = &hugetlb_uffd_test_ops;
-	} else if (!strcmp(type, "hugetlb_shared")) {
 		map_shared = true;
+	} else if (!strcmp(type, "hugetlb-private")) {
 		test_type = TEST_HUGETLB;
 		uffd_test_ops = &hugetlb_uffd_test_ops;
 	} else if (!strcmp(type, "shmem")) {
 		map_shared = true;
 		test_type = TEST_SHMEM;
 		uffd_test_ops = &shmem_uffd_test_ops;
+	} else if (!strcmp(type, "shmem-private")) {
+		test_type = TEST_SHMEM;
+		uffd_test_ops = &shmem_uffd_test_ops;
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

