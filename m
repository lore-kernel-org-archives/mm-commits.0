Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 919B9C433EF
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 18:41:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6AE5B61186
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 18:41:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232258AbhKESog (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 14:44:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:51332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231904AbhKESog (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 14:44:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0B5CC60D07;
        Fri,  5 Nov 2021 18:41:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636137716;
        bh=OC+NPmCqLfJ8Cxsby1kiaAaUl9RSLECfIGJmiiAKlfU=;
        h=Date:From:To:Subject:From;
        b=bGYcigahkLtCPwZv6hlP+ZYO6sWebm3izjCuA5ikZSz/ZG0xQ3QiY+xvf6KyI98z+
         Ie2p9Kfq/8BTVIOczE2JGYqceF24bOLJnMQno9roXQB5UH53pSex7OTiXNlq96W7x9
         j+naoVinmtghfHTxKgYD1SX2yCwOe4BhQK5SvChQ=
Date:   Fri, 05 Nov 2021 11:41:55 -0700
From:   akpm@linux-foundation.org
To:     almasrymina@google.com, ckennelly@google.com, kenchen@google.com,
        kirill@shutemov.name, mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, vbabka@suse.cz
Subject:  [folded-merged]
 mm-hugepages-add-hugetlb-vma-mremap-test-v8.patch removed from -mm tree
Message-ID: <20211105184155.1W9OouGHS%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-hugepages-add-hugetlb-vma-mremap-test-v8
has been removed from the -mm tree.  Its filename was
     mm-hugepages-add-hugetlb-vma-mremap-test-v8.patch

This patch was dropped because it was folded into mm-hugepages-add-hugetlb-vma-mremap-test.patch

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

