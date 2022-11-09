Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1853C433FE
	for <mm-commits@archiver.kernel.org>; Wed,  9 Nov 2022 01:38:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229898AbiKIBiP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Nov 2022 20:38:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229891AbiKIBiI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Nov 2022 20:38:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7D64606AF
        for <mm-commits@vger.kernel.org>; Tue,  8 Nov 2022 17:38:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 84C4B6181A
        for <mm-commits@vger.kernel.org>; Wed,  9 Nov 2022 01:38:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E01D6C433C1;
        Wed,  9 Nov 2022 01:38:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667957887;
        bh=8p2A7AhewYjS0+14/mYV+fT/Mv6wR6OU3t6p4jvRAoU=;
        h=Date:To:From:Subject:From;
        b=WJZqMmxlfgASCiSQfJNi90FtT9xxQN2IvtvgN4sgbI7Uz+DvWybUGJTbjiRgq5bru
         lG2WeFv3KgN7PlwOJoXVlPDbHn3dpRuZGXI+oh494dAl+TwWaOifvjbVMp4yeUhRaF
         K8N5lq/8uP6Drj9/o2bKfIxO7biMWyEpMCDZUZOw=
Date:   Tue, 08 Nov 2022 17:38:06 -0800
To:     mm-commits@vger.kernel.org, mike.kravetz@oracle.com,
        axelrasmussen@google.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-vm-use-memfd-for-hugetlb-madvise-test.patch removed from -mm tree
Message-Id: <20221109013806.E01D6C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests/vm: use memfd for hugetlb-madvise test
has been removed from the -mm tree.  Its filename was
     selftests-vm-use-memfd-for-hugetlb-madvise-test.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-always-compile-in-pte-markers.patch
mm-use-pte-markers-for-swap-errors.patch

