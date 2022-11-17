Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D961C4332F
	for <mm-commits@archiver.kernel.org>; Thu, 17 Nov 2022 22:07:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234954AbiKQWHc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 17 Nov 2022 17:07:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241388AbiKQWHO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 17 Nov 2022 17:07:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D359173B94
        for <mm-commits@vger.kernel.org>; Thu, 17 Nov 2022 14:07:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7003A62251
        for <mm-commits@vger.kernel.org>; Thu, 17 Nov 2022 22:07:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB663C433D6;
        Thu, 17 Nov 2022 22:07:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668722824;
        bh=KzvFtj7p1ik2Xi2WTZhHmbv1RYSuUXpXGeVMbpTDi8g=;
        h=Date:To:From:Subject:From;
        b=bQqprvfma+vM7eJtxZhyrj1HrTNlGu3UOq3kzTMmtY3NWyJqwv7daqcId074bDXql
         6AhEPXDG1u0k9xobia6mpH850hqlJ8T27B5+obYcqGQICkyfXIpX9LIFXd6iU5h3sr
         J6dr/pS/3ZPxyiLq516kGXRL06roiKrX7vgcwgsc=
Date:   Thu, 17 Nov 2022 14:07:04 -0800
To:     mm-commits@vger.kernel.org, jsavitz@redhat.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-vm-use-memfd-for-hugepage-mmap-test.patch added to mm-unstable branch
Message-Id: <20221117220704.CB663C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/vm: use memfd for hugepage-mmap test
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-vm-use-memfd-for-hugepage-mmap-test.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-vm-use-memfd-for-hugepage-mmap-test.patch

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
mm-always-compile-in-pte-markers.patch
mm-use-pte-markers-for-swap-errors.patch
mm-uffd-sanity-check-write-bit-for-uffd-wp-protected-ptes.patch
selftests-vm-use-memfd-for-hugepage-mmap-test.patch

