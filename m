Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3BE0C43217
	for <mm-commits@archiver.kernel.org>; Mon, 17 Oct 2022 00:34:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbiJQAeS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 16 Oct 2022 20:34:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229962AbiJQAeO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 16 Oct 2022 20:34:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3D622F385
        for <mm-commits@vger.kernel.org>; Sun, 16 Oct 2022 17:34:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 372CEB80DAC
        for <mm-commits@vger.kernel.org>; Mon, 17 Oct 2022 00:34:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE390C433C1;
        Mon, 17 Oct 2022 00:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1665966850;
        bh=PehkZcDAxjF5lB1z03jlv/SDBbellLa9qLIIqV1X7Es=;
        h=Date:To:From:Subject:From;
        b=XPJifPicAzmmo143gCHFXT20YC+0jA4/BkWY+tVOBYyp+BCS6LTbfllftRquastgk
         U17BbfLGpOaJ3dcCeWcXcfs+DUE9L78bI6u+lLwY1fwL+CJP6nrEMd3IWbtfeFsOop
         4XN9+CYrnCEwGsaPz0Gs9xREE8UBA2okIQcXNaJg=
Date:   Sun, 16 Oct 2022 17:34:09 -0700
To:     mm-commits@vger.kernel.org, mike.kravetz@oracle.com,
        axelrasmussen@google.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-vm-use-memfd-for-hugetlb-madvise-test.patch added to mm-unstable branch
Message-Id: <20221017003409.DE390C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/vm: use memfd for hugetlb-madvise test
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-vm-use-memfd-for-hugetlb-madvise-test.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-vm-use-memfd-for-hugetlb-madvise-test.patch

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
Subject: selftests/vm: use memfd for hugetlb-madvise test
Date: Fri, 14 Oct 2022 10:39:19 -0400

For dropping the hugetlb mountpoint in run_vmtests.sh.  Since no parameter
is needed, drop USAGE too.

Link: https://lkml.kernel.org/r/20221014143921.93887-3-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/hugetlb-madvise.c |   12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

--- a/tools/testing/selftests/vm/hugetlb-madvise.c~selftests-vm-use-memfd-for-hugetlb-madvise-test
+++ a/tools/testing/selftests/vm/hugetlb-madvise.c
@@ -12,6 +12,7 @@
  * directory.
  */
 
+#define _GNU_SOURCE
 #include <stdlib.h>
 #include <stdio.h>
 #include <unistd.h>
@@ -19,7 +20,6 @@
 #define __USE_GNU
 #include <fcntl.h>
 
-#define USAGE	"USAGE: %s <hugepagefile_name>\n"
 #define MIN_FREE_PAGES	20
 #define NR_HUGE_PAGES	10	/* common number of pages to map/allocate */
 
@@ -103,11 +103,6 @@ int main(int argc, char **argv)
 	int fd;
 	int ret;
 
-	if (argc != 2) {
-		printf(USAGE, argv[0]);
-		exit(1);
-	}
-
 	huge_page_size = default_huge_page_size();
 	if (!huge_page_size) {
 		printf("Unable to determine huge page size, exiting!\n");
@@ -125,9 +120,9 @@ int main(int argc, char **argv)
 		exit(1);
 	}
 
-	fd = open(argv[1], O_CREAT | O_RDWR, 0755);
+	fd = memfd_create(argv[0], MFD_HUGETLB);
 	if (fd < 0) {
-		perror("Open failed");
+		perror("memfd_create() failed");
 		exit(1);
 	}
 
@@ -406,6 +401,5 @@ int main(int argc, char **argv)
 	(void)munmap(addr2, NR_HUGE_PAGES * huge_page_size);
 
 	close(fd);
-	unlink(argv[1]);
 	return 0;
 }
_

Patches currently in -mm which might be from peterx@redhat.com are

selftests-vm-use-memfd-for-uffd-hugetlb-tests.patch
selftests-vm-use-memfd-for-hugetlb-madvise-test.patch
selftests-vm-use-memfd-for-hugepage-mremap-test.patch
selftests-vm-drop-mnt-point-for-hugetlb-in-run_vmtestssh.patch

