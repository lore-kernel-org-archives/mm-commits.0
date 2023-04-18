Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40C63C77B7C
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 23:38:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231580AbjDRXii (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Apr 2023 19:38:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231663AbjDRXgz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2023 19:36:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F48DD335
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 16:35:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7DB5C62CA1
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 23:35:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D420BC4339B;
        Tue, 18 Apr 2023 23:35:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681860939;
        bh=vLnaqrfAcM+lLt/n9tKnXmHYy6q7OB1lttCvmovEI44=;
        h=Date:To:From:Subject:From;
        b=qk3wGUXZNygRInKPXn74Z6xRUrONHmkh8X6Lr/ge1EH4NrfeLarsqADJUDE0DT0kb
         /Af+IbrB7I9Z3n5mYZ61Lj6IGqB8Ide5mWyvv0eJFpmPg1M8s7OXehD86t3ing5oAS
         /N26AM/UKxrsuZZvOvzZe7uhTKcoB3D6SpYXWbgw=
Date:   Tue, 18 Apr 2023 16:35:39 -0700
To:     mm-commits@vger.kernel.org, zokeefe@google.com, rppt@kernel.org,
        mike.kravetz@oracle.com, david@redhat.com,
        axelrasmussen@google.com, 0x7f454c46@gmail.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-add-shmem-private-test-to-uffd-stress.patch removed from -mm tree
Message-Id: <20230418233539.D420BC4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests/mm: add shmem-private test to uffd-stress
has been removed from the -mm tree.  Its filename was
     selftests-mm-add-shmem-private-test-to-uffd-stress.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

selftests-mm-add-uffdio-register-ioctls-test.patch
mm-hugetlb-fix-uffd-wp-during-fork.patch
mm-hugetlb-fix-uffd-wp-bit-lost-when-unsharing-happens.patch
selftests-mm-add-a-few-options-for-uffd-unit-test.patch
selftests-mm-extend-and-rename-uffd-pagemap-test.patch
selftests-mm-rename-cow_extra_libs-to-iouring_extra_libs.patch
selftests-mm-add-tests-for-ro-pinning-vs-fork.patch

