Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CCDDC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 15 Oct 2021 20:18:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6832B611C2
	for <mm-commits@archiver.kernel.org>; Fri, 15 Oct 2021 20:18:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238469AbhJOUUc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 15 Oct 2021 16:20:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:57836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234408AbhJOUUb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 15 Oct 2021 16:20:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B65756105A;
        Fri, 15 Oct 2021 20:18:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634329105;
        bh=lzEYVWveB4StggNE8KccHjY5KHSva7XeieCC98Rz2Kc=;
        h=Date:From:To:Subject:From;
        b=YXRRigabzDaNNAyl6hdLbMVY8AYt7h3rX27I2KhK4qULy7oGe4IDyx/it5BKuP81Q
         7tZjoeXIwj2vflEKVve/dvNjJJP+YnBQbhcTu8PHIppXJe2vM54NtIricYniiBo3gz
         yuu4/UcXiB73FfmOH38B12K8n/Sxvmm2zbWtlXZs=
Date:   Fri, 15 Oct 2021 13:18:24 -0700
From:   akpm@linux-foundation.org
To:     almasrymina@google.com, ckennelly@google.com, kenchen@google.com,
        kirill@shutemov.name, mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, vbabka@suse.cz
Subject:  + mm-hugepages-add-hugetlb-vma-mremap-test-v8.patch added
 to -mm tree
Message-ID: <20211015201824.0zdj7BWIV%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-hugepages-add-hugetlb-vma-mremap-test-v8
has been added to the -mm tree.  Its filename is
     mm-hugepages-add-hugetlb-vma-mremap-test-v8.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-hugepages-add-hugetlb-vma-mremap-test-v8.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-hugepages-add-hugetlb-vma-mremap-test-v8.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mina Almasry <almasrymina@google.com>
Subject: mm-hugepages-add-hugetlb-vma-mremap-test-v8

Link: https://lkml.kernel.org/r/20211014200542.4126947-2-almasrymina@google.com
Signed-off-by: Mina Almasry <almasrymina@google.com>
Acked-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Ken Chen <kenchen@google.com>
Cc: Chris Kennelly <ckennelly@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Kirill Shutemov <kirill@shutemov.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/hugepage-mremap.c |   10 +++-------
 tools/testing/selftests/vm/run_vmtests.sh    |   11 +++++++++++
 2 files changed, 14 insertions(+), 7 deletions(-)

--- a/tools/testing/selftests/vm/hugepage-mremap.c~mm-hugepages-add-hugetlb-vma-mremap-test-v8
+++ a/tools/testing/selftests/vm/hugepage-mremap.c
@@ -3,12 +3,8 @@
  * hugepage-mremap:
  *
  * Example of remapping huge page memory in a user application using the
- * mremap system call.  Before running this application, make sure that the
- * administrator has mounted the hugetlbfs filesystem (on some directory
- * like /mnt) using the command mount -t hugetlbfs nodev /mnt. In this
- * example, the app is requesting memory of size 10MB that is backed by
- * huge pages.
- *
+ * mremap system call.  Code assumes a hugetlbfs filesystem is mounted
+ * at './huge'.  The code will use 10MB worth of huge pages.
  */
 
 #define _GNU_SOURCE
@@ -109,7 +105,7 @@ int main(void)
 {
 	int ret = 0;
 
-	int fd = open("/mnt/huge/test", O_CREAT | O_RDWR, 0755);
+	int fd = open("/huge/test", O_CREAT | O_RDWR, 0755);
 
 	if (fd < 0) {
 		perror("Open failed");
--- a/tools/testing/selftests/vm/run_vmtests.sh~mm-hugepages-add-hugetlb-vma-mremap-test-v8
+++ a/tools/testing/selftests/vm/run_vmtests.sh
@@ -108,6 +108,17 @@ else
 	echo "[PASS]"
 fi
 
+echo "-----------------------"
+echo "running hugepage-mremap"
+echo "-----------------------"
+./hugepage-mremap
+if [ $? -ne 0 ]; then
+	echo "[FAIL]"
+	exitcode=1
+else
+	echo "[PASS]"
+fi
+
 echo "NOTE: The above hugetlb tests provide minimal coverage.  Use"
 echo "      https://github.com/libhugetlbfs/libhugetlbfs.git for"
 echo "      hugetlb regression testing."
_

Patches currently in -mm which might be from almasrymina@google.com are

mm-hugepages-add-mremap-support-for-hugepage-backed-vma.patch
mm-hugepages-add-hugetlb-vma-mremap-test.patch
mm-hugepages-add-hugetlb-vma-mremap-test-v8.patch

