Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23755C77B72
	for <mm-commits@archiver.kernel.org>; Wed, 12 Apr 2023 20:03:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229800AbjDLUDS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Apr 2023 16:03:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229862AbjDLUDA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Apr 2023 16:03:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8BB16E8A
        for <mm-commits@vger.kernel.org>; Wed, 12 Apr 2023 13:02:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 549CD638BE
        for <mm-commits@vger.kernel.org>; Wed, 12 Apr 2023 20:02:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB6B8C433EF;
        Wed, 12 Apr 2023 20:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681329776;
        bh=G9OWWMFJYhd8cTmUozs8UmkR27yBjmvrwDcZfLGTnno=;
        h=Date:To:From:Subject:From;
        b=M2fDO6vJ8U5GO21ZmOJTEAArQJ7eGkQQuxj0OYwsXli/yhxRuGO7M2LFyOT3XYXpN
         SGDalwtMAw5HtKjXodGBplYkZj6UwC6fV5HWOoT/6d9YtmQ2Euu6NFYek+//HQNo4E
         2uZKcoYmVBD6UFvbqx+BHLVL5pONp1UUyGUritZA=
Date:   Wed, 12 Apr 2023 13:02:56 -0700
To:     mm-commits@vger.kernel.org, zokeefe@google.com, rppt@kernel.org,
        mike.kravetz@oracle.com, david@redhat.com,
        axelrasmussen@google.com, 0x7f454c46@gmail.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-drop-global-hpage_size-in-uffd-tests.patch added to mm-unstable branch
Message-Id: <20230412200256.AB6B8C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/mm: drop global hpage_size in uffd tests
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-drop-global-hpage_size-in-uffd-tests.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-drop-global-hpage_size-in-uffd-tests.patch

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
Subject: selftests/mm: drop global hpage_size in uffd tests
Date: Wed, 12 Apr 2023 12:43:33 -0400

hpage_size was wrongly used.  Sometimes it means hugetlb default size,
sometimes it was used as thp size.

Remove the global variable and use the right one at each place.

Link: https://lkml.kernel.org/r/20230412164333.328596-1-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dmitry Safonov <0x7f454c46@gmail.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Zach O'Keefe <zokeefe@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/uffd-common.c |    7 ++++---
 tools/testing/selftests/mm/uffd-common.h |    2 +-
 tools/testing/selftests/mm/uffd-stress.c |    6 +++---
 3 files changed, 8 insertions(+), 7 deletions(-)

--- a/tools/testing/selftests/mm/uffd-common.c~selftests-mm-drop-global-hpage_size-in-uffd-tests
+++ a/tools/testing/selftests/mm/uffd-common.c
@@ -10,7 +10,7 @@
 #define BASE_PMD_ADDR ((void *)(1UL << 30))
 
 volatile bool test_uffdio_copy_eexist = true;
-unsigned long nr_cpus, nr_pages, nr_pages_per_cpu, page_size, hpage_size;
+unsigned long nr_cpus, nr_pages, nr_pages_per_cpu, page_size;
 char *area_src, *area_src_alias, *area_dst, *area_dst_alias, *area_remap;
 int uffd = -1, uffd_flags, finished, *pipefd, test_type;
 bool map_shared, test_collapse, test_dev_userfaultfd;
@@ -115,7 +115,7 @@ static void shmem_release_pages(char *re
 static void shmem_allocate_area(void **alloc_area, bool is_src)
 {
 	void *area_alias = NULL;
-	size_t bytes = nr_pages * page_size;
+	size_t bytes = nr_pages * page_size, hpage_size = read_pmd_pagesize();
 	unsigned long offset = is_src ? 0 : bytes;
 	char *p = NULL, *p_alias = NULL;
 	int mem_fd = uffd_mem_fd_create(bytes * 2, false);
@@ -159,7 +159,8 @@ static void shmem_alias_mapping(__u64 *s
 
 static void shmem_check_pmd_mapping(void *p, int expect_nr_hpages)
 {
-	if (!check_huge_shmem(area_dst_alias, expect_nr_hpages, hpage_size))
+	if (!check_huge_shmem(area_dst_alias, expect_nr_hpages,
+			      read_pmd_pagesize()))
 		err("Did not find expected %d number of hugepages",
 		    expect_nr_hpages);
 }
--- a/tools/testing/selftests/mm/uffd-common.h~selftests-mm-drop-global-hpage_size-in-uffd-tests
+++ a/tools/testing/selftests/mm/uffd-common.h
@@ -85,7 +85,7 @@ struct uffd_test_ops {
 };
 typedef struct uffd_test_ops uffd_test_ops_t;
 
-extern unsigned long nr_cpus, nr_pages, nr_pages_per_cpu, page_size, hpage_size;
+extern unsigned long nr_cpus, nr_pages, nr_pages_per_cpu, page_size;
 extern char *area_src, *area_src_alias, *area_dst, *area_dst_alias, *area_remap;
 extern int uffd, uffd_flags, finished, *pipefd, test_type;
 extern bool map_shared, test_collapse, test_dev_userfaultfd;
--- a/tools/testing/selftests/mm/uffd-stress.c~selftests-mm-drop-global-hpage_size-in-uffd-tests
+++ a/tools/testing/selftests/mm/uffd-stress.c
@@ -655,7 +655,7 @@ static int userfaultfd_minor_test(void)
 
 		uffd_test_ops->check_pmd_mapping(area_dst,
 						 nr_pages * page_size /
-						 hpage_size);
+						 read_pmd_pagesize());
 		/*
 		 * This won't cause uffd-fault - it purely just makes sure there
 		 * was no corruption.
@@ -997,7 +997,7 @@ static void parse_test_type_arg(const ch
 		err("Unsupported test: %s", raw_type);
 
 	if (test_type == TEST_HUGETLB)
-		page_size = hpage_size;
+		page_size = default_huge_page_size();
 	else
 		page_size = sysconf(_SC_PAGE_SIZE);
 
@@ -1035,6 +1035,7 @@ static void sigalrm(int sig)
 int main(int argc, char **argv)
 {
 	size_t bytes;
+	size_t hpage_size = read_pmd_pagesize();
 
 	if (argc < 4)
 		usage();
@@ -1043,7 +1044,6 @@ int main(int argc, char **argv)
 		err("failed to arm SIGALRM");
 	alarm(ALARM_INTERVAL_SECS);
 
-	hpage_size = default_huge_page_size();
 	parse_test_type_arg(argv[1]);
 	bytes = atol(argv[2]) * 1024 * 1024;
 
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

