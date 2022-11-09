Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FA65C433FE
	for <mm-commits@archiver.kernel.org>; Wed,  9 Nov 2022 01:38:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229917AbiKIBiO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Nov 2022 20:38:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229612AbiKIBiH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Nov 2022 20:38:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8EF260379
        for <mm-commits@vger.kernel.org>; Tue,  8 Nov 2022 17:38:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 73FEF617F0
        for <mm-commits@vger.kernel.org>; Wed,  9 Nov 2022 01:38:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF2F7C433D6;
        Wed,  9 Nov 2022 01:38:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667957885;
        bh=HpJuHF4usyH+MSe48z/NbP6p268rf+nmdeluIC+1iPA=;
        h=Date:To:From:Subject:From;
        b=uncDbgzgiuUr0huX97lln+IqqgN3uHbQcogqRnCAOrddwfbodJUqLnG1HU88q2U37
         AfSc8y4fuwPQWX4dtMoLhZY1ynwjrAnbsRkFzN1TAnuGzPGZZk2O3gSJrQYtDb64Oa
         UD+Ig3Ss0/ndBiYj0V4odCSCjIZ1dV2OGT8WVFmg=
Date:   Tue, 08 Nov 2022 17:38:05 -0800
To:     mm-commits@vger.kernel.org, mike.kravetz@oracle.com,
        axelrasmussen@google.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-vm-use-memfd-for-uffd-hugetlb-tests.patch removed from -mm tree
Message-Id: <20221109013805.CF2F7C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests/vm: use memfd for uffd hugetlb tests
has been removed from the -mm tree.  Its filename was
     selftests-vm-use-memfd-for-uffd-hugetlb-tests.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: selftests/vm: use memfd for uffd hugetlb tests
Date: Fri, 14 Oct 2022 10:39:18 -0400

Patch series "selftests/vm: Drop hugetlb mntpoint in run_vmtests.sh", v2.

Clean the code up so we can use the same memfd for both hugetlb and shmem
which is cleaner.


This patch (of 4):

We already used memfd for shmem test, move it forward with hugetlb too so
that we don't need user to specify the hugetlb file path explicitly when
running hugetlb shared tests.

Link: https://lkml.kernel.org/r/20221014143921.93887-1-peterx@redhat.com
Link: https://lkml.kernel.org/r/20221014143921.93887-2-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/userfaultfd.c |   62 +++++++--------------
 1 file changed, 21 insertions(+), 41 deletions(-)

--- a/tools/testing/selftests/vm/userfaultfd.c~selftests-vm-use-memfd-for-uffd-hugetlb-tests
+++ a/tools/testing/selftests/vm/userfaultfd.c
@@ -93,10 +93,8 @@ static volatile bool test_uffdio_zeropag
 static bool test_uffdio_wp = true;
 /* Whether to test uffd minor faults */
 static bool test_uffdio_minor = false;
-
 static bool map_shared;
-static int shm_fd;
-static int huge_fd;
+static int mem_fd;
 static unsigned long long *count_verify;
 static int uffd = -1;
 static int uffd_flags, finished, *pipefd;
@@ -143,7 +141,7 @@ const char *examples =
     "# Run hugetlb memory test on 256MiB region with 50 bounces:\n"
     "./userfaultfd hugetlb 256 50\n\n"
     "# Run the same hugetlb test but using shared file:\n"
-    "./userfaultfd hugetlb_shared 256 50 /dev/hugepages/hugefile\n\n"
+    "./userfaultfd hugetlb_shared 256 50\n\n"
     "# 10MiB-~6GiB 999 bounces anonymous test, "
     "continue forever unless an error triggers\n"
     "while ./userfaultfd anon $[RANDOM % 6000 + 10] 999; do true; done\n\n";
@@ -260,35 +258,21 @@ static void hugetlb_release_pages(char *
 
 static void hugetlb_allocate_area(void **alloc_area, bool is_src)
 {
+	off_t size = nr_pages * page_size;
+	off_t offset = is_src ? 0 : size;
 	void *area_alias = NULL;
 	char **alloc_area_alias;
 
-	if (!map_shared)
-		*alloc_area = mmap(NULL,
-			nr_pages * page_size,
-			PROT_READ | PROT_WRITE,
-			MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB |
-				(is_src ? 0 : MAP_NORESERVE),
-			-1,
-			0);
-	else
-		*alloc_area = mmap(NULL,
-			nr_pages * page_size,
-			PROT_READ | PROT_WRITE,
-			MAP_SHARED |
-				(is_src ? 0 : MAP_NORESERVE),
-			huge_fd,
-			is_src ? 0 : nr_pages * page_size);
+	*alloc_area = mmap(NULL, size, PROT_READ | PROT_WRITE,
+			   (map_shared ? MAP_SHARED : MAP_PRIVATE) |
+			   (is_src ? 0 : MAP_NORESERVE),
+			   mem_fd, offset);
 	if (*alloc_area == MAP_FAILED)
 		err("mmap of hugetlbfs file failed");
 
 	if (map_shared) {
-		area_alias = mmap(NULL,
-			nr_pages * page_size,
-			PROT_READ | PROT_WRITE,
-			MAP_SHARED,
-			huge_fd,
-			is_src ? 0 : nr_pages * page_size);
+		area_alias = mmap(NULL, size, PROT_READ | PROT_WRITE,
+				  MAP_SHARED, mem_fd, offset);
 		if (area_alias == MAP_FAILED)
 			err("mmap of hugetlb file alias failed");
 	}
@@ -334,14 +318,14 @@ static void shmem_allocate_area(void **a
 	}
 
 	*alloc_area = mmap(p, bytes, PROT_READ | PROT_WRITE, MAP_SHARED,
-			   shm_fd, offset);
+			   mem_fd, offset);
 	if (*alloc_area == MAP_FAILED)
 		err("mmap of memfd failed");
 	if (test_collapse && *alloc_area != p)
 		err("mmap of memfd failed at %p", p);
 
 	area_alias = mmap(p_alias, bytes, PROT_READ | PROT_WRITE, MAP_SHARED,
-			  shm_fd, offset);
+			  mem_fd, offset);
 	if (area_alias == MAP_FAILED)
 		err("mmap of memfd alias failed");
 	if (test_collapse && area_alias != p_alias)
@@ -1841,21 +1825,17 @@ int main(int argc, char **argv)
 	}
 	nr_pages = nr_pages_per_cpu * nr_cpus;
 
-	if (test_type == TEST_HUGETLB && map_shared) {
-		if (argc < 5)
-			usage();
-		huge_fd = open(argv[4], O_CREAT | O_RDWR, 0755);
-		if (huge_fd < 0)
-			err("Open of %s failed", argv[4]);
-		if (ftruncate(huge_fd, 0))
-			err("ftruncate %s to size 0 failed", argv[4]);
-	} else if (test_type == TEST_SHMEM) {
-		shm_fd = memfd_create(argv[0], 0);
-		if (shm_fd < 0)
+	if (test_type == TEST_SHMEM || test_type == TEST_HUGETLB) {
+		unsigned int memfd_flags = 0;
+
+		if (test_type == TEST_HUGETLB)
+			memfd_flags = MFD_HUGETLB;
+		mem_fd = memfd_create(argv[0], memfd_flags);
+		if (mem_fd < 0)
 			err("memfd_create");
-		if (ftruncate(shm_fd, nr_pages * page_size * 2))
+		if (ftruncate(mem_fd, nr_pages * page_size * 2))
 			err("ftruncate");
-		if (fallocate(shm_fd,
+		if (fallocate(mem_fd,
 			      FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE, 0,
 			      nr_pages * page_size * 2))
 			err("fallocate");
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-always-compile-in-pte-markers.patch
mm-use-pte-markers-for-swap-errors.patch

