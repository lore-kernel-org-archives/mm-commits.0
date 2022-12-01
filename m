Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 293C8C4321E
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 00:08:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230390AbiLAAIe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 19:08:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230284AbiLAAGd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 19:06:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5C4138B
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 16:02:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A686DB81D81
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 00:02:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AD84C433B5;
        Thu,  1 Dec 2022 00:02:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669852951;
        bh=1d84yOi2DbsAQB3q552+xyfX3AkxDOawP0cfXoMFC5M=;
        h=Date:To:From:Subject:From;
        b=sSAUDVOOUgVKhjIgsMZWxILObfAmTCnv1N+Q8ZHfExWsYyi3VNlo5PMkLUh5QKVK6
         2oeDTt4QSMYpwlno7C0bx4wZqVsPdTivutBV//Y02IxgHRZcdBeq/4xo/qWXB4d1qq
         eZ2H8t7AnR33PTE6ZU3m3wybg4sebwd7RCDRpw8U=
Date:   Wed, 30 Nov 2022 16:02:30 -0800
To:     mm-commits@vger.kernel.org, jsavitz@redhat.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-vm-use-memfd-for-hugepage-mmap-test.patch removed from -mm tree
Message-Id: <20221201000231.4AD84C433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests/vm: use memfd for hugepage-mmap test
has been removed from the -mm tree.  Its filename was
     selftests-vm-use-memfd-for-hugepage-mmap-test.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: selftests/vm: use memfd for hugepage-mmap test
Date: Thu, 17 Nov 2022 16:29:15 -0500

This test was overlooked with a hard-coded mntpoint path in test when
we're removing the hugetlb mntpoint in commit 0796c7b8be84.  Fix it up so
the test can keep running.

Link: https://lkml.kernel.org/r/Y3aojfUC2nSwbCzB@x1n
Fixes: 0796c7b8be84 ("selftests/vm: drop mnt point for hugetlb in run_vmtests.sh")
Signed-off-by: Peter Xu <peterx@redhat.com>
Reported-by: Joel Savitz <jsavitz@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/hugepage-mmap.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/tools/testing/selftests/vm/hugepage-mmap.c~selftests-vm-use-memfd-for-hugepage-mmap-test
+++ a/tools/testing/selftests/vm/hugepage-mmap.c
@@ -16,14 +16,13 @@
  * range.
  * Other architectures, such as ppc64, i386 or x86_64 are not so constrained.
  */
-
+#define _GNU_SOURCE
 #include <stdlib.h>
 #include <stdio.h>
 #include <unistd.h>
 #include <sys/mman.h>
 #include <fcntl.h>
 
-#define FILE_NAME "huge/hugepagefile"
 #define LENGTH (256UL*1024*1024)
 #define PROTECTION (PROT_READ | PROT_WRITE)
 
@@ -67,16 +66,16 @@ int main(void)
 	void *addr;
 	int fd, ret;
 
-	fd = open(FILE_NAME, O_CREAT | O_RDWR, 0755);
+	fd = memfd_create("hugepage-mmap", MFD_HUGETLB);
 	if (fd < 0) {
-		perror("Open failed");
+		perror("memfd_create() failed");
 		exit(1);
 	}
 
 	addr = mmap(ADDR, LENGTH, PROTECTION, FLAGS, fd, 0);
 	if (addr == MAP_FAILED) {
 		perror("mmap");
-		unlink(FILE_NAME);
+		close(fd);
 		exit(1);
 	}
 
@@ -87,7 +86,6 @@ int main(void)
 
 	munmap(addr, LENGTH);
 	close(fd);
-	unlink(FILE_NAME);
 
 	return ret;
 }
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-migrate-fix-read-only-page-got-writable-when-recover-pte.patch
mm-hugetlb-let-vma_offset_start-to-return-start.patch
mm-hugetlb-dont-wait-for-migration-entry-during-follow-page.patch
mm-hugetlb-document-huge_pte_offset-usage.patch
mm-hugetlb-move-swap-entry-handling-into-vma-lock-when-faulted.patch
mm-hugetlb-make-userfaultfd_huge_must_wait-safe-to-pmd-unshare.patch
mm-hugetlb-make-hugetlb_follow_page_mask-safe-to-pmd-unshare.patch
mm-hugetlb-make-follow_hugetlb_page-safe-to-pmd-unshare.patch
mm-hugetlb-make-walk_hugetlb_range-safe-to-pmd-unshare.patch
mm-hugetlb-make-page_vma_mapped_walk-safe-to-pmd-unshare.patch
mm-hugetlb-introduce-hugetlb_walk.patch
mm-hugetlb-introduce-hugetlb_walk-fix.patch
mm-hugetlb-introduce-hugetlb_walk-fix-2.patch

