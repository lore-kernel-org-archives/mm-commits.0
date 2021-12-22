Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1E42C433EF
	for <mm-commits@archiver.kernel.org>; Wed, 22 Dec 2021 01:17:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230433AbhLVBRd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 21 Dec 2021 20:17:33 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:48444 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240557AbhLVBRc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 21 Dec 2021 20:17:32 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 263C6CE19F3
        for <mm-commits@vger.kernel.org>; Wed, 22 Dec 2021 01:17:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECFDBC36AE9;
        Wed, 22 Dec 2021 01:17:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1640135849;
        bh=h8I9NMOQCjECkeyCLWcKsVt1p+KSz+lAPk15uGTed4A=;
        h=Date:From:To:Subject:From;
        b=mflhENNZgGOqfaxn0SiA6pIn0upys6WLi9KUvOc2fs5XusvCD5UhjfQmVoCXWlI5x
         1UIM2K91Ty/81eNK/+6B84hUTMo6lNvaFV7RSihJ9494bBACXEcscfaRvP8GZJfcCK
         +mUhlig7PnTsgGw90jF2/dDZkul82ND8MU/Sl5jY=
Date:   Tue, 21 Dec 2021 17:17:28 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, shuah@kernel.org, peterx@redhat.com,
        axelrasmussen@google.com, almasrymina@google.com,
        aarcange@redhat.com, mike.kravetz@oracle.com
Subject:  + userfaultfd-selftests-fix-hugetlb-area-allocations.patch
 added to -mm tree
Message-ID: <20211222011728.bQAjh%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd/selftests: fix hugetlb area allocations
has been added to the -mm tree.  Its filename is
     userfaultfd-selftests-fix-hugetlb-area-allocations.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/userfaultfd-selftests-fix-hugetlb-area-allocations.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/userfaultfd-selftests-fix-hugetlb-area-allocations.patch

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
Subject: userfaultfd/selftests: fix hugetlb area allocations

Currently, userfaultfd selftest for hugetlb as run from run_vmtests.sh or
any environment where there are 'just enough' hugetlb pages will always
fail with:

testing events (fork, remap, remove):
		ERROR: UFFDIO_COPY error: -12 (errno=12, line=616)

The ENOMEM error code implies there are not enough hugetlb pages. 
However, there are free hugetlb pages but they are all reserved.  There is
a basic problem with the way the test allocates hugetlb pages which has
existed since the test was originally written.  Due to the way 'cleanup'
was done between different phases of the test, this issue was masked until
recently.  The issue was uncovered by commit 8ba6e8640844
("userfaultfd/selftests: reinitialize test context in each test").

For the hugetlb test, src and dst areas are allocated as PRIVATE mappings
of a hugetlb file.  This means that at mmap time, pages are reserved for
the src and dst areas.  At the start of event testing (and other tests)
the src area is populated which results in allocation of huge pages to
fill the area and consumption of reserves associated with the area.  Then,
a child is forked to fault in the dst area.  Note that the dst area was
allocated in the parent and hence the parent owns the reserves associated
with the mapping.  The child has normal access to the dst area, but can
not use the reserves created/owned by the parent.  Thus, if there are no
other huge pages available allocation of a page for the dst by the child
will fail.

Fix by not creating reserves for the dst area.  In this way the child can
use free (non-reserved) pages.

Also, MAP_PRIVATE of a file only makes sense if you are interested in the
contents of the file before making a COW copy.  The test does not do this.
So, just use MAP_ANONYMOUS | MAP_HUGETLB to create an anonymous hugetlb
mapping.  There is no need to create a hugetlb file in the non-shared
case.

Link: https://lkml.kernel.org/r/20211217172919.7861-1-mike.kravetz@oracle.com
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/userfaultfd.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

--- a/tools/testing/selftests/vm/userfaultfd.c~userfaultfd-selftests-fix-hugetlb-area-allocations
+++ a/tools/testing/selftests/vm/userfaultfd.c
@@ -87,7 +87,7 @@ static bool test_uffdio_minor = false;
 
 static bool map_shared;
 static int shm_fd;
-static int huge_fd;
+static int huge_fd = -1;	/* only used for hugetlb_shared test */
 static char *huge_fd_off0;
 static unsigned long long *count_verify;
 static int uffd = -1;
@@ -223,6 +223,9 @@ static void noop_alias_mapping(__u64 *st
 
 static void hugetlb_release_pages(char *rel_area)
 {
+	if (huge_fd == -1)
+		return;
+
 	if (fallocate(huge_fd, FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE,
 		      rel_area == huge_fd_off0 ? 0 : nr_pages * page_size,
 		      nr_pages * page_size))
@@ -235,16 +238,17 @@ static void hugetlb_allocate_area(void *
 	char **alloc_area_alias;
 
 	*alloc_area = mmap(NULL, nr_pages * page_size, PROT_READ | PROT_WRITE,
-			   (map_shared ? MAP_SHARED : MAP_PRIVATE) |
-			   MAP_HUGETLB,
-			   huge_fd, *alloc_area == area_src ? 0 :
-			   nr_pages * page_size);
+			   map_shared ? MAP_SHARED :
+			   MAP_PRIVATE | MAP_HUGETLB |
+			   (*alloc_area == area_src ? 0 : MAP_NORESERVE),
+			   huge_fd,
+			   *alloc_area == area_src ? 0 : nr_pages * page_size);
 	if (*alloc_area == MAP_FAILED)
 		err("mmap of hugetlbfs file failed");
 
 	if (map_shared) {
 		area_alias = mmap(NULL, nr_pages * page_size, PROT_READ | PROT_WRITE,
-				  MAP_SHARED | MAP_HUGETLB,
+				  MAP_SHARED,
 				  huge_fd, *alloc_area == area_src ? 0 :
 				  nr_pages * page_size);
 		if (area_alias == MAP_FAILED)
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are

userfaultfd-selftests-fix-hugetlb-area-allocations.patch

