Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9957C433F5
	for <mm-commits@archiver.kernel.org>; Wed, 16 Feb 2022 01:06:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245251AbiBPBGc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Feb 2022 20:06:32 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245255AbiBPBG2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 15 Feb 2022 20:06:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E311F540A
        for <mm-commits@vger.kernel.org>; Tue, 15 Feb 2022 17:06:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 955F861028
        for <mm-commits@vger.kernel.org>; Wed, 16 Feb 2022 01:06:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3192C340ED;
        Wed, 16 Feb 2022 01:06:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1644973576;
        bh=TDLdqRuQD7nH8PoM3WgBc90UAB5HvFaMzD9pjA786ns=;
        h=Date:To:From:Subject:From;
        b=FPJYLv5lZ9SUy8trAXaEFyoyV/sBWNnrVDVtEO3/ZKZcvU4q2anIsQz7OrgK9o1er
         aY/A/qF9seNK1O/uD/kA9CSa2ooCPRQoBXHEJHWf/Kpi90+kR03y8jGHnuG6OdFDIy
         AwahXpYtLdQOtbm69MSk4ZIGSErEuMVJVP1M+fz4=
Date:   Tue, 15 Feb 2022 17:06:15 -0800
To:     mm-commits@vger.kernel.org, skhan@linuxfoundation.org,
        rppt@kernel.org, peterx@redhat.com, naoya.horiguchi@linux.dev,
        mhocko@suse.com, david@redhat.com, axelrasmussen@google.com,
        almasrymina@google.com, aarcange@redhat.com,
        mike.kravetz@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + userfaultfd-selftests-enable-hugetlb-remap-and-remove-event-testing.patch added to -mm tree
Message-Id: <20220216010615.E3192C340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd/selftests: enable hugetlb remap and remove event testing
has been added to the -mm tree.  Its filename is
     userfaultfd-selftests-enable-hugetlb-remap-and-remove-event-testing.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/userfaultfd-selftests-enable-hugetlb-remap-and-remove-event-testing.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/userfaultfd-selftests-enable-hugetlb-remap-and-remove-event-testing.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: userfaultfd/selftests: enable hugetlb remap and remove event testing

With MADV_DONTNEED support added to hugetlb mappings, mremap testing can
also be enabled for hugetlb.

Modify the tests to use madvise MADV_DONTNEED and MADV_REMOVE instead of
fallocate hole puch for releasing hugetlb pages.

Link: https://lkml.kernel.org/r/20220215002348.128823-4-mike.kravetz@oracle.com
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Naoya Horiguchi <naoya.horiguchi@linux.dev>
Cc: Peter Xu <peterx@redhat.com>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/run_vmtests.sh |    3 
 tools/testing/selftests/vm/userfaultfd.c  |   69 ++++++++++----------
 2 files changed, 36 insertions(+), 36 deletions(-)

--- a/tools/testing/selftests/vm/run_vmtests.sh~userfaultfd-selftests-enable-hugetlb-remap-and-remove-event-testing
+++ a/tools/testing/selftests/vm/run_vmtests.sh
@@ -208,14 +208,13 @@ echo "running userfaultfd_hugetlb"
 echo "---------------------------"
 # Test requires source and destination huge pages.  Size of source
 # (half_ufd_size_MB) is passed as argument to test.
-./userfaultfd hugetlb $half_ufd_size_MB 32 $mnt/ufd_test_file
+./userfaultfd hugetlb $half_ufd_size_MB 32
 if [ $? -ne 0 ]; then
 	echo "[FAIL]"
 	exitcode=1
 else
 	echo "[PASS]"
 fi
-rm -f $mnt/ufd_test_file
 
 echo "-------------------------"
 echo "running userfaultfd_shmem"
--- a/tools/testing/selftests/vm/userfaultfd.c~userfaultfd-selftests-enable-hugetlb-remap-and-remove-event-testing
+++ a/tools/testing/selftests/vm/userfaultfd.c
@@ -88,7 +88,6 @@ static bool test_uffdio_minor = false;
 static bool map_shared;
 static int shm_fd;
 static int huge_fd;
-static char *huge_fd_off0;
 static unsigned long long *count_verify;
 static int uffd = -1;
 static int uffd_flags, finished, *pipefd;
@@ -124,9 +123,9 @@ const char *examples =
     "./userfaultfd anon 100 99999\n\n"
     "# Run share memory test on 1GiB region with 99 bounces:\n"
     "./userfaultfd shmem 1000 99\n\n"
-    "# Run hugetlb memory test on 256MiB region with 50 bounces (using /dev/hugepages/hugefile):\n"
-    "./userfaultfd hugetlb 256 50 /dev/hugepages/hugefile\n\n"
-    "# Run the same hugetlb test but using shmem:\n"
+    "# Run hugetlb memory test on 256MiB region with 50 bounces:\n"
+    "./userfaultfd hugetlb 256 50\n\n"
+    "# Run the same hugetlb test but using shared file:\n"
     "./userfaultfd hugetlb_shared 256 50 /dev/hugepages/hugefile\n\n"
     "# 10MiB-~6GiB 999 bounces anonymous test, "
     "continue forever unless an error triggers\n"
@@ -223,10 +222,13 @@ static void noop_alias_mapping(__u64 *st
 
 static void hugetlb_release_pages(char *rel_area)
 {
-	if (fallocate(huge_fd, FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE,
-		      rel_area == huge_fd_off0 ? 0 : nr_pages * page_size,
-		      nr_pages * page_size))
-		err("fallocate() failed");
+	if (!map_shared) {
+		if (madvise(rel_area, nr_pages * page_size, MADV_DONTNEED))
+			err("madvise(MADV_DONTNEED) failed");
+	} else {
+		if (madvise(rel_area, nr_pages * page_size, MADV_REMOVE))
+			err("madvise(MADV_REMOVE) failed");
+	}
 }
 
 static void hugetlb_allocate_area(void **alloc_area)
@@ -234,26 +236,37 @@ static void hugetlb_allocate_area(void *
 	void *area_alias = NULL;
 	char **alloc_area_alias;
 
-	*alloc_area = mmap(NULL, nr_pages * page_size, PROT_READ | PROT_WRITE,
-			   (map_shared ? MAP_SHARED : MAP_PRIVATE) |
-			   MAP_HUGETLB |
-			   (*alloc_area == area_src ? 0 : MAP_NORESERVE),
-			   huge_fd, *alloc_area == area_src ? 0 :
-			   nr_pages * page_size);
+	if (!map_shared)
+		*alloc_area = mmap(NULL,
+			nr_pages * page_size,
+			PROT_READ | PROT_WRITE,
+			MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB |
+				(*alloc_area == area_src ? 0 : MAP_NORESERVE),
+			-1,
+			0);
+	else
+		*alloc_area = mmap(NULL,
+			nr_pages * page_size,
+			PROT_READ | PROT_WRITE,
+			MAP_SHARED |
+				(*alloc_area == area_src ? 0 : MAP_NORESERVE),
+			huge_fd,
+			*alloc_area == area_src ? 0 : nr_pages * page_size);
 	if (*alloc_area == MAP_FAILED)
 		err("mmap of hugetlbfs file failed");
 
 	if (map_shared) {
-		area_alias = mmap(NULL, nr_pages * page_size, PROT_READ | PROT_WRITE,
-				  MAP_SHARED | MAP_HUGETLB,
-				  huge_fd, *alloc_area == area_src ? 0 :
-				  nr_pages * page_size);
+		area_alias = mmap(NULL,
+			nr_pages * page_size,
+			PROT_READ | PROT_WRITE,
+			MAP_SHARED,
+			huge_fd,
+			*alloc_area == area_src ? 0 : nr_pages * page_size);
 		if (area_alias == MAP_FAILED)
 			err("mmap of hugetlb file alias failed");
 	}
 
 	if (*alloc_area == area_src) {
-		huge_fd_off0 = *alloc_area;
 		alloc_area_alias = &area_src_alias;
 	} else {
 		alloc_area_alias = &area_dst_alias;
@@ -266,12 +279,7 @@ static void hugetlb_alias_mapping(__u64
 {
 	if (!map_shared)
 		return;
-	/*
-	 * We can't zap just the pagetable with hugetlbfs because
-	 * MADV_DONTEED won't work. So exercise -EEXIST on a alias
-	 * mapping where the pagetables are not established initially,
-	 * this way we'll exercise the -EEXEC at the fs level.
-	 */
+
 	*start = (unsigned long) area_dst_alias + offset;
 }
 
@@ -424,7 +432,6 @@ static void uffd_test_ctx_clear(void)
 		uffd = -1;
 	}
 
-	huge_fd_off0 = NULL;
 	munmap_area((void **)&area_src);
 	munmap_area((void **)&area_src_alias);
 	munmap_area((void **)&area_dst);
@@ -922,10 +929,7 @@ static int faulting_process(int signal_t
 	struct sigaction act;
 	unsigned long signalled = 0;
 
-	if (test_type != TEST_HUGETLB)
-		split_nr_pages = (nr_pages + 1) / 2;
-	else
-		split_nr_pages = nr_pages;
+	split_nr_pages = (nr_pages + 1) / 2;
 
 	if (signal_test) {
 		sigbuf = &jbuf;
@@ -982,9 +986,6 @@ static int faulting_process(int signal_t
 	if (signal_test)
 		return signalled != split_nr_pages;
 
-	if (test_type == TEST_HUGETLB)
-		return 0;
-
 	area_dst = mremap(area_dst, nr_pages * page_size,  nr_pages * page_size,
 			  MREMAP_MAYMOVE | MREMAP_FIXED, area_src);
 	if (area_dst == MAP_FAILED)
@@ -1672,7 +1673,7 @@ int main(int argc, char **argv)
 	}
 	nr_pages = nr_pages_per_cpu * nr_cpus;
 
-	if (test_type == TEST_HUGETLB) {
+	if (test_type == TEST_HUGETLB && map_shared) {
 		if (argc < 5)
 			usage();
 		huge_fd = open(argv[4], O_CREAT | O_RDWR, 0755);
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are

selftests-vm-cleanup-hugetlb-file-after-mremap-test.patch
mm-enable-madv_dontneed-for-hugetlb-mappings.patch
selftests-vm-add-hugetlb-madvise-madv_dontneed-madv_remove-test.patch
userfaultfd-selftests-enable-hugetlb-remap-and-remove-event-testing.patch

