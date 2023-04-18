Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C279C77B76
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 23:38:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231599AbjDRXii (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Apr 2023 19:38:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231431AbjDRXgz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2023 19:36:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3B1193D9
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 16:35:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C556863A0D
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 23:35:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 250D6C433EF;
        Tue, 18 Apr 2023 23:35:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681860930;
        bh=rSa8t6aCg7tz4pnE4jm5Lj5T4IJioRkRB49P8V4ZUIs=;
        h=Date:To:From:Subject:From;
        b=Jh1dnaM+BUpzk4jqtZ5A+ozvzoBka0mJhDnbbiz1+MZGLRbRZK2k+witVpp73IHjp
         84pBtEHwnkrWCKHplzRCBcrHHkohgVrmOtKIC2fMmvRQuNJZbW3qWNazbMvl6JDNBq
         canwk6/3pY/IR0X0den5F89lw8r2p7ZdYM3wtG0k=
Date:   Tue, 18 Apr 2023 16:35:29 -0700
To:     mm-commits@vger.kernel.org, zokeefe@google.com, rppt@kernel.org,
        mike.kravetz@oracle.com, david@redhat.com,
        axelrasmussen@google.com, 0x7f454c46@gmail.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-allow-allocate_area-to-fail-properly.patch removed from -mm tree
Message-Id: <20230418233530.250D6C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests/mm: allow allocate_area() to fail properly
has been removed from the -mm tree.  Its filename was
     selftests-mm-allow-allocate_area-to-fail-properly.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: selftests/mm: allow allocate_area() to fail properly
Date: Wed, 12 Apr 2023 12:43:45 -0400

Mostly to detect hugetlb allocation errors and skip hugetlb tests when
pages are not allocated.

Link: https://lkml.kernel.org/r/20230412164345.328659-1-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dmitry Safonov <0x7f454c46@gmail.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Zach O'Keefe <zokeefe@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/uffd-common.c |   47 +++++++++++++++------
 tools/testing/selftests/mm/uffd-common.h |    4 -
 2 files changed, 36 insertions(+), 15 deletions(-)

--- a/tools/testing/selftests/mm/uffd-common.c~selftests-mm-allow-allocate_area-to-fail-properly
+++ a/tools/testing/selftests/mm/uffd-common.c
@@ -44,10 +44,15 @@ static void anon_release_pages(char *rel
 		err("madvise(MADV_DONTNEED) failed");
 }
 
-static void anon_allocate_area(void **alloc_area, bool is_src)
+static int anon_allocate_area(void **alloc_area, bool is_src)
 {
 	*alloc_area = mmap(NULL, nr_pages * page_size, PROT_READ | PROT_WRITE,
 			   MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
+	if (*alloc_area == MAP_FAILED) {
+		*alloc_area = NULL;
+		return -errno;
+	}
+	return 0;
 }
 
 static void noop_alias_mapping(__u64 *start, size_t len, unsigned long offset)
@@ -65,7 +70,7 @@ static void hugetlb_release_pages(char *
 	}
 }
 
-static void hugetlb_allocate_area(void **alloc_area, bool is_src)
+static int hugetlb_allocate_area(void **alloc_area, bool is_src)
 {
 	off_t size = nr_pages * page_size;
 	off_t offset = is_src ? 0 : size;
@@ -77,14 +82,16 @@ static void hugetlb_allocate_area(void *
 			   (map_shared ? MAP_SHARED : MAP_PRIVATE) |
 			   (is_src ? 0 : MAP_NORESERVE),
 			   mem_fd, offset);
-	if (*alloc_area == MAP_FAILED)
-		err("mmap of hugetlbfs file failed");
+	if (*alloc_area == MAP_FAILED) {
+		*alloc_area = NULL;
+		return -errno;
+	}
 
 	if (map_shared) {
 		area_alias = mmap(NULL, size, PROT_READ | PROT_WRITE,
 				  MAP_SHARED, mem_fd, offset);
 		if (area_alias == MAP_FAILED)
-			err("mmap of hugetlb file alias failed");
+			return -errno;
 	}
 
 	if (is_src) {
@@ -96,6 +103,7 @@ static void hugetlb_allocate_area(void *
 		*alloc_area_alias = area_alias;
 
 	close(mem_fd);
+	return 0;
 }
 
 static void hugetlb_alias_mapping(__u64 *start, size_t len, unsigned long offset)
@@ -112,7 +120,7 @@ static void shmem_release_pages(char *re
 		err("madvise(MADV_REMOVE) failed");
 }
 
-static void shmem_allocate_area(void **alloc_area, bool is_src)
+static int shmem_allocate_area(void **alloc_area, bool is_src)
 {
 	void *area_alias = NULL;
 	size_t bytes = nr_pages * page_size, hpage_size = read_pmd_pagesize();
@@ -132,15 +140,20 @@ static void shmem_allocate_area(void **a
 
 	*alloc_area = mmap(p, bytes, PROT_READ | PROT_WRITE, MAP_SHARED,
 			   mem_fd, offset);
-	if (*alloc_area == MAP_FAILED)
-		err("mmap of memfd failed");
+	if (*alloc_area == MAP_FAILED) {
+		*alloc_area = NULL;
+		return -errno;
+	}
 	if (test_collapse && *alloc_area != p)
 		err("mmap of memfd failed at %p", p);
 
 	area_alias = mmap(p_alias, bytes, PROT_READ | PROT_WRITE, MAP_SHARED,
 			  mem_fd, offset);
-	if (area_alias == MAP_FAILED)
-		err("mmap of memfd alias failed");
+	if (area_alias == MAP_FAILED) {
+		munmap(*alloc_area, bytes);
+		*alloc_area = NULL;
+		return -errno;
+	}
 	if (test_collapse && area_alias != p_alias)
 		err("mmap of anonymous memory failed at %p", p_alias);
 
@@ -150,6 +163,7 @@ static void shmem_allocate_area(void **a
 		area_dst_alias = area_alias;
 
 	close(mem_fd);
+	return 0;
 }
 
 static void shmem_alias_mapping(__u64 *start, size_t len, unsigned long offset)
@@ -282,14 +296,19 @@ static void uffd_test_ctx_clear(void)
 	munmap_area((void **)&area_remap);
 }
 
-void uffd_test_ctx_init(uint64_t features)
+int uffd_test_ctx_init(uint64_t features)
 {
 	unsigned long nr, cpu;
+	int ret;
 
 	uffd_test_ctx_clear();
 
-	uffd_test_ops->allocate_area((void **)&area_src, true);
-	uffd_test_ops->allocate_area((void **)&area_dst, false);
+	ret = uffd_test_ops->allocate_area((void **)&area_src, true);
+	if (ret)
+		return ret;
+	ret = uffd_test_ops->allocate_area((void **)&area_dst, false);
+	if (ret)
+		return ret;
 
 	userfaultfd_open(&features);
 
@@ -337,6 +356,8 @@ void uffd_test_ctx_init(uint64_t feature
 	for (cpu = 0; cpu < nr_cpus; cpu++)
 		if (pipe2(&pipefd[cpu * 2], O_CLOEXEC | O_NONBLOCK))
 			err("pipe");
+
+	return 0;
 }
 
 void wp_range(int ufd, __u64 start, __u64 len, bool wp)
--- a/tools/testing/selftests/mm/uffd-common.h~selftests-mm-allow-allocate_area-to-fail-properly
+++ a/tools/testing/selftests/mm/uffd-common.h
@@ -80,7 +80,7 @@ struct uffd_args {
 };
 
 struct uffd_test_ops {
-	void (*allocate_area)(void **alloc_area, bool is_src);
+	int (*allocate_area)(void **alloc_area, bool is_src);
 	void (*release_pages)(char *rel_area);
 	void (*alias_mapping)(__u64 *start, size_t len, unsigned long offset);
 	void (*check_pmd_mapping)(void *p, int expect_nr_hpages);
@@ -101,7 +101,7 @@ extern uffd_test_ops_t hugetlb_uffd_test
 extern uffd_test_ops_t *uffd_test_ops;
 
 void uffd_stats_report(struct uffd_args *args, int n_cpus);
-void uffd_test_ctx_init(uint64_t features);
+int uffd_test_ctx_init(uint64_t features);
 void userfaultfd_open(uint64_t *features);
 int uffd_read_msg(int ufd, struct uffd_msg *msg);
 void wp_range(int ufd, __u64 start, __u64 len, bool wp);
_

Patches currently in -mm which might be from peterx@redhat.com are

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

