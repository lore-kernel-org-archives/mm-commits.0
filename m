Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99DD4C433F5
	for <mm-commits@archiver.kernel.org>; Tue,  1 Feb 2022 21:30:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230238AbiBAVak (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 1 Feb 2022 16:30:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231310AbiBAVaj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 1 Feb 2022 16:30:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6E42C061714
        for <mm-commits@vger.kernel.org>; Tue,  1 Feb 2022 13:30:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 766D76178E
        for <mm-commits@vger.kernel.org>; Tue,  1 Feb 2022 21:30:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB3A0C340EC;
        Tue,  1 Feb 2022 21:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643751038;
        bh=+0PzXJPCunMj2NWqZxFTnFuvknhj92pKsNobe9F6R+I=;
        h=Date:To:From:Subject:From;
        b=fhZ0vQTM/MKAlP/T+9WGvOdz/kGGmBtRS4MHA8AWQ6+VRRf3XSw8GmOolw5qtKdWe
         ppVksv89srBNcR/3l1T3OpKzLeadOKW38TjqH3tWNDM86xndFtOnZvmTQ8LgrrYQK4
         VYy1kryiD2H43pdNgy4qID0dsN3dPCNFnWX8o0j8=
Received: by hp1 (sSMTP sendmail emulation); Tue, 01 Feb 2022 13:30:37 -0800
Date:   Tue, 01 Feb 2022 13:30:37 -0800
To:     mm-commits@vger.kernel.org, yosryahmed@google.com,
        songmuchun@bytedance.com, skhan@linuxfoundation.org,
        almasrymina@google.com, mike.kravetz@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-vm-cleanup-hugetlb-file-after-mremap-test.patch added to -mm tree
Message-Id: <20220201213037.AB3A0C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/vm: cleanup hugetlb file after mremap test
has been added to the -mm tree.  Its filename is
     selftests-vm-cleanup-hugetlb-file-after-mremap-test.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/selftests-vm-cleanup-hugetlb-file-after-mremap-test.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/selftests-vm-cleanup-hugetlb-file-after-mremap-test.patch

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
Cc: Mina Almasry <almasrymina@google.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Cc: Muchun Song <songmuchun@bytedance.com>
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

selftests-vm-cleanup-hugetlb-file-after-mremap-test.patch

