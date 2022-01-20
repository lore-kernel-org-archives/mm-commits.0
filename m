Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85C8AC433EF
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:27:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377864AbiATV1B (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:27:01 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:37542 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377863AbiATV07 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:26:59 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8304F60018
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:26:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB568C340E0;
        Thu, 20 Jan 2022 21:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642714019;
        bh=FEF9PC3HCm1P11flCoWxcDhyRDfhiC6j+1FLJvpYhJU=;
        h=Date:From:To:Subject:From;
        b=WzDnzF+Uulz+FxKO3WK0axORJ6vSDg9qcy4LiooWpXqLKVKlE4kgnEwlnGxF/bgi4
         XJYfDO4SrF+SOrs4py1rb+helw3APY6G9WFnvC5w9zfbYbkUQZInaJbM7qYMNwHlZY
         LdKueepuppsGwypFIg/ZyGkpzzw8qukO6TrUVid4=
Date:   Thu, 20 Jan 2022 13:26:58 -0800
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, almasrymina@google.com,
        axelrasmussen@google.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, peterx@redhat.com, shuah@kernel.org
Subject:  [merged]
 userfaultfd-selftests-clean-up-hugetlb-allocation-code.patch removed from
 -mm tree
Message-ID: <20220120212658.fgi07PyV7%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd/selftests: clean up hugetlb allocation code
has been removed from the -mm tree.  Its filename was
     userfaultfd-selftests-clean-up-hugetlb-allocation-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: userfaultfd/selftests: clean up hugetlb allocation code

The message for commit f5c73297181c ("userfaultfd/selftests: fix hugetlb
area allocations") says there is no need to create a hugetlb file in the
non-shared testing case.  However, the commit did not actually change the
code to prevent creation of the file.

While it is technically true that there is no need to create and use a
hugetlb file in the case of non-shared-testing, it is useful.  This is
because 'hole punching' of a hugetlb file has the potentially incorrect
side effect of also removing pages from private mappings.  The userfaultfd
test relies on this side effect for removing pages from the destination
buffer during rounds of stress testing.

Remove the incomplete code that was added to deal with no hugetlb file. 
Just keep the code that prevents reserves from being created for the
destination area.

Link: https://lkml.kernel.org/r/20220104021729.111006-1-mike.kravetz@oracle.com
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/userfaultfd.c |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

--- a/tools/testing/selftests/vm/userfaultfd.c~userfaultfd-selftests-clean-up-hugetlb-allocation-code
+++ a/tools/testing/selftests/vm/userfaultfd.c
@@ -87,7 +87,7 @@ static bool test_uffdio_minor = false;
 
 static bool map_shared;
 static int shm_fd;
-static int huge_fd = -1;	/* only used for hugetlb_shared test */
+static int huge_fd;
 static char *huge_fd_off0;
 static unsigned long long *count_verify;
 static int uffd = -1;
@@ -223,9 +223,6 @@ static void noop_alias_mapping(__u64 *st
 
 static void hugetlb_release_pages(char *rel_area)
 {
-	if (huge_fd == -1)
-		return;
-
 	if (fallocate(huge_fd, FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE,
 		      rel_area == huge_fd_off0 ? 0 : nr_pages * page_size,
 		      nr_pages * page_size))
@@ -238,17 +235,17 @@ static void hugetlb_allocate_area(void *
 	char **alloc_area_alias;
 
 	*alloc_area = mmap(NULL, nr_pages * page_size, PROT_READ | PROT_WRITE,
-			   map_shared ? MAP_SHARED :
-			   MAP_PRIVATE | MAP_HUGETLB |
+			   (map_shared ? MAP_SHARED : MAP_PRIVATE) |
+			   MAP_HUGETLB |
 			   (*alloc_area == area_src ? 0 : MAP_NORESERVE),
-			   huge_fd,
-			   *alloc_area == area_src ? 0 : nr_pages * page_size);
+			   huge_fd, *alloc_area == area_src ? 0 :
+			   nr_pages * page_size);
 	if (*alloc_area == MAP_FAILED)
 		err("mmap of hugetlbfs file failed");
 
 	if (map_shared) {
 		area_alias = mmap(NULL, nr_pages * page_size, PROT_READ | PROT_WRITE,
-				  MAP_SHARED,
+				  MAP_SHARED | MAP_HUGETLB,
 				  huge_fd, *alloc_area == area_src ? 0 :
 				  nr_pages * page_size);
 		if (area_alias == MAP_FAILED)
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are


