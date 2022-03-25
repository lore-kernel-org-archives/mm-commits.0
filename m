Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA9B4C43217
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:13:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354887AbiCYBPE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:15:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357212AbiCYBPC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:15:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F4253A5F2
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:13:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AF9C461808
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:13:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13069C340ED;
        Fri, 25 Mar 2022 01:13:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648170805;
        bh=rfN1nHjKzfHH67M3jNByMPkyR4JgA99Q+b3GyNICGtQ=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=PBXC1v9DoPhlxL2uws9MhpfRYXuSGgZ2X5AywhPhW51U5Dr1x7z9lS/AtZ/CIxj8N
         WubQZZjqW38aAVq86UZAwcsMEfZaezMe7oxch9rsJaKVY0KymGz6iVcHfsCds1u3LX
         kLqxISB19LQHx82nsNZoPP/Fx/3FFc0vNysX+BN0=
Date:   Thu, 24 Mar 2022 18:13:24 -0700
To:     skhan@linuxfoundation.org, rppt@kernel.org, peterx@redhat.com,
        naoya.horiguchi@linux.dev, mhocko@suse.com, david@redhat.com,
        axelrasmussen@google.com, almasrymina@google.com,
        aarcange@redhat.com, mike.kravetz@oracle.com,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220324180758.96b1ac7e17675d6bc474485e@linux-foundation.org>
Subject: [patch 097/114] userfaultfd/selftests: enable hugetlb remap and remove event testing
Message-Id: <20220325011325.13069C340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
@@ -89,7 +89,6 @@ static bool test_uffdio_minor = false;
 static bool map_shared;
 static int shm_fd;
 static int huge_fd;
-static char *huge_fd_off0;
 static unsigned long long *count_verify;
 static int uffd = -1;
 static int uffd_flags, finished, *pipefd;
@@ -128,9 +127,9 @@ const char *examples =
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
@@ -227,10 +226,13 @@ static void noop_alias_mapping(__u64 *st
 
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
@@ -238,26 +240,37 @@ static void hugetlb_allocate_area(void *
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
@@ -270,12 +283,7 @@ static void hugetlb_alias_mapping(__u64
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
 
@@ -428,7 +436,6 @@ static void uffd_test_ctx_clear(void)
 		uffd = -1;
 	}
 
-	huge_fd_off0 = NULL;
 	munmap_area((void **)&area_src);
 	munmap_area((void **)&area_src_alias);
 	munmap_area((void **)&area_dst);
@@ -926,10 +933,7 @@ static int faulting_process(int signal_t
 	struct sigaction act;
 	unsigned long signalled = 0;
 
-	if (test_type != TEST_HUGETLB)
-		split_nr_pages = (nr_pages + 1) / 2;
-	else
-		split_nr_pages = nr_pages;
+	split_nr_pages = (nr_pages + 1) / 2;
 
 	if (signal_test) {
 		sigbuf = &jbuf;
@@ -986,9 +990,6 @@ static int faulting_process(int signal_t
 	if (signal_test)
 		return signalled != split_nr_pages;
 
-	if (test_type == TEST_HUGETLB)
-		return 0;
-
 	area_dst = mremap(area_dst, nr_pages * page_size,  nr_pages * page_size,
 			  MREMAP_MAYMOVE | MREMAP_FIXED, area_src);
 	if (area_dst == MAP_FAILED)
@@ -1676,7 +1677,7 @@ int main(int argc, char **argv)
 	}
 	nr_pages = nr_pages_per_cpu * nr_cpus;
 
-	if (test_type == TEST_HUGETLB) {
+	if (test_type == TEST_HUGETLB && map_shared) {
 		if (argc < 5)
 			usage();
 		huge_fd = open(argv[4], O_CREAT | O_RDWR, 0755);
_
