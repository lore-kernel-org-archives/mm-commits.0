Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8ED67C77B6E
	for <mm-commits@archiver.kernel.org>; Wed, 12 Apr 2023 20:03:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230085AbjDLUDR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Apr 2023 16:03:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229969AbjDLUC7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Apr 2023 16:02:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69B596A7A
        for <mm-commits@vger.kernel.org>; Wed, 12 Apr 2023 13:02:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 065E062E18
        for <mm-commits@vger.kernel.org>; Wed, 12 Apr 2023 20:02:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 632E5C433EF;
        Wed, 12 Apr 2023 20:02:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681329774;
        bh=tzRqxeTd0fph60lld6w6cP81TXerVSWIwZ8TfF09Tn4=;
        h=Date:To:From:Subject:From;
        b=vuwpotJLYIMS496zay3Xj7NracyrCQ6rW+YpCWbCiRERWRZ1csAXKLtWRjpY/dDgu
         846cT1CaEJdDZkzcCHVJcSby+qnhBY3v+czeEQ0WSVJDFkqxNZrkXW/cegfM/5CKvw
         TzmlrCPTSQDcC3sS48NoeSrZjTPjr3xQ9O1Jd1OE=
Date:   Wed, 12 Apr 2023 13:02:53 -0700
To:     mm-commits@vger.kernel.org, zokeefe@google.com, rppt@kernel.org,
        mike.kravetz@oracle.com, david@redhat.com,
        axelrasmussen@google.com, 0x7f454c46@gmail.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-drop-global-mem_fd-in-uffd-tests.patch added to mm-unstable branch
Message-Id: <20230412200254.632E5C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/mm: drop global mem_fd in uffd tests
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-drop-global-mem_fd-in-uffd-tests.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-drop-global-mem_fd-in-uffd-tests.patch

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
Subject: selftests/mm: drop global mem_fd in uffd tests
Date: Wed, 12 Apr 2023 12:43:31 -0400

Drop it by creating the memfd dynamically in the tests.

Link: https://lkml.kernel.org/r/20230412164331.328584-1-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dmitry Safonov <0x7f454c46@gmail.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Zach O'Keefe <zokeefe@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/uffd-common.c |   28 ++++++++++++++++++++-
 tools/testing/selftests/mm/uffd-common.h |    2 -
 tools/testing/selftests/mm/uffd-stress.c |   15 -----------
 3 files changed, 28 insertions(+), 17 deletions(-)

--- a/tools/testing/selftests/mm/uffd-common.c~selftests-mm-drop-global-mem_fd-in-uffd-tests
+++ a/tools/testing/selftests/mm/uffd-common.c
@@ -12,12 +12,32 @@
 volatile bool test_uffdio_copy_eexist = true;
 unsigned long nr_cpus, nr_pages, nr_pages_per_cpu, page_size, hpage_size;
 char *area_src, *area_src_alias, *area_dst, *area_dst_alias, *area_remap;
-int mem_fd, uffd = -1, uffd_flags, finished, *pipefd, test_type;
+int uffd = -1, uffd_flags, finished, *pipefd, test_type;
 bool map_shared, test_collapse, test_dev_userfaultfd;
 bool test_uffdio_wp = true, test_uffdio_minor = false;
 unsigned long long *count_verify;
 uffd_test_ops_t *uffd_test_ops;
 
+static int uffd_mem_fd_create(off_t mem_size, bool hugetlb)
+{
+	unsigned int memfd_flags = 0;
+	int mem_fd;
+
+	if (hugetlb)
+		memfd_flags = MFD_HUGETLB;
+	mem_fd = memfd_create("uffd-test", memfd_flags);
+	if (mem_fd < 0)
+		err("memfd_create");
+	if (ftruncate(mem_fd, mem_size))
+		err("ftruncate");
+	if (fallocate(mem_fd,
+		      FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE, 0,
+		      mem_size))
+		err("fallocate");
+
+	return mem_fd;
+}
+
 static void anon_release_pages(char *rel_area)
 {
 	if (madvise(rel_area, nr_pages * page_size, MADV_DONTNEED))
@@ -51,6 +71,7 @@ static void hugetlb_allocate_area(void *
 	off_t offset = is_src ? 0 : size;
 	void *area_alias = NULL;
 	char **alloc_area_alias;
+	int mem_fd = uffd_mem_fd_create(size * 2, true);
 
 	*alloc_area = mmap(NULL, size, PROT_READ | PROT_WRITE,
 			   (map_shared ? MAP_SHARED : MAP_PRIVATE) |
@@ -73,6 +94,8 @@ static void hugetlb_allocate_area(void *
 	}
 	if (area_alias)
 		*alloc_area_alias = area_alias;
+
+	close(mem_fd);
 }
 
 static void hugetlb_alias_mapping(__u64 *start, size_t len, unsigned long offset)
@@ -95,6 +118,7 @@ static void shmem_allocate_area(void **a
 	size_t bytes = nr_pages * page_size;
 	unsigned long offset = is_src ? 0 : bytes;
 	char *p = NULL, *p_alias = NULL;
+	int mem_fd = uffd_mem_fd_create(bytes * 2, false);
 
 	if (test_collapse) {
 		p = BASE_PMD_ADDR;
@@ -124,6 +148,8 @@ static void shmem_allocate_area(void **a
 		area_src_alias = area_alias;
 	else
 		area_dst_alias = area_alias;
+
+	close(mem_fd);
 }
 
 static void shmem_alias_mapping(__u64 *start, size_t len, unsigned long offset)
--- a/tools/testing/selftests/mm/uffd-common.h~selftests-mm-drop-global-mem_fd-in-uffd-tests
+++ a/tools/testing/selftests/mm/uffd-common.h
@@ -87,7 +87,7 @@ typedef struct uffd_test_ops uffd_test_o
 
 extern unsigned long nr_cpus, nr_pages, nr_pages_per_cpu, page_size, hpage_size;
 extern char *area_src, *area_src_alias, *area_dst, *area_dst_alias, *area_remap;
-extern int mem_fd, uffd, uffd_flags, finished, *pipefd, test_type;
+extern int uffd, uffd_flags, finished, *pipefd, test_type;
 extern bool map_shared, test_collapse, test_dev_userfaultfd;
 extern bool test_uffdio_wp, test_uffdio_minor;
 extern unsigned long long *count_verify;
--- a/tools/testing/selftests/mm/uffd-stress.c~selftests-mm-drop-global-mem_fd-in-uffd-tests
+++ a/tools/testing/selftests/mm/uffd-stress.c
@@ -1090,21 +1090,6 @@ int main(int argc, char **argv)
 	}
 	nr_pages = nr_pages_per_cpu * nr_cpus;
 
-	if (test_type == TEST_SHMEM || test_type == TEST_HUGETLB) {
-		unsigned int memfd_flags = 0;
-
-		if (test_type == TEST_HUGETLB)
-			memfd_flags = MFD_HUGETLB;
-		mem_fd = memfd_create(argv[0], memfd_flags);
-		if (mem_fd < 0)
-			err("memfd_create");
-		if (ftruncate(mem_fd, nr_pages * page_size * 2))
-			err("ftruncate");
-		if (fallocate(mem_fd,
-			      FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE, 0,
-			      nr_pages * page_size * 2))
-			err("fallocate");
-	}
 	printf("nr_pages: %lu, nr_pages_per_cpu: %lu\n",
 	       nr_pages, nr_pages_per_cpu);
 	return userfaultfd_stress();
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

