Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13D27C433EF
	for <mm-commits@archiver.kernel.org>; Sun,  6 Mar 2022 22:08:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233586AbiCFWJo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 6 Mar 2022 17:09:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229812AbiCFWJn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 6 Mar 2022 17:09:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0218722BD6
        for <mm-commits@vger.kernel.org>; Sun,  6 Mar 2022 14:08:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 771B560F4A
        for <mm-commits@vger.kernel.org>; Sun,  6 Mar 2022 22:08:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6E37C340EC;
        Sun,  6 Mar 2022 22:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646604529;
        bh=EhqSpVIG3v2u6EigKWIorIVqmF5qEBdNajHHE/DMmr4=;
        h=Date:To:From:Subject:From;
        b=BNhBx2nqq9iUw9qZl3BJikx3/9ybH96DXHj761IF1M3owaKFp0aSY/S3fyUduSvqU
         HR52A5v7bLGmaji7DakLn8JwTvf4OKZm+sgDkIOiD+47Qv6S2iI00yNitIq7uzeVhd
         XCUR1u1be+h1hEn3OmYf3+bJSwU7JcAJuPnkdBBk=
Date:   Sun, 06 Mar 2022 14:08:49 -0800
To:     mm-commits@vger.kernel.org, yosryahmed@google.com,
        songmuchun@bytedance.com, skhan@linuxfoundation.org,
        almasrymina@google.com, mike.kravetz@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] selftests-vm-cleanup-hugetlb-file-after-mremap-test.patch removed from -mm tree
Message-Id: <20220306220849.C6E37C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/vm: cleanup hugetlb file after mremap test
has been removed from the -mm tree.  Its filename was
     selftests-vm-cleanup-hugetlb-file-after-mremap-test.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: selftests/vm: cleanup hugetlb file after mremap test

The hugepage-mremap test will create a file in a hugetlb filesystem.  In a
default 'run_vmtests' run, the file will contain all the hugetlb pages. 
After the test, the file remains and there are no free hugetlb pages for
subsequent tests.  This causes those hugetlb tests to fail.

Change hugepage-mremap to take the name of the hugetlb file as an
argument.  Unlink the file within the test, and just to be sure remove the
file in the run_vmtests script.

Link: https://lkml.kernel.org/r/20220201033459.156944-1-mike.kravetz@oracle.com
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Shuah Khan <skhan@linuxfoundation.org>
Acked-by: Yosry Ahmed <yosryahmed@google.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Mina Almasry <almasrymina@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/hugepage-mremap.c |   26 ++++++++++++-----
 tools/testing/selftests/vm/run_vmtests.sh    |    3 +
 2 files changed, 21 insertions(+), 8 deletions(-)

--- a/tools/testing/selftests/vm/hugepage-mremap.c~selftests-vm-cleanup-hugetlb-file-after-mremap-test
+++ a/tools/testing/selftests/vm/hugepage-mremap.c
@@ -3,9 +3,10 @@
  * hugepage-mremap:
  *
  * Example of remapping huge page memory in a user application using the
- * mremap system call.  Code assumes a hugetlbfs filesystem is mounted
- * at './huge'.  The amount of memory used by this test is decided by a command
- * line argument in MBs. If missing, the default amount is 10MB.
+ * mremap system call.  The path to a file in a hugetlbfs filesystem must
+ * be passed as the last argument to this test.  The amount of memory used
+ * by this test in MBs can optionally be passed as an argument.  If no memory
+ * amount is passed, the default amount is 10MB.
  *
  * To make sure the test triggers pmd sharing and goes through the 'unshare'
  * path in the mremap code use 1GB (1024) or more.
@@ -25,7 +26,6 @@
 #define DEFAULT_LENGTH_MB 10UL
 #define MB_TO_BYTES(x) (x * 1024 * 1024)
 
-#define FILE_NAME "huge/hugepagefile"
 #define PROTECTION (PROT_READ | PROT_WRITE | PROT_EXEC)
 #define FLAGS (MAP_SHARED | MAP_ANONYMOUS)
 
@@ -107,17 +107,26 @@ static void register_region_with_uffd(ch
 
 int main(int argc, char *argv[])
 {
+	size_t length;
+
+	if (argc != 2 && argc != 3) {
+		printf("Usage: %s [length_in_MB] <hugetlb_file>\n", argv[0]);
+		exit(1);
+	}
+
 	/* Read memory length as the first arg if valid, otherwise fallback to
-	 * the default length. Any additional args are ignored.
+	 * the default length.
 	 */
-	size_t length = argc > 1 ? (size_t)atoi(argv[1]) : 0UL;
+	if (argc == 3)
+		length = argc > 2 ? (size_t)atoi(argv[1]) : 0UL;
 
 	length = length > 0 ? length : DEFAULT_LENGTH_MB;
 	length = MB_TO_BYTES(length);
 
 	int ret = 0;
 
-	int fd = open(FILE_NAME, O_CREAT | O_RDWR, 0755);
+	/* last arg is the hugetlb file name */
+	int fd = open(argv[argc-1], O_CREAT | O_RDWR, 0755);
 
 	if (fd < 0) {
 		perror("Open failed");
@@ -169,5 +178,8 @@ int main(int argc, char *argv[])
 
 	munmap(addr, length);
 
+	close(fd);
+	unlink(argv[argc-1]);
+
 	return ret;
 }
--- a/tools/testing/selftests/vm/run_vmtests.sh~selftests-vm-cleanup-hugetlb-file-after-mremap-test
+++ a/tools/testing/selftests/vm/run_vmtests.sh
@@ -111,13 +111,14 @@ fi
 echo "-----------------------"
 echo "running hugepage-mremap"
 echo "-----------------------"
-./hugepage-mremap 256
+./hugepage-mremap $mnt/huge_mremap
 if [ $? -ne 0 ]; then
 	echo "[FAIL]"
 	exitcode=1
 else
 	echo "[PASS]"
 fi
+rm -f $mnt/huge_mremap
 
 echo "NOTE: The above hugetlb tests provide minimal coverage.  Use"
 echo "      https://github.com/libhugetlbfs/libhugetlbfs.git for"
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are

hugetlb-clean-up-potential-spectre-issue-warnings.patch
hugetlb-clean-up-potential-spectre-issue-warnings-v2.patch
mm-enable-madv_dontneed-for-hugetlb-mappings.patch
selftests-vm-add-hugetlb-madvise-madv_dontneed-madv_remove-test.patch
userfaultfd-selftests-enable-hugetlb-remap-and-remove-event-testing.patch

