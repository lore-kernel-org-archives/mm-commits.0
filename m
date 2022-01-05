Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D488BC433EF
	for <mm-commits@archiver.kernel.org>; Wed,  5 Jan 2022 23:57:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245580AbiAEX5n (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Jan 2022 18:57:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235323AbiAEX5m (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Jan 2022 18:57:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EB9EC061245
        for <mm-commits@vger.kernel.org>; Wed,  5 Jan 2022 15:57:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 55FE2B817FD
        for <mm-commits@vger.kernel.org>; Wed,  5 Jan 2022 23:57:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC1E0C36AEB;
        Wed,  5 Jan 2022 23:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1641427060;
        bh=fV0dnnalMtr45HgO6mVspKehJkNcWBlCFni/NxQVUOE=;
        h=Date:From:To:Subject:From;
        b=Zv4vaJcR2myQN3tN3D5AhYdS0YkiIVkcPnrcLdMp8GZu1rj/+AgU3eq3ZxIWkOKUQ
         cAZy10H5l6r2qi6N9OgXEnwr7cd2lzQ+C5AEmeXHp9AMLyygQjefU4dqzMCv0AWOkb
         rZqaBK5jn2W6yQMISdlRxMMrVK8UBLc1+CD7WoV0=
Date:   Wed, 05 Jan 2022 15:57:39 -0800
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, almasrymina@google.com,
        axelrasmussen@google.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, peterx@redhat.com, shuah@kernel.org
Subject:  +
 userfaultfd-selftests-clean-up-hugetlb-allocation-code.patch added to -mm
 tree
Message-ID: <20220105235739.4UjVAvKmD%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd/selftests: clean up hugetlb allocation code
has been added to the -mm tree.  Its filename is
     userfaultfd-selftests-clean-up-hugetlb-allocation-code.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/userfaultfd-selftests-clean-up-hugetlb-allocation-code.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/userfaultfd-selftests-clean-up-hugetlb-allocation-code.patch

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

userfaultfd-selftests-clean-up-hugetlb-allocation-code.patch

